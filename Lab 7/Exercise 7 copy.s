			TTL CMPE-250 Exercise Seven
;****************************************************************
;(What does the program do?)
;Name:  <Chase Lewis>
;Date:  <3/1/19>
;Class:  CMPE-250
;Section:  <Section: 1, Friday, 12:00 pm>
;---------------------------------------------------------------
;Keil Template for KL46
;R. W. Melton
;February 5, 2018
;****************************************************************
;Assembler directives
            THUMB
            OPT    64  ;Turn on listing macro expansions
;****************************************************************
;Include files
            GET  MKL46Z4.s     ;Included by start.s
            OPT  1   ;Turn on listing
;****************************************************************
;EQUates
;Management record structure field displacements
IN_PTR  	EQU	 0
OUT_PTR     EQU  4
BUF_STRT    EQU  8
BUF_PAST    EQU  12
BUF_SIZE    EQU  16
NUM_ENQD    EQU  17
    
;Queue structure sizes
Q_BUF_SZ    EQU  80
Q_REC_SZ    EQU  18
MAX_STRING	EQU	 79
;---------------------------------------------------------------
;Characters
CR          EQU  0x0D
LF          EQU  0x0A
NULL        EQU  0x00
;---------------------------------------------------------------
;PORTx_PCRn (Port x pin control register n [for pin n])
;___->10-08:Pin mux control (select 0 to 8)
;Use provided PORT_PCR_MUX_SELECT_2_MASK
;---------------------------------------------------------------
;Port A
PORT_PCR_SET_PTA1_UART0_RX  EQU  (PORT_PCR_ISF_MASK :OR: \
                                  PORT_PCR_MUX_SELECT_2_MASK)
PORT_PCR_SET_PTA2_UART0_TX  EQU  (PORT_PCR_ISF_MASK :OR: \
                                  PORT_PCR_MUX_SELECT_2_MASK)
;---------------------------------------------------------------
;SIM_SCGC4
;1->10:UART0 clock gate control (enabled)
;Use provided SIM_SCGC4_UART0_MASK
;---------------------------------------------------------------
;SIM_SCGC5
;1->09:Port A clock gate control (enabled)
;Use provided SIM_SCGC5_PORTA_MASK
;---------------------------------------------------------------
;SIM_SOPT2
;01=27-26:UART0SRC=UART0 clock source select
;         (PLLFLLSEL determines MCGFLLCLK' or MCGPLLCLK/2)
; 1=   16:PLLFLLSEL=PLL/FLL clock select (MCGPLLCLK/2)
;---------------------------------------------------------------
SIM_SOPT2_UART0SRC_MCGPLLCLK  EQU  \
                                 (1 << SIM_SOPT2_UART0SRC_SHIFT)
SIM_SOPT2_UART0_MCGPLLCLK_DIV2 EQU \
    (SIM_SOPT2_UART0SRC_MCGPLLCLK :OR: SIM_SOPT2_PLLFLLSEL_MASK)
;---------------------------------------------------------------
;SIM_SOPT5
; 0->   16:UART0 open drain enable (disabled)
; 0->   02:UART0 receive data select (UART0_RX)
;00->01-00:UART0 transmit data select source (UART0_TX)
SIM_SOPT5_UART0_EXTERN_MASK_CLEAR  EQU  \
                               (SIM_SOPT5_UART0ODE_MASK :OR: \
                                SIM_SOPT5_UART0RXSRC_MASK :OR: \
                                SIM_SOPT5_UART0TXSRC_MASK)
;---------------------------------------------------------------
;UART0_BDH
;    0->  7:LIN break detect IE (disabled)
;    0->  6:RxD input active edge IE (disabled)
;    0->  5:Stop bit number select (1)
;00001->4-0:SBR[12:0] (UART0CLK / [9600 * (OSR + 1)]) 
;UART0CLK is MCGPLLCLK/2
;MCGPLLCLK is 96 MHz
;MCGPLLCLK/2 is 48 MHz
;SBR = 48 MHz / (9600 * 16) = 312.5 --> 312 = 0x138
UART0_BDH_9600  EQU  0x01
;---------------------------------------------------------------
;UART0_BDL
;26->7-0:SBR[7:0] (UART0CLK / [9600 * (OSR + 1)])
;UART0CLK is MCGPLLCLK/2
;MCGPLLCLK is 96 MHz
;MCGPLLCLK/2 is 48 MHz
;SBR = 48 MHz / (9600 * 16) = 312.5 --> 312 = 0x138
UART0_BDL_9600  EQU  0x38
;---------------------------------------------------------------
;UART0_C1
;0-->7:LOOPS=loops select (normal)
;0-->6:DOZEEN=doze enable (disabled)
;0-->5:RSRC=receiver source select (internal--no effect LOOPS=0)
;0-->4:M=9- or 8-bit mode select 
;        (1 start, 8 data [lsb first], 1 stop)
;0-->3:WAKE=receiver wakeup method select (idle)
;0-->2:IDLE=idle line type select (idle begins after start bit)
;0-->1:PE=parity enable (disabled)
;0-->0:PT=parity type (even parity--no effect PE=0)
UART0_C1_8N1  EQU  0x00
;---------------------------------------------------------------
;UART0_C2
;0-->7:TIE=transmit IE for TDRE (disabled)
;0-->6:TCIE=transmission complete IE for TC (disabled)
;0-->5:RIE=receiver IE for RDRF (disabled)
;0-->4:ILIE=idle line IE for IDLE (disabled)
;1-->3:TE=transmitter enable (enabled)
;1-->2:RE=receiver enable (enabled)
;0-->1:RWU=receiver wakeup control (normal)
;0-->0:SBK=send break (disabled, normal)
UART0_C2_T_R  EQU  (UART0_C2_TE_MASK :OR: UART0_C2_RE_MASK)
;---------------------------------------------------------------
;UART0_C3
;0-->7:R8T9=9th data bit for receiver (not used M=0)
;           10th data bit for transmitter (not used M10=0)
;0-->6:R9T8=9th data bit for transmitter (not used M=0)
;           10th data bit for receiver (not used M10=0)
;0-->5:TXDIR=UART_TX pin direction in single-wire mode
;            (no effect LOOPS=0)
;0-->4:TXINV=transmit data inversion (not inverted)
;0-->3:ORIE=overrun IE for OR (disabled)
;0-->2:NEIE=noise error IE for NF (disabled)
;0-->1:FEIE=framing error IE for FE (disabled)
;0-->0:PEIE=parity error IE for PF (disabled)
UART0_C3_NO_TXINV  EQU  0x00
;---------------------------------------------------------------
;UART0_C4
;    0-->  7:MAEN1=match address mode enable 1 (disabled)
;    0-->  6:MAEN2=match address mode enable 2 (disabled)
;    0-->  5:M10=10-bit mode select (not selected)
;01111-->4-0:OSR=over sampling ratio (16)
;               = 1 + OSR for 3 <= OSR <= 31
;               = 16 for 0 <= OSR <= 2 (invalid values)
UART0_C4_OSR_16           EQU  0x0F
UART0_C4_NO_MATCH_OSR_16  EQU  UART0_C4_OSR_16
;---------------------------------------------------------------
;UART0_C5
;  0-->  7:TDMAE=transmitter DMA enable (disabled)
;  0-->  6:Reserved; read-only; always 0
;  0-->  5:RDMAE=receiver full DMA enable (disabled)
;000-->4-2:Reserved; read-only; always 0
;  0-->  1:BOTHEDGE=both edge sampling (rising edge only)
;  0-->  0:RESYNCDIS=resynchronization disable (enabled)
UART0_C5_NO_DMA_SSR_SYNC  EQU  0x00
;---------------------------------------------------------------
;UART0_S1
;0-->7:TDRE=transmit data register empty flag; read-only
;0-->6:TC=transmission complete flag; read-only
;0-->5:RDRF=receive data register full flag; read-only
;1-->4:IDLE=idle line flag; write 1 to clear (clear)
;1-->3:OR=receiver overrun flag; write 1 to clear (clear)
;1-->2:NF=noise flag; write 1 to clear (clear)
;1-->1:FE=framing error flag; write 1 to clear (clear)
;1-->0:PF=parity error flag; write 1 to clear (clear)
UART0_S1_CLEAR_FLAGS  EQU  (UART0_S1_IDLE_MASK :OR: \
                            UART0_S1_OR_MASK :OR: \
                            UART0_S1_NF_MASK :OR: \
                            UART0_S1_FE_MASK :OR: \
                            UART0_S1_PF_MASK)
;---------------------------------------------------------------
;UART0_S2
;1-->7:LBKDIF=LIN break detect interrupt flag (clear)
;             write 1 to clear
;1-->6:RXEDGIF=RxD pin active edge interrupt flag (clear)
;              write 1 to clear
;0-->5:(reserved); read-only; always 0
;0-->4:RXINV=receive data inversion (disabled)
;0-->3:RWUID=receive wake-up idle detect
;0-->2:BRK13=break character generation length (10)
;0-->1:LBKDE=LIN break detect enable (disabled)
;0-->0:RAF=receiver active flag; read-only
UART0_S2_NO_RXINV_BRK10_NO_LBKDETECT_CLEAR_FLAGS  EQU  \
        (UART0_S2_LBKDIF_MASK :OR: UART0_S2_RXEDGIF_MASK)
;---------------------------------------------------------------
;****************************************************************
;Program
;Linker requires Reset_Handler
            AREA    MyCode,CODE,READONLY
            ENTRY
            EXPORT  Reset_Handler
            IMPORT  Startup
            ;IMPORT  LengthStringSB
Reset_Handler  PROC  {}
main
;---------------------------------------------------------------
;Mask interrupts
            CPSID   I
;KL46 system startup with 48-MHz system clock
            BL      Startup
;---------------------------------------------------------------
;>>>>> begin main program code <<<<<

			BL		Init_UART0_Polling
			BL		InitQueue
			B		Return
			BL		PutStringSB
			MOVS    R0,#0x0D
            BL      PUTCHAR
            MOVS    R0,#0x0A
            BL      PUTCHAR
            MOVS	R0,#0x3C
			BL		PUTCHAR
Return		LDR		R0,=String
			BL		PutStringSB

GOBACK		BL		GETCHAR
			CMP		R0,#'A'
			BGE		ABOVE
			B		GOBACK			
ABOVE		CMP		R0,#'Z'
			BLE		CONVERT
			CMP		R0,#'a'
			BLT		GOBACK
			B		LOWER
			
CONVERT		MOVS	R2,R0
			CMP		R0,#'D'
			BEQ		DCOM
			CMP		R0,#'E'
			BEQ		ECOM
			CMP		R0,#'H'
			BEQ		HCOM
			CMP		R0,#'S'
			BEQ		SCOM
			CMP		R0,#'P'
			BEQ		PCOM
			ADDS	R0,R0,#32

LOWER       CMP		R0,#'z'
			BGT		GOBACK
			CMP		R0,#'d'
			BEQ		DCOM
			CMP		R0,#'e'
			BEQ		ECOM
			CMP		R0,#'h'
			BEQ		HCOM
			CMP		R0,#'s'
			BEQ		SCOM
			CMP		R0,#'p'
			BEQ		PCOM
			B		GOBACK
			
			
PCOM		
ifP         CMP     R2,#'P'
            BEQ     copyP
            B       restP
copyP       MOVS	R0,R2
restP       BL      PUTCHAR
            MOVS    R0,#0x0D
            BL      PUTCHAR
            MOVS    R0,#0x0A
            BL      PUTCHAR
            MOVS    R0,#0x3E
            BL      PUTCHAR
			LDR		R1,=QRecord
			LDR		R3,[R1,#IN_PTR]
			LDR		R4,[R1,#OUT_PTR]
LoopP		LDR		R5,[R1,#OUT_PTR]
			CMP		R5,R3
			BHS		EnderP									;out_ptr < in_ptr
			LDRB	R0,[R5,#0]
			BL		PUTCHAR
			ADDS	R5,R5,#1
			STR		R5,[R1,#OUT_PTR]
			B		LoopP

EnderP		STR		R4,[R1,#OUT_PTR]						; reset out_ptr
			MOVS    R0,#0x3c
            BL      PUTCHAR
			MOVS    R0,#0x0D
            BL      PUTCHAR
            MOVS    R0,#0x0A
            BL      PUTCHAR
            B       Return 

DCOM		
ifD         CMP     R2,#'D'							;dequeue
            BEQ     copyD
            B       restD
copyD       MOVS	R0,R2
restD		BL		PUTCHAR  			
            MOVS    R0,#0x0D
            BL      PUTCHAR
            MOVS    R0,#0x0A
            BL      PUTCHAR
            BL		Dequeue 
            MOVS    R0,#0x0D
            BL      PUTCHAR
            MOVS    R0,#0x0A
            BL      PUTCHAR
            B       Return
			
ECOM		
ife         CMP     R2,#'E'								;enqueue
            BEQ     copyE
            B       restE
copyE       MOVS	R0,R2
restE       BL      PUTCHAR
            MOVS    R0,#0x0D
            BL      PUTCHAR
            MOVS    R0,#0x0A
            BL      PUTCHAR
			BL		Enqueue
            MOVS    R0,#0x0D
            BL      PUTCHAR
            MOVS    R0,#0x0A
            BL      PUTCHAR
            B       Return
			
HCOM		
ifH         CMP     R2,#'S'
            BEQ     copyH
            B       restH
copyH       MOVS	R0,R2
restH       BL      PUTCHAR
            MOVS    R0,#0x0D
            BL      PUTCHAR
            MOVS    R0,#0x0A
            BL      PUTCHAR
			LDR		R0,=Help					;print help statement
			BL		PutStringSB
			MOVS    R0,#0x0D
            BL      PUTCHAR
            MOVS    R0,#0x0A
            BL      PUTCHAR
			B		Return
SCOM      
ifS         CMP     R2,#'S'
            BEQ     copyS
            B       restS
copyS       MOVS	R0,R2
restS       BL      PUTCHAR
            MOVS    R0,#0x0D
            BL      PUTCHAR
            MOVS    R0,#0x0A
            BL      PUTCHAR
			LDR		R0,=Status
			BL		PutStringSB
			LDR		R1,=QRecord
            MOVS    R0,#0x09
            BL      PUTCHAR
            LDR     R0,=In
            BL      PutStringSB
            LDR     R4,[R1,#IN_PTR]
            MOVS    R0,R4
            BL      PutNumHex
            MOVS	R0,#0x20
			BL		PUTCHAR
            LDR     R0,=Out
            BL      PutStringSB
            LDR     R6,[R1,#OUT_PTR]
            MOVS    R0,R6
            BL      PutNumHex
			MOVS	R0,#0x20
			BL		PUTCHAR
			LDR		R0,=Num
			BL	  	PutStringSB
			LDR		R1,=QRecord
			LDRB	R0,[R1,#NUM_ENQD]
			BL		PutNumUB                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          
			
            MOVS    R0,#0x0D
            BL      PUTCHAR
            MOVS    R0,#0x0A
            BL      PUTCHAR
            B       Return





			


						
;>>>>>   end main program code <<<<<
;Stay here
            B       .
            ENDP
			LTORG
;>>>>> begin subroutine code <<<<<
;Select MCGPLLCLK / 2 as UART0 clock source
Init_UART0_Polling	PROC	{R0-R14}
			PUSH	{R1-R3}
			LDR		R1,=SIM_SOPT2
			LDR		R2,=SIM_SOPT2_UART0SRC_MASK
			LDR		R3,[R1,#0]
			BICS	R3,R3,R2
			LDR     R2,=SIM_SOPT2_UART0_MCGPLLCLK_DIV2
			ORRS    R3,R3,R2
			STR		R3,[R1,#0]
;Enable external connection for UART0
			LDR 	R1,=SIM_SOPT5
			LDR		R2,=SIM_SOPT5_UART0_EXTERN_MASK_CLEAR
			LDR   	R3,[R1,#0]     
			BICS  	R3,R3,R2
			STR   	R3,[R1,#0] 
;Enable clock for UART0 module
			LDR   	R1,=SIM_SCGC4     
			LDR     R2 ,= SIM_SCGC4_UART0_MASK     
			LDR     R3,[R1,#0]     
			ORRS    R3,R3,R2
			STR     R3,[R1 ,#0]
;Enable clock for Port A module     
			LDR     R1,=SIM_SCGC5     
			LDR     R2,= SIM_SCGC5_PORTA_MASK     
			LDR     R3,[R1,#0]     
			ORRS  	R3,R3,R2
            STR     R3,[R1,#0] 
;Connect PORT A Pin 1 (PTA1) to UART0 Rx (J1 Pin 02)     
			LDR     R1,=PORTA_PCR1     
			LDR     R2,=PORT_PCR_SET_PTA1_UART0_RX     
			STR     R2,[R1,#0] 
;Connect PORT A Pin 2 (PTA2) to UART0 Tx (J1 Pin 04)     
			LDR     R1,=PORTA_PCR2    
			LDR     R2,=PORT_PCR_SET_PTA2_UART0_TX     
			STR     R2,[R1,#0] 
;Disable UART0 receiver and transmitter 			
			LDR     R1,=UART0_BASE
			MOVS    R2,#UART0_C2_T_R
			LDRB    R3,[R1,#UART0_C2_OFFSET]
			BICS    R3,R3,R2
			STRB    R3,[R1,#UART0_C2_OFFSET]
;Set UART0 for 9600 baud, 8N1 protocol 			
			MOVS    R2,#UART0_BDH_9600
			STRB    R2,[R1,#UART0_BDH_OFFSET]
			MOVS    R2,#UART0_BDL_9600
			STRB    R2,[R1,#UART0_BDL_OFFSET]
			MOVS    R2,#UART0_C1_8N1
			STRB    R2,[R1,#UART0_C1_OFFSET]
			MOVS    R2,#UART0_C3_NO_TXINV
			STRB    R2,[R1,#UART0_C3_OFFSET]
			MOVS    R2,#UART0_C4_NO_MATCH_OSR_16
			STRB    R2,[R1,#UART0_C4_OFFSET]
			MOVS    R2,#UART0_C5_NO_DMA_SSR_SYNC
			STRB    R2,[R1,#UART0_C5_OFFSET]
			MOVS    R2,#UART0_S1_CLEAR_FLAGS
			STRB    R2,[R1,#UART0_S1_OFFSET]
			MOVS    R2,#UART0_S2_NO_RXINV_BRK10_NO_LBKDETECT_CLEAR_FLAGS
			STRB    R2,[R1,#UART0_S2_OFFSET]
;Enable UART0 receiver and transmitter 
			MOVS    R2,#UART0_C2_T_R
			STRB    R2,[R1,#UART0_C2_OFFSET]
			POP		{R1-R3}
			BX		LR
			ENDP
			
;****************************************************************	
;Subroutine for initqueue that takes in the queue record structure, the address of 
; of the structure and the and the character capcity
InitQueue	PROC	{R0-R14}
            LDR     R0,=QBuffer
            LDR     R1,=QRecord
            STR     R0,[R1,#IN_PTR]
            STR     R0,[R1,#OUT_PTR]
            STR     R0,[R1,#BUF_STRT]
            MOVS    R2,#Q_BUF_SZ
            ADDS    R0,R0,R2
            STR     R0,[R1,#BUF_PAST]
            STRB    R2,[R1,#BUF_SIZE]
            MOVS    R0,#0
            STRB    R0,[R1,#NUM_ENQD]
			BX	    LR
			ENDP
;*******************************************************
;If the queue (whose queue record structures address is in R1) is not empty, 
;dequeues  ;a character from the queue to R0 and reports success by returning with 
;the C flag ;cleared, (i.e., 0); otherwise only reports failure by returning with the 
;C flag set, (i.e., 1). 
; Input:  R1:  Address of queue record structure 
; Output:  R0:  Character dequeued 
;           PSR C flag:  Success(0) or Failure (1)
; Modify:  R0; APSR

Dequeue		PROC	{R0-R14}
			PUSH	{LR,R1-R4}
			LDR		R1,=QRecord
            LDRB    R2,[R1,#NUM_ENQD]
            CMP     R2,#0
            BLE     EMPTY									;if queue is empty 						
            LDR     R3,[R1,#OUT_PTR]						;get iten at OutPointer
            MOVS    R0,R3								
			PUSH	{R0}
            LDR     R0,=Success
            BL      PutStringSB
			POP		{R0}
            SUBS    R2,R2,#1								;number enqueued = numbered enqueued + 1
			STRB	R2,[R1,#NUM_ENQD]
            ADDS    R3,R3,#1								;out_ptr = out_ptr + 1
            STR     R3,[R1,#OUT_PTR]
            LDR     R4,[R1,#BUF_PAST]
            CMP     R3,R4
            BLT     NoAdjust
            STR     R4,[R1,#OUT_PTR]						;buf_past --> out_ptr
NoAdjust    PUSH    {R0,R1,R4-R6}     
            MRS     R0,APSR     
            MOVS    R1,#0x20								;clear c flag
			LSLS	R1,R1,#24
            BICS    R0,R0,R1    
            MSR     APSR,R0
            LDR     R5,=QRecord
            MOVS    R0,#0x09
            BL      PUTCHAR
            LDR     R0,=In
            BL      PutStringSB
            LDR     R4,[R5,#IN_PTR]
            MOVS    R0,R4
            BL      PutNumHex
            MOVS	R0,#0x20
			BL		PUTCHAR
            LDR     R0,=Out
            BL      PutStringSB
            LDR     R6,[R5,#OUT_PTR]
            MOVS    R0,R6
            BL      PutNumHex
			MOVS	R0,#0x20
			BL		PUTCHAR
			LDR		R0,=Num
			BL	  	PutStringSB
			LDR		R1,=QRecord
			LDRB	R0,[R1,#NUM_ENQD]
			BL		PutNumUB
            POP     {R0-R1,R4-R6}
			
			B		DEEND
EMPTY       PUSH    {R0,R1,R5,R6}     
           	MRS     R0,APSR     								;set c flag
            MOVS    R1,#0x20
			LSLS	R1,R1,#24
            ORRS    R0,R0,R1    
            MSR     APSR,R0            
            POP     {R1}
            LDR     R5,=QRecord
            LDR     R0,=Failure									;dequeue failed
            BL      PutStringSB
            MOVS    R0,#0x09
            BL      PUTCHAR
            LDR     R0,=In
            BL      PutStringSB
            LDR     R4,[R5,#IN_PTR]
            MOVS    R0,R4
            BL      PutNumHex
            MOVS	R0,#0x20
			BL		PUTCHAR
            LDR     R0,=Out
            BL      PutStringSB
            LDR     R6,[R5,#OUT_PTR]
            MOVS    R0,R6
            BL      PutNumHex
			MOVS	R0,#0x20
			BL		PUTCHAR
			LDR		R0,=Num
			BL	  	PutStringSB
			LDR		R1,=QRecord
			LDRB	R0,[R1,#NUM_ENQD]
			BL		PutNumUB
			POP		{R0,R5,R6}
			
DEEND		POP		{R1-R4,PC}			
			ENDP
;*************************************************
;If the queue (whose queue record structures address is in 
;R1) is not full, enqueues the character from R0 to the queue and reports success by 
;returning with the C flag cleared, (i.e., 0); otherwise only reports failure by 
;returning with the C flag set, (i.e., 1).
; Input: R1: Address of queue record structure
;	  R0: Character to enqueue
; Output: PSR C flag: Success(0) or Failure(1)
; Modify: ASPR
; All other registers remain unchanged on return

Enqueue		PROC	{R0-R14}
			PUSH	{LR,R2-R4}
			LDR		R1, =QRecord
			LDRB	R2,[R1,#NUM_ENQD]
			LDRB	R3,[R1,#BUF_SIZE]
			LDR		R4,[R1,#IN_PTR]
			LDR		R5,[R1,#BUF_PAST]
            LDR     R6,[R1,#OUT_PTR]
			CMP	    R2,R3
			BHS	    EMPTYEN
			LDR		R0,=Enq
			BL		PutStringSB	
			BL		GETCHAR
			BL		PUTCHAR
            PUSH	{R0}
			MOVS	R0,#0x20
			BL		PUTCHAR
			POP		{R0}
			STRB	R0,[R4,#0]					
			ADDS	R2,R2,#1					;INCREMENT number enqueued
			STRB	R2,[R1,#NUM_ENQD]				
			ADDS	R4,R4,#1					; in_ptr = in_ptr + 1
            STR     R4,[R1,#IN_PTR]
			CMP	    R4,R5
			BLT	    NoAdjustEN
			LDR     R4,[R1,#BUF_STRT]
NoAdjustEN  PUSH    {R0,R1}     
            MRS     R0,APSR     				;set c flag
            MOVS    R1,#0x20
			LSLS	R1,R1,#24
            BICS    R0,R0,R1    
            MSR     APSR,R0
            MOVS    R0,#0x0D
            BL      PUTCHAR
            MOVS    R0,#0x0A
            BL      PUTCHAR            				
			LDR		R0,=Success					;enqueue succeeded
			BL		PutStringSB
            MOVS    R0,#0x09
            BL      PUTCHAR
            LDR     R0,=In
            BL      PutStringSB
            MOVS    R0,R4
            BL      PutNumHex
            MOVS	R0,#0x20
			BL		PUTCHAR
            LDR     R0,=Out
            BL      PutStringSB
            MOVS    R0,R6
            BL      PutNumHex
			MOVS	R0,#0x20
			BL		PUTCHAR
			LDR		R0,=Num
			BL	  	PutStringSB
			LDR		R1,=QRecord
			LDRB	R0,[R1,#NUM_ENQD]
			BL		PutNumUB
            POP     {R0-R1}
			B		ENEND
EMPTYEN     PUSH    {R1,R0}     
           	MRS     R0,APSR     
            MOVS    R1,#0x20							;set c flag
			LSLS	R1,R1,#24
            ORRS    R0,R0,R1    
            MSR     APSR,R0
            MOVS    R0,#0x0D
            BL      PUTCHAR
            MOVS    R0,#0x0A
            BL      PUTCHAR           
            POP     {R0,R1}
			PUSH	{R0}
			LDR     R0,=Failure							; enqueue failed
            BL      PutStringSB
            MOVS    R0,#0x09
            BL      PUTCHAR
            LDR     R0,=In
            BL      PutStringSB
            MOVS    R0,R4
            BL      PutNumHex
            LDR     R0,=Out
            BL      PutStringSB
            MOVS    R0,R6
            BL      PutNumHex
			MOVS	R0,#0x20
			BL		PUTCHAR
			LDR		R0,=Num
			BL	  	PutStringSB
			LDR		R1,=QRecord
			LDRB	R0,[R1,#NUM_ENQD]
			BL		PutNumUB
			POP		{R0}
ENEND		POP		{R2-R4,PC}
			ENDP
			
;******************************************************************
;PutNumHex: Prints to the terminal screen the text hexadecimal representation of the 
;unsigned word value in R0.  

PutNumHex	PROC	{R0-R14}
			PUSH 	{R2,R3,R4,LR}
			MOVS 	R2,#32
HEX_PRINT_LOOP
			;Iterate 8 times for each digit stored in a register
			CMP 	R2,#0
			BLT 	END_PRINT_HEX
			;Shift current nibble to print to
			;the rightmost value of register
			MOVS 	R3,R0
			MOVS 	R4,#0x0F
			LSRS 	R3,R2
			ANDS 	R4,R4,R3
			;Convert to appropriate ASCII value
			CMP 	R4,#10
			BGE PRINT_LETTER        
			;If 0-9 should be printed, add ASCII '0' val
			ADDS 	R4,#'0'
			B 		PRINT_HX        
PRINT_LETTER        
			;If A-F should be printed, Add ASCII '55'
			;To convert to capital letter value
			ADDS 	R4,R4,#55        
PRINT_HX
			;Print ASCII value to the screen
			;Make sure not to destroy vlue in R0!
			PUSH 	{R0}
			MOVS 	R0,R4
			BL 		PUTCHAR
			POP 	{R0}        
			;Reset value in R3 and increment loop counter
			MOVS 	R4,#0
			SUBS 	R2,R2,#4
			B HEX_PRINT_LOOP        
END_PRINT_HEX

			POP 	{R2,R3,R4,PC}
			BX		LR
			ENDP



;*********************************************************************



;*********************************************************************
;Prints to the terminal screen the text decimal representation of the unsigned byte 
;value in R0.

PutNumUB	PROC	{R0-R14}
 	        PUSH	{R2,LR}
			LDR		R2,=0x000000FF
			ANDS	R0,R0,R2
			BL		PutNumU
			POP		{R2,PC}
			BX		LR	
			ENDP
			

		

;*********************************************************************
GETCHAR		PROC	{R0-R14}
			PUSH	{R1-R3}
			LDR		R1,=UART0_BASE
			MOVS	R2,#UART0_S1_RDRF_MASK 
PollRx		LDRB  	R3,[R1,#UART0_S1_OFFSET]
			ANDS	R3,R3,R2
			BEQ		PollRx
			LDRB	R0,[R1,#UART0_D_OFFSET]
			POP		{R1-R3}
			BX		LR
			ENDP		
;****************************************************************
PUTCHAR		PROC	{R0-R14}
			PUSH	{R1-R3}
			LDR		R1,=UART0_BASE
			MOVS	R2,#UART0_S1_TDRE_MASK 
PollTx		LDRB  	R3,[R1,#UART0_S1_OFFSET]
			ANDS	R3,R3,R2
			BEQ		PollTx
			STRB	R0,[R1,#UART0_D_OFFSET]
			POP		{R1-R3}
			BX		LR
			ENDP

;****************************************************************
GetStringSB	PROC	{R0-R14}
            PUSH    {R3-R4,LR}
			MOVS	R3,R0
			MOVS	R4,#0		
            MOVS    R1,#MAX_STRING
			SUBS	R1,R1,#1
            PUSH    {R0}
Loop		BL      GETCHAR
			CMP		R0,#0x0D
			BEQ		EXIT                       
			STRB	R0,[R3,R4]
            BL      PUTCHAR
			ADDS	R4,R4,#1
			CMP		R4,R1
			BEQ		WAIT
			
            B       Loop
            
WAIT        BL      GETCHAR
            CMP		R0,#0x0D
			BNE		WAIT
EXIT	    ;ADDS    R4,R4,#1
            MOVS    R0,#0x00
            STRB    R0,[R3,R4]
            POP     {R0}
            POP     {R3,R4,PC}
            ;BX      LR
            ENDP


;****************************************************************
PutStringSB PROC    {R0-R13}
            PUSH    {R1-R4,LR}
            MOVS    R3,R0
            MOVS    R4,#0
            PUSH    {R0}
Loop2       LDRB    R0,[R3,R4]
            CMP     R0,#0
            BEQ     EXIT2
            BL      PUTCHAR
            ADDS    R4,R4,#1
            CMP		R4,R1           
			BGE		EXIT2 
            B       Loop2
EXIT2       POP     {R0-R4,PC}
            ;BX      LR
            ENDP
            
            
;****************************************************************
PutNumU		PROC	{R1-R14}
            PUSH    {R2,LR}
            MOVS    R2,#0
NumLoop     MOVS    R1,R0
            MOVS    R0,#10
            BL      DIVU
            PUSH    {R1}
            ADDS    R2,R2,#1
iff         CMP     R0,#0
            BEQ     NumLoop2
Els         B       NumLoop
NumLoop2    CMP     R2,#0
iff2        BEQ     ENDNUM
Els2        POP     {R1}
            ADDS    R1,R1,#0x30
            SUBS    R2,R2,#1
            MOVS    R0,R1
            BL      PUTCHAR
            B       NumLoop2
ENDNUM      POP     {R2,PC}
            ENDP
            
            
;****************************************************************
DIVU		PROC	{R2-R14}		;register 2-14 are unchanged
			PUSH    {R2} 
            MOVS    R2,#0 
            CMP     R0,#0
            BEQ     SETCARRY		;if Dividend is equal to divsior set carry
			CMP		R1,#0
			BEQ		ZERO			;if divisor is equal to zero branch to ZERO
WHILE       CMP     R1,R0
            BLO     ENDWHILE    	;if diviend is less than divisor end while loop
            ADDS    R2,R2,#1    
            SUBS    R1,R1,R0    
            B       WHILE       	;branch to while loop
ENDWHILE 
CLEAR								;c flag is cleared
            MOVS    R0,R2       
      
            PUSH    {R0,R1}     
            MRS     R0,APSR     
            MOVS    R1,#0x20
			LSLS	R1,R1,#24
            BICS    R0,R0,R1    
            MSR     APSR,R0     
            POP     {R0,R1}     
			B		QUITDIV
SETCARRY    						;;c flag is set
            PUSH    {R0,R1}     
            MRS     R0,APSR     
            MOVS    R1,#0x20
			LSLS	R1,R1,#24
            ORRS    R0,R0,R1    
            MSR     APSR,R0     
            POP     {R0,R1}     
            B		QUITDIV

ZERO								;set divisor to zero
			MOVS 	R0,#0 			;sets R0=0 because R1=1, 0/X=0r0
			B		CLEAR
QUITDIV		POP		{R2}
            BX      LR
			ENDP
;>>>>>   end subroutine code <<<<<
            ALIGN
			
;****************************************************************
;Vector Table Mapped to Address 0 at Reset
;Linker requires __Vectors to be exported
            AREA    RESET, DATA, READONLY
            EXPORT  __Vectors
            EXPORT  __Vectors_End
            EXPORT  __Vectors_Size
            IMPORT  __initial_sp
            IMPORT  Dummy_Handler
            IMPORT  HardFault_Handler
__Vectors 
                                      ;ARM core vectors
            DCD    __initial_sp       ;00:end of stack
            DCD    Reset_Handler      ;01:reset vector
            DCD    Dummy_Handler      ;02:NMI
            DCD    HardFault_Handler  ;03:hard fault
            DCD    Dummy_Handler      ;04:(reserved)
            DCD    Dummy_Handler      ;05:(reserved)
            DCD    Dummy_Handler      ;06:(reserved)
            DCD    Dummy_Handler      ;07:(reserved)
            DCD    Dummy_Handler      ;08:(reserved)
            DCD    Dummy_Handler      ;09:(reserved)
            DCD    Dummy_Handler      ;10:(reserved)
            DCD    Dummy_Handler      ;11:SVCall (supervisor call)
            DCD    Dummy_Handler      ;12:(reserved)
            DCD    Dummy_Handler      ;13:(reserved)
            DCD    Dummy_Handler      ;14:PendableSrvReq (pendable request 
                                      ;   for system service)
            DCD    Dummy_Handler      ;15:SysTick (system tick timer)
            DCD    Dummy_Handler      ;16:DMA channel 0 xfer complete/error
            DCD    Dummy_Handler      ;17:DMA channel 1 xfer complete/error
            DCD    Dummy_Handler      ;18:DMA channel 2 xfer complete/error
            DCD    Dummy_Handler      ;19:DMA channel 3 xfer complete/error
            DCD    Dummy_Handler      ;20:(reserved)
            DCD    Dummy_Handler      ;21:command complete; read collision
            DCD    Dummy_Handler      ;22:low-voltage detect;
                                      ;   low-voltage warning
            DCD    Dummy_Handler      ;23:low leakage wakeup
            DCD    Dummy_Handler      ;24:I2C0
            DCD    Dummy_Handler      ;25:I2C1
            DCD    Dummy_Handler      ;26:SPI0 (all IRQ sources)
            DCD    Dummy_Handler      ;27:SPI1 (all IRQ sources)
            DCD    Dummy_Handler      ;28:UART0 (status; error)
            DCD    Dummy_Handler      ;29:UART1 (status; error)
            DCD    Dummy_Handler      ;30:UART2 (status; error)
            DCD    Dummy_Handler      ;31:ADC0
            DCD    Dummy_Handler      ;32:CMP0
            DCD    Dummy_Handler      ;33:TPM0
            DCD    Dummy_Handler      ;34:TPM1
            DCD    Dummy_Handler      ;35:TPM2
            DCD    Dummy_Handler      ;36:RTC (alarm)
            DCD    Dummy_Handler      ;37:RTC (seconds)
            DCD    Dummy_Handler      ;38:PIT (all IRQ sources)
            DCD    Dummy_Handler      ;39:I2S0
            DCD    Dummy_Handler      ;40:USB0
            DCD    Dummy_Handler      ;41:DAC0
            DCD    Dummy_Handler      ;42:TSI0
            DCD    Dummy_Handler      ;43:MCG
            DCD    Dummy_Handler      ;44:LPTMR0
            DCD    Dummy_Handler      ;45:Segment LCD
            DCD    Dummy_Handler      ;46:PORTA pin detect
            DCD    Dummy_Handler      ;47:PORTC and PORTD pin detect
__Vectors_End
__Vectors_Size  EQU     __Vectors_End - __Vectors
            ALIGN
;****************************************************************
;Constants
            AREA    MyConst,DATA,READONLY
;>>>>> begin constants here <<<<<
String		 DCB	 "Type a queue command (D,E,H,P,S):", 0
Help		 DCB	 " hi buddy: d (dequeue), e(enqueue), h(help), p(print), s(status)",0
Failure      DCB     "Failure:",0
Success      DCB     "Success:",0
Hex			 DCB	 "0x"
Enq          DCB     "Character to enqueue: ",0
In           DCB     "In=0x",0
Out          DCB     "Out=0x",0
Num			 DCB	 "Num=",0
Status       DCB     "Status:",0

;>>>>>   end constants here <<<<<
            ALIGN
;****************************************************************
;Variables
            AREA    MyData,DATA,READWRITE
;>>>>> begin variables here <<<<<
QBuffer     SPACE   Q_BUF_SZ
			ALIGN
QRecord     SPACE   Q_REC_SZ
;>>>>>   end variables here <<<<<
            ALIGN
            END			

			
			
