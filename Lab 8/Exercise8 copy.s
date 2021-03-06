;				TTL Multiprecision
;****************************************************************
;Contains subroutines for initialization, Enqueue, and dequeue of
;a Circular FIFO Queue
;Name:  Chase Lewis
;Date:  March 22, 2019 
;Class:  CMPE-250
;Section:  Section 1, 12:00 Friday.
;---------------------------------------------------------------
;Keil Template for KL46
;R. W. Melton
;September 25, 2017
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
SIM_SOPT2_UART0SRC_MCGPLLCLK  	EQU  	(1 << SIM_SOPT2_UART0SRC_SHIFT)
SIM_SOPT2_UART0_MCGPLLCLK_DIV2  EQU		(SIM_SOPT2_UART0SRC_MCGPLLCLK :OR: SIM_SOPT2_PLLFLLSEL_MASK)
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
;0x38->7-0:SBR[7:0] (UART0CLK / [9600 * (OSR + 1)])
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
UART0_S1_CLEAR_FLAGS  EQU  0x1F
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
UART0_S2_NO_RXINV_BRK10_NO_LBKDETECT_CLEAR_FLAGS  EQU  0xC0
;****************************************************************
;Program
;Linker requires Reset_Handler
            AREA    MyCode,CODE,READONLY
            ENTRY
            EXPORT  Reset_Handler
            IMPORT  Startup
			EXPORT	PutChar
            
Reset_Handler  PROC  {},{}
main
;---------------------------------------------------------------
;Mask interrupts
            CPSID   I
;KL46 system startup with 48-MHz system clock
            BL      Startup
;---------------------------------------------------------------
;>>>>> begin main program code <<<<<
			BL		Init_UART0_Polling

MainLoop	LDR		R0,=firstPrompt						;first number to add
			BL		PutString
			LDR		R0,=MultiHex
			MOVS	R1,#3
			BL		GetHexIntMulti
			BCS		InvInput1
back1		BL		NewLine
			LDR		R0,=secPrompt						;second number to add
			BL		PutString
			LDR		R0,=MultiHex2
			BL		GetHexIntMulti
			BCS		InvInput2
back2		BL		NewLine
			LDR		R0,=Sum								;sum of the two 96 bit numbers
			BL		PutString
			MOVS	R3,R1
			LDR		R0,=SUM
			LDR		R1,=MultiHex
			LDR		R2,=MultiHex2
			BL		AddIntMultiU
            BCS     OverFlow
			MOVS	R1,#3
			BL		PutHexIntMulti
			BL		NewLine
			B		MainLoop

InvInput1	BL		NewLine								; invalid input 
			LDR		R0,=Invalid
			BL		PutString
			LDR		R0,=MultiHex
			BL		GetHexIntMulti
			BCS		InvInput1
			B		back1	

InvInput2	BL		NewLine								;invalid input 
			LDR		R0,=Invalid
			BL		PutString
			LDR		R0,=MultiHex2
			BL		GetHexIntMulti
			BCS		InvInput2
			B		back2

OverFlow    LDR     R0,=Overflow						;overflow
            BL      PutString
            BL      NewLine
            B       MainLoop
;>>>>>   end main program code <<<<<

;>>>>>	 begin subroutine code <<<<<
;Title: Initialization Subroutine
;Functionality: This subroutine prepares the board for UART input and output
;With the format of a Baud rate of 9600, 8 data bits, no parity
;and 1 stop bit.
;Input: No input required
;Ouput: No output
;Register Modification List: NONE

Init_UART0_Polling  		PROC		{R0-R14}
			PUSH 		{R0-R2}

;Select MCGPLLCLK / 2 as UART0 clock source
			LDR   		R0,=SIM_SOPT2
			LDR   		R1,=SIM_SOPT2_UART0SRC_MASK
			LDR   		R2,[R0,#0]
			BICS 		R2,R2,R1
			LDR   		R1,=SIM_SOPT2_UART0_MCGPLLCLK_DIV2
			ORRS  		R2,R2,R1
			STR   		R2,[R0,#0]

;Enable external connection for UART0
			LDR   		R0,=SIM_SOPT5
			LDR   		R1,=SIM_SOPT5_UART0_EXTERN_MASK_CLEAR
			LDR   		R2,[R0,#0]
			BICS  		R2,R2,R1
			STR   		R2,[R0,#0]

;Enable clock for UART0 module
			LDR   		R0,=SIM_SCGC4
			LDR   		R1,=SIM_SCGC4_UART0_MASK
			LDR   		R2,[R0,#0]
			ORRS  		R2,R2,R1
			STR   		R2,[R0,#0]

;Enable clock for Port A module
			LDR   		R0,=SIM_SCGC5
			LDR   		R1,=SIM_SCGC5_PORTA_MASK
			LDR   		R2,[R0,#0]
			ORRS  		R2,R2,R1
			STR   		R2,[R0,#0]

;Connect PORT A Pin 1 (PTA1) to UART0 Rx (J1 Pin 02)
			LDR     	R0,=PORTA_PCR1
			LDR     	R1,=PORT_PCR_SET_PTA1_UART0_RX
			STR     	R1,[R0,#0]

;Connect PORT A Pin 2 (PTA2) to UART0 Tx (J1 Pin 04)
			LDR     	R0,=PORTA_PCR2
			LDR     	R1,=PORT_PCR_SET_PTA2_UART0_TX
			STR     	R1,[R0,#0]

;Load base address for UART0
			LDR			R0,=UART0_BASE

;Disable UART0
			MOVS   		R2,#UART0_C2_T_R
			LDRB   		R1,[R0,#UART0_C2_OFFSET]
			BICS   		R1,R1,R2
			STRB   		R1,[R0,#UART0_C2_OFFSET]
	
;Set UART0 baud rate?BDH before BDL
			MOVS  		R2,#UART0_BDH_9600
			STRB  		R2,[R0,#UART0_BDH_OFFSET]
			MOVS  		R2,#UART0_BDL_9600
			STRB 		R2,[R0,#UART0_BDL_OFFSET]

;Set UART0 character format for serial bit stream and clear flags
			MOVS  		R2,#UART0_C1_8N1
			STRB  		R2,[R0,#UART0_C1_OFFSET]
			MOVS  		R2,#UART0_C3_NO_TXINV
			STRB 		R2,[R0,#UART0_C3_OFFSET]
			MOVS  		R2,#UART0_C4_NO_MATCH_OSR_16
			STRB  		R2,[R0,#UART0_C4_OFFSET]
			MOVS  		R2,#UART0_C5_NO_DMA_SSR_SYNC
			STRB  		R2,[R0,#UART0_C5_OFFSET]
			MOVS  		R2,#UART0_S1_CLEAR_FLAGS
			STRB  		R2,[R0,#UART0_S1_OFFSET]
			MOVS  		R2, #UART0_S2_NO_RXINV_BRK10_NO_LBKDETECT_CLEAR_FLAGS
			STRB  		R2,[R0,#UART0_S2_OFFSET]

;Enable UART0
			MOVS  		R2,#UART0_C2_T_R
			STRB  		R2,[R0,#UART0_C2_OFFSET]

			POP	   		{R0-R2}
			BX	    	LR
			ENDP

;Title: PutChar Subroutine
;Functionality: outputs a character to the terminal
;Input: Character ASCII value in R0
;Output: No outputs to registers, but output to terminal
;Register Modification List: R0, stores value into UART data register
PutChar     PROC		{R0-R14}
			PUSH		{R1-R3}
			LDR			R1,=UART0_BASE
			MOVS		R3,#UART0_S1_TDRE_MASK

LoopP		LDRB		R2,[R1,#UART0_S1_OFFSET]
			ANDS		R2,R2,R3
			BEQ			LoopP
			
			STRB		R0,[R1,#UART0_D_OFFSET]
			POP			{R1-R3}
			BX			LR
			ENDP


;Title: Get Character Subroutine
;Functionality: Takes a character inputed to terminal and returns its ASCII value
;Input: Input is taken from terminal
;Output: ASCII value of input character
;Register Modification List: R0 -> ASCII value
GetChar		PROC		{R1-R14}
			PUSH		{R1-R3}
			LDR			R1,=UART0_BASE
			MOVS		R3,#UART0_S1_RDRF_MASK
	
LoopG    	LDRB		R2,[R1,#UART0_S1_OFFSET]
			ANDS		R2,R2,R3
			BEQ			LoopG
	
			LDRB		R0,[R1,#UART0_D_OFFSET]
			POP			{R1-R3}
			BX			LR
			ENDP

;DIVU SUBROUTINE
;Function: Divides the contents of Register 1 by Register 0
;Input: R1 - Dividend, R0 - Divisor
;Output: R1 - Remainder, R0 - Quotient
;Modifies: R0 + R1
                

DIVU		PROC	{R2-R14}		;Perserves Registers R2 and R3
			PUSH	{R2-R4}		;Pushes R2 and R3 onto the stack
			MOVS	R2,#0		;Initializes Quotient
			CMP		R0,#0		;Compares The divisor to 0
			BEQ		INVALID		;Branches if the divisor is 0
			CMP 	R1,#0
			BEQ		ZERO
WHILE		CMP		R1,R0		;Top of While loop 
			BLO		ENDWHILE	;Is the divisor greater than the dividend?
			SUBS	R1,R1,R0	;Dividend - Divisor = Dividend or R1-R0 => R1 
			ADDS	R2,#1		;Quotient++ or R3 + 1 => R3
			B		WHILE		;Return to top of loop

ZERO		MOVS	R0,#0
			
ENDWHILE	MRS		R3,APSR		;Resets the C Flag 
			MOVS	R4,#0x20	;"""
			LSLS	R4,R4,#24	;"""
			BICS	R3,R3,R4	;"""
			MSR		APSR,R3		;"""
INVALID    
			MOVS	R0,R2		;Moves the quotient to the correct register it should be returned in
V			POP		{R2-R4}		;Returns registers R2-R3 to their original state
			BX		LR			;Ends the Subroutine
            ENDP
            
;Get String Subroutine
;Function: Reads a string from the terminal keyboard to memory starting at the address in R0 ;and adds null termination 
;Input: R0 -> address to start the string
;R1 -> buffer capacity
;Output: String to address in R0
;Uses: GetChar, PutChar

GetString	PROC        {R1-R14}
            PUSH		{R0-R7, LR}
            
            MOVS		R3,#0			;Counter = 0
            MOVS        R6,#0x1F        ;For checking if the char is a control char
            MOVS		R2,R0			;Moves pointer to R2, since R0 is changed
            MOVS        R7,#0x7F
LoopGS		BL		    GetChar		    ;Gets first character
            CMP		    R0,R6   		;If (Character == control char):
            BLT		    CheckChar		;	branches to carriage check
            CMP         R0,R7
            BEQ         LoopGS
            BL          PutChar 
            STRB		R0,[R2,R3]		;Stores the first char
            ADDS		R3,#1			;Counter++
            CMP		    R3,R1			;If (Counter = Buffer capacity):
            BEQ		    Buffer  		;	End Loop
            B		    LoopGS	

CheckChar   CMP         R0,#0x0D        ;If a character is in the control character range of 0x00-0x1F it branches here
            BEQ         EndString       ;If that control character is a carriage return it ends if it isn't the main loop continues
            B           LoopGS

Buffer      BL          GetChar         ;If the buffer capacity is reached the program waits in this loop until the carraige return is entered
            CMP         R0,#0x0D
            BEQ         EndString
            B           Buffer
            
EndString	MOVS		R5,#0x00			    ;StrPointer = 0
            STRB		R5,[R2,R3]              ;Store null termination char
            POP		    {R0-R7,PC}
            BX		    LR
            ENDP

;Put String Subroutine
;Displays a null-terminated string from memory,
;starting at the address where R0 points, to the
;terminal screen.
;Parameters
;Input:R0 :  Pointer to source string
;Modify: APSR
;Uses:
;  PutChar

PutString	PROC        {R1-R13,LR}
            PUSH	 	{R2,LR}		    ;Preserve Registers R2 and the LR

            MOVS		R2,R0			;Load the pointer to R2
LoopPS		LDRB		R0,[R2,#0]			;Load the first character to R0
            CMP		    R0,#0			;Check if character == 0:
            BEQ		    EndIf			;	Then end
            BL		    PutChar		    ;put the current char
            ADDS		R2,#1			; Advance the pointer
            B		    LoopPS			;Branch to top of loop

EndIf       POP		    {R2,PC}
            BX		    LR
            ENDP

;PutNumU subroutine
;function: print to the terminal screen the text decimal representation of the unsigned word value ;in R0
;Input: R0 -> word value
;Output: text representation to terminal screen
;Uses: DIVU

PutNumU		PROC	    {R1-R14}
			PUSH		{R1-R3,LR}

			MOVS		R1,R0		    ;DIVU is R1 / R0 so num has to be in R1
            LDR         R2,=Temp        ;Variable that stores the digits backwards
            LDR         R3,=Temp        ;Used to hold the pointer to the start of the num for later use
            SUBS        R3,#1           ;Sets R3 = to the begginning of Temp -1
            
LoopPN		MOVS		R0,#0xA	        ;R0 is divisor 
            BL		    DIVU            ;Branches to DIVU
            ADDS	   	R1,#0x30        ;convert remainder to ascii equivalent
            STRB        R1,[R2,#0]      ;Store MSB digit
            CMP         R0,#0           ;if (quotient == 0)
            BEQ         SecondLoop      ;   End this part
            MOVS        R1,R0           ;Move quotient to divisor register
            ADDS        R2,#1           ;Advance the temp pointer
            B		    LoopPN

SecondLoop  CMP         R2,R3           ;Check if the current pointer in R2 has returned to the start of the variable
            BEQ         EndSub          ;If it does it ends the subroutine
            MOVS        R0,R2           ;Moves the pointer from R2 -> R0
            LDRB        R0,[R2,#0]      ;Loads the current pointed to value to R2
            BL          PutChar         ;Prints the character
            SUBS        R2,#1           ;Pointer--
            B           SecondLoop

EndSub      POP		    {R1-R3,PC}
            BX		    LR
            ENDP
		


;PutNumHex
;Function: subroutine prints to the terminal screen the text 
;hexadecimal representation of the unsigned word value in R0. 
;Input: R0: Unsigned Word Value to be printed
;Output: Word Value to Terminal Screen
;Registers Modified: PSR and nothing else

PutNumHex	PROC		{R0-R14}
			PUSH		{R0-R5,LR}
			
            MOVS        R5,#0x1C
			MOVS		R4,#0x7		;Initialize a counter for the loop
			MOVS		R3,R0		;Preserve the number in R3
			LDR			R1,=0xF0000000	;R1 <- Mask
HexLoop		CMP			R4,#0		;8 is the max amount of iterations
			BLT			EndHex		
            MOVS        R0,R3
			ANDS		R0,R0,R1	;AND the number and the mask
			LSRS		R0,R0,R5	;Shift the result from the AND To the LSB position	
            CMP         R0,#0xA
            BLT         Number
            ADDS        R0,R0,#0x37 ;Convert to ASCII Equivalent
NumberSkip  BL          PutChar
			LSLS		R3,R3,#4	;Shift the word value to put the next digit to be printed in the MSB spot
			SUBS		R4,R4,#1	;decrement the counter
			B			HexLoop

Number      ADDS        R0,R0,#0x30
            B           NumberSkip
            
EndHex		POP			{R0-R5,PC}
			BX			LR
			ENDP
			


;PutNumUB
;Function: Prints to the terminal screen the text decimal 
;representation of the unsigned byte value in R0.
;Input: R0: unsigned byte value
;Output: Prints the byte value to the terminal screen
;Registers Modified: PSR and nothing else

PutNumUB	PROC		{R0-R14}
			PUSH		{R0-R1,LR}
			
			MOVS		R1,#0x000000FF  ;R1 <- Mask
			ANDS		R0,R0,R1        ;R0 <- 0x000000xx
			BL			PutNumU         ;Prints xx
			
			POP			{R0-R1,PC}
			BX			LR
			ENDP
 
;NewLine
;Function: Outputs a new line without altering any registers
;Input: None
;Output: None
;Registers modified: PC

NewLine     PROC       {R0-R7}
            PUSH        {R0,LR}
            
            MOVS        R0,#0x0D    ;R0 <- Carriage Return
            BL          PutChar
            MOVS        R0,#0x0A    ;R0 <- Newline
            BL          PutChar
            
            POP         {R0,PC}
            BX          LR
            ENDP


;AddIntMultiU
;Function: Add an n-word unsigned number stored in memory
;Input: R0: address to store result
;R1: address of one of the words
;R2: address of the other word
;R3: n
;Output: C flag cleared if successful, Set otherwise
;Registers Modified: APSR

AddIntMultiU		PROC	{R0-R14}
					PUSH	{R0-R7}
					MOVS	R6,#4
					MULS	R3,R6,R3
                    SUBS  	R3,R3,#1
					;Clears the C Flag
					MRS   	R6,APSR
					MOVS  	R7,#0x20
					LSLS  	R7,R7,#24
					BICS  	R6,R6,R7
					MSR     APSR,R6
					
					
AddMainLoop		    MSR     APSR,R6
					LDRB	R4,[R1,R3]	;Load word value at current address pointer
					LDRB	R5,[R2,R3]	;""
					ADCS	R4,R4,R5	;R4 <- R4 + R5
                    MRS     R6,APSR
					STRB	R4,[R0,R3]	;R4 -> R0 address
                    LSRS    R4,R4,#8
                    CMP     R4,#1
                    BEQ     SetC
BackToAdd		    CMP		R3,#0		;Checks if max iterations is reached
					BEQ		EndMultiU
                    SUBS    R3,R3,#1
					B		AddMainLoop

SetC			    ORRS  	R6,R6,R7
                    B       BackToAdd

EndMultiU			MSR     APSR,R6
                    POP		{R0-R7}
					BX		LR
					ENDP


;GetHexIntMulti
;Function: Get an n-word unsigned number from the user typed in hexadecimal representation
;Input: R0: address to store number
;R1: n
;Output: n -signed word value starting at address in R0
;C Flag set if invalid result, C flag cleared if valid
;Register Modified: APSR
GetHexIntMulti		PROC	{R0-R14}
					PUSH	{R0-R7,LR}
					
					MOVS	R3,#8
					MULS	R1,R3,R1	;R1 <- 8 * n
					;ADDS	R1,R1,#1	;R1 <- (8*n) + 1
					BL		GetString
					MOVS	R2,#0		;initialize register that temporarily holds the word value
					MOVS	R4,#4		;shift counter, alternates between 4 and 0 
					MOVS	R6,#0       ;offset for loading
                    MOVS    R5,#0       ;offset for storing
					
					
ConvertLoop			LDRB	R3,[R0,R6]	;R3 <- Byte at R0
					CMP		R3,#0x3A	;If the byte is less than 0x3A it could be a number
					BLT		HexNumber
					CMP		R3,#0x40	;byte is not a number, so if it is over 46 it is not a valid letter either
					BGT		HexLetter
HexRep				LSLS	R3,R3,R4	;Shifts the number to the appropriate spot (1st byte loaded goes to MSB spot)
					ORRS	R2,R3,R2	;Adds this current digit to the current byte
                    ADDS    R6,R6,#1    ;Move to next memory address
					CMP		R4,#0		;if R4 is 0 it means a byte is done 
					BEQ		ResetVariables
                    MOVS    R4,#0
					B		ConvertLoop

HexNumber			CMP     R3,#0
                    BEQ     ZeroDigit
                    CMP		R3,#0x2F	;If under 2F its not a number
					BLE		Failure
					SUBS	R3,R3,#0x30	;Converts ASCII to the hexadecimal equivalent
					B		HexRep

HexLetter			CMP		R3,#0x47
					BGE		LowerHex
					SUBS	R3,R3,#0x37
					B		HexRep

LowerHex			CMP		R3,#0x60
					BLE		Failure
					CMP		R3,#0x67
					BGE		Failure
					SUBS	R3,R3,#0x57
					B		HexRep

ZeroDigit           MOVS    R3,#0
                    B       HexRep

ResetVariables		STRB	R2,[R0,R5]	;If the program is sent here it means the current byte is done, so it is stored to R0 + R5
                    ADDS    R5,R5,#1    ;Advance storage offset
					CMP     R6,R1
                    BEQ     EndGetHexIntSuc
                    MOVS    R4,#4
					MOVS	R2,#0
					B		ConvertLoop
					;Sets the C Flag if the result is invalid
Failure				MRS   	R2,APSR
					MOVS  	R3,#0x20
					LSLS  	R3,R3,#24
					ORRS  	R2,R2,R3
					MSR   	APSR,R2
					B 	  	EndGetHexInt

EndGetHexIntSuc		;Clears the C Flag
					MRS   	R6,APSR
					MOVS  	R7,#0x20
					LSLS  	R7,R7,#24
					BICS  	R6,R6,R7
					MSR     APSR,R0
EndGetHexInt		POP		{R0-R7,PC}
					ENDP
					

;PutHexIntMulti
;Function: Output an n-word unsigned number, from memory starting at the addres in R0,
;to the terminal in hexidecimal representation using 8n hex digits.
;Input: R0: addres of n-word unsigned number
;R1: n
;Output: hexadecimal representation to the terminal
;Registers Modified: PC

PutHexIntMulti		PROC		{R0-R14}
					PUSH		{R0-R7,LR}
					MOVS		R4,#4
					MOVS		R3,R0		;Preserves the address in R3 since R0 is used for PutNumHex
					MULS		R1,R4,R1	;Iteration counter increases by 4, and iterates n times so: R1 <- N*4
					MOVS		R2,#0		;Initializes iteration/displacement register
                    MOVS        R5,#24      ;Shift counter
                    MOVS        R6,#0       ;Word holder

PutHexMultiLoop		LDRB		R0,[R3,R2]	;Loads the currently pointed to word
					LSLS        R0,R0,R5
                    ORRS        R6,R0,R6
                    CMP         R5,#0
                    BEQ         FinishedWord   
                    SUBS        R5,R5,#8
BackHexMult		    ADDS		R2,#1		;advances the loop counter
					CMP			R1,R2		;Checks if n iterations has been reached
					BEQ			EndHexMulti
					B			PutHexMultiLoop


FinishedWord        MOVS        R0,R6
                    BL          PutNumHex
                    MOVS        R6,#0
                    MOVS        R5,#24
                    B           BackHexMult

EndHexMulti			POP			{R0-R7,PC}
					BX 			LR
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
firstPrompt	DCB		" Enter first 96-bit hex number:   0x",0
secPrompt	DCB		"Enter 96-bit hex number to add:   0x",0
Sum			DCB		"                           Sum:   0x",0
Invalid		DCB		"     Invalid number--try again:   0x",0
Overflow	DCB		"OVERFLOW",0
;>>>>>   end constants here <<<<<
            ALIGN
;****************************************************************
;Variables
            AREA    MyData,DATA,READWRITE
;>>>>> begin variables here <<<<<
Temp      SPACE  4
MultiHex  SPACE	 80
MultiHex2 SPACE	 80
SUM		  SPACE	 24
;>>>>>   end variables here <<<<<
            ALIGN
            END
