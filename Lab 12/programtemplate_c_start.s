


ARM Macro Assembler    Page 1 Exercise 12


    1 00000000                 TTL              Exercise 12
    2 00000000         ;*******************************************************
                       *********
    3 00000000         ;Descriptive comment header goes here.
    4 00000000         ;(What does the program do?)
    5 00000000         ;Name:  <Chase Lewis>
    6 00000000         ;Date:  <4/18/19>
    7 00000000         ;Class:  CMPE-250
    8 00000000         ;Section:  <1, Friday, 12:00>
    9 00000000         ;-------------------------------------------------------
                       --------
   10 00000000         ;Keil Template for KL46 Assembly with Keil C startup
   11 00000000         ;R. W. Melton
   12 00000000         ;November 13, 2017
   13 00000000         ;*******************************************************
                       *********
   14 00000000         ;Assembler directives
   15 00000000                 THUMB
   16 00000000                 GBLL             MIXED_ASM_C
   17 00000000 TRUE     
                       MIXED_ASM_C
                               SETL             {TRUE}
   19 00000000         ;*******************************************************
                       *********
   20 00000000         ;Include files
   21 00000000                 GET              MKL46Z4.s   ;Included by start.
                                                            s
   23 00000000         ;*******************************************************
                       *********
   24 00000000         ;EQUates
   25 00000000         
   26 00000000         ;-------------------------------------------------------
                       --------
   27 00000000         ;NVIC_ICER
   28 00000000         ;31-00:CLRENA=masks for HW IRQ sources;
   29 00000000         ;             read:   0 = unmasked;   1 = masked
   30 00000000         ;             write:  0 = no effect;  1 = mask
   31 00000000         ;12:UART0 IRQ mask
   32 00000000 00001000 
                       NVIC_ICER_UART0_MASK
                               EQU              UART0_IRQ_MASK
   33 00000000         ;-------------------------------------------------------
                       --------
   34 00000000         ;NVIC_ICPR
   35 00000000         ;31-00:CLRPEND=pending status for HW IRQ sources;
   36 00000000         ;             read:   0 = not pending;  1 = pending
   37 00000000         ;             write:  0 = no effect;
   38 00000000         ;                     1 = change status to not pending
   39 00000000         ;12:UART0 IRQ pending status
   40 00000000 00001000 
                       NVIC_ICPR_UART0_MASK
                               EQU              UART0_IRQ_MASK
   41 00000000         ;-------------------------------------------------------
                       --------
   42 00000000         ;NVIC_IPR0-NVIC_IPR7
   43 00000000         ;2-bit priority:  00 = highest; 11 = lowest
   44 00000000 00000003 
                       UART0_IRQ_PRIORITY
                               EQU              3



ARM Macro Assembler    Page 2 Exercise 12


   45 00000000 000000C0 
                       NVIC_IPR_UART0_MASK
                               EQU              (3 << UART0_PRI_POS)
   46 00000000 000000C0 
                       NVIC_IPR_UART0_PRI_3
                               EQU              (UART0_IRQ_PRIORITY << UART0_PR
I_POS)
   47 00000000         ;-------------------------------------------------------
                       --------
   48 00000000         ;NVIC_ISER
   49 00000000         ;31-00:SETENA=masks for HW IRQ sources;
   50 00000000         ;             read:   0 = masked;     1 = unmasked
   51 00000000         ;             write:  0 = no effect;  1 = unmask
   52 00000000         ;12:UART0 IRQ mask
   53 00000000 00001000 
                       NVIC_ISER_UART0_MASK
                               EQU              UART0_IRQ_MASK
   54 00000000         ;-------------------------------------------------------
                       --------
   55 00000000         ;PIT_LDVALn:  PIT load value register n
   56 00000000         ;31-00:TSV=timer start value (period in clock cycles - 1
                       )
   57 00000000         ;Clock ticks for 0.01 s at 24 MHz count rate
   58 00000000         ;0.01 s * 24,000,000 Hz = 240,000
   59 00000000         ;TSV = 240,000 - 1
   60 00000000 0003A97F 
                       PIT_LDVAL_10ms
                               EQU              239999
   61 00000000         ;-------------------------------------------------------
                       --------
   62 00000000         ;PIT_MCR:  PIT module control register
   63 00000000         ;1-->    0:FRZ=freeze (continue'/stop in debug mode)
   64 00000000         ;0-->    1:MDIS=module disable (PIT section)
   65 00000000         ;               RTI timer not affected
   66 00000000         ;               must be enabled before any other PIT set
                       up
   67 00000000 00000001 
                       PIT_MCR_EN_FRZ
                               EQU              PIT_MCR_FRZ_MASK
   68 00000000         ;-------------------------------------------------------
                       --------
   69 00000000         ;PIT_TCTRLn:  PIT timer control register n
   70 00000000         ;0-->   2:CHN=chain mode (enable)
   71 00000000         ;1-->   1:TIE=timer interrupt enable
   72 00000000         ;1-->   0:TEN=timer enable
   73 00000000 00000003 
                       PIT_TCTRL_CH_IE
                               EQU              (PIT_TCTRL_TEN_MASK :OR: PIT_TC
TRL_TIE_MASK)
   74 00000000 00000000 
                       PIT_IRQ_PRI
                               EQU              0
   75 00000000         ;-------------------------------------------------------
                       --------
   76 00000000         ;PORTx_PCRn (Port x pin control register n [for pin n])
   77 00000000         ;___->10-08:Pin mux control (select 0 to 8)
   78 00000000         ;Use provided PORT_PCR_MUX_SELECT_2_MASK
   79 00000000         ;-------------------------------------------------------
                       --------



ARM Macro Assembler    Page 3 Exercise 12


   80 00000000         ;Port A
   82 00000000 01000200 
                       PORT_PCR_SET_PTA1_UART0_RX
                               EQU              (PORT_PCR_ISF_MASK :OR:       
                             PORT_PCR_MUX_SELECT_2_MASK)
   84 00000000 01000200 
                       PORT_PCR_SET_PTA2_UART0_TX
                               EQU              (PORT_PCR_ISF_MASK :OR:       
                             PORT_PCR_MUX_SELECT_2_MASK)
   85 00000000         ;-------------------------------------------------------
                       --------
   86 00000000         ;SIM_SCGC4
   87 00000000         ;1->10:UART0 clock gate control (enabled)
   88 00000000         ;Use provided SIM_SCGC4_UART0_MASK
   89 00000000         ;-------------------------------------------------------
                       --------
   90 00000000         ;SIM_SCGC5
   91 00000000         ;1->09:Port A clock gate control (enabled)
   92 00000000         ;Use provided SIM_SCGC5_PORTA_MASK
   93 00000000         ;-------------------------------------------------------
                       --------
   94 00000000         ;SIM_SOPT2
   95 00000000         ;01=27-26:UART0SRC=UART0 clock source select
   96 00000000         ;         (PLLFLLSEL determines MCGFLLCLK' or MCGPLLCLK/
                       2)
   97 00000000         ; 1=   16:PLLFLLSEL=PLL/FLL clock select (MCGPLLCLK/2)
   99 00000000 04000000 
                       SIM_SOPT2_UART0SRC_MCGPLLCLK
                               EQU              (1 << SIM_SOPT2_UART0SRC_SHIFT)
  101 00000000 04010000 
                       SIM_SOPT2_UART0_MCGPLLCLK_DIV2
                               EQU              (SIM_SOPT2_UART0SRC_MCGPLLCLK :
OR: SIM_SOPT2_PLLFLLSEL_MASK)
  102 00000000         ;-------------------------------------------------------
                       --------
  103 00000000         ;SIM_SOPT5
  104 00000000         ; 0->   16:UART0 open drain enable (disabled)
  105 00000000         ; 0->   02:UART0 receive data select (UART0_RX)
  106 00000000         ;00->01-00:UART0 transmit data select source (UART0_TX)
  110 00000000 00010007 
                       SIM_SOPT5_UART0_EXTERN_MASK_CLEAR
                               EQU              (SIM_SOPT5_UART0ODE_MASK :OR:  
                                SIM_SOPT5_UART0RXSRC_MASK :OR:               
                   SIM_SOPT5_UART0TXSRC_MASK)
  111 00000000         ;-------------------------------------------------------
                       --------
  112 00000000         ;UART0_BDH
  113 00000000         ;    0->  7:LIN break detect IE (disabled)
  114 00000000         ;    0->  6:RxD input active edge IE (disabled)
  115 00000000         ;    0->  5:Stop bit number select (1)
  116 00000000         ;00001->4-0:SBR[12:0] (UART0CLK / [9600 * (OSR + 1)]) 
  117 00000000         ;UART0CLK is MCGPLLCLK/2
  118 00000000         ;MCGPLLCLK is 96 MHz
  119 00000000         ;MCGPLLCLK/2 is 48 MHz
  120 00000000         ;SBR = 48 MHz / (9600 * 16) = 312.5 --> 312 = 0x138
  121 00000000 00000001 
                       UART0_BDH_9600
                               EQU              0x01
  122 00000000         ;-------------------------------------------------------



ARM Macro Assembler    Page 4 Exercise 12


                       --------
  123 00000000         ;UART0_BDL
  124 00000000         ;26->7-0:SBR[7:0] (UART0CLK / [9600 * (OSR + 1)])
  125 00000000         ;UART0CLK is MCGPLLCLK/2
  126 00000000         ;MCGPLLCLK is 96 MHz
  127 00000000         ;MCGPLLCLK/2 is 48 MHz
  128 00000000         ;SBR = 48 MHz / (9600 * 16) = 312.5 --> 312 = 0x138
  129 00000000 00000038 
                       UART0_BDL_9600
                               EQU              0x38
  130 00000000         ;-------------------------------------------------------
                       --------
  131 00000000         ;UART0_C1
  132 00000000         ;0-->7:LOOPS=loops select (normal)
  133 00000000         ;0-->6:DOZEEN=doze enable (disabled)
  134 00000000         ;0-->5:RSRC=receiver source select (internal--no effect 
                       LOOPS=0)
  135 00000000         ;0-->4:M=9- or 8-bit mode select 
  136 00000000         ;        (1 start, 8 data [lsb first], 1 stop)
  137 00000000         ;0-->3:WAKE=receiver wakeup method select (idle)
  138 00000000         ;0-->2:IDLE=idle line type select (idle begins after sta
                       rt bit)
  139 00000000         ;0-->1:PE=parity enable (disabled)
  140 00000000         ;0-->0:PT=parity type (even parity--no effect PE=0)
  141 00000000 00000000 
                       UART0_C1_8N1
                               EQU              0x00
  142 00000000         ;-------------------------------------------------------
                       --------
  143 00000000         ;UART0_C2
  144 00000000         ;0-->7:TIE=transmit IE for TDRE (disabled)
  145 00000000         ;0-->6:TCIE=transmission complete IE for TC (disabled)
  146 00000000         ;0-->5:RIE=receiver IE for RDRF (disabled)
  147 00000000         ;0-->4:ILIE=idle line IE for IDLE (disabled)
  148 00000000         ;1-->3:TE=transmitter enable (enabled)
  149 00000000         ;1-->2:RE=receiver enable (enabled)
  150 00000000         ;0-->1:RWU=receiver wakeup control (normal)
  151 00000000         ;0-->0:SBK=send break (disabled, normal)
  152 00000000 0000000C 
                       UART0_C2_T_R
                               EQU              (UART0_C2_TE_MASK :OR: UART0_C2
_RE_MASK)
  153 00000000 0000002C 
                       UART0_C2_T_RI
                               EQU              (UART0_C2_RIE_MASK :OR: UART0_C
2_T_R)
  154 00000000 000000AC 
                       UART0_C2_TI_RI
                               EQU              (UART0_C2_TIE_MASK :OR: UART0_C
2_T_RI)
  155 00000000         ;-------------------------------------------------------
                       --------
  156 00000000         ;UART0_C3
  157 00000000         ;0-->7:R8T9=9th data bit for receiver (not used M=0)
  158 00000000         ;           10th data bit for transmitter (not used M10=
                       0)
  159 00000000         ;0-->6:R9T8=9th data bit for transmitter (not used M=0)
  160 00000000         ;           10th data bit for receiver (not used M10=0)
  161 00000000         ;0-->5:TXDIR=UART_TX pin direction in single-wire mode



ARM Macro Assembler    Page 5 Exercise 12


  162 00000000         ;            (no effect LOOPS=0)
  163 00000000         ;0-->4:TXINV=transmit data inversion (not inverted)
  164 00000000         ;0-->3:ORIE=overrun IE for OR (disabled)
  165 00000000         ;0-->2:NEIE=noise error IE for NF (disabled)
  166 00000000         ;0-->1:FEIE=framing error IE for FE (disabled)
  167 00000000         ;0-->0:PEIE=parity error IE for PF (disabled)
  168 00000000 00000000 
                       UART0_C3_NO_TXINV
                               EQU              0x00
  169 00000000         ;-------------------------------------------------------
                       --------
  170 00000000         ;UART0_C4
  171 00000000         ;    0-->  7:MAEN1=match address mode enable 1 (disabled
                       )
  172 00000000         ;    0-->  6:MAEN2=match address mode enable 2 (disabled
                       )
  173 00000000         ;    0-->  5:M10=10-bit mode select (not selected)
  174 00000000         ;01111-->4-0:OSR=over sampling ratio (16)
  175 00000000         ;               = 1 + OSR for 3 <= OSR <= 31
  176 00000000         ;               = 16 for 0 <= OSR <= 2 (invalid values)
  177 00000000 0000000F 
                       UART0_C4_OSR_16
                               EQU              0x0F
  178 00000000 0000000F 
                       UART0_C4_NO_MATCH_OSR_16
                               EQU              UART0_C4_OSR_16
  179 00000000         ;-------------------------------------------------------
                       --------
  180 00000000         ;UART0_C5
  181 00000000         ;  0-->  7:TDMAE=transmitter DMA enable (disabled)
  182 00000000         ;  0-->  6:Reserved; read-only; always 0
  183 00000000         ;  0-->  5:RDMAE=receiver full DMA enable (disabled)
  184 00000000         ;000-->4-2:Reserved; read-only; always 0
  185 00000000         ;  0-->  1:BOTHEDGE=both edge sampling (rising edge only
                       )
  186 00000000         ;  0-->  0:RESYNCDIS=resynchronization disable (enabled)
                       
  187 00000000 00000000 
                       UART0_C5_NO_DMA_SSR_SYNC
                               EQU              0x00
  188 00000000         ;-------------------------------------------------------
                       --------
  189 00000000         ;UART0_S1
  190 00000000         ;0-->7:TDRE=transmit data register empty flag; read-only
                       
  191 00000000         ;0-->6:TC=transmission complete flag; read-only
  192 00000000         ;0-->5:RDRF=receive data register full flag; read-only
  193 00000000         ;1-->4:IDLE=idle line flag; write 1 to clear (clear)
  194 00000000         ;1-->3:OR=receiver overrun flag; write 1 to clear (clear
                       )
  195 00000000         ;1-->2:NF=noise flag; write 1 to clear (clear)
  196 00000000         ;1-->1:FE=framing error flag; write 1 to clear (clear)
  197 00000000         ;1-->0:PF=parity error flag; write 1 to clear (clear)
  198 00000000 0000001F 
                       UART0_S1_CLEAR_FLAGS
                               EQU              0x1F
  199 00000000         ;-------------------------------------------------------
                       --------
  200 00000000         ;UART0_S2



ARM Macro Assembler    Page 6 Exercise 12


  201 00000000         ;1-->7:LBKDIF=LIN break detect interrupt flag (clear)
  202 00000000         ;             write 1 to clear
  203 00000000         ;1-->6:RXEDGIF=RxD pin active edge interrupt flag (clear
                       )
  204 00000000         ;              write 1 to clear
  205 00000000         ;0-->5:(reserved); read-only; always 0
  206 00000000         ;0-->4:RXINV=receive data inversion (disabled)
  207 00000000         ;0-->3:RWUID=receive wake-up idle detect
  208 00000000         ;0-->2:BRK13=break character generation length (10)
  209 00000000         ;0-->1:LBKDE=LIN break detect enable (disabled)
  210 00000000         ;0-->0:RAF=receiver active flag; read-only
  211 00000000 000000C0 
                       UART0_S2_NO_RXINV_BRK10_NO_LBKDETECT_CLEAR_FLAGS
                               EQU              0xC0
  212 00000000         ;-------------------------------------------------------
                       --------
  213 00000000         
  214 00000000         
  215 00000000 0000004F 
                       MAX_STRING
                               EQU              79
  216 00000000 000003E8 
                       DIV1K   EQU              0x3E8
  217 00000000 00002710 
                       DIV10K  EQU              0x2710
  218 00000000 000186A0 
                       DIV100K EQU              0x186A0
  219 00000000 000F4240 
                       DIV1M   EQU              0xF4240
  220 00000000 00000000 
                       IN_PTR  EQU              0
  221 00000000 00000004 
                       OUT_PTR EQU              4
  222 00000000 00000008 
                       BUF_STRT
                               EQU              8
  223 00000000 0000000C 
                       BUF_PAST
                               EQU              12
  224 00000000 00000010 
                       BUF_SIZE
                               EQU              16
  225 00000000 00000011 
                       NUM_ENQD
                               EQU              17
  226 00000000 00000004 
                       Q_BUF_SZ
                               EQU              4
  227 00000000 00000012 
                       Q_REC_SZ
                               EQU              18
  228 00000000 00000020 
                       RDRF_CHARSET_MASK
                               EQU              0x20
  229 00000000         ;Port D
  230 00000000 00000100 
                       PTD5_MUX_GPIO
                               EQU              (1 << PORT_PCR_MUX_SHIFT)
  232 00000000 01000100 



ARM Macro Assembler    Page 7 Exercise 12


                       SET_PTD5_GPIO
                               EQU              (PORT_PCR_ISF_MASK :OR:       
                        PTD5_MUX_GPIO)
  233 00000000         ;Port E
  234 00000000 00000100 
                       PTE29_MUX_GPIO
                               EQU              (1 << PORT_PCR_MUX_SHIFT)
  236 00000000 01000100 
                       SET_PTE29_GPIO
                               EQU              (PORT_PCR_ISF_MASK :OR:       
                        PTE29_MUX_GPIO)
  237 00000000 0000001D 
                       POS_RED EQU              29
  238 00000000 00000005 
                       POS_GREEN
                               EQU              5
  239 00000000 20000000 
                       LED_RED_MASK
                               EQU              (1 << POS_RED)
  240 00000000 00000020 
                       LED_GREEN_MASK
                               EQU              (1 << POS_GREEN)
  241 00000000 00000020 
                       LED_PORTD_MASK
                               EQU              LED_GREEN_MASK
  242 00000000 20000000 
                       LED_PORTE_MASK
                               EQU              LED_RED_MASK
  243 00000000         
  244 00000000         
  245 00000000         ;Servo position determined by duty cycle
  246 00000000         ;Create constant table for desired positions
  247 00000000         ;(duty periods in terms of clock cycles)
  248 00000000         ;*need to calibrate to servo values
  249 00000000 0000EA60 
                       PWM_PERIOD_20ms
                               EQU              60000
  250 00000000 000007D0 
                       PWM_DUTY_5
                               EQU              2000
  251 00000000 000016A8 
                       PWM_DUTY_10
                               EQU              5800
  252 00000000         
  253 00000000         ;EQUates for DAC0 lookup table
  254 00000000 00001000 
                       DAC0_STEPS
                               EQU              4096
  255 00000000 00000005 
                       SERVO_POSITIONS
                               EQU              5
  256 00000000         ;*******************************************************
                       *********
  257 00000000         ;MACROs
  258 00000000         ;*******************************************************
                       *********
  259 00000000         
  260 00000000         ;*******************************************************
                       *********



ARM Macro Assembler    Page 8 Exercise 12


  261 00000000         ;Program
  262 00000000         ;Linker requires Reset_Handler
  263 00000000                 AREA             MyCode,CODE,READONLY
  264 00000000                 EXPORT           AddIntMultiU
  265 00000000                 EXPORT           GetStringSB
  266 00000000                 EXPORT           PutStringSB
  267 00000000                 EXPORT           Init_UART0_IRQ
  268 00000000                 EXPORT           Init_PIT_IRQ
  269 00000000                 EXPORT           GetChar
  270 00000000                 EXPORT           PutChar
  271 00000000                 EXPORT           PutNumUB
  272 00000000                 EXPORT           PutNumHex
  273 00000000                 EXPORT           DAC0_table_0
  274 00000000                 EXPORT           PWM_duty_table_0
  275 00000000                 EXPORT           UART0_IRQHandler
  276 00000000                 EXPORT           PIT_IRQHandler
  277 00000000                 EXPORT           KeyPressed
  278 00000000                 EXPORT           GetCount
  279 00000000                 EXPORT           TimeStart
  280 00000000                 EXPORT           LEDSet
  281 00000000                 EXPORT           Init_LED
  282 00000000         
  283 00000000         
  284 00000000         ;-------------------------------------------
  285 00000000         KeyPressed
                               PROC             {R0-R14},{}
  286 00000000         ;checks to see if a key has been pressed
  287 00000000         ;by looking at the RDRF bit in UART0.
  288 00000000         ;if a key has been pressed, the receive register
  289 00000000         ;will be populated, and will otherwise be zero.
  290 00000000         ;If a key has been pressed, returns 1 in R0
  291 00000000         ;if a key hasnt been pressed, returns 0 in R0
  292 00000000         ;Calls:
  293 00000000         ;Input:
  294 00000000         ;Output: R0
  295 00000000         ;Reg Modifications: R0 will be 0 if key wasnt pressed, 1
                        if it was
  296 00000000         
  297 00000000 4829            LDR              R0, =RxQueueRecord
  298 00000002 7C40            LDRB             R0,[R0,#NUM_ENQD]
  299 00000004 4770            BX               LR
  300 00000006                 ENDP
  301 00000006         
  302 00000006         GetCount
  303 00000006         ;store value of word variable Count in the address in R0
                       
  304 00000006         ;Calls:
  305 00000006         ;Input:
  306 00000006         ;Output: R0
  307 00000006         ;Reg Modifications: R0 will be value of word variable Co
                       unt
  308 00000006 B402            PUSH             {R1}
  309 00000008 4928            LDR              R1,=Count
  310 0000000A 6809            LDR              R1,[R1,#0]
  311 0000000C 0008            MOVS             R0,R1
  312 0000000E BC02            POP              {R1}
  313 00000010 4770            BX               LR
  314 00000012         
  315 00000012         TimeStart



ARM Macro Assembler    Page 9 Exercise 12


                               PROC             {R0-R14},{}
  316 00000012         ;initialize Count and start timer
  317 00000012 B403            PUSH             {R0-R1}
  318 00000014         ;Initalize RunStopwatch to 1 and Count to 0
  319 00000014 4825            LDR              R0, =Count
  320 00000016 2100            MOVS             R1, #0
  321 00000018 6001            STR              R1, [R0, #0]
  322 0000001A 4825            LDR              R0, =RunStopWatch
  323 0000001C 2101            MOVS             R1, #1
  324 0000001E 7001            STRB             R1, [R0, #0]
  325 00000020 BC03            POP              {R0-R1}
  326 00000022 4770            BX               LR
  327 00000024                 ENDP
  328 00000024         
  329 00000024         Init_PIT_IRQ
                               PROC             {R0-R14},{}
  330 00000024         ;Init_PIT_IRQ: Initalize the PIT to generate an 
  331 00000024         ;interrupt every 0.01 seconds from channel 0 
  332 00000024         
  333 00000024 B672            CPSID            I
  334 00000026 B507            PUSH             {R0-R2, LR}
  335 00000028 4823            LDR              R0, =SIM_SCGC6
  336 0000002A 4924            LDR              R1, =SIM_SCGC6_PIT_MASK
  337 0000002C 6802            LDR              R2, [R0, #0] ;current SIM_SCGC6
                                                             value
  338 0000002E 430A            ORRS             R2, R2, R1  ;only PIT bit set
  339 00000030 6002            STR              R2, [R0, #0] ;update SIM_SCGC6
  340 00000032 4823            LDR              R0, =PIT_BASE ;Enable PIT timer
                                                             module
  341 00000034 4923            LDR              R1, =PIT_MCR_EN_FRZ
  342 00000036 6001            STR              R1, [R0, #PIT_MCR_OFFSET]
  343 00000038 4823            LDR              R0, =PIT_CH0_BASE
  344 0000003A 4924            LDR              R1, =PIT_LDVAL_10ms
  345 0000003C 6001            STR              R1, [R0, #PIT_LDVAL_OFFSET]
  346 0000003E 4822            LDR              R0, =PIT_CH0_BASE ;Enable PIT t
                                                            imer channel 0 for 
                                                            interrupts
  347 00000040 4920            LDR              R1, =PIT_TCTRL_TEN_MASK
  348 00000042 6882            LDR              R2, [R0, #PIT_TCTRL_OFFSET]
  349 00000044 438A            BICS             R2, R2, R1
  350 00000046 6082            STR              R2, [R0, #PIT_TCTRL_OFFSET]
  351 00000048 481F            LDR              R0, =PIT_CH0_BASE ;Enable PIT t
                                                            imer channel 0 for 
                                                            interrupts
  352 0000004A 2103            MOVS             R1, #PIT_TCTRL_CH_IE
  353 0000004C 6081            STR              R1, [R0, #PIT_TCTRL_OFFSET]
  354 0000004E         ;Unmask PIT Interrupts
  355 0000004E 4820            LDR              R0, =NVIC_ISER
  356 00000050 4920            LDR              R1, =PIT_IRQ_MASK
  357 00000052 6001            STR              R1, [R0, #0]
  358 00000054         ;Set PIT Interrupt Priority
  359 00000054 4820            LDR              R0, =PIT_IPR
  360 00000056 4917            LDR              R1, =(PIT_IRQ_PRI << PIT_PRI_PO
S)
  361 00000058 6001            STR              R1, [R0, #0]
  362 0000005A B662            CPSIE            I
  363 0000005C BD07            POP              {R0-R2, PC}
  364 0000005E                 ENDP
  365 0000005E         



ARM Macro Assembler    Page 10 Exercise 12


  366 0000005E         LEDSet  PROC             {R0-R14},{}
  367 0000005E         ;Change value of LED
  368 0000005E         ;Calls: 
  369 0000005E         ;Input: bit 0 set for green, bit 1 set for red
  370 0000005E         ;Output:
  371 0000005E         ;Reg Modifications:
  372 0000005E B407            PUSH             {R0-R2}
  373 00000060         ;addresses for green
  374 00000060 491F            LDR              R1,=FGPIOD_BASE
  375 00000062 4A20            LDR              R2,=LED_GREEN_MASK
  376 00000064         ;shift value of green to carry bit
  377 00000064 0840            LSRS             R0,R0,#1
  378 00000066         ;check if it's set
  379 00000066 D201            BCS              GRNSET
  380 00000068         ;turn off green
  381 00000068 604A            STR              R2,[R1,#GPIO_PSOR_OFFSET]
  382 0000006A E000            B                REDCHK
  383 0000006C         ;turn green on
  384 0000006C         GRNSET
  385 0000006C 608A            STR              R2,[R1,#GPIO_PCOR_OFFSET]
  386 0000006E         REDCHK
  387 0000006E         ;addresses for red
  388 0000006E 491E            LDR              R1,=FGPIOE_BASE
  389 00000070 4A1E            LDR              R2,=LED_RED_MASK
  390 00000072         ;shift value of red to carry bit
  391 00000072 0840            LSRS             R0,R0,#1
  392 00000074         ;check if set
  393 00000074 D201            BCS              REDSET
  394 00000076         ;else turn red off
  395 00000076 604A            STR              R2,[R1,#GPIO_PSOR_OFFSET]
  396 00000078 E000            B                QUITLEDSET
  397 0000007A         ;turn red on
  398 0000007A         REDSET
  399 0000007A 608A            STR              R2,[R1,#GPIO_PCOR_OFFSET]
  400 0000007C         
  401 0000007C         QUITLEDSET
  402 0000007C BC07            POP              {R0-R2}
  403 0000007E 4770            BX               LR
  404 00000080                 ENDP
  405 00000080         
  406 00000080         Init_LED
                               PROC             {R0-R14},{}
  407 00000080         ;initialize LEDs
  408 00000080 B407            PUSH             {R0,R1,R2}
  409 00000082         ;Enable clock for Port D and E modules
  410 00000082 481B            LDR              R0,=SIM_SCGC5
  412 00000084 491B            LDR              R1,=(SIM_SCGC5_PORTD_MASK :OR: 
                          SIM_SCGC5_PORTE_MASK)
  413 00000086 6802            LDR              R2,[R0,#0]
  414 00000088 430A            ORRS             R2,R2,R1
  415 0000008A 6002            STR              R2,[R0,#0]
  416 0000008C         ;select PORT E Pin 29 for GPIO to red LED
  417 0000008C 481A            LDR              R0,=PORTE_BASE
  418 0000008E 491B            LDR              R1,=SET_PTE29_GPIO
  419 00000090 6741            STR              R1,[R0,#PORTE_PCR29_OFFSET]
  420 00000092         ;select PORT E Pin 29 for GPIO to red LED
  421 00000092 481B            LDR              R0,=PORTD_BASE
  422 00000094 4919            LDR              R1,=SET_PTD5_GPIO
  423 00000096 6141            STR              R1,[R0,#PORTD_PCR5_OFFSET]



ARM Macro Assembler    Page 11 Exercise 12


  424 00000098         ;port data direction
  425 00000098 4811            LDR              R0,=FGPIOD_BASE
  426 0000009A 4912            LDR              R1,=LED_PORTD_MASK
  427 0000009C 6141            STR              R1,[R0,#GPIO_PDDR_OFFSET]
  428 0000009E 4812            LDR              R0,=FGPIOE_BASE
  429 000000A0 4912            LDR              R1,=LED_PORTE_MASK
  430 000000A2 6141            STR              R1,[R0,#GPIO_PDDR_OFFSET]
  431 000000A4 BC07            POP              {R0,R1,R2}
  432 000000A6 4770            BX               LR
  433 000000A8                 ENDP
  434 000000A8         
  435 000000A8         
  436 000000A8 00000000 
              00000000 
              00000000 
              00000000 
              4004803C 
              00800000 
              40037000 
              00000001 
              40037100 
              0003A97F 
              E000E100 
              00400000 
              E000E414 
              00000000 
              F80FF0C0 
              00000020 
              F80FF100 
              20000000 
              40048038 
              00003000 
              4004D000 
              01000100 
              4004C000         LTORG
  437 00000104         
  438 00000104         InitQueue
                               PROC             {R0-R14},{}
  439 00000104         ;Initializes the queue record structure at the 
  440 00000104         ;address in R1 for the empty queue buffer at 
  441 00000104         ;the address in R0 of size, 
  442 00000104         ;(i.e., character capacity), given in R2.
  443 00000104         ;Calls:
  444 00000104         ;Input: R0, R1, R2
  445 00000104         ;Output:  
  446 00000104         ;Register Modiciations:
  447 00000104 B50F            PUSH             {R0-R3,LR}  ;preserve register 
                                                            values      
  448 00000106 6008            STR              R0,[R1,#IN_PTR] ;sets the queue
                                                             buffer address to 
                                                            InPointer
  449 00000108 6048            STR              R0,[R1,#OUT_PTR] ;"    " "    "
                                                                "    " OutPoint
                                                            er
  450 0000010A 6088            STR              R0,[R1,#BUF_STRT] ;sets the buf
                                                            fer start address t
                                                            o the queue buffer 
                                                            address
  451 0000010C 2204            MOVS             R2,#Q_BUF_SZ



ARM Macro Assembler    Page 12 Exercise 12


  452 0000010E 1883            ADDS             R3,R0,R2    ;adds the buffer si
                                                            ze to the buffer st
                                                            arting address
  453 00000110 60CB            STR              R3,[R1,#BUF_PAST] ;store this n
                                                            ew address
  454 00000112 740A            STRB             R2,[R1,#BUF_SIZE] ;set the buff
                                                            er size to 4
  455 00000114 2300            MOVS             R3,#0       ;clear R3
  456 00000116 744B            STRB             R3,[R1,#NUM_ENQD] ;clear enqueu
                                                            ed number
  457 00000118 BD0F            POP              {R0-R3,PC}  ;restore register v
                                                            alues
  458 0000011A         
  459 0000011A                 ENDP
  460 0000011A         
  461 0000011A         Dequeue PROC             {R0-R14},{}
  462 0000011A         ;Attempts to get a character from the queue 
  463 0000011A         ;whose record structure?s address is in R1:  
  464 0000011A         ;if the queue is not empty, dequeues a single
  465 0000011A         ; character from the queue to R0, and returns 
  466 0000011A         ;with the PSRC bit cleared, (i.e., 0), to report 
  467 0000011A         ;dequeue success; otherwise, returns with the 
  468 0000011A         ;PSRC bit set, (i.e., 1) to report dequeue failure.
  469 0000011A         ;Inputs: R1
  470 0000011A         ;Outputs: R0, C
  471 0000011A B41E            PUSH             {R1, R2, R3, R4}
  472 0000011C 7C4B            LDRB             R3, [R1, #NUM_ENQD] ;set flag i
                                                            f no queued
  473 0000011E 2B00            CMP              R3, #0
  474 00000120 D014            BEQ              INVALID
  475 00000122 6848            LDR              R0, [R1, #OUT_PTR] ;R0 <- value
                                                            
  476 00000124 7800            LDRB             R0, [R0, #0]
  477 00000126 7C4B            LDRB             R3, [R1, #NUM_ENQD] 
                                                            ;NumEnqueued -=1
  478 00000128 1E5B            SUBS             R3, R3, #1
  479 0000012A 744B            STRB             R3, [R1, #NUM_ENQD]
  480 0000012C 684B            LDR              R3, [R1, #OUT_PTR] 
                                                            ;OutPointer +=1
  481 0000012E 1C5B            ADDS             R3, R3, #1
  482 00000130 604B            STR              R3, [R1, #OUT_PTR]
  483 00000132 68CC            LDR              R4, [R1, #BUF_PAST] ;if OutPoin
                                                            ter >= BufferPast, 
                                                            wrap,
  484 00000134 42A3            CMP              R3, R4
  485 00000136 D301            BLO              CLEARC
  486 00000138 688B            LDR              R3, [R1, #BUF_STRT] ;OutPointer
                                                             = BufferStart
  487 0000013A 604B            STR              R3, [R1, #OUT_PTR] ;wrap 
  488 0000013C         CLEARC
  489 0000013C F3EF 8100       MRS              R1, APSR    ;clears C
  490 00000140 2320            MOVS             R3, #0x20
  491 00000142 0609            LSLS             R1, R1, #24
  492 00000144 4399            BICS             R1, R1, R3
  493 00000146 F381 8800       MSR              APSR, R1
  494 0000014A E006            B                DQQUITT     ;quit
  495 0000014C         INVALID
  496 0000014C F3EF 8100       MRS              R1, APSR    ;set C
  497 00000150 2320            MOVS             R3, #0x20



ARM Macro Assembler    Page 13 Exercise 12


  498 00000152 061B            LSLS             R3, R3, #24
  499 00000154 4319            ORRS             R1, R1, R3
  500 00000156 F381 8800       MSR              APSR, R1
  501 0000015A         
  502 0000015A         DQQUITT
  503 0000015A BC1E            POP              {R1, R2, R3, R4} ;restore regis
                                                            ter values
  504 0000015C 4770            BX               LR          ;exit subroutine
  505 0000015E         
  506 0000015E                 ENDP
  507 0000015E         
  508 0000015E         Enqueue PROC             {R0-R14},{}
  509 0000015E         ;Attempts to put a character in the queue
  510 0000015E         ; whose queue record structure?s address
  511 0000015E         ; is in R1?if the queue is not full, enqueues
  512 0000015E         ; the single character from R0 to the queue, 
  513 0000015E         ;and returns with the PSRC cleared to 
  514 0000015E         ;report enqueue success; otherwise, returns 
  515 0000015E         ;with the PSRC bit set to report enqueue failure.
  516 0000015E         ;Calls:
  517 0000015E         ;Input: R0,R1
  518 0000015E         ;Output: PSR C flag flag (0 = success, 1 = failure)
  519 0000015E         ;Register Modiciations: No registers, PSR
  520 0000015E B478            PUSH             {R3-R6}     ;preserve register 
                                                            values
  521 00000160 7C4B            LDRB             R3,[R1,#NUM_ENQD] 
                                                            ;R3 <- NumEnqueued
  522 00000162 7C0C            LDRB             R4,[R1,#BUF_SIZE] 
                                                            ;R4 <- BufferSize
  523 00000164 42A3            CMP              R3,R4       ;if value >= buffer
                                                             size, go to carry
  524 00000166 D211            BHS              CARRY
  525 00000168 680D            LDR              R5,[R1,#IN_PTR] 
                                                            ;R5 <- InPointer
  526 0000016A 68CE            LDR              R6,[R1,#BUF_PAST] 
                                                            ;R6 <- BufferPast
  527 0000016C 7028            STRB             R0,[R5,#0]  ;store value at InP
                                                            ointer
  528 0000016E 1C5B            ADDS             R3,R3,#1    ;NumEnqueued += 1
  529 00000170 744B            STRB             R3,[R1,#NUM_ENQD] 
                                                            ;R3 <- NumEnqueued
  530 00000172 1C6D            ADDS             R5,R5,#1    ;InPointer += 1
  531 00000174 42B5            CMP              R5,R6       ;if Inpointer < Buf
                                                            ferPast, skip reset
                                                            
  532 00000176 D300            BLO              SKIPE
  533 00000178 688D            LDR              R5,[R1,#BUF_STRT] 
                                                            ;reset InPointer
  534 0000017A         SKIPE
  535 0000017A 600D            STR              R5,[R1,#IN_PTR] 
                                                            ;Inpointer <- R1
  536 0000017C F3EF 8300       MRS              R3,APSR     ;R3 <- APSR
  537 00000180 2420            MOVS             R4,#0x20    ;R4 <- #0x20, for l
                                                            ogic
  538 00000182 0624            LSLS             R4,R4,#24   ;shift to MSB
  539 00000184 43A3            BICS             R3,R3,R4    ;clear C
  540 00000186 F383 8800       MSR              APSR,R3
  541 0000018A E006            B                EQQUITT     ;quit
  542 0000018C         CARRY



ARM Macro Assembler    Page 14 Exercise 12


  543 0000018C F3EF 8300       MRS              R3,APSR     ;set C
  544 00000190 2420            MOVS             R4,#0x20
  545 00000192 0624            LSLS             R4,R4,#24
  546 00000194 4323            ORRS             R3,R3,R4
  547 00000196 F383 8800       MSR              APSR,R3
  548 0000019A         EQQUITT
  549 0000019A BC78            POP              {R3-R6}     ;restore register v
                                                            alues 
  550 0000019C 4770            BX               LR          ;exit subroutine
  551 0000019E         
  552 0000019E                 ENDP
  553 0000019E         
  554 0000019E         AddIntMultiU
                               PROC             {R0-R14},{}
  555 0000019E         ;Add the n-word unsigned number in memory starting 
  556 0000019E         ;at the address in R2 to the n-word unsigned number
  557 0000019E         ; in memory starting at the address in R1, and store
  558 0000019E         ; the result to memory starting at the address in R0,
  559 0000019E         ; where the value in R3 is n.  
  560 0000019E         ;If the result is a valid n-word unsigned number, 
  561 0000019E         ;it returns with the APSR C bit clear as the return code
                        for success; 
  562 0000019E         ;otherwise it returns with the APSR C bit set as the ret
                       urn code for overflow.
  563 0000019E         
  564 0000019E         ;Inputs:  R0,R1,R2,R3
  565 0000019E         ;Outputs: R0
  566 0000019E         
  567 0000019E B5FE            PUSH             {R1-R7, LR}
  568 000001A0 B403            PUSH             {R0-R1}
  569 000001A2 48C1            LDR              R0, =FLAGS  ;Initalize state of
                                                             APSR C Flag
  570 000001A4 2100            MOVS             R1, #0
  571 000001A6 7001            STRB             R1, [R0, #0]
  572 000001A8 BC03            POP              {R0-R1}
  573 000001AA 2500            MOVS             R5,#0       ;Initalize register
                                                            s
  574 000001AC 2400            MOVS             R4,#0
  575 000001AE         ADD
  576 000001AE 2B00            CMP              R3, #0
  577 000001B0 D016            BEQ              ADDEND
  578 000001B2 594E            LDR              R6, [R1, R5]
  579 000001B4 5957            LDR              R7, [R2, R5]
  580 000001B6 2C01            CMP              R4,#1       ;if there was overf
                                                            low on last additio
                                                            n
  581 000001B8 D100            BNE              SKIP
  582 000001BA 1C76            ADDS             R6,R6,#1    ;then add it to the
                                                             sum
  583 000001BC 1E5B    SKIP    SUBS             R3, R3, #1  ;decrement n      
  584 000001BE 1D2D            ADDS             R5, R5, #4  ;increment offset  
                                                                     
  585 000001C0 B420            PUSH             {R5}
  586 000001C2 1F2D            SUBS             R5, R5, #4  ;store mem address 
                                                             
  587 000001C4 F000 F819       BL               GETFLAGS    ;helper sub to set 
                                                            the APSR state
  588 000001C8 417E            ADCS             R6, R6, R7
  589 000001CA F000 F82C       BL               SETFLAGS    ;Helper sub to set 



ARM Macro Assembler    Page 15 Exercise 12


                                                            C flag
  590 000001CE 5146            STR              R6, [R0,R5]
  591 000001D0 BC20            POP              {R5}
  592 000001D2 D201            BCS              VCHK        ;check for overflow
                                                            
  593 000001D4 2400            MOVS             R4,#0
  594 000001D6 E7EA            B                ADD         ;loop
  595 000001D8         VCHK
  596 000001D8 2401            MOVS             R4,#1       ;if theres overflow
                                                            , set variable to 1
                                                            
  597 000001DA 2B00            CMP              R3, #0      ;if its the last op
                                                            eration
  598 000001DC D1E7            BNE              ADD
  599 000001DE 2001            MOVS             R0, #1      ;set overflow varia
                                                            ble to 1
  600 000001E0         ADDEND
  601 000001E0 2801            CMP              R0, #1      ;if overflow variab
                                                            le is set, quit
  602 000001E2 D100            BNE              SUCC        ;else, success! mov
                                                            e on
  603 000001E4 E008            B                QUITADDMULTIU
  604 000001E6         SUCC
  605 000001E6 B40C            PUSH             {R2,R3}     ;clear C flag and q
                                                            uit
  606 000001E8 F3EF 8200       MRS              R2, APSR
  607 000001EC 2320            MOVS             R3, #0x20
  608 000001EE 0612            LSLS             R2, R2, #24
  609 000001F0 439A            BICS             R2, R2, R3
  610 000001F2 F382 8800       MSR              APSR, R2
  611 000001F6 BC0C            POP              {R2,R3}
  612 000001F8         QUITADDMULTIU
  613 000001F8 BDFE            POP              {R1-R7, PC}
  614 000001FA                 ENDP
  615 000001FA         
  616 000001FA         GETFLAGS
  617 000001FA         ;Helper subroutine for managing
  618 000001FA         ;the flags on the APSR in the addition
  619 000001FA         ;subroutine
  620 000001FA         ;Input: R0
  621 000001FA         ;Output: Carry flag
  622 000001FA         ;Register modifications: none
  623 000001FA B40F            PUSH             {R0-R3}
  624 000001FC 48AA            LDR              R0, =FLAGS  ;load pointer to st
                                                            ore flags
  625 000001FE 7800            LDRB             R0, [R0, #0]
  626 00000200 2800            CMP              R0, #0
  627 00000202 D107            BNE              SETCFLAG    ;if flag reg is set
                                                            , set C
  628 00000204 F3EF 8200       MRS              R2, APSR    ;otherwise, clear C
                                                            
  629 00000208 2320            MOVS             R3, #0x20
  630 0000020A 0612            LSLS             R2, R2, #24
  631 0000020C 439A            BICS             R2, R2, R3
  632 0000020E F382 8800       MSR              APSR, R2
  633 00000212 E006            B                ENDGF
  634 00000214         SETCFLAG                             ;Set C flag
  635 00000214 F3EF 8200       MRS              R2, APSR
  636 00000218 2320            MOVS             R3, #0x20



ARM Macro Assembler    Page 16 Exercise 12


  637 0000021A 061B            LSLS             R3, R3, #24
  638 0000021C 431A            ORRS             R2, R2, R3
  639 0000021E F382 8800       MSR              APSR, R2
  640 00000222         ENDGF
  641 00000222 BC0F            POP              {R0 - R3}   ;restore vals and q
                                                            uit
  642 00000224 4770            BX               LR
  643 00000226         SETFLAGS
  644 00000226         ;helper subroutine for setting the flags
  645 00000226         ;in the addition subroutine
  646 00000226         ;Input: 
  647 00000226         ;Output: APSR flags stored
  648 00000226         ;Register Modifications: none
  649 00000226 B407            PUSH             {R0-R2}
  650 00000228 F3EF 8000       MRS              R0, APSR
  651 0000022C 0F00            LSRS             R0, #28
  652 0000022E 2102            MOVS             R1, #2
  653 00000230 4008            ANDS             R0, R0, R1
  654 00000232 0880            LSRS             R0, R0, #2
  655 00000234 499C            LDR              R1, =FLAGS
  656 00000236 7008            STRB             R0, [R1, #0]
  657 00000238 BC07            POP              {R0-R2}
  658 0000023A 4770            BX               LR
  659 0000023C         
  660 0000023C         PutNumHex
                               PROC             {R0-R14},{}
  661 0000023C         ;Prints to the terminal screen the text
  662 0000023C         ; hexadecimal representation of the unsigned
  663 0000023C         ; word value in R0.  (For example, if R0 
  664 0000023C         ;contains 0x000012FF, then 000012FF should 
  665 0000023C         ;print on the terminal. 
  666 0000023C         ;Calls: PutChar
  667 0000023C         ;Input: R0   
  668 0000023C         ;Output: print to command line
  669 0000023C         ;Register Modiciations: PSR
  670 0000023C B583            PUSH             {R0,R1,R7,LR} ;preserve registe
                                                            r values
  671 0000023E 0007            MOVS             R7,R0       ;save copy of R0
  672 00000240 2100            MOVS             R1,#0       ;initialize shift v
                                                            alue
  673 00000242         LOOP
  674 00000242 0038            MOVS             R0,R7
  675 00000244 4088            LSLS             R0,R0,R1    ;shift R0 left 
  676 00000246 0F00            LSRS             R0,R0,#28   ;shift R0 right
  677 00000248 280A            CMP              R0,#10      ;check if number is
                                                             bigger than or equ
                                                            al to 10
  678 0000024A D201            BHS              ISHEX       ;if yes, it's a let
                                                            ter
  679 0000024C 3030            ADDS             R0,R0,#'0'  ;if no, it's a numb
                                                            er
  680 0000024E E000            B                PRNT        ;print the number
  681 00000250         ISHEX
  682 00000250 3037            ADDS             R0,R0,#('A'-10) ;convert number
                                                             to hex letter
  683 00000252         PRNT
  684 00000252 F7FF FFFE       BL               PutChar     ;print the number
  685 00000256 1D09            ADDS             R1,R1,#4    ;shift value += 4
  686 00000258 2920            CMP              R1,#32      ;if shift value is 



ARM Macro Assembler    Page 17 Exercise 12


                                                            32, no more charact
                                                            ers 
  687 0000025A D000            BEQ              QUIT        ;then quit
  688 0000025C E7F1            B                LOOP        ;else loop
  689 0000025E         QUIT
  690 0000025E BD83            POP              {R0,R1,R7,PC} ;restore register
                                                             values
  691 00000260         
  692 00000260                 ENDP
  693 00000260         
  694 00000260         PutNumUB
                               PROC             {R0-R14},{}
  695 00000260         ;Printss to the terminal screen 
  696 00000260         ;the text decimal representation
  697 00000260         ; of the unsigned byte value in R0.  
  698 00000260         ;Calls: PutNumU
  699 00000260         ;Inputs: R0
  700 00000260         ;Outputs:
  701 00000260         ;Register Modifications:
  702 00000260         
  703 00000260 B502            PUSH             {R1, LR}    ;preserve register 
                                                            values
  704 00000262 21FF            MOVS             R1, #0xFF   ;Mask off everythin
                                                            g but the last byte
                                                            
  705 00000264 4008            ANDS             R0, R0, R1
  706 00000266 F7FF FFFE       BL               PutNumU
  707 0000026A BD02            POP              {R1, PC}
  708 0000026C         
  709 0000026C                 ENDP
  710 0000026C         
  711 0000026C         GetStringSB
                               PROC             {R0-R14},{}
  712 0000026C         ;Read & store string from command line
  713 0000026C         ;Calls: GetChar, PutChar
  714 0000026C         ;Input: R0, R1 
  715 0000026C         ;Output: Prints to command line
  716 0000026C         ;Register Modifications:  
  717 0000026C B50F            PUSH             {R0,R1,R2,R3,LR} ;store registe
                                                            r vallues
  718 0000026E 1E49            SUBS             R1,R1,#1    ;R1 <- MAX_STRING -
                                                             1
  719 00000270 2200            MOVS             R2,#0       ;clear R2   
  720 00000272 0003            MOVS             R3,R0       ;store string point
                                                            er 
  721 00000274         GSLOOP
  722 00000274 F7FF FFFE       BL               GetChar     ;store character fr
                                                            om string
  723 00000278 428A            CMP              R2,R1       ;is the string smal
                                                            ler than MAX_STRING
                                                            ?
  724 0000027A D208            BHS              OVRFLW      ;if yes, branch    
                                                             
  725 0000027C 280D            CMP              R0,#0x0D
  726 0000027E D010            BEQ              GSQUIT      ;quit on carriage r
                                                            eturn
  727 00000280 287F            CMP              R0,#0x7F
  728 00000282 D007            BEQ              ADDCHK      ;go back one on bac
                                                            kspace



ARM Macro Assembler    Page 18 Exercise 12


  729 00000284 5498            STRB             R0,[R3,R2]  ;store char in M[R3
                                                            +R2]
  730 00000286 F7FF FFFE       BL               PutChar     ;print the characte
                                                            r         
  731 0000028A 1C52            ADDS             R2,R2,#1    ;increment offset  
                                                                    
  732 0000028C E7F2            B                GSLOOP      ;go to start of loo
                                                            p
  733 0000028E         OVRFLW
  734 0000028E 280D            CMP              R0,#0x0D
  735 00000290 D007            BEQ              GSQUIT      ;quit on carriage r
                                                            eturn
  736 00000292 E7EF            B                GSLOOP      ;go to start of loo
                                                            p
  737 00000294         ADDCHK
  738 00000294 2A00            CMP              R2,#0
  739 00000296 D0ED            BEQ              GSLOOP      ;go to start of loo
                                                            p if backspaced on 
                                                            nothing
  740 00000298 1E52            SUBS             R2,R2,#1    ;else go back one b
                                                            yte
  741 0000029A 207F            MOVS             R0,#0x7F    ;load backspace int
                                                            o R0
  742 0000029C F7FF FFFE       BL               PutChar     ;send backspace to 
                                                            command line
  743 000002A0 E7E8            B                GSLOOP      ;go to start of loo
                                                            p
  744 000002A2         GSQUIT
  745 000002A2 2000            MOVS             R0,#0       ;clear R0
  746 000002A4 5498            STRB             R0,[R3,R2]  ;store 0 in M[R3+R2
                                                            ]
  747 000002A6 200D            MOVS             R0,#0x0D    ;load carriage retu
                                                            rn into R0
  748 000002A8 F7FF FFFE       BL               PutChar     ;print carriage ret
                                                            urn
  749 000002AC 200A            MOVS             R0,#0x0A    ;load line feed int
                                                            o R0
  750 000002AE F7FF FFFE       BL               PutChar     ;print line feed
  751 000002B2 BD0F            POP              {R0,R1,R2,R3,PC} ;restore regis
                                                            ter values
  752 000002B4         
  753 000002B4                 ENDP
  754 000002B4         PutStringSB
                               PROC             {R0-R14},{}
  755 000002B4         ;Print string to command line
  756 000002B4         ;Calls: PutChar
  757 000002B4         ;Input: R0
  758 000002B4         ;Output: Print to command line
  759 000002B4         ;Register Modifications:  
  760 000002B4 B507            PUSH             {R0,R1,R2,LR} ;preserve registe
                                                            r values
  761 000002B6 2100            MOVS             R1,#0       ;clear R1
  762 000002B8 0002            MOVS             R2,R0       ;store string point
                                                            er in R2
  763 000002BA         PSLOOP
  764 000002BA 5C50            LDRB             R0,[R2,R1]  ;load character int
                                                            o R0
  765 000002BC 2800            CMP              R0,#0
  766 000002BE D003            BEQ              PSQUIT      ;quit on Null



ARM Macro Assembler    Page 19 Exercise 12


  767 000002C0 1C49            ADDS             R1,R1,#1    ;increment offset
  768 000002C2 F7FF FFFE       BL               PutChar     ;print the characte
                                                            r
  769 000002C6 E7F8            B                PSLOOP      ;go to start of loo
                                                            p
  770 000002C8         PSQUIT
  771 000002C8 BD07            POP              {R0,R1,R2,PC} ;restore register
                                                             values
  772 000002CA         
  773 000002CA                 ENDP
  774 000002CA         
  775 000002CA         ;UART0_ISR
  776 000002CA         ;handles UART0 transmit and receive interrupts
  777 000002CA         UART0_IRQHandler
                               PROC             {R0-R14},{}
  778 000002CA B672            CPSID            I           ;Mask  interrupts
  779 000002CC B50F            PUSH             {LR, R0-R3} ;preserve reg value
                                                            s
  780 000002CE 4879            LDR              R0, =UART0_BASE
  781 000002D0 78C1            LDRB             R1,[R0,#UART0_C2_OFFSET]
  782 000002D2 2280            MOVS             R2, #0x80
  783 000002D4 4011            ANDS             R1, R1, R2
  784 000002D6 2900            CMP              R1, #0
  785 000002D8 D100            BNE              TXEN
  786 000002DA E00F            B                CHECKRX     ;Icheck for rx inte
                                                            rrupt
  787 000002DC         TXEN
  788 000002DC 7901            LDRB             R1,[R0,#UART0_S1_OFFSET]
  789 000002DE 2280            MOVS             R2, #0x80
  790 000002E0 4011            ANDS             R1, R1, R2
  791 000002E2 2900            CMP              R1, #0
  792 000002E4 D00A            BEQ              CHECKRX
  793 000002E6 4971            LDR              R1, =TxQueueRecord 
                                                            ;Dequeue character
  794 000002E8 2204            MOVS             R2, #Q_BUF_SZ ;initialize queue
                                                            
  795 000002EA F7FF FFFE       BL               Dequeue
  796 000002EE D202            BCS              TXDA        ;dequeue failed
  797 000002F0 4970            LDR              R1, =UART0_BASE ;dequeue worked
                                                            
  798 000002F2 71C8            STRB             R0, [R1, #UART0_D_OFFSET]
  799 000002F4 E00E            B                QUITISR
  800 000002F6         TXDA
  801 000002F6 212C            MOVS             R1,#UART0_C2_T_RI
  802 000002F8 70C1            STRB             R1,[R0,#UART0_C2_OFFSET]
  803 000002FA E00B            B                QUITISR
  804 000002FC         CHECKRX
  805 000002FC 486D            LDR              R0, =UART0_BASE
  806 000002FE 7901            LDRB             R1,[R0,#UART0_S1_OFFSET] ;check
                                                             for rx interrupt
  807 00000300 2210            MOVS             R2, #0x10
  808 00000302 4011            ANDS             R1, R1, R2
  809 00000304 2900            CMP              R1, #0
  810 00000306 D005            BEQ              QUITISR
  811 00000308 486A            LDR              R0, =UART0_BASE
  812 0000030A 79C3            LDRB             R3, [R0, #UART0_D_OFFSET]
  813 0000030C 4968            LDR              R1, =RxQueueRecord
  814 0000030E 0018            MOVS             R0, R3
  815 00000310 F7FF FFFE       BL               Enqueue     ;enqueue character



ARM Macro Assembler    Page 20 Exercise 12


  816 00000314         QUITISR
  817 00000314 B662            CPSIE            I
  818 00000316 BD0F            POP              {R0-R3, PC}
  819 00000318                 ENDP
  820 00000318         
  821 00000318         PIT_IRQHandler
                               PROC             {R0-R14},{}
  822 00000318         ;On a PIT interrupt, if the (byte) variable RunStopWatch
                       
  823 00000318         ;is not equal to zero, the (word) variable Count is incr
                       emented
  824 00000318         ;otherwise, it leaves Count unchanged. 
  825 00000318         ;Interrupt condition is then cleard
  826 00000318         
  827 00000318 4867            LDR              R0, =RunStopWatch
  828 0000031A 7800            LDRB             R0, [R0, #0]
  829 0000031C 2800            CMP              R0, #0
  830 0000031E D100            BNE              PITISRINCR
  831 00000320 E003            B                QUITPITISR
  832 00000322         PITISRINCR
  833 00000322 4866            LDR              R0, =Count  ;increment count if
                                                             stopwatch is runni
                                                            ng 
  834 00000324 6801            LDR              R1, [R0, #0]
  835 00000326 1C49            ADDS             R1, R1, #1
  836 00000328 6001            STR              R1, [R0, #0]
  837 0000032A         QUITPITISR
  838 0000032A 4867            LDR              R0, =PIT_CH0_BASE ;clear interr
                                                            upt condition
  839 0000032C 4967            LDR              R1, =PIT_TFLG_TIF_MASK
  840 0000032E 60C1            STR              R1, [R0, #PIT_TFLG_OFFSET]
  841 00000330 4770            BX               LR
  842 00000332                 ENDP
  843 00000332         
  844 00000332         GetChar
  845 00000332         ;Dequeues a character from the receive queue, and return
                       s it in R0.
  846 00000332         ;Input: None
  847 00000332         ;Output: R0
  848 00000332         ;Modified Registers: R0
  849 00000332 B506            PUSH             {R1, R2, LR} ;preserve reg valu
                                                            es
  850 00000334 495E            LDR              R1,=RxQueueRecord ;load queue r
                                                            ecord address into 
                                                            R1
  851 00000336         GETCHARLOOP
  852 00000336 B672            CPSID            I           ;Mask interrupts
  853 00000338 F7FF FFFE       BL               Dequeue     ;dequeue character 
                                                            from receive queue
  854 0000033C B662            CPSIE            I           ;enable interrupts
  855 0000033E D2FA            BCS              GETCHARLOOP
  856 00000340 BD06            POP              {R1, R2, PC}
  857 00000342         
  858 00000342         PutChar
  859 00000342         ;Enqueues the character from R0 to the transmit queue.
  860 00000342         ;Input: R0
  861 00000342         ;Output: Prints to terminall
  862 00000342         ;Register modifications: None
  863 00000342         



ARM Macro Assembler    Page 21 Exercise 12


  864 00000342 B503            PUSH             {R0, R1, LR}
  865 00000344         PUTCHARLOOP
  866 00000344 4959            LDR              R1,=TxQueueRecord
  867 00000346 B672            CPSID            I           ;Mask interrupts
  868 00000348 F7FF FFFE       BL               Enqueue     ;Enqueue char from 
                                                            R0 to transmit queu
                                                            e
  869 0000034C B662            CPSIE            I           ;enable interrupts
  870 0000034E D2F9            BCS              PUTCHARLOOP
  871 00000350 21AC            MOVS             R1,#UART0_C2_TI_RI ;Enable UART
                                                            0 Transmitter, reci
                                                            ever, and rx interr
                                                            upt
  872 00000352 4858            LDR              R0, =UART0_BASE
  873 00000354 70C1            STRB             R1,[R0,#UART0_C2_OFFSET]
  874 00000356 BD03            POP              {R0, R1, PC} ;restore register 
                                                            values
  875 00000358         
  876 00000358         NEWLINE
  877 00000358         ;Prints a carriage return and a line feed
  878 00000358         ;Calls: PutChar
  879 00000358         ;Input:
  880 00000358         ;Output: Print to command line
  881 00000358         ;Register Modifications: 
  882 00000358 B501            PUSH             {R0,LR}     ;preserve register 
                                                            values
  883 0000035A 200D            MOVS             R0,#0x0D    ;load carriage retu
                                                            rn into R0
  884 0000035C F7FF FFFE       BL               PutChar     ;print carriage ret
                                                            urn
  885 00000360 200A            MOVS             R0,#0x0A    ;load line feed int
                                                            o R0
  886 00000362 F7FF FFFE       BL               PutChar     ;print line feed
  887 00000366 BD01            POP              {R0,PC}     ;restore register v
                                                            alues
  888 00000368         
  889 00000368         Init_UART0_IRQ
                               PROC             {R0-R14},{}
  890 00000368         ;Initializes UART0 to be used with interrupts
  891 00000368 B507            PUSH             {R0, R1, R2, LR}
  892 0000036A         ;initialize transmit queue
  893 0000036A 4855            LDR              R0, =TxQueue
  894 0000036C 494F            LDR              R1, =TxQueueRecord
  895 0000036E F7FF FFFE       BL               InitQueue
  896 00000372         ;initialize receive queue
  897 00000372 4854            LDR              R0, =RxQueue
  898 00000374 494E            LDR              R1, =RxQueueRecord
  899 00000376 F7FF FFFE       BL               InitQueue
  900 0000037A         ;Select MCGPLLCLK / 2 as UART0 clock source
  901 0000037A 485B            LDR              R0,=SIM_SOPT2
  902 0000037C 495B            LDR              R1,=SIM_SOPT2_UART0SRC_MASK
  903 0000037E 6802            LDR              R2,[R0,#0]
  904 00000380 438A            BICS             R2,R2,R1
  905 00000382 495B            LDR              R1,=SIM_SOPT2_UART0_MCGPLLCLK_D
IV2
  906 00000384 430A            ORRS             R2,R2,R1
  907 00000386 6002            STR              R2,[R0,#0]
  908 00000388         ;Enable external connection for UART0
  909 00000388 485A            LDR              R0,=SIM_SOPT5



ARM Macro Assembler    Page 22 Exercise 12


  910 0000038A 495B            LDR              R1,= SIM_SOPT5_UART0_EXTERN_MAS
K_CLEAR
  911 0000038C 6802            LDR              R2,[R0,#0]
  912 0000038E 438A            BICS             R2,R2,R1
  913 00000390 6002            STR              R2,[R0,#0]
  914 00000392         ;Enable clock for UART0 module
  915 00000392 485A            LDR              R0,=SIM_SCGC4
  916 00000394 495A            LDR              R1,= SIM_SCGC4_UART0_MASK
  917 00000396 6802            LDR              R2,[R0,#0]
  918 00000398 430A            ORRS             R2,R2,R1
  919 0000039A 6002            STR              R2,[R0,#0]
  920 0000039C         ;Enable clock for Port A module
  921 0000039C 4859            LDR              R0,=SIM_SCGC5
  922 0000039E 495A            LDR              R1,= SIM_SCGC5_PORTA_MASK
  923 000003A0 6802            LDR              R2,[R0,#0]
  924 000003A2 430A            ORRS             R2,R2,R1
  925 000003A4 6002            STR              R2,[R0,#0]
  926 000003A6         ;Connect PORT A Pin 1 (PTA1) to UART0 Rx (J1 Pin 02)
  927 000003A6 4859            LDR              R0,=PORTA_PCR1
  928 000003A8 4959            LDR              R1,=PORT_PCR_SET_PTA1_UART0_RX
  929 000003AA 6001            STR              R1,[R0,#0]
  930 000003AC         ;Connect PORT A Pin 2 (PTA2) to UART0 Tx (J1 Pin 04)
  931 000003AC 4859            LDR              R0,=PORTA_PCR2
  932 000003AE 4958            LDR              R1,=PORT_PCR_SET_PTA2_UART0_TX
  933 000003B0 6001            STR              R1,[R0,#0]
  934 000003B2         ;Disable UART0 receiver and transmitter
  935 000003B2 4840            LDR              R0,=UART0_BASE
  936 000003B4 210C            MOVS             R1,#UART0_C2_T_R
  937 000003B6 78C2            LDRB             R2,[R0,#UART0_C2_OFFSET]
  938 000003B8 438A            BICS             R2,R2,R1
  939 000003BA 70C2            STRB             R2,[R0,#UART0_C2_OFFSET]
  940 000003BC         ;Initialize NVIC for UART0 Interrupts
  941 000003BC         ;Set UART0 IRQ Priority
  942 000003BC 4856            LDR              R0, =UART0_IPR
  943 000003BE 4957            LDR              R1, =NVIC_IPR_UART0_MASK
  944 000003C0 4A56            LDR              R2, =NVIC_IPR_UART0_PRI_3
  945 000003C2 6803            LDR              R3, [R0, #0]
  946 000003C4 438B            BICS             R3, R3, R1
  947 000003C6 4313            ORRS             R3, R3, R2
  948 000003C8 6003            STR              R3, [R0, #0]
  949 000003CA         ;Clear any pending UART0 Interrupts
  950 000003CA 4855            LDR              R0, =NVIC_ICPR
  951 000003CC 4955            LDR              R1, =NVIC_ICPR_UART0_MASK
  952 000003CE 6001            STR              R1, [R0, #0]
  953 000003D0         ;Unmask UART0 interrupts
  954 000003D0 4855            LDR              R0, =NVIC_ISER
  955 000003D2 4954            LDR              R1, =NVIC_ISER_UART0_MASK
  956 000003D4 6001            STR              R1, [R0, #0]
  957 000003D6         ;Init UART0 for 8N1 format at 9600 Baud,
  958 000003D6         ;and enable the recieve interrupt
  959 000003D6 4837            LDR              R0, =UART0_BASE
  960 000003D8 2101            MOVS             R1,#UART0_BDH_9600
  961 000003DA 7001            STRB             R1,[R0,#UART0_BDH_OFFSET]
  962 000003DC 2138            MOVS             R1,#UART0_BDL_9600
  963 000003DE 7041            STRB             R1,[R0,#UART0_BDL_OFFSET]
  964 000003E0 2100            MOVS             R1,#UART0_C1_8N1
  965 000003E2 7081            STRB             R1,[R0,#UART0_C1_OFFSET]
  966 000003E4 2100            MOVS             R1,#UART0_C3_NO_TXINV
  967 000003E6 7181            STRB             R1,[R0,#UART0_C3_OFFSET]



ARM Macro Assembler    Page 23 Exercise 12


  968 000003E8 210F            MOVS             R1,#UART0_C4_NO_MATCH_OSR_16
  969 000003EA 7281            STRB             R1,[R0,#UART0_C4_OFFSET]
  970 000003EC 2100            MOVS             R1,#UART0_C5_NO_DMA_SSR_SYNC
  971 000003EE 72C1            STRB             R1,[R0,#UART0_C5_OFFSET]
  972 000003F0 211F            MOVS             R1,#UART0_S1_CLEAR_FLAGS
  973 000003F2 7101            STRB             R1,[R0,#UART0_S1_OFFSET]
  975 000003F4 21C0            MOVS             R1,     #UART0_S2_NO_RXINV_BRK
10_NO_LBKDETECT_CLEAR_FLAGS
  976 000003F6 7141            STRB             R1,[R0,#UART0_S2_OFFSET]
  977 000003F8         ;Enable UART0 transmitter, transmitter interrupt,
  978 000003F8         ;receiver, and receive interrupt
  979 000003F8 212C            MOVS             R1,#UART0_C2_T_RI
  980 000003FA 70C1            STRB             R1,[R0,#UART0_C2_OFFSET]
  981 000003FC         ;Pop prevous R0-2 values off the stack.
  982 000003FC BD07            POP              {R0, R1, R2, PC}
  983 000003FE                 ENDP
  984 000003FE         
  985 000003FE         PutNumU PROC             {R0-R14},{}
  986 000003FE         ;Prints decimal representation of the unsigned word valu
                       e in R0
  987 000003FE         ;Calls: DIVU, PutChar
  988 000003FE         ;Input: R0
  989 000003FE         ;Output: Print to command line
  990 000003FE         ;Register Modifications:
  991 000003FE B507            PUSH             {R0,R1,R2,LR} ;preserve registe
                                                            r values
  992 00000400 2800            CMP              R0,#0       ;if number is 0
  993 00000402 D024            BEQ              ISZERO      ;branch
  994 00000404 2200            MOVS             R2,#0       ;clear R2
  995 00000406 0001            MOVS             R1,R0       ;set R1 to number 
  996 00000408 4848            LDR              R0,=DIV1M
  997 0000040A F7FF FFFE       BL               DIVU        ;Number/1000000
  998 0000040E F000 F841       BL               PRNTHLPR    ;print result
  999 00000412 4847            LDR              R0,=DIV100K
 1000 00000414 F7FF FFFE       BL               DIVU        ;Number/100000
 1001 00000418 F000 F83C       BL               PRNTHLPR    ;print result
 1002 0000041C 4845            LDR              R0,=DIV10K
 1003 0000041E F7FF FFFE       BL               DIVU        ;Number/10000
 1004 00000422 F000 F837       BL               PRNTHLPR    ;print result
 1005 00000426 4844            LDR              R0,=DIV1K
 1006 00000428 F7FF FFFE       BL               DIVU        ;Number/1000
 1007 0000042C F000 F832       BL               PRNTHLPR    ;print result
 1008 00000430 2064            MOVS             R0,#0x64
 1009 00000432 F7FF FFFE       BL               DIVU        ;Number/100
 1010 00000436 F000 F82D       BL               PRNTHLPR    ;print result
 1011 0000043A 200A            MOVS             R0,#0xA
 1012 0000043C F7FF FFFE       BL               DIVU        ;Number/10
 1013 00000440 F000 F828       BL               PRNTHLPR    ;print result
 1014 00000444 0008            MOVS             R0,R1       ;load remainder int
                                                            o R0
 1015 00000446 3030            ADDS             R0,R0,#0x30 ;convert to ascii
 1016 00000448 F7FF FFFE       BL               PutChar     ;print the number
 1017 0000044C BD07            POP              {R0,R1,R2,PC} ;restore register
                                                             values
 1018 0000044E         ISZERO
 1019 0000044E 2030            MOVS             R0,#0x30
 1020 00000450 F7FF FFFE       BL               PutChar     ;print "0"
 1021 00000454 BD07            POP              {R0,R1,R2,PC} ;restore register
                                                             values



ARM Macro Assembler    Page 24 Exercise 12


 1022 00000456                 ENDP
 1023 00000456         
 1024 00000456         DIVU    PROC             {R2-R14},{}
 1025 00000456         ;Computes R1 / R0 into R0 remainder R1
 1026 00000456         ;Calls: DIVU, PutChar
 1027 00000456         ;Input: R0, R1
 1028 00000456         ;Output: R0, R1
 1029 00000456         ;Register Modifications: R0, R1
 1030 00000456 B418            PUSH             {R3,R4}     ;store values of R3
                                                             and R4
 1031 00000458 2800            CMP              R0, #0      ;compare divisor to
                                                             0
 1032 0000045A D002            BEQ              SET_CAR     ;if divisor is 0, g
                                                            o to special case
 1033 0000045C 2900            CMP              R1, #0      ;compare dividend t
                                                            o zero
 1034 0000045E D00E            BEQ              ZERODIV     ;if dividend is 0, 
                                                            
 1035 00000460 E007            B                BRK         ;go to special case
                                                            
 1036 00000462         SET_CAR
 1037 00000462 F3EF 8300       MRS              R3,APSR     ;set C flag to 1
 1038 00000466 2420            MOVS             R4,#0x20
 1039 00000468 0624            LSLS             R4,R4,#24
 1040 0000046A 4323            ORRS             R3,R3,R4
 1041 0000046C F383 8800       MSR              APSR,R3
 1042 00000470 E00E            B                ENDDIV
 1043 00000472         BRK
 1044 00000472 2300            MOVS             R3, #0      ;put quotient in R3
                                                            
 1045 00000474         
 1046 00000474         DIVWHILE
 1047 00000474 4288            CMP              R0, R1      ;compare R0 and R1
 1048 00000476 D803            BHI              ENDDIVWHILE ;if R0<R1 exit the 
                                                            loop
 1049 00000478 1C5B            ADDS             R3, R3, #1  ;quotient ++
 1050 0000047A 1A09            SUBS             R1, R1, R0  ;R1 = R1 - R0
 1051 0000047C E7FA            B                DIVWHILE
 1052 0000047E         
 1053 0000047E         ZERODIV
 1054 0000047E 2300            MOVS             R3,#0       ;IF dividend is zer
                                                            o, remainder is alw
                                                            ays zero
 1055 00000480         ENDDIVWHILE
 1056 00000480 0018            MOVS             R0, R3      ;R0 <- quotient, re
                                                            mainder = R1
 1057 00000482 F3EF 8300       MRS              R3,APSR     ;clear C flag to 0
 1058 00000486 2420            MOVS             R4,#0x20
 1059 00000488 0624            LSLS             R4,R4,#24
 1060 0000048A 43A3            BICS             R3,R3,R4
 1061 0000048C F383 8800       MSR              APSR,R3
 1062 00000490         
 1063 00000490         ENDDIV
 1064 00000490 BC18            POP              {R3,R4}     ;clear changes from
                                                             registers
 1065 00000492 4770            BX               LR          ;quit subroutine
 1066 00000494                 ENDP
 1067 00000494         
 1068 00000494         PRNTHLPR



ARM Macro Assembler    Page 25 Exercise 12


 1069 00000494         ;Prints character if character is not a leading zero
 1070 00000494         ;Calls: PutChar
 1071 00000494         ;Input: R0, R2
 1072 00000494         ;Output: R0, R2
 1073 00000494         ;Register Modifications: R0, R2
 1074 00000494         
 1075 00000494 B500            PUSH             {LR}        ;preserve register 
                                                            values
 1076 00000496 2A01            CMP              R2,#1       ;if character isnt 
                                                            a leading character
                                                            
 1077 00000498 D001            BEQ              PRINTCHAR   ;print it
 1078 0000049A 2800            CMP              R0,#0       ;if character is le
                                                            ading zero
 1079 0000049C D003            BEQ              PRNTQUITT   ;quit
 1080 0000049E         PRINTCHAR
 1081 0000049E 3030            ADDS             R0,R0,#0x30 ;convert char to as
                                                            cii
 1082 000004A0 F7FF FFFE       BL               PutChar     ;print character
 1083 000004A4 2201            MOVS             R2,#1       ;indicates all futu
                                                            re numbers aren't l
                                                            eading
 1084 000004A6         PRNTQUITT
 1085 000004A6 BD00            POP              {PC}        ;restore register v
                                                            alues
 1086 000004A8         ;>>>>>   end subroutine code <<<<<
 1087 000004A8                 ALIGN
 1088 000004A8         ;*******************************************************
                       ***************
 1089 000004A8         ;Constants
 1090 000004A8 00000000 
              00000000 
              00000000 
              4006A000 
              00000000 
              00000000 
              00000000 
              00000000 
              40037100 
              00000001 
              00000000 
              00000000 
              00000000 
              00000000 
              00000000 
              00000000 
              40048004 
              0C000000 
              04010000 
              40048010 
              00010007 
              40048034 
              00000400 
              40048038 
              00000200 
              40049004 
              01000200 
              40049008 
              E000E40C 



ARM Macro Assembler    Page 26 Exercise 12


              000000C0 
              E000E280 
              00001000 
              E000E100 
              000F4240 
              000186A0 
              00002710 
              000003E8         AREA             MyConst,DATA,READONLY
 1091 00000000         ;>>>>> begin constants here <<<<<
 1092 00000000                 EXPORT           DAC0_table_0
 1093 00000000                 EXPORT           PWM_duty_table_0
 1094 00000000         PWM_duty_table_0
 1095 00000000 A8 16           DCW              PWM_DUTY_10 ;100% Range
 1096 00000002 F2 12           DCW              ((3 * (PWM_DUTY_10 - PWM_DUTY_5
)/4) + PWM_DUTY_5) 
                                                            ;75% Range
 1097 00000004 3C 0F           DCW              (((PWM_DUTY_10 - PWM_DUTY_5) / 
2) + PWM_DUTY_5) 
                                                            ;50% Range
 1098 00000006 86 0B           DCW              (((PWM_DUTY_10 - PWM_DUTY_5) / 
4) + PWM_DUTY_5) 
                                                            ;25% Range
 1099 00000008 D0 07           DCW              PWM_DUTY_5  ;0% Range
 1100 0000000A 00 00           ALIGN
 1101 0000000C         DAC0_table_0
 1102 0000000C 99 01           DCW              ((DAC0_STEPS - 1) / (SERVO_POSI
TIONS * 2))
 1103 0000000E CC 04           DCW              (((DAC0_STEPS - 1) * 3) / (SERV
O_POSITIONS * 2))
 1104 00000010 FF 07           DCW              (((DAC0_STEPS - 1) * 5) / (SERV
O_POSITIONS * 2))
 1105 00000012 32 0B           DCW              (((DAC0_STEPS - 1) * 7) / (SERV
O_POSITIONS * 2))
 1106 00000014 65 0E           DCW              (((DAC0_STEPS - 1) * 9) / (SERV
O_POSITIONS * 2))
 1107 00000016         ;>>>>>   end constants here <<<<<
 1108 00000016         ;*******************************************************
                       ***************
 1109 00000016         ;Variables
 1110 00000016                 AREA             MyData,DATA,READWRITE
 1111 00000000         ;>>>>> begin variables here <<<<<
 1112 00000000 00 00 00 
              00       QBuffer SPACE            Q_BUF_SZ    ;Queue contents 
 1113 00000004 00 00 00 
              00 00 00 
              00 00 00 
              00 00 00 
              00 00 00 
              00 00 00 QRecord SPACE            Q_REC_SZ    ;Queue management r
                                                            ecord 
 1114 00000016 00 00           ALIGN
 1115 00000018 00 00 00 
              00       RxQueue SPACE            Q_BUF_SZ
 1116 0000001C 00 00 00 
              00 00 00 
              00 00 00 
              00 00 00 
              00 00 00 
              00 00 00 RxQueueRecord



ARM Macro Assembler    Page 27 Exercise 12


                               SPACE            Q_REC_SZ
 1117 0000002E 00 00           ALIGN
 1118 00000030 00 00 00 
              00       TxQueue SPACE            Q_BUF_SZ
 1119 00000034 00 00 00 
              00 00 00 
              00 00 00 
              00 00 00 
              00 00 00 
              00 00 00 TxQueueRecord
                               SPACE            Q_REC_SZ
 1120 00000046 00 00           ALIGN
 1121 00000048 00      RunStopWatch
                               SPACE            1
 1122 00000049 00 00 00        ALIGN
 1123 0000004C 00 00 00 
              00       Count   SPACE            4
 1124 00000050                 ALIGN
 1125 00000050 00 00   FLAGS   SPACE            2
 1126 00000052         
 1127 00000052         ;>>>>>   end variables here <<<<<
 1128 00000052 00 00           ALIGN
 1129 00000054                 END
Command Line: --debug --xref --diag_suppress=9931 --cpu=Cortex-M0+ --apcs=inter
work --depend=.\objects\programtemplate_c_start.d -o.\objects\programtemplate_c
_start.o -I.\RTE\_Target_1 -IC:\Keil_v5\ARM\PACK\ARM\CMSIS\5.5.1\CMSIS\Core\Inc
lude -IC:\Keil_v5\ARM\PACK\Keil\Kinetis_KLxx_DFP\1.14.0\Device\Include --predef
ine="__EVAL SETA 1" --predefine="__UVISION_VERSION SETA 524" --predefine="_RTE_
 SETA 1" --predefine="MKL46Z256xxx4 SETA 1" --list=.\listings\programtemplate_c
_start.lst "..\Exercise 11\ProgramTemplate_C_Start.s"



ARM Macro Assembler    Page 1 Alphabetic symbol ordering
Relocatable symbols

ADD 000001AE

Symbol: ADD
   Definitions
      At line 575 in file ..\Exercise
   Uses
      At line 594 in file ..\Exercise
      At line 598 in file ..\Exercise

ADDCHK 00000294

Symbol: ADDCHK
   Definitions
      At line 737 in file ..\Exercise
   Uses
      At line 728 in file ..\Exercise
Comment: ADDCHK used once
ADDEND 000001E0

Symbol: ADDEND
   Definitions
      At line 600 in file ..\Exercise
   Uses
      At line 577 in file ..\Exercise
Comment: ADDEND used once
AddIntMultiU 0000019E

Symbol: AddIntMultiU
   Definitions
      At line 554 in file ..\Exercise
   Uses
      At line 264 in file ..\Exercise
Comment: AddIntMultiU used once
BRK 00000472

Symbol: BRK
   Definitions
      At line 1043 in file ..\Exercise
   Uses
      At line 1035 in file ..\Exercise
Comment: BRK used once
CARRY 0000018C

Symbol: CARRY
   Definitions
      At line 542 in file ..\Exercise
   Uses
      At line 524 in file ..\Exercise
Comment: CARRY used once
CHECKRX 000002FC

Symbol: CHECKRX
   Definitions
      At line 804 in file ..\Exercise
   Uses
      At line 786 in file ..\Exercise
      At line 792 in file ..\Exercise

CLEARC 0000013C



ARM Macro Assembler    Page 2 Alphabetic symbol ordering
Relocatable symbols


Symbol: CLEARC
   Definitions
      At line 488 in file ..\Exercise
   Uses
      At line 485 in file ..\Exercise
Comment: CLEARC used once
DIVU 00000456

Symbol: DIVU
   Definitions
      At line 1024 in file ..\Exercise
   Uses
      At line 997 in file ..\Exercise
      At line 1000 in file ..\Exercise
      At line 1003 in file ..\Exercise
      At line 1006 in file ..\Exercise
      At line 1009 in file ..\Exercise
      At line 1012 in file ..\Exercise

DIVWHILE 00000474

Symbol: DIVWHILE
   Definitions
      At line 1046 in file ..\Exercise
   Uses
      At line 1051 in file ..\Exercise
Comment: DIVWHILE used once
DQQUITT 0000015A

Symbol: DQQUITT
   Definitions
      At line 502 in file ..\Exercise
   Uses
      At line 494 in file ..\Exercise
Comment: DQQUITT used once
Dequeue 0000011A

Symbol: Dequeue
   Definitions
      At line 461 in file ..\Exercise
   Uses
      At line 795 in file ..\Exercise
      At line 853 in file ..\Exercise

ENDDIV 00000490

Symbol: ENDDIV
   Definitions
      At line 1063 in file ..\Exercise
   Uses
      At line 1042 in file ..\Exercise
Comment: ENDDIV used once
ENDDIVWHILE 00000480

Symbol: ENDDIVWHILE
   Definitions
      At line 1055 in file ..\Exercise
   Uses



ARM Macro Assembler    Page 3 Alphabetic symbol ordering
Relocatable symbols

      At line 1048 in file ..\Exercise
Comment: ENDDIVWHILE used once
ENDGF 00000222

Symbol: ENDGF
   Definitions
      At line 640 in file ..\Exercise
   Uses
      At line 633 in file ..\Exercise
Comment: ENDGF used once
EQQUITT 0000019A

Symbol: EQQUITT
   Definitions
      At line 548 in file ..\Exercise
   Uses
      At line 541 in file ..\Exercise
Comment: EQQUITT used once
Enqueue 0000015E

Symbol: Enqueue
   Definitions
      At line 508 in file ..\Exercise
   Uses
      At line 815 in file ..\Exercise
      At line 868 in file ..\Exercise

GETCHARLOOP 00000336

Symbol: GETCHARLOOP
   Definitions
      At line 851 in file ..\Exercise
   Uses
      At line 855 in file ..\Exercise
Comment: GETCHARLOOP used once
GETFLAGS 000001FA

Symbol: GETFLAGS
   Definitions
      At line 616 in file ..\Exercise
   Uses
      At line 587 in file ..\Exercise
Comment: GETFLAGS used once
GRNSET 0000006C

Symbol: GRNSET
   Definitions
      At line 384 in file ..\Exercise
   Uses
      At line 379 in file ..\Exercise
Comment: GRNSET used once
GSLOOP 00000274

Symbol: GSLOOP
   Definitions
      At line 721 in file ..\Exercise
   Uses
      At line 732 in file ..\Exercise
      At line 736 in file ..\Exercise



ARM Macro Assembler    Page 4 Alphabetic symbol ordering
Relocatable symbols

      At line 739 in file ..\Exercise
      At line 743 in file ..\Exercise

GSQUIT 000002A2

Symbol: GSQUIT
   Definitions
      At line 744 in file ..\Exercise
   Uses
      At line 726 in file ..\Exercise
      At line 735 in file ..\Exercise

GetChar 00000332

Symbol: GetChar
   Definitions
      At line 844 in file ..\Exercise
   Uses
      At line 269 in file ..\Exercise
      At line 722 in file ..\Exercise

GetCount 00000006

Symbol: GetCount
   Definitions
      At line 302 in file ..\Exercise
   Uses
      At line 278 in file ..\Exercise
Comment: GetCount used once
GetStringSB 0000026C

Symbol: GetStringSB
   Definitions
      At line 711 in file ..\Exercise
   Uses
      At line 265 in file ..\Exercise
Comment: GetStringSB used once
INVALID 0000014C

Symbol: INVALID
   Definitions
      At line 495 in file ..\Exercise
   Uses
      At line 474 in file ..\Exercise
Comment: INVALID used once
ISHEX 00000250

Symbol: ISHEX
   Definitions
      At line 681 in file ..\Exercise
   Uses
      At line 678 in file ..\Exercise
Comment: ISHEX used once
ISZERO 0000044E

Symbol: ISZERO
   Definitions
      At line 1018 in file ..\Exercise
   Uses



ARM Macro Assembler    Page 5 Alphabetic symbol ordering
Relocatable symbols

      At line 993 in file ..\Exercise
Comment: ISZERO used once
InitQueue 00000104

Symbol: InitQueue
   Definitions
      At line 438 in file ..\Exercise
   Uses
      At line 895 in file ..\Exercise
      At line 899 in file ..\Exercise

Init_LED 00000080

Symbol: Init_LED
   Definitions
      At line 406 in file ..\Exercise
   Uses
      At line 281 in file ..\Exercise
Comment: Init_LED used once
Init_PIT_IRQ 00000024

Symbol: Init_PIT_IRQ
   Definitions
      At line 329 in file ..\Exercise
   Uses
      At line 268 in file ..\Exercise
Comment: Init_PIT_IRQ used once
Init_UART0_IRQ 00000368

Symbol: Init_UART0_IRQ
   Definitions
      At line 889 in file ..\Exercise
   Uses
      At line 267 in file ..\Exercise
Comment: Init_UART0_IRQ used once
KeyPressed 00000000

Symbol: KeyPressed
   Definitions
      At line 285 in file ..\Exercise
   Uses
      At line 277 in file ..\Exercise
Comment: KeyPressed used once
LEDSet 0000005E

Symbol: LEDSet
   Definitions
      At line 366 in file ..\Exercise
   Uses
      At line 280 in file ..\Exercise
Comment: LEDSet used once
LOOP 00000242

Symbol: LOOP
   Definitions
      At line 673 in file ..\Exercise
   Uses
      At line 688 in file ..\Exercise
Comment: LOOP used once



ARM Macro Assembler    Page 6 Alphabetic symbol ordering
Relocatable symbols

MyCode 00000000

Symbol: MyCode
   Definitions
      At line 263 in file ..\Exercise
   Uses
      None
Comment: MyCode unused
NEWLINE 00000358

Symbol: NEWLINE
   Definitions
      At line 876 in file ..\Exercise
   Uses
      None
Comment: NEWLINE unused
OVRFLW 0000028E

Symbol: OVRFLW
   Definitions
      At line 733 in file ..\Exercise
   Uses
      At line 724 in file ..\Exercise
Comment: OVRFLW used once
PITISRINCR 00000322

Symbol: PITISRINCR
   Definitions
      At line 832 in file ..\Exercise
   Uses
      At line 830 in file ..\Exercise
Comment: PITISRINCR used once
PIT_IRQHandler 00000318

Symbol: PIT_IRQHandler
   Definitions
      At line 821 in file ..\Exercise
   Uses
      At line 276 in file ..\Exercise
Comment: PIT_IRQHandler used once
PRINTCHAR 0000049E

Symbol: PRINTCHAR
   Definitions
      At line 1080 in file ..\Exercise
   Uses
      At line 1077 in file ..\Exercise
Comment: PRINTCHAR used once
PRNT 00000252

Symbol: PRNT
   Definitions
      At line 683 in file ..\Exercise
   Uses
      At line 680 in file ..\Exercise
Comment: PRNT used once
PRNTHLPR 00000494

Symbol: PRNTHLPR



ARM Macro Assembler    Page 7 Alphabetic symbol ordering
Relocatable symbols

   Definitions
      At line 1068 in file ..\Exercise
   Uses
      At line 998 in file ..\Exercise
      At line 1001 in file ..\Exercise
      At line 1004 in file ..\Exercise
      At line 1007 in file ..\Exercise
      At line 1010 in file ..\Exercise
      At line 1013 in file ..\Exercise

PRNTQUITT 000004A6

Symbol: PRNTQUITT
   Definitions
      At line 1084 in file ..\Exercise
   Uses
      At line 1079 in file ..\Exercise
Comment: PRNTQUITT used once
PSLOOP 000002BA

Symbol: PSLOOP
   Definitions
      At line 763 in file ..\Exercise
   Uses
      At line 769 in file ..\Exercise
Comment: PSLOOP used once
PSQUIT 000002C8

Symbol: PSQUIT
   Definitions
      At line 770 in file ..\Exercise
   Uses
      At line 766 in file ..\Exercise
Comment: PSQUIT used once
PUTCHARLOOP 00000344

Symbol: PUTCHARLOOP
   Definitions
      At line 865 in file ..\Exercise
   Uses
      At line 870 in file ..\Exercise
Comment: PUTCHARLOOP used once
PutChar 00000342

Symbol: PutChar
   Definitions
      At line 858 in file ..\Exercise
   Uses
      At line 270 in file ..\Exercise
      At line 684 in file ..\Exercise
      At line 730 in file ..\Exercise
      At line 742 in file ..\Exercise
      At line 748 in file ..\Exercise
      At line 750 in file ..\Exercise
      At line 768 in file ..\Exercise
      At line 884 in file ..\Exercise
      At line 886 in file ..\Exercise
      At line 1016 in file ..\Exercise
      At line 1020 in file ..\Exercise



ARM Macro Assembler    Page 8 Alphabetic symbol ordering
Relocatable symbols

      At line 1082 in file ..\Exercise

PutNumHex 0000023C

Symbol: PutNumHex
   Definitions
      At line 660 in file ..\Exercise
   Uses
      At line 272 in file ..\Exercise
Comment: PutNumHex used once
PutNumU 000003FE

Symbol: PutNumU
   Definitions
      At line 985 in file ..\Exercise
   Uses
      At line 706 in file ..\Exercise
Comment: PutNumU used once
PutNumUB 00000260

Symbol: PutNumUB
   Definitions
      At line 694 in file ..\Exercise
   Uses
      At line 271 in file ..\Exercise
Comment: PutNumUB used once
PutStringSB 000002B4

Symbol: PutStringSB
   Definitions
      At line 754 in file ..\Exercise
   Uses
      At line 266 in file ..\Exercise
Comment: PutStringSB used once
QUIT 0000025E

Symbol: QUIT
   Definitions
      At line 689 in file ..\Exercise
   Uses
      At line 687 in file ..\Exercise
Comment: QUIT used once
QUITADDMULTIU 000001F8

Symbol: QUITADDMULTIU
   Definitions
      At line 612 in file ..\Exercise
   Uses
      At line 603 in file ..\Exercise
Comment: QUITADDMULTIU used once
QUITISR 00000314

Symbol: QUITISR
   Definitions
      At line 816 in file ..\Exercise
   Uses
      At line 799 in file ..\Exercise
      At line 803 in file ..\Exercise
      At line 810 in file ..\Exercise



ARM Macro Assembler    Page 9 Alphabetic symbol ordering
Relocatable symbols


QUITLEDSET 0000007C

Symbol: QUITLEDSET
   Definitions
      At line 401 in file ..\Exercise
   Uses
      At line 396 in file ..\Exercise
Comment: QUITLEDSET used once
QUITPITISR 0000032A

Symbol: QUITPITISR
   Definitions
      At line 837 in file ..\Exercise
   Uses
      At line 831 in file ..\Exercise
Comment: QUITPITISR used once
REDCHK 0000006E

Symbol: REDCHK
   Definitions
      At line 386 in file ..\Exercise
   Uses
      At line 382 in file ..\Exercise
Comment: REDCHK used once
REDSET 0000007A

Symbol: REDSET
   Definitions
      At line 398 in file ..\Exercise
   Uses
      At line 393 in file ..\Exercise
Comment: REDSET used once
SETCFLAG 00000214

Symbol: SETCFLAG
   Definitions
      At line 634 in file ..\Exercise
   Uses
      At line 627 in file ..\Exercise
Comment: SETCFLAG used once
SETFLAGS 00000226

Symbol: SETFLAGS
   Definitions
      At line 643 in file ..\Exercise
   Uses
      At line 589 in file ..\Exercise
Comment: SETFLAGS used once
SET_CAR 00000462

Symbol: SET_CAR
   Definitions
      At line 1036 in file ..\Exercise
   Uses
      At line 1032 in file ..\Exercise
Comment: SET_CAR used once
SKIP 000001BC




ARM Macro Assembler    Page 10 Alphabetic symbol ordering
Relocatable symbols

Symbol: SKIP
   Definitions
      At line 583 in file ..\Exercise
   Uses
      At line 581 in file ..\Exercise
Comment: SKIP used once
SKIPE 0000017A

Symbol: SKIPE
   Definitions
      At line 534 in file ..\Exercise
   Uses
      At line 532 in file ..\Exercise
Comment: SKIPE used once
SUCC 000001E6

Symbol: SUCC
   Definitions
      At line 604 in file ..\Exercise
   Uses
      At line 602 in file ..\Exercise
Comment: SUCC used once
TXDA 000002F6

Symbol: TXDA
   Definitions
      At line 800 in file ..\Exercise
   Uses
      At line 796 in file ..\Exercise
Comment: TXDA used once
TXEN 000002DC

Symbol: TXEN
   Definitions
      At line 787 in file ..\Exercise
   Uses
      At line 785 in file ..\Exercise
Comment: TXEN used once
TimeStart 00000012

Symbol: TimeStart
   Definitions
      At line 315 in file ..\Exercise
   Uses
      At line 279 in file ..\Exercise
Comment: TimeStart used once
UART0_IRQHandler 000002CA

Symbol: UART0_IRQHandler
   Definitions
      At line 777 in file ..\Exercise
   Uses
      At line 275 in file ..\Exercise
Comment: UART0_IRQHandler used once
VCHK 000001D8

Symbol: VCHK
   Definitions
      At line 595 in file ..\Exercise



ARM Macro Assembler    Page 11 Alphabetic symbol ordering
Relocatable symbols

   Uses
      At line 592 in file ..\Exercise
Comment: VCHK used once
ZERODIV 0000047E

Symbol: ZERODIV
   Definitions
      At line 1053 in file ..\Exercise
   Uses
      At line 1034 in file ..\Exercise
Comment: ZERODIV used once
71 symbols



ARM Macro Assembler    Page 1 Alphabetic symbol ordering
Relocatable symbols

DAC0_table_0 0000000C

Symbol: DAC0_table_0
   Definitions
      At line 1101 in file ..\Exercise
   Uses
      At line 273 in file ..\Exercise
      At line 1092 in file ..\Exercise

MyConst 00000000

Symbol: MyConst
   Definitions
      At line 1090 in file ..\Exercise
   Uses
      None
Comment: MyConst unused
PWM_duty_table_0 00000000

Symbol: PWM_duty_table_0
   Definitions
      At line 1094 in file ..\Exercise
   Uses
      At line 274 in file ..\Exercise
      At line 1093 in file ..\Exercise

3 symbols



ARM Macro Assembler    Page 1 Alphabetic symbol ordering
Relocatable symbols

Count 0000004C

Symbol: Count
   Definitions
      At line 1123 in file ..\Exercise
   Uses
      At line 309 in file ..\Exercise
      At line 319 in file ..\Exercise
      At line 833 in file ..\Exercise

FLAGS 00000050

Symbol: FLAGS
   Definitions
      At line 1125 in file ..\Exercise
   Uses
      At line 569 in file ..\Exercise
      At line 624 in file ..\Exercise
      At line 655 in file ..\Exercise

MyData 00000000

Symbol: MyData
   Definitions
      At line 1110 in file ..\Exercise
   Uses
      None
Comment: MyData unused
QBuffer 00000000

Symbol: QBuffer
   Definitions
      At line 1112 in file ..\Exercise
   Uses
      None
Comment: QBuffer unused
QRecord 00000004

Symbol: QRecord
   Definitions
      At line 1113 in file ..\Exercise
   Uses
      None
Comment: QRecord unused
RunStopWatch 00000048

Symbol: RunStopWatch
   Definitions
      At line 1121 in file ..\Exercise
   Uses
      At line 322 in file ..\Exercise
      At line 827 in file ..\Exercise

RxQueue 00000018

Symbol: RxQueue
   Definitions
      At line 1115 in file ..\Exercise
   Uses



ARM Macro Assembler    Page 2 Alphabetic symbol ordering
Relocatable symbols

      At line 897 in file ..\Exercise
Comment: RxQueue used once
RxQueueRecord 0000001C

Symbol: RxQueueRecord
   Definitions
      At line 1116 in file ..\Exercise
   Uses
      At line 297 in file ..\Exercise
      At line 813 in file ..\Exercise
      At line 850 in file ..\Exercise
      At line 898 in file ..\Exercise

TxQueue 00000030

Symbol: TxQueue
   Definitions
      At line 1118 in file ..\Exercise
   Uses
      At line 893 in file ..\Exercise
Comment: TxQueue used once
TxQueueRecord 00000034

Symbol: TxQueueRecord
   Definitions
      At line 1119 in file ..\Exercise
   Uses
      At line 793 in file ..\Exercise
      At line 866 in file ..\Exercise
      At line 894 in file ..\Exercise

10 symbols



ARM Macro Assembler    Page 1 Alphabetic symbol ordering
Absolute symbols

ADC0_BASE 4003B000

Symbol: ADC0_BASE
   Definitions
      At line 186 in file ..\Exercise
   Uses
      At line 214 in file ..\Exercise
      At line 215 in file ..\Exercise
      At line 216 in file ..\Exercise
      At line 217 in file ..\Exercise
      At line 218 in file ..\Exercise
      At line 219 in file ..\Exercise
      At line 220 in file ..\Exercise
      At line 221 in file ..\Exercise
      At line 222 in file ..\Exercise
      At line 223 in file ..\Exercise
      At line 224 in file ..\Exercise
      At line 225 in file ..\Exercise
      At line 226 in file ..\Exercise
      At line 227 in file ..\Exercise
      At line 228 in file ..\Exercise
      At line 229 in file ..\Exercise
      At line 230 in file ..\Exercise
      At line 231 in file ..\Exercise
      At line 232 in file ..\Exercise
      At line 233 in file ..\Exercise
      At line 234 in file ..\Exercise
      At line 235 in file ..\Exercise
      At line 236 in file ..\Exercise
      At line 237 in file ..\Exercise
      At line 238 in file ..\Exercise
      At line 239 in file ..\Exercise
      At line 240 in file ..\Exercise

ADC0_CFG1 4003B008

Symbol: ADC0_CFG1
   Definitions
      At line 214 in file ..\Exercise
   Uses
      None
Comment: ADC0_CFG1 unused
ADC0_CFG2 4003B00C

Symbol: ADC0_CFG2
   Definitions
      At line 215 in file ..\Exercise
   Uses
      None
Comment: ADC0_CFG2 unused
ADC0_CLM0 4003B06C

Symbol: ADC0_CLM0
   Definitions
      At line 218 in file ..\Exercise
   Uses
      None
Comment: ADC0_CLM0 unused
ADC0_CLM1 4003B068



ARM Macro Assembler    Page 2 Alphabetic symbol ordering
Absolute symbols


Symbol: ADC0_CLM1
   Definitions
      At line 219 in file ..\Exercise
   Uses
      None
Comment: ADC0_CLM1 unused
ADC0_CLM2 4003B064

Symbol: ADC0_CLM2
   Definitions
      At line 220 in file ..\Exercise
   Uses
      None
Comment: ADC0_CLM2 unused
ADC0_CLM3 4003B060

Symbol: ADC0_CLM3
   Definitions
      At line 221 in file ..\Exercise
   Uses
      None
Comment: ADC0_CLM3 unused
ADC0_CLM4 4003B05C

Symbol: ADC0_CLM4
   Definitions
      At line 222 in file ..\Exercise
   Uses
      None
Comment: ADC0_CLM4 unused
ADC0_CLMD 4003B054

Symbol: ADC0_CLMD
   Definitions
      At line 216 in file ..\Exercise
   Uses
      None
Comment: ADC0_CLMD unused
ADC0_CLMS 4003B058

Symbol: ADC0_CLMS
   Definitions
      At line 217 in file ..\Exercise
   Uses
      None
Comment: ADC0_CLMS unused
ADC0_CLP0 4003B04C

Symbol: ADC0_CLP0
   Definitions
      At line 225 in file ..\Exercise
   Uses
      None
Comment: ADC0_CLP0 unused
ADC0_CLP1 4003B048

Symbol: ADC0_CLP1
   Definitions



ARM Macro Assembler    Page 3 Alphabetic symbol ordering
Absolute symbols

      At line 226 in file ..\Exercise
   Uses
      None
Comment: ADC0_CLP1 unused
ADC0_CLP2 4003B044

Symbol: ADC0_CLP2
   Definitions
      At line 227 in file ..\Exercise
   Uses
      None
Comment: ADC0_CLP2 unused
ADC0_CLP3 4003B040

Symbol: ADC0_CLP3
   Definitions
      At line 228 in file ..\Exercise
   Uses
      None
Comment: ADC0_CLP3 unused
ADC0_CLP4 4003B03C

Symbol: ADC0_CLP4
   Definitions
      At line 229 in file ..\Exercise
   Uses
      None
Comment: ADC0_CLP4 unused
ADC0_CLPD 4003B034

Symbol: ADC0_CLPD
   Definitions
      At line 223 in file ..\Exercise
   Uses
      None
Comment: ADC0_CLPD unused
ADC0_CLPS 4003B038

Symbol: ADC0_CLPS
   Definitions
      At line 224 in file ..\Exercise
   Uses
      None
Comment: ADC0_CLPS unused
ADC0_CV1 4003B018

Symbol: ADC0_CV1
   Definitions
      At line 230 in file ..\Exercise
   Uses
      None
Comment: ADC0_CV1 unused
ADC0_CV2 4003B01C

Symbol: ADC0_CV2
   Definitions
      At line 231 in file ..\Exercise
   Uses
      None



ARM Macro Assembler    Page 4 Alphabetic symbol ordering
Absolute symbols

Comment: ADC0_CV2 unused
ADC0_IPR E000E40C

Symbol: ADC0_IPR
   Definitions
      At line 2678 in file ..\Exercise
   Uses
      None
Comment: ADC0_IPR unused
ADC0_IRQ 0000000F

Symbol: ADC0_IRQ
   Definitions
      At line 2748 in file ..\Exercise
   Uses
      At line 2782 in file ..\Exercise
Comment: ADC0_IRQ used once
ADC0_IRQ_MASK 00008000

Symbol: ADC0_IRQ_MASK
   Definitions
      At line 2782 in file ..\Exercise
   Uses
      None
Comment: ADC0_IRQ_MASK unused
ADC0_IRQn 0000000F

Symbol: ADC0_IRQn
   Definitions
      At line 161 in file ..\Exercise
   Uses
      None
Comment: ADC0_IRQn unused
ADC0_MG 4003B030

Symbol: ADC0_MG
   Definitions
      At line 232 in file ..\Exercise
   Uses
      None
Comment: ADC0_MG unused
ADC0_OFS 4003B028

Symbol: ADC0_OFS
   Definitions
      At line 233 in file ..\Exercise
   Uses
      None
Comment: ADC0_OFS unused
ADC0_PG 4003B02C

Symbol: ADC0_PG
   Definitions
      At line 234 in file ..\Exercise
   Uses
      None
Comment: ADC0_PG unused
ADC0_PRI_POS 0000001E




ARM Macro Assembler    Page 5 Alphabetic symbol ordering
Absolute symbols

Symbol: ADC0_PRI_POS
   Definitions
      At line 2714 in file ..\Exercise
   Uses
      None
Comment: ADC0_PRI_POS unused
ADC0_RA 4003B010

Symbol: ADC0_RA
   Definitions
      At line 235 in file ..\Exercise
   Uses
      None
Comment: ADC0_RA unused
ADC0_RB 4003B014

Symbol: ADC0_RB
   Definitions
      At line 236 in file ..\Exercise
   Uses
      None
Comment: ADC0_RB unused
ADC0_SC1A 4003B000

Symbol: ADC0_SC1A
   Definitions
      At line 237 in file ..\Exercise
   Uses
      None
Comment: ADC0_SC1A unused
ADC0_SC1B 4003B004

Symbol: ADC0_SC1B
   Definitions
      At line 238 in file ..\Exercise
   Uses
      None
Comment: ADC0_SC1B unused
ADC0_SC2 4003B020

Symbol: ADC0_SC2
   Definitions
      At line 239 in file ..\Exercise
   Uses
      None
Comment: ADC0_SC2 unused
ADC0_SC3 4003B024

Symbol: ADC0_SC3
   Definitions
      At line 240 in file ..\Exercise
   Uses
      None
Comment: ADC0_SC3 unused
ADC0_Vector 0000001F

Symbol: ADC0_Vector
   Definitions
      At line 2832 in file ..\Exercise



ARM Macro Assembler    Page 6 Alphabetic symbol ordering
Absolute symbols

   Uses
      None
Comment: ADC0_Vector unused
ADC_ACFE_MASK 00000020

Symbol: ADC_ACFE_MASK
   Definitions
      At line 493 in file ..\Exercise
   Uses
      None
Comment: ADC_ACFE_MASK unused
ADC_ACFE_SHIFT 00000005

Symbol: ADC_ACFE_SHIFT
   Definitions
      At line 494 in file ..\Exercise
   Uses
      None
Comment: ADC_ACFE_SHIFT unused
ADC_ACFGT_MASK 00000010

Symbol: ADC_ACFGT_MASK
   Definitions
      At line 495 in file ..\Exercise
   Uses
      None
Comment: ADC_ACFGT_MASK unused
ADC_ACFGT_SHIFT 00000004

Symbol: ADC_ACFGT_SHIFT
   Definitions
      At line 496 in file ..\Exercise
   Uses
      None
Comment: ADC_ACFGT_SHIFT unused
ADC_ACREN_MASK 00000008

Symbol: ADC_ACREN_MASK
   Definitions
      At line 497 in file ..\Exercise
   Uses
      None
Comment: ADC_ACREN_MASK unused
ADC_ACREN_SHIFT 00000003

Symbol: ADC_ACREN_SHIFT
   Definitions
      At line 498 in file ..\Exercise
   Uses
      None
Comment: ADC_ACREN_SHIFT unused
ADC_ADACT_MASK 00000080

Symbol: ADC_ADACT_MASK
   Definitions
      At line 489 in file ..\Exercise
   Uses
      None
Comment: ADC_ADACT_MASK unused



ARM Macro Assembler    Page 7 Alphabetic symbol ordering
Absolute symbols

ADC_ADACT_SHIFT 00000007

Symbol: ADC_ADACT_SHIFT
   Definitions
      At line 490 in file ..\Exercise
   Uses
      None
Comment: ADC_ADACT_SHIFT unused
ADC_ADCH_MASK 0000001F

Symbol: ADC_ADCH_MASK
   Definitions
      At line 466 in file ..\Exercise
   Uses
      None
Comment: ADC_ADCH_MASK unused
ADC_ADCH_SHIFT 00000000

Symbol: ADC_ADCH_SHIFT
   Definitions
      At line 467 in file ..\Exercise
   Uses
      None
Comment: ADC_ADCH_SHIFT unused
ADC_ADCO_MASK 00000008

Symbol: ADC_ADCO_MASK
   Definitions
      At line 520 in file ..\Exercise
   Uses
      None
Comment: ADC_ADCO_MASK unused
ADC_ADCO_SHIFT 00000003

Symbol: ADC_ADCO_SHIFT
   Definitions
      At line 521 in file ..\Exercise
   Uses
      None
Comment: ADC_ADCO_SHIFT unused
ADC_ADTRG_MASK 00000040

Symbol: ADC_ADTRG_MASK
   Definitions
      At line 491 in file ..\Exercise
   Uses
      None
Comment: ADC_ADTRG_MASK unused
ADC_ADTRG_SHIFT 00000006

Symbol: ADC_ADTRG_SHIFT
   Definitions
      At line 492 in file ..\Exercise
   Uses
      None
Comment: ADC_ADTRG_SHIFT unused
ADC_AIEN_MASK 00000040

Symbol: ADC_AIEN_MASK



ARM Macro Assembler    Page 8 Alphabetic symbol ordering
Absolute symbols

   Definitions
      At line 462 in file ..\Exercise
   Uses
      None
Comment: ADC_AIEN_MASK unused
ADC_AIEN_SHIFT 00000006

Symbol: ADC_AIEN_SHIFT
   Definitions
      At line 463 in file ..\Exercise
   Uses
      None
Comment: ADC_AIEN_SHIFT unused
ADC_AVGE_MASK 00000004

Symbol: ADC_AVGE_MASK
   Definitions
      At line 522 in file ..\Exercise
   Uses
      None
Comment: ADC_AVGE_MASK unused
ADC_AVGE_SHIFT 00000002

Symbol: ADC_AVGE_SHIFT
   Definitions
      At line 523 in file ..\Exercise
   Uses
      None
Comment: ADC_AVGE_SHIFT unused
ADC_AVGS_MASK 00000003

Symbol: ADC_AVGS_MASK
   Definitions
      At line 524 in file ..\Exercise
   Uses
      None
Comment: ADC_AVGS_MASK unused
ADC_AVGS_SHIFT 00000000

Symbol: ADC_AVGS_SHIFT
   Definitions
      At line 525 in file ..\Exercise
   Uses
      None
Comment: ADC_AVGS_SHIFT unused
ADC_CALF_MASK 00000040

Symbol: ADC_CALF_MASK
   Definitions
      At line 518 in file ..\Exercise
   Uses
      None
Comment: ADC_CALF_MASK unused
ADC_CALF_SHIFT 00000006

Symbol: ADC_CALF_SHIFT
   Definitions
      At line 519 in file ..\Exercise
   Uses



ARM Macro Assembler    Page 9 Alphabetic symbol ordering
Absolute symbols

      None
Comment: ADC_CALF_SHIFT unused
ADC_CAL_MASK 00000080

Symbol: ADC_CAL_MASK
   Definitions
      At line 516 in file ..\Exercise
   Uses
      None
Comment: ADC_CAL_MASK unused
ADC_CAL_SHIFT 00000007

Symbol: ADC_CAL_SHIFT
   Definitions
      At line 517 in file ..\Exercise
   Uses
      None
Comment: ADC_CAL_SHIFT unused
ADC_CFG1_ADICLK_MASK 00000003

Symbol: ADC_CFG1_ADICLK_MASK
   Definitions
      At line 272 in file ..\Exercise
   Uses
      None
Comment: ADC_CFG1_ADICLK_MASK unused
ADC_CFG1_ADICLK_SHIFT 00000000

Symbol: ADC_CFG1_ADICLK_SHIFT
   Definitions
      At line 273 in file ..\Exercise
   Uses
      None
Comment: ADC_CFG1_ADICLK_SHIFT unused
ADC_CFG1_ADIV_MASK 00000060

Symbol: ADC_CFG1_ADIV_MASK
   Definitions
      At line 266 in file ..\Exercise
   Uses
      None
Comment: ADC_CFG1_ADIV_MASK unused
ADC_CFG1_ADIV_SHIFT 00000005

Symbol: ADC_CFG1_ADIV_SHIFT
   Definitions
      At line 267 in file ..\Exercise
   Uses
      None
Comment: ADC_CFG1_ADIV_SHIFT unused
ADC_CFG1_ADLPC_MASK 00000080

Symbol: ADC_CFG1_ADLPC_MASK
   Definitions
      At line 264 in file ..\Exercise
   Uses
      None
Comment: ADC_CFG1_ADLPC_MASK unused
ADC_CFG1_ADLPC_SHIFT 00000007



ARM Macro Assembler    Page 10 Alphabetic symbol ordering
Absolute symbols


Symbol: ADC_CFG1_ADLPC_SHIFT
   Definitions
      At line 265 in file ..\Exercise
   Uses
      None
Comment: ADC_CFG1_ADLPC_SHIFT unused
ADC_CFG1_ADLSMP_MASK 00000010

Symbol: ADC_CFG1_ADLSMP_MASK
   Definitions
      At line 268 in file ..\Exercise
   Uses
      None
Comment: ADC_CFG1_ADLSMP_MASK unused
ADC_CFG1_ADLSMP_SHIFT 00000004

Symbol: ADC_CFG1_ADLSMP_SHIFT
   Definitions
      At line 269 in file ..\Exercise
   Uses
      None
Comment: ADC_CFG1_ADLSMP_SHIFT unused
ADC_CFG1_MODE_MASK 0000000C

Symbol: ADC_CFG1_MODE_MASK
   Definitions
      At line 270 in file ..\Exercise
   Uses
      None
Comment: ADC_CFG1_MODE_MASK unused
ADC_CFG1_MODE_SHIFT 00000002

Symbol: ADC_CFG1_MODE_SHIFT
   Definitions
      At line 271 in file ..\Exercise
   Uses
      None
Comment: ADC_CFG1_MODE_SHIFT unused
ADC_CFG1_OFFSET 00000008

Symbol: ADC_CFG1_OFFSET
   Definitions
      At line 189 in file ..\Exercise
   Uses
      At line 214 in file ..\Exercise
Comment: ADC_CFG1_OFFSET used once
ADC_CFG2_ADACKEN_MASK 00000008

Symbol: ADC_CFG2_ADACKEN_MASK
   Definitions
      At line 295 in file ..\Exercise
   Uses
      None
Comment: ADC_CFG2_ADACKEN_MASK unused
ADC_CFG2_ADACKEN_SHIFT 00000003

Symbol: ADC_CFG2_ADACKEN_SHIFT
   Definitions



ARM Macro Assembler    Page 11 Alphabetic symbol ordering
Absolute symbols

      At line 296 in file ..\Exercise
   Uses
      None
Comment: ADC_CFG2_ADACKEN_SHIFT unused
ADC_CFG2_ADHSC_MASK 00000004

Symbol: ADC_CFG2_ADHSC_MASK
   Definitions
      At line 297 in file ..\Exercise
   Uses
      None
Comment: ADC_CFG2_ADHSC_MASK unused
ADC_CFG2_ADHSC_SHIFT 00000002

Symbol: ADC_CFG2_ADHSC_SHIFT
   Definitions
      At line 298 in file ..\Exercise
   Uses
      None
Comment: ADC_CFG2_ADHSC_SHIFT unused
ADC_CFG2_ADLSTS_MASK 00000003

Symbol: ADC_CFG2_ADLSTS_MASK
   Definitions
      At line 299 in file ..\Exercise
   Uses
      None
Comment: ADC_CFG2_ADLSTS_MASK unused
ADC_CFG2_ADLSTS_SHIFT 00000000

Symbol: ADC_CFG2_ADLSTS_SHIFT
   Definitions
      At line 300 in file ..\Exercise
   Uses
      None
Comment: ADC_CFG2_ADLSTS_SHIFT unused
ADC_CFG2_MUXSEL_MASK 00000010

Symbol: ADC_CFG2_MUXSEL_MASK
   Definitions
      At line 293 in file ..\Exercise
   Uses
      None
Comment: ADC_CFG2_MUXSEL_MASK unused
ADC_CFG2_MUXSEL_SHIFT 00000004

Symbol: ADC_CFG2_MUXSEL_SHIFT
   Definitions
      At line 294 in file ..\Exercise
   Uses
      None
Comment: ADC_CFG2_MUXSEL_SHIFT unused
ADC_CFG2_OFFSET 0000000C

Symbol: ADC_CFG2_OFFSET
   Definitions
      At line 190 in file ..\Exercise
   Uses
      At line 215 in file ..\Exercise



ARM Macro Assembler    Page 12 Alphabetic symbol ordering
Absolute symbols

Comment: ADC_CFG2_OFFSET used once
ADC_CLM0_MASK 0000003F

Symbol: ADC_CLM0_MASK
   Definitions
      At line 317 in file ..\Exercise
   Uses
      None
Comment: ADC_CLM0_MASK unused
ADC_CLM0_OFFSET 0000006C

Symbol: ADC_CLM0_OFFSET
   Definitions
      At line 213 in file ..\Exercise
   Uses
      At line 218 in file ..\Exercise
Comment: ADC_CLM0_OFFSET used once
ADC_CLM0_SHIFT 00000000

Symbol: ADC_CLM0_SHIFT
   Definitions
      At line 318 in file ..\Exercise
   Uses
      None
Comment: ADC_CLM0_SHIFT unused
ADC_CLM1_MASK 0000007F

Symbol: ADC_CLM1_MASK
   Definitions
      At line 323 in file ..\Exercise
   Uses
      None
Comment: ADC_CLM1_MASK unused
ADC_CLM1_OFFSET 00000068

Symbol: ADC_CLM1_OFFSET
   Definitions
      At line 212 in file ..\Exercise
   Uses
      At line 219 in file ..\Exercise
Comment: ADC_CLM1_OFFSET used once
ADC_CLM1_SHIFT 00000000

Symbol: ADC_CLM1_SHIFT
   Definitions
      At line 324 in file ..\Exercise
   Uses
      None
Comment: ADC_CLM1_SHIFT unused
ADC_CLM2_MASK 000000FF

Symbol: ADC_CLM2_MASK
   Definitions
      At line 329 in file ..\Exercise
   Uses
      None
Comment: ADC_CLM2_MASK unused
ADC_CLM2_OFFSET 00000064




ARM Macro Assembler    Page 13 Alphabetic symbol ordering
Absolute symbols

Symbol: ADC_CLM2_OFFSET
   Definitions
      At line 211 in file ..\Exercise
   Uses
      At line 220 in file ..\Exercise
Comment: ADC_CLM2_OFFSET used once
ADC_CLM2_SHIFT 00000000

Symbol: ADC_CLM2_SHIFT
   Definitions
      At line 330 in file ..\Exercise
   Uses
      None
Comment: ADC_CLM2_SHIFT unused
ADC_CLM3_MASK 000001FF

Symbol: ADC_CLM3_MASK
   Definitions
      At line 335 in file ..\Exercise
   Uses
      None
Comment: ADC_CLM3_MASK unused
ADC_CLM3_OFFSET 00000060

Symbol: ADC_CLM3_OFFSET
   Definitions
      At line 210 in file ..\Exercise
   Uses
      At line 221 in file ..\Exercise
Comment: ADC_CLM3_OFFSET used once
ADC_CLM3_SHIFT 00000000

Symbol: ADC_CLM3_SHIFT
   Definitions
      At line 336 in file ..\Exercise
   Uses
      None
Comment: ADC_CLM3_SHIFT unused
ADC_CLM4_MASK 000003FF

Symbol: ADC_CLM4_MASK
   Definitions
      At line 341 in file ..\Exercise
   Uses
      None
Comment: ADC_CLM4_MASK unused
ADC_CLM4_OFFSET 0000005C

Symbol: ADC_CLM4_OFFSET
   Definitions
      At line 209 in file ..\Exercise
   Uses
      At line 222 in file ..\Exercise
Comment: ADC_CLM4_OFFSET used once
ADC_CLM4_SHIFT 00000000

Symbol: ADC_CLM4_SHIFT
   Definitions
      At line 342 in file ..\Exercise



ARM Macro Assembler    Page 14 Alphabetic symbol ordering
Absolute symbols

   Uses
      None
Comment: ADC_CLM4_SHIFT unused
ADC_CLMD_MASK 0000003F

Symbol: ADC_CLMD_MASK
   Definitions
      At line 305 in file ..\Exercise
   Uses
      None
Comment: ADC_CLMD_MASK unused
ADC_CLMD_OFFSET 00000054

Symbol: ADC_CLMD_OFFSET
   Definitions
      At line 207 in file ..\Exercise
   Uses
      At line 216 in file ..\Exercise
Comment: ADC_CLMD_OFFSET used once
ADC_CLMD_SHIFT 00000000

Symbol: ADC_CLMD_SHIFT
   Definitions
      At line 306 in file ..\Exercise
   Uses
      None
Comment: ADC_CLMD_SHIFT unused
ADC_CLMS_MASK 0000003F

Symbol: ADC_CLMS_MASK
   Definitions
      At line 311 in file ..\Exercise
   Uses
      None
Comment: ADC_CLMS_MASK unused
ADC_CLMS_OFFSET 00000058

Symbol: ADC_CLMS_OFFSET
   Definitions
      At line 208 in file ..\Exercise
   Uses
      At line 217 in file ..\Exercise
Comment: ADC_CLMS_OFFSET used once
ADC_CLMS_SHIFT 00000000

Symbol: ADC_CLMS_SHIFT
   Definitions
      At line 312 in file ..\Exercise
   Uses
      None
Comment: ADC_CLMS_SHIFT unused
ADC_CLP0_MASK 0000003F

Symbol: ADC_CLP0_MASK
   Definitions
      At line 359 in file ..\Exercise
   Uses
      None
Comment: ADC_CLP0_MASK unused



ARM Macro Assembler    Page 15 Alphabetic symbol ordering
Absolute symbols

ADC_CLP0_OFFSET 0000004C

Symbol: ADC_CLP0_OFFSET
   Definitions
      At line 206 in file ..\Exercise
   Uses
      At line 225 in file ..\Exercise
Comment: ADC_CLP0_OFFSET used once
ADC_CLP0_SHIFT 00000000

Symbol: ADC_CLP0_SHIFT
   Definitions
      At line 360 in file ..\Exercise
   Uses
      None
Comment: ADC_CLP0_SHIFT unused
ADC_CLP1_MASK 0000007F

Symbol: ADC_CLP1_MASK
   Definitions
      At line 365 in file ..\Exercise
   Uses
      None
Comment: ADC_CLP1_MASK unused
ADC_CLP1_OFFSET 00000048

Symbol: ADC_CLP1_OFFSET
   Definitions
      At line 205 in file ..\Exercise
   Uses
      At line 226 in file ..\Exercise
Comment: ADC_CLP1_OFFSET used once
ADC_CLP1_SHIFT 00000000

Symbol: ADC_CLP1_SHIFT
   Definitions
      At line 366 in file ..\Exercise
   Uses
      None
Comment: ADC_CLP1_SHIFT unused
ADC_CLP2_MASK 000000FF

Symbol: ADC_CLP2_MASK
   Definitions
      At line 371 in file ..\Exercise
   Uses
      None
Comment: ADC_CLP2_MASK unused
ADC_CLP2_OFFSET 00000044

Symbol: ADC_CLP2_OFFSET
   Definitions
      At line 204 in file ..\Exercise
   Uses
      At line 227 in file ..\Exercise
Comment: ADC_CLP2_OFFSET used once
ADC_CLP2_SHIFT 00000000

Symbol: ADC_CLP2_SHIFT



ARM Macro Assembler    Page 16 Alphabetic symbol ordering
Absolute symbols

   Definitions
      At line 372 in file ..\Exercise
   Uses
      None
Comment: ADC_CLP2_SHIFT unused
ADC_CLP3_MASK 000001FF

Symbol: ADC_CLP3_MASK
   Definitions
      At line 377 in file ..\Exercise
   Uses
      None
Comment: ADC_CLP3_MASK unused
ADC_CLP3_OFFSET 00000040

Symbol: ADC_CLP3_OFFSET
   Definitions
      At line 203 in file ..\Exercise
   Uses
      At line 228 in file ..\Exercise
Comment: ADC_CLP3_OFFSET used once
ADC_CLP3_SHIFT 00000000

Symbol: ADC_CLP3_SHIFT
   Definitions
      At line 378 in file ..\Exercise
   Uses
      None
Comment: ADC_CLP3_SHIFT unused
ADC_CLP4_MASK 000003FF

Symbol: ADC_CLP4_MASK
   Definitions
      At line 383 in file ..\Exercise
   Uses
      None
Comment: ADC_CLP4_MASK unused
ADC_CLP4_OFFSET 0000003C

Symbol: ADC_CLP4_OFFSET
   Definitions
      At line 202 in file ..\Exercise
   Uses
      At line 229 in file ..\Exercise
Comment: ADC_CLP4_OFFSET used once
ADC_CLP4_SHIFT 00000000

Symbol: ADC_CLP4_SHIFT
   Definitions
      At line 384 in file ..\Exercise
   Uses
      None
Comment: ADC_CLP4_SHIFT unused
ADC_CLPD_MASK 0000003F

Symbol: ADC_CLPD_MASK
   Definitions
      At line 347 in file ..\Exercise
   Uses



ARM Macro Assembler    Page 17 Alphabetic symbol ordering
Absolute symbols

      None
Comment: ADC_CLPD_MASK unused
ADC_CLPD_OFFSET 00000034

Symbol: ADC_CLPD_OFFSET
   Definitions
      At line 200 in file ..\Exercise
   Uses
      At line 223 in file ..\Exercise
Comment: ADC_CLPD_OFFSET used once
ADC_CLPD_SHIFT 00000000

Symbol: ADC_CLPD_SHIFT
   Definitions
      At line 348 in file ..\Exercise
   Uses
      None
Comment: ADC_CLPD_SHIFT unused
ADC_CLPS_MASK 0000003F

Symbol: ADC_CLPS_MASK
   Definitions
      At line 353 in file ..\Exercise
   Uses
      None
Comment: ADC_CLPS_MASK unused
ADC_CLPS_OFFSET 00000038

Symbol: ADC_CLPS_OFFSET
   Definitions
      At line 201 in file ..\Exercise
   Uses
      At line 224 in file ..\Exercise
Comment: ADC_CLPS_OFFSET used once
ADC_CLPS_SHIFT 00000000

Symbol: ADC_CLPS_SHIFT
   Definitions
      At line 354 in file ..\Exercise
   Uses
      None
Comment: ADC_CLPS_SHIFT unused
ADC_COCO_MASK 00000080

Symbol: ADC_COCO_MASK
   Definitions
      At line 460 in file ..\Exercise
   Uses
      None
Comment: ADC_COCO_MASK unused
ADC_COCO_SHIFT 00000007

Symbol: ADC_COCO_SHIFT
   Definitions
      At line 461 in file ..\Exercise
   Uses
      None
Comment: ADC_COCO_SHIFT unused
ADC_CV1_OFFSET 00000018



ARM Macro Assembler    Page 18 Alphabetic symbol ordering
Absolute symbols


Symbol: ADC_CV1_OFFSET
   Definitions
      At line 193 in file ..\Exercise
   Uses
      At line 230 in file ..\Exercise
Comment: ADC_CV1_OFFSET used once
ADC_CV2_OFFSET 0000001C

Symbol: ADC_CV2_OFFSET
   Definitions
      At line 194 in file ..\Exercise
   Uses
      At line 231 in file ..\Exercise
Comment: ADC_CV2_OFFSET used once
ADC_CV_MASK 0000FFFF

Symbol: ADC_CV_MASK
   Definitions
      At line 391 in file ..\Exercise
   Uses
      None
Comment: ADC_CV_MASK unused
ADC_CV_SHIFT 00000000

Symbol: ADC_CV_SHIFT
   Definitions
      At line 392 in file ..\Exercise
   Uses
      None
Comment: ADC_CV_SHIFT unused
ADC_DIFF_MASK 00000020

Symbol: ADC_DIFF_MASK
   Definitions
      At line 464 in file ..\Exercise
   Uses
      None
Comment: ADC_DIFF_MASK unused
ADC_DIFF_SHIFT 00000005

Symbol: ADC_DIFF_SHIFT
   Definitions
      At line 465 in file ..\Exercise
   Uses
      None
Comment: ADC_DIFF_SHIFT unused
ADC_DMAEN_MASK 00000004

Symbol: ADC_DMAEN_MASK
   Definitions
      At line 499 in file ..\Exercise
   Uses
      None
Comment: ADC_DMAEN_MASK unused
ADC_DMAEN_SHIFT 00000002

Symbol: ADC_DMAEN_SHIFT
   Definitions



ARM Macro Assembler    Page 19 Alphabetic symbol ordering
Absolute symbols

      At line 500 in file ..\Exercise
   Uses
      None
Comment: ADC_DMAEN_SHIFT unused
ADC_D_MASK 0000FFFF

Symbol: ADC_D_MASK
   Definitions
      At line 415 in file ..\Exercise
   Uses
      None
Comment: ADC_D_MASK unused
ADC_D_SHIFT 00000000

Symbol: ADC_D_SHIFT
   Definitions
      At line 416 in file ..\Exercise
   Uses
      None
Comment: ADC_D_SHIFT unused
ADC_MG_MASK 0000FFFF

Symbol: ADC_MG_MASK
   Definitions
      At line 397 in file ..\Exercise
   Uses
      None
Comment: ADC_MG_MASK unused
ADC_MG_OFFSET 00000030

Symbol: ADC_MG_OFFSET
   Definitions
      At line 199 in file ..\Exercise
   Uses
      At line 232 in file ..\Exercise
Comment: ADC_MG_OFFSET used once
ADC_MG_SHIFT 00000000

Symbol: ADC_MG_SHIFT
   Definitions
      At line 398 in file ..\Exercise
   Uses
      None
Comment: ADC_MG_SHIFT unused
ADC_OFS_MASK 0000FFFF

Symbol: ADC_OFS_MASK
   Definitions
      At line 403 in file ..\Exercise
   Uses
      None
Comment: ADC_OFS_MASK unused
ADC_OFS_OFFSET 00000028

Symbol: ADC_OFS_OFFSET
   Definitions
      At line 197 in file ..\Exercise
   Uses
      At line 233 in file ..\Exercise



ARM Macro Assembler    Page 20 Alphabetic symbol ordering
Absolute symbols

Comment: ADC_OFS_OFFSET used once
ADC_OFS_SHIFT 00000000

Symbol: ADC_OFS_SHIFT
   Definitions
      At line 404 in file ..\Exercise
   Uses
      None
Comment: ADC_OFS_SHIFT unused
ADC_PG_MASK 0000FFFF

Symbol: ADC_PG_MASK
   Definitions
      At line 409 in file ..\Exercise
   Uses
      None
Comment: ADC_PG_MASK unused
ADC_PG_OFFSET 0000002C

Symbol: ADC_PG_OFFSET
   Definitions
      At line 198 in file ..\Exercise
   Uses
      At line 234 in file ..\Exercise
Comment: ADC_PG_OFFSET used once
ADC_PG_SHIFT 00000000

Symbol: ADC_PG_SHIFT
   Definitions
      At line 410 in file ..\Exercise
   Uses
      None
Comment: ADC_PG_SHIFT unused
ADC_RA_OFFSET 00000010

Symbol: ADC_RA_OFFSET
   Definitions
      At line 191 in file ..\Exercise
   Uses
      At line 235 in file ..\Exercise
Comment: ADC_RA_OFFSET used once
ADC_RB_OFFSET 00000014

Symbol: ADC_RB_OFFSET
   Definitions
      At line 192 in file ..\Exercise
   Uses
      At line 236 in file ..\Exercise
Comment: ADC_RB_OFFSET used once
ADC_REFSEL_MASK 00000003

Symbol: ADC_REFSEL_MASK
   Definitions
      At line 501 in file ..\Exercise
   Uses
      None
Comment: ADC_REFSEL_MASK unused
ADC_REFSEL_SHIFT 00000000




ARM Macro Assembler    Page 21 Alphabetic symbol ordering
Absolute symbols

Symbol: ADC_REFSEL_SHIFT
   Definitions
      At line 502 in file ..\Exercise
   Uses
      None
Comment: ADC_REFSEL_SHIFT unused
ADC_SC1A_OFFSET 00000000

Symbol: ADC_SC1A_OFFSET
   Definitions
      At line 187 in file ..\Exercise
   Uses
      At line 237 in file ..\Exercise
Comment: ADC_SC1A_OFFSET used once
ADC_SC1B_OFFSET 00000004

Symbol: ADC_SC1B_OFFSET
   Definitions
      At line 188 in file ..\Exercise
   Uses
      At line 238 in file ..\Exercise
Comment: ADC_SC1B_OFFSET used once
ADC_SC2_OFFSET 00000020

Symbol: ADC_SC2_OFFSET
   Definitions
      At line 195 in file ..\Exercise
   Uses
      At line 239 in file ..\Exercise
Comment: ADC_SC2_OFFSET used once
ADC_SC3_OFFSET 00000024

Symbol: ADC_SC3_OFFSET
   Definitions
      At line 196 in file ..\Exercise
   Uses
      At line 240 in file ..\Exercise
Comment: ADC_SC3_OFFSET used once
APSR_C_MASK 20000000

Symbol: APSR_C_MASK
   Definitions
      At line 80 in file ..\Exercise
   Uses
      At line 119 in file ..\Exercise
Comment: APSR_C_MASK used once
APSR_C_SHIFT 0000001D

Symbol: APSR_C_SHIFT
   Definitions
      At line 81 in file ..\Exercise
   Uses
      At line 120 in file ..\Exercise
Comment: APSR_C_SHIFT used once
APSR_MASK F0000000

Symbol: APSR_MASK
   Definitions
      At line 74 in file ..\Exercise



ARM Macro Assembler    Page 22 Alphabetic symbol ordering
Absolute symbols

   Uses
      None
Comment: APSR_MASK unused
APSR_N_MASK 80000000

Symbol: APSR_N_MASK
   Definitions
      At line 76 in file ..\Exercise
   Uses
      At line 115 in file ..\Exercise
Comment: APSR_N_MASK used once
APSR_N_SHIFT 0000001F

Symbol: APSR_N_SHIFT
   Definitions
      At line 77 in file ..\Exercise
   Uses
      At line 116 in file ..\Exercise
Comment: APSR_N_SHIFT used once
APSR_SHIFT 0000001C

Symbol: APSR_SHIFT
   Definitions
      At line 75 in file ..\Exercise
   Uses
      None
Comment: APSR_SHIFT unused
APSR_V_MASK 10000000

Symbol: APSR_V_MASK
   Definitions
      At line 82 in file ..\Exercise
   Uses
      At line 121 in file ..\Exercise
Comment: APSR_V_MASK used once
APSR_V_SHIFT 0000001C

Symbol: APSR_V_SHIFT
   Definitions
      At line 83 in file ..\Exercise
   Uses
      At line 122 in file ..\Exercise
Comment: APSR_V_SHIFT used once
APSR_Z_MASK 40000000

Symbol: APSR_Z_MASK
   Definitions
      At line 78 in file ..\Exercise
   Uses
      At line 117 in file ..\Exercise
Comment: APSR_Z_MASK used once
APSR_Z_SHIFT 0000001E

Symbol: APSR_Z_SHIFT
   Definitions
      At line 79 in file ..\Exercise
   Uses
      At line 118 in file ..\Exercise
Comment: APSR_Z_SHIFT used once



ARM Macro Assembler    Page 23 Alphabetic symbol ordering
Absolute symbols

BUF_PAST 0000000C

Symbol: BUF_PAST
   Definitions
      At line 223 in file ..\Exercise
   Uses
      At line 453 in file ..\Exercise
      At line 483 in file ..\Exercise
      At line 526 in file ..\Exercise

BUF_SIZE 00000010

Symbol: BUF_SIZE
   Definitions
      At line 224 in file ..\Exercise
   Uses
      At line 454 in file ..\Exercise
      At line 522 in file ..\Exercise

BUF_STRT 00000008

Symbol: BUF_STRT
   Definitions
      At line 222 in file ..\Exercise
   Uses
      At line 450 in file ..\Exercise
      At line 486 in file ..\Exercise
      At line 533 in file ..\Exercise

BYTE_BITS 00000008

Symbol: BYTE_BITS
   Definitions
      At line 26 in file ..\Exercise
   Uses
      None
Comment: BYTE_BITS unused
BYTE_MASK 000000FF

Symbol: BYTE_MASK
   Definitions
      At line 23 in file ..\Exercise
   Uses
      None
Comment: BYTE_MASK unused
CMP0_BASE 40073000

Symbol: CMP0_BASE
   Definitions
      At line 528 in file ..\Exercise
   Uses
      At line 535 in file ..\Exercise
      At line 536 in file ..\Exercise
      At line 537 in file ..\Exercise
      At line 538 in file ..\Exercise
      At line 539 in file ..\Exercise
      At line 540 in file ..\Exercise

CMP0_CR0 40073000



ARM Macro Assembler    Page 24 Alphabetic symbol ordering
Absolute symbols


Symbol: CMP0_CR0
   Definitions
      At line 535 in file ..\Exercise
   Uses
      None
Comment: CMP0_CR0 unused
CMP0_CR0_OFFSET 00000000

Symbol: CMP0_CR0_OFFSET
   Definitions
      At line 529 in file ..\Exercise
   Uses
      At line 535 in file ..\Exercise
Comment: CMP0_CR0_OFFSET used once
CMP0_CR1 40073001

Symbol: CMP0_CR1
   Definitions
      At line 536 in file ..\Exercise
   Uses
      None
Comment: CMP0_CR1 unused
CMP0_CR1_OFFSET 00000001

Symbol: CMP0_CR1_OFFSET
   Definitions
      At line 530 in file ..\Exercise
   Uses
      At line 536 in file ..\Exercise
Comment: CMP0_CR1_OFFSET used once
CMP0_DACCR 40073004

Symbol: CMP0_DACCR
   Definitions
      At line 539 in file ..\Exercise
   Uses
      None
Comment: CMP0_DACCR unused
CMP0_DACCR_OFFSET 00000004

Symbol: CMP0_DACCR_OFFSET
   Definitions
      At line 533 in file ..\Exercise
   Uses
      At line 539 in file ..\Exercise
Comment: CMP0_DACCR_OFFSET used once
CMP0_FPR 40073002

Symbol: CMP0_FPR
   Definitions
      At line 537 in file ..\Exercise
   Uses
      None
Comment: CMP0_FPR unused
CMP0_FPR_OFFSET 00000002

Symbol: CMP0_FPR_OFFSET
   Definitions



ARM Macro Assembler    Page 25 Alphabetic symbol ordering
Absolute symbols

      At line 531 in file ..\Exercise
   Uses
      At line 537 in file ..\Exercise
Comment: CMP0_FPR_OFFSET used once
CMP0_IPR E000E410

Symbol: CMP0_IPR
   Definitions
      At line 2679 in file ..\Exercise
   Uses
      None
Comment: CMP0_IPR unused
CMP0_IRQ 00000010

Symbol: CMP0_IRQ
   Definitions
      At line 2749 in file ..\Exercise
   Uses
      At line 2783 in file ..\Exercise
Comment: CMP0_IRQ used once
CMP0_IRQ_MASK 00010000

Symbol: CMP0_IRQ_MASK
   Definitions
      At line 2783 in file ..\Exercise
   Uses
      None
Comment: CMP0_IRQ_MASK unused
CMP0_IRQn 00000010

Symbol: CMP0_IRQn
   Definitions
      At line 162 in file ..\Exercise
   Uses
      None
Comment: CMP0_IRQn unused
CMP0_MUXCR 40073005

Symbol: CMP0_MUXCR
   Definitions
      At line 540 in file ..\Exercise
   Uses
      None
Comment: CMP0_MUXCR unused
CMP0_MUXCR_OFFSET 00000005

Symbol: CMP0_MUXCR_OFFSET
   Definitions
      At line 534 in file ..\Exercise
   Uses
      At line 540 in file ..\Exercise
Comment: CMP0_MUXCR_OFFSET used once
CMP0_PRI_POS 00000006

Symbol: CMP0_PRI_POS
   Definitions
      At line 2715 in file ..\Exercise
   Uses
      None



ARM Macro Assembler    Page 26 Alphabetic symbol ordering
Absolute symbols

Comment: CMP0_PRI_POS unused
CMP0_SCR 40073003

Symbol: CMP0_SCR
   Definitions
      At line 538 in file ..\Exercise
   Uses
      None
Comment: CMP0_SCR unused
CMP0_SCR_OFFSET 00000003

Symbol: CMP0_SCR_OFFSET
   Definitions
      At line 532 in file ..\Exercise
   Uses
      At line 538 in file ..\Exercise
Comment: CMP0_SCR_OFFSET used once
CMP0_Vector 00000020

Symbol: CMP0_Vector
   Definitions
      At line 2833 in file ..\Exercise
   Uses
      None
Comment: CMP0_Vector unused
CMP_CR0_FILTER_CNT_MASK 00000070

Symbol: CMP_CR0_FILTER_CNT_MASK
   Definitions
      At line 550 in file ..\Exercise
   Uses
      None
Comment: CMP_CR0_FILTER_CNT_MASK unused
CMP_CR0_FILTER_CNT_SHIFT 00000004

Symbol: CMP_CR0_FILTER_CNT_SHIFT
   Definitions
      At line 551 in file ..\Exercise
   Uses
      None
Comment: CMP_CR0_FILTER_CNT_SHIFT unused
CMP_CR0_HYSTCTR_MASK 00000003

Symbol: CMP_CR0_HYSTCTR_MASK
   Definitions
      At line 548 in file ..\Exercise
   Uses
      None
Comment: CMP_CR0_HYSTCTR_MASK unused
CMP_CR0_HYSTCTR_SHIFT 00000000

Symbol: CMP_CR0_HYSTCTR_SHIFT
   Definitions
      At line 549 in file ..\Exercise
   Uses
      None
Comment: CMP_CR0_HYSTCTR_SHIFT unused
CMP_CR1_COS_MASK 00000004




ARM Macro Assembler    Page 27 Alphabetic symbol ordering
Absolute symbols

Symbol: CMP_CR1_COS_MASK
   Definitions
      At line 566 in file ..\Exercise
   Uses
      None
Comment: CMP_CR1_COS_MASK unused
CMP_CR1_COS_SHIFT 00000002

Symbol: CMP_CR1_COS_SHIFT
   Definitions
      At line 567 in file ..\Exercise
   Uses
      None
Comment: CMP_CR1_COS_SHIFT unused
CMP_CR1_EN_MASK 00000001

Symbol: CMP_CR1_EN_MASK
   Definitions
      At line 562 in file ..\Exercise
   Uses
      None
Comment: CMP_CR1_EN_MASK unused
CMP_CR1_EN_SHIFT 00000000

Symbol: CMP_CR1_EN_SHIFT
   Definitions
      At line 563 in file ..\Exercise
   Uses
      None
Comment: CMP_CR1_EN_SHIFT unused
CMP_CR1_INV_MASK 00000008

Symbol: CMP_CR1_INV_MASK
   Definitions
      At line 568 in file ..\Exercise
   Uses
      None
Comment: CMP_CR1_INV_MASK unused
CMP_CR1_INV_SHIFT 00000003

Symbol: CMP_CR1_INV_SHIFT
   Definitions
      At line 569 in file ..\Exercise
   Uses
      None
Comment: CMP_CR1_INV_SHIFT unused
CMP_CR1_OPE_MASK 00000002

Symbol: CMP_CR1_OPE_MASK
   Definitions
      At line 564 in file ..\Exercise
   Uses
      None
Comment: CMP_CR1_OPE_MASK unused
CMP_CR1_OPE_SHIFT 00000001

Symbol: CMP_CR1_OPE_SHIFT
   Definitions
      At line 565 in file ..\Exercise



ARM Macro Assembler    Page 28 Alphabetic symbol ordering
Absolute symbols

   Uses
      None
Comment: CMP_CR1_OPE_SHIFT unused
CMP_CR1_PMODE_MASK 00000010

Symbol: CMP_CR1_PMODE_MASK
   Definitions
      At line 570 in file ..\Exercise
   Uses
      None
Comment: CMP_CR1_PMODE_MASK unused
CMP_CR1_PMODE_SHIFT 00000004

Symbol: CMP_CR1_PMODE_SHIFT
   Definitions
      At line 571 in file ..\Exercise
   Uses
      None
Comment: CMP_CR1_PMODE_SHIFT unused
CMP_CR1_SE_MASK 00000080

Symbol: CMP_CR1_SE_MASK
   Definitions
      At line 576 in file ..\Exercise
   Uses
      None
Comment: CMP_CR1_SE_MASK unused
CMP_CR1_SE_SHIFT 00000007

Symbol: CMP_CR1_SE_SHIFT
   Definitions
      At line 577 in file ..\Exercise
   Uses
      None
Comment: CMP_CR1_SE_SHIFT unused
CMP_CR1_TRIGM_MASK 00000020

Symbol: CMP_CR1_TRIGM_MASK
   Definitions
      At line 572 in file ..\Exercise
   Uses
      None
Comment: CMP_CR1_TRIGM_MASK unused
CMP_CR1_TRIGM_SHIFT 00000005

Symbol: CMP_CR1_TRIGM_SHIFT
   Definitions
      At line 573 in file ..\Exercise
   Uses
      None
Comment: CMP_CR1_TRIGM_SHIFT unused
CMP_CR1_WE_MASK 00000040

Symbol: CMP_CR1_WE_MASK
   Definitions
      At line 574 in file ..\Exercise
   Uses
      None
Comment: CMP_CR1_WE_MASK unused



ARM Macro Assembler    Page 29 Alphabetic symbol ordering
Absolute symbols

CMP_CR1_WE_SHIFT 00000006

Symbol: CMP_CR1_WE_SHIFT
   Definitions
      At line 575 in file ..\Exercise
   Uses
      None
Comment: CMP_CR1_WE_SHIFT unused
CMP_DACCR_DACEN_MASK 00000080

Symbol: CMP_DACCR_DACEN_MASK
   Definitions
      At line 615 in file ..\Exercise
   Uses
      None
Comment: CMP_DACCR_DACEN_MASK unused
CMP_DACCR_DACEN_SHIFT 00000007

Symbol: CMP_DACCR_DACEN_SHIFT
   Definitions
      At line 616 in file ..\Exercise
   Uses
      None
Comment: CMP_DACCR_DACEN_SHIFT unused
CMP_DACCR_VOSEL_MASK 0000003F

Symbol: CMP_DACCR_VOSEL_MASK
   Definitions
      At line 611 in file ..\Exercise
   Uses
      None
Comment: CMP_DACCR_VOSEL_MASK unused
CMP_DACCR_VOSEL_SHIFT 00000000

Symbol: CMP_DACCR_VOSEL_SHIFT
   Definitions
      At line 612 in file ..\Exercise
   Uses
      None
Comment: CMP_DACCR_VOSEL_SHIFT unused
CMP_DACCR_VRSEL_MASK 00000040

Symbol: CMP_DACCR_VRSEL_MASK
   Definitions
      At line 613 in file ..\Exercise
   Uses
      None
Comment: CMP_DACCR_VRSEL_MASK unused
CMP_DACCR_VRSEL_SHIFT 00000006

Symbol: CMP_DACCR_VRSEL_SHIFT
   Definitions
      At line 614 in file ..\Exercise
   Uses
      None
Comment: CMP_DACCR_VRSEL_SHIFT unused
CMP_FPR_FILT_PER_MASK 000000FF

Symbol: CMP_FPR_FILT_PER_MASK



ARM Macro Assembler    Page 30 Alphabetic symbol ordering
Absolute symbols

   Definitions
      At line 581 in file ..\Exercise
   Uses
      None
Comment: CMP_FPR_FILT_PER_MASK unused
CMP_FPR_FILT_PER_SHIFT 00000000

Symbol: CMP_FPR_FILT_PER_SHIFT
   Definitions
      At line 582 in file ..\Exercise
   Uses
      None
Comment: CMP_FPR_FILT_PER_SHIFT unused
CMP_MUXCR_MSEL_MASK 00000007

Symbol: CMP_MUXCR_MSEL_MASK
   Definitions
      At line 624 in file ..\Exercise
   Uses
      None
Comment: CMP_MUXCR_MSEL_MASK unused
CMP_MUXCR_MSEL_SHIFT 00000000

Symbol: CMP_MUXCR_MSEL_SHIFT
   Definitions
      At line 625 in file ..\Exercise
   Uses
      None
Comment: CMP_MUXCR_MSEL_SHIFT unused
CMP_MUXCR_PSEL_MASK 00000038

Symbol: CMP_MUXCR_PSEL_MASK
   Definitions
      At line 626 in file ..\Exercise
   Uses
      None
Comment: CMP_MUXCR_PSEL_MASK unused
CMP_MUXCR_PSEL_SHIFT 00000003

Symbol: CMP_MUXCR_PSEL_SHIFT
   Definitions
      At line 627 in file ..\Exercise
   Uses
      None
Comment: CMP_MUXCR_PSEL_SHIFT unused
CMP_MUXCR_PSTM_MASK 00000080

Symbol: CMP_MUXCR_PSTM_MASK
   Definitions
      At line 628 in file ..\Exercise
   Uses
      None
Comment: CMP_MUXCR_PSTM_MASK unused
CMP_MUXCR_PSTM_SHIFT 00000007

Symbol: CMP_MUXCR_PSTM_SHIFT
   Definitions
      At line 629 in file ..\Exercise
   Uses



ARM Macro Assembler    Page 31 Alphabetic symbol ordering
Absolute symbols

      None
Comment: CMP_MUXCR_PSTM_SHIFT unused
CMP_SCR_CFF_MASK 00000002

Symbol: CMP_SCR_CFF_MASK
   Definitions
      At line 595 in file ..\Exercise
   Uses
      None
Comment: CMP_SCR_CFF_MASK unused
CMP_SCR_CFF_SHIFT 00000001

Symbol: CMP_SCR_CFF_SHIFT
   Definitions
      At line 596 in file ..\Exercise
   Uses
      None
Comment: CMP_SCR_CFF_SHIFT unused
CMP_SCR_CFR_MASK 00000004

Symbol: CMP_SCR_CFR_MASK
   Definitions
      At line 597 in file ..\Exercise
   Uses
      None
Comment: CMP_SCR_CFR_MASK unused
CMP_SCR_CFR_SHIFT 00000002

Symbol: CMP_SCR_CFR_SHIFT
   Definitions
      At line 598 in file ..\Exercise
   Uses
      None
Comment: CMP_SCR_CFR_SHIFT unused
CMP_SCR_COUT_MASK 00000001

Symbol: CMP_SCR_COUT_MASK
   Definitions
      At line 593 in file ..\Exercise
   Uses
      None
Comment: CMP_SCR_COUT_MASK unused
CMP_SCR_COUT_SHIFT 00000000

Symbol: CMP_SCR_COUT_SHIFT
   Definitions
      At line 594 in file ..\Exercise
   Uses
      None
Comment: CMP_SCR_COUT_SHIFT unused
CMP_SCR_DMAEN_MASK 00000040

Symbol: CMP_SCR_DMAEN_MASK
   Definitions
      At line 603 in file ..\Exercise
   Uses
      None
Comment: CMP_SCR_DMAEN_MASK unused
CMP_SCR_DMAEN_SHIFT 00000006



ARM Macro Assembler    Page 32 Alphabetic symbol ordering
Absolute symbols


Symbol: CMP_SCR_DMAEN_SHIFT
   Definitions
      At line 604 in file ..\Exercise
   Uses
      None
Comment: CMP_SCR_DMAEN_SHIFT unused
CMP_SCR_IEF_MASK 00000008

Symbol: CMP_SCR_IEF_MASK
   Definitions
      At line 599 in file ..\Exercise
   Uses
      None
Comment: CMP_SCR_IEF_MASK unused
CMP_SCR_IEF_SHIFT 00000003

Symbol: CMP_SCR_IEF_SHIFT
   Definitions
      At line 600 in file ..\Exercise
   Uses
      None
Comment: CMP_SCR_IEF_SHIFT unused
CMP_SCR_IER_MASK 00000010

Symbol: CMP_SCR_IER_MASK
   Definitions
      At line 601 in file ..\Exercise
   Uses
      None
Comment: CMP_SCR_IER_MASK unused
CMP_SCR_IER_SHIFT 00000004

Symbol: CMP_SCR_IER_SHIFT
   Definitions
      At line 602 in file ..\Exercise
   Uses
      None
Comment: CMP_SCR_IER_SHIFT unused
CONTROL_SPSEL_MASK 00000002

Symbol: CONTROL_SPSEL_MASK
   Definitions
      At line 50 in file ..\Exercise
   Uses
      None
Comment: CONTROL_SPSEL_MASK unused
CONTROL_SPSEL_SHIFT 00000001

Symbol: CONTROL_SPSEL_SHIFT
   Definitions
      At line 51 in file ..\Exercise
   Uses
      None
Comment: CONTROL_SPSEL_SHIFT unused
CONTROL_nPRIV_MASK 00000001

Symbol: CONTROL_nPRIV_MASK
   Definitions



ARM Macro Assembler    Page 33 Alphabetic symbol ordering
Absolute symbols

      At line 52 in file ..\Exercise
   Uses
      None
Comment: CONTROL_nPRIV_MASK unused
CONTROL_nPRIV_SHIFT 00000000

Symbol: CONTROL_nPRIV_SHIFT
   Definitions
      At line 53 in file ..\Exercise
   Uses
      None
Comment: CONTROL_nPRIV_SHIFT unused
COP_COPCLKS_MASK 00000002

Symbol: COP_COPCLKS_MASK
   Definitions
      At line 3454 in file ..\Exercise
   Uses
      None
Comment: COP_COPCLKS_MASK unused
COP_COPCLKS_SHIFT 00000001

Symbol: COP_COPCLKS_SHIFT
   Definitions
      At line 3455 in file ..\Exercise
   Uses
      None
Comment: COP_COPCLKS_SHIFT unused
COP_COPT_MASK 0000000C

Symbol: COP_COPT_MASK
   Definitions
      At line 3452 in file ..\Exercise
   Uses
      None
Comment: COP_COPT_MASK unused
COP_COPT_SHIFT 00000002

Symbol: COP_COPT_SHIFT
   Definitions
      At line 3453 in file ..\Exercise
   Uses
      None
Comment: COP_COPT_SHIFT unused
COP_COPW_MASK 00000001

Symbol: COP_COPW_MASK
   Definitions
      At line 3456 in file ..\Exercise
   Uses
      None
Comment: COP_COPW_MASK unused
COP_COPW_SHIFT 00000001

Symbol: COP_COPW_SHIFT
   Definitions
      At line 3457 in file ..\Exercise
   Uses
      None



ARM Macro Assembler    Page 34 Alphabetic symbol ordering
Absolute symbols

Comment: COP_COPW_SHIFT unused
DAC0_BASE 4003F000

Symbol: DAC0_BASE
   Definitions
      At line 632 in file ..\Exercise
   Uses
      At line 641 in file ..\Exercise
      At line 642 in file ..\Exercise
      At line 643 in file ..\Exercise
      At line 644 in file ..\Exercise
      At line 645 in file ..\Exercise
      At line 646 in file ..\Exercise
      At line 647 in file ..\Exercise
      At line 648 in file ..\Exercise

DAC0_C0 4003F021

Symbol: DAC0_C0
   Definitions
      At line 646 in file ..\Exercise
   Uses
      None
Comment: DAC0_C0 unused
DAC0_C0_OFFSET 00000021

Symbol: DAC0_C0_OFFSET
   Definitions
      At line 638 in file ..\Exercise
   Uses
      At line 646 in file ..\Exercise
Comment: DAC0_C0_OFFSET used once
DAC0_C1 4003F022

Symbol: DAC0_C1
   Definitions
      At line 647 in file ..\Exercise
   Uses
      None
Comment: DAC0_C1 unused
DAC0_C1_OFFSET 00000022

Symbol: DAC0_C1_OFFSET
   Definitions
      At line 639 in file ..\Exercise
   Uses
      At line 647 in file ..\Exercise
Comment: DAC0_C1_OFFSET used once
DAC0_C2 4003F023

Symbol: DAC0_C2
   Definitions
      At line 648 in file ..\Exercise
   Uses
      None
Comment: DAC0_C2 unused
DAC0_C2_OFFSET 00000023

Symbol: DAC0_C2_OFFSET



ARM Macro Assembler    Page 35 Alphabetic symbol ordering
Absolute symbols

   Definitions
      At line 640 in file ..\Exercise
   Uses
      At line 648 in file ..\Exercise
Comment: DAC0_C2_OFFSET used once
DAC0_DAT0H 4003F001

Symbol: DAC0_DAT0H
   Definitions
      At line 642 in file ..\Exercise
   Uses
      None
Comment: DAC0_DAT0H unused
DAC0_DAT0H_OFFSET 00000001

Symbol: DAC0_DAT0H_OFFSET
   Definitions
      At line 634 in file ..\Exercise
   Uses
      At line 642 in file ..\Exercise
Comment: DAC0_DAT0H_OFFSET used once
DAC0_DAT0L 4003F000

Symbol: DAC0_DAT0L
   Definitions
      At line 641 in file ..\Exercise
   Uses
      None
Comment: DAC0_DAT0L unused
DAC0_DAT0L_OFFSET 00000000

Symbol: DAC0_DAT0L_OFFSET
   Definitions
      At line 633 in file ..\Exercise
   Uses
      At line 641 in file ..\Exercise
Comment: DAC0_DAT0L_OFFSET used once
DAC0_DAT1H 4003F003

Symbol: DAC0_DAT1H
   Definitions
      At line 644 in file ..\Exercise
   Uses
      None
Comment: DAC0_DAT1H unused
DAC0_DAT1H_OFFSET 00000003

Symbol: DAC0_DAT1H_OFFSET
   Definitions
      At line 636 in file ..\Exercise
   Uses
      At line 644 in file ..\Exercise
Comment: DAC0_DAT1H_OFFSET used once
DAC0_DAT1L 4003F002

Symbol: DAC0_DAT1L
   Definitions
      At line 643 in file ..\Exercise
   Uses



ARM Macro Assembler    Page 36 Alphabetic symbol ordering
Absolute symbols

      None
Comment: DAC0_DAT1L unused
DAC0_DAT1L_OFFSET 00000002

Symbol: DAC0_DAT1L_OFFSET
   Definitions
      At line 635 in file ..\Exercise
   Uses
      At line 643 in file ..\Exercise
Comment: DAC0_DAT1L_OFFSET used once
DAC0_IPR E000E418

Symbol: DAC0_IPR
   Definitions
      At line 2688 in file ..\Exercise
   Uses
      None
Comment: DAC0_IPR unused
DAC0_IRQ 00000019

Symbol: DAC0_IRQ
   Definitions
      At line 2758 in file ..\Exercise
   Uses
      At line 2792 in file ..\Exercise
Comment: DAC0_IRQ used once
DAC0_IRQ_MASK 02000000

Symbol: DAC0_IRQ_MASK
   Definitions
      At line 2792 in file ..\Exercise
   Uses
      None
Comment: DAC0_IRQ_MASK unused
DAC0_IRQn 00000019

Symbol: DAC0_IRQn
   Definitions
      At line 171 in file ..\Exercise
   Uses
      None
Comment: DAC0_IRQn unused
DAC0_PRI_POS 0000000E

Symbol: DAC0_PRI_POS
   Definitions
      At line 2724 in file ..\Exercise
   Uses
      None
Comment: DAC0_PRI_POS unused
DAC0_SR 4003F020

Symbol: DAC0_SR
   Definitions
      At line 645 in file ..\Exercise
   Uses
      None
Comment: DAC0_SR unused
DAC0_SR_OFFSET 00000020



ARM Macro Assembler    Page 37 Alphabetic symbol ordering
Absolute symbols


Symbol: DAC0_SR_OFFSET
   Definitions
      At line 637 in file ..\Exercise
   Uses
      At line 645 in file ..\Exercise
Comment: DAC0_SR_OFFSET used once
DAC0_STEPS 00001000

Symbol: DAC0_STEPS
   Definitions
      At line 254 in file ..\Exercise
   Uses
      At line 1102 in file ..\Exercise
      At line 1103 in file ..\Exercise
      At line 1104 in file ..\Exercise
      At line 1105 in file ..\Exercise
      At line 1106 in file ..\Exercise

DAC0_Vector 00000029

Symbol: DAC0_Vector
   Definitions
      At line 2842 in file ..\Exercise
   Uses
      None
Comment: DAC0_Vector unused
DAC_C0_DACBBIEN_MASK 00000001

Symbol: DAC_C0_DACBBIEN_MASK
   Definitions
      At line 701 in file ..\Exercise
   Uses
      None
Comment: DAC_C0_DACBBIEN_MASK unused
DAC_C0_DACBBIEN_SHIFT 00000000

Symbol: DAC_C0_DACBBIEN_SHIFT
   Definitions
      At line 702 in file ..\Exercise
   Uses
      None
Comment: DAC_C0_DACBBIEN_SHIFT unused
DAC_C0_DACBTIEN_MASK 00000002

Symbol: DAC_C0_DACBTIEN_MASK
   Definitions
      At line 699 in file ..\Exercise
   Uses
      None
Comment: DAC_C0_DACBTIEN_MASK unused
DAC_C0_DACBTIEN_SHIFT 00000001

Symbol: DAC_C0_DACBTIEN_SHIFT
   Definitions
      At line 700 in file ..\Exercise
   Uses
      None
Comment: DAC_C0_DACBTIEN_SHIFT unused



ARM Macro Assembler    Page 38 Alphabetic symbol ordering
Absolute symbols

DAC_C0_DACEN_MASK 00000080

Symbol: DAC_C0_DACEN_MASK
   Definitions
      At line 689 in file ..\Exercise
   Uses
      None
Comment: DAC_C0_DACEN_MASK unused
DAC_C0_DACEN_SHIFT 00000007

Symbol: DAC_C0_DACEN_SHIFT
   Definitions
      At line 690 in file ..\Exercise
   Uses
      None
Comment: DAC_C0_DACEN_SHIFT unused
DAC_C0_DACRFS_MASK 00000040

Symbol: DAC_C0_DACRFS_MASK
   Definitions
      At line 691 in file ..\Exercise
   Uses
      None
Comment: DAC_C0_DACRFS_MASK unused
DAC_C0_DACRFS_SHIFT 00000006

Symbol: DAC_C0_DACRFS_SHIFT
   Definitions
      At line 692 in file ..\Exercise
   Uses
      None
Comment: DAC_C0_DACRFS_SHIFT unused
DAC_C0_DACSWTRG_MASK 00000010

Symbol: DAC_C0_DACSWTRG_MASK
   Definitions
      At line 695 in file ..\Exercise
   Uses
      None
Comment: DAC_C0_DACSWTRG_MASK unused
DAC_C0_DACSWTRG_SHIFT 00000004

Symbol: DAC_C0_DACSWTRG_SHIFT
   Definitions
      At line 696 in file ..\Exercise
   Uses
      None
Comment: DAC_C0_DACSWTRG_SHIFT unused
DAC_C0_DACTRGSEL_MASK 00000020

Symbol: DAC_C0_DACTRGSEL_MASK
   Definitions
      At line 693 in file ..\Exercise
   Uses
      None
Comment: DAC_C0_DACTRGSEL_MASK unused
DAC_C0_DACTRGSEL_SHIFT 00000005

Symbol: DAC_C0_DACTRGSEL_SHIFT



ARM Macro Assembler    Page 39 Alphabetic symbol ordering
Absolute symbols

   Definitions
      At line 694 in file ..\Exercise
   Uses
      None
Comment: DAC_C0_DACTRGSEL_SHIFT unused
DAC_C0_LPEN_MASK 00000008

Symbol: DAC_C0_LPEN_MASK
   Definitions
      At line 697 in file ..\Exercise
   Uses
      None
Comment: DAC_C0_LPEN_MASK unused
DAC_C0_LPEN_SHIFT 00000003

Symbol: DAC_C0_LPEN_SHIFT
   Definitions
      At line 698 in file ..\Exercise
   Uses
      None
Comment: DAC_C0_LPEN_SHIFT unused
DAC_C1_DACBFEN_MASK 00000001

Symbol: DAC_C1_DACBFEN_MASK
   Definitions
      At line 718 in file ..\Exercise
   Uses
      None
Comment: DAC_C1_DACBFEN_MASK unused
DAC_C1_DACBFEN_SHIFT 00000000

Symbol: DAC_C1_DACBFEN_SHIFT
   Definitions
      At line 719 in file ..\Exercise
   Uses
      None
Comment: DAC_C1_DACBFEN_SHIFT unused
DAC_C1_DACBFMD_MASK 00000004

Symbol: DAC_C1_DACBFMD_MASK
   Definitions
      At line 716 in file ..\Exercise
   Uses
      None
Comment: DAC_C1_DACBFMD_MASK unused
DAC_C1_DACBFMD_SHIFT 00000002

Symbol: DAC_C1_DACBFMD_SHIFT
   Definitions
      At line 717 in file ..\Exercise
   Uses
      None
Comment: DAC_C1_DACBFMD_SHIFT unused
DAC_C1_DMAEN_MASK 00000080

Symbol: DAC_C1_DMAEN_MASK
   Definitions
      At line 714 in file ..\Exercise
   Uses



ARM Macro Assembler    Page 40 Alphabetic symbol ordering
Absolute symbols

      None
Comment: DAC_C1_DMAEN_MASK unused
DAC_C1_DMAEN_SHIFT 00000007

Symbol: DAC_C1_DMAEN_SHIFT
   Definitions
      At line 715 in file ..\Exercise
   Uses
      None
Comment: DAC_C1_DMAEN_SHIFT unused
DAC_C2_DACBFRP_MASK 00000010

Symbol: DAC_C2_DACBFRP_MASK
   Definitions
      At line 726 in file ..\Exercise
   Uses
      None
Comment: DAC_C2_DACBFRP_MASK unused
DAC_C2_DACBFRP_SHIFT 00000004

Symbol: DAC_C2_DACBFRP_SHIFT
   Definitions
      At line 727 in file ..\Exercise
   Uses
      None
Comment: DAC_C2_DACBFRP_SHIFT unused
DAC_C2_DACBFUP_MASK 00000001

Symbol: DAC_C2_DACBFUP_MASK
   Definitions
      At line 728 in file ..\Exercise
   Uses
      None
Comment: DAC_C2_DACBFUP_MASK unused
DAC_C2_DACBFUP_SHIFT 00000000

Symbol: DAC_C2_DACBFUP_SHIFT
   Definitions
      At line 729 in file ..\Exercise
   Uses
      None
Comment: DAC_C2_DACBFUP_SHIFT unused
DAC_DAT0H_MASK 0000000F

Symbol: DAC_DAT0H_MASK
   Definitions
      At line 654 in file ..\Exercise
   Uses
      None
Comment: DAC_DAT0H_MASK unused
DAC_DAT0H_SHIFT 00000000

Symbol: DAC_DAT0H_SHIFT
   Definitions
      At line 655 in file ..\Exercise
   Uses
      None
Comment: DAC_DAT0H_SHIFT unused
DAC_DAT1H_MASK 0000000F



ARM Macro Assembler    Page 41 Alphabetic symbol ordering
Absolute symbols


Symbol: DAC_DAT1H_MASK
   Definitions
      At line 665 in file ..\Exercise
   Uses
      None
Comment: DAC_DAT1H_MASK unused
DAC_DAT1H_SHIFT 00000000

Symbol: DAC_DAT1H_SHIFT
   Definitions
      At line 666 in file ..\Exercise
   Uses
      None
Comment: DAC_DAT1H_SHIFT unused
DAC_SR_DACBFRPBF_MASK 00000001

Symbol: DAC_SR_DACBFRPBF_MASK
   Definitions
      At line 740 in file ..\Exercise
   Uses
      None
Comment: DAC_SR_DACBFRPBF_MASK unused
DAC_SR_DACBFRPBF_SHIFT 00000000

Symbol: DAC_SR_DACBFRPBF_SHIFT
   Definitions
      At line 741 in file ..\Exercise
   Uses
      None
Comment: DAC_SR_DACBFRPBF_SHIFT unused
DAC_SR_DACBFRPTF_MASK 00000002

Symbol: DAC_SR_DACBFRPTF_MASK
   Definitions
      At line 738 in file ..\Exercise
   Uses
      None
Comment: DAC_SR_DACBFRPTF_MASK unused
DAC_SR_DACBFRPTF_SHIFT 00000001

Symbol: DAC_SR_DACBFRPTF_SHIFT
   Definitions
      At line 739 in file ..\Exercise
   Uses
      None
Comment: DAC_SR_DACBFRPTF_SHIFT unused
DIV100K 000186A0

Symbol: DIV100K
   Definitions
      At line 218 in file ..\Exercise
   Uses
      At line 999 in file ..\Exercise
Comment: DIV100K used once
DIV10K 00002710

Symbol: DIV10K
   Definitions



ARM Macro Assembler    Page 42 Alphabetic symbol ordering
Absolute symbols

      At line 217 in file ..\Exercise
   Uses
      At line 1002 in file ..\Exercise
Comment: DIV10K used once
DIV1K 000003E8

Symbol: DIV1K
   Definitions
      At line 216 in file ..\Exercise
   Uses
      At line 1005 in file ..\Exercise
Comment: DIV1K used once
DIV1M 000F4240

Symbol: DIV1M
   Definitions
      At line 219 in file ..\Exercise
   Uses
      At line 996 in file ..\Exercise
Comment: DIV1M used once
DMA0_IPR E000E400

Symbol: DMA0_IPR
   Definitions
      At line 2663 in file ..\Exercise
   Uses
      None
Comment: DMA0_IPR unused
DMA0_IRQ 00000000

Symbol: DMA0_IRQ
   Definitions
      At line 2733 in file ..\Exercise
   Uses
      At line 2767 in file ..\Exercise
Comment: DMA0_IRQ used once
DMA0_IRQ_MASK 00000001

Symbol: DMA0_IRQ_MASK
   Definitions
      At line 2767 in file ..\Exercise
   Uses
      None
Comment: DMA0_IRQ_MASK unused
DMA0_IRQn 00000000

Symbol: DMA0_IRQn
   Definitions
      At line 146 in file ..\Exercise
   Uses
      None
Comment: DMA0_IRQn unused
DMA0_PRI_POS 00000006

Symbol: DMA0_PRI_POS
   Definitions
      At line 2699 in file ..\Exercise
   Uses
      None



ARM Macro Assembler    Page 43 Alphabetic symbol ordering
Absolute symbols

Comment: DMA0_PRI_POS unused
DMA0_Vector 00000010

Symbol: DMA0_Vector
   Definitions
      At line 2817 in file ..\Exercise
   Uses
      None
Comment: DMA0_Vector unused
DMA1_IPR E000E400

Symbol: DMA1_IPR
   Definitions
      At line 2664 in file ..\Exercise
   Uses
      None
Comment: DMA1_IPR unused
DMA1_IRQ 00000001

Symbol: DMA1_IRQ
   Definitions
      At line 2734 in file ..\Exercise
   Uses
      At line 2768 in file ..\Exercise
Comment: DMA1_IRQ used once
DMA1_IRQ_MASK 00000002

Symbol: DMA1_IRQ_MASK
   Definitions
      At line 2768 in file ..\Exercise
   Uses
      None
Comment: DMA1_IRQ_MASK unused
DMA1_IRQn 00000001

Symbol: DMA1_IRQn
   Definitions
      At line 147 in file ..\Exercise
   Uses
      None
Comment: DMA1_IRQn unused
DMA1_PRI_POS 0000000E

Symbol: DMA1_PRI_POS
   Definitions
      At line 2700 in file ..\Exercise
   Uses
      None
Comment: DMA1_PRI_POS unused
DMA1_Vector 00000011

Symbol: DMA1_Vector
   Definitions
      At line 2818 in file ..\Exercise
   Uses
      None
Comment: DMA1_Vector unused
DMA2_IPR E000E400




ARM Macro Assembler    Page 44 Alphabetic symbol ordering
Absolute symbols

Symbol: DMA2_IPR
   Definitions
      At line 2665 in file ..\Exercise
   Uses
      None
Comment: DMA2_IPR unused
DMA2_IRQ 00000002

Symbol: DMA2_IRQ
   Definitions
      At line 2735 in file ..\Exercise
   Uses
      At line 2769 in file ..\Exercise
Comment: DMA2_IRQ used once
DMA2_IRQ_MASK 00000004

Symbol: DMA2_IRQ_MASK
   Definitions
      At line 2769 in file ..\Exercise
   Uses
      None
Comment: DMA2_IRQ_MASK unused
DMA2_IRQn 00000002

Symbol: DMA2_IRQn
   Definitions
      At line 148 in file ..\Exercise
   Uses
      None
Comment: DMA2_IRQn unused
DMA2_PRI_POS 00000016

Symbol: DMA2_PRI_POS
   Definitions
      At line 2701 in file ..\Exercise
   Uses
      None
Comment: DMA2_PRI_POS unused
DMA2_Vector 00000012

Symbol: DMA2_Vector
   Definitions
      At line 2819 in file ..\Exercise
   Uses
      None
Comment: DMA2_Vector unused
DMA3_IPR E000E400

Symbol: DMA3_IPR
   Definitions
      At line 2666 in file ..\Exercise
   Uses
      None
Comment: DMA3_IPR unused
DMA3_IRQ 00000003

Symbol: DMA3_IRQ
   Definitions
      At line 2736 in file ..\Exercise



ARM Macro Assembler    Page 45 Alphabetic symbol ordering
Absolute symbols

   Uses
      At line 2770 in file ..\Exercise
Comment: DMA3_IRQ used once
DMA3_IRQ_MASK 00000008

Symbol: DMA3_IRQ_MASK
   Definitions
      At line 2770 in file ..\Exercise
   Uses
      None
Comment: DMA3_IRQ_MASK unused
DMA3_IRQn 00000003

Symbol: DMA3_IRQn
   Definitions
      At line 149 in file ..\Exercise
   Uses
      None
Comment: DMA3_IRQn unused
DMA3_PRI_POS 0000001E

Symbol: DMA3_PRI_POS
   Definitions
      At line 2702 in file ..\Exercise
   Uses
      None
Comment: DMA3_PRI_POS unused
DMA3_Vector 00000013

Symbol: DMA3_Vector
   Definitions
      At line 2820 in file ..\Exercise
   Uses
      None
Comment: DMA3_Vector unused
EPSR_MASK 01000000

Symbol: EPSR_MASK
   Definitions
      At line 89 in file ..\Exercise
   Uses
      None
Comment: EPSR_MASK unused
EPSR_SHIFT 00000018

Symbol: EPSR_SHIFT
   Definitions
      At line 90 in file ..\Exercise
   Uses
      None
Comment: EPSR_SHIFT unused
EPSR_T_MASK 01000000

Symbol: EPSR_T_MASK
   Definitions
      At line 91 in file ..\Exercise
   Uses
      At line 123 in file ..\Exercise
Comment: EPSR_T_MASK used once



ARM Macro Assembler    Page 46 Alphabetic symbol ordering
Absolute symbols

EPSR_T_SHIFT 00000018

Symbol: EPSR_T_SHIFT
   Definitions
      At line 92 in file ..\Exercise
   Uses
      At line 124 in file ..\Exercise
Comment: EPSR_T_SHIFT used once
FCF_BACKDOOR_KEY0 000000FF

Symbol: FCF_BACKDOOR_KEY0
   Definitions
      At line 804 in file ..\Exercise
   Uses
      None
Comment: FCF_BACKDOOR_KEY0 unused
FCF_BACKDOOR_KEY1 000000FF

Symbol: FCF_BACKDOOR_KEY1
   Definitions
      At line 808 in file ..\Exercise
   Uses
      None
Comment: FCF_BACKDOOR_KEY1 unused
FCF_BACKDOOR_KEY2 000000FF

Symbol: FCF_BACKDOOR_KEY2
   Definitions
      At line 812 in file ..\Exercise
   Uses
      None
Comment: FCF_BACKDOOR_KEY2 unused
FCF_BACKDOOR_KEY3 000000FF

Symbol: FCF_BACKDOOR_KEY3
   Definitions
      At line 816 in file ..\Exercise
   Uses
      None
Comment: FCF_BACKDOOR_KEY3 unused
FCF_BACKDOOR_KEY4 000000FF

Symbol: FCF_BACKDOOR_KEY4
   Definitions
      At line 820 in file ..\Exercise
   Uses
      None
Comment: FCF_BACKDOOR_KEY4 unused
FCF_BACKDOOR_KEY5 000000FF

Symbol: FCF_BACKDOOR_KEY5
   Definitions
      At line 824 in file ..\Exercise
   Uses
      None
Comment: FCF_BACKDOOR_KEY5 unused
FCF_BACKDOOR_KEY6 000000FF

Symbol: FCF_BACKDOOR_KEY6



ARM Macro Assembler    Page 47 Alphabetic symbol ordering
Absolute symbols

   Definitions
      At line 828 in file ..\Exercise
   Uses
      None
Comment: FCF_BACKDOOR_KEY6 unused
FCF_BACKDOOR_KEY7 000000FF

Symbol: FCF_BACKDOOR_KEY7
   Definitions
      At line 832 in file ..\Exercise
   Uses
      None
Comment: FCF_BACKDOOR_KEY7 unused
FCF_FOPT 000000FF

Symbol: FCF_FOPT
   Definitions
      At line 843 in file ..\Exercise
   Uses
      None
Comment: FCF_FOPT unused
FCF_FPROT0 000000FF

Symbol: FCF_FPROT0
   Definitions
      At line 858 in file ..\Exercise
   Uses
      None
Comment: FCF_FPROT0 unused
FCF_FPROT1 000000FF

Symbol: FCF_FPROT1
   Definitions
      At line 869 in file ..\Exercise
   Uses
      None
Comment: FCF_FPROT1 unused
FCF_FPROT2 000000FF

Symbol: FCF_FPROT2
   Definitions
      At line 880 in file ..\Exercise
   Uses
      None
Comment: FCF_FPROT2 unused
FCF_FPROT3 000000FF

Symbol: FCF_FPROT3
   Definitions
      At line 891 in file ..\Exercise
   Uses
      None
Comment: FCF_FPROT3 unused
FCF_FSEC 0000007E

Symbol: FCF_FSEC
   Definitions
      At line 920 in file ..\Exercise
   Uses



ARM Macro Assembler    Page 48 Alphabetic symbol ordering
Absolute symbols

      None
Comment: FCF_FSEC unused
FGPIOA_BASE F80FF000

Symbol: FGPIOA_BASE
   Definitions
      At line 752 in file ..\Exercise
   Uses
      At line 753 in file ..\Exercise
      At line 754 in file ..\Exercise
      At line 755 in file ..\Exercise
      At line 756 in file ..\Exercise
      At line 757 in file ..\Exercise
      At line 758 in file ..\Exercise

FGPIOA_PCOR F80FF008

Symbol: FGPIOA_PCOR
   Definitions
      At line 755 in file ..\Exercise
   Uses
      None
Comment: FGPIOA_PCOR unused
FGPIOA_PDDR F80FF014

Symbol: FGPIOA_PDDR
   Definitions
      At line 758 in file ..\Exercise
   Uses
      None
Comment: FGPIOA_PDDR unused
FGPIOA_PDIR F80FF010

Symbol: FGPIOA_PDIR
   Definitions
      At line 757 in file ..\Exercise
   Uses
      None
Comment: FGPIOA_PDIR unused
FGPIOA_PDOR F80FF000

Symbol: FGPIOA_PDOR
   Definitions
      At line 753 in file ..\Exercise
   Uses
      None
Comment: FGPIOA_PDOR unused
FGPIOA_PSOR F80FF004

Symbol: FGPIOA_PSOR
   Definitions
      At line 754 in file ..\Exercise
   Uses
      None
Comment: FGPIOA_PSOR unused
FGPIOA_PTOR F80FF00C

Symbol: FGPIOA_PTOR
   Definitions



ARM Macro Assembler    Page 49 Alphabetic symbol ordering
Absolute symbols

      At line 756 in file ..\Exercise
   Uses
      None
Comment: FGPIOA_PTOR unused
FGPIOB_BASE F80FF040

Symbol: FGPIOB_BASE
   Definitions
      At line 760 in file ..\Exercise
   Uses
      At line 761 in file ..\Exercise
      At line 762 in file ..\Exercise
      At line 763 in file ..\Exercise
      At line 764 in file ..\Exercise
      At line 765 in file ..\Exercise
      At line 766 in file ..\Exercise

FGPIOB_PCOR F80FF048

Symbol: FGPIOB_PCOR
   Definitions
      At line 763 in file ..\Exercise
   Uses
      None
Comment: FGPIOB_PCOR unused
FGPIOB_PDDR F80FF054

Symbol: FGPIOB_PDDR
   Definitions
      At line 766 in file ..\Exercise
   Uses
      None
Comment: FGPIOB_PDDR unused
FGPIOB_PDIR F80FF050

Symbol: FGPIOB_PDIR
   Definitions
      At line 765 in file ..\Exercise
   Uses
      None
Comment: FGPIOB_PDIR unused
FGPIOB_PDOR F80FF040

Symbol: FGPIOB_PDOR
   Definitions
      At line 761 in file ..\Exercise
   Uses
      None
Comment: FGPIOB_PDOR unused
FGPIOB_PSOR F80FF044

Symbol: FGPIOB_PSOR
   Definitions
      At line 762 in file ..\Exercise
   Uses
      None
Comment: FGPIOB_PSOR unused
FGPIOB_PTOR F80FF04C




ARM Macro Assembler    Page 50 Alphabetic symbol ordering
Absolute symbols

Symbol: FGPIOB_PTOR
   Definitions
      At line 764 in file ..\Exercise
   Uses
      None
Comment: FGPIOB_PTOR unused
FGPIOC_BASE F80FF080

Symbol: FGPIOC_BASE
   Definitions
      At line 768 in file ..\Exercise
   Uses
      At line 769 in file ..\Exercise
      At line 770 in file ..\Exercise
      At line 771 in file ..\Exercise
      At line 772 in file ..\Exercise
      At line 773 in file ..\Exercise
      At line 774 in file ..\Exercise

FGPIOC_PCOR F80FF088

Symbol: FGPIOC_PCOR
   Definitions
      At line 771 in file ..\Exercise
   Uses
      None
Comment: FGPIOC_PCOR unused
FGPIOC_PDDR F80FF094

Symbol: FGPIOC_PDDR
   Definitions
      At line 774 in file ..\Exercise
   Uses
      None
Comment: FGPIOC_PDDR unused
FGPIOC_PDIR F80FF090

Symbol: FGPIOC_PDIR
   Definitions
      At line 773 in file ..\Exercise
   Uses
      None
Comment: FGPIOC_PDIR unused
FGPIOC_PDOR F80FF080

Symbol: FGPIOC_PDOR
   Definitions
      At line 769 in file ..\Exercise
   Uses
      None
Comment: FGPIOC_PDOR unused
FGPIOC_PSOR F80FF084

Symbol: FGPIOC_PSOR
   Definitions
      At line 770 in file ..\Exercise
   Uses
      None
Comment: FGPIOC_PSOR unused



ARM Macro Assembler    Page 51 Alphabetic symbol ordering
Absolute symbols

FGPIOC_PTOR F80FF08C

Symbol: FGPIOC_PTOR
   Definitions
      At line 772 in file ..\Exercise
   Uses
      None
Comment: FGPIOC_PTOR unused
FGPIOD_BASE F80FF0C0

Symbol: FGPIOD_BASE
   Definitions
      At line 776 in file ..\Exercise
   Uses
      At line 777 in file ..\Exercise
      At line 778 in file ..\Exercise
      At line 779 in file ..\Exercise
      At line 780 in file ..\Exercise
      At line 781 in file ..\Exercise
      At line 782 in file ..\Exercise
      At line 374 in file ..\Exercise
      At line 425 in file ..\Exercise

FGPIOD_PCOR F80FF0C8

Symbol: FGPIOD_PCOR
   Definitions
      At line 779 in file ..\Exercise
   Uses
      None
Comment: FGPIOD_PCOR unused
FGPIOD_PDDR F80FF0D4

Symbol: FGPIOD_PDDR
   Definitions
      At line 782 in file ..\Exercise
   Uses
      None
Comment: FGPIOD_PDDR unused
FGPIOD_PDIR F80FF0D0

Symbol: FGPIOD_PDIR
   Definitions
      At line 781 in file ..\Exercise
   Uses
      None
Comment: FGPIOD_PDIR unused
FGPIOD_PDOR F80FF0C0

Symbol: FGPIOD_PDOR
   Definitions
      At line 777 in file ..\Exercise
   Uses
      None
Comment: FGPIOD_PDOR unused
FGPIOD_PSOR F80FF0C4

Symbol: FGPIOD_PSOR
   Definitions



ARM Macro Assembler    Page 52 Alphabetic symbol ordering
Absolute symbols

      At line 778 in file ..\Exercise
   Uses
      None
Comment: FGPIOD_PSOR unused
FGPIOD_PTOR F80FF0CC

Symbol: FGPIOD_PTOR
   Definitions
      At line 780 in file ..\Exercise
   Uses
      None
Comment: FGPIOD_PTOR unused
FGPIOE_BASE F80FF100

Symbol: FGPIOE_BASE
   Definitions
      At line 784 in file ..\Exercise
   Uses
      At line 785 in file ..\Exercise
      At line 786 in file ..\Exercise
      At line 787 in file ..\Exercise
      At line 788 in file ..\Exercise
      At line 789 in file ..\Exercise
      At line 790 in file ..\Exercise
      At line 388 in file ..\Exercise
      At line 428 in file ..\Exercise

FGPIOE_PCOR F80FF108

Symbol: FGPIOE_PCOR
   Definitions
      At line 787 in file ..\Exercise
   Uses
      None
Comment: FGPIOE_PCOR unused
FGPIOE_PDDR F80FF114

Symbol: FGPIOE_PDDR
   Definitions
      At line 790 in file ..\Exercise
   Uses
      None
Comment: FGPIOE_PDDR unused
FGPIOE_PDIR F80FF110

Symbol: FGPIOE_PDIR
   Definitions
      At line 789 in file ..\Exercise
   Uses
      None
Comment: FGPIOE_PDIR unused
FGPIOE_PDOR F80FF100

Symbol: FGPIOE_PDOR
   Definitions
      At line 785 in file ..\Exercise
   Uses
      None
Comment: FGPIOE_PDOR unused



ARM Macro Assembler    Page 53 Alphabetic symbol ordering
Absolute symbols

FGPIOE_PSOR F80FF104

Symbol: FGPIOE_PSOR
   Definitions
      At line 786 in file ..\Exercise
   Uses
      None
Comment: FGPIOE_PSOR unused
FGPIOE_PTOR F80FF10C

Symbol: FGPIOE_PTOR
   Definitions
      At line 788 in file ..\Exercise
   Uses
      None
Comment: FGPIOE_PTOR unused
FGPIO_BASE F80FF000

Symbol: FGPIO_BASE
   Definitions
      At line 747 in file ..\Exercise
   Uses
      None
Comment: FGPIO_BASE unused
FTFA_IPR E000E404

Symbol: FTFA_IPR
   Definitions
      At line 2668 in file ..\Exercise
   Uses
      None
Comment: FTFA_IPR unused
FTFA_IRQ 00000005

Symbol: FTFA_IRQ
   Definitions
      At line 2738 in file ..\Exercise
   Uses
      At line 2772 in file ..\Exercise
Comment: FTFA_IRQ used once
FTFA_IRQ_MASK 00000020

Symbol: FTFA_IRQ_MASK
   Definitions
      At line 2772 in file ..\Exercise
   Uses
      None
Comment: FTFA_IRQ_MASK unused
FTFA_IRQn 00000005

Symbol: FTFA_IRQn
   Definitions
      At line 151 in file ..\Exercise
   Uses
      None
Comment: FTFA_IRQn unused
FTFA_PRI_POS 0000000E

Symbol: FTFA_PRI_POS



ARM Macro Assembler    Page 54 Alphabetic symbol ordering
Absolute symbols

   Definitions
      At line 2704 in file ..\Exercise
   Uses
      None
Comment: FTFA_PRI_POS unused
FTFA_Vector 00000015

Symbol: FTFA_Vector
   Definitions
      At line 2822 in file ..\Exercise
   Uses
      None
Comment: FTFA_Vector unused
GPIOA_BASE 400FF000

Symbol: GPIOA_BASE
   Definitions
      At line 939 in file ..\Exercise
   Uses
      At line 940 in file ..\Exercise
      At line 941 in file ..\Exercise
      At line 942 in file ..\Exercise
      At line 943 in file ..\Exercise
      At line 944 in file ..\Exercise
      At line 945 in file ..\Exercise

GPIOA_OFFSET 00000000

Symbol: GPIOA_OFFSET
   Definitions
      At line 933 in file ..\Exercise
   Uses
      None
Comment: GPIOA_OFFSET unused
GPIOA_PCOR 400FF008

Symbol: GPIOA_PCOR
   Definitions
      At line 942 in file ..\Exercise
   Uses
      None
Comment: GPIOA_PCOR unused
GPIOA_PDDR 400FF014

Symbol: GPIOA_PDDR
   Definitions
      At line 945 in file ..\Exercise
   Uses
      None
Comment: GPIOA_PDDR unused
GPIOA_PDIR 400FF010

Symbol: GPIOA_PDIR
   Definitions
      At line 944 in file ..\Exercise
   Uses
      None
Comment: GPIOA_PDIR unused
GPIOA_PDOR 400FF000



ARM Macro Assembler    Page 55 Alphabetic symbol ordering
Absolute symbols


Symbol: GPIOA_PDOR
   Definitions
      At line 940 in file ..\Exercise
   Uses
      None
Comment: GPIOA_PDOR unused
GPIOA_PSOR 400FF004

Symbol: GPIOA_PSOR
   Definitions
      At line 941 in file ..\Exercise
   Uses
      None
Comment: GPIOA_PSOR unused
GPIOA_PTOR 400FF00C

Symbol: GPIOA_PTOR
   Definitions
      At line 943 in file ..\Exercise
   Uses
      None
Comment: GPIOA_PTOR unused
GPIOB_BASE 400FF040

Symbol: GPIOB_BASE
   Definitions
      At line 947 in file ..\Exercise
   Uses
      At line 948 in file ..\Exercise
      At line 949 in file ..\Exercise
      At line 950 in file ..\Exercise
      At line 951 in file ..\Exercise
      At line 952 in file ..\Exercise
      At line 953 in file ..\Exercise

GPIOB_OFFSET 00000040

Symbol: GPIOB_OFFSET
   Definitions
      At line 934 in file ..\Exercise
   Uses
      None
Comment: GPIOB_OFFSET unused
GPIOB_PCOR 400FF048

Symbol: GPIOB_PCOR
   Definitions
      At line 950 in file ..\Exercise
   Uses
      None
Comment: GPIOB_PCOR unused
GPIOB_PDDR 400FF054

Symbol: GPIOB_PDDR
   Definitions
      At line 953 in file ..\Exercise
   Uses
      None



ARM Macro Assembler    Page 56 Alphabetic symbol ordering
Absolute symbols

Comment: GPIOB_PDDR unused
GPIOB_PDIR 400FF050

Symbol: GPIOB_PDIR
   Definitions
      At line 952 in file ..\Exercise
   Uses
      None
Comment: GPIOB_PDIR unused
GPIOB_PDOR 400FF040

Symbol: GPIOB_PDOR
   Definitions
      At line 948 in file ..\Exercise
   Uses
      None
Comment: GPIOB_PDOR unused
GPIOB_PSOR 400FF044

Symbol: GPIOB_PSOR
   Definitions
      At line 949 in file ..\Exercise
   Uses
      None
Comment: GPIOB_PSOR unused
GPIOB_PTOR 400FF04C

Symbol: GPIOB_PTOR
   Definitions
      At line 951 in file ..\Exercise
   Uses
      None
Comment: GPIOB_PTOR unused
GPIOC_BASE 400FF080

Symbol: GPIOC_BASE
   Definitions
      At line 955 in file ..\Exercise
   Uses
      At line 956 in file ..\Exercise
      At line 957 in file ..\Exercise
      At line 958 in file ..\Exercise
      At line 959 in file ..\Exercise
      At line 960 in file ..\Exercise
      At line 961 in file ..\Exercise

GPIOC_OFFSET 00000080

Symbol: GPIOC_OFFSET
   Definitions
      At line 935 in file ..\Exercise
   Uses
      None
Comment: GPIOC_OFFSET unused
GPIOC_PCOR 400FF088

Symbol: GPIOC_PCOR
   Definitions
      At line 958 in file ..\Exercise



ARM Macro Assembler    Page 57 Alphabetic symbol ordering
Absolute symbols

   Uses
      None
Comment: GPIOC_PCOR unused
GPIOC_PDDR 400FF094

Symbol: GPIOC_PDDR
   Definitions
      At line 961 in file ..\Exercise
   Uses
      None
Comment: GPIOC_PDDR unused
GPIOC_PDIR 400FF090

Symbol: GPIOC_PDIR
   Definitions
      At line 960 in file ..\Exercise
   Uses
      None
Comment: GPIOC_PDIR unused
GPIOC_PDOR 400FF080

Symbol: GPIOC_PDOR
   Definitions
      At line 956 in file ..\Exercise
   Uses
      None
Comment: GPIOC_PDOR unused
GPIOC_PSOR 400FF084

Symbol: GPIOC_PSOR
   Definitions
      At line 957 in file ..\Exercise
   Uses
      None
Comment: GPIOC_PSOR unused
GPIOC_PTOR 400FF08C

Symbol: GPIOC_PTOR
   Definitions
      At line 959 in file ..\Exercise
   Uses
      None
Comment: GPIOC_PTOR unused
GPIOD_BASE 400FF0C0

Symbol: GPIOD_BASE
   Definitions
      At line 963 in file ..\Exercise
   Uses
      At line 964 in file ..\Exercise
      At line 965 in file ..\Exercise
      At line 966 in file ..\Exercise
      At line 967 in file ..\Exercise
      At line 968 in file ..\Exercise
      At line 969 in file ..\Exercise

GPIOD_OFFSET 000000C0

Symbol: GPIOD_OFFSET



ARM Macro Assembler    Page 58 Alphabetic symbol ordering
Absolute symbols

   Definitions
      At line 936 in file ..\Exercise
   Uses
      None
Comment: GPIOD_OFFSET unused
GPIOD_PCOR 400FF0C8

Symbol: GPIOD_PCOR
   Definitions
      At line 966 in file ..\Exercise
   Uses
      None
Comment: GPIOD_PCOR unused
GPIOD_PDDR 400FF0D4

Symbol: GPIOD_PDDR
   Definitions
      At line 969 in file ..\Exercise
   Uses
      None
Comment: GPIOD_PDDR unused
GPIOD_PDIR 400FF0D0

Symbol: GPIOD_PDIR
   Definitions
      At line 968 in file ..\Exercise
   Uses
      None
Comment: GPIOD_PDIR unused
GPIOD_PDOR 400FF0C0

Symbol: GPIOD_PDOR
   Definitions
      At line 964 in file ..\Exercise
   Uses
      None
Comment: GPIOD_PDOR unused
GPIOD_PSOR 400FF0C4

Symbol: GPIOD_PSOR
   Definitions
      At line 965 in file ..\Exercise
   Uses
      None
Comment: GPIOD_PSOR unused
GPIOD_PTOR 400FF0CC

Symbol: GPIOD_PTOR
   Definitions
      At line 967 in file ..\Exercise
   Uses
      None
Comment: GPIOD_PTOR unused
GPIOE_BASE 400FF100

Symbol: GPIOE_BASE
   Definitions
      At line 971 in file ..\Exercise
   Uses



ARM Macro Assembler    Page 59 Alphabetic symbol ordering
Absolute symbols

      At line 972 in file ..\Exercise
      At line 973 in file ..\Exercise
      At line 974 in file ..\Exercise
      At line 975 in file ..\Exercise
      At line 976 in file ..\Exercise
      At line 977 in file ..\Exercise

GPIOE_OFFSET 00000100

Symbol: GPIOE_OFFSET
   Definitions
      At line 937 in file ..\Exercise
   Uses
      None
Comment: GPIOE_OFFSET unused
GPIOE_PCOR 400FF108

Symbol: GPIOE_PCOR
   Definitions
      At line 974 in file ..\Exercise
   Uses
      None
Comment: GPIOE_PCOR unused
GPIOE_PDDR 400FF114

Symbol: GPIOE_PDDR
   Definitions
      At line 977 in file ..\Exercise
   Uses
      None
Comment: GPIOE_PDDR unused
GPIOE_PDIR 400FF110

Symbol: GPIOE_PDIR
   Definitions
      At line 976 in file ..\Exercise
   Uses
      None
Comment: GPIOE_PDIR unused
GPIOE_PDOR 400FF100

Symbol: GPIOE_PDOR
   Definitions
      At line 972 in file ..\Exercise
   Uses
      None
Comment: GPIOE_PDOR unused
GPIOE_PSOR 400FF104

Symbol: GPIOE_PSOR
   Definitions
      At line 973 in file ..\Exercise
   Uses
      None
Comment: GPIOE_PSOR unused
GPIOE_PTOR 400FF10C

Symbol: GPIOE_PTOR
   Definitions



ARM Macro Assembler    Page 60 Alphabetic symbol ordering
Absolute symbols

      At line 975 in file ..\Exercise
   Uses
      None
Comment: GPIOE_PTOR unused
GPIO_BASE 400FF000

Symbol: GPIO_BASE
   Definitions
      At line 926 in file ..\Exercise
   Uses
      None
Comment: GPIO_BASE unused
GPIO_PCOR_OFFSET 00000008

Symbol: GPIO_PCOR_OFFSET
   Definitions
      At line 929 in file ..\Exercise
   Uses
      At line 755 in file ..\Exercise
      At line 763 in file ..\Exercise
      At line 771 in file ..\Exercise
      At line 779 in file ..\Exercise
      At line 787 in file ..\Exercise
      At line 942 in file ..\Exercise
      At line 950 in file ..\Exercise
      At line 958 in file ..\Exercise
      At line 966 in file ..\Exercise
      At line 974 in file ..\Exercise
      At line 385 in file ..\Exercise
      At line 399 in file ..\Exercise

GPIO_PDDR_OFFSET 00000014

Symbol: GPIO_PDDR_OFFSET
   Definitions
      At line 932 in file ..\Exercise
   Uses
      At line 758 in file ..\Exercise
      At line 766 in file ..\Exercise
      At line 774 in file ..\Exercise
      At line 782 in file ..\Exercise
      At line 790 in file ..\Exercise
      At line 945 in file ..\Exercise
      At line 953 in file ..\Exercise
      At line 961 in file ..\Exercise
      At line 969 in file ..\Exercise
      At line 977 in file ..\Exercise
      At line 427 in file ..\Exercise
      At line 430 in file ..\Exercise

GPIO_PDIR_OFFSET 00000010

Symbol: GPIO_PDIR_OFFSET
   Definitions
      At line 931 in file ..\Exercise
   Uses
      At line 757 in file ..\Exercise
      At line 765 in file ..\Exercise
      At line 773 in file ..\Exercise



ARM Macro Assembler    Page 61 Alphabetic symbol ordering
Absolute symbols

      At line 781 in file ..\Exercise
      At line 789 in file ..\Exercise
      At line 944 in file ..\Exercise
      At line 952 in file ..\Exercise
      At line 960 in file ..\Exercise
      At line 968 in file ..\Exercise
      At line 976 in file ..\Exercise

GPIO_PDOR_OFFSET 00000000

Symbol: GPIO_PDOR_OFFSET
   Definitions
      At line 927 in file ..\Exercise
   Uses
      At line 753 in file ..\Exercise
      At line 761 in file ..\Exercise
      At line 769 in file ..\Exercise
      At line 777 in file ..\Exercise
      At line 785 in file ..\Exercise
      At line 940 in file ..\Exercise
      At line 948 in file ..\Exercise
      At line 956 in file ..\Exercise
      At line 964 in file ..\Exercise
      At line 972 in file ..\Exercise

GPIO_PSOR_OFFSET 00000004

Symbol: GPIO_PSOR_OFFSET
   Definitions
      At line 928 in file ..\Exercise
   Uses
      At line 754 in file ..\Exercise
      At line 762 in file ..\Exercise
      At line 770 in file ..\Exercise
      At line 778 in file ..\Exercise
      At line 786 in file ..\Exercise
      At line 941 in file ..\Exercise
      At line 949 in file ..\Exercise
      At line 957 in file ..\Exercise
      At line 965 in file ..\Exercise
      At line 973 in file ..\Exercise
      At line 381 in file ..\Exercise
      At line 395 in file ..\Exercise

GPIO_PTOR_OFFSET 0000000C

Symbol: GPIO_PTOR_OFFSET
   Definitions
      At line 930 in file ..\Exercise
   Uses
      At line 756 in file ..\Exercise
      At line 764 in file ..\Exercise
      At line 772 in file ..\Exercise
      At line 780 in file ..\Exercise
      At line 788 in file ..\Exercise
      At line 943 in file ..\Exercise
      At line 951 in file ..\Exercise
      At line 959 in file ..\Exercise
      At line 967 in file ..\Exercise



ARM Macro Assembler    Page 62 Alphabetic symbol ordering
Absolute symbols

      At line 975 in file ..\Exercise

HALFWORD_MASK 0000FFFF

Symbol: HALFWORD_MASK
   Definitions
      At line 32 in file ..\Exercise
   Uses
      None
Comment: HALFWORD_MASK unused
HALFWORD_SIZE 00000002

Symbol: HALFWORD_SIZE
   Definitions
      At line 30 in file ..\Exercise
   Uses
      None
Comment: HALFWORD_SIZE unused
HardFault_IRQn FFFFFFF3

Symbol: HardFault_IRQn
   Definitions
      At line 139 in file ..\Exercise
   Uses
      None
Comment: HardFault_IRQn unused
Hard_Fault_Vector 00000003

Symbol: Hard_Fault_Vector
   Definitions
      At line 2804 in file ..\Exercise
   Uses
      None
Comment: Hard_Fault_Vector unused
I2C0_IPR E000E408

Symbol: I2C0_IPR
   Definitions
      At line 2671 in file ..\Exercise
   Uses
      None
Comment: I2C0_IPR unused
I2C0_IRQ 00000008

Symbol: I2C0_IRQ
   Definitions
      At line 2741 in file ..\Exercise
   Uses
      At line 2775 in file ..\Exercise
Comment: I2C0_IRQ used once
I2C0_IRQ_MASK 00000100

Symbol: I2C0_IRQ_MASK
   Definitions
      At line 2775 in file ..\Exercise
   Uses
      None
Comment: I2C0_IRQ_MASK unused
I2C0_IRQn 00000008



ARM Macro Assembler    Page 63 Alphabetic symbol ordering
Absolute symbols


Symbol: I2C0_IRQn
   Definitions
      At line 154 in file ..\Exercise
   Uses
      None
Comment: I2C0_IRQn unused
I2C0_PRI_POS 00000006

Symbol: I2C0_PRI_POS
   Definitions
      At line 2707 in file ..\Exercise
   Uses
      None
Comment: I2C0_PRI_POS unused
I2C0_Vector 00000018

Symbol: I2C0_Vector
   Definitions
      At line 2825 in file ..\Exercise
   Uses
      None
Comment: I2C0_Vector unused
I2C1_IPR E000E408

Symbol: I2C1_IPR
   Definitions
      At line 2672 in file ..\Exercise
   Uses
      None
Comment: I2C1_IPR unused
I2C1_IRQ 00000009

Symbol: I2C1_IRQ
   Definitions
      At line 2742 in file ..\Exercise
   Uses
      At line 2776 in file ..\Exercise
Comment: I2C1_IRQ used once
I2C1_IRQ_MASK 00000200

Symbol: I2C1_IRQ_MASK
   Definitions
      At line 2776 in file ..\Exercise
   Uses
      None
Comment: I2C1_IRQ_MASK unused
I2C1_IRQn 00000009

Symbol: I2C1_IRQn
   Definitions
      At line 155 in file ..\Exercise
   Uses
      None
Comment: I2C1_IRQn unused
I2C1_PRI_POS 0000000E

Symbol: I2C1_PRI_POS
   Definitions



ARM Macro Assembler    Page 64 Alphabetic symbol ordering
Absolute symbols

      At line 2708 in file ..\Exercise
   Uses
      None
Comment: I2C1_PRI_POS unused
I2C1_Vector 00000019

Symbol: I2C1_Vector
   Definitions
      At line 2826 in file ..\Exercise
   Uses
      None
Comment: I2C1_Vector unused
I2S0_IPR E000E414

Symbol: I2S0_IPR
   Definitions
      At line 2686 in file ..\Exercise
   Uses
      None
Comment: I2S0_IPR unused
I2S0_IRQ 00000017

Symbol: I2S0_IRQ
   Definitions
      At line 2756 in file ..\Exercise
   Uses
      At line 2790 in file ..\Exercise
Comment: I2S0_IRQ used once
I2S0_IRQ_MASK 00800000

Symbol: I2S0_IRQ_MASK
   Definitions
      At line 2790 in file ..\Exercise
   Uses
      None
Comment: I2S0_IRQ_MASK unused
I2S0_IRQn 00000017

Symbol: I2S0_IRQn
   Definitions
      At line 169 in file ..\Exercise
   Uses
      None
Comment: I2S0_IRQn unused
I2S0_PRI_POS 0000001E

Symbol: I2S0_PRI_POS
   Definitions
      At line 2722 in file ..\Exercise
   Uses
      None
Comment: I2S0_PRI_POS unused
I2S0_Vector 00000027

Symbol: I2S0_Vector
   Definitions
      At line 2840 in file ..\Exercise
   Uses
      None



ARM Macro Assembler    Page 65 Alphabetic symbol ordering
Absolute symbols

Comment: I2S0_Vector unused
IN_PTR 00000000

Symbol: IN_PTR
   Definitions
      At line 220 in file ..\Exercise
   Uses
      At line 448 in file ..\Exercise
      At line 525 in file ..\Exercise
      At line 535 in file ..\Exercise

IPSR_EXCEPTION_MASK 0000003F

Symbol: IPSR_EXCEPTION_MASK
   Definitions
      At line 112 in file ..\Exercise
   Uses
      At line 125 in file ..\Exercise
Comment: IPSR_EXCEPTION_MASK used once
IPSR_EXCEPTION_SHIFT 00000000

Symbol: IPSR_EXCEPTION_SHIFT
   Definitions
      At line 113 in file ..\Exercise
   Uses
      At line 126 in file ..\Exercise
Comment: IPSR_EXCEPTION_SHIFT used once
IPSR_MASK 0000003F

Symbol: IPSR_MASK
   Definitions
      At line 110 in file ..\Exercise
   Uses
      None
Comment: IPSR_MASK unused
IPSR_SHIFT 00000000

Symbol: IPSR_SHIFT
   Definitions
      At line 111 in file ..\Exercise
   Uses
      None
Comment: IPSR_SHIFT unused
Init_SP_Vector 00000000

Symbol: Init_SP_Vector
   Definitions
      At line 2801 in file ..\Exercise
   Uses
      None
Comment: Init_SP_Vector unused
LCD_AR 40053004

Symbol: LCD_AR
   Definitions
      At line 1010 in file ..\Exercise
   Uses
      None
Comment: LCD_AR unused



ARM Macro Assembler    Page 66 Alphabetic symbol ordering
Absolute symbols

LCD_AR_ALT_MASK 00000040

Symbol: LCD_AR_ALT_MASK
   Definitions
      At line 1133 in file ..\Exercise
   Uses
      None
Comment: LCD_AR_ALT_MASK unused
LCD_AR_ALT_SHIFT 00000006

Symbol: LCD_AR_ALT_SHIFT
   Definitions
      At line 1134 in file ..\Exercise
   Uses
      None
Comment: LCD_AR_ALT_SHIFT unused
LCD_AR_BLANK_MASK 00000020

Symbol: LCD_AR_BLANK_MASK
   Definitions
      At line 1131 in file ..\Exercise
   Uses
      None
Comment: LCD_AR_BLANK_MASK unused
LCD_AR_BLANK_SHIFT 00000005

Symbol: LCD_AR_BLANK_SHIFT
   Definitions
      At line 1132 in file ..\Exercise
   Uses
      None
Comment: LCD_AR_BLANK_SHIFT unused
LCD_AR_BLINK_MASK 00000080

Symbol: LCD_AR_BLINK_MASK
   Definitions
      At line 1135 in file ..\Exercise
   Uses
      None
Comment: LCD_AR_BLINK_MASK unused
LCD_AR_BLINK_SHIFT 00000007

Symbol: LCD_AR_BLINK_SHIFT
   Definitions
      At line 1136 in file ..\Exercise
   Uses
      None
Comment: LCD_AR_BLINK_SHIFT unused
LCD_AR_BMODE_MASK 00000008

Symbol: LCD_AR_BMODE_MASK
   Definitions
      At line 1129 in file ..\Exercise
   Uses
      None
Comment: LCD_AR_BMODE_MASK unused
LCD_AR_BMODE_SHIFT 00000003

Symbol: LCD_AR_BMODE_SHIFT



ARM Macro Assembler    Page 67 Alphabetic symbol ordering
Absolute symbols

   Definitions
      At line 1130 in file ..\Exercise
   Uses
      None
Comment: LCD_AR_BMODE_SHIFT unused
LCD_AR_BRATE_MASK 00000007

Symbol: LCD_AR_BRATE_MASK
   Definitions
      At line 1127 in file ..\Exercise
   Uses
      None
Comment: LCD_AR_BRATE_MASK unused
LCD_AR_BRATE_SHIFT 00000000

Symbol: LCD_AR_BRATE_SHIFT
   Definitions
      At line 1128 in file ..\Exercise
   Uses
      None
Comment: LCD_AR_BRATE_SHIFT unused
LCD_AR_OFFSET 00000004

Symbol: LCD_AR_OFFSET
   Definitions
      At line 985 in file ..\Exercise
   Uses
      At line 1010 in file ..\Exercise
Comment: LCD_AR_OFFSET used once
LCD_BASE 40053000

Symbol: LCD_BASE
   Definitions
      At line 983 in file ..\Exercise
   Uses
      At line 1009 in file ..\Exercise
      At line 1010 in file ..\Exercise
      At line 1011 in file ..\Exercise
      At line 1012 in file ..\Exercise
      At line 1013 in file ..\Exercise
      At line 1014 in file ..\Exercise
      At line 1015 in file ..\Exercise
      At line 1016 in file ..\Exercise
      At line 1017 in file ..\Exercise
      At line 1018 in file ..\Exercise
      At line 1019 in file ..\Exercise
      At line 1020 in file ..\Exercise
      At line 1021 in file ..\Exercise
      At line 1022 in file ..\Exercise
      At line 1023 in file ..\Exercise
      At line 1024 in file ..\Exercise
      At line 1025 in file ..\Exercise
      At line 1026 in file ..\Exercise
      At line 1027 in file ..\Exercise
      At line 1028 in file ..\Exercise
      At line 1029 in file ..\Exercise
      At line 1030 in file ..\Exercise
      At line 1031 in file ..\Exercise
      At line 1032 in file ..\Exercise



ARM Macro Assembler    Page 68 Alphabetic symbol ordering
Absolute symbols

      At line 1033 in file ..\Exercise

LCD_BPENH 4005301C

Symbol: LCD_BPENH
   Definitions
      At line 1016 in file ..\Exercise
   Uses
      None
Comment: LCD_BPENH unused
LCD_BPENH_OFFSET 0000001C

Symbol: LCD_BPENH_OFFSET
   Definitions
      At line 991 in file ..\Exercise
   Uses
      At line 1016 in file ..\Exercise
Comment: LCD_BPENH_OFFSET used once
LCD_BPENL 40053018

Symbol: LCD_BPENL
   Definitions
      At line 1015 in file ..\Exercise
   Uses
      None
Comment: LCD_BPENL unused
LCD_BPENL_OFFSET 00000018

Symbol: LCD_BPENL_OFFSET
   Definitions
      At line 990 in file ..\Exercise
   Uses
      At line 1015 in file ..\Exercise
Comment: LCD_BPENL_OFFSET used once
LCD_BPEN_BPEN_MASK FFFFFFFF

Symbol: LCD_BPEN_BPEN_MASK
   Definitions
      At line 1183 in file ..\Exercise
   Uses
      None
Comment: LCD_BPEN_BPEN_MASK unused
LCD_BPEN_BPEN_SHIFT 00000000

Symbol: LCD_BPEN_BPEN_SHIFT
   Definitions
      At line 1184 in file ..\Exercise
   Uses
      None
Comment: LCD_BPEN_BPEN_SHIFT unused
LCD_FDCR 40053008

Symbol: LCD_FDCR
   Definitions
      At line 1011 in file ..\Exercise
   Uses
      None
Comment: LCD_FDCR unused
LCD_FDCR_FDBPEN_MASK 00000040



ARM Macro Assembler    Page 69 Alphabetic symbol ordering
Absolute symbols


Symbol: LCD_FDCR_FDBPEN_MASK
   Definitions
      At line 1151 in file ..\Exercise
   Uses
      None
Comment: LCD_FDCR_FDBPEN_MASK unused
LCD_FDCR_FDBPEN_SHIFT 00000006

Symbol: LCD_FDCR_FDBPEN_SHIFT
   Definitions
      At line 1152 in file ..\Exercise
   Uses
      None
Comment: LCD_FDCR_FDBPEN_SHIFT unused
LCD_FDCR_FDEN_MASK 00000080

Symbol: LCD_FDCR_FDEN_MASK
   Definitions
      At line 1153 in file ..\Exercise
   Uses
      None
Comment: LCD_FDCR_FDEN_MASK unused
LCD_FDCR_FDEN_SHIFT 00000007

Symbol: LCD_FDCR_FDEN_SHIFT
   Definitions
      At line 1154 in file ..\Exercise
   Uses
      None
Comment: LCD_FDCR_FDEN_SHIFT unused
LCD_FDCR_FDPINID_MASK 0000003F

Symbol: LCD_FDCR_FDPINID_MASK
   Definitions
      At line 1149 in file ..\Exercise
   Uses
      None
Comment: LCD_FDCR_FDPINID_MASK unused
LCD_FDCR_FDPINID_SHIFT 00000000

Symbol: LCD_FDCR_FDPINID_SHIFT
   Definitions
      At line 1150 in file ..\Exercise
   Uses
      None
Comment: LCD_FDCR_FDPINID_SHIFT unused
LCD_FDCR_FDPRS_MASK 00007000

Symbol: LCD_FDCR_FDPRS_MASK
   Definitions
      At line 1157 in file ..\Exercise
   Uses
      None
Comment: LCD_FDCR_FDPRS_MASK unused
LCD_FDCR_FDPRS_SHIFT 0000000C

Symbol: LCD_FDCR_FDPRS_SHIFT
   Definitions



ARM Macro Assembler    Page 70 Alphabetic symbol ordering
Absolute symbols

      At line 1158 in file ..\Exercise
   Uses
      None
Comment: LCD_FDCR_FDPRS_SHIFT unused
LCD_FDCR_FDSWW_MASK 00000E00

Symbol: LCD_FDCR_FDSWW_MASK
   Definitions
      At line 1155 in file ..\Exercise
   Uses
      None
Comment: LCD_FDCR_FDSWW_MASK unused
LCD_FDCR_FDSWW_SHIFT 00000009

Symbol: LCD_FDCR_FDSWW_SHIFT
   Definitions
      At line 1156 in file ..\Exercise
   Uses
      None
Comment: LCD_FDCR_FDSWW_SHIFT unused
LCD_FDCR_OFFSET 00000008

Symbol: LCD_FDCR_OFFSET
   Definitions
      At line 986 in file ..\Exercise
   Uses
      At line 1011 in file ..\Exercise
Comment: LCD_FDCR_OFFSET used once
LCD_FDSR 4005300C

Symbol: LCD_FDSR
   Definitions
      At line 1012 in file ..\Exercise
   Uses
      None
Comment: LCD_FDSR unused
LCD_FDSR_FDCF_MASK 00008000

Symbol: LCD_FDSR_FDCF_MASK
   Definitions
      At line 1171 in file ..\Exercise
   Uses
      None
Comment: LCD_FDSR_FDCF_MASK unused
LCD_FDSR_FDCF_SHIFT 0000000F

Symbol: LCD_FDSR_FDCF_SHIFT
   Definitions
      At line 1172 in file ..\Exercise
   Uses
      None
Comment: LCD_FDSR_FDCF_SHIFT unused
LCD_FDSR_FDCNT_MASK 000000FF

Symbol: LCD_FDSR_FDCNT_MASK
   Definitions
      At line 1169 in file ..\Exercise
   Uses
      None



ARM Macro Assembler    Page 71 Alphabetic symbol ordering
Absolute symbols

Comment: LCD_FDSR_FDCNT_MASK unused
LCD_FDSR_FDCNT_SHIFT 00000000

Symbol: LCD_FDSR_FDCNT_SHIFT
   Definitions
      At line 1170 in file ..\Exercise
   Uses
      None
Comment: LCD_FDSR_FDCNT_SHIFT unused
LCD_FDSR_OFFSET 0000000C

Symbol: LCD_FDSR_OFFSET
   Definitions
      At line 987 in file ..\Exercise
   Uses
      At line 1012 in file ..\Exercise
Comment: LCD_FDSR_OFFSET used once
LCD_GCR 40053000

Symbol: LCD_GCR
   Definitions
      At line 1009 in file ..\Exercise
   Uses
      None
Comment: LCD_GCR unused
LCD_GCR_ALTDIV_MASK 00003000

Symbol: LCD_GCR_ALTDIV_MASK
   Definitions
      At line 1097 in file ..\Exercise
   Uses
      None
Comment: LCD_GCR_ALTDIV_MASK unused
LCD_GCR_ALTDIV_SHIFT 0000000C

Symbol: LCD_GCR_ALTDIV_SHIFT
   Definitions
      At line 1098 in file ..\Exercise
   Uses
      None
Comment: LCD_GCR_ALTDIV_SHIFT unused
LCD_GCR_ALTSOURCE_MASK 00000800

Symbol: LCD_GCR_ALTSOURCE_MASK
   Definitions
      At line 1095 in file ..\Exercise
   Uses
      None
Comment: LCD_GCR_ALTSOURCE_MASK unused
LCD_GCR_ALTSOURCE_SHIFT 0000000B

Symbol: LCD_GCR_ALTSOURCE_SHIFT
   Definitions
      At line 1096 in file ..\Exercise
   Uses
      None
Comment: LCD_GCR_ALTSOURCE_SHIFT unused
LCD_GCR_CPSEL_MASK 00800000




ARM Macro Assembler    Page 72 Alphabetic symbol ordering
Absolute symbols

Symbol: LCD_GCR_CPSEL_MASK
   Definitions
      At line 1107 in file ..\Exercise
   Uses
      None
Comment: LCD_GCR_CPSEL_MASK unused
LCD_GCR_CPSEL_SHIFT 00000017

Symbol: LCD_GCR_CPSEL_SHIFT
   Definitions
      At line 1108 in file ..\Exercise
   Uses
      None
Comment: LCD_GCR_CPSEL_SHIFT unused
LCD_GCR_DUTY_MASK 00000007

Symbol: LCD_GCR_DUTY_MASK
   Definitions
      At line 1081 in file ..\Exercise
   Uses
      None
Comment: LCD_GCR_DUTY_MASK unused
LCD_GCR_DUTY_SHIFT 00000000

Symbol: LCD_GCR_DUTY_SHIFT
   Definitions
      At line 1082 in file ..\Exercise
   Uses
      None
Comment: LCD_GCR_DUTY_SHIFT unused
LCD_GCR_FDCIEN_MASK 00004000

Symbol: LCD_GCR_FDCIEN_MASK
   Definitions
      At line 1099 in file ..\Exercise
   Uses
      None
Comment: LCD_GCR_FDCIEN_MASK unused
LCD_GCR_FDCIEN_SHIFT 0000000E

Symbol: LCD_GCR_FDCIEN_SHIFT
   Definitions
      At line 1100 in file ..\Exercise
   Uses
      None
Comment: LCD_GCR_FDCIEN_SHIFT unused
LCD_GCR_FFR_MASK 00000400

Symbol: LCD_GCR_FFR_MASK
   Definitions
      At line 1093 in file ..\Exercise
   Uses
      None
Comment: LCD_GCR_FFR_MASK unused
LCD_GCR_FFR_SHIFT 0000000A

Symbol: LCD_GCR_FFR_SHIFT
   Definitions
      At line 1094 in file ..\Exercise



ARM Macro Assembler    Page 73 Alphabetic symbol ordering
Absolute symbols

   Uses
      None
Comment: LCD_GCR_FFR_SHIFT unused
LCD_GCR_LADJ_MASK 00300000

Symbol: LCD_GCR_LADJ_MASK
   Definitions
      At line 1105 in file ..\Exercise
   Uses
      None
Comment: LCD_GCR_LADJ_MASK unused
LCD_GCR_LADJ_SHIFT 00000014

Symbol: LCD_GCR_LADJ_SHIFT
   Definitions
      At line 1106 in file ..\Exercise
   Uses
      None
Comment: LCD_GCR_LADJ_SHIFT unused
LCD_GCR_LCDDOZE_MASK 00000200

Symbol: LCD_GCR_LCDDOZE_MASK
   Definitions
      At line 1091 in file ..\Exercise
   Uses
      None
Comment: LCD_GCR_LCDDOZE_MASK unused
LCD_GCR_LCDDOZE_SHIFT 00000009

Symbol: LCD_GCR_LCDDOZE_SHIFT
   Definitions
      At line 1092 in file ..\Exercise
   Uses
      None
Comment: LCD_GCR_LCDDOZE_SHIFT unused
LCD_GCR_LCDEN_MASK 00000080

Symbol: LCD_GCR_LCDEN_MASK
   Definitions
      At line 1087 in file ..\Exercise
   Uses
      None
Comment: LCD_GCR_LCDEN_MASK unused
LCD_GCR_LCDEN_SHIFT 00000007

Symbol: LCD_GCR_LCDEN_SHIFT
   Definitions
      At line 1088 in file ..\Exercise
   Uses
      None
Comment: LCD_GCR_LCDEN_SHIFT unused
LCD_GCR_LCDSTP_MASK 00000100

Symbol: LCD_GCR_LCDSTP_MASK
   Definitions
      At line 1089 in file ..\Exercise
   Uses
      None
Comment: LCD_GCR_LCDSTP_MASK unused



ARM Macro Assembler    Page 74 Alphabetic symbol ordering
Absolute symbols

LCD_GCR_LCDSTP_SHIFT 00000008

Symbol: LCD_GCR_LCDSTP_SHIFT
   Definitions
      At line 1090 in file ..\Exercise
   Uses
      None
Comment: LCD_GCR_LCDSTP_SHIFT unused
LCD_GCR_LCLK_MASK 00000038

Symbol: LCD_GCR_LCLK_MASK
   Definitions
      At line 1083 in file ..\Exercise
   Uses
      None
Comment: LCD_GCR_LCLK_MASK unused
LCD_GCR_LCLK_SHIFT 00000003

Symbol: LCD_GCR_LCLK_SHIFT
   Definitions
      At line 1084 in file ..\Exercise
   Uses
      None
Comment: LCD_GCR_LCLK_SHIFT unused
LCD_GCR_OFFSET 00000000

Symbol: LCD_GCR_OFFSET
   Definitions
      At line 984 in file ..\Exercise
   Uses
      At line 1009 in file ..\Exercise
Comment: LCD_GCR_OFFSET used once
LCD_GCR_PADSAFE_MASK 00008000

Symbol: LCD_GCR_PADSAFE_MASK
   Definitions
      At line 1101 in file ..\Exercise
   Uses
      None
Comment: LCD_GCR_PADSAFE_MASK unused
LCD_GCR_PADSAFE_SHIFT 0000000F

Symbol: LCD_GCR_PADSAFE_SHIFT
   Definitions
      At line 1102 in file ..\Exercise
   Uses
      None
Comment: LCD_GCR_PADSAFE_SHIFT unused
LCD_GCR_RVEN_MASK 80000000

Symbol: LCD_GCR_RVEN_MASK
   Definitions
      At line 1111 in file ..\Exercise
   Uses
      None
Comment: LCD_GCR_RVEN_MASK unused
LCD_GCR_RVEN_SHIFT 0000001F

Symbol: LCD_GCR_RVEN_SHIFT



ARM Macro Assembler    Page 75 Alphabetic symbol ordering
Absolute symbols

   Definitions
      At line 1112 in file ..\Exercise
   Uses
      None
Comment: LCD_GCR_RVEN_SHIFT unused
LCD_GCR_RVTRIM_MASK 0F000000

Symbol: LCD_GCR_RVTRIM_MASK
   Definitions
      At line 1109 in file ..\Exercise
   Uses
      None
Comment: LCD_GCR_RVTRIM_MASK unused
LCD_GCR_RVTRIM_SHIFT 00000018

Symbol: LCD_GCR_RVTRIM_SHIFT
   Definitions
      At line 1110 in file ..\Exercise
   Uses
      None
Comment: LCD_GCR_RVTRIM_SHIFT unused
LCD_GCR_SOURCE_MASK 00000040

Symbol: LCD_GCR_SOURCE_MASK
   Definitions
      At line 1085 in file ..\Exercise
   Uses
      None
Comment: LCD_GCR_SOURCE_MASK unused
LCD_GCR_SOURCE_SHIFT 00000006

Symbol: LCD_GCR_SOURCE_SHIFT
   Definitions
      At line 1086 in file ..\Exercise
   Uses
      None
Comment: LCD_GCR_SOURCE_SHIFT unused
LCD_GCR_VSUPPLY_MASK 00020000

Symbol: LCD_GCR_VSUPPLY_MASK
   Definitions
      At line 1103 in file ..\Exercise
   Uses
      None
Comment: LCD_GCR_VSUPPLY_MASK unused
LCD_GCR_VSUPPLY_SHIFT 00000011

Symbol: LCD_GCR_VSUPPLY_SHIFT
   Definitions
      At line 1104 in file ..\Exercise
   Uses
      None
Comment: LCD_GCR_VSUPPLY_SHIFT unused
LCD_IPR E000E41C

Symbol: LCD_IPR
   Definitions
      At line 2692 in file ..\Exercise
   Uses



ARM Macro Assembler    Page 76 Alphabetic symbol ordering
Absolute symbols

      None
Comment: LCD_IPR unused
LCD_IRQ 0000001D

Symbol: LCD_IRQ
   Definitions
      At line 2762 in file ..\Exercise
   Uses
      At line 2796 in file ..\Exercise
Comment: LCD_IRQ used once
LCD_IRQ_MASK 20000000

Symbol: LCD_IRQ_MASK
   Definitions
      At line 2796 in file ..\Exercise
   Uses
      None
Comment: LCD_IRQ_MASK unused
LCD_IRQn 0000001D

Symbol: LCD_IRQn
   Definitions
      At line 175 in file ..\Exercise
   Uses
      None
Comment: LCD_IRQn unused
LCD_PENH 40053014

Symbol: LCD_PENH
   Definitions
      At line 1014 in file ..\Exercise
   Uses
      None
Comment: LCD_PENH unused
LCD_PENH_OFFSET 00000014

Symbol: LCD_PENH_OFFSET
   Definitions
      At line 989 in file ..\Exercise
   Uses
      At line 1014 in file ..\Exercise
Comment: LCD_PENH_OFFSET used once
LCD_PENL 40053010

Symbol: LCD_PENL
   Definitions
      At line 1013 in file ..\Exercise
   Uses
      None
Comment: LCD_PENL unused
LCD_PENL_OFFSET 00000010

Symbol: LCD_PENL_OFFSET
   Definitions
      At line 988 in file ..\Exercise
   Uses
      At line 1013 in file ..\Exercise
Comment: LCD_PENL_OFFSET used once
LCD_PEN_PEN_MASK FFFFFFFF



ARM Macro Assembler    Page 77 Alphabetic symbol ordering
Absolute symbols


Symbol: LCD_PEN_PEN_MASK
   Definitions
      At line 1177 in file ..\Exercise
   Uses
      None
Comment: LCD_PEN_PEN_MASK unused
LCD_PEN_PEN_SHIFT 00000000

Symbol: LCD_PEN_PEN_SHIFT
   Definitions
      At line 1178 in file ..\Exercise
   Uses
      None
Comment: LCD_PEN_PEN_SHIFT unused
LCD_PRI_POS 0000000E

Symbol: LCD_PRI_POS
   Definitions
      At line 2728 in file ..\Exercise
   Uses
      None
Comment: LCD_PRI_POS unused
LCD_Vector 0000002D

Symbol: LCD_Vector
   Definitions
      At line 2846 in file ..\Exercise
   Uses
      None
Comment: LCD_Vector unused
LCD_WF 40053020

Symbol: LCD_WF
   Definitions
      At line 1017 in file ..\Exercise
   Uses
      None
Comment: LCD_WF unused
LCD_WF0_REG 40053020

Symbol: LCD_WF0_REG
   Definitions
      At line 1206 in file ..\Exercise
   Uses
      None
Comment: LCD_WF0_REG unused
LCD_WF10_REG 40053028

Symbol: LCD_WF10_REG
   Definitions
      At line 1216 in file ..\Exercise
   Uses
      None
Comment: LCD_WF10_REG unused
LCD_WF11TO8 40053028

Symbol: LCD_WF11TO8
   Definitions



ARM Macro Assembler    Page 78 Alphabetic symbol ordering
Absolute symbols

      At line 1020 in file ..\Exercise
   Uses
      At line 1214 in file ..\Exercise
      At line 1215 in file ..\Exercise
      At line 1216 in file ..\Exercise
      At line 1217 in file ..\Exercise

LCD_WF11TO8_OFFSET 00000028

Symbol: LCD_WF11TO8_OFFSET
   Definitions
      At line 995 in file ..\Exercise
   Uses
      At line 1020 in file ..\Exercise
Comment: LCD_WF11TO8_OFFSET used once
LCD_WF11_REG 40053028

Symbol: LCD_WF11_REG
   Definitions
      At line 1217 in file ..\Exercise
   Uses
      None
Comment: LCD_WF11_REG unused
LCD_WF12_REG 4005302C

Symbol: LCD_WF12_REG
   Definitions
      At line 1218 in file ..\Exercise
   Uses
      None
Comment: LCD_WF12_REG unused
LCD_WF13_REG 4005302C

Symbol: LCD_WF13_REG
   Definitions
      At line 1219 in file ..\Exercise
   Uses
      None
Comment: LCD_WF13_REG unused
LCD_WF14_REG 4005302C

Symbol: LCD_WF14_REG
   Definitions
      At line 1220 in file ..\Exercise
   Uses
      None
Comment: LCD_WF14_REG unused
LCD_WF15TO12 4005302C

Symbol: LCD_WF15TO12
   Definitions
      At line 1021 in file ..\Exercise
   Uses
      At line 1218 in file ..\Exercise
      At line 1219 in file ..\Exercise
      At line 1220 in file ..\Exercise
      At line 1221 in file ..\Exercise

LCD_WF15TO12_OFFSET 0000002C



ARM Macro Assembler    Page 79 Alphabetic symbol ordering
Absolute symbols


Symbol: LCD_WF15TO12_OFFSET
   Definitions
      At line 996 in file ..\Exercise
   Uses
      At line 1021 in file ..\Exercise
Comment: LCD_WF15TO12_OFFSET used once
LCD_WF15_REG 4005302C

Symbol: LCD_WF15_REG
   Definitions
      At line 1221 in file ..\Exercise
   Uses
      None
Comment: LCD_WF15_REG unused
LCD_WF16_REG 40053030

Symbol: LCD_WF16_REG
   Definitions
      At line 1222 in file ..\Exercise
   Uses
      None
Comment: LCD_WF16_REG unused
LCD_WF17_REG 40053030

Symbol: LCD_WF17_REG
   Definitions
      At line 1223 in file ..\Exercise
   Uses
      None
Comment: LCD_WF17_REG unused
LCD_WF18_REG 40053030

Symbol: LCD_WF18_REG
   Definitions
      At line 1224 in file ..\Exercise
   Uses
      None
Comment: LCD_WF18_REG unused
LCD_WF19TO16 40053030

Symbol: LCD_WF19TO16
   Definitions
      At line 1022 in file ..\Exercise
   Uses
      At line 1222 in file ..\Exercise
      At line 1223 in file ..\Exercise
      At line 1224 in file ..\Exercise
      At line 1225 in file ..\Exercise

LCD_WF19TO16_OFFSET 00000030

Symbol: LCD_WF19TO16_OFFSET
   Definitions
      At line 997 in file ..\Exercise
   Uses
      At line 1022 in file ..\Exercise
Comment: LCD_WF19TO16_OFFSET used once
LCD_WF19_REG 40053030



ARM Macro Assembler    Page 80 Alphabetic symbol ordering
Absolute symbols


Symbol: LCD_WF19_REG
   Definitions
      At line 1225 in file ..\Exercise
   Uses
      None
Comment: LCD_WF19_REG unused
LCD_WF1_REG 40053020

Symbol: LCD_WF1_REG
   Definitions
      At line 1207 in file ..\Exercise
   Uses
      None
Comment: LCD_WF1_REG unused
LCD_WF20_REG 40053034

Symbol: LCD_WF20_REG
   Definitions
      At line 1226 in file ..\Exercise
   Uses
      None
Comment: LCD_WF20_REG unused
LCD_WF21_REG 40053034

Symbol: LCD_WF21_REG
   Definitions
      At line 1227 in file ..\Exercise
   Uses
      None
Comment: LCD_WF21_REG unused
LCD_WF22_REG 40053034

Symbol: LCD_WF22_REG
   Definitions
      At line 1228 in file ..\Exercise
   Uses
      None
Comment: LCD_WF22_REG unused
LCD_WF23TO20 40053034

Symbol: LCD_WF23TO20
   Definitions
      At line 1023 in file ..\Exercise
   Uses
      At line 1226 in file ..\Exercise
      At line 1227 in file ..\Exercise
      At line 1228 in file ..\Exercise
      At line 1229 in file ..\Exercise

LCD_WF23TO20_OFFSET 00000034

Symbol: LCD_WF23TO20_OFFSET
   Definitions
      At line 998 in file ..\Exercise
   Uses
      At line 1023 in file ..\Exercise
Comment: LCD_WF23TO20_OFFSET used once
LCD_WF23_REG 40053034



ARM Macro Assembler    Page 81 Alphabetic symbol ordering
Absolute symbols


Symbol: LCD_WF23_REG
   Definitions
      At line 1229 in file ..\Exercise
   Uses
      None
Comment: LCD_WF23_REG unused
LCD_WF24_REG 40053038

Symbol: LCD_WF24_REG
   Definitions
      At line 1230 in file ..\Exercise
   Uses
      None
Comment: LCD_WF24_REG unused
LCD_WF25_REG 40053038

Symbol: LCD_WF25_REG
   Definitions
      At line 1231 in file ..\Exercise
   Uses
      None
Comment: LCD_WF25_REG unused
LCD_WF26_REG 40053038

Symbol: LCD_WF26_REG
   Definitions
      At line 1232 in file ..\Exercise
   Uses
      None
Comment: LCD_WF26_REG unused
LCD_WF27TO24 40053038

Symbol: LCD_WF27TO24
   Definitions
      At line 1024 in file ..\Exercise
   Uses
      At line 1230 in file ..\Exercise
      At line 1231 in file ..\Exercise
      At line 1232 in file ..\Exercise
      At line 1233 in file ..\Exercise

LCD_WF27TO24_OFFSET 00000038

Symbol: LCD_WF27TO24_OFFSET
   Definitions
      At line 999 in file ..\Exercise
   Uses
      At line 1024 in file ..\Exercise
Comment: LCD_WF27TO24_OFFSET used once
LCD_WF27_REG 40053038

Symbol: LCD_WF27_REG
   Definitions
      At line 1233 in file ..\Exercise
   Uses
      None
Comment: LCD_WF27_REG unused
LCD_WF28_REG 4005303C



ARM Macro Assembler    Page 82 Alphabetic symbol ordering
Absolute symbols


Symbol: LCD_WF28_REG
   Definitions
      At line 1234 in file ..\Exercise
   Uses
      None
Comment: LCD_WF28_REG unused
LCD_WF29_REG 4005303C

Symbol: LCD_WF29_REG
   Definitions
      At line 1235 in file ..\Exercise
   Uses
      None
Comment: LCD_WF29_REG unused
LCD_WF2_REG 40053020

Symbol: LCD_WF2_REG
   Definitions
      At line 1208 in file ..\Exercise
   Uses
      None
Comment: LCD_WF2_REG unused
LCD_WF30_REG 4005303C

Symbol: LCD_WF30_REG
   Definitions
      At line 1236 in file ..\Exercise
   Uses
      None
Comment: LCD_WF30_REG unused
LCD_WF31TO28 4005303C

Symbol: LCD_WF31TO28
   Definitions
      At line 1025 in file ..\Exercise
   Uses
      At line 1234 in file ..\Exercise
      At line 1235 in file ..\Exercise
      At line 1236 in file ..\Exercise
      At line 1237 in file ..\Exercise

LCD_WF31TO28_OFFSET 0000003C

Symbol: LCD_WF31TO28_OFFSET
   Definitions
      At line 1000 in file ..\Exercise
   Uses
      At line 1025 in file ..\Exercise
Comment: LCD_WF31TO28_OFFSET used once
LCD_WF31_REG 4005303C

Symbol: LCD_WF31_REG
   Definitions
      At line 1237 in file ..\Exercise
   Uses
      None
Comment: LCD_WF31_REG unused
LCD_WF32_REG 40053040



ARM Macro Assembler    Page 83 Alphabetic symbol ordering
Absolute symbols


Symbol: LCD_WF32_REG
   Definitions
      At line 1238 in file ..\Exercise
   Uses
      None
Comment: LCD_WF32_REG unused
LCD_WF33_REG 40053040

Symbol: LCD_WF33_REG
   Definitions
      At line 1239 in file ..\Exercise
   Uses
      None
Comment: LCD_WF33_REG unused
LCD_WF34_REG 40053040

Symbol: LCD_WF34_REG
   Definitions
      At line 1240 in file ..\Exercise
   Uses
      None
Comment: LCD_WF34_REG unused
LCD_WF35TO32 40053040

Symbol: LCD_WF35TO32
   Definitions
      At line 1026 in file ..\Exercise
   Uses
      At line 1238 in file ..\Exercise
      At line 1239 in file ..\Exercise
      At line 1240 in file ..\Exercise
      At line 1241 in file ..\Exercise

LCD_WF35TO32_OFFSET 00000040

Symbol: LCD_WF35TO32_OFFSET
   Definitions
      At line 1001 in file ..\Exercise
   Uses
      At line 1026 in file ..\Exercise
Comment: LCD_WF35TO32_OFFSET used once
LCD_WF35_REG 40053040

Symbol: LCD_WF35_REG
   Definitions
      At line 1241 in file ..\Exercise
   Uses
      None
Comment: LCD_WF35_REG unused
LCD_WF36_REG 40053044

Symbol: LCD_WF36_REG
   Definitions
      At line 1242 in file ..\Exercise
   Uses
      None
Comment: LCD_WF36_REG unused
LCD_WF37_REG 40053044



ARM Macro Assembler    Page 84 Alphabetic symbol ordering
Absolute symbols


Symbol: LCD_WF37_REG
   Definitions
      At line 1243 in file ..\Exercise
   Uses
      None
Comment: LCD_WF37_REG unused
LCD_WF38_REG 40053044

Symbol: LCD_WF38_REG
   Definitions
      At line 1244 in file ..\Exercise
   Uses
      None
Comment: LCD_WF38_REG unused
LCD_WF39TO36 40053044

Symbol: LCD_WF39TO36
   Definitions
      At line 1027 in file ..\Exercise
   Uses
      At line 1242 in file ..\Exercise
      At line 1243 in file ..\Exercise
      At line 1244 in file ..\Exercise
      At line 1245 in file ..\Exercise

LCD_WF39TO36_OFFSET 00000044

Symbol: LCD_WF39TO36_OFFSET
   Definitions
      At line 1002 in file ..\Exercise
   Uses
      At line 1027 in file ..\Exercise
Comment: LCD_WF39TO36_OFFSET used once
LCD_WF39_REG 40053044

Symbol: LCD_WF39_REG
   Definitions
      At line 1245 in file ..\Exercise
   Uses
      None
Comment: LCD_WF39_REG unused
LCD_WF3TO0 40053020

Symbol: LCD_WF3TO0
   Definitions
      At line 1018 in file ..\Exercise
   Uses
      At line 1206 in file ..\Exercise
      At line 1207 in file ..\Exercise
      At line 1208 in file ..\Exercise
      At line 1209 in file ..\Exercise

LCD_WF3TO0_OFFSET 00000020

Symbol: LCD_WF3TO0_OFFSET
   Definitions
      At line 993 in file ..\Exercise
   Uses



ARM Macro Assembler    Page 85 Alphabetic symbol ordering
Absolute symbols

      At line 1018 in file ..\Exercise
Comment: LCD_WF3TO0_OFFSET used once
LCD_WF3_REG 40053020

Symbol: LCD_WF3_REG
   Definitions
      At line 1209 in file ..\Exercise
   Uses
      None
Comment: LCD_WF3_REG unused
LCD_WF40_REG 40053048

Symbol: LCD_WF40_REG
   Definitions
      At line 1246 in file ..\Exercise
   Uses
      None
Comment: LCD_WF40_REG unused
LCD_WF41_REG 40053048

Symbol: LCD_WF41_REG
   Definitions
      At line 1247 in file ..\Exercise
   Uses
      None
Comment: LCD_WF41_REG unused
LCD_WF42_REG 40053048

Symbol: LCD_WF42_REG
   Definitions
      At line 1248 in file ..\Exercise
   Uses
      None
Comment: LCD_WF42_REG unused
LCD_WF43TO40 40053048

Symbol: LCD_WF43TO40
   Definitions
      At line 1028 in file ..\Exercise
   Uses
      At line 1246 in file ..\Exercise
      At line 1247 in file ..\Exercise
      At line 1248 in file ..\Exercise
      At line 1249 in file ..\Exercise

LCD_WF43TO40_OFFSET 00000048

Symbol: LCD_WF43TO40_OFFSET
   Definitions
      At line 1003 in file ..\Exercise
   Uses
      At line 1028 in file ..\Exercise
Comment: LCD_WF43TO40_OFFSET used once
LCD_WF43_REG 40053048

Symbol: LCD_WF43_REG
   Definitions
      At line 1249 in file ..\Exercise
   Uses



ARM Macro Assembler    Page 86 Alphabetic symbol ordering
Absolute symbols

      None
Comment: LCD_WF43_REG unused
LCD_WF44_REG 4005304C

Symbol: LCD_WF44_REG
   Definitions
      At line 1250 in file ..\Exercise
   Uses
      None
Comment: LCD_WF44_REG unused
LCD_WF45_REG 4005304C

Symbol: LCD_WF45_REG
   Definitions
      At line 1251 in file ..\Exercise
   Uses
      None
Comment: LCD_WF45_REG unused
LCD_WF46_REG 4005304C

Symbol: LCD_WF46_REG
   Definitions
      At line 1252 in file ..\Exercise
   Uses
      None
Comment: LCD_WF46_REG unused
LCD_WF47TO44 4005304C

Symbol: LCD_WF47TO44
   Definitions
      At line 1029 in file ..\Exercise
   Uses
      At line 1250 in file ..\Exercise
      At line 1251 in file ..\Exercise
      At line 1252 in file ..\Exercise
      At line 1253 in file ..\Exercise

LCD_WF47TO44_OFFSET 0000004C

Symbol: LCD_WF47TO44_OFFSET
   Definitions
      At line 1004 in file ..\Exercise
   Uses
      At line 1029 in file ..\Exercise
Comment: LCD_WF47TO44_OFFSET used once
LCD_WF47_REG 4005304C

Symbol: LCD_WF47_REG
   Definitions
      At line 1253 in file ..\Exercise
   Uses
      None
Comment: LCD_WF47_REG unused
LCD_WF48_REG 40053050

Symbol: LCD_WF48_REG
   Definitions
      At line 1254 in file ..\Exercise
   Uses



ARM Macro Assembler    Page 87 Alphabetic symbol ordering
Absolute symbols

      None
Comment: LCD_WF48_REG unused
LCD_WF49_REG 40053050

Symbol: LCD_WF49_REG
   Definitions
      At line 1255 in file ..\Exercise
   Uses
      None
Comment: LCD_WF49_REG unused
LCD_WF4_REG 40053024

Symbol: LCD_WF4_REG
   Definitions
      At line 1210 in file ..\Exercise
   Uses
      None
Comment: LCD_WF4_REG unused
LCD_WF50_REG 40053050

Symbol: LCD_WF50_REG
   Definitions
      At line 1256 in file ..\Exercise
   Uses
      None
Comment: LCD_WF50_REG unused
LCD_WF51TO48 40053050

Symbol: LCD_WF51TO48
   Definitions
      At line 1030 in file ..\Exercise
   Uses
      At line 1254 in file ..\Exercise
      At line 1255 in file ..\Exercise
      At line 1256 in file ..\Exercise
      At line 1257 in file ..\Exercise

LCD_WF51TO48_OFFSET 00000050

Symbol: LCD_WF51TO48_OFFSET
   Definitions
      At line 1005 in file ..\Exercise
   Uses
      At line 1030 in file ..\Exercise
Comment: LCD_WF51TO48_OFFSET used once
LCD_WF51_REG 40053050

Symbol: LCD_WF51_REG
   Definitions
      At line 1257 in file ..\Exercise
   Uses
      None
Comment: LCD_WF51_REG unused
LCD_WF52_REG 40053054

Symbol: LCD_WF52_REG
   Definitions
      At line 1258 in file ..\Exercise
   Uses



ARM Macro Assembler    Page 88 Alphabetic symbol ordering
Absolute symbols

      None
Comment: LCD_WF52_REG unused
LCD_WF53_REG 40053054

Symbol: LCD_WF53_REG
   Definitions
      At line 1259 in file ..\Exercise
   Uses
      None
Comment: LCD_WF53_REG unused
LCD_WF54_REG 40053054

Symbol: LCD_WF54_REG
   Definitions
      At line 1260 in file ..\Exercise
   Uses
      None
Comment: LCD_WF54_REG unused
LCD_WF55TO52 40053054

Symbol: LCD_WF55TO52
   Definitions
      At line 1031 in file ..\Exercise
   Uses
      At line 1258 in file ..\Exercise
      At line 1259 in file ..\Exercise
      At line 1260 in file ..\Exercise
      At line 1261 in file ..\Exercise

LCD_WF55TO52_OFFSET 00000054

Symbol: LCD_WF55TO52_OFFSET
   Definitions
      At line 1006 in file ..\Exercise
   Uses
      At line 1031 in file ..\Exercise
Comment: LCD_WF55TO52_OFFSET used once
LCD_WF55_REG 40053054

Symbol: LCD_WF55_REG
   Definitions
      At line 1261 in file ..\Exercise
   Uses
      None
Comment: LCD_WF55_REG unused
LCD_WF56_REG 40053058

Symbol: LCD_WF56_REG
   Definitions
      At line 1262 in file ..\Exercise
   Uses
      None
Comment: LCD_WF56_REG unused
LCD_WF57_REG 40053058

Symbol: LCD_WF57_REG
   Definitions
      At line 1263 in file ..\Exercise
   Uses



ARM Macro Assembler    Page 89 Alphabetic symbol ordering
Absolute symbols

      None
Comment: LCD_WF57_REG unused
LCD_WF58_REG 40053058

Symbol: LCD_WF58_REG
   Definitions
      At line 1264 in file ..\Exercise
   Uses
      None
Comment: LCD_WF58_REG unused
LCD_WF59TO56 40053058

Symbol: LCD_WF59TO56
   Definitions
      At line 1032 in file ..\Exercise
   Uses
      At line 1262 in file ..\Exercise
      At line 1263 in file ..\Exercise
      At line 1264 in file ..\Exercise
      At line 1265 in file ..\Exercise

LCD_WF59TO56_OFFSET 00000058

Symbol: LCD_WF59TO56_OFFSET
   Definitions
      At line 1007 in file ..\Exercise
   Uses
      At line 1032 in file ..\Exercise
Comment: LCD_WF59TO56_OFFSET used once
LCD_WF59_REG 40053058

Symbol: LCD_WF59_REG
   Definitions
      At line 1265 in file ..\Exercise
   Uses
      None
Comment: LCD_WF59_REG unused
LCD_WF5_REG 40053024

Symbol: LCD_WF5_REG
   Definitions
      At line 1211 in file ..\Exercise
   Uses
      None
Comment: LCD_WF5_REG unused
LCD_WF60_REG 4005305C

Symbol: LCD_WF60_REG
   Definitions
      At line 1266 in file ..\Exercise
   Uses
      None
Comment: LCD_WF60_REG unused
LCD_WF61_REG 4005305C

Symbol: LCD_WF61_REG
   Definitions
      At line 1267 in file ..\Exercise
   Uses



ARM Macro Assembler    Page 90 Alphabetic symbol ordering
Absolute symbols

      None
Comment: LCD_WF61_REG unused
LCD_WF62_REG 4005305C

Symbol: LCD_WF62_REG
   Definitions
      At line 1268 in file ..\Exercise
   Uses
      None
Comment: LCD_WF62_REG unused
LCD_WF63TO60 4005305C

Symbol: LCD_WF63TO60
   Definitions
      At line 1033 in file ..\Exercise
   Uses
      At line 1266 in file ..\Exercise
      At line 1267 in file ..\Exercise
      At line 1268 in file ..\Exercise
      At line 1269 in file ..\Exercise

LCD_WF63TO60_OFFSET 0000005C

Symbol: LCD_WF63TO60_OFFSET
   Definitions
      At line 1008 in file ..\Exercise
   Uses
      At line 1033 in file ..\Exercise
Comment: LCD_WF63TO60_OFFSET used once
LCD_WF63_REG 4005305C

Symbol: LCD_WF63_REG
   Definitions
      At line 1269 in file ..\Exercise
   Uses
      None
Comment: LCD_WF63_REG unused
LCD_WF6_REG 40053024

Symbol: LCD_WF6_REG
   Definitions
      At line 1212 in file ..\Exercise
   Uses
      None
Comment: LCD_WF6_REG unused
LCD_WF7TO4 40053024

Symbol: LCD_WF7TO4
   Definitions
      At line 1019 in file ..\Exercise
   Uses
      At line 1210 in file ..\Exercise
      At line 1211 in file ..\Exercise
      At line 1212 in file ..\Exercise
      At line 1213 in file ..\Exercise

LCD_WF7TO4_OFFSET 00000024

Symbol: LCD_WF7TO4_OFFSET



ARM Macro Assembler    Page 91 Alphabetic symbol ordering
Absolute symbols

   Definitions
      At line 994 in file ..\Exercise
   Uses
      At line 1019 in file ..\Exercise
Comment: LCD_WF7TO4_OFFSET used once
LCD_WF7_REG 40053024

Symbol: LCD_WF7_REG
   Definitions
      At line 1213 in file ..\Exercise
   Uses
      None
Comment: LCD_WF7_REG unused
LCD_WF8B_BPALCD0_MASK 00000001

Symbol: LCD_WF8B_BPALCD0_MASK
   Definitions
      At line 1431 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPALCD0_MASK unused
LCD_WF8B_BPALCD0_SHIFT 00000000

Symbol: LCD_WF8B_BPALCD0_SHIFT
   Definitions
      At line 1432 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPALCD0_SHIFT unused
LCD_WF8B_BPALCD10_MASK 00000001

Symbol: LCD_WF8B_BPALCD10_MASK
   Definitions
      At line 1553 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPALCD10_MASK unused
LCD_WF8B_BPALCD10_SHIFT 00000000

Symbol: LCD_WF8B_BPALCD10_SHIFT
   Definitions
      At line 1554 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPALCD10_SHIFT unused
LCD_WF8B_BPALCD11_MASK 00000001

Symbol: LCD_WF8B_BPALCD11_MASK
   Definitions
      At line 1551 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPALCD11_MASK unused
LCD_WF8B_BPALCD11_SHIFT 00000000

Symbol: LCD_WF8B_BPALCD11_SHIFT
   Definitions
      At line 1552 in file ..\Exercise
   Uses



ARM Macro Assembler    Page 92 Alphabetic symbol ordering
Absolute symbols

      None
Comment: LCD_WF8B_BPALCD11_SHIFT unused
LCD_WF8B_BPALCD12_MASK 00000001

Symbol: LCD_WF8B_BPALCD12_MASK
   Definitions
      At line 1549 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPALCD12_MASK unused
LCD_WF8B_BPALCD12_SHIFT 00000000

Symbol: LCD_WF8B_BPALCD12_SHIFT
   Definitions
      At line 1550 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPALCD12_SHIFT unused
LCD_WF8B_BPALCD13_MASK 00000001

Symbol: LCD_WF8B_BPALCD13_MASK
   Definitions
      At line 1547 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPALCD13_MASK unused
LCD_WF8B_BPALCD13_SHIFT 00000000

Symbol: LCD_WF8B_BPALCD13_SHIFT
   Definitions
      At line 1548 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPALCD13_SHIFT unused
LCD_WF8B_BPALCD14_MASK 00000001

Symbol: LCD_WF8B_BPALCD14_MASK
   Definitions
      At line 1545 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPALCD14_MASK unused
LCD_WF8B_BPALCD14_SHIFT 00000000

Symbol: LCD_WF8B_BPALCD14_SHIFT
   Definitions
      At line 1546 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPALCD14_SHIFT unused
LCD_WF8B_BPALCD15_MASK 00000001

Symbol: LCD_WF8B_BPALCD15_MASK
   Definitions
      At line 1541 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPALCD15_MASK unused
LCD_WF8B_BPALCD15_SHIFT 00000000



ARM Macro Assembler    Page 93 Alphabetic symbol ordering
Absolute symbols


Symbol: LCD_WF8B_BPALCD15_SHIFT
   Definitions
      At line 1542 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPALCD15_SHIFT unused
LCD_WF8B_BPALCD16_MASK 00000001

Symbol: LCD_WF8B_BPALCD16_MASK
   Definitions
      At line 1539 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPALCD16_MASK unused
LCD_WF8B_BPALCD16_SHIFT 00000000

Symbol: LCD_WF8B_BPALCD16_SHIFT
   Definitions
      At line 1540 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPALCD16_SHIFT unused
LCD_WF8B_BPALCD17_MASK 00000001

Symbol: LCD_WF8B_BPALCD17_MASK
   Definitions
      At line 1537 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPALCD17_MASK unused
LCD_WF8B_BPALCD17_SHIFT 00000000

Symbol: LCD_WF8B_BPALCD17_SHIFT
   Definitions
      At line 1538 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPALCD17_SHIFT unused
LCD_WF8B_BPALCD18_MASK 00000001

Symbol: LCD_WF8B_BPALCD18_MASK
   Definitions
      At line 1535 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPALCD18_MASK unused
LCD_WF8B_BPALCD18_SHIFT 00000000

Symbol: LCD_WF8B_BPALCD18_SHIFT
   Definitions
      At line 1536 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPALCD18_SHIFT unused
LCD_WF8B_BPALCD19_MASK 00000001

Symbol: LCD_WF8B_BPALCD19_MASK
   Definitions



ARM Macro Assembler    Page 94 Alphabetic symbol ordering
Absolute symbols

      At line 1533 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPALCD19_MASK unused
LCD_WF8B_BPALCD19_SHIFT 00000000

Symbol: LCD_WF8B_BPALCD19_SHIFT
   Definitions
      At line 1534 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPALCD19_SHIFT unused
LCD_WF8B_BPALCD1_MASK 00000001

Symbol: LCD_WF8B_BPALCD1_MASK
   Definitions
      At line 1447 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPALCD1_MASK unused
LCD_WF8B_BPALCD1_SHIFT 00000000

Symbol: LCD_WF8B_BPALCD1_SHIFT
   Definitions
      At line 1448 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPALCD1_SHIFT unused
LCD_WF8B_BPALCD20_MASK 00000001

Symbol: LCD_WF8B_BPALCD20_MASK
   Definitions
      At line 1531 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPALCD20_MASK unused
LCD_WF8B_BPALCD20_SHIFT 00000000

Symbol: LCD_WF8B_BPALCD20_SHIFT
   Definitions
      At line 1532 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPALCD20_SHIFT unused
LCD_WF8B_BPALCD21_MASK 00000001

Symbol: LCD_WF8B_BPALCD21_MASK
   Definitions
      At line 1529 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPALCD21_MASK unused
LCD_WF8B_BPALCD21_SHIFT 00000000

Symbol: LCD_WF8B_BPALCD21_SHIFT
   Definitions
      At line 1530 in file ..\Exercise
   Uses
      None



ARM Macro Assembler    Page 95 Alphabetic symbol ordering
Absolute symbols

Comment: LCD_WF8B_BPALCD21_SHIFT unused
LCD_WF8B_BPALCD22_MASK 00000001

Symbol: LCD_WF8B_BPALCD22_MASK
   Definitions
      At line 1525 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPALCD22_MASK unused
LCD_WF8B_BPALCD22_SHIFT 00000000

Symbol: LCD_WF8B_BPALCD22_SHIFT
   Definitions
      At line 1526 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPALCD22_SHIFT unused
LCD_WF8B_BPALCD23_MASK 00000001

Symbol: LCD_WF8B_BPALCD23_MASK
   Definitions
      At line 1523 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPALCD23_MASK unused
LCD_WF8B_BPALCD23_SHIFT 00000000

Symbol: LCD_WF8B_BPALCD23_SHIFT
   Definitions
      At line 1524 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPALCD23_SHIFT unused
LCD_WF8B_BPALCD24_MASK 00000001

Symbol: LCD_WF8B_BPALCD24_MASK
   Definitions
      At line 1521 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPALCD24_MASK unused
LCD_WF8B_BPALCD24_SHIFT 00000000

Symbol: LCD_WF8B_BPALCD24_SHIFT
   Definitions
      At line 1522 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPALCD24_SHIFT unused
LCD_WF8B_BPALCD25_MASK 00000001

Symbol: LCD_WF8B_BPALCD25_MASK
   Definitions
      At line 1519 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPALCD25_MASK unused
LCD_WF8B_BPALCD25_SHIFT 00000000




ARM Macro Assembler    Page 96 Alphabetic symbol ordering
Absolute symbols

Symbol: LCD_WF8B_BPALCD25_SHIFT
   Definitions
      At line 1520 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPALCD25_SHIFT unused
LCD_WF8B_BPALCD26_MASK 00000001

Symbol: LCD_WF8B_BPALCD26_MASK
   Definitions
      At line 1517 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPALCD26_MASK unused
LCD_WF8B_BPALCD26_SHIFT 00000000

Symbol: LCD_WF8B_BPALCD26_SHIFT
   Definitions
      At line 1518 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPALCD26_SHIFT unused
LCD_WF8B_BPALCD27_MASK 00000001

Symbol: LCD_WF8B_BPALCD27_MASK
   Definitions
      At line 1515 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPALCD27_MASK unused
LCD_WF8B_BPALCD27_SHIFT 00000000

Symbol: LCD_WF8B_BPALCD27_SHIFT
   Definitions
      At line 1516 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPALCD27_SHIFT unused
LCD_WF8B_BPALCD28_MASK 00000001

Symbol: LCD_WF8B_BPALCD28_MASK
   Definitions
      At line 1513 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPALCD28_MASK unused
LCD_WF8B_BPALCD28_SHIFT 00000000

Symbol: LCD_WF8B_BPALCD28_SHIFT
   Definitions
      At line 1514 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPALCD28_SHIFT unused
LCD_WF8B_BPALCD29_MASK 00000001

Symbol: LCD_WF8B_BPALCD29_MASK
   Definitions
      At line 1509 in file ..\Exercise



ARM Macro Assembler    Page 97 Alphabetic symbol ordering
Absolute symbols

   Uses
      None
Comment: LCD_WF8B_BPALCD29_MASK unused
LCD_WF8B_BPALCD29_SHIFT 00000000

Symbol: LCD_WF8B_BPALCD29_SHIFT
   Definitions
      At line 1510 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPALCD29_SHIFT unused
LCD_WF8B_BPALCD2_MASK 00000001

Symbol: LCD_WF8B_BPALCD2_MASK
   Definitions
      At line 1463 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPALCD2_MASK unused
LCD_WF8B_BPALCD2_SHIFT 00000000

Symbol: LCD_WF8B_BPALCD2_SHIFT
   Definitions
      At line 1464 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPALCD2_SHIFT unused
LCD_WF8B_BPALCD30_MASK 00000001

Symbol: LCD_WF8B_BPALCD30_MASK
   Definitions
      At line 1507 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPALCD30_MASK unused
LCD_WF8B_BPALCD30_SHIFT 00000000

Symbol: LCD_WF8B_BPALCD30_SHIFT
   Definitions
      At line 1508 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPALCD30_SHIFT unused
LCD_WF8B_BPALCD31_MASK 00000001

Symbol: LCD_WF8B_BPALCD31_MASK
   Definitions
      At line 1505 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPALCD31_MASK unused
LCD_WF8B_BPALCD31_SHIFT 00000000

Symbol: LCD_WF8B_BPALCD31_SHIFT
   Definitions
      At line 1506 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPALCD31_SHIFT unused



ARM Macro Assembler    Page 98 Alphabetic symbol ordering
Absolute symbols

LCD_WF8B_BPALCD32_MASK 00000001

Symbol: LCD_WF8B_BPALCD32_MASK
   Definitions
      At line 1503 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPALCD32_MASK unused
LCD_WF8B_BPALCD32_SHIFT 00000000

Symbol: LCD_WF8B_BPALCD32_SHIFT
   Definitions
      At line 1504 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPALCD32_SHIFT unused
LCD_WF8B_BPALCD33_MASK 00000001

Symbol: LCD_WF8B_BPALCD33_MASK
   Definitions
      At line 1501 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPALCD33_MASK unused
LCD_WF8B_BPALCD33_SHIFT 00000000

Symbol: LCD_WF8B_BPALCD33_SHIFT
   Definitions
      At line 1502 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPALCD33_SHIFT unused
LCD_WF8B_BPALCD34_MASK 00000001

Symbol: LCD_WF8B_BPALCD34_MASK
   Definitions
      At line 1499 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPALCD34_MASK unused
LCD_WF8B_BPALCD34_SHIFT 00000000

Symbol: LCD_WF8B_BPALCD34_SHIFT
   Definitions
      At line 1500 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPALCD34_SHIFT unused
LCD_WF8B_BPALCD35_MASK 00000001

Symbol: LCD_WF8B_BPALCD35_MASK
   Definitions
      At line 1497 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPALCD35_MASK unused
LCD_WF8B_BPALCD35_SHIFT 00000000

Symbol: LCD_WF8B_BPALCD35_SHIFT



ARM Macro Assembler    Page 99 Alphabetic symbol ordering
Absolute symbols

   Definitions
      At line 1498 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPALCD35_SHIFT unused
LCD_WF8B_BPALCD36_MASK 00000001

Symbol: LCD_WF8B_BPALCD36_MASK
   Definitions
      At line 1493 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPALCD36_MASK unused
LCD_WF8B_BPALCD36_SHIFT 00000000

Symbol: LCD_WF8B_BPALCD36_SHIFT
   Definitions
      At line 1494 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPALCD36_SHIFT unused
LCD_WF8B_BPALCD37_MASK 00000001

Symbol: LCD_WF8B_BPALCD37_MASK
   Definitions
      At line 1491 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPALCD37_MASK unused
LCD_WF8B_BPALCD37_SHIFT 00000000

Symbol: LCD_WF8B_BPALCD37_SHIFT
   Definitions
      At line 1492 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPALCD37_SHIFT unused
LCD_WF8B_BPALCD38_MASK 00000001

Symbol: LCD_WF8B_BPALCD38_MASK
   Definitions
      At line 1489 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPALCD38_MASK unused
LCD_WF8B_BPALCD38_SHIFT 00000000

Symbol: LCD_WF8B_BPALCD38_SHIFT
   Definitions
      At line 1490 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPALCD38_SHIFT unused
LCD_WF8B_BPALCD39_MASK 00000001

Symbol: LCD_WF8B_BPALCD39_MASK
   Definitions
      At line 1487 in file ..\Exercise
   Uses



ARM Macro Assembler    Page 100 Alphabetic symbol ordering
Absolute symbols

      None
Comment: LCD_WF8B_BPALCD39_MASK unused
LCD_WF8B_BPALCD39_SHIFT 00000000

Symbol: LCD_WF8B_BPALCD39_SHIFT
   Definitions
      At line 1488 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPALCD39_SHIFT unused
LCD_WF8B_BPALCD3_MASK 00000001

Symbol: LCD_WF8B_BPALCD3_MASK
   Definitions
      At line 1479 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPALCD3_MASK unused
LCD_WF8B_BPALCD3_SHIFT 00000000

Symbol: LCD_WF8B_BPALCD3_SHIFT
   Definitions
      At line 1480 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPALCD3_SHIFT unused
LCD_WF8B_BPALCD40_MASK 00000001

Symbol: LCD_WF8B_BPALCD40_MASK
   Definitions
      At line 1485 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPALCD40_MASK unused
LCD_WF8B_BPALCD40_SHIFT 00000000

Symbol: LCD_WF8B_BPALCD40_SHIFT
   Definitions
      At line 1486 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPALCD40_SHIFT unused
LCD_WF8B_BPALCD41_MASK 00000001

Symbol: LCD_WF8B_BPALCD41_MASK
   Definitions
      At line 1483 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPALCD41_MASK unused
LCD_WF8B_BPALCD41_SHIFT 00000000

Symbol: LCD_WF8B_BPALCD41_SHIFT
   Definitions
      At line 1484 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPALCD41_SHIFT unused
LCD_WF8B_BPALCD42_MASK 00000001



ARM Macro Assembler    Page 101 Alphabetic symbol ordering
Absolute symbols


Symbol: LCD_WF8B_BPALCD42_MASK
   Definitions
      At line 1481 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPALCD42_MASK unused
LCD_WF8B_BPALCD42_SHIFT 00000000

Symbol: LCD_WF8B_BPALCD42_SHIFT
   Definitions
      At line 1482 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPALCD42_SHIFT unused
LCD_WF8B_BPALCD43_MASK 00000001

Symbol: LCD_WF8B_BPALCD43_MASK
   Definitions
      At line 1477 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPALCD43_MASK unused
LCD_WF8B_BPALCD43_SHIFT 00000000

Symbol: LCD_WF8B_BPALCD43_SHIFT
   Definitions
      At line 1478 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPALCD43_SHIFT unused
LCD_WF8B_BPALCD44_MASK 00000001

Symbol: LCD_WF8B_BPALCD44_MASK
   Definitions
      At line 1475 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPALCD44_MASK unused
LCD_WF8B_BPALCD44_SHIFT 00000000

Symbol: LCD_WF8B_BPALCD44_SHIFT
   Definitions
      At line 1476 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPALCD44_SHIFT unused
LCD_WF8B_BPALCD45_MASK 00000001

Symbol: LCD_WF8B_BPALCD45_MASK
   Definitions
      At line 1473 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPALCD45_MASK unused
LCD_WF8B_BPALCD45_SHIFT 00000000

Symbol: LCD_WF8B_BPALCD45_SHIFT
   Definitions



ARM Macro Assembler    Page 102 Alphabetic symbol ordering
Absolute symbols

      At line 1474 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPALCD45_SHIFT unused
LCD_WF8B_BPALCD46_MASK 00000001

Symbol: LCD_WF8B_BPALCD46_MASK
   Definitions
      At line 1471 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPALCD46_MASK unused
LCD_WF8B_BPALCD46_SHIFT 00000000

Symbol: LCD_WF8B_BPALCD46_SHIFT
   Definitions
      At line 1472 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPALCD46_SHIFT unused
LCD_WF8B_BPALCD47_MASK 00000001

Symbol: LCD_WF8B_BPALCD47_MASK
   Definitions
      At line 1469 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPALCD47_MASK unused
LCD_WF8B_BPALCD47_SHIFT 00000000

Symbol: LCD_WF8B_BPALCD47_SHIFT
   Definitions
      At line 1470 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPALCD47_SHIFT unused
LCD_WF8B_BPALCD48_MASK 00000001

Symbol: LCD_WF8B_BPALCD48_MASK
   Definitions
      At line 1467 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPALCD48_MASK unused
LCD_WF8B_BPALCD48_SHIFT 00000000

Symbol: LCD_WF8B_BPALCD48_SHIFT
   Definitions
      At line 1468 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPALCD48_SHIFT unused
LCD_WF8B_BPALCD49_MASK 00000001

Symbol: LCD_WF8B_BPALCD49_MASK
   Definitions
      At line 1465 in file ..\Exercise
   Uses
      None



ARM Macro Assembler    Page 103 Alphabetic symbol ordering
Absolute symbols

Comment: LCD_WF8B_BPALCD49_MASK unused
LCD_WF8B_BPALCD49_SHIFT 00000000

Symbol: LCD_WF8B_BPALCD49_SHIFT
   Definitions
      At line 1466 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPALCD49_SHIFT unused
LCD_WF8B_BPALCD4_MASK 00000001

Symbol: LCD_WF8B_BPALCD4_MASK
   Definitions
      At line 1495 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPALCD4_MASK unused
LCD_WF8B_BPALCD4_SHIFT 00000000

Symbol: LCD_WF8B_BPALCD4_SHIFT
   Definitions
      At line 1496 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPALCD4_SHIFT unused
LCD_WF8B_BPALCD50_MASK 00000001

Symbol: LCD_WF8B_BPALCD50_MASK
   Definitions
      At line 1461 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPALCD50_MASK unused
LCD_WF8B_BPALCD50_SHIFT 00000000

Symbol: LCD_WF8B_BPALCD50_SHIFT
   Definitions
      At line 1462 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPALCD50_SHIFT unused
LCD_WF8B_BPALCD51_MASK 00000001

Symbol: LCD_WF8B_BPALCD51_MASK
   Definitions
      At line 1459 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPALCD51_MASK unused
LCD_WF8B_BPALCD51_SHIFT 00000000

Symbol: LCD_WF8B_BPALCD51_SHIFT
   Definitions
      At line 1460 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPALCD51_SHIFT unused
LCD_WF8B_BPALCD52_MASK 00000001




ARM Macro Assembler    Page 104 Alphabetic symbol ordering
Absolute symbols

Symbol: LCD_WF8B_BPALCD52_MASK
   Definitions
      At line 1457 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPALCD52_MASK unused
LCD_WF8B_BPALCD52_SHIFT 00000000

Symbol: LCD_WF8B_BPALCD52_SHIFT
   Definitions
      At line 1458 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPALCD52_SHIFT unused
LCD_WF8B_BPALCD53_MASK 00000001

Symbol: LCD_WF8B_BPALCD53_MASK
   Definitions
      At line 1455 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPALCD53_MASK unused
LCD_WF8B_BPALCD53_SHIFT 00000000

Symbol: LCD_WF8B_BPALCD53_SHIFT
   Definitions
      At line 1456 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPALCD53_SHIFT unused
LCD_WF8B_BPALCD54_MASK 00000001

Symbol: LCD_WF8B_BPALCD54_MASK
   Definitions
      At line 1453 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPALCD54_MASK unused
LCD_WF8B_BPALCD54_SHIFT 00000000

Symbol: LCD_WF8B_BPALCD54_SHIFT
   Definitions
      At line 1454 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPALCD54_SHIFT unused
LCD_WF8B_BPALCD55_MASK 00000001

Symbol: LCD_WF8B_BPALCD55_MASK
   Definitions
      At line 1451 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPALCD55_MASK unused
LCD_WF8B_BPALCD55_SHIFT 00000000

Symbol: LCD_WF8B_BPALCD55_SHIFT
   Definitions
      At line 1452 in file ..\Exercise



ARM Macro Assembler    Page 105 Alphabetic symbol ordering
Absolute symbols

   Uses
      None
Comment: LCD_WF8B_BPALCD55_SHIFT unused
LCD_WF8B_BPALCD56_MASK 00000001

Symbol: LCD_WF8B_BPALCD56_MASK
   Definitions
      At line 1449 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPALCD56_MASK unused
LCD_WF8B_BPALCD56_SHIFT 00000000

Symbol: LCD_WF8B_BPALCD56_SHIFT
   Definitions
      At line 1450 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPALCD56_SHIFT unused
LCD_WF8B_BPALCD57_MASK 00000001

Symbol: LCD_WF8B_BPALCD57_MASK
   Definitions
      At line 1445 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPALCD57_MASK unused
LCD_WF8B_BPALCD57_SHIFT 00000000

Symbol: LCD_WF8B_BPALCD57_SHIFT
   Definitions
      At line 1446 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPALCD57_SHIFT unused
LCD_WF8B_BPALCD58_MASK 00000001

Symbol: LCD_WF8B_BPALCD58_MASK
   Definitions
      At line 1443 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPALCD58_MASK unused
LCD_WF8B_BPALCD58_SHIFT 00000000

Symbol: LCD_WF8B_BPALCD58_SHIFT
   Definitions
      At line 1444 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPALCD58_SHIFT unused
LCD_WF8B_BPALCD59_MASK 00000001

Symbol: LCD_WF8B_BPALCD59_MASK
   Definitions
      At line 1441 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPALCD59_MASK unused



ARM Macro Assembler    Page 106 Alphabetic symbol ordering
Absolute symbols

LCD_WF8B_BPALCD59_SHIFT 00000000

Symbol: LCD_WF8B_BPALCD59_SHIFT
   Definitions
      At line 1442 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPALCD59_SHIFT unused
LCD_WF8B_BPALCD5_MASK 00000001

Symbol: LCD_WF8B_BPALCD5_MASK
   Definitions
      At line 1511 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPALCD5_MASK unused
LCD_WF8B_BPALCD5_SHIFT 00000000

Symbol: LCD_WF8B_BPALCD5_SHIFT
   Definitions
      At line 1512 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPALCD5_SHIFT unused
LCD_WF8B_BPALCD60_MASK 00000001

Symbol: LCD_WF8B_BPALCD60_MASK
   Definitions
      At line 1439 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPALCD60_MASK unused
LCD_WF8B_BPALCD60_SHIFT 00000000

Symbol: LCD_WF8B_BPALCD60_SHIFT
   Definitions
      At line 1440 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPALCD60_SHIFT unused
LCD_WF8B_BPALCD61_MASK 00000001

Symbol: LCD_WF8B_BPALCD61_MASK
   Definitions
      At line 1437 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPALCD61_MASK unused
LCD_WF8B_BPALCD61_SHIFT 00000000

Symbol: LCD_WF8B_BPALCD61_SHIFT
   Definitions
      At line 1438 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPALCD61_SHIFT unused
LCD_WF8B_BPALCD62_MASK 00000001

Symbol: LCD_WF8B_BPALCD62_MASK



ARM Macro Assembler    Page 107 Alphabetic symbol ordering
Absolute symbols

   Definitions
      At line 1435 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPALCD62_MASK unused
LCD_WF8B_BPALCD62_SHIFT 00000000

Symbol: LCD_WF8B_BPALCD62_SHIFT
   Definitions
      At line 1436 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPALCD62_SHIFT unused
LCD_WF8B_BPALCD63_MASK 00000001

Symbol: LCD_WF8B_BPALCD63_MASK
   Definitions
      At line 1433 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPALCD63_MASK unused
LCD_WF8B_BPALCD63_SHIFT 00000000

Symbol: LCD_WF8B_BPALCD63_SHIFT
   Definitions
      At line 1434 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPALCD63_SHIFT unused
LCD_WF8B_BPALCD6_MASK 00000001

Symbol: LCD_WF8B_BPALCD6_MASK
   Definitions
      At line 1527 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPALCD6_MASK unused
LCD_WF8B_BPALCD6_SHIFT 00000000

Symbol: LCD_WF8B_BPALCD6_SHIFT
   Definitions
      At line 1528 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPALCD6_SHIFT unused
LCD_WF8B_BPALCD7_MASK 00000001

Symbol: LCD_WF8B_BPALCD7_MASK
   Definitions
      At line 1543 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPALCD7_MASK unused
LCD_WF8B_BPALCD7_SHIFT 00000000

Symbol: LCD_WF8B_BPALCD7_SHIFT
   Definitions
      At line 1544 in file ..\Exercise
   Uses



ARM Macro Assembler    Page 108 Alphabetic symbol ordering
Absolute symbols

      None
Comment: LCD_WF8B_BPALCD7_SHIFT unused
LCD_WF8B_BPALCD8_MASK 00000001

Symbol: LCD_WF8B_BPALCD8_MASK
   Definitions
      At line 1557 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPALCD8_MASK unused
LCD_WF8B_BPALCD8_SHIFT 00000000

Symbol: LCD_WF8B_BPALCD8_SHIFT
   Definitions
      At line 1558 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPALCD8_SHIFT unused
LCD_WF8B_BPALCD9_MASK 00000001

Symbol: LCD_WF8B_BPALCD9_MASK
   Definitions
      At line 1555 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPALCD9_MASK unused
LCD_WF8B_BPALCD9_SHIFT 00000000

Symbol: LCD_WF8B_BPALCD9_SHIFT
   Definitions
      At line 1556 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPALCD9_SHIFT unused
LCD_WF8B_BPBLCD0_MASK 00000002

Symbol: LCD_WF8B_BPBLCD0_MASK
   Definitions
      At line 1597 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPBLCD0_MASK unused
LCD_WF8B_BPBLCD0_SHIFT 00000001

Symbol: LCD_WF8B_BPBLCD0_SHIFT
   Definitions
      At line 1598 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPBLCD0_SHIFT unused
LCD_WF8B_BPBLCD10_MASK 00000002

Symbol: LCD_WF8B_BPBLCD10_MASK
   Definitions
      At line 1575 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPBLCD10_MASK unused
LCD_WF8B_BPBLCD10_SHIFT 00000001



ARM Macro Assembler    Page 109 Alphabetic symbol ordering
Absolute symbols


Symbol: LCD_WF8B_BPBLCD10_SHIFT
   Definitions
      At line 1576 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPBLCD10_SHIFT unused
LCD_WF8B_BPBLCD11_MASK 00000002

Symbol: LCD_WF8B_BPBLCD11_MASK
   Definitions
      At line 1671 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPBLCD11_MASK unused
LCD_WF8B_BPBLCD11_SHIFT 00000001

Symbol: LCD_WF8B_BPBLCD11_SHIFT
   Definitions
      At line 1672 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPBLCD11_SHIFT unused
LCD_WF8B_BPBLCD12_MASK 00000002

Symbol: LCD_WF8B_BPBLCD12_MASK
   Definitions
      At line 1633 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPBLCD12_MASK unused
LCD_WF8B_BPBLCD12_SHIFT 00000001

Symbol: LCD_WF8B_BPBLCD12_SHIFT
   Definitions
      At line 1634 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPBLCD12_SHIFT unused
LCD_WF8B_BPBLCD13_MASK 00000002

Symbol: LCD_WF8B_BPBLCD13_MASK
   Definitions
      At line 1685 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPBLCD13_MASK unused
LCD_WF8B_BPBLCD13_SHIFT 00000001

Symbol: LCD_WF8B_BPBLCD13_SHIFT
   Definitions
      At line 1686 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPBLCD13_SHIFT unused
LCD_WF8B_BPBLCD14_MASK 00000002

Symbol: LCD_WF8B_BPBLCD14_MASK
   Definitions



ARM Macro Assembler    Page 110 Alphabetic symbol ordering
Absolute symbols

      At line 1657 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPBLCD14_MASK unused
LCD_WF8B_BPBLCD14_SHIFT 00000001

Symbol: LCD_WF8B_BPBLCD14_SHIFT
   Definitions
      At line 1658 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPBLCD14_SHIFT unused
LCD_WF8B_BPBLCD15_MASK 00000002

Symbol: LCD_WF8B_BPBLCD15_MASK
   Definitions
      At line 1577 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPBLCD15_MASK unused
LCD_WF8B_BPBLCD15_SHIFT 00000001

Symbol: LCD_WF8B_BPBLCD15_SHIFT
   Definitions
      At line 1578 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPBLCD15_SHIFT unused
LCD_WF8B_BPBLCD16_MASK 00000002

Symbol: LCD_WF8B_BPBLCD16_MASK
   Definitions
      At line 1683 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPBLCD16_MASK unused
LCD_WF8B_BPBLCD16_SHIFT 00000001

Symbol: LCD_WF8B_BPBLCD16_SHIFT
   Definitions
      At line 1684 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPBLCD16_SHIFT unused
LCD_WF8B_BPBLCD17_MASK 00000002

Symbol: LCD_WF8B_BPBLCD17_MASK
   Definitions
      At line 1667 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPBLCD17_MASK unused
LCD_WF8B_BPBLCD17_SHIFT 00000001

Symbol: LCD_WF8B_BPBLCD17_SHIFT
   Definitions
      At line 1668 in file ..\Exercise
   Uses
      None



ARM Macro Assembler    Page 111 Alphabetic symbol ordering
Absolute symbols

Comment: LCD_WF8B_BPBLCD17_SHIFT unused
LCD_WF8B_BPBLCD18_MASK 00000002

Symbol: LCD_WF8B_BPBLCD18_MASK
   Definitions
      At line 1651 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPBLCD18_MASK unused
LCD_WF8B_BPBLCD18_SHIFT 00000001

Symbol: LCD_WF8B_BPBLCD18_SHIFT
   Definitions
      At line 1652 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPBLCD18_SHIFT unused
LCD_WF8B_BPBLCD19_MASK 00000002

Symbol: LCD_WF8B_BPBLCD19_MASK
   Definitions
      At line 1635 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPBLCD19_MASK unused
LCD_WF8B_BPBLCD19_SHIFT 00000001

Symbol: LCD_WF8B_BPBLCD19_SHIFT
   Definitions
      At line 1636 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPBLCD19_SHIFT unused
LCD_WF8B_BPBLCD1_MASK 00000002

Symbol: LCD_WF8B_BPBLCD1_MASK
   Definitions
      At line 1559 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPBLCD1_MASK unused
LCD_WF8B_BPBLCD1_SHIFT 00000001

Symbol: LCD_WF8B_BPBLCD1_SHIFT
   Definitions
      At line 1560 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPBLCD1_SHIFT unused
LCD_WF8B_BPBLCD20_MASK 00000002

Symbol: LCD_WF8B_BPBLCD20_MASK
   Definitions
      At line 1619 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPBLCD20_MASK unused
LCD_WF8B_BPBLCD20_SHIFT 00000001




ARM Macro Assembler    Page 112 Alphabetic symbol ordering
Absolute symbols

Symbol: LCD_WF8B_BPBLCD20_SHIFT
   Definitions
      At line 1620 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPBLCD20_SHIFT unused
LCD_WF8B_BPBLCD21_MASK 00000002

Symbol: LCD_WF8B_BPBLCD21_MASK
   Definitions
      At line 1603 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPBLCD21_MASK unused
LCD_WF8B_BPBLCD21_SHIFT 00000001

Symbol: LCD_WF8B_BPBLCD21_SHIFT
   Definitions
      At line 1604 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPBLCD21_SHIFT unused
LCD_WF8B_BPBLCD22_MASK 00000002

Symbol: LCD_WF8B_BPBLCD22_MASK
   Definitions
      At line 1587 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPBLCD22_MASK unused
LCD_WF8B_BPBLCD22_SHIFT 00000001

Symbol: LCD_WF8B_BPBLCD22_SHIFT
   Definitions
      At line 1588 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPBLCD22_SHIFT unused
LCD_WF8B_BPBLCD23_MASK 00000002

Symbol: LCD_WF8B_BPBLCD23_MASK
   Definitions
      At line 1571 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPBLCD23_MASK unused
LCD_WF8B_BPBLCD23_SHIFT 00000001

Symbol: LCD_WF8B_BPBLCD23_SHIFT
   Definitions
      At line 1572 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPBLCD23_SHIFT unused
LCD_WF8B_BPBLCD24_MASK 00000002

Symbol: LCD_WF8B_BPBLCD24_MASK
   Definitions
      At line 1567 in file ..\Exercise



ARM Macro Assembler    Page 113 Alphabetic symbol ordering
Absolute symbols

   Uses
      None
Comment: LCD_WF8B_BPBLCD24_MASK unused
LCD_WF8B_BPBLCD24_SHIFT 00000001

Symbol: LCD_WF8B_BPBLCD24_SHIFT
   Definitions
      At line 1568 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPBLCD24_SHIFT unused
LCD_WF8B_BPBLCD25_MASK 00000002

Symbol: LCD_WF8B_BPBLCD25_MASK
   Definitions
      At line 1609 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPBLCD25_MASK unused
LCD_WF8B_BPBLCD25_SHIFT 00000001

Symbol: LCD_WF8B_BPBLCD25_SHIFT
   Definitions
      At line 1610 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPBLCD25_SHIFT unused
LCD_WF8B_BPBLCD26_MASK 00000002

Symbol: LCD_WF8B_BPBLCD26_MASK
   Definitions
      At line 1631 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPBLCD26_MASK unused
LCD_WF8B_BPBLCD26_SHIFT 00000001

Symbol: LCD_WF8B_BPBLCD26_SHIFT
   Definitions
      At line 1632 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPBLCD26_SHIFT unused
LCD_WF8B_BPBLCD27_MASK 00000002

Symbol: LCD_WF8B_BPBLCD27_MASK
   Definitions
      At line 1655 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPBLCD27_MASK unused
LCD_WF8B_BPBLCD27_SHIFT 00000001

Symbol: LCD_WF8B_BPBLCD27_SHIFT
   Definitions
      At line 1656 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPBLCD27_SHIFT unused



ARM Macro Assembler    Page 114 Alphabetic symbol ordering
Absolute symbols

LCD_WF8B_BPBLCD28_MASK 00000002

Symbol: LCD_WF8B_BPBLCD28_MASK
   Definitions
      At line 1569 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPBLCD28_MASK unused
LCD_WF8B_BPBLCD28_SHIFT 00000001

Symbol: LCD_WF8B_BPBLCD28_SHIFT
   Definitions
      At line 1570 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPBLCD28_SHIFT unused
LCD_WF8B_BPBLCD29_MASK 00000002

Symbol: LCD_WF8B_BPBLCD29_MASK
   Definitions
      At line 1607 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPBLCD29_MASK unused
LCD_WF8B_BPBLCD29_SHIFT 00000001

Symbol: LCD_WF8B_BPBLCD29_SHIFT
   Definitions
      At line 1608 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPBLCD29_SHIFT unused
LCD_WF8B_BPBLCD2_MASK 00000002

Symbol: LCD_WF8B_BPBLCD2_MASK
   Definitions
      At line 1593 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPBLCD2_MASK unused
LCD_WF8B_BPBLCD2_SHIFT 00000001

Symbol: LCD_WF8B_BPBLCD2_SHIFT
   Definitions
      At line 1594 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPBLCD2_SHIFT unused
LCD_WF8B_BPBLCD30_MASK 00000002

Symbol: LCD_WF8B_BPBLCD30_MASK
   Definitions
      At line 1563 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPBLCD30_MASK unused
LCD_WF8B_BPBLCD30_SHIFT 00000001

Symbol: LCD_WF8B_BPBLCD30_SHIFT



ARM Macro Assembler    Page 115 Alphabetic symbol ordering
Absolute symbols

   Definitions
      At line 1564 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPBLCD30_SHIFT unused
LCD_WF8B_BPBLCD31_MASK 00000002

Symbol: LCD_WF8B_BPBLCD31_MASK
   Definitions
      At line 1647 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPBLCD31_MASK unused
LCD_WF8B_BPBLCD31_SHIFT 00000001

Symbol: LCD_WF8B_BPBLCD31_SHIFT
   Definitions
      At line 1648 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPBLCD31_SHIFT unused
LCD_WF8B_BPBLCD32_MASK 00000002

Symbol: LCD_WF8B_BPBLCD32_MASK
   Definitions
      At line 1561 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPBLCD32_MASK unused
LCD_WF8B_BPBLCD32_SHIFT 00000001

Symbol: LCD_WF8B_BPBLCD32_SHIFT
   Definitions
      At line 1562 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPBLCD32_SHIFT unused
LCD_WF8B_BPBLCD33_MASK 00000002

Symbol: LCD_WF8B_BPBLCD33_MASK
   Definitions
      At line 1591 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPBLCD33_MASK unused
LCD_WF8B_BPBLCD33_SHIFT 00000001

Symbol: LCD_WF8B_BPBLCD33_SHIFT
   Definitions
      At line 1592 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPBLCD33_SHIFT unused
LCD_WF8B_BPBLCD34_MASK 00000002

Symbol: LCD_WF8B_BPBLCD34_MASK
   Definitions
      At line 1637 in file ..\Exercise
   Uses



ARM Macro Assembler    Page 116 Alphabetic symbol ordering
Absolute symbols

      None
Comment: LCD_WF8B_BPBLCD34_MASK unused
LCD_WF8B_BPBLCD34_SHIFT 00000001

Symbol: LCD_WF8B_BPBLCD34_SHIFT
   Definitions
      At line 1638 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPBLCD34_SHIFT unused
LCD_WF8B_BPBLCD35_MASK 00000002

Symbol: LCD_WF8B_BPBLCD35_MASK
   Definitions
      At line 1665 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPBLCD35_MASK unused
LCD_WF8B_BPBLCD35_SHIFT 00000001

Symbol: LCD_WF8B_BPBLCD35_SHIFT
   Definitions
      At line 1666 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPBLCD35_SHIFT unused
LCD_WF8B_BPBLCD36_MASK 00000002

Symbol: LCD_WF8B_BPBLCD36_MASK
   Definitions
      At line 1579 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPBLCD36_MASK unused
LCD_WF8B_BPBLCD36_SHIFT 00000001

Symbol: LCD_WF8B_BPBLCD36_SHIFT
   Definitions
      At line 1580 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPBLCD36_SHIFT unused
LCD_WF8B_BPBLCD37_MASK 00000002

Symbol: LCD_WF8B_BPBLCD37_MASK
   Definitions
      At line 1645 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPBLCD37_MASK unused
LCD_WF8B_BPBLCD37_SHIFT 00000001

Symbol: LCD_WF8B_BPBLCD37_SHIFT
   Definitions
      At line 1646 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPBLCD37_SHIFT unused
LCD_WF8B_BPBLCD38_MASK 00000002



ARM Macro Assembler    Page 117 Alphabetic symbol ordering
Absolute symbols


Symbol: LCD_WF8B_BPBLCD38_MASK
   Definitions
      At line 1615 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPBLCD38_MASK unused
LCD_WF8B_BPBLCD38_SHIFT 00000001

Symbol: LCD_WF8B_BPBLCD38_SHIFT
   Definitions
      At line 1616 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPBLCD38_SHIFT unused
LCD_WF8B_BPBLCD39_MASK 00000002

Symbol: LCD_WF8B_BPBLCD39_MASK
   Definitions
      At line 1639 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPBLCD39_MASK unused
LCD_WF8B_BPBLCD39_SHIFT 00000001

Symbol: LCD_WF8B_BPBLCD39_SHIFT
   Definitions
      At line 1640 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPBLCD39_SHIFT unused
LCD_WF8B_BPBLCD3_MASK 00000002

Symbol: LCD_WF8B_BPBLCD3_MASK
   Definitions
      At line 1681 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPBLCD3_MASK unused
LCD_WF8B_BPBLCD3_SHIFT 00000001

Symbol: LCD_WF8B_BPBLCD3_SHIFT
   Definitions
      At line 1682 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPBLCD3_SHIFT unused
LCD_WF8B_BPBLCD40_MASK 00000002

Symbol: LCD_WF8B_BPBLCD40_MASK
   Definitions
      At line 1627 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPBLCD40_MASK unused
LCD_WF8B_BPBLCD40_SHIFT 00000001

Symbol: LCD_WF8B_BPBLCD40_SHIFT
   Definitions



ARM Macro Assembler    Page 118 Alphabetic symbol ordering
Absolute symbols

      At line 1628 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPBLCD40_SHIFT unused
LCD_WF8B_BPBLCD41_MASK 00000002

Symbol: LCD_WF8B_BPBLCD41_MASK
   Definitions
      At line 1669 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPBLCD41_MASK unused
LCD_WF8B_BPBLCD41_SHIFT 00000001

Symbol: LCD_WF8B_BPBLCD41_SHIFT
   Definitions
      At line 1670 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPBLCD41_SHIFT unused
LCD_WF8B_BPBLCD42_MASK 00000002

Symbol: LCD_WF8B_BPBLCD42_MASK
   Definitions
      At line 1677 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPBLCD42_MASK unused
LCD_WF8B_BPBLCD42_SHIFT 00000001

Symbol: LCD_WF8B_BPBLCD42_SHIFT
   Definitions
      At line 1678 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPBLCD42_SHIFT unused
LCD_WF8B_BPBLCD43_MASK 00000002

Symbol: LCD_WF8B_BPBLCD43_MASK
   Definitions
      At line 1617 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPBLCD43_MASK unused
LCD_WF8B_BPBLCD43_SHIFT 00000001

Symbol: LCD_WF8B_BPBLCD43_SHIFT
   Definitions
      At line 1618 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPBLCD43_SHIFT unused
LCD_WF8B_BPBLCD44_MASK 00000002

Symbol: LCD_WF8B_BPBLCD44_MASK
   Definitions
      At line 1581 in file ..\Exercise
   Uses
      None



ARM Macro Assembler    Page 119 Alphabetic symbol ordering
Absolute symbols

Comment: LCD_WF8B_BPBLCD44_MASK unused
LCD_WF8B_BPBLCD44_SHIFT 00000001

Symbol: LCD_WF8B_BPBLCD44_SHIFT
   Definitions
      At line 1582 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPBLCD44_SHIFT unused
LCD_WF8B_BPBLCD45_MASK 00000002

Symbol: LCD_WF8B_BPBLCD45_MASK
   Definitions
      At line 1653 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPBLCD45_MASK unused
LCD_WF8B_BPBLCD45_SHIFT 00000001

Symbol: LCD_WF8B_BPBLCD45_SHIFT
   Definitions
      At line 1654 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPBLCD45_SHIFT unused
LCD_WF8B_BPBLCD46_MASK 00000002

Symbol: LCD_WF8B_BPBLCD46_MASK
   Definitions
      At line 1673 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPBLCD46_MASK unused
LCD_WF8B_BPBLCD46_SHIFT 00000001

Symbol: LCD_WF8B_BPBLCD46_SHIFT
   Definitions
      At line 1674 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPBLCD46_SHIFT unused
LCD_WF8B_BPBLCD47_MASK 00000002

Symbol: LCD_WF8B_BPBLCD47_MASK
   Definitions
      At line 1589 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPBLCD47_MASK unused
LCD_WF8B_BPBLCD47_SHIFT 00000001

Symbol: LCD_WF8B_BPBLCD47_SHIFT
   Definitions
      At line 1590 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPBLCD47_SHIFT unused
LCD_WF8B_BPBLCD48_MASK 00000002




ARM Macro Assembler    Page 120 Alphabetic symbol ordering
Absolute symbols

Symbol: LCD_WF8B_BPBLCD48_MASK
   Definitions
      At line 1573 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPBLCD48_MASK unused
LCD_WF8B_BPBLCD48_SHIFT 00000001

Symbol: LCD_WF8B_BPBLCD48_SHIFT
   Definitions
      At line 1574 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPBLCD48_SHIFT unused
LCD_WF8B_BPBLCD49_MASK 00000002

Symbol: LCD_WF8B_BPBLCD49_MASK
   Definitions
      At line 1595 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPBLCD49_MASK unused
LCD_WF8B_BPBLCD49_SHIFT 00000001

Symbol: LCD_WF8B_BPBLCD49_SHIFT
   Definitions
      At line 1596 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPBLCD49_SHIFT unused
LCD_WF8B_BPBLCD4_MASK 00000002

Symbol: LCD_WF8B_BPBLCD4_MASK
   Definitions
      At line 1663 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPBLCD4_MASK unused
LCD_WF8B_BPBLCD4_SHIFT 00000001

Symbol: LCD_WF8B_BPBLCD4_SHIFT
   Definitions
      At line 1664 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPBLCD4_SHIFT unused
LCD_WF8B_BPBLCD50_MASK 00000002

Symbol: LCD_WF8B_BPBLCD50_MASK
   Definitions
      At line 1625 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPBLCD50_MASK unused
LCD_WF8B_BPBLCD50_SHIFT 00000001

Symbol: LCD_WF8B_BPBLCD50_SHIFT
   Definitions
      At line 1626 in file ..\Exercise



ARM Macro Assembler    Page 121 Alphabetic symbol ordering
Absolute symbols

   Uses
      None
Comment: LCD_WF8B_BPBLCD50_SHIFT unused
LCD_WF8B_BPBLCD51_MASK 00000002

Symbol: LCD_WF8B_BPBLCD51_MASK
   Definitions
      At line 1659 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPBLCD51_MASK unused
LCD_WF8B_BPBLCD51_SHIFT 00000001

Symbol: LCD_WF8B_BPBLCD51_SHIFT
   Definitions
      At line 1660 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPBLCD51_SHIFT unused
LCD_WF8B_BPBLCD52_MASK 00000002

Symbol: LCD_WF8B_BPBLCD52_MASK
   Definitions
      At line 1661 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPBLCD52_MASK unused
LCD_WF8B_BPBLCD52_SHIFT 00000001

Symbol: LCD_WF8B_BPBLCD52_SHIFT
   Definitions
      At line 1662 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPBLCD52_SHIFT unused
LCD_WF8B_BPBLCD53_MASK 00000002

Symbol: LCD_WF8B_BPBLCD53_MASK
   Definitions
      At line 1585 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPBLCD53_MASK unused
LCD_WF8B_BPBLCD53_SHIFT 00000001

Symbol: LCD_WF8B_BPBLCD53_SHIFT
   Definitions
      At line 1586 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPBLCD53_SHIFT unused
LCD_WF8B_BPBLCD54_MASK 00000002

Symbol: LCD_WF8B_BPBLCD54_MASK
   Definitions
      At line 1613 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPBLCD54_MASK unused



ARM Macro Assembler    Page 122 Alphabetic symbol ordering
Absolute symbols

LCD_WF8B_BPBLCD54_SHIFT 00000001

Symbol: LCD_WF8B_BPBLCD54_SHIFT
   Definitions
      At line 1614 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPBLCD54_SHIFT unused
LCD_WF8B_BPBLCD55_MASK 00000002

Symbol: LCD_WF8B_BPBLCD55_MASK
   Definitions
      At line 1599 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPBLCD55_MASK unused
LCD_WF8B_BPBLCD55_SHIFT 00000001

Symbol: LCD_WF8B_BPBLCD55_SHIFT
   Definitions
      At line 1600 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPBLCD55_SHIFT unused
LCD_WF8B_BPBLCD56_MASK 00000002

Symbol: LCD_WF8B_BPBLCD56_MASK
   Definitions
      At line 1601 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPBLCD56_MASK unused
LCD_WF8B_BPBLCD56_SHIFT 00000001

Symbol: LCD_WF8B_BPBLCD56_SHIFT
   Definitions
      At line 1602 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPBLCD56_SHIFT unused
LCD_WF8B_BPBLCD57_MASK 00000002

Symbol: LCD_WF8B_BPBLCD57_MASK
   Definitions
      At line 1675 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPBLCD57_MASK unused
LCD_WF8B_BPBLCD57_SHIFT 00000001

Symbol: LCD_WF8B_BPBLCD57_SHIFT
   Definitions
      At line 1676 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPBLCD57_SHIFT unused
LCD_WF8B_BPBLCD58_MASK 00000002

Symbol: LCD_WF8B_BPBLCD58_MASK



ARM Macro Assembler    Page 123 Alphabetic symbol ordering
Absolute symbols

   Definitions
      At line 1649 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPBLCD58_MASK unused
LCD_WF8B_BPBLCD58_SHIFT 00000001

Symbol: LCD_WF8B_BPBLCD58_SHIFT
   Definitions
      At line 1650 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPBLCD58_SHIFT unused
LCD_WF8B_BPBLCD59_MASK 00000002

Symbol: LCD_WF8B_BPBLCD59_MASK
   Definitions
      At line 1641 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPBLCD59_MASK unused
LCD_WF8B_BPBLCD59_SHIFT 00000001

Symbol: LCD_WF8B_BPBLCD59_SHIFT
   Definitions
      At line 1642 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPBLCD59_SHIFT unused
LCD_WF8B_BPBLCD5_MASK 00000002

Symbol: LCD_WF8B_BPBLCD5_MASK
   Definitions
      At line 1679 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPBLCD5_MASK unused
LCD_WF8B_BPBLCD5_SHIFT 00000001

Symbol: LCD_WF8B_BPBLCD5_SHIFT
   Definitions
      At line 1680 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPBLCD5_SHIFT unused
LCD_WF8B_BPBLCD60_MASK 00000002

Symbol: LCD_WF8B_BPBLCD60_MASK
   Definitions
      At line 1565 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPBLCD60_MASK unused
LCD_WF8B_BPBLCD60_SHIFT 00000001

Symbol: LCD_WF8B_BPBLCD60_SHIFT
   Definitions
      At line 1566 in file ..\Exercise
   Uses



ARM Macro Assembler    Page 124 Alphabetic symbol ordering
Absolute symbols

      None
Comment: LCD_WF8B_BPBLCD60_SHIFT unused
LCD_WF8B_BPBLCD61_MASK 00000002

Symbol: LCD_WF8B_BPBLCD61_MASK
   Definitions
      At line 1643 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPBLCD61_MASK unused
LCD_WF8B_BPBLCD61_SHIFT 00000001

Symbol: LCD_WF8B_BPBLCD61_SHIFT
   Definitions
      At line 1644 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPBLCD61_SHIFT unused
LCD_WF8B_BPBLCD62_MASK 00000002

Symbol: LCD_WF8B_BPBLCD62_MASK
   Definitions
      At line 1583 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPBLCD62_MASK unused
LCD_WF8B_BPBLCD62_SHIFT 00000001

Symbol: LCD_WF8B_BPBLCD62_SHIFT
   Definitions
      At line 1584 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPBLCD62_SHIFT unused
LCD_WF8B_BPBLCD63_MASK 00000002

Symbol: LCD_WF8B_BPBLCD63_MASK
   Definitions
      At line 1629 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPBLCD63_MASK unused
LCD_WF8B_BPBLCD63_SHIFT 00000001

Symbol: LCD_WF8B_BPBLCD63_SHIFT
   Definitions
      At line 1630 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPBLCD63_SHIFT unused
LCD_WF8B_BPBLCD6_MASK 00000002

Symbol: LCD_WF8B_BPBLCD6_MASK
   Definitions
      At line 1605 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPBLCD6_MASK unused
LCD_WF8B_BPBLCD6_SHIFT 00000001



ARM Macro Assembler    Page 125 Alphabetic symbol ordering
Absolute symbols


Symbol: LCD_WF8B_BPBLCD6_SHIFT
   Definitions
      At line 1606 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPBLCD6_SHIFT unused
LCD_WF8B_BPBLCD7_MASK 00000002

Symbol: LCD_WF8B_BPBLCD7_MASK
   Definitions
      At line 1623 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPBLCD7_MASK unused
LCD_WF8B_BPBLCD7_SHIFT 00000001

Symbol: LCD_WF8B_BPBLCD7_SHIFT
   Definitions
      At line 1624 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPBLCD7_SHIFT unused
LCD_WF8B_BPBLCD8_MASK 00000002

Symbol: LCD_WF8B_BPBLCD8_MASK
   Definitions
      At line 1611 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPBLCD8_MASK unused
LCD_WF8B_BPBLCD8_SHIFT 00000001

Symbol: LCD_WF8B_BPBLCD8_SHIFT
   Definitions
      At line 1612 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPBLCD8_SHIFT unused
LCD_WF8B_BPBLCD9_MASK 00000002

Symbol: LCD_WF8B_BPBLCD9_MASK
   Definitions
      At line 1621 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPBLCD9_MASK unused
LCD_WF8B_BPBLCD9_SHIFT 00000001

Symbol: LCD_WF8B_BPBLCD9_SHIFT
   Definitions
      At line 1622 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPBLCD9_SHIFT unused
LCD_WF8B_BPCLCD0_MASK 00000004

Symbol: LCD_WF8B_BPCLCD0_MASK
   Definitions



ARM Macro Assembler    Page 126 Alphabetic symbol ordering
Absolute symbols

      At line 1759 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPCLCD0_MASK unused
LCD_WF8B_BPCLCD0_SHIFT 00000002

Symbol: LCD_WF8B_BPCLCD0_SHIFT
   Definitions
      At line 1760 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPCLCD0_SHIFT unused
LCD_WF8B_BPCLCD10_MASK 00000004

Symbol: LCD_WF8B_BPCLCD10_MASK
   Definitions
      At line 1687 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPCLCD10_MASK unused
LCD_WF8B_BPCLCD10_SHIFT 00000002

Symbol: LCD_WF8B_BPCLCD10_SHIFT
   Definitions
      At line 1688 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPCLCD10_SHIFT unused
LCD_WF8B_BPCLCD11_MASK 00000004

Symbol: LCD_WF8B_BPCLCD11_MASK
   Definitions
      At line 1797 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPCLCD11_MASK unused
LCD_WF8B_BPCLCD11_SHIFT 00000002

Symbol: LCD_WF8B_BPCLCD11_SHIFT
   Definitions
      At line 1798 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPCLCD11_SHIFT unused
LCD_WF8B_BPCLCD12_MASK 00000004

Symbol: LCD_WF8B_BPCLCD12_MASK
   Definitions
      At line 1795 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPCLCD12_MASK unused
LCD_WF8B_BPCLCD12_SHIFT 00000002

Symbol: LCD_WF8B_BPCLCD12_SHIFT
   Definitions
      At line 1796 in file ..\Exercise
   Uses
      None



ARM Macro Assembler    Page 127 Alphabetic symbol ordering
Absolute symbols

Comment: LCD_WF8B_BPCLCD12_SHIFT unused
LCD_WF8B_BPCLCD13_MASK 00000004

Symbol: LCD_WF8B_BPCLCD13_MASK
   Definitions
      At line 1779 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPCLCD13_MASK unused
LCD_WF8B_BPCLCD13_SHIFT 00000002

Symbol: LCD_WF8B_BPCLCD13_SHIFT
   Definitions
      At line 1780 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPCLCD13_SHIFT unused
LCD_WF8B_BPCLCD14_MASK 00000004

Symbol: LCD_WF8B_BPCLCD14_MASK
   Definitions
      At line 1749 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPCLCD14_MASK unused
LCD_WF8B_BPCLCD14_SHIFT 00000002

Symbol: LCD_WF8B_BPCLCD14_SHIFT
   Definitions
      At line 1750 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPCLCD14_SHIFT unused
LCD_WF8B_BPCLCD15_MASK 00000004

Symbol: LCD_WF8B_BPCLCD15_MASK
   Definitions
      At line 1745 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPCLCD15_MASK unused
LCD_WF8B_BPCLCD15_SHIFT 00000002

Symbol: LCD_WF8B_BPCLCD15_SHIFT
   Definitions
      At line 1746 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPCLCD15_SHIFT unused
LCD_WF8B_BPCLCD16_MASK 00000004

Symbol: LCD_WF8B_BPCLCD16_MASK
   Definitions
      At line 1747 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPCLCD16_MASK unused
LCD_WF8B_BPCLCD16_SHIFT 00000002




ARM Macro Assembler    Page 128 Alphabetic symbol ordering
Absolute symbols

Symbol: LCD_WF8B_BPCLCD16_SHIFT
   Definitions
      At line 1748 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPCLCD16_SHIFT unused
LCD_WF8B_BPCLCD17_MASK 00000004

Symbol: LCD_WF8B_BPCLCD17_MASK
   Definitions
      At line 1737 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPCLCD17_MASK unused
LCD_WF8B_BPCLCD17_SHIFT 00000002

Symbol: LCD_WF8B_BPCLCD17_SHIFT
   Definitions
      At line 1738 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPCLCD17_SHIFT unused
LCD_WF8B_BPCLCD18_MASK 00000004

Symbol: LCD_WF8B_BPCLCD18_MASK
   Definitions
      At line 1729 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPCLCD18_MASK unused
LCD_WF8B_BPCLCD18_SHIFT 00000002

Symbol: LCD_WF8B_BPCLCD18_SHIFT
   Definitions
      At line 1730 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPCLCD18_SHIFT unused
LCD_WF8B_BPCLCD19_MASK 00000004

Symbol: LCD_WF8B_BPCLCD19_MASK
   Definitions
      At line 1719 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPCLCD19_MASK unused
LCD_WF8B_BPCLCD19_SHIFT 00000002

Symbol: LCD_WF8B_BPCLCD19_SHIFT
   Definitions
      At line 1720 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPCLCD19_SHIFT unused
LCD_WF8B_BPCLCD1_MASK 00000004

Symbol: LCD_WF8B_BPCLCD1_MASK
   Definitions
      At line 1713 in file ..\Exercise



ARM Macro Assembler    Page 129 Alphabetic symbol ordering
Absolute symbols

   Uses
      None
Comment: LCD_WF8B_BPCLCD1_MASK unused
LCD_WF8B_BPCLCD1_SHIFT 00000002

Symbol: LCD_WF8B_BPCLCD1_SHIFT
   Definitions
      At line 1714 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPCLCD1_SHIFT unused
LCD_WF8B_BPCLCD20_MASK 00000004

Symbol: LCD_WF8B_BPCLCD20_MASK
   Definitions
      At line 1715 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPCLCD20_MASK unused
LCD_WF8B_BPCLCD20_SHIFT 00000002

Symbol: LCD_WF8B_BPCLCD20_SHIFT
   Definitions
      At line 1716 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPCLCD20_SHIFT unused
LCD_WF8B_BPCLCD21_MASK 00000004

Symbol: LCD_WF8B_BPCLCD21_MASK
   Definitions
      At line 1707 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPCLCD21_MASK unused
LCD_WF8B_BPCLCD21_SHIFT 00000002

Symbol: LCD_WF8B_BPCLCD21_SHIFT
   Definitions
      At line 1708 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPCLCD21_SHIFT unused
LCD_WF8B_BPCLCD22_MASK 00000004

Symbol: LCD_WF8B_BPCLCD22_MASK
   Definitions
      At line 1703 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPCLCD22_MASK unused
LCD_WF8B_BPCLCD22_SHIFT 00000002

Symbol: LCD_WF8B_BPCLCD22_SHIFT
   Definitions
      At line 1704 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPCLCD22_SHIFT unused



ARM Macro Assembler    Page 130 Alphabetic symbol ordering
Absolute symbols

LCD_WF8B_BPCLCD23_MASK 00000004

Symbol: LCD_WF8B_BPCLCD23_MASK
   Definitions
      At line 1693 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPCLCD23_MASK unused
LCD_WF8B_BPCLCD23_SHIFT 00000002

Symbol: LCD_WF8B_BPCLCD23_SHIFT
   Definitions
      At line 1694 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPCLCD23_SHIFT unused
LCD_WF8B_BPCLCD24_MASK 00000004

Symbol: LCD_WF8B_BPCLCD24_MASK
   Definitions
      At line 1697 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPCLCD24_MASK unused
LCD_WF8B_BPCLCD24_SHIFT 00000002

Symbol: LCD_WF8B_BPCLCD24_SHIFT
   Definitions
      At line 1698 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPCLCD24_SHIFT unused
LCD_WF8B_BPCLCD25_MASK 00000004

Symbol: LCD_WF8B_BPCLCD25_MASK
   Definitions
      At line 1711 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPCLCD25_MASK unused
LCD_WF8B_BPCLCD25_SHIFT 00000002

Symbol: LCD_WF8B_BPCLCD25_SHIFT
   Definitions
      At line 1712 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPCLCD25_SHIFT unused
LCD_WF8B_BPCLCD26_MASK 00000004

Symbol: LCD_WF8B_BPCLCD26_MASK
   Definitions
      At line 1721 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPCLCD26_MASK unused
LCD_WF8B_BPCLCD26_SHIFT 00000002

Symbol: LCD_WF8B_BPCLCD26_SHIFT



ARM Macro Assembler    Page 131 Alphabetic symbol ordering
Absolute symbols

   Definitions
      At line 1722 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPCLCD26_SHIFT unused
LCD_WF8B_BPCLCD27_MASK 00000004

Symbol: LCD_WF8B_BPCLCD27_MASK
   Definitions
      At line 1735 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPCLCD27_MASK unused
LCD_WF8B_BPCLCD27_SHIFT 00000002

Symbol: LCD_WF8B_BPCLCD27_SHIFT
   Definitions
      At line 1736 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPCLCD27_SHIFT unused
LCD_WF8B_BPCLCD28_MASK 00000004

Symbol: LCD_WF8B_BPCLCD28_MASK
   Definitions
      At line 1753 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPCLCD28_MASK unused
LCD_WF8B_BPCLCD28_SHIFT 00000002

Symbol: LCD_WF8B_BPCLCD28_SHIFT
   Definitions
      At line 1754 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPCLCD28_SHIFT unused
LCD_WF8B_BPCLCD29_MASK 00000004

Symbol: LCD_WF8B_BPCLCD29_MASK
   Definitions
      At line 1769 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPCLCD29_MASK unused
LCD_WF8B_BPCLCD29_SHIFT 00000002

Symbol: LCD_WF8B_BPCLCD29_SHIFT
   Definitions
      At line 1770 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPCLCD29_SHIFT unused
LCD_WF8B_BPCLCD2_MASK 00000004

Symbol: LCD_WF8B_BPCLCD2_MASK
   Definitions
      At line 1691 in file ..\Exercise
   Uses



ARM Macro Assembler    Page 132 Alphabetic symbol ordering
Absolute symbols

      None
Comment: LCD_WF8B_BPCLCD2_MASK unused
LCD_WF8B_BPCLCD2_SHIFT 00000002

Symbol: LCD_WF8B_BPCLCD2_SHIFT
   Definitions
      At line 1692 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPCLCD2_SHIFT unused
LCD_WF8B_BPCLCD30_MASK 00000004

Symbol: LCD_WF8B_BPCLCD30_MASK
   Definitions
      At line 1783 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPCLCD30_MASK unused
LCD_WF8B_BPCLCD30_SHIFT 00000002

Symbol: LCD_WF8B_BPCLCD30_SHIFT
   Definitions
      At line 1784 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPCLCD30_SHIFT unused
LCD_WF8B_BPCLCD31_MASK 00000004

Symbol: LCD_WF8B_BPCLCD31_MASK
   Definitions
      At line 1803 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPCLCD31_MASK unused
LCD_WF8B_BPCLCD31_SHIFT 00000002

Symbol: LCD_WF8B_BPCLCD31_SHIFT
   Definitions
      At line 1804 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPCLCD31_SHIFT unused
LCD_WF8B_BPCLCD32_MASK 00000004

Symbol: LCD_WF8B_BPCLCD32_MASK
   Definitions
      At line 1751 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPCLCD32_MASK unused
LCD_WF8B_BPCLCD32_SHIFT 00000002

Symbol: LCD_WF8B_BPCLCD32_SHIFT
   Definitions
      At line 1752 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPCLCD32_SHIFT unused
LCD_WF8B_BPCLCD33_MASK 00000004



ARM Macro Assembler    Page 133 Alphabetic symbol ordering
Absolute symbols


Symbol: LCD_WF8B_BPCLCD33_MASK
   Definitions
      At line 1757 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPCLCD33_MASK unused
LCD_WF8B_BPCLCD33_SHIFT 00000002

Symbol: LCD_WF8B_BPCLCD33_SHIFT
   Definitions
      At line 1758 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPCLCD33_SHIFT unused
LCD_WF8B_BPCLCD34_MASK 00000004

Symbol: LCD_WF8B_BPCLCD34_MASK
   Definitions
      At line 1767 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPCLCD34_MASK unused
LCD_WF8B_BPCLCD34_SHIFT 00000002

Symbol: LCD_WF8B_BPCLCD34_SHIFT
   Definitions
      At line 1768 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPCLCD34_SHIFT unused
LCD_WF8B_BPCLCD35_MASK 00000004

Symbol: LCD_WF8B_BPCLCD35_MASK
   Definitions
      At line 1777 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPCLCD35_MASK unused
LCD_WF8B_BPCLCD35_SHIFT 00000002

Symbol: LCD_WF8B_BPCLCD35_SHIFT
   Definitions
      At line 1778 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPCLCD35_SHIFT unused
LCD_WF8B_BPCLCD36_MASK 00000004

Symbol: LCD_WF8B_BPCLCD36_MASK
   Definitions
      At line 1781 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPCLCD36_MASK unused
LCD_WF8B_BPCLCD36_SHIFT 00000002

Symbol: LCD_WF8B_BPCLCD36_SHIFT
   Definitions



ARM Macro Assembler    Page 134 Alphabetic symbol ordering
Absolute symbols

      At line 1782 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPCLCD36_SHIFT unused
LCD_WF8B_BPCLCD37_MASK 00000004

Symbol: LCD_WF8B_BPCLCD37_MASK
   Definitions
      At line 1791 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPCLCD37_MASK unused
LCD_WF8B_BPCLCD37_SHIFT 00000002

Symbol: LCD_WF8B_BPCLCD37_SHIFT
   Definitions
      At line 1792 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPCLCD37_SHIFT unused
LCD_WF8B_BPCLCD38_MASK 00000004

Symbol: LCD_WF8B_BPCLCD38_MASK
   Definitions
      At line 1799 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPCLCD38_MASK unused
LCD_WF8B_BPCLCD38_SHIFT 00000002

Symbol: LCD_WF8B_BPCLCD38_SHIFT
   Definitions
      At line 1800 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPCLCD38_SHIFT unused
LCD_WF8B_BPCLCD39_MASK 00000004

Symbol: LCD_WF8B_BPCLCD39_MASK
   Definitions
      At line 1811 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPCLCD39_MASK unused
LCD_WF8B_BPCLCD39_SHIFT 00000002

Symbol: LCD_WF8B_BPCLCD39_SHIFT
   Definitions
      At line 1812 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPCLCD39_SHIFT unused
LCD_WF8B_BPCLCD3_MASK 00000004

Symbol: LCD_WF8B_BPCLCD3_MASK
   Definitions
      At line 1793 in file ..\Exercise
   Uses
      None



ARM Macro Assembler    Page 135 Alphabetic symbol ordering
Absolute symbols

Comment: LCD_WF8B_BPCLCD3_MASK unused
LCD_WF8B_BPCLCD3_SHIFT 00000002

Symbol: LCD_WF8B_BPCLCD3_SHIFT
   Definitions
      At line 1794 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPCLCD3_SHIFT unused
LCD_WF8B_BPCLCD40_MASK 00000004

Symbol: LCD_WF8B_BPCLCD40_MASK
   Definitions
      At line 1805 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPCLCD40_MASK unused
LCD_WF8B_BPCLCD40_SHIFT 00000002

Symbol: LCD_WF8B_BPCLCD40_SHIFT
   Definitions
      At line 1806 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPCLCD40_SHIFT unused
LCD_WF8B_BPCLCD41_MASK 00000004

Symbol: LCD_WF8B_BPCLCD41_MASK
   Definitions
      At line 1789 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPCLCD41_MASK unused
LCD_WF8B_BPCLCD41_SHIFT 00000002

Symbol: LCD_WF8B_BPCLCD41_SHIFT
   Definitions
      At line 1790 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPCLCD41_SHIFT unused
LCD_WF8B_BPCLCD42_MASK 00000004

Symbol: LCD_WF8B_BPCLCD42_MASK
   Definitions
      At line 1775 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPCLCD42_MASK unused
LCD_WF8B_BPCLCD42_SHIFT 00000002

Symbol: LCD_WF8B_BPCLCD42_SHIFT
   Definitions
      At line 1776 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPCLCD42_SHIFT unused
LCD_WF8B_BPCLCD43_MASK 00000004




ARM Macro Assembler    Page 136 Alphabetic symbol ordering
Absolute symbols

Symbol: LCD_WF8B_BPCLCD43_MASK
   Definitions
      At line 1761 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPCLCD43_MASK unused
LCD_WF8B_BPCLCD43_SHIFT 00000002

Symbol: LCD_WF8B_BPCLCD43_SHIFT
   Definitions
      At line 1762 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPCLCD43_SHIFT unused
LCD_WF8B_BPCLCD44_MASK 00000004

Symbol: LCD_WF8B_BPCLCD44_MASK
   Definitions
      At line 1801 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPCLCD44_MASK unused
LCD_WF8B_BPCLCD44_SHIFT 00000002

Symbol: LCD_WF8B_BPCLCD44_SHIFT
   Definitions
      At line 1802 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPCLCD44_SHIFT unused
LCD_WF8B_BPCLCD45_MASK 00000004

Symbol: LCD_WF8B_BPCLCD45_MASK
   Definitions
      At line 1771 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPCLCD45_MASK unused
LCD_WF8B_BPCLCD45_SHIFT 00000002

Symbol: LCD_WF8B_BPCLCD45_SHIFT
   Definitions
      At line 1772 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPCLCD45_SHIFT unused
LCD_WF8B_BPCLCD46_MASK 00000004

Symbol: LCD_WF8B_BPCLCD46_MASK
   Definitions
      At line 1727 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPCLCD46_MASK unused
LCD_WF8B_BPCLCD46_SHIFT 00000002

Symbol: LCD_WF8B_BPCLCD46_SHIFT
   Definitions
      At line 1728 in file ..\Exercise



ARM Macro Assembler    Page 137 Alphabetic symbol ordering
Absolute symbols

   Uses
      None
Comment: LCD_WF8B_BPCLCD46_SHIFT unused
LCD_WF8B_BPCLCD47_MASK 00000004

Symbol: LCD_WF8B_BPCLCD47_MASK
   Definitions
      At line 1701 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPCLCD47_MASK unused
LCD_WF8B_BPCLCD47_SHIFT 00000002

Symbol: LCD_WF8B_BPCLCD47_SHIFT
   Definitions
      At line 1702 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPCLCD47_SHIFT unused
LCD_WF8B_BPCLCD48_MASK 00000004

Symbol: LCD_WF8B_BPCLCD48_MASK
   Definitions
      At line 1695 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPCLCD48_MASK unused
LCD_WF8B_BPCLCD48_SHIFT 00000002

Symbol: LCD_WF8B_BPCLCD48_SHIFT
   Definitions
      At line 1696 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPCLCD48_SHIFT unused
LCD_WF8B_BPCLCD49_MASK 00000004

Symbol: LCD_WF8B_BPCLCD49_MASK
   Definitions
      At line 1709 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPCLCD49_MASK unused
LCD_WF8B_BPCLCD49_SHIFT 00000002

Symbol: LCD_WF8B_BPCLCD49_SHIFT
   Definitions
      At line 1710 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPCLCD49_SHIFT unused
LCD_WF8B_BPCLCD4_MASK 00000004

Symbol: LCD_WF8B_BPCLCD4_MASK
   Definitions
      At line 1765 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPCLCD4_MASK unused



ARM Macro Assembler    Page 138 Alphabetic symbol ordering
Absolute symbols

LCD_WF8B_BPCLCD4_SHIFT 00000002

Symbol: LCD_WF8B_BPCLCD4_SHIFT
   Definitions
      At line 1766 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPCLCD4_SHIFT unused
LCD_WF8B_BPCLCD50_MASK 00000004

Symbol: LCD_WF8B_BPCLCD50_MASK
   Definitions
      At line 1717 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPCLCD50_MASK unused
LCD_WF8B_BPCLCD50_SHIFT 00000002

Symbol: LCD_WF8B_BPCLCD50_SHIFT
   Definitions
      At line 1718 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPCLCD50_SHIFT unused
LCD_WF8B_BPCLCD51_MASK 00000004

Symbol: LCD_WF8B_BPCLCD51_MASK
   Definitions
      At line 1739 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPCLCD51_MASK unused
LCD_WF8B_BPCLCD51_SHIFT 00000002

Symbol: LCD_WF8B_BPCLCD51_SHIFT
   Definitions
      At line 1740 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPCLCD51_SHIFT unused
LCD_WF8B_BPCLCD52_MASK 00000004

Symbol: LCD_WF8B_BPCLCD52_MASK
   Definitions
      At line 1785 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPCLCD52_MASK unused
LCD_WF8B_BPCLCD52_SHIFT 00000002

Symbol: LCD_WF8B_BPCLCD52_SHIFT
   Definitions
      At line 1786 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPCLCD52_SHIFT unused
LCD_WF8B_BPCLCD53_MASK 00000004

Symbol: LCD_WF8B_BPCLCD53_MASK



ARM Macro Assembler    Page 139 Alphabetic symbol ordering
Absolute symbols

   Definitions
      At line 1755 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPCLCD53_MASK unused
LCD_WF8B_BPCLCD53_SHIFT 00000002

Symbol: LCD_WF8B_BPCLCD53_SHIFT
   Definitions
      At line 1756 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPCLCD53_SHIFT unused
LCD_WF8B_BPCLCD54_MASK 00000004

Symbol: LCD_WF8B_BPCLCD54_MASK
   Definitions
      At line 1743 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPCLCD54_MASK unused
LCD_WF8B_BPCLCD54_SHIFT 00000002

Symbol: LCD_WF8B_BPCLCD54_SHIFT
   Definitions
      At line 1744 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPCLCD54_SHIFT unused
LCD_WF8B_BPCLCD55_MASK 00000004

Symbol: LCD_WF8B_BPCLCD55_MASK
   Definitions
      At line 1689 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPCLCD55_MASK unused
LCD_WF8B_BPCLCD55_SHIFT 00000002

Symbol: LCD_WF8B_BPCLCD55_SHIFT
   Definitions
      At line 1690 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPCLCD55_SHIFT unused
LCD_WF8B_BPCLCD56_MASK 00000004

Symbol: LCD_WF8B_BPCLCD56_MASK
   Definitions
      At line 1809 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPCLCD56_MASK unused
LCD_WF8B_BPCLCD56_SHIFT 00000002

Symbol: LCD_WF8B_BPCLCD56_SHIFT
   Definitions
      At line 1810 in file ..\Exercise
   Uses



ARM Macro Assembler    Page 140 Alphabetic symbol ordering
Absolute symbols

      None
Comment: LCD_WF8B_BPCLCD56_SHIFT unused
LCD_WF8B_BPCLCD57_MASK 00000004

Symbol: LCD_WF8B_BPCLCD57_MASK
   Definitions
      At line 1773 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPCLCD57_MASK unused
LCD_WF8B_BPCLCD57_SHIFT 00000002

Symbol: LCD_WF8B_BPCLCD57_SHIFT
   Definitions
      At line 1774 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPCLCD57_SHIFT unused
LCD_WF8B_BPCLCD58_MASK 00000004

Symbol: LCD_WF8B_BPCLCD58_MASK
   Definitions
      At line 1787 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPCLCD58_MASK unused
LCD_WF8B_BPCLCD58_SHIFT 00000002

Symbol: LCD_WF8B_BPCLCD58_SHIFT
   Definitions
      At line 1788 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPCLCD58_SHIFT unused
LCD_WF8B_BPCLCD59_MASK 00000004

Symbol: LCD_WF8B_BPCLCD59_MASK
   Definitions
      At line 1723 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPCLCD59_MASK unused
LCD_WF8B_BPCLCD59_SHIFT 00000002

Symbol: LCD_WF8B_BPCLCD59_SHIFT
   Definitions
      At line 1724 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPCLCD59_SHIFT unused
LCD_WF8B_BPCLCD5_MASK 00000004

Symbol: LCD_WF8B_BPCLCD5_MASK
   Definitions
      At line 1731 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPCLCD5_MASK unused
LCD_WF8B_BPCLCD5_SHIFT 00000002



ARM Macro Assembler    Page 141 Alphabetic symbol ordering
Absolute symbols


Symbol: LCD_WF8B_BPCLCD5_SHIFT
   Definitions
      At line 1732 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPCLCD5_SHIFT unused
LCD_WF8B_BPCLCD60_MASK 00000004

Symbol: LCD_WF8B_BPCLCD60_MASK
   Definitions
      At line 1699 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPCLCD60_MASK unused
LCD_WF8B_BPCLCD60_SHIFT 00000002

Symbol: LCD_WF8B_BPCLCD60_SHIFT
   Definitions
      At line 1700 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPCLCD60_SHIFT unused
LCD_WF8B_BPCLCD61_MASK 00000004

Symbol: LCD_WF8B_BPCLCD61_MASK
   Definitions
      At line 1725 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPCLCD61_MASK unused
LCD_WF8B_BPCLCD61_SHIFT 00000002

Symbol: LCD_WF8B_BPCLCD61_SHIFT
   Definitions
      At line 1726 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPCLCD61_SHIFT unused
LCD_WF8B_BPCLCD62_MASK 00000004

Symbol: LCD_WF8B_BPCLCD62_MASK
   Definitions
      At line 1807 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPCLCD62_MASK unused
LCD_WF8B_BPCLCD62_SHIFT 00000002

Symbol: LCD_WF8B_BPCLCD62_SHIFT
   Definitions
      At line 1808 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPCLCD62_SHIFT unused
LCD_WF8B_BPCLCD63_MASK 00000004

Symbol: LCD_WF8B_BPCLCD63_MASK
   Definitions



ARM Macro Assembler    Page 142 Alphabetic symbol ordering
Absolute symbols

      At line 1733 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPCLCD63_MASK unused
LCD_WF8B_BPCLCD63_SHIFT 00000002

Symbol: LCD_WF8B_BPCLCD63_SHIFT
   Definitions
      At line 1734 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPCLCD63_SHIFT unused
LCD_WF8B_BPCLCD6_MASK 00000004

Symbol: LCD_WF8B_BPCLCD6_MASK
   Definitions
      At line 1813 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPCLCD6_MASK unused
LCD_WF8B_BPCLCD6_SHIFT 00000002

Symbol: LCD_WF8B_BPCLCD6_SHIFT
   Definitions
      At line 1814 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPCLCD6_SHIFT unused
LCD_WF8B_BPCLCD7_MASK 00000004

Symbol: LCD_WF8B_BPCLCD7_MASK
   Definitions
      At line 1763 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPCLCD7_MASK unused
LCD_WF8B_BPCLCD7_SHIFT 00000002

Symbol: LCD_WF8B_BPCLCD7_SHIFT
   Definitions
      At line 1764 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPCLCD7_SHIFT unused
LCD_WF8B_BPCLCD8_MASK 00000004

Symbol: LCD_WF8B_BPCLCD8_MASK
   Definitions
      At line 1705 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPCLCD8_MASK unused
LCD_WF8B_BPCLCD8_SHIFT 00000002

Symbol: LCD_WF8B_BPCLCD8_SHIFT
   Definitions
      At line 1706 in file ..\Exercise
   Uses
      None



ARM Macro Assembler    Page 143 Alphabetic symbol ordering
Absolute symbols

Comment: LCD_WF8B_BPCLCD8_SHIFT unused
LCD_WF8B_BPCLCD9_MASK 00000004

Symbol: LCD_WF8B_BPCLCD9_MASK
   Definitions
      At line 1741 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPCLCD9_MASK unused
LCD_WF8B_BPCLCD9_SHIFT 00000002

Symbol: LCD_WF8B_BPCLCD9_SHIFT
   Definitions
      At line 1742 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPCLCD9_SHIFT unused
LCD_WF8B_BPDLCD0_MASK 00000008

Symbol: LCD_WF8B_BPDLCD0_MASK
   Definitions
      At line 1855 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPDLCD0_MASK unused
LCD_WF8B_BPDLCD0_SHIFT 00000003

Symbol: LCD_WF8B_BPDLCD0_SHIFT
   Definitions
      At line 1856 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPDLCD0_SHIFT unused
LCD_WF8B_BPDLCD10_MASK 00000008

Symbol: LCD_WF8B_BPDLCD10_MASK
   Definitions
      At line 1829 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPDLCD10_MASK unused
LCD_WF8B_BPDLCD10_SHIFT 00000003

Symbol: LCD_WF8B_BPDLCD10_SHIFT
   Definitions
      At line 1830 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPDLCD10_SHIFT unused
LCD_WF8B_BPDLCD11_MASK 00000008

Symbol: LCD_WF8B_BPDLCD11_MASK
   Definitions
      At line 1941 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPDLCD11_MASK unused
LCD_WF8B_BPDLCD11_SHIFT 00000003




ARM Macro Assembler    Page 144 Alphabetic symbol ordering
Absolute symbols

Symbol: LCD_WF8B_BPDLCD11_SHIFT
   Definitions
      At line 1942 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPDLCD11_SHIFT unused
LCD_WF8B_BPDLCD12_MASK 00000008

Symbol: LCD_WF8B_BPDLCD12_MASK
   Definitions
      At line 1935 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPDLCD12_MASK unused
LCD_WF8B_BPDLCD12_SHIFT 00000003

Symbol: LCD_WF8B_BPDLCD12_SHIFT
   Definitions
      At line 1936 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPDLCD12_SHIFT unused
LCD_WF8B_BPDLCD13_MASK 00000008

Symbol: LCD_WF8B_BPDLCD13_MASK
   Definitions
      At line 1877 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPDLCD13_MASK unused
LCD_WF8B_BPDLCD13_SHIFT 00000003

Symbol: LCD_WF8B_BPDLCD13_SHIFT
   Definitions
      At line 1878 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPDLCD13_SHIFT unused
LCD_WF8B_BPDLCD14_MASK 00000008

Symbol: LCD_WF8B_BPDLCD14_MASK
   Definitions
      At line 1883 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPDLCD14_MASK unused
LCD_WF8B_BPDLCD14_SHIFT 00000003

Symbol: LCD_WF8B_BPDLCD14_SHIFT
   Definitions
      At line 1884 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPDLCD14_SHIFT unused
LCD_WF8B_BPDLCD15_MASK 00000008

Symbol: LCD_WF8B_BPDLCD15_MASK
   Definitions
      At line 1823 in file ..\Exercise



ARM Macro Assembler    Page 145 Alphabetic symbol ordering
Absolute symbols

   Uses
      None
Comment: LCD_WF8B_BPDLCD15_MASK unused
LCD_WF8B_BPDLCD15_SHIFT 00000003

Symbol: LCD_WF8B_BPDLCD15_SHIFT
   Definitions
      At line 1824 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPDLCD15_SHIFT unused
LCD_WF8B_BPDLCD16_MASK 00000008

Symbol: LCD_WF8B_BPDLCD16_MASK
   Definitions
      At line 1879 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPDLCD16_MASK unused
LCD_WF8B_BPDLCD16_SHIFT 00000003

Symbol: LCD_WF8B_BPDLCD16_SHIFT
   Definitions
      At line 1880 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPDLCD16_SHIFT unused
LCD_WF8B_BPDLCD17_MASK 00000008

Symbol: LCD_WF8B_BPDLCD17_MASK
   Definitions
      At line 1867 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPDLCD17_MASK unused
LCD_WF8B_BPDLCD17_SHIFT 00000003

Symbol: LCD_WF8B_BPDLCD17_SHIFT
   Definitions
      At line 1868 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPDLCD17_SHIFT unused
LCD_WF8B_BPDLCD18_MASK 00000008

Symbol: LCD_WF8B_BPDLCD18_MASK
   Definitions
      At line 1861 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPDLCD18_MASK unused
LCD_WF8B_BPDLCD18_SHIFT 00000003

Symbol: LCD_WF8B_BPDLCD18_SHIFT
   Definitions
      At line 1862 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPDLCD18_SHIFT unused



ARM Macro Assembler    Page 146 Alphabetic symbol ordering
Absolute symbols

LCD_WF8B_BPDLCD19_MASK 00000008

Symbol: LCD_WF8B_BPDLCD19_MASK
   Definitions
      At line 1849 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPDLCD19_MASK unused
LCD_WF8B_BPDLCD19_SHIFT 00000003

Symbol: LCD_WF8B_BPDLCD19_SHIFT
   Definitions
      At line 1850 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPDLCD19_SHIFT unused
LCD_WF8B_BPDLCD1_MASK 00000008

Symbol: LCD_WF8B_BPDLCD1_MASK
   Definitions
      At line 1835 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPDLCD1_MASK unused
LCD_WF8B_BPDLCD1_SHIFT 00000003

Symbol: LCD_WF8B_BPDLCD1_SHIFT
   Definitions
      At line 1836 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPDLCD1_SHIFT unused
LCD_WF8B_BPDLCD20_MASK 00000008

Symbol: LCD_WF8B_BPDLCD20_MASK
   Definitions
      At line 1839 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPDLCD20_MASK unused
LCD_WF8B_BPDLCD20_SHIFT 00000003

Symbol: LCD_WF8B_BPDLCD20_SHIFT
   Definitions
      At line 1840 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPDLCD20_SHIFT unused
LCD_WF8B_BPDLCD21_MASK 00000008

Symbol: LCD_WF8B_BPDLCD21_MASK
   Definitions
      At line 1831 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPDLCD21_MASK unused
LCD_WF8B_BPDLCD21_SHIFT 00000003

Symbol: LCD_WF8B_BPDLCD21_SHIFT



ARM Macro Assembler    Page 147 Alphabetic symbol ordering
Absolute symbols

   Definitions
      At line 1832 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPDLCD21_SHIFT unused
LCD_WF8B_BPDLCD22_MASK 00000008

Symbol: LCD_WF8B_BPDLCD22_MASK
   Definitions
      At line 1825 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPDLCD22_MASK unused
LCD_WF8B_BPDLCD22_SHIFT 00000003

Symbol: LCD_WF8B_BPDLCD22_SHIFT
   Definitions
      At line 1826 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPDLCD22_SHIFT unused
LCD_WF8B_BPDLCD23_MASK 00000008

Symbol: LCD_WF8B_BPDLCD23_MASK
   Definitions
      At line 1817 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPDLCD23_MASK unused
LCD_WF8B_BPDLCD23_SHIFT 00000003

Symbol: LCD_WF8B_BPDLCD23_SHIFT
   Definitions
      At line 1818 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPDLCD23_SHIFT unused
LCD_WF8B_BPDLCD24_MASK 00000008

Symbol: LCD_WF8B_BPDLCD24_MASK
   Definitions
      At line 1821 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPDLCD24_MASK unused
LCD_WF8B_BPDLCD24_SHIFT 00000003

Symbol: LCD_WF8B_BPDLCD24_SHIFT
   Definitions
      At line 1822 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPDLCD24_SHIFT unused
LCD_WF8B_BPDLCD25_MASK 00000008

Symbol: LCD_WF8B_BPDLCD25_MASK
   Definitions
      At line 1837 in file ..\Exercise
   Uses



ARM Macro Assembler    Page 148 Alphabetic symbol ordering
Absolute symbols

      None
Comment: LCD_WF8B_BPDLCD25_MASK unused
LCD_WF8B_BPDLCD25_SHIFT 00000003

Symbol: LCD_WF8B_BPDLCD25_SHIFT
   Definitions
      At line 1838 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPDLCD25_SHIFT unused
LCD_WF8B_BPDLCD26_MASK 00000008

Symbol: LCD_WF8B_BPDLCD26_MASK
   Definitions
      At line 1853 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPDLCD26_MASK unused
LCD_WF8B_BPDLCD26_SHIFT 00000003

Symbol: LCD_WF8B_BPDLCD26_SHIFT
   Definitions
      At line 1854 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPDLCD26_SHIFT unused
LCD_WF8B_BPDLCD27_MASK 00000008

Symbol: LCD_WF8B_BPDLCD27_MASK
   Definitions
      At line 1869 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPDLCD27_MASK unused
LCD_WF8B_BPDLCD27_SHIFT 00000003

Symbol: LCD_WF8B_BPDLCD27_SHIFT
   Definitions
      At line 1870 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPDLCD27_SHIFT unused
LCD_WF8B_BPDLCD28_MASK 00000008

Symbol: LCD_WF8B_BPDLCD28_MASK
   Definitions
      At line 1885 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPDLCD28_MASK unused
LCD_WF8B_BPDLCD28_SHIFT 00000003

Symbol: LCD_WF8B_BPDLCD28_SHIFT
   Definitions
      At line 1886 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPDLCD28_SHIFT unused
LCD_WF8B_BPDLCD29_MASK 00000008



ARM Macro Assembler    Page 149 Alphabetic symbol ordering
Absolute symbols


Symbol: LCD_WF8B_BPDLCD29_MASK
   Definitions
      At line 1901 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPDLCD29_MASK unused
LCD_WF8B_BPDLCD29_SHIFT 00000003

Symbol: LCD_WF8B_BPDLCD29_SHIFT
   Definitions
      At line 1902 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPDLCD29_SHIFT unused
LCD_WF8B_BPDLCD2_MASK 00000008

Symbol: LCD_WF8B_BPDLCD2_MASK
   Definitions
      At line 1841 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPDLCD2_MASK unused
LCD_WF8B_BPDLCD2_SHIFT 00000003

Symbol: LCD_WF8B_BPDLCD2_SHIFT
   Definitions
      At line 1842 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPDLCD2_SHIFT unused
LCD_WF8B_BPDLCD30_MASK 00000008

Symbol: LCD_WF8B_BPDLCD30_MASK
   Definitions
      At line 1917 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPDLCD30_MASK unused
LCD_WF8B_BPDLCD30_SHIFT 00000003

Symbol: LCD_WF8B_BPDLCD30_SHIFT
   Definitions
      At line 1918 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPDLCD30_SHIFT unused
LCD_WF8B_BPDLCD31_MASK 00000008

Symbol: LCD_WF8B_BPDLCD31_MASK
   Definitions
      At line 1933 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPDLCD31_MASK unused
LCD_WF8B_BPDLCD31_SHIFT 00000003

Symbol: LCD_WF8B_BPDLCD31_SHIFT
   Definitions



ARM Macro Assembler    Page 150 Alphabetic symbol ordering
Absolute symbols

      At line 1934 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPDLCD31_SHIFT unused
LCD_WF8B_BPDLCD32_MASK 00000008

Symbol: LCD_WF8B_BPDLCD32_MASK
   Definitions
      At line 1881 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPDLCD32_MASK unused
LCD_WF8B_BPDLCD32_SHIFT 00000003

Symbol: LCD_WF8B_BPDLCD32_SHIFT
   Definitions
      At line 1882 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPDLCD32_SHIFT unused
LCD_WF8B_BPDLCD33_MASK 00000008

Symbol: LCD_WF8B_BPDLCD33_MASK
   Definitions
      At line 1897 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPDLCD33_MASK unused
LCD_WF8B_BPDLCD33_SHIFT 00000003

Symbol: LCD_WF8B_BPDLCD33_SHIFT
   Definitions
      At line 1898 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPDLCD33_SHIFT unused
LCD_WF8B_BPDLCD34_MASK 00000008

Symbol: LCD_WF8B_BPDLCD34_MASK
   Definitions
      At line 1899 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPDLCD34_MASK unused
LCD_WF8B_BPDLCD34_SHIFT 00000003

Symbol: LCD_WF8B_BPDLCD34_SHIFT
   Definitions
      At line 1900 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPDLCD34_SHIFT unused
LCD_WF8B_BPDLCD35_MASK 00000008

Symbol: LCD_WF8B_BPDLCD35_MASK
   Definitions
      At line 1909 in file ..\Exercise
   Uses
      None



ARM Macro Assembler    Page 151 Alphabetic symbol ordering
Absolute symbols

Comment: LCD_WF8B_BPDLCD35_MASK unused
LCD_WF8B_BPDLCD35_SHIFT 00000003

Symbol: LCD_WF8B_BPDLCD35_SHIFT
   Definitions
      At line 1910 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPDLCD35_SHIFT unused
LCD_WF8B_BPDLCD36_MASK 00000008

Symbol: LCD_WF8B_BPDLCD36_MASK
   Definitions
      At line 1915 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPDLCD36_MASK unused
LCD_WF8B_BPDLCD36_SHIFT 00000003

Symbol: LCD_WF8B_BPDLCD36_SHIFT
   Definitions
      At line 1916 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPDLCD36_SHIFT unused
LCD_WF8B_BPDLCD37_MASK 00000008

Symbol: LCD_WF8B_BPDLCD37_MASK
   Definitions
      At line 1921 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPDLCD37_MASK unused
LCD_WF8B_BPDLCD37_SHIFT 00000003

Symbol: LCD_WF8B_BPDLCD37_SHIFT
   Definitions
      At line 1922 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPDLCD37_SHIFT unused
LCD_WF8B_BPDLCD38_MASK 00000008

Symbol: LCD_WF8B_BPDLCD38_MASK
   Definitions
      At line 1927 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPDLCD38_MASK unused
LCD_WF8B_BPDLCD38_SHIFT 00000003

Symbol: LCD_WF8B_BPDLCD38_SHIFT
   Definitions
      At line 1928 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPDLCD38_SHIFT unused
LCD_WF8B_BPDLCD39_MASK 00000008




ARM Macro Assembler    Page 152 Alphabetic symbol ordering
Absolute symbols

Symbol: LCD_WF8B_BPDLCD39_MASK
   Definitions
      At line 1937 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPDLCD39_MASK unused
LCD_WF8B_BPDLCD39_SHIFT 00000003

Symbol: LCD_WF8B_BPDLCD39_SHIFT
   Definitions
      At line 1938 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPDLCD39_SHIFT unused
LCD_WF8B_BPDLCD3_MASK 00000008

Symbol: LCD_WF8B_BPDLCD3_MASK
   Definitions
      At line 1939 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPDLCD3_MASK unused
LCD_WF8B_BPDLCD3_SHIFT 00000003

Symbol: LCD_WF8B_BPDLCD3_SHIFT
   Definitions
      At line 1940 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPDLCD3_SHIFT unused
LCD_WF8B_BPDLCD40_MASK 00000008

Symbol: LCD_WF8B_BPDLCD40_MASK
   Definitions
      At line 1931 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPDLCD40_MASK unused
LCD_WF8B_BPDLCD40_SHIFT 00000003

Symbol: LCD_WF8B_BPDLCD40_SHIFT
   Definitions
      At line 1932 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPDLCD40_SHIFT unused
LCD_WF8B_BPDLCD41_MASK 00000008

Symbol: LCD_WF8B_BPDLCD41_MASK
   Definitions
      At line 1919 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPDLCD41_MASK unused
LCD_WF8B_BPDLCD41_SHIFT 00000003

Symbol: LCD_WF8B_BPDLCD41_SHIFT
   Definitions
      At line 1920 in file ..\Exercise



ARM Macro Assembler    Page 153 Alphabetic symbol ordering
Absolute symbols

   Uses
      None
Comment: LCD_WF8B_BPDLCD41_SHIFT unused
LCD_WF8B_BPDLCD42_MASK 00000008

Symbol: LCD_WF8B_BPDLCD42_MASK
   Definitions
      At line 1907 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPDLCD42_MASK unused
LCD_WF8B_BPDLCD42_SHIFT 00000003

Symbol: LCD_WF8B_BPDLCD42_SHIFT
   Definitions
      At line 1908 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPDLCD42_SHIFT unused
LCD_WF8B_BPDLCD43_MASK 00000008

Symbol: LCD_WF8B_BPDLCD43_MASK
   Definitions
      At line 1887 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPDLCD43_MASK unused
LCD_WF8B_BPDLCD43_SHIFT 00000003

Symbol: LCD_WF8B_BPDLCD43_SHIFT
   Definitions
      At line 1888 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPDLCD43_SHIFT unused
LCD_WF8B_BPDLCD44_MASK 00000008

Symbol: LCD_WF8B_BPDLCD44_MASK
   Definitions
      At line 1923 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPDLCD44_MASK unused
LCD_WF8B_BPDLCD44_SHIFT 00000003

Symbol: LCD_WF8B_BPDLCD44_SHIFT
   Definitions
      At line 1924 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPDLCD44_SHIFT unused
LCD_WF8B_BPDLCD45_MASK 00000008

Symbol: LCD_WF8B_BPDLCD45_MASK
   Definitions
      At line 1891 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPDLCD45_MASK unused



ARM Macro Assembler    Page 154 Alphabetic symbol ordering
Absolute symbols

LCD_WF8B_BPDLCD45_SHIFT 00000003

Symbol: LCD_WF8B_BPDLCD45_SHIFT
   Definitions
      At line 1892 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPDLCD45_SHIFT unused
LCD_WF8B_BPDLCD46_MASK 00000008

Symbol: LCD_WF8B_BPDLCD46_MASK
   Definitions
      At line 1859 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPDLCD46_MASK unused
LCD_WF8B_BPDLCD46_SHIFT 00000003

Symbol: LCD_WF8B_BPDLCD46_SHIFT
   Definitions
      At line 1860 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPDLCD46_SHIFT unused
LCD_WF8B_BPDLCD47_MASK 00000008

Symbol: LCD_WF8B_BPDLCD47_MASK
   Definitions
      At line 1815 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPDLCD47_MASK unused
LCD_WF8B_BPDLCD47_SHIFT 00000003

Symbol: LCD_WF8B_BPDLCD47_SHIFT
   Definitions
      At line 1816 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPDLCD47_SHIFT unused
LCD_WF8B_BPDLCD48_MASK 00000008

Symbol: LCD_WF8B_BPDLCD48_MASK
   Definitions
      At line 1819 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPDLCD48_MASK unused
LCD_WF8B_BPDLCD48_SHIFT 00000003

Symbol: LCD_WF8B_BPDLCD48_SHIFT
   Definitions
      At line 1820 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPDLCD48_SHIFT unused
LCD_WF8B_BPDLCD49_MASK 00000008

Symbol: LCD_WF8B_BPDLCD49_MASK



ARM Macro Assembler    Page 155 Alphabetic symbol ordering
Absolute symbols

   Definitions
      At line 1833 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPDLCD49_MASK unused
LCD_WF8B_BPDLCD49_SHIFT 00000003

Symbol: LCD_WF8B_BPDLCD49_SHIFT
   Definitions
      At line 1834 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPDLCD49_SHIFT unused
LCD_WF8B_BPDLCD4_MASK 00000008

Symbol: LCD_WF8B_BPDLCD4_MASK
   Definitions
      At line 1889 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPDLCD4_MASK unused
LCD_WF8B_BPDLCD4_SHIFT 00000003

Symbol: LCD_WF8B_BPDLCD4_SHIFT
   Definitions
      At line 1890 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPDLCD4_SHIFT unused
LCD_WF8B_BPDLCD50_MASK 00000008

Symbol: LCD_WF8B_BPDLCD50_MASK
   Definitions
      At line 1857 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPDLCD50_MASK unused
LCD_WF8B_BPDLCD50_SHIFT 00000003

Symbol: LCD_WF8B_BPDLCD50_SHIFT
   Definitions
      At line 1858 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPDLCD50_SHIFT unused
LCD_WF8B_BPDLCD51_MASK 00000008

Symbol: LCD_WF8B_BPDLCD51_MASK
   Definitions
      At line 1873 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPDLCD51_MASK unused
LCD_WF8B_BPDLCD51_SHIFT 00000003

Symbol: LCD_WF8B_BPDLCD51_SHIFT
   Definitions
      At line 1874 in file ..\Exercise
   Uses



ARM Macro Assembler    Page 156 Alphabetic symbol ordering
Absolute symbols

      None
Comment: LCD_WF8B_BPDLCD51_SHIFT unused
LCD_WF8B_BPDLCD52_MASK 00000008

Symbol: LCD_WF8B_BPDLCD52_MASK
   Definitions
      At line 1911 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPDLCD52_MASK unused
LCD_WF8B_BPDLCD52_SHIFT 00000003

Symbol: LCD_WF8B_BPDLCD52_SHIFT
   Definitions
      At line 1912 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPDLCD52_SHIFT unused
LCD_WF8B_BPDLCD53_MASK 00000008

Symbol: LCD_WF8B_BPDLCD53_MASK
   Definitions
      At line 1871 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPDLCD53_MASK unused
LCD_WF8B_BPDLCD53_SHIFT 00000003

Symbol: LCD_WF8B_BPDLCD53_SHIFT
   Definitions
      At line 1872 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPDLCD53_SHIFT unused
LCD_WF8B_BPDLCD54_MASK 00000008

Symbol: LCD_WF8B_BPDLCD54_MASK
   Definitions
      At line 1875 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPDLCD54_MASK unused
LCD_WF8B_BPDLCD54_SHIFT 00000003

Symbol: LCD_WF8B_BPDLCD54_SHIFT
   Definitions
      At line 1876 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPDLCD54_SHIFT unused
LCD_WF8B_BPDLCD55_MASK 00000008

Symbol: LCD_WF8B_BPDLCD55_MASK
   Definitions
      At line 1843 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPDLCD55_MASK unused
LCD_WF8B_BPDLCD55_SHIFT 00000003



ARM Macro Assembler    Page 157 Alphabetic symbol ordering
Absolute symbols


Symbol: LCD_WF8B_BPDLCD55_SHIFT
   Definitions
      At line 1844 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPDLCD55_SHIFT unused
LCD_WF8B_BPDLCD56_MASK 00000008

Symbol: LCD_WF8B_BPDLCD56_MASK
   Definitions
      At line 1929 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPDLCD56_MASK unused
LCD_WF8B_BPDLCD56_SHIFT 00000003

Symbol: LCD_WF8B_BPDLCD56_SHIFT
   Definitions
      At line 1930 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPDLCD56_SHIFT unused
LCD_WF8B_BPDLCD57_MASK 00000008

Symbol: LCD_WF8B_BPDLCD57_MASK
   Definitions
      At line 1905 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPDLCD57_MASK unused
LCD_WF8B_BPDLCD57_SHIFT 00000003

Symbol: LCD_WF8B_BPDLCD57_SHIFT
   Definitions
      At line 1906 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPDLCD57_SHIFT unused
LCD_WF8B_BPDLCD58_MASK 00000008

Symbol: LCD_WF8B_BPDLCD58_MASK
   Definitions
      At line 1903 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPDLCD58_MASK unused
LCD_WF8B_BPDLCD58_SHIFT 00000003

Symbol: LCD_WF8B_BPDLCD58_SHIFT
   Definitions
      At line 1904 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPDLCD58_SHIFT unused
LCD_WF8B_BPDLCD59_MASK 00000008

Symbol: LCD_WF8B_BPDLCD59_MASK
   Definitions



ARM Macro Assembler    Page 158 Alphabetic symbol ordering
Absolute symbols

      At line 1845 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPDLCD59_MASK unused
LCD_WF8B_BPDLCD59_SHIFT 00000003

Symbol: LCD_WF8B_BPDLCD59_SHIFT
   Definitions
      At line 1846 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPDLCD59_SHIFT unused
LCD_WF8B_BPDLCD5_MASK 00000008

Symbol: LCD_WF8B_BPDLCD5_MASK
   Definitions
      At line 1847 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPDLCD5_MASK unused
LCD_WF8B_BPDLCD5_SHIFT 00000003

Symbol: LCD_WF8B_BPDLCD5_SHIFT
   Definitions
      At line 1848 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPDLCD5_SHIFT unused
LCD_WF8B_BPDLCD60_MASK 00000008

Symbol: LCD_WF8B_BPDLCD60_MASK
   Definitions
      At line 1827 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPDLCD60_MASK unused
LCD_WF8B_BPDLCD60_SHIFT 00000003

Symbol: LCD_WF8B_BPDLCD60_SHIFT
   Definitions
      At line 1828 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPDLCD60_SHIFT unused
LCD_WF8B_BPDLCD61_MASK 00000008

Symbol: LCD_WF8B_BPDLCD61_MASK
   Definitions
      At line 1863 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPDLCD61_MASK unused
LCD_WF8B_BPDLCD61_SHIFT 00000003

Symbol: LCD_WF8B_BPDLCD61_SHIFT
   Definitions
      At line 1864 in file ..\Exercise
   Uses
      None



ARM Macro Assembler    Page 159 Alphabetic symbol ordering
Absolute symbols

Comment: LCD_WF8B_BPDLCD61_SHIFT unused
LCD_WF8B_BPDLCD62_MASK 00000008

Symbol: LCD_WF8B_BPDLCD62_MASK
   Definitions
      At line 1895 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPDLCD62_MASK unused
LCD_WF8B_BPDLCD62_SHIFT 00000003

Symbol: LCD_WF8B_BPDLCD62_SHIFT
   Definitions
      At line 1896 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPDLCD62_SHIFT unused
LCD_WF8B_BPDLCD63_MASK 00000008

Symbol: LCD_WF8B_BPDLCD63_MASK
   Definitions
      At line 1925 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPDLCD63_MASK unused
LCD_WF8B_BPDLCD63_SHIFT 00000003

Symbol: LCD_WF8B_BPDLCD63_SHIFT
   Definitions
      At line 1926 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPDLCD63_SHIFT unused
LCD_WF8B_BPDLCD6_MASK 00000008

Symbol: LCD_WF8B_BPDLCD6_MASK
   Definitions
      At line 1851 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPDLCD6_MASK unused
LCD_WF8B_BPDLCD6_SHIFT 00000003

Symbol: LCD_WF8B_BPDLCD6_SHIFT
   Definitions
      At line 1852 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPDLCD6_SHIFT unused
LCD_WF8B_BPDLCD7_MASK 00000008

Symbol: LCD_WF8B_BPDLCD7_MASK
   Definitions
      At line 1913 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPDLCD7_MASK unused
LCD_WF8B_BPDLCD7_SHIFT 00000003




ARM Macro Assembler    Page 160 Alphabetic symbol ordering
Absolute symbols

Symbol: LCD_WF8B_BPDLCD7_SHIFT
   Definitions
      At line 1914 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPDLCD7_SHIFT unused
LCD_WF8B_BPDLCD8_MASK 00000008

Symbol: LCD_WF8B_BPDLCD8_MASK
   Definitions
      At line 1893 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPDLCD8_MASK unused
LCD_WF8B_BPDLCD8_SHIFT 00000003

Symbol: LCD_WF8B_BPDLCD8_SHIFT
   Definitions
      At line 1894 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPDLCD8_SHIFT unused
LCD_WF8B_BPDLCD9_MASK 00000008

Symbol: LCD_WF8B_BPDLCD9_MASK
   Definitions
      At line 1865 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPDLCD9_MASK unused
LCD_WF8B_BPDLCD9_SHIFT 00000003

Symbol: LCD_WF8B_BPDLCD9_SHIFT
   Definitions
      At line 1866 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPDLCD9_SHIFT unused
LCD_WF8B_BPELCD0_MASK 00000010

Symbol: LCD_WF8B_BPELCD0_MASK
   Definitions
      At line 2053 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPELCD0_MASK unused
LCD_WF8B_BPELCD0_SHIFT 00000004

Symbol: LCD_WF8B_BPELCD0_SHIFT
   Definitions
      At line 2054 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPELCD0_SHIFT unused
LCD_WF8B_BPELCD10_MASK 00000010

Symbol: LCD_WF8B_BPELCD10_MASK
   Definitions
      At line 1997 in file ..\Exercise



ARM Macro Assembler    Page 161 Alphabetic symbol ordering
Absolute symbols

   Uses
      None
Comment: LCD_WF8B_BPELCD10_MASK unused
LCD_WF8B_BPELCD10_SHIFT 00000004

Symbol: LCD_WF8B_BPELCD10_SHIFT
   Definitions
      At line 1998 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPELCD10_SHIFT unused
LCD_WF8B_BPELCD11_MASK 00000010

Symbol: LCD_WF8B_BPELCD11_MASK
   Definitions
      At line 1969 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPELCD11_MASK unused
LCD_WF8B_BPELCD11_SHIFT 00000004

Symbol: LCD_WF8B_BPELCD11_SHIFT
   Definitions
      At line 1970 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPELCD11_SHIFT unused
LCD_WF8B_BPELCD12_MASK 00000010

Symbol: LCD_WF8B_BPELCD12_MASK
   Definitions
      At line 1943 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPELCD12_MASK unused
LCD_WF8B_BPELCD12_SHIFT 00000004

Symbol: LCD_WF8B_BPELCD12_SHIFT
   Definitions
      At line 1944 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPELCD12_SHIFT unused
LCD_WF8B_BPELCD13_MASK 00000010

Symbol: LCD_WF8B_BPELCD13_MASK
   Definitions
      At line 1999 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPELCD13_MASK unused
LCD_WF8B_BPELCD13_SHIFT 00000004

Symbol: LCD_WF8B_BPELCD13_SHIFT
   Definitions
      At line 2000 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPELCD13_SHIFT unused



ARM Macro Assembler    Page 162 Alphabetic symbol ordering
Absolute symbols

LCD_WF8B_BPELCD14_MASK 00000010

Symbol: LCD_WF8B_BPELCD14_MASK
   Definitions
      At line 2051 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPELCD14_MASK unused
LCD_WF8B_BPELCD14_SHIFT 00000004

Symbol: LCD_WF8B_BPELCD14_SHIFT
   Definitions
      At line 2052 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPELCD14_SHIFT unused
LCD_WF8B_BPELCD15_MASK 00000010

Symbol: LCD_WF8B_BPELCD15_MASK
   Definitions
      At line 2057 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPELCD15_MASK unused
LCD_WF8B_BPELCD15_SHIFT 00000004

Symbol: LCD_WF8B_BPELCD15_SHIFT
   Definitions
      At line 2058 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPELCD15_SHIFT unused
LCD_WF8B_BPELCD16_MASK 00000010

Symbol: LCD_WF8B_BPELCD16_MASK
   Definitions
      At line 2035 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPELCD16_MASK unused
LCD_WF8B_BPELCD16_SHIFT 00000004

Symbol: LCD_WF8B_BPELCD16_SHIFT
   Definitions
      At line 2036 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPELCD16_SHIFT unused
LCD_WF8B_BPELCD17_MASK 00000010

Symbol: LCD_WF8B_BPELCD17_MASK
   Definitions
      At line 2031 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPELCD17_MASK unused
LCD_WF8B_BPELCD17_SHIFT 00000004

Symbol: LCD_WF8B_BPELCD17_SHIFT



ARM Macro Assembler    Page 163 Alphabetic symbol ordering
Absolute symbols

   Definitions
      At line 2032 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPELCD17_SHIFT unused
LCD_WF8B_BPELCD18_MASK 00000010

Symbol: LCD_WF8B_BPELCD18_MASK
   Definitions
      At line 2027 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPELCD18_MASK unused
LCD_WF8B_BPELCD18_SHIFT 00000004

Symbol: LCD_WF8B_BPELCD18_SHIFT
   Definitions
      At line 2028 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPELCD18_SHIFT unused
LCD_WF8B_BPELCD19_MASK 00000010

Symbol: LCD_WF8B_BPELCD19_MASK
   Definitions
      At line 2021 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPELCD19_MASK unused
LCD_WF8B_BPELCD19_SHIFT 00000004

Symbol: LCD_WF8B_BPELCD19_SHIFT
   Definitions
      At line 2022 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPELCD19_SHIFT unused
LCD_WF8B_BPELCD1_MASK 00000010

Symbol: LCD_WF8B_BPELCD1_MASK
   Definitions
      At line 2043 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPELCD1_MASK unused
LCD_WF8B_BPELCD1_SHIFT 00000004

Symbol: LCD_WF8B_BPELCD1_SHIFT
   Definitions
      At line 2044 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPELCD1_SHIFT unused
LCD_WF8B_BPELCD20_MASK 00000010

Symbol: LCD_WF8B_BPELCD20_MASK
   Definitions
      At line 2019 in file ..\Exercise
   Uses



ARM Macro Assembler    Page 164 Alphabetic symbol ordering
Absolute symbols

      None
Comment: LCD_WF8B_BPELCD20_MASK unused
LCD_WF8B_BPELCD20_SHIFT 00000004

Symbol: LCD_WF8B_BPELCD20_SHIFT
   Definitions
      At line 2020 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPELCD20_SHIFT unused
LCD_WF8B_BPELCD21_MASK 00000010

Symbol: LCD_WF8B_BPELCD21_MASK
   Definitions
      At line 2015 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPELCD21_MASK unused
LCD_WF8B_BPELCD21_SHIFT 00000004

Symbol: LCD_WF8B_BPELCD21_SHIFT
   Definitions
      At line 2016 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPELCD21_SHIFT unused
LCD_WF8B_BPELCD22_MASK 00000010

Symbol: LCD_WF8B_BPELCD22_MASK
   Definitions
      At line 2011 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPELCD22_MASK unused
LCD_WF8B_BPELCD22_SHIFT 00000004

Symbol: LCD_WF8B_BPELCD22_SHIFT
   Definitions
      At line 2012 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPELCD22_SHIFT unused
LCD_WF8B_BPELCD23_MASK 00000010

Symbol: LCD_WF8B_BPELCD23_MASK
   Definitions
      At line 2009 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPELCD23_MASK unused
LCD_WF8B_BPELCD23_SHIFT 00000004

Symbol: LCD_WF8B_BPELCD23_SHIFT
   Definitions
      At line 2010 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPELCD23_SHIFT unused
LCD_WF8B_BPELCD24_MASK 00000010



ARM Macro Assembler    Page 165 Alphabetic symbol ordering
Absolute symbols


Symbol: LCD_WF8B_BPELCD24_MASK
   Definitions
      At line 2005 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPELCD24_MASK unused
LCD_WF8B_BPELCD24_SHIFT 00000004

Symbol: LCD_WF8B_BPELCD24_SHIFT
   Definitions
      At line 2006 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPELCD24_SHIFT unused
LCD_WF8B_BPELCD25_MASK 00000010

Symbol: LCD_WF8B_BPELCD25_MASK
   Definitions
      At line 2001 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPELCD25_MASK unused
LCD_WF8B_BPELCD25_SHIFT 00000004

Symbol: LCD_WF8B_BPELCD25_SHIFT
   Definitions
      At line 2002 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPELCD25_SHIFT unused
LCD_WF8B_BPELCD26_MASK 00000010

Symbol: LCD_WF8B_BPELCD26_MASK
   Definitions
      At line 1995 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPELCD26_MASK unused
LCD_WF8B_BPELCD26_SHIFT 00000004

Symbol: LCD_WF8B_BPELCD26_SHIFT
   Definitions
      At line 1996 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPELCD26_SHIFT unused
LCD_WF8B_BPELCD27_MASK 00000010

Symbol: LCD_WF8B_BPELCD27_MASK
   Definitions
      At line 1991 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPELCD27_MASK unused
LCD_WF8B_BPELCD27_SHIFT 00000004

Symbol: LCD_WF8B_BPELCD27_SHIFT
   Definitions



ARM Macro Assembler    Page 166 Alphabetic symbol ordering
Absolute symbols

      At line 1992 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPELCD27_SHIFT unused
LCD_WF8B_BPELCD28_MASK 00000010

Symbol: LCD_WF8B_BPELCD28_MASK
   Definitions
      At line 1987 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPELCD28_MASK unused
LCD_WF8B_BPELCD28_SHIFT 00000004

Symbol: LCD_WF8B_BPELCD28_SHIFT
   Definitions
      At line 1988 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPELCD28_SHIFT unused
LCD_WF8B_BPELCD29_MASK 00000010

Symbol: LCD_WF8B_BPELCD29_MASK
   Definitions
      At line 1981 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPELCD29_MASK unused
LCD_WF8B_BPELCD29_SHIFT 00000004

Symbol: LCD_WF8B_BPELCD29_SHIFT
   Definitions
      At line 1982 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPELCD29_SHIFT unused
LCD_WF8B_BPELCD2_MASK 00000010

Symbol: LCD_WF8B_BPELCD2_MASK
   Definitions
      At line 1989 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPELCD2_MASK unused
LCD_WF8B_BPELCD2_SHIFT 00000004

Symbol: LCD_WF8B_BPELCD2_SHIFT
   Definitions
      At line 1990 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPELCD2_SHIFT unused
LCD_WF8B_BPELCD30_MASK 00000010

Symbol: LCD_WF8B_BPELCD30_MASK
   Definitions
      At line 1979 in file ..\Exercise
   Uses
      None



ARM Macro Assembler    Page 167 Alphabetic symbol ordering
Absolute symbols

Comment: LCD_WF8B_BPELCD30_MASK unused
LCD_WF8B_BPELCD30_SHIFT 00000004

Symbol: LCD_WF8B_BPELCD30_SHIFT
   Definitions
      At line 1980 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPELCD30_SHIFT unused
LCD_WF8B_BPELCD31_MASK 00000010

Symbol: LCD_WF8B_BPELCD31_MASK
   Definitions
      At line 1975 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPELCD31_MASK unused
LCD_WF8B_BPELCD31_SHIFT 00000004

Symbol: LCD_WF8B_BPELCD31_SHIFT
   Definitions
      At line 1976 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPELCD31_SHIFT unused
LCD_WF8B_BPELCD32_MASK 00000010

Symbol: LCD_WF8B_BPELCD32_MASK
   Definitions
      At line 1973 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPELCD32_MASK unused
LCD_WF8B_BPELCD32_SHIFT 00000004

Symbol: LCD_WF8B_BPELCD32_SHIFT
   Definitions
      At line 1974 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPELCD32_SHIFT unused
LCD_WF8B_BPELCD33_MASK 00000010

Symbol: LCD_WF8B_BPELCD33_MASK
   Definitions
      At line 1967 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPELCD33_MASK unused
LCD_WF8B_BPELCD33_SHIFT 00000004

Symbol: LCD_WF8B_BPELCD33_SHIFT
   Definitions
      At line 1968 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPELCD33_SHIFT unused
LCD_WF8B_BPELCD34_MASK 00000010




ARM Macro Assembler    Page 168 Alphabetic symbol ordering
Absolute symbols

Symbol: LCD_WF8B_BPELCD34_MASK
   Definitions
      At line 1965 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPELCD34_MASK unused
LCD_WF8B_BPELCD34_SHIFT 00000004

Symbol: LCD_WF8B_BPELCD34_SHIFT
   Definitions
      At line 1966 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPELCD34_SHIFT unused
LCD_WF8B_BPELCD35_MASK 00000010

Symbol: LCD_WF8B_BPELCD35_MASK
   Definitions
      At line 1961 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPELCD35_MASK unused
LCD_WF8B_BPELCD35_SHIFT 00000004

Symbol: LCD_WF8B_BPELCD35_SHIFT
   Definitions
      At line 1962 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPELCD35_SHIFT unused
LCD_WF8B_BPELCD36_MASK 00000010

Symbol: LCD_WF8B_BPELCD36_MASK
   Definitions
      At line 1957 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPELCD36_MASK unused
LCD_WF8B_BPELCD36_SHIFT 00000004

Symbol: LCD_WF8B_BPELCD36_SHIFT
   Definitions
      At line 1958 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPELCD36_SHIFT unused
LCD_WF8B_BPELCD37_MASK 00000010

Symbol: LCD_WF8B_BPELCD37_MASK
   Definitions
      At line 1953 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPELCD37_MASK unused
LCD_WF8B_BPELCD37_SHIFT 00000004

Symbol: LCD_WF8B_BPELCD37_SHIFT
   Definitions
      At line 1954 in file ..\Exercise



ARM Macro Assembler    Page 169 Alphabetic symbol ordering
Absolute symbols

   Uses
      None
Comment: LCD_WF8B_BPELCD37_SHIFT unused
LCD_WF8B_BPELCD38_MASK 00000010

Symbol: LCD_WF8B_BPELCD38_MASK
   Definitions
      At line 1949 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPELCD38_MASK unused
LCD_WF8B_BPELCD38_SHIFT 00000004

Symbol: LCD_WF8B_BPELCD38_SHIFT
   Definitions
      At line 1950 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPELCD38_SHIFT unused
LCD_WF8B_BPELCD39_MASK 00000010

Symbol: LCD_WF8B_BPELCD39_MASK
   Definitions
      At line 1945 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPELCD39_MASK unused
LCD_WF8B_BPELCD39_SHIFT 00000004

Symbol: LCD_WF8B_BPELCD39_SHIFT
   Definitions
      At line 1946 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPELCD39_SHIFT unused
LCD_WF8B_BPELCD3_MASK 00000010

Symbol: LCD_WF8B_BPELCD3_MASK
   Definitions
      At line 1947 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPELCD3_MASK unused
LCD_WF8B_BPELCD3_SHIFT 00000004

Symbol: LCD_WF8B_BPELCD3_SHIFT
   Definitions
      At line 1948 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPELCD3_SHIFT unused
LCD_WF8B_BPELCD40_MASK 00000010

Symbol: LCD_WF8B_BPELCD40_MASK
   Definitions
      At line 1951 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPELCD40_MASK unused



ARM Macro Assembler    Page 170 Alphabetic symbol ordering
Absolute symbols

LCD_WF8B_BPELCD40_SHIFT 00000004

Symbol: LCD_WF8B_BPELCD40_SHIFT
   Definitions
      At line 1952 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPELCD40_SHIFT unused
LCD_WF8B_BPELCD41_MASK 00000010

Symbol: LCD_WF8B_BPELCD41_MASK
   Definitions
      At line 1955 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPELCD41_MASK unused
LCD_WF8B_BPELCD41_SHIFT 00000004

Symbol: LCD_WF8B_BPELCD41_SHIFT
   Definitions
      At line 1956 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPELCD41_SHIFT unused
LCD_WF8B_BPELCD42_MASK 00000010

Symbol: LCD_WF8B_BPELCD42_MASK
   Definitions
      At line 1963 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPELCD42_MASK unused
LCD_WF8B_BPELCD42_SHIFT 00000004

Symbol: LCD_WF8B_BPELCD42_SHIFT
   Definitions
      At line 1964 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPELCD42_SHIFT unused
LCD_WF8B_BPELCD43_MASK 00000010

Symbol: LCD_WF8B_BPELCD43_MASK
   Definitions
      At line 1971 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPELCD43_MASK unused
LCD_WF8B_BPELCD43_SHIFT 00000004

Symbol: LCD_WF8B_BPELCD43_SHIFT
   Definitions
      At line 1972 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPELCD43_SHIFT unused
LCD_WF8B_BPELCD44_MASK 00000010

Symbol: LCD_WF8B_BPELCD44_MASK



ARM Macro Assembler    Page 171 Alphabetic symbol ordering
Absolute symbols

   Definitions
      At line 1977 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPELCD44_MASK unused
LCD_WF8B_BPELCD44_SHIFT 00000004

Symbol: LCD_WF8B_BPELCD44_SHIFT
   Definitions
      At line 1978 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPELCD44_SHIFT unused
LCD_WF8B_BPELCD45_MASK 00000010

Symbol: LCD_WF8B_BPELCD45_MASK
   Definitions
      At line 1985 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPELCD45_MASK unused
LCD_WF8B_BPELCD45_SHIFT 00000004

Symbol: LCD_WF8B_BPELCD45_SHIFT
   Definitions
      At line 1986 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPELCD45_SHIFT unused
LCD_WF8B_BPELCD46_MASK 00000010

Symbol: LCD_WF8B_BPELCD46_MASK
   Definitions
      At line 1993 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPELCD46_MASK unused
LCD_WF8B_BPELCD46_SHIFT 00000004

Symbol: LCD_WF8B_BPELCD46_SHIFT
   Definitions
      At line 1994 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPELCD46_SHIFT unused
LCD_WF8B_BPELCD47_MASK 00000010

Symbol: LCD_WF8B_BPELCD47_MASK
   Definitions
      At line 2007 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPELCD47_MASK unused
LCD_WF8B_BPELCD47_SHIFT 00000004

Symbol: LCD_WF8B_BPELCD47_SHIFT
   Definitions
      At line 2008 in file ..\Exercise
   Uses



ARM Macro Assembler    Page 172 Alphabetic symbol ordering
Absolute symbols

      None
Comment: LCD_WF8B_BPELCD47_SHIFT unused
LCD_WF8B_BPELCD48_MASK 00000010

Symbol: LCD_WF8B_BPELCD48_MASK
   Definitions
      At line 2013 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPELCD48_MASK unused
LCD_WF8B_BPELCD48_SHIFT 00000004

Symbol: LCD_WF8B_BPELCD48_SHIFT
   Definitions
      At line 2014 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPELCD48_SHIFT unused
LCD_WF8B_BPELCD49_MASK 00000010

Symbol: LCD_WF8B_BPELCD49_MASK
   Definitions
      At line 2017 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPELCD49_MASK unused
LCD_WF8B_BPELCD49_SHIFT 00000004

Symbol: LCD_WF8B_BPELCD49_SHIFT
   Definitions
      At line 2018 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPELCD49_SHIFT unused
LCD_WF8B_BPELCD4_MASK 00000010

Symbol: LCD_WF8B_BPELCD4_MASK
   Definitions
      At line 2069 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPELCD4_MASK unused
LCD_WF8B_BPELCD4_SHIFT 00000004

Symbol: LCD_WF8B_BPELCD4_SHIFT
   Definitions
      At line 2070 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPELCD4_SHIFT unused
LCD_WF8B_BPELCD50_MASK 00000010

Symbol: LCD_WF8B_BPELCD50_MASK
   Definitions
      At line 2025 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPELCD50_MASK unused
LCD_WF8B_BPELCD50_SHIFT 00000004



ARM Macro Assembler    Page 173 Alphabetic symbol ordering
Absolute symbols


Symbol: LCD_WF8B_BPELCD50_SHIFT
   Definitions
      At line 2026 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPELCD50_SHIFT unused
LCD_WF8B_BPELCD51_MASK 00000010

Symbol: LCD_WF8B_BPELCD51_MASK
   Definitions
      At line 2033 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPELCD51_MASK unused
LCD_WF8B_BPELCD51_SHIFT 00000004

Symbol: LCD_WF8B_BPELCD51_SHIFT
   Definitions
      At line 2034 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPELCD51_SHIFT unused
LCD_WF8B_BPELCD52_MASK 00000010

Symbol: LCD_WF8B_BPELCD52_MASK
   Definitions
      At line 2041 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPELCD52_MASK unused
LCD_WF8B_BPELCD52_SHIFT 00000004

Symbol: LCD_WF8B_BPELCD52_SHIFT
   Definitions
      At line 2042 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPELCD52_SHIFT unused
LCD_WF8B_BPELCD53_MASK 00000010

Symbol: LCD_WF8B_BPELCD53_MASK
   Definitions
      At line 2049 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPELCD53_MASK unused
LCD_WF8B_BPELCD53_SHIFT 00000004

Symbol: LCD_WF8B_BPELCD53_SHIFT
   Definitions
      At line 2050 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPELCD53_SHIFT unused
LCD_WF8B_BPELCD54_MASK 00000010

Symbol: LCD_WF8B_BPELCD54_MASK
   Definitions



ARM Macro Assembler    Page 174 Alphabetic symbol ordering
Absolute symbols

      At line 2061 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPELCD54_MASK unused
LCD_WF8B_BPELCD54_SHIFT 00000004

Symbol: LCD_WF8B_BPELCD54_SHIFT
   Definitions
      At line 2062 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPELCD54_SHIFT unused
LCD_WF8B_BPELCD55_MASK 00000010

Symbol: LCD_WF8B_BPELCD55_MASK
   Definitions
      At line 2067 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPELCD55_MASK unused
LCD_WF8B_BPELCD55_SHIFT 00000004

Symbol: LCD_WF8B_BPELCD55_SHIFT
   Definitions
      At line 2068 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPELCD55_SHIFT unused
LCD_WF8B_BPELCD56_MASK 00000010

Symbol: LCD_WF8B_BPELCD56_MASK
   Definitions
      At line 2037 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPELCD56_MASK unused
LCD_WF8B_BPELCD56_SHIFT 00000004

Symbol: LCD_WF8B_BPELCD56_SHIFT
   Definitions
      At line 2038 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPELCD56_SHIFT unused
LCD_WF8B_BPELCD57_MASK 00000010

Symbol: LCD_WF8B_BPELCD57_MASK
   Definitions
      At line 2039 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPELCD57_MASK unused
LCD_WF8B_BPELCD57_SHIFT 00000004

Symbol: LCD_WF8B_BPELCD57_SHIFT
   Definitions
      At line 2040 in file ..\Exercise
   Uses
      None



ARM Macro Assembler    Page 175 Alphabetic symbol ordering
Absolute symbols

Comment: LCD_WF8B_BPELCD57_SHIFT unused
LCD_WF8B_BPELCD58_MASK 00000010

Symbol: LCD_WF8B_BPELCD58_MASK
   Definitions
      At line 2045 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPELCD58_MASK unused
LCD_WF8B_BPELCD58_SHIFT 00000004

Symbol: LCD_WF8B_BPELCD58_SHIFT
   Definitions
      At line 2046 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPELCD58_SHIFT unused
LCD_WF8B_BPELCD59_MASK 00000010

Symbol: LCD_WF8B_BPELCD59_MASK
   Definitions
      At line 2047 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPELCD59_MASK unused
LCD_WF8B_BPELCD59_SHIFT 00000004

Symbol: LCD_WF8B_BPELCD59_SHIFT
   Definitions
      At line 2048 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPELCD59_SHIFT unused
LCD_WF8B_BPELCD5_MASK 00000010

Symbol: LCD_WF8B_BPELCD5_MASK
   Definitions
      At line 2003 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPELCD5_MASK unused
LCD_WF8B_BPELCD5_SHIFT 00000004

Symbol: LCD_WF8B_BPELCD5_SHIFT
   Definitions
      At line 2004 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPELCD5_SHIFT unused
LCD_WF8B_BPELCD60_MASK 00000010

Symbol: LCD_WF8B_BPELCD60_MASK
   Definitions
      At line 2055 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPELCD60_MASK unused
LCD_WF8B_BPELCD60_SHIFT 00000004




ARM Macro Assembler    Page 176 Alphabetic symbol ordering
Absolute symbols

Symbol: LCD_WF8B_BPELCD60_SHIFT
   Definitions
      At line 2056 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPELCD60_SHIFT unused
LCD_WF8B_BPELCD61_MASK 00000010

Symbol: LCD_WF8B_BPELCD61_MASK
   Definitions
      At line 2059 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPELCD61_MASK unused
LCD_WF8B_BPELCD61_SHIFT 00000004

Symbol: LCD_WF8B_BPELCD61_SHIFT
   Definitions
      At line 2060 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPELCD61_SHIFT unused
LCD_WF8B_BPELCD62_MASK 00000010

Symbol: LCD_WF8B_BPELCD62_MASK
   Definitions
      At line 2063 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPELCD62_MASK unused
LCD_WF8B_BPELCD62_SHIFT 00000004

Symbol: LCD_WF8B_BPELCD62_SHIFT
   Definitions
      At line 2064 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPELCD62_SHIFT unused
LCD_WF8B_BPELCD63_MASK 00000010

Symbol: LCD_WF8B_BPELCD63_MASK
   Definitions
      At line 2065 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPELCD63_MASK unused
LCD_WF8B_BPELCD63_SHIFT 00000004

Symbol: LCD_WF8B_BPELCD63_SHIFT
   Definitions
      At line 2066 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPELCD63_SHIFT unused
LCD_WF8B_BPELCD6_MASK 00000010

Symbol: LCD_WF8B_BPELCD6_MASK
   Definitions
      At line 2029 in file ..\Exercise



ARM Macro Assembler    Page 177 Alphabetic symbol ordering
Absolute symbols

   Uses
      None
Comment: LCD_WF8B_BPELCD6_MASK unused
LCD_WF8B_BPELCD6_SHIFT 00000004

Symbol: LCD_WF8B_BPELCD6_SHIFT
   Definitions
      At line 2030 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPELCD6_SHIFT unused
LCD_WF8B_BPELCD7_MASK 00000010

Symbol: LCD_WF8B_BPELCD7_MASK
   Definitions
      At line 1983 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPELCD7_MASK unused
LCD_WF8B_BPELCD7_SHIFT 00000004

Symbol: LCD_WF8B_BPELCD7_SHIFT
   Definitions
      At line 1984 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPELCD7_SHIFT unused
LCD_WF8B_BPELCD8_MASK 00000010

Symbol: LCD_WF8B_BPELCD8_MASK
   Definitions
      At line 1959 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPELCD8_MASK unused
LCD_WF8B_BPELCD8_SHIFT 00000004

Symbol: LCD_WF8B_BPELCD8_SHIFT
   Definitions
      At line 1960 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPELCD8_SHIFT unused
LCD_WF8B_BPELCD9_MASK 00000010

Symbol: LCD_WF8B_BPELCD9_MASK
   Definitions
      At line 2023 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPELCD9_MASK unused
LCD_WF8B_BPELCD9_SHIFT 00000004

Symbol: LCD_WF8B_BPELCD9_SHIFT
   Definitions
      At line 2024 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPELCD9_SHIFT unused



ARM Macro Assembler    Page 178 Alphabetic symbol ordering
Absolute symbols

LCD_WF8B_BPFLCD0_MASK 00000020

Symbol: LCD_WF8B_BPFLCD0_MASK
   Definitions
      At line 2111 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPFLCD0_MASK unused
LCD_WF8B_BPFLCD0_SHIFT 00000005

Symbol: LCD_WF8B_BPFLCD0_SHIFT
   Definitions
      At line 2112 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPFLCD0_SHIFT unused
LCD_WF8B_BPFLCD10_MASK 00000020

Symbol: LCD_WF8B_BPFLCD10_MASK
   Definitions
      At line 2121 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPFLCD10_MASK unused
LCD_WF8B_BPFLCD10_SHIFT 00000005

Symbol: LCD_WF8B_BPFLCD10_SHIFT
   Definitions
      At line 2122 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPFLCD10_SHIFT unused
LCD_WF8B_BPFLCD11_MASK 00000020

Symbol: LCD_WF8B_BPFLCD11_MASK
   Definitions
      At line 2129 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPFLCD11_MASK unused
LCD_WF8B_BPFLCD11_SHIFT 00000005

Symbol: LCD_WF8B_BPFLCD11_SHIFT
   Definitions
      At line 2130 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPFLCD11_SHIFT unused
LCD_WF8B_BPFLCD12_MASK 00000020

Symbol: LCD_WF8B_BPFLCD12_MASK
   Definitions
      At line 2195 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPFLCD12_MASK unused
LCD_WF8B_BPFLCD12_SHIFT 00000005

Symbol: LCD_WF8B_BPFLCD12_SHIFT



ARM Macro Assembler    Page 179 Alphabetic symbol ordering
Absolute symbols

   Definitions
      At line 2196 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPFLCD12_SHIFT unused
LCD_WF8B_BPFLCD13_MASK 00000020

Symbol: LCD_WF8B_BPFLCD13_MASK
   Definitions
      At line 2071 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPFLCD13_MASK unused
LCD_WF8B_BPFLCD13_SHIFT 00000005

Symbol: LCD_WF8B_BPFLCD13_SHIFT
   Definitions
      At line 2072 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPFLCD13_SHIFT unused
LCD_WF8B_BPFLCD14_MASK 00000020

Symbol: LCD_WF8B_BPFLCD14_MASK
   Definitions
      At line 2087 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPFLCD14_MASK unused
LCD_WF8B_BPFLCD14_SHIFT 00000005

Symbol: LCD_WF8B_BPFLCD14_SHIFT
   Definitions
      At line 2088 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPFLCD14_SHIFT unused
LCD_WF8B_BPFLCD15_MASK 00000020

Symbol: LCD_WF8B_BPFLCD15_MASK
   Definitions
      At line 2093 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPFLCD15_MASK unused
LCD_WF8B_BPFLCD15_SHIFT 00000005

Symbol: LCD_WF8B_BPFLCD15_SHIFT
   Definitions
      At line 2094 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPFLCD15_SHIFT unused
LCD_WF8B_BPFLCD16_MASK 00000020

Symbol: LCD_WF8B_BPFLCD16_MASK
   Definitions
      At line 2141 in file ..\Exercise
   Uses



ARM Macro Assembler    Page 180 Alphabetic symbol ordering
Absolute symbols

      None
Comment: LCD_WF8B_BPFLCD16_MASK unused
LCD_WF8B_BPFLCD16_SHIFT 00000005

Symbol: LCD_WF8B_BPFLCD16_SHIFT
   Definitions
      At line 2142 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPFLCD16_SHIFT unused
LCD_WF8B_BPFLCD17_MASK 00000020

Symbol: LCD_WF8B_BPFLCD17_MASK
   Definitions
      At line 2147 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPFLCD17_MASK unused
LCD_WF8B_BPFLCD17_SHIFT 00000005

Symbol: LCD_WF8B_BPFLCD17_SHIFT
   Definitions
      At line 2148 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPFLCD17_SHIFT unused
LCD_WF8B_BPFLCD18_MASK 00000020

Symbol: LCD_WF8B_BPFLCD18_MASK
   Definitions
      At line 2157 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPFLCD18_MASK unused
LCD_WF8B_BPFLCD18_SHIFT 00000005

Symbol: LCD_WF8B_BPFLCD18_SHIFT
   Definitions
      At line 2158 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPFLCD18_SHIFT unused
LCD_WF8B_BPFLCD19_MASK 00000020

Symbol: LCD_WF8B_BPFLCD19_MASK
   Definitions
      At line 2161 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPFLCD19_MASK unused
LCD_WF8B_BPFLCD19_SHIFT 00000005

Symbol: LCD_WF8B_BPFLCD19_SHIFT
   Definitions
      At line 2162 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPFLCD19_SHIFT unused
LCD_WF8B_BPFLCD1_MASK 00000020



ARM Macro Assembler    Page 181 Alphabetic symbol ordering
Absolute symbols


Symbol: LCD_WF8B_BPFLCD1_MASK
   Definitions
      At line 2133 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPFLCD1_MASK unused
LCD_WF8B_BPFLCD1_SHIFT 00000005

Symbol: LCD_WF8B_BPFLCD1_SHIFT
   Definitions
      At line 2134 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPFLCD1_SHIFT unused
LCD_WF8B_BPFLCD20_MASK 00000020

Symbol: LCD_WF8B_BPFLCD20_MASK
   Definitions
      At line 2173 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPFLCD20_MASK unused
LCD_WF8B_BPFLCD20_SHIFT 00000005

Symbol: LCD_WF8B_BPFLCD20_SHIFT
   Definitions
      At line 2174 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPFLCD20_SHIFT unused
LCD_WF8B_BPFLCD21_MASK 00000020

Symbol: LCD_WF8B_BPFLCD21_MASK
   Definitions
      At line 2179 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPFLCD21_MASK unused
LCD_WF8B_BPFLCD21_SHIFT 00000005

Symbol: LCD_WF8B_BPFLCD21_SHIFT
   Definitions
      At line 2180 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPFLCD21_SHIFT unused
LCD_WF8B_BPFLCD22_MASK 00000020

Symbol: LCD_WF8B_BPFLCD22_MASK
   Definitions
      At line 2191 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPFLCD22_MASK unused
LCD_WF8B_BPFLCD22_SHIFT 00000005

Symbol: LCD_WF8B_BPFLCD22_SHIFT
   Definitions



ARM Macro Assembler    Page 182 Alphabetic symbol ordering
Absolute symbols

      At line 2192 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPFLCD22_SHIFT unused
LCD_WF8B_BPFLCD23_MASK 00000020

Symbol: LCD_WF8B_BPFLCD23_MASK
   Definitions
      At line 2197 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPFLCD23_MASK unused
LCD_WF8B_BPFLCD23_SHIFT 00000005

Symbol: LCD_WF8B_BPFLCD23_SHIFT
   Definitions
      At line 2198 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPFLCD23_SHIFT unused
LCD_WF8B_BPFLCD24_MASK 00000020

Symbol: LCD_WF8B_BPFLCD24_MASK
   Definitions
      At line 2089 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPFLCD24_MASK unused
LCD_WF8B_BPFLCD24_SHIFT 00000005

Symbol: LCD_WF8B_BPFLCD24_SHIFT
   Definitions
      At line 2090 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPFLCD24_SHIFT unused
LCD_WF8B_BPFLCD25_MASK 00000020

Symbol: LCD_WF8B_BPFLCD25_MASK
   Definitions
      At line 2099 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPFLCD25_MASK unused
LCD_WF8B_BPFLCD25_SHIFT 00000005

Symbol: LCD_WF8B_BPFLCD25_SHIFT
   Definitions
      At line 2100 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPFLCD25_SHIFT unused
LCD_WF8B_BPFLCD26_MASK 00000020

Symbol: LCD_WF8B_BPFLCD26_MASK
   Definitions
      At line 2117 in file ..\Exercise
   Uses
      None



ARM Macro Assembler    Page 183 Alphabetic symbol ordering
Absolute symbols

Comment: LCD_WF8B_BPFLCD26_MASK unused
LCD_WF8B_BPFLCD26_SHIFT 00000005

Symbol: LCD_WF8B_BPFLCD26_SHIFT
   Definitions
      At line 2118 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPFLCD26_SHIFT unused
LCD_WF8B_BPFLCD27_MASK 00000020

Symbol: LCD_WF8B_BPFLCD27_MASK
   Definitions
      At line 2127 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPFLCD27_MASK unused
LCD_WF8B_BPFLCD27_SHIFT 00000005

Symbol: LCD_WF8B_BPFLCD27_SHIFT
   Definitions
      At line 2128 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPFLCD27_SHIFT unused
LCD_WF8B_BPFLCD28_MASK 00000020

Symbol: LCD_WF8B_BPFLCD28_MASK
   Definitions
      At line 2149 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPFLCD28_MASK unused
LCD_WF8B_BPFLCD28_SHIFT 00000005

Symbol: LCD_WF8B_BPFLCD28_SHIFT
   Definitions
      At line 2150 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPFLCD28_SHIFT unused
LCD_WF8B_BPFLCD29_MASK 00000020

Symbol: LCD_WF8B_BPFLCD29_MASK
   Definitions
      At line 2153 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPFLCD29_MASK unused
LCD_WF8B_BPFLCD29_SHIFT 00000005

Symbol: LCD_WF8B_BPFLCD29_SHIFT
   Definitions
      At line 2154 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPFLCD29_SHIFT unused
LCD_WF8B_BPFLCD2_MASK 00000020




ARM Macro Assembler    Page 184 Alphabetic symbol ordering
Absolute symbols

Symbol: LCD_WF8B_BPFLCD2_MASK
   Definitions
      At line 2163 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPFLCD2_MASK unused
LCD_WF8B_BPFLCD2_SHIFT 00000005

Symbol: LCD_WF8B_BPFLCD2_SHIFT
   Definitions
      At line 2164 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPFLCD2_SHIFT unused
LCD_WF8B_BPFLCD30_MASK 00000020

Symbol: LCD_WF8B_BPFLCD30_MASK
   Definitions
      At line 2177 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPFLCD30_MASK unused
LCD_WF8B_BPFLCD30_SHIFT 00000005

Symbol: LCD_WF8B_BPFLCD30_SHIFT
   Definitions
      At line 2178 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPFLCD30_SHIFT unused
LCD_WF8B_BPFLCD31_MASK 00000020

Symbol: LCD_WF8B_BPFLCD31_MASK
   Definitions
      At line 2185 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPFLCD31_MASK unused
LCD_WF8B_BPFLCD31_SHIFT 00000005

Symbol: LCD_WF8B_BPFLCD31_SHIFT
   Definitions
      At line 2186 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPFLCD31_SHIFT unused
LCD_WF8B_BPFLCD32_MASK 00000020

Symbol: LCD_WF8B_BPFLCD32_MASK
   Definitions
      At line 2095 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPFLCD32_MASK unused
LCD_WF8B_BPFLCD32_SHIFT 00000005

Symbol: LCD_WF8B_BPFLCD32_SHIFT
   Definitions
      At line 2096 in file ..\Exercise



ARM Macro Assembler    Page 185 Alphabetic symbol ordering
Absolute symbols

   Uses
      None
Comment: LCD_WF8B_BPFLCD32_SHIFT unused
LCD_WF8B_BPFLCD33_MASK 00000020

Symbol: LCD_WF8B_BPFLCD33_MASK
   Definitions
      At line 2105 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPFLCD33_MASK unused
LCD_WF8B_BPFLCD33_SHIFT 00000005

Symbol: LCD_WF8B_BPFLCD33_SHIFT
   Definitions
      At line 2106 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPFLCD33_SHIFT unused
LCD_WF8B_BPFLCD34_MASK 00000020

Symbol: LCD_WF8B_BPFLCD34_MASK
   Definitions
      At line 2159 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPFLCD34_MASK unused
LCD_WF8B_BPFLCD34_SHIFT 00000005

Symbol: LCD_WF8B_BPFLCD34_SHIFT
   Definitions
      At line 2160 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPFLCD34_SHIFT unused
LCD_WF8B_BPFLCD35_MASK 00000020

Symbol: LCD_WF8B_BPFLCD35_MASK
   Definitions
      At line 2181 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPFLCD35_MASK unused
LCD_WF8B_BPFLCD35_SHIFT 00000005

Symbol: LCD_WF8B_BPFLCD35_SHIFT
   Definitions
      At line 2182 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPFLCD35_SHIFT unused
LCD_WF8B_BPFLCD36_MASK 00000020

Symbol: LCD_WF8B_BPFLCD36_MASK
   Definitions
      At line 2119 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPFLCD36_MASK unused



ARM Macro Assembler    Page 186 Alphabetic symbol ordering
Absolute symbols

LCD_WF8B_BPFLCD36_SHIFT 00000005

Symbol: LCD_WF8B_BPFLCD36_SHIFT
   Definitions
      At line 2120 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPFLCD36_SHIFT unused
LCD_WF8B_BPFLCD37_MASK 00000020

Symbol: LCD_WF8B_BPFLCD37_MASK
   Definitions
      At line 2169 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPFLCD37_MASK unused
LCD_WF8B_BPFLCD37_SHIFT 00000005

Symbol: LCD_WF8B_BPFLCD37_SHIFT
   Definitions
      At line 2170 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPFLCD37_SHIFT unused
LCD_WF8B_BPFLCD38_MASK 00000020

Symbol: LCD_WF8B_BPFLCD38_MASK
   Definitions
      At line 2193 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPFLCD38_MASK unused
LCD_WF8B_BPFLCD38_SHIFT 00000005

Symbol: LCD_WF8B_BPFLCD38_SHIFT
   Definitions
      At line 2194 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPFLCD38_SHIFT unused
LCD_WF8B_BPFLCD39_MASK 00000020

Symbol: LCD_WF8B_BPFLCD39_MASK
   Definitions
      At line 2073 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPFLCD39_MASK unused
LCD_WF8B_BPFLCD39_SHIFT 00000005

Symbol: LCD_WF8B_BPFLCD39_SHIFT
   Definitions
      At line 2074 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPFLCD39_SHIFT unused
LCD_WF8B_BPFLCD3_MASK 00000020

Symbol: LCD_WF8B_BPFLCD3_MASK



ARM Macro Assembler    Page 187 Alphabetic symbol ordering
Absolute symbols

   Definitions
      At line 2167 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPFLCD3_MASK unused
LCD_WF8B_BPFLCD3_SHIFT 00000005

Symbol: LCD_WF8B_BPFLCD3_SHIFT
   Definitions
      At line 2168 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPFLCD3_SHIFT unused
LCD_WF8B_BPFLCD40_MASK 00000020

Symbol: LCD_WF8B_BPFLCD40_MASK
   Definitions
      At line 2137 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPFLCD40_MASK unused
LCD_WF8B_BPFLCD40_SHIFT 00000005

Symbol: LCD_WF8B_BPFLCD40_SHIFT
   Definitions
      At line 2138 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPFLCD40_SHIFT unused
LCD_WF8B_BPFLCD41_MASK 00000020

Symbol: LCD_WF8B_BPFLCD41_MASK
   Definitions
      At line 2103 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPFLCD41_MASK unused
LCD_WF8B_BPFLCD41_SHIFT 00000005

Symbol: LCD_WF8B_BPFLCD41_SHIFT
   Definitions
      At line 2104 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPFLCD41_SHIFT unused
LCD_WF8B_BPFLCD42_MASK 00000020

Symbol: LCD_WF8B_BPFLCD42_MASK
   Definitions
      At line 2151 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPFLCD42_MASK unused
LCD_WF8B_BPFLCD42_SHIFT 00000005

Symbol: LCD_WF8B_BPFLCD42_SHIFT
   Definitions
      At line 2152 in file ..\Exercise
   Uses



ARM Macro Assembler    Page 188 Alphabetic symbol ordering
Absolute symbols

      None
Comment: LCD_WF8B_BPFLCD42_SHIFT unused
LCD_WF8B_BPFLCD43_MASK 00000020

Symbol: LCD_WF8B_BPFLCD43_MASK
   Definitions
      At line 2081 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPFLCD43_MASK unused
LCD_WF8B_BPFLCD43_SHIFT 00000005

Symbol: LCD_WF8B_BPFLCD43_SHIFT
   Definitions
      At line 2082 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPFLCD43_SHIFT unused
LCD_WF8B_BPFLCD44_MASK 00000020

Symbol: LCD_WF8B_BPFLCD44_MASK
   Definitions
      At line 2175 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPFLCD44_MASK unused
LCD_WF8B_BPFLCD44_SHIFT 00000005

Symbol: LCD_WF8B_BPFLCD44_SHIFT
   Definitions
      At line 2176 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPFLCD44_SHIFT unused
LCD_WF8B_BPFLCD45_MASK 00000020

Symbol: LCD_WF8B_BPFLCD45_MASK
   Definitions
      At line 2143 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPFLCD45_MASK unused
LCD_WF8B_BPFLCD45_SHIFT 00000005

Symbol: LCD_WF8B_BPFLCD45_SHIFT
   Definitions
      At line 2144 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPFLCD45_SHIFT unused
LCD_WF8B_BPFLCD46_MASK 00000020

Symbol: LCD_WF8B_BPFLCD46_MASK
   Definitions
      At line 2113 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPFLCD46_MASK unused
LCD_WF8B_BPFLCD46_SHIFT 00000005



ARM Macro Assembler    Page 189 Alphabetic symbol ordering
Absolute symbols


Symbol: LCD_WF8B_BPFLCD46_SHIFT
   Definitions
      At line 2114 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPFLCD46_SHIFT unused
LCD_WF8B_BPFLCD47_MASK 00000020

Symbol: LCD_WF8B_BPFLCD47_MASK
   Definitions
      At line 2077 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPFLCD47_MASK unused
LCD_WF8B_BPFLCD47_SHIFT 00000005

Symbol: LCD_WF8B_BPFLCD47_SHIFT
   Definitions
      At line 2078 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPFLCD47_SHIFT unused
LCD_WF8B_BPFLCD48_MASK 00000020

Symbol: LCD_WF8B_BPFLCD48_MASK
   Definitions
      At line 2187 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPFLCD48_MASK unused
LCD_WF8B_BPFLCD48_SHIFT 00000005

Symbol: LCD_WF8B_BPFLCD48_SHIFT
   Definitions
      At line 2188 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPFLCD48_SHIFT unused
LCD_WF8B_BPFLCD49_MASK 00000020

Symbol: LCD_WF8B_BPFLCD49_MASK
   Definitions
      At line 2171 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPFLCD49_MASK unused
LCD_WF8B_BPFLCD49_SHIFT 00000005

Symbol: LCD_WF8B_BPFLCD49_SHIFT
   Definitions
      At line 2172 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPFLCD49_SHIFT unused
LCD_WF8B_BPFLCD4_MASK 00000020

Symbol: LCD_WF8B_BPFLCD4_MASK
   Definitions



ARM Macro Assembler    Page 190 Alphabetic symbol ordering
Absolute symbols

      At line 2183 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPFLCD4_MASK unused
LCD_WF8B_BPFLCD4_SHIFT 00000005

Symbol: LCD_WF8B_BPFLCD4_SHIFT
   Definitions
      At line 2184 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPFLCD4_SHIFT unused
LCD_WF8B_BPFLCD50_MASK 00000020

Symbol: LCD_WF8B_BPFLCD50_MASK
   Definitions
      At line 2155 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPFLCD50_MASK unused
LCD_WF8B_BPFLCD50_SHIFT 00000005

Symbol: LCD_WF8B_BPFLCD50_SHIFT
   Definitions
      At line 2156 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPFLCD50_SHIFT unused
LCD_WF8B_BPFLCD51_MASK 00000020

Symbol: LCD_WF8B_BPFLCD51_MASK
   Definitions
      At line 2139 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPFLCD51_MASK unused
LCD_WF8B_BPFLCD51_SHIFT 00000005

Symbol: LCD_WF8B_BPFLCD51_SHIFT
   Definitions
      At line 2140 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPFLCD51_SHIFT unused
LCD_WF8B_BPFLCD52_MASK 00000020

Symbol: LCD_WF8B_BPFLCD52_MASK
   Definitions
      At line 2123 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPFLCD52_MASK unused
LCD_WF8B_BPFLCD52_SHIFT 00000005

Symbol: LCD_WF8B_BPFLCD52_SHIFT
   Definitions
      At line 2124 in file ..\Exercise
   Uses
      None



ARM Macro Assembler    Page 191 Alphabetic symbol ordering
Absolute symbols

Comment: LCD_WF8B_BPFLCD52_SHIFT unused
LCD_WF8B_BPFLCD53_MASK 00000020

Symbol: LCD_WF8B_BPFLCD53_MASK
   Definitions
      At line 2107 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPFLCD53_MASK unused
LCD_WF8B_BPFLCD53_SHIFT 00000005

Symbol: LCD_WF8B_BPFLCD53_SHIFT
   Definitions
      At line 2108 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPFLCD53_SHIFT unused
LCD_WF8B_BPFLCD54_MASK 00000020

Symbol: LCD_WF8B_BPFLCD54_MASK
   Definitions
      At line 2091 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPFLCD54_MASK unused
LCD_WF8B_BPFLCD54_SHIFT 00000005

Symbol: LCD_WF8B_BPFLCD54_SHIFT
   Definitions
      At line 2092 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPFLCD54_SHIFT unused
LCD_WF8B_BPFLCD55_MASK 00000020

Symbol: LCD_WF8B_BPFLCD55_MASK
   Definitions
      At line 2075 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPFLCD55_MASK unused
LCD_WF8B_BPFLCD55_SHIFT 00000005

Symbol: LCD_WF8B_BPFLCD55_SHIFT
   Definitions
      At line 2076 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPFLCD55_SHIFT unused
LCD_WF8B_BPFLCD56_MASK 00000020

Symbol: LCD_WF8B_BPFLCD56_MASK
   Definitions
      At line 2131 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPFLCD56_MASK unused
LCD_WF8B_BPFLCD56_SHIFT 00000005




ARM Macro Assembler    Page 192 Alphabetic symbol ordering
Absolute symbols

Symbol: LCD_WF8B_BPFLCD56_SHIFT
   Definitions
      At line 2132 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPFLCD56_SHIFT unused
LCD_WF8B_BPFLCD57_MASK 00000020

Symbol: LCD_WF8B_BPFLCD57_MASK
   Definitions
      At line 2125 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPFLCD57_MASK unused
LCD_WF8B_BPFLCD57_SHIFT 00000005

Symbol: LCD_WF8B_BPFLCD57_SHIFT
   Definitions
      At line 2126 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPFLCD57_SHIFT unused
LCD_WF8B_BPFLCD58_MASK 00000020

Symbol: LCD_WF8B_BPFLCD58_MASK
   Definitions
      At line 2115 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPFLCD58_MASK unused
LCD_WF8B_BPFLCD58_SHIFT 00000005

Symbol: LCD_WF8B_BPFLCD58_SHIFT
   Definitions
      At line 2116 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPFLCD58_SHIFT unused
LCD_WF8B_BPFLCD59_MASK 00000020

Symbol: LCD_WF8B_BPFLCD59_MASK
   Definitions
      At line 2109 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPFLCD59_MASK unused
LCD_WF8B_BPFLCD59_SHIFT 00000005

Symbol: LCD_WF8B_BPFLCD59_SHIFT
   Definitions
      At line 2110 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPFLCD59_SHIFT unused
LCD_WF8B_BPFLCD5_MASK 00000020

Symbol: LCD_WF8B_BPFLCD5_MASK
   Definitions
      At line 2083 in file ..\Exercise



ARM Macro Assembler    Page 193 Alphabetic symbol ordering
Absolute symbols

   Uses
      None
Comment: LCD_WF8B_BPFLCD5_MASK unused
LCD_WF8B_BPFLCD5_SHIFT 00000005

Symbol: LCD_WF8B_BPFLCD5_SHIFT
   Definitions
      At line 2084 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPFLCD5_SHIFT unused
LCD_WF8B_BPFLCD60_MASK 00000020

Symbol: LCD_WF8B_BPFLCD60_MASK
   Definitions
      At line 2101 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPFLCD60_MASK unused
LCD_WF8B_BPFLCD60_SHIFT 00000005

Symbol: LCD_WF8B_BPFLCD60_SHIFT
   Definitions
      At line 2102 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPFLCD60_SHIFT unused
LCD_WF8B_BPFLCD61_MASK 00000020

Symbol: LCD_WF8B_BPFLCD61_MASK
   Definitions
      At line 2097 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPFLCD61_MASK unused
LCD_WF8B_BPFLCD61_SHIFT 00000005

Symbol: LCD_WF8B_BPFLCD61_SHIFT
   Definitions
      At line 2098 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPFLCD61_SHIFT unused
LCD_WF8B_BPFLCD62_MASK 00000020

Symbol: LCD_WF8B_BPFLCD62_MASK
   Definitions
      At line 2085 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPFLCD62_MASK unused
LCD_WF8B_BPFLCD62_SHIFT 00000005

Symbol: LCD_WF8B_BPFLCD62_SHIFT
   Definitions
      At line 2086 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPFLCD62_SHIFT unused



ARM Macro Assembler    Page 194 Alphabetic symbol ordering
Absolute symbols

LCD_WF8B_BPFLCD63_MASK 00000020

Symbol: LCD_WF8B_BPFLCD63_MASK
   Definitions
      At line 2079 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPFLCD63_MASK unused
LCD_WF8B_BPFLCD63_SHIFT 00000005

Symbol: LCD_WF8B_BPFLCD63_SHIFT
   Definitions
      At line 2080 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPFLCD63_SHIFT unused
LCD_WF8B_BPFLCD6_MASK 00000020

Symbol: LCD_WF8B_BPFLCD6_MASK
   Definitions
      At line 2145 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPFLCD6_MASK unused
LCD_WF8B_BPFLCD6_SHIFT 00000005

Symbol: LCD_WF8B_BPFLCD6_SHIFT
   Definitions
      At line 2146 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPFLCD6_SHIFT unused
LCD_WF8B_BPFLCD7_MASK 00000020

Symbol: LCD_WF8B_BPFLCD7_MASK
   Definitions
      At line 2189 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPFLCD7_MASK unused
LCD_WF8B_BPFLCD7_SHIFT 00000005

Symbol: LCD_WF8B_BPFLCD7_SHIFT
   Definitions
      At line 2190 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPFLCD7_SHIFT unused
LCD_WF8B_BPFLCD8_MASK 00000020

Symbol: LCD_WF8B_BPFLCD8_MASK
   Definitions
      At line 2135 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPFLCD8_MASK unused
LCD_WF8B_BPFLCD8_SHIFT 00000005

Symbol: LCD_WF8B_BPFLCD8_SHIFT



ARM Macro Assembler    Page 195 Alphabetic symbol ordering
Absolute symbols

   Definitions
      At line 2136 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPFLCD8_SHIFT unused
LCD_WF8B_BPFLCD9_MASK 00000020

Symbol: LCD_WF8B_BPFLCD9_MASK
   Definitions
      At line 2165 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPFLCD9_MASK unused
LCD_WF8B_BPFLCD9_SHIFT 00000005

Symbol: LCD_WF8B_BPFLCD9_SHIFT
   Definitions
      At line 2166 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPFLCD9_SHIFT unused
LCD_WF8B_BPGLCD0_MASK 00000040

Symbol: LCD_WF8B_BPGLCD0_MASK
   Definitions
      At line 2221 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPGLCD0_MASK unused
LCD_WF8B_BPGLCD0_SHIFT 00000006

Symbol: LCD_WF8B_BPGLCD0_SHIFT
   Definitions
      At line 2222 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPGLCD0_SHIFT unused
LCD_WF8B_BPGLCD10_MASK 00000040

Symbol: LCD_WF8B_BPGLCD10_MASK
   Definitions
      At line 2279 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPGLCD10_MASK unused
LCD_WF8B_BPGLCD10_SHIFT 00000006

Symbol: LCD_WF8B_BPGLCD10_SHIFT
   Definitions
      At line 2280 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPGLCD10_SHIFT unused
LCD_WF8B_BPGLCD11_MASK 00000040

Symbol: LCD_WF8B_BPGLCD11_MASK
   Definitions
      At line 2307 in file ..\Exercise
   Uses



ARM Macro Assembler    Page 196 Alphabetic symbol ordering
Absolute symbols

      None
Comment: LCD_WF8B_BPGLCD11_MASK unused
LCD_WF8B_BPGLCD11_SHIFT 00000006

Symbol: LCD_WF8B_BPGLCD11_SHIFT
   Definitions
      At line 2308 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPGLCD11_SHIFT unused
LCD_WF8B_BPGLCD12_MASK 00000040

Symbol: LCD_WF8B_BPGLCD12_MASK
   Definitions
      At line 2311 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPGLCD12_MASK unused
LCD_WF8B_BPGLCD12_SHIFT 00000006

Symbol: LCD_WF8B_BPGLCD12_SHIFT
   Definitions
      At line 2312 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPGLCD12_SHIFT unused
LCD_WF8B_BPGLCD13_MASK 00000040

Symbol: LCD_WF8B_BPGLCD13_MASK
   Definitions
      At line 2257 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPGLCD13_MASK unused
LCD_WF8B_BPGLCD13_SHIFT 00000006

Symbol: LCD_WF8B_BPGLCD13_SHIFT
   Definitions
      At line 2258 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPGLCD13_SHIFT unused
LCD_WF8B_BPGLCD14_MASK 00000040

Symbol: LCD_WF8B_BPGLCD14_MASK
   Definitions
      At line 2199 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPGLCD14_MASK unused
LCD_WF8B_BPGLCD14_SHIFT 00000006

Symbol: LCD_WF8B_BPGLCD14_SHIFT
   Definitions
      At line 2200 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPGLCD14_SHIFT unused
LCD_WF8B_BPGLCD15_MASK 00000040



ARM Macro Assembler    Page 197 Alphabetic symbol ordering
Absolute symbols


Symbol: LCD_WF8B_BPGLCD15_MASK
   Definitions
      At line 2205 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPGLCD15_MASK unused
LCD_WF8B_BPGLCD15_SHIFT 00000006

Symbol: LCD_WF8B_BPGLCD15_SHIFT
   Definitions
      At line 2206 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPGLCD15_SHIFT unused
LCD_WF8B_BPGLCD16_MASK 00000040

Symbol: LCD_WF8B_BPGLCD16_MASK
   Definitions
      At line 2235 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPGLCD16_MASK unused
LCD_WF8B_BPGLCD16_SHIFT 00000006

Symbol: LCD_WF8B_BPGLCD16_SHIFT
   Definitions
      At line 2236 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPGLCD16_SHIFT unused
LCD_WF8B_BPGLCD17_MASK 00000040

Symbol: LCD_WF8B_BPGLCD17_MASK
   Definitions
      At line 2239 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPGLCD17_MASK unused
LCD_WF8B_BPGLCD17_SHIFT 00000006

Symbol: LCD_WF8B_BPGLCD17_SHIFT
   Definitions
      At line 2240 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPGLCD17_SHIFT unused
LCD_WF8B_BPGLCD18_MASK 00000040

Symbol: LCD_WF8B_BPGLCD18_MASK
   Definitions
      At line 2243 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPGLCD18_MASK unused
LCD_WF8B_BPGLCD18_SHIFT 00000006

Symbol: LCD_WF8B_BPGLCD18_SHIFT
   Definitions



ARM Macro Assembler    Page 198 Alphabetic symbol ordering
Absolute symbols

      At line 2244 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPGLCD18_SHIFT unused
LCD_WF8B_BPGLCD19_MASK 00000040

Symbol: LCD_WF8B_BPGLCD19_MASK
   Definitions
      At line 2245 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPGLCD19_MASK unused
LCD_WF8B_BPGLCD19_SHIFT 00000006

Symbol: LCD_WF8B_BPGLCD19_SHIFT
   Definitions
      At line 2246 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPGLCD19_SHIFT unused
LCD_WF8B_BPGLCD1_MASK 00000040

Symbol: LCD_WF8B_BPGLCD1_MASK
   Definitions
      At line 2237 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPGLCD1_MASK unused
LCD_WF8B_BPGLCD1_SHIFT 00000006

Symbol: LCD_WF8B_BPGLCD1_SHIFT
   Definitions
      At line 2238 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPGLCD1_SHIFT unused
LCD_WF8B_BPGLCD20_MASK 00000040

Symbol: LCD_WF8B_BPGLCD20_MASK
   Definitions
      At line 2251 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPGLCD20_MASK unused
LCD_WF8B_BPGLCD20_SHIFT 00000006

Symbol: LCD_WF8B_BPGLCD20_SHIFT
   Definitions
      At line 2252 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPGLCD20_SHIFT unused
LCD_WF8B_BPGLCD21_MASK 00000040

Symbol: LCD_WF8B_BPGLCD21_MASK
   Definitions
      At line 2255 in file ..\Exercise
   Uses
      None



ARM Macro Assembler    Page 199 Alphabetic symbol ordering
Absolute symbols

Comment: LCD_WF8B_BPGLCD21_MASK unused
LCD_WF8B_BPGLCD21_SHIFT 00000006

Symbol: LCD_WF8B_BPGLCD21_SHIFT
   Definitions
      At line 2256 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPGLCD21_SHIFT unused
LCD_WF8B_BPGLCD22_MASK 00000040

Symbol: LCD_WF8B_BPGLCD22_MASK
   Definitions
      At line 2261 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPGLCD22_MASK unused
LCD_WF8B_BPGLCD22_SHIFT 00000006

Symbol: LCD_WF8B_BPGLCD22_SHIFT
   Definitions
      At line 2262 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPGLCD22_SHIFT unused
LCD_WF8B_BPGLCD23_MASK 00000040

Symbol: LCD_WF8B_BPGLCD23_MASK
   Definitions
      At line 2267 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPGLCD23_MASK unused
LCD_WF8B_BPGLCD23_SHIFT 00000006

Symbol: LCD_WF8B_BPGLCD23_SHIFT
   Definitions
      At line 2268 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPGLCD23_SHIFT unused
LCD_WF8B_BPGLCD24_MASK 00000040

Symbol: LCD_WF8B_BPGLCD24_MASK
   Definitions
      At line 2269 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPGLCD24_MASK unused
LCD_WF8B_BPGLCD24_SHIFT 00000006

Symbol: LCD_WF8B_BPGLCD24_SHIFT
   Definitions
      At line 2270 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPGLCD24_SHIFT unused
LCD_WF8B_BPGLCD25_MASK 00000040




ARM Macro Assembler    Page 200 Alphabetic symbol ordering
Absolute symbols

Symbol: LCD_WF8B_BPGLCD25_MASK
   Definitions
      At line 2271 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPGLCD25_MASK unused
LCD_WF8B_BPGLCD25_SHIFT 00000006

Symbol: LCD_WF8B_BPGLCD25_SHIFT
   Definitions
      At line 2272 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPGLCD25_SHIFT unused
LCD_WF8B_BPGLCD26_MASK 00000040

Symbol: LCD_WF8B_BPGLCD26_MASK
   Definitions
      At line 2275 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPGLCD26_MASK unused
LCD_WF8B_BPGLCD26_SHIFT 00000006

Symbol: LCD_WF8B_BPGLCD26_SHIFT
   Definitions
      At line 2276 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPGLCD26_SHIFT unused
LCD_WF8B_BPGLCD27_MASK 00000040

Symbol: LCD_WF8B_BPGLCD27_MASK
   Definitions
      At line 2277 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPGLCD27_MASK unused
LCD_WF8B_BPGLCD27_SHIFT 00000006

Symbol: LCD_WF8B_BPGLCD27_SHIFT
   Definitions
      At line 2278 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPGLCD27_SHIFT unused
LCD_WF8B_BPGLCD28_MASK 00000040

Symbol: LCD_WF8B_BPGLCD28_MASK
   Definitions
      At line 2283 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPGLCD28_MASK unused
LCD_WF8B_BPGLCD28_SHIFT 00000006

Symbol: LCD_WF8B_BPGLCD28_SHIFT
   Definitions
      At line 2284 in file ..\Exercise



ARM Macro Assembler    Page 201 Alphabetic symbol ordering
Absolute symbols

   Uses
      None
Comment: LCD_WF8B_BPGLCD28_SHIFT unused
LCD_WF8B_BPGLCD29_MASK 00000040

Symbol: LCD_WF8B_BPGLCD29_MASK
   Definitions
      At line 2285 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPGLCD29_MASK unused
LCD_WF8B_BPGLCD29_SHIFT 00000006

Symbol: LCD_WF8B_BPGLCD29_SHIFT
   Definitions
      At line 2286 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPGLCD29_SHIFT unused
LCD_WF8B_BPGLCD2_MASK 00000040

Symbol: LCD_WF8B_BPGLCD2_MASK
   Definitions
      At line 2293 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPGLCD2_MASK unused
LCD_WF8B_BPGLCD2_SHIFT 00000006

Symbol: LCD_WF8B_BPGLCD2_SHIFT
   Definitions
      At line 2294 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPGLCD2_SHIFT unused
LCD_WF8B_BPGLCD30_MASK 00000040

Symbol: LCD_WF8B_BPGLCD30_MASK
   Definitions
      At line 2291 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPGLCD30_MASK unused
LCD_WF8B_BPGLCD30_SHIFT 00000006

Symbol: LCD_WF8B_BPGLCD30_SHIFT
   Definitions
      At line 2292 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPGLCD30_SHIFT unused
LCD_WF8B_BPGLCD31_MASK 00000040

Symbol: LCD_WF8B_BPGLCD31_MASK
   Definitions
      At line 2295 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPGLCD31_MASK unused



ARM Macro Assembler    Page 202 Alphabetic symbol ordering
Absolute symbols

LCD_WF8B_BPGLCD31_SHIFT 00000006

Symbol: LCD_WF8B_BPGLCD31_SHIFT
   Definitions
      At line 2296 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPGLCD31_SHIFT unused
LCD_WF8B_BPGLCD32_MASK 00000040

Symbol: LCD_WF8B_BPGLCD32_MASK
   Definitions
      At line 2299 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPGLCD32_MASK unused
LCD_WF8B_BPGLCD32_SHIFT 00000006

Symbol: LCD_WF8B_BPGLCD32_SHIFT
   Definitions
      At line 2300 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPGLCD32_SHIFT unused
LCD_WF8B_BPGLCD33_MASK 00000040

Symbol: LCD_WF8B_BPGLCD33_MASK
   Definitions
      At line 2301 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPGLCD33_MASK unused
LCD_WF8B_BPGLCD33_SHIFT 00000006

Symbol: LCD_WF8B_BPGLCD33_SHIFT
   Definitions
      At line 2302 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPGLCD33_SHIFT unused
LCD_WF8B_BPGLCD34_MASK 00000040

Symbol: LCD_WF8B_BPGLCD34_MASK
   Definitions
      At line 2305 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPGLCD34_MASK unused
LCD_WF8B_BPGLCD34_SHIFT 00000006

Symbol: LCD_WF8B_BPGLCD34_SHIFT
   Definitions
      At line 2306 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPGLCD34_SHIFT unused
LCD_WF8B_BPGLCD35_MASK 00000040

Symbol: LCD_WF8B_BPGLCD35_MASK



ARM Macro Assembler    Page 203 Alphabetic symbol ordering
Absolute symbols

   Definitions
      At line 2309 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPGLCD35_MASK unused
LCD_WF8B_BPGLCD35_SHIFT 00000006

Symbol: LCD_WF8B_BPGLCD35_SHIFT
   Definitions
      At line 2310 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPGLCD35_SHIFT unused
LCD_WF8B_BPGLCD36_MASK 00000040

Symbol: LCD_WF8B_BPGLCD36_MASK
   Definitions
      At line 2315 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPGLCD36_MASK unused
LCD_WF8B_BPGLCD36_SHIFT 00000006

Symbol: LCD_WF8B_BPGLCD36_SHIFT
   Definitions
      At line 2316 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPGLCD36_SHIFT unused
LCD_WF8B_BPGLCD37_MASK 00000040

Symbol: LCD_WF8B_BPGLCD37_MASK
   Definitions
      At line 2319 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPGLCD37_MASK unused
LCD_WF8B_BPGLCD37_SHIFT 00000006

Symbol: LCD_WF8B_BPGLCD37_SHIFT
   Definitions
      At line 2320 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPGLCD37_SHIFT unused
LCD_WF8B_BPGLCD38_MASK 00000040

Symbol: LCD_WF8B_BPGLCD38_MASK
   Definitions
      At line 2323 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPGLCD38_MASK unused
LCD_WF8B_BPGLCD38_SHIFT 00000006

Symbol: LCD_WF8B_BPGLCD38_SHIFT
   Definitions
      At line 2324 in file ..\Exercise
   Uses



ARM Macro Assembler    Page 204 Alphabetic symbol ordering
Absolute symbols

      None
Comment: LCD_WF8B_BPGLCD38_SHIFT unused
LCD_WF8B_BPGLCD39_MASK 00000040

Symbol: LCD_WF8B_BPGLCD39_MASK
   Definitions
      At line 2325 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPGLCD39_MASK unused
LCD_WF8B_BPGLCD39_SHIFT 00000006

Symbol: LCD_WF8B_BPGLCD39_SHIFT
   Definitions
      At line 2326 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPGLCD39_SHIFT unused
LCD_WF8B_BPGLCD3_MASK 00000040

Symbol: LCD_WF8B_BPGLCD3_MASK
   Definitions
      At line 2317 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPGLCD3_MASK unused
LCD_WF8B_BPGLCD3_SHIFT 00000006

Symbol: LCD_WF8B_BPGLCD3_SHIFT
   Definitions
      At line 2318 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPGLCD3_SHIFT unused
LCD_WF8B_BPGLCD40_MASK 00000040

Symbol: LCD_WF8B_BPGLCD40_MASK
   Definitions
      At line 2321 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPGLCD40_MASK unused
LCD_WF8B_BPGLCD40_SHIFT 00000006

Symbol: LCD_WF8B_BPGLCD40_SHIFT
   Definitions
      At line 2322 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPGLCD40_SHIFT unused
LCD_WF8B_BPGLCD41_MASK 00000040

Symbol: LCD_WF8B_BPGLCD41_MASK
   Definitions
      At line 2313 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPGLCD41_MASK unused
LCD_WF8B_BPGLCD41_SHIFT 00000006



ARM Macro Assembler    Page 205 Alphabetic symbol ordering
Absolute symbols


Symbol: LCD_WF8B_BPGLCD41_SHIFT
   Definitions
      At line 2314 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPGLCD41_SHIFT unused
LCD_WF8B_BPGLCD42_MASK 00000040

Symbol: LCD_WF8B_BPGLCD42_MASK
   Definitions
      At line 2303 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPGLCD42_MASK unused
LCD_WF8B_BPGLCD42_SHIFT 00000006

Symbol: LCD_WF8B_BPGLCD42_SHIFT
   Definitions
      At line 2304 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPGLCD42_SHIFT unused
LCD_WF8B_BPGLCD43_MASK 00000040

Symbol: LCD_WF8B_BPGLCD43_MASK
   Definitions
      At line 2297 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPGLCD43_MASK unused
LCD_WF8B_BPGLCD43_SHIFT 00000006

Symbol: LCD_WF8B_BPGLCD43_SHIFT
   Definitions
      At line 2298 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPGLCD43_SHIFT unused
LCD_WF8B_BPGLCD44_MASK 00000040

Symbol: LCD_WF8B_BPGLCD44_MASK
   Definitions
      At line 2289 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPGLCD44_MASK unused
LCD_WF8B_BPGLCD44_SHIFT 00000006

Symbol: LCD_WF8B_BPGLCD44_SHIFT
   Definitions
      At line 2290 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPGLCD44_SHIFT unused
LCD_WF8B_BPGLCD45_MASK 00000040

Symbol: LCD_WF8B_BPGLCD45_MASK
   Definitions



ARM Macro Assembler    Page 206 Alphabetic symbol ordering
Absolute symbols

      At line 2281 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPGLCD45_MASK unused
LCD_WF8B_BPGLCD45_SHIFT 00000006

Symbol: LCD_WF8B_BPGLCD45_SHIFT
   Definitions
      At line 2282 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPGLCD45_SHIFT unused
LCD_WF8B_BPGLCD46_MASK 00000040

Symbol: LCD_WF8B_BPGLCD46_MASK
   Definitions
      At line 2273 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPGLCD46_MASK unused
LCD_WF8B_BPGLCD46_SHIFT 00000006

Symbol: LCD_WF8B_BPGLCD46_SHIFT
   Definitions
      At line 2274 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPGLCD46_SHIFT unused
LCD_WF8B_BPGLCD47_MASK 00000040

Symbol: LCD_WF8B_BPGLCD47_MASK
   Definitions
      At line 2265 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPGLCD47_MASK unused
LCD_WF8B_BPGLCD47_SHIFT 00000006

Symbol: LCD_WF8B_BPGLCD47_SHIFT
   Definitions
      At line 2266 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPGLCD47_SHIFT unused
LCD_WF8B_BPGLCD48_MASK 00000040

Symbol: LCD_WF8B_BPGLCD48_MASK
   Definitions
      At line 2259 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPGLCD48_MASK unused
LCD_WF8B_BPGLCD48_SHIFT 00000006

Symbol: LCD_WF8B_BPGLCD48_SHIFT
   Definitions
      At line 2260 in file ..\Exercise
   Uses
      None



ARM Macro Assembler    Page 207 Alphabetic symbol ordering
Absolute symbols

Comment: LCD_WF8B_BPGLCD48_SHIFT unused
LCD_WF8B_BPGLCD49_MASK 00000040

Symbol: LCD_WF8B_BPGLCD49_MASK
   Definitions
      At line 2249 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPGLCD49_MASK unused
LCD_WF8B_BPGLCD49_SHIFT 00000006

Symbol: LCD_WF8B_BPGLCD49_SHIFT
   Definitions
      At line 2250 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPGLCD49_SHIFT unused
LCD_WF8B_BPGLCD4_MASK 00000040

Symbol: LCD_WF8B_BPGLCD4_MASK
   Definitions
      At line 2287 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPGLCD4_MASK unused
LCD_WF8B_BPGLCD4_SHIFT 00000006

Symbol: LCD_WF8B_BPGLCD4_SHIFT
   Definitions
      At line 2288 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPGLCD4_SHIFT unused
LCD_WF8B_BPGLCD50_MASK 00000040

Symbol: LCD_WF8B_BPGLCD50_MASK
   Definitions
      At line 2241 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPGLCD50_MASK unused
LCD_WF8B_BPGLCD50_SHIFT 00000006

Symbol: LCD_WF8B_BPGLCD50_SHIFT
   Definitions
      At line 2242 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPGLCD50_SHIFT unused
LCD_WF8B_BPGLCD51_MASK 00000040

Symbol: LCD_WF8B_BPGLCD51_MASK
   Definitions
      At line 2233 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPGLCD51_MASK unused
LCD_WF8B_BPGLCD51_SHIFT 00000006




ARM Macro Assembler    Page 208 Alphabetic symbol ordering
Absolute symbols

Symbol: LCD_WF8B_BPGLCD51_SHIFT
   Definitions
      At line 2234 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPGLCD51_SHIFT unused
LCD_WF8B_BPGLCD52_MASK 00000040

Symbol: LCD_WF8B_BPGLCD52_MASK
   Definitions
      At line 2225 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPGLCD52_MASK unused
LCD_WF8B_BPGLCD52_SHIFT 00000006

Symbol: LCD_WF8B_BPGLCD52_SHIFT
   Definitions
      At line 2226 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPGLCD52_SHIFT unused
LCD_WF8B_BPGLCD53_MASK 00000040

Symbol: LCD_WF8B_BPGLCD53_MASK
   Definitions
      At line 2217 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPGLCD53_MASK unused
LCD_WF8B_BPGLCD53_SHIFT 00000006

Symbol: LCD_WF8B_BPGLCD53_SHIFT
   Definitions
      At line 2218 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPGLCD53_SHIFT unused
LCD_WF8B_BPGLCD54_MASK 00000040

Symbol: LCD_WF8B_BPGLCD54_MASK
   Definitions
      At line 2209 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPGLCD54_MASK unused
LCD_WF8B_BPGLCD54_SHIFT 00000006

Symbol: LCD_WF8B_BPGLCD54_SHIFT
   Definitions
      At line 2210 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPGLCD54_SHIFT unused
LCD_WF8B_BPGLCD55_MASK 00000040

Symbol: LCD_WF8B_BPGLCD55_MASK
   Definitions
      At line 2201 in file ..\Exercise



ARM Macro Assembler    Page 209 Alphabetic symbol ordering
Absolute symbols

   Uses
      None
Comment: LCD_WF8B_BPGLCD55_MASK unused
LCD_WF8B_BPGLCD55_SHIFT 00000006

Symbol: LCD_WF8B_BPGLCD55_SHIFT
   Definitions
      At line 2202 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPGLCD55_SHIFT unused
LCD_WF8B_BPGLCD56_MASK 00000040

Symbol: LCD_WF8B_BPGLCD56_MASK
   Definitions
      At line 2229 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPGLCD56_MASK unused
LCD_WF8B_BPGLCD56_SHIFT 00000006

Symbol: LCD_WF8B_BPGLCD56_SHIFT
   Definitions
      At line 2230 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPGLCD56_SHIFT unused
LCD_WF8B_BPGLCD57_MASK 00000040

Symbol: LCD_WF8B_BPGLCD57_MASK
   Definitions
      At line 2223 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPGLCD57_MASK unused
LCD_WF8B_BPGLCD57_SHIFT 00000006

Symbol: LCD_WF8B_BPGLCD57_SHIFT
   Definitions
      At line 2224 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPGLCD57_SHIFT unused
LCD_WF8B_BPGLCD58_MASK 00000040

Symbol: LCD_WF8B_BPGLCD58_MASK
   Definitions
      At line 2219 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPGLCD58_MASK unused
LCD_WF8B_BPGLCD58_SHIFT 00000006

Symbol: LCD_WF8B_BPGLCD58_SHIFT
   Definitions
      At line 2220 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPGLCD58_SHIFT unused



ARM Macro Assembler    Page 210 Alphabetic symbol ordering
Absolute symbols

LCD_WF8B_BPGLCD59_MASK 00000040

Symbol: LCD_WF8B_BPGLCD59_MASK
   Definitions
      At line 2215 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPGLCD59_MASK unused
LCD_WF8B_BPGLCD59_SHIFT 00000006

Symbol: LCD_WF8B_BPGLCD59_SHIFT
   Definitions
      At line 2216 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPGLCD59_SHIFT unused
LCD_WF8B_BPGLCD5_MASK 00000040

Symbol: LCD_WF8B_BPGLCD5_MASK
   Definitions
      At line 2263 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPGLCD5_MASK unused
LCD_WF8B_BPGLCD5_SHIFT 00000006

Symbol: LCD_WF8B_BPGLCD5_SHIFT
   Definitions
      At line 2264 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPGLCD5_SHIFT unused
LCD_WF8B_BPGLCD60_MASK 00000040

Symbol: LCD_WF8B_BPGLCD60_MASK
   Definitions
      At line 2213 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPGLCD60_MASK unused
LCD_WF8B_BPGLCD60_SHIFT 00000006

Symbol: LCD_WF8B_BPGLCD60_SHIFT
   Definitions
      At line 2214 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPGLCD60_SHIFT unused
LCD_WF8B_BPGLCD61_MASK 00000040

Symbol: LCD_WF8B_BPGLCD61_MASK
   Definitions
      At line 2211 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPGLCD61_MASK unused
LCD_WF8B_BPGLCD61_SHIFT 00000006

Symbol: LCD_WF8B_BPGLCD61_SHIFT



ARM Macro Assembler    Page 211 Alphabetic symbol ordering
Absolute symbols

   Definitions
      At line 2212 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPGLCD61_SHIFT unused
LCD_WF8B_BPGLCD62_MASK 00000040

Symbol: LCD_WF8B_BPGLCD62_MASK
   Definitions
      At line 2207 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPGLCD62_MASK unused
LCD_WF8B_BPGLCD62_SHIFT 00000006

Symbol: LCD_WF8B_BPGLCD62_SHIFT
   Definitions
      At line 2208 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPGLCD62_SHIFT unused
LCD_WF8B_BPGLCD63_MASK 00000040

Symbol: LCD_WF8B_BPGLCD63_MASK
   Definitions
      At line 2203 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPGLCD63_MASK unused
LCD_WF8B_BPGLCD63_SHIFT 00000006

Symbol: LCD_WF8B_BPGLCD63_SHIFT
   Definitions
      At line 2204 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPGLCD63_SHIFT unused
LCD_WF8B_BPGLCD6_MASK 00000040

Symbol: LCD_WF8B_BPGLCD6_MASK
   Definitions
      At line 2231 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPGLCD6_MASK unused
LCD_WF8B_BPGLCD6_SHIFT 00000006

Symbol: LCD_WF8B_BPGLCD6_SHIFT
   Definitions
      At line 2232 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPGLCD6_SHIFT unused
LCD_WF8B_BPGLCD7_MASK 00000040

Symbol: LCD_WF8B_BPGLCD7_MASK
   Definitions
      At line 2227 in file ..\Exercise
   Uses



ARM Macro Assembler    Page 212 Alphabetic symbol ordering
Absolute symbols

      None
Comment: LCD_WF8B_BPGLCD7_MASK unused
LCD_WF8B_BPGLCD7_SHIFT 00000006

Symbol: LCD_WF8B_BPGLCD7_SHIFT
   Definitions
      At line 2228 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPGLCD7_SHIFT unused
LCD_WF8B_BPGLCD8_MASK 00000040

Symbol: LCD_WF8B_BPGLCD8_MASK
   Definitions
      At line 2247 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPGLCD8_MASK unused
LCD_WF8B_BPGLCD8_SHIFT 00000006

Symbol: LCD_WF8B_BPGLCD8_SHIFT
   Definitions
      At line 2248 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPGLCD8_SHIFT unused
LCD_WF8B_BPGLCD9_MASK 00000040

Symbol: LCD_WF8B_BPGLCD9_MASK
   Definitions
      At line 2253 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPGLCD9_MASK unused
LCD_WF8B_BPGLCD9_SHIFT 00000006

Symbol: LCD_WF8B_BPGLCD9_SHIFT
   Definitions
      At line 2254 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPGLCD9_SHIFT unused
LCD_WF8B_BPHLCD0_MASK 00000080

Symbol: LCD_WF8B_BPHLCD0_MASK
   Definitions
      At line 2341 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPHLCD0_MASK unused
LCD_WF8B_BPHLCD0_SHIFT 00000007

Symbol: LCD_WF8B_BPHLCD0_SHIFT
   Definitions
      At line 2342 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPHLCD0_SHIFT unused
LCD_WF8B_BPHLCD10_MASK 00000080



ARM Macro Assembler    Page 213 Alphabetic symbol ordering
Absolute symbols


Symbol: LCD_WF8B_BPHLCD10_MASK
   Definitions
      At line 2447 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPHLCD10_MASK unused
LCD_WF8B_BPHLCD10_SHIFT 00000007

Symbol: LCD_WF8B_BPHLCD10_SHIFT
   Definitions
      At line 2448 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPHLCD10_SHIFT unused
LCD_WF8B_BPHLCD11_MASK 00000080

Symbol: LCD_WF8B_BPHLCD11_MASK
   Definitions
      At line 2445 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPHLCD11_MASK unused
LCD_WF8B_BPHLCD11_SHIFT 00000007

Symbol: LCD_WF8B_BPHLCD11_SHIFT
   Definitions
      At line 2446 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPHLCD11_SHIFT unused
LCD_WF8B_BPHLCD12_MASK 00000080

Symbol: LCD_WF8B_BPHLCD12_MASK
   Definitions
      At line 2443 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPHLCD12_MASK unused
LCD_WF8B_BPHLCD12_SHIFT 00000007

Symbol: LCD_WF8B_BPHLCD12_SHIFT
   Definitions
      At line 2444 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPHLCD12_SHIFT unused
LCD_WF8B_BPHLCD13_MASK 00000080

Symbol: LCD_WF8B_BPHLCD13_MASK
   Definitions
      At line 2441 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPHLCD13_MASK unused
LCD_WF8B_BPHLCD13_SHIFT 00000007

Symbol: LCD_WF8B_BPHLCD13_SHIFT
   Definitions



ARM Macro Assembler    Page 214 Alphabetic symbol ordering
Absolute symbols

      At line 2442 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPHLCD13_SHIFT unused
LCD_WF8B_BPHLCD14_MASK 00000080

Symbol: LCD_WF8B_BPHLCD14_MASK
   Definitions
      At line 2439 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPHLCD14_MASK unused
LCD_WF8B_BPHLCD14_SHIFT 00000007

Symbol: LCD_WF8B_BPHLCD14_SHIFT
   Definitions
      At line 2440 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPHLCD14_SHIFT unused
LCD_WF8B_BPHLCD15_MASK 00000080

Symbol: LCD_WF8B_BPHLCD15_MASK
   Definitions
      At line 2435 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPHLCD15_MASK unused
LCD_WF8B_BPHLCD15_SHIFT 00000007

Symbol: LCD_WF8B_BPHLCD15_SHIFT
   Definitions
      At line 2436 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPHLCD15_SHIFT unused
LCD_WF8B_BPHLCD16_MASK 00000080

Symbol: LCD_WF8B_BPHLCD16_MASK
   Definitions
      At line 2433 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPHLCD16_MASK unused
LCD_WF8B_BPHLCD16_SHIFT 00000007

Symbol: LCD_WF8B_BPHLCD16_SHIFT
   Definitions
      At line 2434 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPHLCD16_SHIFT unused
LCD_WF8B_BPHLCD17_MASK 00000080

Symbol: LCD_WF8B_BPHLCD17_MASK
   Definitions
      At line 2431 in file ..\Exercise
   Uses
      None



ARM Macro Assembler    Page 215 Alphabetic symbol ordering
Absolute symbols

Comment: LCD_WF8B_BPHLCD17_MASK unused
LCD_WF8B_BPHLCD17_SHIFT 00000007

Symbol: LCD_WF8B_BPHLCD17_SHIFT
   Definitions
      At line 2432 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPHLCD17_SHIFT unused
LCD_WF8B_BPHLCD18_MASK 00000080

Symbol: LCD_WF8B_BPHLCD18_MASK
   Definitions
      At line 2429 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPHLCD18_MASK unused
LCD_WF8B_BPHLCD18_SHIFT 00000007

Symbol: LCD_WF8B_BPHLCD18_SHIFT
   Definitions
      At line 2430 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPHLCD18_SHIFT unused
LCD_WF8B_BPHLCD19_MASK 00000080

Symbol: LCD_WF8B_BPHLCD19_MASK
   Definitions
      At line 2427 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPHLCD19_MASK unused
LCD_WF8B_BPHLCD19_SHIFT 00000007

Symbol: LCD_WF8B_BPHLCD19_SHIFT
   Definitions
      At line 2428 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPHLCD19_SHIFT unused
LCD_WF8B_BPHLCD1_MASK 00000080

Symbol: LCD_WF8B_BPHLCD1_MASK
   Definitions
      At line 2357 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPHLCD1_MASK unused
LCD_WF8B_BPHLCD1_SHIFT 00000007

Symbol: LCD_WF8B_BPHLCD1_SHIFT
   Definitions
      At line 2358 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPHLCD1_SHIFT unused
LCD_WF8B_BPHLCD20_MASK 00000080




ARM Macro Assembler    Page 216 Alphabetic symbol ordering
Absolute symbols

Symbol: LCD_WF8B_BPHLCD20_MASK
   Definitions
      At line 2425 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPHLCD20_MASK unused
LCD_WF8B_BPHLCD20_SHIFT 00000007

Symbol: LCD_WF8B_BPHLCD20_SHIFT
   Definitions
      At line 2426 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPHLCD20_SHIFT unused
LCD_WF8B_BPHLCD21_MASK 00000080

Symbol: LCD_WF8B_BPHLCD21_MASK
   Definitions
      At line 2423 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPHLCD21_MASK unused
LCD_WF8B_BPHLCD21_SHIFT 00000007

Symbol: LCD_WF8B_BPHLCD21_SHIFT
   Definitions
      At line 2424 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPHLCD21_SHIFT unused
LCD_WF8B_BPHLCD22_MASK 00000080

Symbol: LCD_WF8B_BPHLCD22_MASK
   Definitions
      At line 2419 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPHLCD22_MASK unused
LCD_WF8B_BPHLCD22_SHIFT 00000007

Symbol: LCD_WF8B_BPHLCD22_SHIFT
   Definitions
      At line 2420 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPHLCD22_SHIFT unused
LCD_WF8B_BPHLCD23_MASK 00000080

Symbol: LCD_WF8B_BPHLCD23_MASK
   Definitions
      At line 2417 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPHLCD23_MASK unused
LCD_WF8B_BPHLCD23_SHIFT 00000007

Symbol: LCD_WF8B_BPHLCD23_SHIFT
   Definitions
      At line 2418 in file ..\Exercise



ARM Macro Assembler    Page 217 Alphabetic symbol ordering
Absolute symbols

   Uses
      None
Comment: LCD_WF8B_BPHLCD23_SHIFT unused
LCD_WF8B_BPHLCD24_MASK 00000080

Symbol: LCD_WF8B_BPHLCD24_MASK
   Definitions
      At line 2415 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPHLCD24_MASK unused
LCD_WF8B_BPHLCD24_SHIFT 00000007

Symbol: LCD_WF8B_BPHLCD24_SHIFT
   Definitions
      At line 2416 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPHLCD24_SHIFT unused
LCD_WF8B_BPHLCD25_MASK 00000080

Symbol: LCD_WF8B_BPHLCD25_MASK
   Definitions
      At line 2413 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPHLCD25_MASK unused
LCD_WF8B_BPHLCD25_SHIFT 00000007

Symbol: LCD_WF8B_BPHLCD25_SHIFT
   Definitions
      At line 2414 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPHLCD25_SHIFT unused
LCD_WF8B_BPHLCD26_MASK 00000080

Symbol: LCD_WF8B_BPHLCD26_MASK
   Definitions
      At line 2411 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPHLCD26_MASK unused
LCD_WF8B_BPHLCD26_SHIFT 00000007

Symbol: LCD_WF8B_BPHLCD26_SHIFT
   Definitions
      At line 2412 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPHLCD26_SHIFT unused
LCD_WF8B_BPHLCD27_MASK 00000080

Symbol: LCD_WF8B_BPHLCD27_MASK
   Definitions
      At line 2409 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPHLCD27_MASK unused



ARM Macro Assembler    Page 218 Alphabetic symbol ordering
Absolute symbols

LCD_WF8B_BPHLCD27_SHIFT 00000007

Symbol: LCD_WF8B_BPHLCD27_SHIFT
   Definitions
      At line 2410 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPHLCD27_SHIFT unused
LCD_WF8B_BPHLCD28_MASK 00000080

Symbol: LCD_WF8B_BPHLCD28_MASK
   Definitions
      At line 2407 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPHLCD28_MASK unused
LCD_WF8B_BPHLCD28_SHIFT 00000007

Symbol: LCD_WF8B_BPHLCD28_SHIFT
   Definitions
      At line 2408 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPHLCD28_SHIFT unused
LCD_WF8B_BPHLCD29_MASK 00000080

Symbol: LCD_WF8B_BPHLCD29_MASK
   Definitions
      At line 2403 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPHLCD29_MASK unused
LCD_WF8B_BPHLCD29_SHIFT 00000007

Symbol: LCD_WF8B_BPHLCD29_SHIFT
   Definitions
      At line 2404 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPHLCD29_SHIFT unused
LCD_WF8B_BPHLCD2_MASK 00000080

Symbol: LCD_WF8B_BPHLCD2_MASK
   Definitions
      At line 2373 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPHLCD2_MASK unused
LCD_WF8B_BPHLCD2_SHIFT 00000007

Symbol: LCD_WF8B_BPHLCD2_SHIFT
   Definitions
      At line 2374 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPHLCD2_SHIFT unused
LCD_WF8B_BPHLCD30_MASK 00000080

Symbol: LCD_WF8B_BPHLCD30_MASK



ARM Macro Assembler    Page 219 Alphabetic symbol ordering
Absolute symbols

   Definitions
      At line 2401 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPHLCD30_MASK unused
LCD_WF8B_BPHLCD30_SHIFT 00000007

Symbol: LCD_WF8B_BPHLCD30_SHIFT
   Definitions
      At line 2402 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPHLCD30_SHIFT unused
LCD_WF8B_BPHLCD31_MASK 00000080

Symbol: LCD_WF8B_BPHLCD31_MASK
   Definitions
      At line 2399 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPHLCD31_MASK unused
LCD_WF8B_BPHLCD31_SHIFT 00000007

Symbol: LCD_WF8B_BPHLCD31_SHIFT
   Definitions
      At line 2400 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPHLCD31_SHIFT unused
LCD_WF8B_BPHLCD32_MASK 00000080

Symbol: LCD_WF8B_BPHLCD32_MASK
   Definitions
      At line 2397 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPHLCD32_MASK unused
LCD_WF8B_BPHLCD32_SHIFT 00000007

Symbol: LCD_WF8B_BPHLCD32_SHIFT
   Definitions
      At line 2398 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPHLCD32_SHIFT unused
LCD_WF8B_BPHLCD33_MASK 00000080

Symbol: LCD_WF8B_BPHLCD33_MASK
   Definitions
      At line 2395 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPHLCD33_MASK unused
LCD_WF8B_BPHLCD33_SHIFT 00000007

Symbol: LCD_WF8B_BPHLCD33_SHIFT
   Definitions
      At line 2396 in file ..\Exercise
   Uses



ARM Macro Assembler    Page 220 Alphabetic symbol ordering
Absolute symbols

      None
Comment: LCD_WF8B_BPHLCD33_SHIFT unused
LCD_WF8B_BPHLCD34_MASK 00000080

Symbol: LCD_WF8B_BPHLCD34_MASK
   Definitions
      At line 2393 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPHLCD34_MASK unused
LCD_WF8B_BPHLCD34_SHIFT 00000007

Symbol: LCD_WF8B_BPHLCD34_SHIFT
   Definitions
      At line 2394 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPHLCD34_SHIFT unused
LCD_WF8B_BPHLCD35_MASK 00000080

Symbol: LCD_WF8B_BPHLCD35_MASK
   Definitions
      At line 2391 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPHLCD35_MASK unused
LCD_WF8B_BPHLCD35_SHIFT 00000007

Symbol: LCD_WF8B_BPHLCD35_SHIFT
   Definitions
      At line 2392 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPHLCD35_SHIFT unused
LCD_WF8B_BPHLCD36_MASK 00000080

Symbol: LCD_WF8B_BPHLCD36_MASK
   Definitions
      At line 2387 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPHLCD36_MASK unused
LCD_WF8B_BPHLCD36_SHIFT 00000007

Symbol: LCD_WF8B_BPHLCD36_SHIFT
   Definitions
      At line 2388 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPHLCD36_SHIFT unused
LCD_WF8B_BPHLCD37_MASK 00000080

Symbol: LCD_WF8B_BPHLCD37_MASK
   Definitions
      At line 2385 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPHLCD37_MASK unused
LCD_WF8B_BPHLCD37_SHIFT 00000007



ARM Macro Assembler    Page 221 Alphabetic symbol ordering
Absolute symbols


Symbol: LCD_WF8B_BPHLCD37_SHIFT
   Definitions
      At line 2386 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPHLCD37_SHIFT unused
LCD_WF8B_BPHLCD38_MASK 00000080

Symbol: LCD_WF8B_BPHLCD38_MASK
   Definitions
      At line 2383 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPHLCD38_MASK unused
LCD_WF8B_BPHLCD38_SHIFT 00000007

Symbol: LCD_WF8B_BPHLCD38_SHIFT
   Definitions
      At line 2384 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPHLCD38_SHIFT unused
LCD_WF8B_BPHLCD39_MASK 00000080

Symbol: LCD_WF8B_BPHLCD39_MASK
   Definitions
      At line 2381 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPHLCD39_MASK unused
LCD_WF8B_BPHLCD39_SHIFT 00000007

Symbol: LCD_WF8B_BPHLCD39_SHIFT
   Definitions
      At line 2382 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPHLCD39_SHIFT unused
LCD_WF8B_BPHLCD3_MASK 00000080

Symbol: LCD_WF8B_BPHLCD3_MASK
   Definitions
      At line 2389 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPHLCD3_MASK unused
LCD_WF8B_BPHLCD3_SHIFT 00000007

Symbol: LCD_WF8B_BPHLCD3_SHIFT
   Definitions
      At line 2390 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPHLCD3_SHIFT unused
LCD_WF8B_BPHLCD40_MASK 00000080

Symbol: LCD_WF8B_BPHLCD40_MASK
   Definitions



ARM Macro Assembler    Page 222 Alphabetic symbol ordering
Absolute symbols

      At line 2379 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPHLCD40_MASK unused
LCD_WF8B_BPHLCD40_SHIFT 00000007

Symbol: LCD_WF8B_BPHLCD40_SHIFT
   Definitions
      At line 2380 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPHLCD40_SHIFT unused
LCD_WF8B_BPHLCD41_MASK 00000080

Symbol: LCD_WF8B_BPHLCD41_MASK
   Definitions
      At line 2377 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPHLCD41_MASK unused
LCD_WF8B_BPHLCD41_SHIFT 00000007

Symbol: LCD_WF8B_BPHLCD41_SHIFT
   Definitions
      At line 2378 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPHLCD41_SHIFT unused
LCD_WF8B_BPHLCD42_MASK 00000080

Symbol: LCD_WF8B_BPHLCD42_MASK
   Definitions
      At line 2375 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPHLCD42_MASK unused
LCD_WF8B_BPHLCD42_SHIFT 00000007

Symbol: LCD_WF8B_BPHLCD42_SHIFT
   Definitions
      At line 2376 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPHLCD42_SHIFT unused
LCD_WF8B_BPHLCD43_MASK 00000080

Symbol: LCD_WF8B_BPHLCD43_MASK
   Definitions
      At line 2371 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPHLCD43_MASK unused
LCD_WF8B_BPHLCD43_SHIFT 00000007

Symbol: LCD_WF8B_BPHLCD43_SHIFT
   Definitions
      At line 2372 in file ..\Exercise
   Uses
      None



ARM Macro Assembler    Page 223 Alphabetic symbol ordering
Absolute symbols

Comment: LCD_WF8B_BPHLCD43_SHIFT unused
LCD_WF8B_BPHLCD44_MASK 00000080

Symbol: LCD_WF8B_BPHLCD44_MASK
   Definitions
      At line 2369 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPHLCD44_MASK unused
LCD_WF8B_BPHLCD44_SHIFT 00000007

Symbol: LCD_WF8B_BPHLCD44_SHIFT
   Definitions
      At line 2370 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPHLCD44_SHIFT unused
LCD_WF8B_BPHLCD45_MASK 00000080

Symbol: LCD_WF8B_BPHLCD45_MASK
   Definitions
      At line 2367 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPHLCD45_MASK unused
LCD_WF8B_BPHLCD45_SHIFT 00000007

Symbol: LCD_WF8B_BPHLCD45_SHIFT
   Definitions
      At line 2368 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPHLCD45_SHIFT unused
LCD_WF8B_BPHLCD46_MASK 00000080

Symbol: LCD_WF8B_BPHLCD46_MASK
   Definitions
      At line 2365 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPHLCD46_MASK unused
LCD_WF8B_BPHLCD46_SHIFT 00000007

Symbol: LCD_WF8B_BPHLCD46_SHIFT
   Definitions
      At line 2366 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPHLCD46_SHIFT unused
LCD_WF8B_BPHLCD47_MASK 00000080

Symbol: LCD_WF8B_BPHLCD47_MASK
   Definitions
      At line 2363 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPHLCD47_MASK unused
LCD_WF8B_BPHLCD47_SHIFT 00000007




ARM Macro Assembler    Page 224 Alphabetic symbol ordering
Absolute symbols

Symbol: LCD_WF8B_BPHLCD47_SHIFT
   Definitions
      At line 2364 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPHLCD47_SHIFT unused
LCD_WF8B_BPHLCD48_MASK 00000080

Symbol: LCD_WF8B_BPHLCD48_MASK
   Definitions
      At line 2361 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPHLCD48_MASK unused
LCD_WF8B_BPHLCD48_SHIFT 00000007

Symbol: LCD_WF8B_BPHLCD48_SHIFT
   Definitions
      At line 2362 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPHLCD48_SHIFT unused
LCD_WF8B_BPHLCD49_MASK 00000080

Symbol: LCD_WF8B_BPHLCD49_MASK
   Definitions
      At line 2359 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPHLCD49_MASK unused
LCD_WF8B_BPHLCD49_SHIFT 00000007

Symbol: LCD_WF8B_BPHLCD49_SHIFT
   Definitions
      At line 2360 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPHLCD49_SHIFT unused
LCD_WF8B_BPHLCD4_MASK 00000080

Symbol: LCD_WF8B_BPHLCD4_MASK
   Definitions
      At line 2405 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPHLCD4_MASK unused
LCD_WF8B_BPHLCD4_SHIFT 00000007

Symbol: LCD_WF8B_BPHLCD4_SHIFT
   Definitions
      At line 2406 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPHLCD4_SHIFT unused
LCD_WF8B_BPHLCD50_MASK 00000080

Symbol: LCD_WF8B_BPHLCD50_MASK
   Definitions
      At line 2355 in file ..\Exercise



ARM Macro Assembler    Page 225 Alphabetic symbol ordering
Absolute symbols

   Uses
      None
Comment: LCD_WF8B_BPHLCD50_MASK unused
LCD_WF8B_BPHLCD50_SHIFT 00000007

Symbol: LCD_WF8B_BPHLCD50_SHIFT
   Definitions
      At line 2356 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPHLCD50_SHIFT unused
LCD_WF8B_BPHLCD51_MASK 00000080

Symbol: LCD_WF8B_BPHLCD51_MASK
   Definitions
      At line 2353 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPHLCD51_MASK unused
LCD_WF8B_BPHLCD51_SHIFT 00000007

Symbol: LCD_WF8B_BPHLCD51_SHIFT
   Definitions
      At line 2354 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPHLCD51_SHIFT unused
LCD_WF8B_BPHLCD52_MASK 00000080

Symbol: LCD_WF8B_BPHLCD52_MASK
   Definitions
      At line 2351 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPHLCD52_MASK unused
LCD_WF8B_BPHLCD52_SHIFT 00000007

Symbol: LCD_WF8B_BPHLCD52_SHIFT
   Definitions
      At line 2352 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPHLCD52_SHIFT unused
LCD_WF8B_BPHLCD53_MASK 00000080

Symbol: LCD_WF8B_BPHLCD53_MASK
   Definitions
      At line 2349 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPHLCD53_MASK unused
LCD_WF8B_BPHLCD53_SHIFT 00000007

Symbol: LCD_WF8B_BPHLCD53_SHIFT
   Definitions
      At line 2350 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPHLCD53_SHIFT unused



ARM Macro Assembler    Page 226 Alphabetic symbol ordering
Absolute symbols

LCD_WF8B_BPHLCD54_MASK 00000080

Symbol: LCD_WF8B_BPHLCD54_MASK
   Definitions
      At line 2347 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPHLCD54_MASK unused
LCD_WF8B_BPHLCD54_SHIFT 00000007

Symbol: LCD_WF8B_BPHLCD54_SHIFT
   Definitions
      At line 2348 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPHLCD54_SHIFT unused
LCD_WF8B_BPHLCD55_MASK 00000080

Symbol: LCD_WF8B_BPHLCD55_MASK
   Definitions
      At line 2345 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPHLCD55_MASK unused
LCD_WF8B_BPHLCD55_SHIFT 00000007

Symbol: LCD_WF8B_BPHLCD55_SHIFT
   Definitions
      At line 2346 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPHLCD55_SHIFT unused
LCD_WF8B_BPHLCD56_MASK 00000080

Symbol: LCD_WF8B_BPHLCD56_MASK
   Definitions
      At line 2343 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPHLCD56_MASK unused
LCD_WF8B_BPHLCD56_SHIFT 00000007

Symbol: LCD_WF8B_BPHLCD56_SHIFT
   Definitions
      At line 2344 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPHLCD56_SHIFT unused
LCD_WF8B_BPHLCD57_MASK 00000080

Symbol: LCD_WF8B_BPHLCD57_MASK
   Definitions
      At line 2339 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPHLCD57_MASK unused
LCD_WF8B_BPHLCD57_SHIFT 00000007

Symbol: LCD_WF8B_BPHLCD57_SHIFT



ARM Macro Assembler    Page 227 Alphabetic symbol ordering
Absolute symbols

   Definitions
      At line 2340 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPHLCD57_SHIFT unused
LCD_WF8B_BPHLCD58_MASK 00000080

Symbol: LCD_WF8B_BPHLCD58_MASK
   Definitions
      At line 2337 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPHLCD58_MASK unused
LCD_WF8B_BPHLCD58_SHIFT 00000007

Symbol: LCD_WF8B_BPHLCD58_SHIFT
   Definitions
      At line 2338 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPHLCD58_SHIFT unused
LCD_WF8B_BPHLCD59_MASK 00000080

Symbol: LCD_WF8B_BPHLCD59_MASK
   Definitions
      At line 2335 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPHLCD59_MASK unused
LCD_WF8B_BPHLCD59_SHIFT 00000007

Symbol: LCD_WF8B_BPHLCD59_SHIFT
   Definitions
      At line 2336 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPHLCD59_SHIFT unused
LCD_WF8B_BPHLCD5_MASK 00000080

Symbol: LCD_WF8B_BPHLCD5_MASK
   Definitions
      At line 2421 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPHLCD5_MASK unused
LCD_WF8B_BPHLCD5_SHIFT 00000007

Symbol: LCD_WF8B_BPHLCD5_SHIFT
   Definitions
      At line 2422 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPHLCD5_SHIFT unused
LCD_WF8B_BPHLCD60_MASK 00000080

Symbol: LCD_WF8B_BPHLCD60_MASK
   Definitions
      At line 2333 in file ..\Exercise
   Uses



ARM Macro Assembler    Page 228 Alphabetic symbol ordering
Absolute symbols

      None
Comment: LCD_WF8B_BPHLCD60_MASK unused
LCD_WF8B_BPHLCD60_SHIFT 00000007

Symbol: LCD_WF8B_BPHLCD60_SHIFT
   Definitions
      At line 2334 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPHLCD60_SHIFT unused
LCD_WF8B_BPHLCD61_MASK 00000080

Symbol: LCD_WF8B_BPHLCD61_MASK
   Definitions
      At line 2331 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPHLCD61_MASK unused
LCD_WF8B_BPHLCD61_SHIFT 00000007

Symbol: LCD_WF8B_BPHLCD61_SHIFT
   Definitions
      At line 2332 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPHLCD61_SHIFT unused
LCD_WF8B_BPHLCD62_MASK 00000080

Symbol: LCD_WF8B_BPHLCD62_MASK
   Definitions
      At line 2329 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPHLCD62_MASK unused
LCD_WF8B_BPHLCD62_SHIFT 00000007

Symbol: LCD_WF8B_BPHLCD62_SHIFT
   Definitions
      At line 2330 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPHLCD62_SHIFT unused
LCD_WF8B_BPHLCD63_MASK 00000080

Symbol: LCD_WF8B_BPHLCD63_MASK
   Definitions
      At line 2327 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPHLCD63_MASK unused
LCD_WF8B_BPHLCD63_SHIFT 00000007

Symbol: LCD_WF8B_BPHLCD63_SHIFT
   Definitions
      At line 2328 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPHLCD63_SHIFT unused
LCD_WF8B_BPHLCD6_MASK 00000080



ARM Macro Assembler    Page 229 Alphabetic symbol ordering
Absolute symbols


Symbol: LCD_WF8B_BPHLCD6_MASK
   Definitions
      At line 2437 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPHLCD6_MASK unused
LCD_WF8B_BPHLCD6_SHIFT 00000007

Symbol: LCD_WF8B_BPHLCD6_SHIFT
   Definitions
      At line 2438 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPHLCD6_SHIFT unused
LCD_WF8B_BPHLCD7_MASK 00000080

Symbol: LCD_WF8B_BPHLCD7_MASK
   Definitions
      At line 2453 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPHLCD7_MASK unused
LCD_WF8B_BPHLCD7_SHIFT 00000007

Symbol: LCD_WF8B_BPHLCD7_SHIFT
   Definitions
      At line 2454 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPHLCD7_SHIFT unused
LCD_WF8B_BPHLCD8_MASK 00000080

Symbol: LCD_WF8B_BPHLCD8_MASK
   Definitions
      At line 2451 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPHLCD8_MASK unused
LCD_WF8B_BPHLCD8_SHIFT 00000007

Symbol: LCD_WF8B_BPHLCD8_SHIFT
   Definitions
      At line 2452 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPHLCD8_SHIFT unused
LCD_WF8B_BPHLCD9_MASK 00000080

Symbol: LCD_WF8B_BPHLCD9_MASK
   Definitions
      At line 2449 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPHLCD9_MASK unused
LCD_WF8B_BPHLCD9_SHIFT 00000007

Symbol: LCD_WF8B_BPHLCD9_SHIFT
   Definitions



ARM Macro Assembler    Page 230 Alphabetic symbol ordering
Absolute symbols

      At line 2450 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8B_BPHLCD9_SHIFT unused
LCD_WF8_REG 40053028

Symbol: LCD_WF8_REG
   Definitions
      At line 1214 in file ..\Exercise
   Uses
      None
Comment: LCD_WF8_REG unused
LCD_WF9_REG 40053028

Symbol: LCD_WF9_REG
   Definitions
      At line 1215 in file ..\Exercise
   Uses
      None
Comment: LCD_WF9_REG unused
LCD_WF_A_MASK 00000001

Symbol: LCD_WF_A_MASK
   Definitions
      At line 1413 in file ..\Exercise
   Uses
      None
Comment: LCD_WF_A_MASK unused
LCD_WF_A_SHIFT 00000000

Symbol: LCD_WF_A_SHIFT
   Definitions
      At line 1414 in file ..\Exercise
   Uses
      None
Comment: LCD_WF_A_SHIFT unused
LCD_WF_B_MASK 00000002

Symbol: LCD_WF_B_MASK
   Definitions
      At line 1415 in file ..\Exercise
   Uses
      None
Comment: LCD_WF_B_MASK unused
LCD_WF_B_SHIFT 00000001

Symbol: LCD_WF_B_SHIFT
   Definitions
      At line 1416 in file ..\Exercise
   Uses
      None
Comment: LCD_WF_B_SHIFT unused
LCD_WF_C_MASK 00000004

Symbol: LCD_WF_C_MASK
   Definitions
      At line 1417 in file ..\Exercise
   Uses
      None



ARM Macro Assembler    Page 231 Alphabetic symbol ordering
Absolute symbols

Comment: LCD_WF_C_MASK unused
LCD_WF_C_SHIFT 00000002

Symbol: LCD_WF_C_SHIFT
   Definitions
      At line 1418 in file ..\Exercise
   Uses
      None
Comment: LCD_WF_C_SHIFT unused
LCD_WF_D_MASK 00000008

Symbol: LCD_WF_D_MASK
   Definitions
      At line 1419 in file ..\Exercise
   Uses
      None
Comment: LCD_WF_D_MASK unused
LCD_WF_D_SHIFT 00000003

Symbol: LCD_WF_D_SHIFT
   Definitions
      At line 1420 in file ..\Exercise
   Uses
      None
Comment: LCD_WF_D_SHIFT unused
LCD_WF_E_MASK 00000010

Symbol: LCD_WF_E_MASK
   Definitions
      At line 1421 in file ..\Exercise
   Uses
      None
Comment: LCD_WF_E_MASK unused
LCD_WF_E_SHIFT 00000004

Symbol: LCD_WF_E_SHIFT
   Definitions
      At line 1422 in file ..\Exercise
   Uses
      None
Comment: LCD_WF_E_SHIFT unused
LCD_WF_F_MASK 00000020

Symbol: LCD_WF_F_MASK
   Definitions
      At line 1423 in file ..\Exercise
   Uses
      None
Comment: LCD_WF_F_MASK unused
LCD_WF_F_SHIFT 00000005

Symbol: LCD_WF_F_SHIFT
   Definitions
      At line 1424 in file ..\Exercise
   Uses
      None
Comment: LCD_WF_F_SHIFT unused
LCD_WF_G_MASK 00000040




ARM Macro Assembler    Page 232 Alphabetic symbol ordering
Absolute symbols

Symbol: LCD_WF_G_MASK
   Definitions
      At line 1425 in file ..\Exercise
   Uses
      None
Comment: LCD_WF_G_MASK unused
LCD_WF_G_SHIFT 00000006

Symbol: LCD_WF_G_SHIFT
   Definitions
      At line 1426 in file ..\Exercise
   Uses
      None
Comment: LCD_WF_G_SHIFT unused
LCD_WF_H_MASK 00000080

Symbol: LCD_WF_H_MASK
   Definitions
      At line 1427 in file ..\Exercise
   Uses
      None
Comment: LCD_WF_H_MASK unused
LCD_WF_H_SHIFT 00000007

Symbol: LCD_WF_H_SHIFT
   Definitions
      At line 1428 in file ..\Exercise
   Uses
      None
Comment: LCD_WF_H_SHIFT unused
LCD_WF_OFFSET 00000020

Symbol: LCD_WF_OFFSET
   Definitions
      At line 992 in file ..\Exercise
   Uses
      At line 1017 in file ..\Exercise
Comment: LCD_WF_OFFSET used once
LCD_WF_WF0_MASK 000000FF

Symbol: LCD_WF_WF0_MASK
   Definitions
      At line 1272 in file ..\Exercise
   Uses
      None
Comment: LCD_WF_WF0_MASK unused
LCD_WF_WF0_SHIFT 00000000

Symbol: LCD_WF_WF0_SHIFT
   Definitions
      At line 1273 in file ..\Exercise
   Uses
      None
Comment: LCD_WF_WF0_SHIFT unused
LCD_WF_WF10_MASK 00FF0000

Symbol: LCD_WF_WF10_MASK
   Definitions
      At line 1366 in file ..\Exercise



ARM Macro Assembler    Page 233 Alphabetic symbol ordering
Absolute symbols

   Uses
      None
Comment: LCD_WF_WF10_MASK unused
LCD_WF_WF10_SHIFT 00000010

Symbol: LCD_WF_WF10_SHIFT
   Definitions
      At line 1367 in file ..\Exercise
   Uses
      None
Comment: LCD_WF_WF10_SHIFT unused
LCD_WF_WF11_MASK FF000000

Symbol: LCD_WF_WF11_MASK
   Definitions
      At line 1390 in file ..\Exercise
   Uses
      None
Comment: LCD_WF_WF11_MASK unused
LCD_WF_WF11_SHIFT 00000018

Symbol: LCD_WF_WF11_SHIFT
   Definitions
      At line 1391 in file ..\Exercise
   Uses
      None
Comment: LCD_WF_WF11_SHIFT unused
LCD_WF_WF12_MASK 000000FF

Symbol: LCD_WF_WF12_MASK
   Definitions
      At line 1296 in file ..\Exercise
   Uses
      None
Comment: LCD_WF_WF12_MASK unused
LCD_WF_WF12_SHIFT 00000000

Symbol: LCD_WF_WF12_SHIFT
   Definitions
      At line 1297 in file ..\Exercise
   Uses
      None
Comment: LCD_WF_WF12_SHIFT unused
LCD_WF_WF13_MASK 0000FF00

Symbol: LCD_WF_WF13_MASK
   Definitions
      At line 1318 in file ..\Exercise
   Uses
      None
Comment: LCD_WF_WF13_MASK unused
LCD_WF_WF13_SHIFT 00000008

Symbol: LCD_WF_WF13_SHIFT
   Definitions
      At line 1319 in file ..\Exercise
   Uses
      None
Comment: LCD_WF_WF13_SHIFT unused



ARM Macro Assembler    Page 234 Alphabetic symbol ordering
Absolute symbols

LCD_WF_WF14_MASK 00FF0000

Symbol: LCD_WF_WF14_MASK
   Definitions
      At line 1354 in file ..\Exercise
   Uses
      None
Comment: LCD_WF_WF14_MASK unused
LCD_WF_WF14_SHIFT 00000010

Symbol: LCD_WF_WF14_SHIFT
   Definitions
      At line 1355 in file ..\Exercise
   Uses
      None
Comment: LCD_WF_WF14_SHIFT unused
LCD_WF_WF15_MASK FF000000

Symbol: LCD_WF_WF15_MASK
   Definitions
      At line 1398 in file ..\Exercise
   Uses
      None
Comment: LCD_WF_WF15_MASK unused
LCD_WF_WF15_SHIFT 00000018

Symbol: LCD_WF_WF15_SHIFT
   Definitions
      At line 1399 in file ..\Exercise
   Uses
      None
Comment: LCD_WF_WF15_SHIFT unused
LCD_WF_WF16_MASK 000000FF

Symbol: LCD_WF_WF16_MASK
   Definitions
      At line 1302 in file ..\Exercise
   Uses
      None
Comment: LCD_WF_WF16_MASK unused
LCD_WF_WF16_SHIFT 00000000

Symbol: LCD_WF_WF16_SHIFT
   Definitions
      At line 1303 in file ..\Exercise
   Uses
      None
Comment: LCD_WF_WF16_SHIFT unused
LCD_WF_WF17_MASK 0000FF00

Symbol: LCD_WF_WF17_MASK
   Definitions
      At line 1314 in file ..\Exercise
   Uses
      None
Comment: LCD_WF_WF17_MASK unused
LCD_WF_WF17_SHIFT 00000008

Symbol: LCD_WF_WF17_SHIFT



ARM Macro Assembler    Page 235 Alphabetic symbol ordering
Absolute symbols

   Definitions
      At line 1315 in file ..\Exercise
   Uses
      None
Comment: LCD_WF_WF17_SHIFT unused
LCD_WF_WF18_MASK 00FF0000

Symbol: LCD_WF_WF18_MASK
   Definitions
      At line 1344 in file ..\Exercise
   Uses
      None
Comment: LCD_WF_WF18_MASK unused
LCD_WF_WF18_SHIFT 00000010

Symbol: LCD_WF_WF18_SHIFT
   Definitions
      At line 1345 in file ..\Exercise
   Uses
      None
Comment: LCD_WF_WF18_SHIFT unused
LCD_WF_WF19_MASK FF000000

Symbol: LCD_WF_WF19_MASK
   Definitions
      At line 1396 in file ..\Exercise
   Uses
      None
Comment: LCD_WF_WF19_MASK unused
LCD_WF_WF19_SHIFT 00000018

Symbol: LCD_WF_WF19_SHIFT
   Definitions
      At line 1397 in file ..\Exercise
   Uses
      None
Comment: LCD_WF_WF19_SHIFT unused
LCD_WF_WF1_MASK 0000FF00

Symbol: LCD_WF_WF1_MASK
   Definitions
      At line 1328 in file ..\Exercise
   Uses
      None
Comment: LCD_WF_WF1_MASK unused
LCD_WF_WF1_SHIFT 00000008

Symbol: LCD_WF_WF1_SHIFT
   Definitions
      At line 1329 in file ..\Exercise
   Uses
      None
Comment: LCD_WF_WF1_SHIFT unused
LCD_WF_WF20_MASK 000000FF

Symbol: LCD_WF_WF20_MASK
   Definitions
      At line 1300 in file ..\Exercise
   Uses



ARM Macro Assembler    Page 236 Alphabetic symbol ordering
Absolute symbols

      None
Comment: LCD_WF_WF20_MASK unused
LCD_WF_WF20_SHIFT 00000000

Symbol: LCD_WF_WF20_SHIFT
   Definitions
      At line 1301 in file ..\Exercise
   Uses
      None
Comment: LCD_WF_WF20_SHIFT unused
LCD_WF_WF21_MASK 0000FF00

Symbol: LCD_WF_WF21_MASK
   Definitions
      At line 1334 in file ..\Exercise
   Uses
      None
Comment: LCD_WF_WF21_MASK unused
LCD_WF_WF21_SHIFT 00000008

Symbol: LCD_WF_WF21_SHIFT
   Definitions
      At line 1335 in file ..\Exercise
   Uses
      None
Comment: LCD_WF_WF21_SHIFT unused
LCD_WF_WF22_MASK 00FF0000

Symbol: LCD_WF_WF22_MASK
   Definitions
      At line 1348 in file ..\Exercise
   Uses
      None
Comment: LCD_WF_WF22_MASK unused
LCD_WF_WF22_SHIFT 00000010

Symbol: LCD_WF_WF22_SHIFT
   Definitions
      At line 1349 in file ..\Exercise
   Uses
      None
Comment: LCD_WF_WF22_SHIFT unused
LCD_WF_WF23_MASK FF000000

Symbol: LCD_WF_WF23_MASK
   Definitions
      At line 1394 in file ..\Exercise
   Uses
      None
Comment: LCD_WF_WF23_MASK unused
LCD_WF_WF23_SHIFT 00000018

Symbol: LCD_WF_WF23_SHIFT
   Definitions
      At line 1395 in file ..\Exercise
   Uses
      None
Comment: LCD_WF_WF23_SHIFT unused
LCD_WF_WF24_MASK 000000FF



ARM Macro Assembler    Page 237 Alphabetic symbol ordering
Absolute symbols


Symbol: LCD_WF_WF24_MASK
   Definitions
      At line 1298 in file ..\Exercise
   Uses
      None
Comment: LCD_WF_WF24_MASK unused
LCD_WF_WF24_SHIFT 00000000

Symbol: LCD_WF_WF24_SHIFT
   Definitions
      At line 1299 in file ..\Exercise
   Uses
      None
Comment: LCD_WF_WF24_SHIFT unused
LCD_WF_WF25_MASK 0000FF00

Symbol: LCD_WF_WF25_MASK
   Definitions
      At line 1312 in file ..\Exercise
   Uses
      None
Comment: LCD_WF_WF25_MASK unused
LCD_WF_WF25_SHIFT 00000008

Symbol: LCD_WF_WF25_SHIFT
   Definitions
      At line 1313 in file ..\Exercise
   Uses
      None
Comment: LCD_WF_WF25_SHIFT unused
LCD_WF_WF26_MASK 00FF0000

Symbol: LCD_WF_WF26_MASK
   Definitions
      At line 1336 in file ..\Exercise
   Uses
      None
Comment: LCD_WF_WF26_MASK unused
LCD_WF_WF26_SHIFT 00000010

Symbol: LCD_WF_WF26_SHIFT
   Definitions
      At line 1337 in file ..\Exercise
   Uses
      None
Comment: LCD_WF_WF26_SHIFT unused
LCD_WF_WF27_MASK FF000000

Symbol: LCD_WF_WF27_MASK
   Definitions
      At line 1392 in file ..\Exercise
   Uses
      None
Comment: LCD_WF_WF27_MASK unused
LCD_WF_WF27_SHIFT 00000018

Symbol: LCD_WF_WF27_SHIFT
   Definitions



ARM Macro Assembler    Page 238 Alphabetic symbol ordering
Absolute symbols

      At line 1393 in file ..\Exercise
   Uses
      None
Comment: LCD_WF_WF27_SHIFT unused
LCD_WF_WF28_MASK 000000FF

Symbol: LCD_WF_WF28_MASK
   Definitions
      At line 1294 in file ..\Exercise
   Uses
      None
Comment: LCD_WF_WF28_MASK unused
LCD_WF_WF28_SHIFT 00000000

Symbol: LCD_WF_WF28_SHIFT
   Definitions
      At line 1295 in file ..\Exercise
   Uses
      None
Comment: LCD_WF_WF28_SHIFT unused
LCD_WF_WF29_MASK 0000FF00

Symbol: LCD_WF_WF29_MASK
   Definitions
      At line 1330 in file ..\Exercise
   Uses
      None
Comment: LCD_WF_WF29_MASK unused
LCD_WF_WF29_SHIFT 00000008

Symbol: LCD_WF_WF29_SHIFT
   Definitions
      At line 1331 in file ..\Exercise
   Uses
      None
Comment: LCD_WF_WF29_SHIFT unused
LCD_WF_WF2_MASK 00FF0000

Symbol: LCD_WF_WF2_MASK
   Definitions
      At line 1358 in file ..\Exercise
   Uses
      None
Comment: LCD_WF_WF2_MASK unused
LCD_WF_WF2_SHIFT 00000010

Symbol: LCD_WF_WF2_SHIFT
   Definitions
      At line 1359 in file ..\Exercise
   Uses
      None
Comment: LCD_WF_WF2_SHIFT unused
LCD_WF_WF30_MASK 00FF0000

Symbol: LCD_WF_WF30_MASK
   Definitions
      At line 1362 in file ..\Exercise
   Uses
      None



ARM Macro Assembler    Page 239 Alphabetic symbol ordering
Absolute symbols

Comment: LCD_WF_WF30_MASK unused
LCD_WF_WF30_SHIFT 00000010

Symbol: LCD_WF_WF30_SHIFT
   Definitions
      At line 1363 in file ..\Exercise
   Uses
      None
Comment: LCD_WF_WF30_SHIFT unused
LCD_WF_WF31_MASK FF000000

Symbol: LCD_WF_WF31_MASK
   Definitions
      At line 1388 in file ..\Exercise
   Uses
      None
Comment: LCD_WF_WF31_MASK unused
LCD_WF_WF31_SHIFT 00000018

Symbol: LCD_WF_WF31_SHIFT
   Definitions
      At line 1389 in file ..\Exercise
   Uses
      None
Comment: LCD_WF_WF31_SHIFT unused
LCD_WF_WF32_MASK 000000FF

Symbol: LCD_WF_WF32_MASK
   Definitions
      At line 1292 in file ..\Exercise
   Uses
      None
Comment: LCD_WF_WF32_MASK unused
LCD_WF_WF32_SHIFT 00000000

Symbol: LCD_WF_WF32_SHIFT
   Definitions
      At line 1293 in file ..\Exercise
   Uses
      None
Comment: LCD_WF_WF32_SHIFT unused
LCD_WF_WF33_MASK 0000FF00

Symbol: LCD_WF_WF33_MASK
   Definitions
      At line 1332 in file ..\Exercise
   Uses
      None
Comment: LCD_WF_WF33_MASK unused
LCD_WF_WF33_SHIFT 00000008

Symbol: LCD_WF_WF33_SHIFT
   Definitions
      At line 1333 in file ..\Exercise
   Uses
      None
Comment: LCD_WF_WF33_SHIFT unused
LCD_WF_WF34_MASK 00FF0000




ARM Macro Assembler    Page 240 Alphabetic symbol ordering
Absolute symbols

Symbol: LCD_WF_WF34_MASK
   Definitions
      At line 1350 in file ..\Exercise
   Uses
      None
Comment: LCD_WF_WF34_MASK unused
LCD_WF_WF34_SHIFT 00000010

Symbol: LCD_WF_WF34_SHIFT
   Definitions
      At line 1351 in file ..\Exercise
   Uses
      None
Comment: LCD_WF_WF34_SHIFT unused
LCD_WF_WF35_MASK FF000000

Symbol: LCD_WF_WF35_MASK
   Definitions
      At line 1386 in file ..\Exercise
   Uses
      None
Comment: LCD_WF_WF35_MASK unused
LCD_WF_WF35_SHIFT 00000018

Symbol: LCD_WF_WF35_SHIFT
   Definitions
      At line 1387 in file ..\Exercise
   Uses
      None
Comment: LCD_WF_WF35_SHIFT unused
LCD_WF_WF36_MASK 000000FF

Symbol: LCD_WF_WF36_MASK
   Definitions
      At line 1290 in file ..\Exercise
   Uses
      None
Comment: LCD_WF_WF36_MASK unused
LCD_WF_WF36_SHIFT 00000000

Symbol: LCD_WF_WF36_SHIFT
   Definitions
      At line 1291 in file ..\Exercise
   Uses
      None
Comment: LCD_WF_WF36_SHIFT unused
LCD_WF_WF37_MASK 0000FF00

Symbol: LCD_WF_WF37_MASK
   Definitions
      At line 1324 in file ..\Exercise
   Uses
      None
Comment: LCD_WF_WF37_MASK unused
LCD_WF_WF37_SHIFT 00000008

Symbol: LCD_WF_WF37_SHIFT
   Definitions
      At line 1325 in file ..\Exercise



ARM Macro Assembler    Page 241 Alphabetic symbol ordering
Absolute symbols

   Uses
      None
Comment: LCD_WF_WF37_SHIFT unused
LCD_WF_WF38_MASK 00FF0000

Symbol: LCD_WF_WF38_MASK
   Definitions
      At line 1346 in file ..\Exercise
   Uses
      None
Comment: LCD_WF_WF38_MASK unused
LCD_WF_WF38_SHIFT 00000010

Symbol: LCD_WF_WF38_SHIFT
   Definitions
      At line 1347 in file ..\Exercise
   Uses
      None
Comment: LCD_WF_WF38_SHIFT unused
LCD_WF_WF39_MASK FF000000

Symbol: LCD_WF_WF39_MASK
   Definitions
      At line 1384 in file ..\Exercise
   Uses
      None
Comment: LCD_WF_WF39_MASK unused
LCD_WF_WF39_SHIFT 00000018

Symbol: LCD_WF_WF39_SHIFT
   Definitions
      At line 1385 in file ..\Exercise
   Uses
      None
Comment: LCD_WF_WF39_SHIFT unused
LCD_WF_WF3_MASK FF000000

Symbol: LCD_WF_WF3_MASK
   Definitions
      At line 1374 in file ..\Exercise
   Uses
      None
Comment: LCD_WF_WF3_MASK unused
LCD_WF_WF3_SHIFT 00000018

Symbol: LCD_WF_WF3_SHIFT
   Definitions
      At line 1375 in file ..\Exercise
   Uses
      None
Comment: LCD_WF_WF3_SHIFT unused
LCD_WF_WF40_MASK 000000FF

Symbol: LCD_WF_WF40_MASK
   Definitions
      At line 1286 in file ..\Exercise
   Uses
      None
Comment: LCD_WF_WF40_MASK unused



ARM Macro Assembler    Page 242 Alphabetic symbol ordering
Absolute symbols

LCD_WF_WF40_SHIFT 00000000

Symbol: LCD_WF_WF40_SHIFT
   Definitions
      At line 1287 in file ..\Exercise
   Uses
      None
Comment: LCD_WF_WF40_SHIFT unused
LCD_WF_WF41_MASK 0000FF00

Symbol: LCD_WF_WF41_MASK
   Definitions
      At line 1316 in file ..\Exercise
   Uses
      None
Comment: LCD_WF_WF41_MASK unused
LCD_WF_WF41_SHIFT 00000008

Symbol: LCD_WF_WF41_SHIFT
   Definitions
      At line 1317 in file ..\Exercise
   Uses
      None
Comment: LCD_WF_WF41_SHIFT unused
LCD_WF_WF42_MASK 00FF0000

Symbol: LCD_WF_WF42_MASK
   Definitions
      At line 1342 in file ..\Exercise
   Uses
      None
Comment: LCD_WF_WF42_MASK unused
LCD_WF_WF42_SHIFT 00000010

Symbol: LCD_WF_WF42_SHIFT
   Definitions
      At line 1343 in file ..\Exercise
   Uses
      None
Comment: LCD_WF_WF42_SHIFT unused
LCD_WF_WF43_MASK FF000000

Symbol: LCD_WF_WF43_MASK
   Definitions
      At line 1380 in file ..\Exercise
   Uses
      None
Comment: LCD_WF_WF43_MASK unused
LCD_WF_WF43_SHIFT 00000018

Symbol: LCD_WF_WF43_SHIFT
   Definitions
      At line 1381 in file ..\Exercise
   Uses
      None
Comment: LCD_WF_WF43_SHIFT unused
LCD_WF_WF44_MASK 000000FF

Symbol: LCD_WF_WF44_MASK



ARM Macro Assembler    Page 243 Alphabetic symbol ordering
Absolute symbols

   Definitions
      At line 1284 in file ..\Exercise
   Uses
      None
Comment: LCD_WF_WF44_MASK unused
LCD_WF_WF44_SHIFT 00000000

Symbol: LCD_WF_WF44_SHIFT
   Definitions
      At line 1285 in file ..\Exercise
   Uses
      None
Comment: LCD_WF_WF44_SHIFT unused
LCD_WF_WF45_MASK 0000FF00

Symbol: LCD_WF_WF45_MASK
   Definitions
      At line 1308 in file ..\Exercise
   Uses
      None
Comment: LCD_WF_WF45_MASK unused
LCD_WF_WF45_SHIFT 00000008

Symbol: LCD_WF_WF45_SHIFT
   Definitions
      At line 1309 in file ..\Exercise
   Uses
      None
Comment: LCD_WF_WF45_SHIFT unused
LCD_WF_WF46_MASK 00FF0000

Symbol: LCD_WF_WF46_MASK
   Definitions
      At line 1338 in file ..\Exercise
   Uses
      None
Comment: LCD_WF_WF46_MASK unused
LCD_WF_WF46_SHIFT 00000010

Symbol: LCD_WF_WF46_SHIFT
   Definitions
      At line 1339 in file ..\Exercise
   Uses
      None
Comment: LCD_WF_WF46_SHIFT unused
LCD_WF_WF47_MASK FF000000

Symbol: LCD_WF_WF47_MASK
   Definitions
      At line 1378 in file ..\Exercise
   Uses
      None
Comment: LCD_WF_WF47_MASK unused
LCD_WF_WF47_SHIFT 00000018

Symbol: LCD_WF_WF47_SHIFT
   Definitions
      At line 1379 in file ..\Exercise
   Uses



ARM Macro Assembler    Page 244 Alphabetic symbol ordering
Absolute symbols

      None
Comment: LCD_WF_WF47_SHIFT unused
LCD_WF_WF48_MASK 000000FF

Symbol: LCD_WF_WF48_MASK
   Definitions
      At line 1282 in file ..\Exercise
   Uses
      None
Comment: LCD_WF_WF48_MASK unused
LCD_WF_WF48_SHIFT 00000000

Symbol: LCD_WF_WF48_SHIFT
   Definitions
      At line 1283 in file ..\Exercise
   Uses
      None
Comment: LCD_WF_WF48_SHIFT unused
LCD_WF_WF49_MASK 0000FF00

Symbol: LCD_WF_WF49_MASK
   Definitions
      At line 1306 in file ..\Exercise
   Uses
      None
Comment: LCD_WF_WF49_MASK unused
LCD_WF_WF49_SHIFT 00000008

Symbol: LCD_WF_WF49_SHIFT
   Definitions
      At line 1307 in file ..\Exercise
   Uses
      None
Comment: LCD_WF_WF49_SHIFT unused
LCD_WF_WF4_MASK 000000FF

Symbol: LCD_WF_WF4_MASK
   Definitions
      At line 1280 in file ..\Exercise
   Uses
      None
Comment: LCD_WF_WF4_MASK unused
LCD_WF_WF4_SHIFT 00000000

Symbol: LCD_WF_WF4_SHIFT
   Definitions
      At line 1281 in file ..\Exercise
   Uses
      None
Comment: LCD_WF_WF4_SHIFT unused
LCD_WF_WF50_MASK 00FF0000

Symbol: LCD_WF_WF50_MASK
   Definitions
      At line 1352 in file ..\Exercise
   Uses
      None
Comment: LCD_WF_WF50_MASK unused
LCD_WF_WF50_SHIFT 00000010



ARM Macro Assembler    Page 245 Alphabetic symbol ordering
Absolute symbols


Symbol: LCD_WF_WF50_SHIFT
   Definitions
      At line 1353 in file ..\Exercise
   Uses
      None
Comment: LCD_WF_WF50_SHIFT unused
LCD_WF_WF51_MASK FF000000

Symbol: LCD_WF_WF51_MASK
   Definitions
      At line 1376 in file ..\Exercise
   Uses
      None
Comment: LCD_WF_WF51_MASK unused
LCD_WF_WF51_SHIFT 00000018

Symbol: LCD_WF_WF51_SHIFT
   Definitions
      At line 1377 in file ..\Exercise
   Uses
      None
Comment: LCD_WF_WF51_SHIFT unused
LCD_WF_WF52_MASK 000000FF

Symbol: LCD_WF_WF52_MASK
   Definitions
      At line 1278 in file ..\Exercise
   Uses
      None
Comment: LCD_WF_WF52_MASK unused
LCD_WF_WF52_SHIFT 00000000

Symbol: LCD_WF_WF52_SHIFT
   Definitions
      At line 1279 in file ..\Exercise
   Uses
      None
Comment: LCD_WF_WF52_SHIFT unused
LCD_WF_WF53_MASK 0000FF00

Symbol: LCD_WF_WF53_MASK
   Definitions
      At line 1322 in file ..\Exercise
   Uses
      None
Comment: LCD_WF_WF53_MASK unused
LCD_WF_WF53_SHIFT 00000008

Symbol: LCD_WF_WF53_SHIFT
   Definitions
      At line 1323 in file ..\Exercise
   Uses
      None
Comment: LCD_WF_WF53_SHIFT unused
LCD_WF_WF54_MASK 00FF0000

Symbol: LCD_WF_WF54_MASK
   Definitions



ARM Macro Assembler    Page 246 Alphabetic symbol ordering
Absolute symbols

      At line 1356 in file ..\Exercise
   Uses
      None
Comment: LCD_WF_WF54_MASK unused
LCD_WF_WF54_SHIFT 00000010

Symbol: LCD_WF_WF54_SHIFT
   Definitions
      At line 1357 in file ..\Exercise
   Uses
      None
Comment: LCD_WF_WF54_SHIFT unused
LCD_WF_WF55_MASK FF000000

Symbol: LCD_WF_WF55_MASK
   Definitions
      At line 1372 in file ..\Exercise
   Uses
      None
Comment: LCD_WF_WF55_MASK unused
LCD_WF_WF55_SHIFT 00000018

Symbol: LCD_WF_WF55_SHIFT
   Definitions
      At line 1373 in file ..\Exercise
   Uses
      None
Comment: LCD_WF_WF55_SHIFT unused
LCD_WF_WF56_MASK 000000FF

Symbol: LCD_WF_WF56_MASK
   Definitions
      At line 1276 in file ..\Exercise
   Uses
      None
Comment: LCD_WF_WF56_MASK unused
LCD_WF_WF56_SHIFT 00000000

Symbol: LCD_WF_WF56_SHIFT
   Definitions
      At line 1277 in file ..\Exercise
   Uses
      None
Comment: LCD_WF_WF56_SHIFT unused
LCD_WF_WF57_MASK 0000FF00

Symbol: LCD_WF_WF57_MASK
   Definitions
      At line 1320 in file ..\Exercise
   Uses
      None
Comment: LCD_WF_WF57_MASK unused
LCD_WF_WF57_SHIFT 00000008

Symbol: LCD_WF_WF57_SHIFT
   Definitions
      At line 1321 in file ..\Exercise
   Uses
      None



ARM Macro Assembler    Page 247 Alphabetic symbol ordering
Absolute symbols

Comment: LCD_WF_WF57_SHIFT unused
LCD_WF_WF58_MASK 00FF0000

Symbol: LCD_WF_WF58_MASK
   Definitions
      At line 1360 in file ..\Exercise
   Uses
      None
Comment: LCD_WF_WF58_MASK unused
LCD_WF_WF58_SHIFT 00000010

Symbol: LCD_WF_WF58_SHIFT
   Definitions
      At line 1361 in file ..\Exercise
   Uses
      None
Comment: LCD_WF_WF58_SHIFT unused
LCD_WF_WF59_MASK FF000000

Symbol: LCD_WF_WF59_MASK
   Definitions
      At line 1370 in file ..\Exercise
   Uses
      None
Comment: LCD_WF_WF59_MASK unused
LCD_WF_WF59_SHIFT 00000018

Symbol: LCD_WF_WF59_SHIFT
   Definitions
      At line 1371 in file ..\Exercise
   Uses
      None
Comment: LCD_WF_WF59_SHIFT unused
LCD_WF_WF5_MASK 0000FF00

Symbol: LCD_WF_WF5_MASK
   Definitions
      At line 1304 in file ..\Exercise
   Uses
      None
Comment: LCD_WF_WF5_MASK unused
LCD_WF_WF5_SHIFT 00000008

Symbol: LCD_WF_WF5_SHIFT
   Definitions
      At line 1305 in file ..\Exercise
   Uses
      None
Comment: LCD_WF_WF5_SHIFT unused
LCD_WF_WF60_MASK 000000FF

Symbol: LCD_WF_WF60_MASK
   Definitions
      At line 1274 in file ..\Exercise
   Uses
      None
Comment: LCD_WF_WF60_MASK unused
LCD_WF_WF60_SHIFT 00000000




ARM Macro Assembler    Page 248 Alphabetic symbol ordering
Absolute symbols

Symbol: LCD_WF_WF60_SHIFT
   Definitions
      At line 1275 in file ..\Exercise
   Uses
      None
Comment: LCD_WF_WF60_SHIFT unused
LCD_WF_WF61_MASK 0000FF00

Symbol: LCD_WF_WF61_MASK
   Definitions
      At line 1310 in file ..\Exercise
   Uses
      None
Comment: LCD_WF_WF61_MASK unused
LCD_WF_WF61_SHIFT 00000008

Symbol: LCD_WF_WF61_SHIFT
   Definitions
      At line 1311 in file ..\Exercise
   Uses
      None
Comment: LCD_WF_WF61_SHIFT unused
LCD_WF_WF62_MASK 00FF0000

Symbol: LCD_WF_WF62_MASK
   Definitions
      At line 1364 in file ..\Exercise
   Uses
      None
Comment: LCD_WF_WF62_MASK unused
LCD_WF_WF62_SHIFT 00000010

Symbol: LCD_WF_WF62_SHIFT
   Definitions
      At line 1365 in file ..\Exercise
   Uses
      None
Comment: LCD_WF_WF62_SHIFT unused
LCD_WF_WF63_MASK FF000000

Symbol: LCD_WF_WF63_MASK
   Definitions
      At line 1368 in file ..\Exercise
   Uses
      None
Comment: LCD_WF_WF63_MASK unused
LCD_WF_WF63_SHIFT 00000018

Symbol: LCD_WF_WF63_SHIFT
   Definitions
      At line 1369 in file ..\Exercise
   Uses
      None
Comment: LCD_WF_WF63_SHIFT unused
LCD_WF_WF6_MASK 00FF0000

Symbol: LCD_WF_WF6_MASK
   Definitions
      At line 1340 in file ..\Exercise



ARM Macro Assembler    Page 249 Alphabetic symbol ordering
Absolute symbols

   Uses
      None
Comment: LCD_WF_WF6_MASK unused
LCD_WF_WF6_SHIFT 00000010

Symbol: LCD_WF_WF6_SHIFT
   Definitions
      At line 1341 in file ..\Exercise
   Uses
      None
Comment: LCD_WF_WF6_SHIFT unused
LCD_WF_WF7_MASK FF000000

Symbol: LCD_WF_WF7_MASK
   Definitions
      At line 1382 in file ..\Exercise
   Uses
      None
Comment: LCD_WF_WF7_MASK unused
LCD_WF_WF7_SHIFT 00000018

Symbol: LCD_WF_WF7_SHIFT
   Definitions
      At line 1383 in file ..\Exercise
   Uses
      None
Comment: LCD_WF_WF7_SHIFT unused
LCD_WF_WF8_MASK 000000FF

Symbol: LCD_WF_WF8_MASK
   Definitions
      At line 1288 in file ..\Exercise
   Uses
      None
Comment: LCD_WF_WF8_MASK unused
LCD_WF_WF8_SHIFT 00000000

Symbol: LCD_WF_WF8_SHIFT
   Definitions
      At line 1289 in file ..\Exercise
   Uses
      None
Comment: LCD_WF_WF8_SHIFT unused
LCD_WF_WF9_MASK 0000FF00

Symbol: LCD_WF_WF9_MASK
   Definitions
      At line 1326 in file ..\Exercise
   Uses
      None
Comment: LCD_WF_WF9_MASK unused
LCD_WF_WF9_SHIFT 00000008

Symbol: LCD_WF_WF9_SHIFT
   Definitions
      At line 1327 in file ..\Exercise
   Uses
      None
Comment: LCD_WF_WF9_SHIFT unused



ARM Macro Assembler    Page 250 Alphabetic symbol ordering
Absolute symbols

LED_GREEN_MASK 00000020

Symbol: LED_GREEN_MASK
   Definitions
      At line 240 in file ..\Exercise
   Uses
      At line 241 in file ..\Exercise
      At line 375 in file ..\Exercise

LED_PORTD_MASK 00000020

Symbol: LED_PORTD_MASK
   Definitions
      At line 241 in file ..\Exercise
   Uses
      At line 426 in file ..\Exercise
Comment: LED_PORTD_MASK used once
LED_PORTE_MASK 20000000

Symbol: LED_PORTE_MASK
   Definitions
      At line 242 in file ..\Exercise
   Uses
      At line 429 in file ..\Exercise
Comment: LED_PORTE_MASK used once
LED_RED_MASK 20000000

Symbol: LED_RED_MASK
   Definitions
      At line 239 in file ..\Exercise
   Uses
      At line 242 in file ..\Exercise
      At line 389 in file ..\Exercise

LLWU_IPR E000E404

Symbol: LLWU_IPR
   Definitions
      At line 2670 in file ..\Exercise
   Uses
      None
Comment: LLWU_IPR unused
LLWU_IRQ 00000007

Symbol: LLWU_IRQ
   Definitions
      At line 2740 in file ..\Exercise
   Uses
      At line 2774 in file ..\Exercise
Comment: LLWU_IRQ used once
LLWU_IRQ_MASK 00000080

Symbol: LLWU_IRQ_MASK
   Definitions
      At line 2774 in file ..\Exercise
   Uses
      None
Comment: LLWU_IRQ_MASK unused
LLWU_PRI_POS 0000001E



ARM Macro Assembler    Page 251 Alphabetic symbol ordering
Absolute symbols


Symbol: LLWU_PRI_POS
   Definitions
      At line 2706 in file ..\Exercise
   Uses
      None
Comment: LLWU_PRI_POS unused
LLWU_Vector 00000017

Symbol: LLWU_Vector
   Definitions
      At line 2824 in file ..\Exercise
   Uses
      None
Comment: LLWU_Vector unused
LLW_IRQn 00000007

Symbol: LLW_IRQn
   Definitions
      At line 153 in file ..\Exercise
   Uses
      None
Comment: LLW_IRQn unused
LPTMR0_IPR E000E41C

Symbol: LPTMR0_IPR
   Definitions
      At line 2691 in file ..\Exercise
   Uses
      None
Comment: LPTMR0_IPR unused
LPTMR0_IRQ 0000001C

Symbol: LPTMR0_IRQ
   Definitions
      At line 2761 in file ..\Exercise
   Uses
      At line 2795 in file ..\Exercise
Comment: LPTMR0_IRQ used once
LPTMR0_IRQ_MASK 10000000

Symbol: LPTMR0_IRQ_MASK
   Definitions
      At line 2795 in file ..\Exercise
   Uses
      None
Comment: LPTMR0_IRQ_MASK unused
LPTMR0_PRI_POS 00000006

Symbol: LPTMR0_PRI_POS
   Definitions
      At line 2727 in file ..\Exercise
   Uses
      None
Comment: LPTMR0_PRI_POS unused
LPTMR0_Vector 0000002C

Symbol: LPTMR0_Vector
   Definitions



ARM Macro Assembler    Page 252 Alphabetic symbol ordering
Absolute symbols

      At line 2845 in file ..\Exercise
   Uses
      None
Comment: LPTMR0_Vector unused
LPTimer_IRQn 0000001C

Symbol: LPTimer_IRQn
   Definitions
      At line 174 in file ..\Exercise
   Uses
      None
Comment: LPTimer_IRQn unused
LVD_LVW_IRQn 00000006

Symbol: LVD_LVW_IRQn
   Definitions
      At line 152 in file ..\Exercise
   Uses
      None
Comment: LVD_LVW_IRQn unused
MAX_STRING 0000004F

Symbol: MAX_STRING
   Definitions
      At line 215 in file ..\Exercise
   Uses
      None
Comment: MAX_STRING unused
MCG_BASE 40064000

Symbol: MCG_BASE
   Definitions
      At line 2457 in file ..\Exercise
   Uses
      At line 2464 in file ..\Exercise
      At line 2465 in file ..\Exercise
      At line 2466 in file ..\Exercise
      At line 2467 in file ..\Exercise
      At line 2468 in file ..\Exercise
      At line 2469 in file ..\Exercise

MCG_C1 40064000

Symbol: MCG_C1
   Definitions
      At line 2464 in file ..\Exercise
   Uses
      None
Comment: MCG_C1 unused
MCG_C1_CLKS_MASK 000000C0

Symbol: MCG_C1_CLKS_MASK
   Definitions
      At line 2494 in file ..\Exercise
   Uses
      None
Comment: MCG_C1_CLKS_MASK unused
MCG_C1_CLKS_SHIFT 00000006




ARM Macro Assembler    Page 253 Alphabetic symbol ordering
Absolute symbols

Symbol: MCG_C1_CLKS_SHIFT
   Definitions
      At line 2495 in file ..\Exercise
   Uses
      None
Comment: MCG_C1_CLKS_SHIFT unused
MCG_C1_FRDIV_MASK 00000038

Symbol: MCG_C1_FRDIV_MASK
   Definitions
      At line 2496 in file ..\Exercise
   Uses
      None
Comment: MCG_C1_FRDIV_MASK unused
MCG_C1_FRDIV_SHIFT 00000003

Symbol: MCG_C1_FRDIV_SHIFT
   Definitions
      At line 2497 in file ..\Exercise
   Uses
      None
Comment: MCG_C1_FRDIV_SHIFT unused
MCG_C1_IRCLKEN_MASK 00000002

Symbol: MCG_C1_IRCLKEN_MASK
   Definitions
      At line 2500 in file ..\Exercise
   Uses
      None
Comment: MCG_C1_IRCLKEN_MASK unused
MCG_C1_IRCLKEN_SHIFT 00000001

Symbol: MCG_C1_IRCLKEN_SHIFT
   Definitions
      At line 2501 in file ..\Exercise
   Uses
      None
Comment: MCG_C1_IRCLKEN_SHIFT unused
MCG_C1_IREFSTEN_MASK 00000001

Symbol: MCG_C1_IREFSTEN_MASK
   Definitions
      At line 2502 in file ..\Exercise
   Uses
      None
Comment: MCG_C1_IREFSTEN_MASK unused
MCG_C1_IREFSTEN_SHIFT 00000000

Symbol: MCG_C1_IREFSTEN_SHIFT
   Definitions
      At line 2503 in file ..\Exercise
   Uses
      None
Comment: MCG_C1_IREFSTEN_SHIFT unused
MCG_C1_IREFS_MASK 00000004

Symbol: MCG_C1_IREFS_MASK
   Definitions
      At line 2498 in file ..\Exercise



ARM Macro Assembler    Page 254 Alphabetic symbol ordering
Absolute symbols

   Uses
      None
Comment: MCG_C1_IREFS_MASK unused
MCG_C1_IREFS_SHIFT 00000002

Symbol: MCG_C1_IREFS_SHIFT
   Definitions
      At line 2499 in file ..\Exercise
   Uses
      None
Comment: MCG_C1_IREFS_SHIFT unused
MCG_C1_OFFSET 00000000

Symbol: MCG_C1_OFFSET
   Definitions
      At line 2458 in file ..\Exercise
   Uses
      At line 2464 in file ..\Exercise
Comment: MCG_C1_OFFSET used once
MCG_C2 40064001

Symbol: MCG_C2
   Definitions
      At line 2465 in file ..\Exercise
   Uses
      None
Comment: MCG_C2 unused
MCG_C2_EREFS0_MASK 00000004

Symbol: MCG_C2_EREFS0_MASK
   Definitions
      At line 2534 in file ..\Exercise
   Uses
      None
Comment: MCG_C2_EREFS0_MASK unused
MCG_C2_EREFS0_SHIFT 00000002

Symbol: MCG_C2_EREFS0_SHIFT
   Definitions
      At line 2535 in file ..\Exercise
   Uses
      None
Comment: MCG_C2_EREFS0_SHIFT unused
MCG_C2_FCFTRIM_MASK 00000040

Symbol: MCG_C2_FCFTRIM_MASK
   Definitions
      At line 2528 in file ..\Exercise
   Uses
      None
Comment: MCG_C2_FCFTRIM_MASK unused
MCG_C2_FCFTRIM_SHIFT 00000006

Symbol: MCG_C2_FCFTRIM_SHIFT
   Definitions
      At line 2529 in file ..\Exercise
   Uses
      None
Comment: MCG_C2_FCFTRIM_SHIFT unused



ARM Macro Assembler    Page 255 Alphabetic symbol ordering
Absolute symbols

MCG_C2_HGO0_MASK 00000008

Symbol: MCG_C2_HGO0_MASK
   Definitions
      At line 2532 in file ..\Exercise
   Uses
      None
Comment: MCG_C2_HGO0_MASK unused
MCG_C2_HGO0_SHIFT 00000003

Symbol: MCG_C2_HGO0_SHIFT
   Definitions
      At line 2533 in file ..\Exercise
   Uses
      None
Comment: MCG_C2_HGO0_SHIFT unused
MCG_C2_IRCS_MASK 00000001

Symbol: MCG_C2_IRCS_MASK
   Definitions
      At line 2538 in file ..\Exercise
   Uses
      None
Comment: MCG_C2_IRCS_MASK unused
MCG_C2_IRCS_SHIFT 00000000

Symbol: MCG_C2_IRCS_SHIFT
   Definitions
      At line 2539 in file ..\Exercise
   Uses
      None
Comment: MCG_C2_IRCS_SHIFT unused
MCG_C2_LOCRE0_MASK 00000080

Symbol: MCG_C2_LOCRE0_MASK
   Definitions
      At line 2526 in file ..\Exercise
   Uses
      None
Comment: MCG_C2_LOCRE0_MASK unused
MCG_C2_LOCRE0_SHIFT 00000007

Symbol: MCG_C2_LOCRE0_SHIFT
   Definitions
      At line 2527 in file ..\Exercise
   Uses
      None
Comment: MCG_C2_LOCRE0_SHIFT unused
MCG_C2_LP_MASK 00000002

Symbol: MCG_C2_LP_MASK
   Definitions
      At line 2536 in file ..\Exercise
   Uses
      None
Comment: MCG_C2_LP_MASK unused
MCG_C2_LP_SHIFT 00000001

Symbol: MCG_C2_LP_SHIFT



ARM Macro Assembler    Page 256 Alphabetic symbol ordering
Absolute symbols

   Definitions
      At line 2537 in file ..\Exercise
   Uses
      None
Comment: MCG_C2_LP_SHIFT unused
MCG_C2_OFFSET 00000001

Symbol: MCG_C2_OFFSET
   Definitions
      At line 2459 in file ..\Exercise
   Uses
      At line 2465 in file ..\Exercise
Comment: MCG_C2_OFFSET used once
MCG_C2_RANGE0_MASK 00000030

Symbol: MCG_C2_RANGE0_MASK
   Definitions
      At line 2530 in file ..\Exercise
   Uses
      None
Comment: MCG_C2_RANGE0_MASK unused
MCG_C2_RANGE0_SHIFT 00000004

Symbol: MCG_C2_RANGE0_SHIFT
   Definitions
      At line 2531 in file ..\Exercise
   Uses
      None
Comment: MCG_C2_RANGE0_SHIFT unused
MCG_C3_SCTRIM_MASK 000000FF

Symbol: MCG_C3_SCTRIM_MASK
   Definitions
      At line 2544 in file ..\Exercise
   Uses
      None
Comment: MCG_C3_SCTRIM_MASK unused
MCG_C3_SCTRIM_SHIFT 00000000

Symbol: MCG_C3_SCTRIM_SHIFT
   Definitions
      At line 2545 in file ..\Exercise
   Uses
      None
Comment: MCG_C3_SCTRIM_SHIFT unused
MCG_C4 40064003

Symbol: MCG_C4
   Definitions
      At line 2466 in file ..\Exercise
   Uses
      None
Comment: MCG_C4 unused
MCG_C4_DMX32_MASK 00000080

Symbol: MCG_C4_DMX32_MASK
   Definitions
      At line 2560 in file ..\Exercise
   Uses



ARM Macro Assembler    Page 257 Alphabetic symbol ordering
Absolute symbols

      None
Comment: MCG_C4_DMX32_MASK unused
MCG_C4_DMX32_SHIFT 00000007

Symbol: MCG_C4_DMX32_SHIFT
   Definitions
      At line 2561 in file ..\Exercise
   Uses
      None
Comment: MCG_C4_DMX32_SHIFT unused
MCG_C4_DRST_DRS_MASK 00000060

Symbol: MCG_C4_DRST_DRS_MASK
   Definitions
      At line 2562 in file ..\Exercise
   Uses
      None
Comment: MCG_C4_DRST_DRS_MASK unused
MCG_C4_DRST_DRS_SHIFT 00000005

Symbol: MCG_C4_DRST_DRS_SHIFT
   Definitions
      At line 2563 in file ..\Exercise
   Uses
      None
Comment: MCG_C4_DRST_DRS_SHIFT unused
MCG_C4_FCTRIM_MASK 0000001E

Symbol: MCG_C4_FCTRIM_MASK
   Definitions
      At line 2564 in file ..\Exercise
   Uses
      None
Comment: MCG_C4_FCTRIM_MASK unused
MCG_C4_FCTRIM_SHIFT 00000001

Symbol: MCG_C4_FCTRIM_SHIFT
   Definitions
      At line 2565 in file ..\Exercise
   Uses
      None
Comment: MCG_C4_FCTRIM_SHIFT unused
MCG_C4_OFFSET 00000003

Symbol: MCG_C4_OFFSET
   Definitions
      At line 2460 in file ..\Exercise
   Uses
      At line 2466 in file ..\Exercise
Comment: MCG_C4_OFFSET used once
MCG_C4_SCFTRIM_MASK 00000001

Symbol: MCG_C4_SCFTRIM_MASK
   Definitions
      At line 2566 in file ..\Exercise
   Uses
      None
Comment: MCG_C4_SCFTRIM_MASK unused
MCG_C4_SCFTRIM_SHIFT 00000000



ARM Macro Assembler    Page 258 Alphabetic symbol ordering
Absolute symbols


Symbol: MCG_C4_SCFTRIM_SHIFT
   Definitions
      At line 2567 in file ..\Exercise
   Uses
      None
Comment: MCG_C4_SCFTRIM_SHIFT unused
MCG_C5 40064004

Symbol: MCG_C5
   Definitions
      At line 2467 in file ..\Exercise
   Uses
      None
Comment: MCG_C5 unused
MCG_C5_OFFSET 00000004

Symbol: MCG_C5_OFFSET
   Definitions
      At line 2461 in file ..\Exercise
   Uses
      At line 2467 in file ..\Exercise
Comment: MCG_C5_OFFSET used once
MCG_C5_PLLCLKEN0_MASK 00000040

Symbol: MCG_C5_PLLCLKEN0_MASK
   Definitions
      At line 2576 in file ..\Exercise
   Uses
      None
Comment: MCG_C5_PLLCLKEN0_MASK unused
MCG_C5_PLLCLKEN0_SHIFT 00000006

Symbol: MCG_C5_PLLCLKEN0_SHIFT
   Definitions
      At line 2577 in file ..\Exercise
   Uses
      None
Comment: MCG_C5_PLLCLKEN0_SHIFT unused
MCG_C5_PLLSTEN0_MASK 00000020

Symbol: MCG_C5_PLLSTEN0_MASK
   Definitions
      At line 2578 in file ..\Exercise
   Uses
      None
Comment: MCG_C5_PLLSTEN0_MASK unused
MCG_C5_PLLSTEN0_SHIFT 00000005

Symbol: MCG_C5_PLLSTEN0_SHIFT
   Definitions
      At line 2579 in file ..\Exercise
   Uses
      None
Comment: MCG_C5_PLLSTEN0_SHIFT unused
MCG_C5_PRDIV0_DIV2 00000001

Symbol: MCG_C5_PRDIV0_DIV2
   Definitions



ARM Macro Assembler    Page 259 Alphabetic symbol ordering
Absolute symbols

      At line 2582 in file ..\Exercise
   Uses
      None
Comment: MCG_C5_PRDIV0_DIV2 unused
MCG_C5_PRDIV0_MASK 0000001F

Symbol: MCG_C5_PRDIV0_MASK
   Definitions
      At line 2580 in file ..\Exercise
   Uses
      None
Comment: MCG_C5_PRDIV0_MASK unused
MCG_C5_PRDIV0_SHIFT 00000000

Symbol: MCG_C5_PRDIV0_SHIFT
   Definitions
      At line 2581 in file ..\Exercise
   Uses
      None
Comment: MCG_C5_PRDIV0_SHIFT unused
MCG_C6 40064005

Symbol: MCG_C6
   Definitions
      At line 2468 in file ..\Exercise
   Uses
      None
Comment: MCG_C6 unused
MCG_C6_CME0_MASK 00000020

Symbol: MCG_C6_CME0_MASK
   Definitions
      At line 2596 in file ..\Exercise
   Uses
      None
Comment: MCG_C6_CME0_MASK unused
MCG_C6_CME0_SHIFT 00000005

Symbol: MCG_C6_CME0_SHIFT
   Definitions
      At line 2597 in file ..\Exercise
   Uses
      None
Comment: MCG_C6_CME0_SHIFT unused
MCG_C6_LOLIE0_MASK 00000080

Symbol: MCG_C6_LOLIE0_MASK
   Definitions
      At line 2592 in file ..\Exercise
   Uses
      None
Comment: MCG_C6_LOLIE0_MASK unused
MCG_C6_LOLIE0_SHIFT 00000007

Symbol: MCG_C6_LOLIE0_SHIFT
   Definitions
      At line 2593 in file ..\Exercise
   Uses
      None



ARM Macro Assembler    Page 260 Alphabetic symbol ordering
Absolute symbols

Comment: MCG_C6_LOLIE0_SHIFT unused
MCG_C6_OFFSET 00000005

Symbol: MCG_C6_OFFSET
   Definitions
      At line 2462 in file ..\Exercise
   Uses
      At line 2468 in file ..\Exercise
Comment: MCG_C6_OFFSET used once
MCG_C6_PLLS_MASK 00000040

Symbol: MCG_C6_PLLS_MASK
   Definitions
      At line 2594 in file ..\Exercise
   Uses
      None
Comment: MCG_C6_PLLS_MASK unused
MCG_C6_PLLS_SHIFT 00000006

Symbol: MCG_C6_PLLS_SHIFT
   Definitions
      At line 2595 in file ..\Exercise
   Uses
      None
Comment: MCG_C6_PLLS_SHIFT unused
MCG_C6_VDIV0_MASK 0000001F

Symbol: MCG_C6_VDIV0_MASK
   Definitions
      At line 2598 in file ..\Exercise
   Uses
      None
Comment: MCG_C6_VDIV0_MASK unused
MCG_C6_VDIV0_SHIFT 00000000

Symbol: MCG_C6_VDIV0_SHIFT
   Definitions
      At line 2599 in file ..\Exercise
   Uses
      None
Comment: MCG_C6_VDIV0_SHIFT unused
MCG_IPR E000E418

Symbol: MCG_IPR
   Definitions
      At line 2690 in file ..\Exercise
   Uses
      None
Comment: MCG_IPR unused
MCG_IRQ 0000001B

Symbol: MCG_IRQ
   Definitions
      At line 2760 in file ..\Exercise
   Uses
      At line 2794 in file ..\Exercise
Comment: MCG_IRQ used once
MCG_IRQ_MASK 08000000




ARM Macro Assembler    Page 261 Alphabetic symbol ordering
Absolute symbols

Symbol: MCG_IRQ_MASK
   Definitions
      At line 2794 in file ..\Exercise
   Uses
      None
Comment: MCG_IRQ_MASK unused
MCG_IRQn 0000001B

Symbol: MCG_IRQn
   Definitions
      At line 173 in file ..\Exercise
   Uses
      None
Comment: MCG_IRQn unused
MCG_PRI_POS 0000001E

Symbol: MCG_PRI_POS
   Definitions
      At line 2726 in file ..\Exercise
   Uses
      None
Comment: MCG_PRI_POS unused
MCG_S 40064006

Symbol: MCG_S
   Definitions
      At line 2469 in file ..\Exercise
   Uses
      None
Comment: MCG_S unused
MCG_S_CLKST_MASK 0000000C

Symbol: MCG_S_CLKST_MASK
   Definitions
      At line 2627 in file ..\Exercise
   Uses
      None
Comment: MCG_S_CLKST_MASK unused
MCG_S_CLKST_SHIFT 00000002

Symbol: MCG_S_CLKST_SHIFT
   Definitions
      At line 2628 in file ..\Exercise
   Uses
      None
Comment: MCG_S_CLKST_SHIFT unused
MCG_S_IRCST_MASK 00000001

Symbol: MCG_S_IRCST_MASK
   Definitions
      At line 2631 in file ..\Exercise
   Uses
      None
Comment: MCG_S_IRCST_MASK unused
MCG_S_IRCST_SHIFT 00000000

Symbol: MCG_S_IRCST_SHIFT
   Definitions
      At line 2632 in file ..\Exercise



ARM Macro Assembler    Page 262 Alphabetic symbol ordering
Absolute symbols

   Uses
      None
Comment: MCG_S_IRCST_SHIFT unused
MCG_S_IREFST_MASK 00000010

Symbol: MCG_S_IREFST_MASK
   Definitions
      At line 2625 in file ..\Exercise
   Uses
      None
Comment: MCG_S_IREFST_MASK unused
MCG_S_IREFST_SHIFT 00000004

Symbol: MCG_S_IREFST_SHIFT
   Definitions
      At line 2626 in file ..\Exercise
   Uses
      None
Comment: MCG_S_IREFST_SHIFT unused
MCG_S_LOCK0_MASK 00000040

Symbol: MCG_S_LOCK0_MASK
   Definitions
      At line 2621 in file ..\Exercise
   Uses
      None
Comment: MCG_S_LOCK0_MASK unused
MCG_S_LOCK0_SHIFT 00000006

Symbol: MCG_S_LOCK0_SHIFT
   Definitions
      At line 2622 in file ..\Exercise
   Uses
      None
Comment: MCG_S_LOCK0_SHIFT unused
MCG_S_LOLS_MASK 00000080

Symbol: MCG_S_LOLS_MASK
   Definitions
      At line 2619 in file ..\Exercise
   Uses
      None
Comment: MCG_S_LOLS_MASK unused
MCG_S_LOLS_SHIFT 00000007

Symbol: MCG_S_LOLS_SHIFT
   Definitions
      At line 2620 in file ..\Exercise
   Uses
      None
Comment: MCG_S_LOLS_SHIFT unused
MCG_S_OFFSET 00000006

Symbol: MCG_S_OFFSET
   Definitions
      At line 2463 in file ..\Exercise
   Uses
      At line 2469 in file ..\Exercise
Comment: MCG_S_OFFSET used once



ARM Macro Assembler    Page 263 Alphabetic symbol ordering
Absolute symbols

MCG_S_OSCINIT0_MASK 00000002

Symbol: MCG_S_OSCINIT0_MASK
   Definitions
      At line 2629 in file ..\Exercise
   Uses
      None
Comment: MCG_S_OSCINIT0_MASK unused
MCG_S_OSCINIT0_SHIFT 00000001

Symbol: MCG_S_OSCINIT0_SHIFT
   Definitions
      At line 2630 in file ..\Exercise
   Uses
      None
Comment: MCG_S_OSCINIT0_SHIFT unused
MCG_S_PLLST_MASK 00000020

Symbol: MCG_S_PLLST_MASK
   Definitions
      At line 2623 in file ..\Exercise
   Uses
      None
Comment: MCG_S_PLLST_MASK unused
MCG_S_PLLST_SHIFT 00000005

Symbol: MCG_S_PLLST_SHIFT
   Definitions
      At line 2624 in file ..\Exercise
   Uses
      None
Comment: MCG_S_PLLST_SHIFT unused
MCG_Vector 0000002B

Symbol: MCG_Vector
   Definitions
      At line 2844 in file ..\Exercise
   Uses
      None
Comment: MCG_Vector unused
MCU_MEM_MAP_VERSION 00000200

Symbol: MCU_MEM_MAP_VERSION
   Definitions
      At line 181 in file ..\Exercise
   Uses
      None
Comment: MCU_MEM_MAP_VERSION unused
MCU_MEM_MAP_VERSION_MINOR 00000002

Symbol: MCU_MEM_MAP_VERSION_MINOR
   Definitions
      At line 183 in file ..\Exercise
   Uses
      None
Comment: MCU_MEM_MAP_VERSION_MINOR unused
NIBBLE_BITS 00000004

Symbol: NIBBLE_BITS



ARM Macro Assembler    Page 264 Alphabetic symbol ordering
Absolute symbols

   Definitions
      At line 27 in file ..\Exercise
   Uses
      None
Comment: NIBBLE_BITS unused
NIBBLE_MASK 0000000F

Symbol: NIBBLE_MASK
   Definitions
      At line 24 in file ..\Exercise
   Uses
      None
Comment: NIBBLE_MASK unused
NMI_Vector02 00000002

Symbol: NMI_Vector02
   Definitions
      At line 2803 in file ..\Exercise
   Uses
      None
Comment: NMI_Vector02 unused
NUM_ENQD 00000011

Symbol: NUM_ENQD
   Definitions
      At line 225 in file ..\Exercise
   Uses
      At line 298 in file ..\Exercise
      At line 456 in file ..\Exercise
      At line 472 in file ..\Exercise
      At line 477 in file ..\Exercise
      At line 479 in file ..\Exercise
      At line 521 in file ..\Exercise
      At line 529 in file ..\Exercise

NVIC_BASE E000E100

Symbol: NVIC_BASE
   Definitions
      At line 2636 in file ..\Exercise
   Uses
      At line 2649 in file ..\Exercise
      At line 2650 in file ..\Exercise
      At line 2651 in file ..\Exercise
      At line 2652 in file ..\Exercise
      At line 2653 in file ..\Exercise
      At line 2654 in file ..\Exercise
      At line 2655 in file ..\Exercise
      At line 2656 in file ..\Exercise
      At line 2657 in file ..\Exercise
      At line 2658 in file ..\Exercise
      At line 2659 in file ..\Exercise
      At line 2660 in file ..\Exercise

NVIC_ICER E000E180

Symbol: NVIC_ICER
   Definitions
      At line 2650 in file ..\Exercise



ARM Macro Assembler    Page 265 Alphabetic symbol ordering
Absolute symbols

   Uses
      None
Comment: NVIC_ICER unused
NVIC_ICER_OFFSET 00000080

Symbol: NVIC_ICER_OFFSET
   Definitions
      At line 2638 in file ..\Exercise
   Uses
      At line 2650 in file ..\Exercise
Comment: NVIC_ICER_OFFSET used once
NVIC_ICER_UART0_MASK 00001000

Symbol: NVIC_ICER_UART0_MASK
   Definitions
      At line 32 in file ..\Exercise
   Uses
      None
Comment: NVIC_ICER_UART0_MASK unused
NVIC_ICPR E000E280

Symbol: NVIC_ICPR
   Definitions
      At line 2652 in file ..\Exercise
   Uses
      At line 950 in file ..\Exercise
Comment: NVIC_ICPR used once
NVIC_ICPR_OFFSET 00000180

Symbol: NVIC_ICPR_OFFSET
   Definitions
      At line 2640 in file ..\Exercise
   Uses
      At line 2652 in file ..\Exercise
Comment: NVIC_ICPR_OFFSET used once
NVIC_ICPR_UART0_MASK 00001000

Symbol: NVIC_ICPR_UART0_MASK
   Definitions
      At line 40 in file ..\Exercise
   Uses
      At line 951 in file ..\Exercise
Comment: NVIC_ICPR_UART0_MASK used once
NVIC_IPR0 E000E400

Symbol: NVIC_IPR0
   Definitions
      At line 2653 in file ..\Exercise
   Uses
      At line 2663 in file ..\Exercise
      At line 2664 in file ..\Exercise
      At line 2665 in file ..\Exercise
      At line 2666 in file ..\Exercise

NVIC_IPR0_OFFSET 00000300

Symbol: NVIC_IPR0_OFFSET
   Definitions
      At line 2641 in file ..\Exercise



ARM Macro Assembler    Page 266 Alphabetic symbol ordering
Absolute symbols

   Uses
      At line 2653 in file ..\Exercise
Comment: NVIC_IPR0_OFFSET used once
NVIC_IPR1 E000E404

Symbol: NVIC_IPR1
   Definitions
      At line 2654 in file ..\Exercise
   Uses
      At line 2667 in file ..\Exercise
      At line 2668 in file ..\Exercise
      At line 2669 in file ..\Exercise
      At line 2670 in file ..\Exercise

NVIC_IPR1_OFFSET 00000304

Symbol: NVIC_IPR1_OFFSET
   Definitions
      At line 2642 in file ..\Exercise
   Uses
      At line 2654 in file ..\Exercise
Comment: NVIC_IPR1_OFFSET used once
NVIC_IPR2 E000E408

Symbol: NVIC_IPR2
   Definitions
      At line 2655 in file ..\Exercise
   Uses
      At line 2671 in file ..\Exercise
      At line 2672 in file ..\Exercise
      At line 2673 in file ..\Exercise
      At line 2674 in file ..\Exercise

NVIC_IPR2_OFFSET 00000308

Symbol: NVIC_IPR2_OFFSET
   Definitions
      At line 2643 in file ..\Exercise
   Uses
      At line 2655 in file ..\Exercise
Comment: NVIC_IPR2_OFFSET used once
NVIC_IPR3 E000E40C

Symbol: NVIC_IPR3
   Definitions
      At line 2656 in file ..\Exercise
   Uses
      At line 2675 in file ..\Exercise
      At line 2676 in file ..\Exercise
      At line 2677 in file ..\Exercise
      At line 2678 in file ..\Exercise

NVIC_IPR3_OFFSET 0000030C

Symbol: NVIC_IPR3_OFFSET
   Definitions
      At line 2644 in file ..\Exercise
   Uses
      At line 2656 in file ..\Exercise



ARM Macro Assembler    Page 267 Alphabetic symbol ordering
Absolute symbols

Comment: NVIC_IPR3_OFFSET used once
NVIC_IPR4 E000E410

Symbol: NVIC_IPR4
   Definitions
      At line 2657 in file ..\Exercise
   Uses
      At line 2679 in file ..\Exercise
      At line 2680 in file ..\Exercise
      At line 2681 in file ..\Exercise
      At line 2682 in file ..\Exercise

NVIC_IPR4_OFFSET 00000310

Symbol: NVIC_IPR4_OFFSET
   Definitions
      At line 2645 in file ..\Exercise
   Uses
      At line 2657 in file ..\Exercise
Comment: NVIC_IPR4_OFFSET used once
NVIC_IPR5 E000E414

Symbol: NVIC_IPR5
   Definitions
      At line 2658 in file ..\Exercise
   Uses
      At line 2683 in file ..\Exercise
      At line 2684 in file ..\Exercise
      At line 2685 in file ..\Exercise
      At line 2686 in file ..\Exercise

NVIC_IPR5_OFFSET 00000314

Symbol: NVIC_IPR5_OFFSET
   Definitions
      At line 2646 in file ..\Exercise
   Uses
      At line 2658 in file ..\Exercise
Comment: NVIC_IPR5_OFFSET used once
NVIC_IPR6 E000E418

Symbol: NVIC_IPR6
   Definitions
      At line 2659 in file ..\Exercise
   Uses
      At line 2687 in file ..\Exercise
      At line 2688 in file ..\Exercise
      At line 2689 in file ..\Exercise
      At line 2690 in file ..\Exercise

NVIC_IPR6_OFFSET 00000318

Symbol: NVIC_IPR6_OFFSET
   Definitions
      At line 2647 in file ..\Exercise
   Uses
      At line 2659 in file ..\Exercise
Comment: NVIC_IPR6_OFFSET used once
NVIC_IPR7 E000E41C



ARM Macro Assembler    Page 268 Alphabetic symbol ordering
Absolute symbols


Symbol: NVIC_IPR7
   Definitions
      At line 2660 in file ..\Exercise
   Uses
      At line 2691 in file ..\Exercise
      At line 2692 in file ..\Exercise
      At line 2693 in file ..\Exercise
      At line 2694 in file ..\Exercise

NVIC_IPR7_OFFSET 0000031C

Symbol: NVIC_IPR7_OFFSET
   Definitions
      At line 2648 in file ..\Exercise
   Uses
      At line 2660 in file ..\Exercise
Comment: NVIC_IPR7_OFFSET used once
NVIC_IPR_UART0_MASK 000000C0

Symbol: NVIC_IPR_UART0_MASK
   Definitions
      At line 45 in file ..\Exercise
   Uses
      At line 943 in file ..\Exercise
Comment: NVIC_IPR_UART0_MASK used once
NVIC_IPR_UART0_PRI_3 000000C0

Symbol: NVIC_IPR_UART0_PRI_3
   Definitions
      At line 46 in file ..\Exercise
   Uses
      At line 944 in file ..\Exercise
Comment: NVIC_IPR_UART0_PRI_3 used once
NVIC_ISER E000E100

Symbol: NVIC_ISER
   Definitions
      At line 2649 in file ..\Exercise
   Uses
      At line 355 in file ..\Exercise
      At line 954 in file ..\Exercise

NVIC_ISER_OFFSET 00000000

Symbol: NVIC_ISER_OFFSET
   Definitions
      At line 2637 in file ..\Exercise
   Uses
      At line 2649 in file ..\Exercise
Comment: NVIC_ISER_OFFSET used once
NVIC_ISER_UART0_MASK 00001000

Symbol: NVIC_ISER_UART0_MASK
   Definitions
      At line 53 in file ..\Exercise
   Uses
      At line 955 in file ..\Exercise
Comment: NVIC_ISER_UART0_MASK used once



ARM Macro Assembler    Page 269 Alphabetic symbol ordering
Absolute symbols

NVIC_ISPR E000E200

Symbol: NVIC_ISPR
   Definitions
      At line 2651 in file ..\Exercise
   Uses
      None
Comment: NVIC_ISPR unused
NVIC_ISPR_OFFSET 00000100

Symbol: NVIC_ISPR_OFFSET
   Definitions
      At line 2639 in file ..\Exercise
   Uses
      At line 2651 in file ..\Exercise
Comment: NVIC_ISPR_OFFSET used once
NonMaskableInt_IRQn FFFFFFF2

Symbol: NonMaskableInt_IRQn
   Definitions
      At line 138 in file ..\Exercise
   Uses
      None
Comment: NonMaskableInt_IRQn unused
OSC0_BASE 40065000

Symbol: OSC0_BASE
   Definitions
      At line 2851 in file ..\Exercise
   Uses
      At line 2853 in file ..\Exercise
Comment: OSC0_BASE used once
OSC0_CR 40065000

Symbol: OSC0_CR
   Definitions
      At line 2853 in file ..\Exercise
   Uses
      None
Comment: OSC0_CR unused
OSC0_CR_OFFSET 00000000

Symbol: OSC0_CR_OFFSET
   Definitions
      At line 2852 in file ..\Exercise
   Uses
      At line 2853 in file ..\Exercise
Comment: OSC0_CR_OFFSET used once
OSC_CR_ERCLKEN_MASK 00000080

Symbol: OSC_CR_ERCLKEN_MASK
   Definitions
      At line 2874 in file ..\Exercise
   Uses
      None
Comment: OSC_CR_ERCLKEN_MASK unused
OSC_CR_ERCLKEN_SHIFT 00000007

Symbol: OSC_CR_ERCLKEN_SHIFT



ARM Macro Assembler    Page 270 Alphabetic symbol ordering
Absolute symbols

   Definitions
      At line 2875 in file ..\Exercise
   Uses
      None
Comment: OSC_CR_ERCLKEN_SHIFT unused
OSC_CR_EREFSTEN_MASK 00000020

Symbol: OSC_CR_EREFSTEN_MASK
   Definitions
      At line 2872 in file ..\Exercise
   Uses
      None
Comment: OSC_CR_EREFSTEN_MASK unused
OSC_CR_EREFSTEN_SHIFT 00000005

Symbol: OSC_CR_EREFSTEN_SHIFT
   Definitions
      At line 2873 in file ..\Exercise
   Uses
      None
Comment: OSC_CR_EREFSTEN_SHIFT unused
OSC_CR_SC16P_MASK 00000001

Symbol: OSC_CR_SC16P_MASK
   Definitions
      At line 2864 in file ..\Exercise
   Uses
      None
Comment: OSC_CR_SC16P_MASK unused
OSC_CR_SC16P_SHIFT 00000000

Symbol: OSC_CR_SC16P_SHIFT
   Definitions
      At line 2865 in file ..\Exercise
   Uses
      None
Comment: OSC_CR_SC16P_SHIFT unused
OSC_CR_SC2P_MASK 00000008

Symbol: OSC_CR_SC2P_MASK
   Definitions
      At line 2870 in file ..\Exercise
   Uses
      None
Comment: OSC_CR_SC2P_MASK unused
OSC_CR_SC2P_SHIFT 00000003

Symbol: OSC_CR_SC2P_SHIFT
   Definitions
      At line 2871 in file ..\Exercise
   Uses
      None
Comment: OSC_CR_SC2P_SHIFT unused
OSC_CR_SC4P_MASK 00000004

Symbol: OSC_CR_SC4P_MASK
   Definitions
      At line 2868 in file ..\Exercise
   Uses



ARM Macro Assembler    Page 271 Alphabetic symbol ordering
Absolute symbols

      None
Comment: OSC_CR_SC4P_MASK unused
OSC_CR_SC4P_SHIFT 00000002

Symbol: OSC_CR_SC4P_SHIFT
   Definitions
      At line 2869 in file ..\Exercise
   Uses
      None
Comment: OSC_CR_SC4P_SHIFT unused
OSC_CR_SC8P_MASK 00000002

Symbol: OSC_CR_SC8P_MASK
   Definitions
      At line 2866 in file ..\Exercise
   Uses
      None
Comment: OSC_CR_SC8P_MASK unused
OSC_CR_SC8P_SHIFT 00000001

Symbol: OSC_CR_SC8P_SHIFT
   Definitions
      At line 2867 in file ..\Exercise
   Uses
      None
Comment: OSC_CR_SC8P_SHIFT unused
OUT_PTR 00000004

Symbol: OUT_PTR
   Definitions
      At line 221 in file ..\Exercise
   Uses
      At line 449 in file ..\Exercise
      At line 475 in file ..\Exercise
      At line 480 in file ..\Exercise
      At line 482 in file ..\Exercise
      At line 487 in file ..\Exercise

PIT_BASE 40037000

Symbol: PIT_BASE
   Definitions
      At line 2878 in file ..\Exercise
   Uses
      At line 2896 in file ..\Exercise
      At line 2897 in file ..\Exercise
      At line 2898 in file ..\Exercise
      At line 2899 in file ..\Exercise
      At line 2900 in file ..\Exercise
      At line 2901 in file ..\Exercise
      At line 2902 in file ..\Exercise
      At line 2903 in file ..\Exercise
      At line 2904 in file ..\Exercise
      At line 2905 in file ..\Exercise
      At line 2906 in file ..\Exercise
      At line 340 in file ..\Exercise

PIT_CH0_BASE 40037100




ARM Macro Assembler    Page 272 Alphabetic symbol ordering
Absolute symbols

Symbol: PIT_CH0_BASE
   Definitions
      At line 2879 in file ..\Exercise
   Uses
      At line 343 in file ..\Exercise
      At line 346 in file ..\Exercise
      At line 351 in file ..\Exercise
      At line 838 in file ..\Exercise

PIT_CH1_BASE 40037110

Symbol: PIT_CH1_BASE
   Definitions
      At line 2880 in file ..\Exercise
   Uses
      None
Comment: PIT_CH1_BASE unused
PIT_CVAL0 40037104

Symbol: PIT_CVAL0
   Definitions
      At line 2900 in file ..\Exercise
   Uses
      None
Comment: PIT_CVAL0 unused
PIT_CVAL0_OFFSET 00000104

Symbol: PIT_CVAL0_OFFSET
   Definitions
      At line 2889 in file ..\Exercise
   Uses
      At line 2900 in file ..\Exercise
Comment: PIT_CVAL0_OFFSET used once
PIT_CVAL1 40037114

Symbol: PIT_CVAL1
   Definitions
      At line 2904 in file ..\Exercise
   Uses
      None
Comment: PIT_CVAL1 unused
PIT_CVAL1_OFFSET 00000114

Symbol: PIT_CVAL1_OFFSET
   Definitions
      At line 2893 in file ..\Exercise
   Uses
      At line 2904 in file ..\Exercise
Comment: PIT_CVAL1_OFFSET used once
PIT_CVAL_OFFSET 00000004

Symbol: PIT_CVAL_OFFSET
   Definitions
      At line 2882 in file ..\Exercise
   Uses
      None
Comment: PIT_CVAL_OFFSET unused
PIT_IPR E000E414




ARM Macro Assembler    Page 273 Alphabetic symbol ordering
Absolute symbols

Symbol: PIT_IPR
   Definitions
      At line 2685 in file ..\Exercise
   Uses
      At line 359 in file ..\Exercise
Comment: PIT_IPR used once
PIT_IRQ 00000016

Symbol: PIT_IRQ
   Definitions
      At line 2755 in file ..\Exercise
   Uses
      At line 2789 in file ..\Exercise
Comment: PIT_IRQ used once
PIT_IRQ_MASK 00400000

Symbol: PIT_IRQ_MASK
   Definitions
      At line 2789 in file ..\Exercise
   Uses
      At line 356 in file ..\Exercise
Comment: PIT_IRQ_MASK used once
PIT_IRQ_PRI 00000000

Symbol: PIT_IRQ_PRI
   Definitions
      At line 74 in file ..\Exercise
   Uses
      At line 360 in file ..\Exercise
Comment: PIT_IRQ_PRI used once
PIT_IRQn 00000016

Symbol: PIT_IRQn
   Definitions
      At line 168 in file ..\Exercise
   Uses
      None
Comment: PIT_IRQn unused
PIT_LDVAL0 40037100

Symbol: PIT_LDVAL0
   Definitions
      At line 2899 in file ..\Exercise
   Uses
      None
Comment: PIT_LDVAL0 unused
PIT_LDVAL0_OFFSET 00000100

Symbol: PIT_LDVAL0_OFFSET
   Definitions
      At line 2888 in file ..\Exercise
   Uses
      At line 2899 in file ..\Exercise
Comment: PIT_LDVAL0_OFFSET used once
PIT_LDVAL1 40037110

Symbol: PIT_LDVAL1
   Definitions
      At line 2903 in file ..\Exercise



ARM Macro Assembler    Page 274 Alphabetic symbol ordering
Absolute symbols

   Uses
      None
Comment: PIT_LDVAL1 unused
PIT_LDVAL1_OFFSET 00000110

Symbol: PIT_LDVAL1_OFFSET
   Definitions
      At line 2892 in file ..\Exercise
   Uses
      At line 2903 in file ..\Exercise
Comment: PIT_LDVAL1_OFFSET used once
PIT_LDVAL_10ms 0003A97F

Symbol: PIT_LDVAL_10ms
   Definitions
      At line 60 in file ..\Exercise
   Uses
      At line 344 in file ..\Exercise
Comment: PIT_LDVAL_10ms used once
PIT_LDVAL_OFFSET 00000000

Symbol: PIT_LDVAL_OFFSET
   Definitions
      At line 2881 in file ..\Exercise
   Uses
      At line 345 in file ..\Exercise
Comment: PIT_LDVAL_OFFSET used once
PIT_LTMR64H 400370E0

Symbol: PIT_LTMR64H
   Definitions
      At line 2897 in file ..\Exercise
   Uses
      None
Comment: PIT_LTMR64H unused
PIT_LTMR64H_OFFSET 000000E0

Symbol: PIT_LTMR64H_OFFSET
   Definitions
      At line 2886 in file ..\Exercise
   Uses
      At line 2897 in file ..\Exercise
Comment: PIT_LTMR64H_OFFSET used once
PIT_LTMR64L 400370E4

Symbol: PIT_LTMR64L
   Definitions
      At line 2898 in file ..\Exercise
   Uses
      None
Comment: PIT_LTMR64L unused
PIT_LTMR64L_OFFSET 000000E4

Symbol: PIT_LTMR64L_OFFSET
   Definitions
      At line 2887 in file ..\Exercise
   Uses
      At line 2898 in file ..\Exercise
Comment: PIT_LTMR64L_OFFSET used once



ARM Macro Assembler    Page 275 Alphabetic symbol ordering
Absolute symbols

PIT_MCR 40037000

Symbol: PIT_MCR
   Definitions
      At line 2896 in file ..\Exercise
   Uses
      None
Comment: PIT_MCR unused
PIT_MCR_EN_FRZ 00000001

Symbol: PIT_MCR_EN_FRZ
   Definitions
      At line 67 in file ..\Exercise
   Uses
      At line 341 in file ..\Exercise
Comment: PIT_MCR_EN_FRZ used once
PIT_MCR_FRZ_MASK 00000001

Symbol: PIT_MCR_FRZ_MASK
   Definitions
      At line 2935 in file ..\Exercise
   Uses
      At line 67 in file ..\Exercise
Comment: PIT_MCR_FRZ_MASK used once
PIT_MCR_FRZ_SHIFT 00000000

Symbol: PIT_MCR_FRZ_SHIFT
   Definitions
      At line 2936 in file ..\Exercise
   Uses
      None
Comment: PIT_MCR_FRZ_SHIFT unused
PIT_MCR_MDIS_MASK 00000002

Symbol: PIT_MCR_MDIS_MASK
   Definitions
      At line 2933 in file ..\Exercise
   Uses
      None
Comment: PIT_MCR_MDIS_MASK unused
PIT_MCR_MDIS_SHIFT 00000001

Symbol: PIT_MCR_MDIS_SHIFT
   Definitions
      At line 2934 in file ..\Exercise
   Uses
      None
Comment: PIT_MCR_MDIS_SHIFT unused
PIT_MCR_OFFSET 00000000

Symbol: PIT_MCR_OFFSET
   Definitions
      At line 2885 in file ..\Exercise
   Uses
      At line 2896 in file ..\Exercise
      At line 342 in file ..\Exercise

PIT_PRI_POS 00000016




ARM Macro Assembler    Page 276 Alphabetic symbol ordering
Absolute symbols

Symbol: PIT_PRI_POS
   Definitions
      At line 2721 in file ..\Exercise
   Uses
      At line 360 in file ..\Exercise
Comment: PIT_PRI_POS used once
PIT_TCTRL0 40037108

Symbol: PIT_TCTRL0
   Definitions
      At line 2901 in file ..\Exercise
   Uses
      None
Comment: PIT_TCTRL0 unused
PIT_TCTRL0_OFFSET 00000108

Symbol: PIT_TCTRL0_OFFSET
   Definitions
      At line 2890 in file ..\Exercise
   Uses
      At line 2901 in file ..\Exercise
Comment: PIT_TCTRL0_OFFSET used once
PIT_TCTRL1 40037118

Symbol: PIT_TCTRL1
   Definitions
      At line 2905 in file ..\Exercise
   Uses
      None
Comment: PIT_TCTRL1 unused
PIT_TCTRL1_OFFSET 00000118

Symbol: PIT_TCTRL1_OFFSET
   Definitions
      At line 2894 in file ..\Exercise
   Uses
      At line 2905 in file ..\Exercise
Comment: PIT_TCTRL1_OFFSET used once
PIT_TCTRL_CHN_MASK 00000004

Symbol: PIT_TCTRL_CHN_MASK
   Definitions
      At line 2946 in file ..\Exercise
   Uses
      None
Comment: PIT_TCTRL_CHN_MASK unused
PIT_TCTRL_CHN_SHIFT 00000002

Symbol: PIT_TCTRL_CHN_SHIFT
   Definitions
      At line 2947 in file ..\Exercise
   Uses
      None
Comment: PIT_TCTRL_CHN_SHIFT unused
PIT_TCTRL_CH_IE 00000003

Symbol: PIT_TCTRL_CH_IE
   Definitions
      At line 73 in file ..\Exercise



ARM Macro Assembler    Page 277 Alphabetic symbol ordering
Absolute symbols

   Uses
      At line 352 in file ..\Exercise
Comment: PIT_TCTRL_CH_IE used once
PIT_TCTRL_OFFSET 00000008

Symbol: PIT_TCTRL_OFFSET
   Definitions
      At line 2883 in file ..\Exercise
   Uses
      At line 348 in file ..\Exercise
      At line 350 in file ..\Exercise
      At line 353 in file ..\Exercise

PIT_TCTRL_TEN_MASK 00000001

Symbol: PIT_TCTRL_TEN_MASK
   Definitions
      At line 2950 in file ..\Exercise
   Uses
      At line 73 in file ..\Exercise
      At line 347 in file ..\Exercise

PIT_TCTRL_TEN_SHIFT 00000000

Symbol: PIT_TCTRL_TEN_SHIFT
   Definitions
      At line 2951 in file ..\Exercise
   Uses
      None
Comment: PIT_TCTRL_TEN_SHIFT unused
PIT_TCTRL_TIE_MASK 00000002

Symbol: PIT_TCTRL_TIE_MASK
   Definitions
      At line 2948 in file ..\Exercise
   Uses
      At line 73 in file ..\Exercise
Comment: PIT_TCTRL_TIE_MASK used once
PIT_TCTRL_TIE_SHIFT 00000001

Symbol: PIT_TCTRL_TIE_SHIFT
   Definitions
      At line 2949 in file ..\Exercise
   Uses
      None
Comment: PIT_TCTRL_TIE_SHIFT unused
PIT_TFLG0 4003710C

Symbol: PIT_TFLG0
   Definitions
      At line 2902 in file ..\Exercise
   Uses
      None
Comment: PIT_TFLG0 unused
PIT_TFLG0_OFFSET 0000010C

Symbol: PIT_TFLG0_OFFSET
   Definitions
      At line 2891 in file ..\Exercise



ARM Macro Assembler    Page 278 Alphabetic symbol ordering
Absolute symbols

   Uses
      At line 2902 in file ..\Exercise
Comment: PIT_TFLG0_OFFSET used once
PIT_TFLG1 4003711C

Symbol: PIT_TFLG1
   Definitions
      At line 2906 in file ..\Exercise
   Uses
      None
Comment: PIT_TFLG1 unused
PIT_TFLG1_OFFSET 0000011C

Symbol: PIT_TFLG1_OFFSET
   Definitions
      At line 2895 in file ..\Exercise
   Uses
      At line 2906 in file ..\Exercise
Comment: PIT_TFLG1_OFFSET used once
PIT_TFLG_OFFSET 0000000C

Symbol: PIT_TFLG_OFFSET
   Definitions
      At line 2884 in file ..\Exercise
   Uses
      At line 840 in file ..\Exercise
Comment: PIT_TFLG_OFFSET used once
PIT_TFLG_TIF_MASK 00000001

Symbol: PIT_TFLG_TIF_MASK
   Definitions
      At line 2957 in file ..\Exercise
   Uses
      At line 839 in file ..\Exercise
Comment: PIT_TFLG_TIF_MASK used once
PIT_TFLG_TIF_SHIFT 00000000

Symbol: PIT_TFLG_TIF_SHIFT
   Definitions
      At line 2958 in file ..\Exercise
   Uses
      None
Comment: PIT_TFLG_TIF_SHIFT unused
PIT_Vector 00000026

Symbol: PIT_Vector
   Definitions
      At line 2839 in file ..\Exercise
   Uses
      None
Comment: PIT_Vector unused
PMC_IPR E000E404

Symbol: PMC_IPR
   Definitions
      At line 2669 in file ..\Exercise
   Uses
      None
Comment: PMC_IPR unused



ARM Macro Assembler    Page 279 Alphabetic symbol ordering
Absolute symbols

PMC_IRQ 00000006

Symbol: PMC_IRQ
   Definitions
      At line 2739 in file ..\Exercise
   Uses
      At line 2773 in file ..\Exercise
Comment: PMC_IRQ used once
PMC_IRQ_MASK 00000040

Symbol: PMC_IRQ_MASK
   Definitions
      At line 2773 in file ..\Exercise
   Uses
      None
Comment: PMC_IRQ_MASK unused
PMC_PRI_POS 00000016

Symbol: PMC_PRI_POS
   Definitions
      At line 2705 in file ..\Exercise
   Uses
      None
Comment: PMC_PRI_POS unused
PMC_Vector 00000016

Symbol: PMC_Vector
   Definitions
      At line 2823 in file ..\Exercise
   Uses
      None
Comment: PMC_Vector unused
PORTA_BASE 40049000

Symbol: PORTA_BASE
   Definitions
      At line 3020 in file ..\Exercise
   Uses
      At line 3056 in file ..\Exercise
      At line 3057 in file ..\Exercise
      At line 3058 in file ..\Exercise
      At line 3059 in file ..\Exercise
      At line 3060 in file ..\Exercise
      At line 3061 in file ..\Exercise
      At line 3062 in file ..\Exercise
      At line 3063 in file ..\Exercise
      At line 3064 in file ..\Exercise
      At line 3065 in file ..\Exercise
      At line 3066 in file ..\Exercise
      At line 3067 in file ..\Exercise
      At line 3068 in file ..\Exercise
      At line 3069 in file ..\Exercise
      At line 3070 in file ..\Exercise
      At line 3071 in file ..\Exercise
      At line 3072 in file ..\Exercise
      At line 3073 in file ..\Exercise
      At line 3074 in file ..\Exercise
      At line 3075 in file ..\Exercise
      At line 3076 in file ..\Exercise



ARM Macro Assembler    Page 280 Alphabetic symbol ordering
Absolute symbols

      At line 3077 in file ..\Exercise
      At line 3078 in file ..\Exercise
      At line 3079 in file ..\Exercise
      At line 3080 in file ..\Exercise
      At line 3081 in file ..\Exercise
      At line 3082 in file ..\Exercise
      At line 3083 in file ..\Exercise
      At line 3084 in file ..\Exercise
      At line 3085 in file ..\Exercise
      At line 3086 in file ..\Exercise
      At line 3087 in file ..\Exercise
      At line 3088 in file ..\Exercise
      At line 3089 in file ..\Exercise
      At line 3090 in file ..\Exercise

PORTA_GPCHR 40049084

Symbol: PORTA_GPCHR
   Definitions
      At line 3089 in file ..\Exercise
   Uses
      None
Comment: PORTA_GPCHR unused
PORTA_GPCHR_OFFSET 00000084

Symbol: PORTA_GPCHR_OFFSET
   Definitions
      At line 3054 in file ..\Exercise
   Uses
      At line 3089 in file ..\Exercise
Comment: PORTA_GPCHR_OFFSET used once
PORTA_GPCLR 40049080

Symbol: PORTA_GPCLR
   Definitions
      At line 3088 in file ..\Exercise
   Uses
      None
Comment: PORTA_GPCLR unused
PORTA_GPCLR_OFFSET 00000080

Symbol: PORTA_GPCLR_OFFSET
   Definitions
      At line 3053 in file ..\Exercise
   Uses
      At line 3088 in file ..\Exercise
Comment: PORTA_GPCLR_OFFSET used once
PORTA_IPR E000E41C

Symbol: PORTA_IPR
   Definitions
      At line 2693 in file ..\Exercise
   Uses
      None
Comment: PORTA_IPR unused
PORTA_IRQ 0000001E

Symbol: PORTA_IRQ
   Definitions



ARM Macro Assembler    Page 281 Alphabetic symbol ordering
Absolute symbols

      At line 2763 in file ..\Exercise
   Uses
      At line 2797 in file ..\Exercise
Comment: PORTA_IRQ used once
PORTA_IRQ_MASK 40000000

Symbol: PORTA_IRQ_MASK
   Definitions
      At line 2797 in file ..\Exercise
   Uses
      None
Comment: PORTA_IRQ_MASK unused
PORTA_IRQn 0000001E

Symbol: PORTA_IRQn
   Definitions
      At line 176 in file ..\Exercise
   Uses
      None
Comment: PORTA_IRQn unused
PORTA_ISFR 400490A0

Symbol: PORTA_ISFR
   Definitions
      At line 3090 in file ..\Exercise
   Uses
      None
Comment: PORTA_ISFR unused
PORTA_ISFR_OFFSET 000000A0

Symbol: PORTA_ISFR_OFFSET
   Definitions
      At line 3055 in file ..\Exercise
   Uses
      At line 3090 in file ..\Exercise
Comment: PORTA_ISFR_OFFSET used once
PORTA_PCR0 40049000

Symbol: PORTA_PCR0
   Definitions
      At line 3056 in file ..\Exercise
   Uses
      None
Comment: PORTA_PCR0 unused
PORTA_PCR0_OFFSET 00000000

Symbol: PORTA_PCR0_OFFSET
   Definitions
      At line 3021 in file ..\Exercise
   Uses
      At line 3056 in file ..\Exercise
Comment: PORTA_PCR0_OFFSET used once
PORTA_PCR1 40049004

Symbol: PORTA_PCR1
   Definitions
      At line 3057 in file ..\Exercise
   Uses
      At line 927 in file ..\Exercise



ARM Macro Assembler    Page 282 Alphabetic symbol ordering
Absolute symbols

Comment: PORTA_PCR1 used once
PORTA_PCR10 40049028

Symbol: PORTA_PCR10
   Definitions
      At line 3066 in file ..\Exercise
   Uses
      None
Comment: PORTA_PCR10 unused
PORTA_PCR10_OFFSET 00000028

Symbol: PORTA_PCR10_OFFSET
   Definitions
      At line 3031 in file ..\Exercise
   Uses
      At line 3066 in file ..\Exercise
Comment: PORTA_PCR10_OFFSET used once
PORTA_PCR11 4004902C

Symbol: PORTA_PCR11
   Definitions
      At line 3067 in file ..\Exercise
   Uses
      None
Comment: PORTA_PCR11 unused
PORTA_PCR11_OFFSET 0000002C

Symbol: PORTA_PCR11_OFFSET
   Definitions
      At line 3032 in file ..\Exercise
   Uses
      At line 3067 in file ..\Exercise
Comment: PORTA_PCR11_OFFSET used once
PORTA_PCR12 40049030

Symbol: PORTA_PCR12
   Definitions
      At line 3068 in file ..\Exercise
   Uses
      None
Comment: PORTA_PCR12 unused
PORTA_PCR12_OFFSET 00000030

Symbol: PORTA_PCR12_OFFSET
   Definitions
      At line 3033 in file ..\Exercise
   Uses
      At line 3068 in file ..\Exercise
Comment: PORTA_PCR12_OFFSET used once
PORTA_PCR13 40049034

Symbol: PORTA_PCR13
   Definitions
      At line 3069 in file ..\Exercise
   Uses
      None
Comment: PORTA_PCR13 unused
PORTA_PCR13_OFFSET 00000034




ARM Macro Assembler    Page 283 Alphabetic symbol ordering
Absolute symbols

Symbol: PORTA_PCR13_OFFSET
   Definitions
      At line 3034 in file ..\Exercise
   Uses
      At line 3069 in file ..\Exercise
Comment: PORTA_PCR13_OFFSET used once
PORTA_PCR14 40049038

Symbol: PORTA_PCR14
   Definitions
      At line 3070 in file ..\Exercise
   Uses
      None
Comment: PORTA_PCR14 unused
PORTA_PCR14_OFFSET 00000038

Symbol: PORTA_PCR14_OFFSET
   Definitions
      At line 3035 in file ..\Exercise
   Uses
      At line 3070 in file ..\Exercise
Comment: PORTA_PCR14_OFFSET used once
PORTA_PCR15 4004903C

Symbol: PORTA_PCR15
   Definitions
      At line 3071 in file ..\Exercise
   Uses
      None
Comment: PORTA_PCR15 unused
PORTA_PCR15_OFFSET 0000003C

Symbol: PORTA_PCR15_OFFSET
   Definitions
      At line 3036 in file ..\Exercise
   Uses
      At line 3071 in file ..\Exercise
Comment: PORTA_PCR15_OFFSET used once
PORTA_PCR16 40049040

Symbol: PORTA_PCR16
   Definitions
      At line 3072 in file ..\Exercise
   Uses
      None
Comment: PORTA_PCR16 unused
PORTA_PCR16_OFFSET 00000040

Symbol: PORTA_PCR16_OFFSET
   Definitions
      At line 3037 in file ..\Exercise
   Uses
      At line 3072 in file ..\Exercise
Comment: PORTA_PCR16_OFFSET used once
PORTA_PCR17 40049044

Symbol: PORTA_PCR17
   Definitions
      At line 3073 in file ..\Exercise



ARM Macro Assembler    Page 284 Alphabetic symbol ordering
Absolute symbols

   Uses
      None
Comment: PORTA_PCR17 unused
PORTA_PCR17_OFFSET 00000044

Symbol: PORTA_PCR17_OFFSET
   Definitions
      At line 3038 in file ..\Exercise
   Uses
      At line 3073 in file ..\Exercise
Comment: PORTA_PCR17_OFFSET used once
PORTA_PCR18 40049048

Symbol: PORTA_PCR18
   Definitions
      At line 3074 in file ..\Exercise
   Uses
      None
Comment: PORTA_PCR18 unused
PORTA_PCR18_OFFSET 00000048

Symbol: PORTA_PCR18_OFFSET
   Definitions
      At line 3039 in file ..\Exercise
   Uses
      At line 3074 in file ..\Exercise
Comment: PORTA_PCR18_OFFSET used once
PORTA_PCR19 4004904C

Symbol: PORTA_PCR19
   Definitions
      At line 3075 in file ..\Exercise
   Uses
      None
Comment: PORTA_PCR19 unused
PORTA_PCR19_OFFSET 0000004C

Symbol: PORTA_PCR19_OFFSET
   Definitions
      At line 3040 in file ..\Exercise
   Uses
      At line 3075 in file ..\Exercise
Comment: PORTA_PCR19_OFFSET used once
PORTA_PCR1_OFFSET 00000004

Symbol: PORTA_PCR1_OFFSET
   Definitions
      At line 3022 in file ..\Exercise
   Uses
      At line 3057 in file ..\Exercise
Comment: PORTA_PCR1_OFFSET used once
PORTA_PCR2 40049008

Symbol: PORTA_PCR2
   Definitions
      At line 3058 in file ..\Exercise
   Uses
      At line 931 in file ..\Exercise
Comment: PORTA_PCR2 used once



ARM Macro Assembler    Page 285 Alphabetic symbol ordering
Absolute symbols

PORTA_PCR20 40049050

Symbol: PORTA_PCR20
   Definitions
      At line 3076 in file ..\Exercise
   Uses
      None
Comment: PORTA_PCR20 unused
PORTA_PCR20_OFFSET 00000050

Symbol: PORTA_PCR20_OFFSET
   Definitions
      At line 3041 in file ..\Exercise
   Uses
      At line 3076 in file ..\Exercise
Comment: PORTA_PCR20_OFFSET used once
PORTA_PCR21 40049054

Symbol: PORTA_PCR21
   Definitions
      At line 3077 in file ..\Exercise
   Uses
      None
Comment: PORTA_PCR21 unused
PORTA_PCR21_OFFSET 00000054

Symbol: PORTA_PCR21_OFFSET
   Definitions
      At line 3042 in file ..\Exercise
   Uses
      At line 3077 in file ..\Exercise
Comment: PORTA_PCR21_OFFSET used once
PORTA_PCR22 40049058

Symbol: PORTA_PCR22
   Definitions
      At line 3078 in file ..\Exercise
   Uses
      None
Comment: PORTA_PCR22 unused
PORTA_PCR22_OFFSET 00000058

Symbol: PORTA_PCR22_OFFSET
   Definitions
      At line 3043 in file ..\Exercise
   Uses
      At line 3078 in file ..\Exercise
Comment: PORTA_PCR22_OFFSET used once
PORTA_PCR23 4004905C

Symbol: PORTA_PCR23
   Definitions
      At line 3079 in file ..\Exercise
   Uses
      None
Comment: PORTA_PCR23 unused
PORTA_PCR23_OFFSET 0000005C

Symbol: PORTA_PCR23_OFFSET



ARM Macro Assembler    Page 286 Alphabetic symbol ordering
Absolute symbols

   Definitions
      At line 3044 in file ..\Exercise
   Uses
      At line 3079 in file ..\Exercise
Comment: PORTA_PCR23_OFFSET used once
PORTA_PCR24 40049060

Symbol: PORTA_PCR24
   Definitions
      At line 3080 in file ..\Exercise
   Uses
      None
Comment: PORTA_PCR24 unused
PORTA_PCR24_OFFSET 00000060

Symbol: PORTA_PCR24_OFFSET
   Definitions
      At line 3045 in file ..\Exercise
   Uses
      At line 3080 in file ..\Exercise
Comment: PORTA_PCR24_OFFSET used once
PORTA_PCR25 40049064

Symbol: PORTA_PCR25
   Definitions
      At line 3081 in file ..\Exercise
   Uses
      None
Comment: PORTA_PCR25 unused
PORTA_PCR25_OFFSET 00000064

Symbol: PORTA_PCR25_OFFSET
   Definitions
      At line 3046 in file ..\Exercise
   Uses
      At line 3081 in file ..\Exercise
Comment: PORTA_PCR25_OFFSET used once
PORTA_PCR26 40049068

Symbol: PORTA_PCR26
   Definitions
      At line 3082 in file ..\Exercise
   Uses
      None
Comment: PORTA_PCR26 unused
PORTA_PCR26_OFFSET 00000068

Symbol: PORTA_PCR26_OFFSET
   Definitions
      At line 3047 in file ..\Exercise
   Uses
      At line 3082 in file ..\Exercise
Comment: PORTA_PCR26_OFFSET used once
PORTA_PCR27 4004906C

Symbol: PORTA_PCR27
   Definitions
      At line 3083 in file ..\Exercise
   Uses



ARM Macro Assembler    Page 287 Alphabetic symbol ordering
Absolute symbols

      None
Comment: PORTA_PCR27 unused
PORTA_PCR27_OFFSET 0000006C

Symbol: PORTA_PCR27_OFFSET
   Definitions
      At line 3048 in file ..\Exercise
   Uses
      At line 3083 in file ..\Exercise
Comment: PORTA_PCR27_OFFSET used once
PORTA_PCR28 40049070

Symbol: PORTA_PCR28
   Definitions
      At line 3084 in file ..\Exercise
   Uses
      None
Comment: PORTA_PCR28 unused
PORTA_PCR28_OFFSET 00000070

Symbol: PORTA_PCR28_OFFSET
   Definitions
      At line 3049 in file ..\Exercise
   Uses
      At line 3084 in file ..\Exercise
Comment: PORTA_PCR28_OFFSET used once
PORTA_PCR29 40049074

Symbol: PORTA_PCR29
   Definitions
      At line 3085 in file ..\Exercise
   Uses
      None
Comment: PORTA_PCR29 unused
PORTA_PCR29_OFFSET 00000074

Symbol: PORTA_PCR29_OFFSET
   Definitions
      At line 3050 in file ..\Exercise
   Uses
      At line 3085 in file ..\Exercise
Comment: PORTA_PCR29_OFFSET used once
PORTA_PCR2_OFFSET 00000008

Symbol: PORTA_PCR2_OFFSET
   Definitions
      At line 3023 in file ..\Exercise
   Uses
      At line 3058 in file ..\Exercise
Comment: PORTA_PCR2_OFFSET used once
PORTA_PCR3 4004900C

Symbol: PORTA_PCR3
   Definitions
      At line 3059 in file ..\Exercise
   Uses
      None
Comment: PORTA_PCR3 unused
PORTA_PCR30 40049078



ARM Macro Assembler    Page 288 Alphabetic symbol ordering
Absolute symbols


Symbol: PORTA_PCR30
   Definitions
      At line 3086 in file ..\Exercise
   Uses
      None
Comment: PORTA_PCR30 unused
PORTA_PCR30_OFFSET 00000078

Symbol: PORTA_PCR30_OFFSET
   Definitions
      At line 3051 in file ..\Exercise
   Uses
      At line 3086 in file ..\Exercise
Comment: PORTA_PCR30_OFFSET used once
PORTA_PCR31 4004907C

Symbol: PORTA_PCR31
   Definitions
      At line 3087 in file ..\Exercise
   Uses
      None
Comment: PORTA_PCR31 unused
PORTA_PCR31_OFFSET 0000007C

Symbol: PORTA_PCR31_OFFSET
   Definitions
      At line 3052 in file ..\Exercise
   Uses
      At line 3087 in file ..\Exercise
Comment: PORTA_PCR31_OFFSET used once
PORTA_PCR3_OFFSET 0000000C

Symbol: PORTA_PCR3_OFFSET
   Definitions
      At line 3024 in file ..\Exercise
   Uses
      At line 3059 in file ..\Exercise
Comment: PORTA_PCR3_OFFSET used once
PORTA_PCR4 40049010

Symbol: PORTA_PCR4
   Definitions
      At line 3060 in file ..\Exercise
   Uses
      None
Comment: PORTA_PCR4 unused
PORTA_PCR4_OFFSET 00000010

Symbol: PORTA_PCR4_OFFSET
   Definitions
      At line 3025 in file ..\Exercise
   Uses
      At line 3060 in file ..\Exercise
Comment: PORTA_PCR4_OFFSET used once
PORTA_PCR5 40049014

Symbol: PORTA_PCR5
   Definitions



ARM Macro Assembler    Page 289 Alphabetic symbol ordering
Absolute symbols

      At line 3061 in file ..\Exercise
   Uses
      None
Comment: PORTA_PCR5 unused
PORTA_PCR5_OFFSET 00000014

Symbol: PORTA_PCR5_OFFSET
   Definitions
      At line 3026 in file ..\Exercise
   Uses
      At line 3061 in file ..\Exercise
Comment: PORTA_PCR5_OFFSET used once
PORTA_PCR6 40049018

Symbol: PORTA_PCR6
   Definitions
      At line 3062 in file ..\Exercise
   Uses
      None
Comment: PORTA_PCR6 unused
PORTA_PCR6_OFFSET 00000018

Symbol: PORTA_PCR6_OFFSET
   Definitions
      At line 3027 in file ..\Exercise
   Uses
      At line 3062 in file ..\Exercise
Comment: PORTA_PCR6_OFFSET used once
PORTA_PCR7 4004901C

Symbol: PORTA_PCR7
   Definitions
      At line 3063 in file ..\Exercise
   Uses
      None
Comment: PORTA_PCR7 unused
PORTA_PCR7_OFFSET 0000001C

Symbol: PORTA_PCR7_OFFSET
   Definitions
      At line 3028 in file ..\Exercise
   Uses
      At line 3063 in file ..\Exercise
Comment: PORTA_PCR7_OFFSET used once
PORTA_PCR8 40049020

Symbol: PORTA_PCR8
   Definitions
      At line 3064 in file ..\Exercise
   Uses
      None
Comment: PORTA_PCR8 unused
PORTA_PCR8_OFFSET 00000020

Symbol: PORTA_PCR8_OFFSET
   Definitions
      At line 3029 in file ..\Exercise
   Uses
      At line 3064 in file ..\Exercise



ARM Macro Assembler    Page 290 Alphabetic symbol ordering
Absolute symbols

Comment: PORTA_PCR8_OFFSET used once
PORTA_PCR9 40049024

Symbol: PORTA_PCR9
   Definitions
      At line 3065 in file ..\Exercise
   Uses
      None
Comment: PORTA_PCR9 unused
PORTA_PCR9_OFFSET 00000024

Symbol: PORTA_PCR9_OFFSET
   Definitions
      At line 3030 in file ..\Exercise
   Uses
      At line 3065 in file ..\Exercise
Comment: PORTA_PCR9_OFFSET used once
PORTA_PRI_POS 00000016

Symbol: PORTA_PRI_POS
   Definitions
      At line 2729 in file ..\Exercise
   Uses
      None
Comment: PORTA_PRI_POS unused
PORTA_Vector 0000002E

Symbol: PORTA_Vector
   Definitions
      At line 2847 in file ..\Exercise
   Uses
      None
Comment: PORTA_Vector unused
PORTB_BASE 4004A000

Symbol: PORTB_BASE
   Definitions
      At line 3093 in file ..\Exercise
   Uses
      At line 3129 in file ..\Exercise
      At line 3130 in file ..\Exercise
      At line 3131 in file ..\Exercise
      At line 3132 in file ..\Exercise
      At line 3133 in file ..\Exercise
      At line 3134 in file ..\Exercise
      At line 3135 in file ..\Exercise
      At line 3136 in file ..\Exercise
      At line 3137 in file ..\Exercise
      At line 3138 in file ..\Exercise
      At line 3139 in file ..\Exercise
      At line 3140 in file ..\Exercise
      At line 3141 in file ..\Exercise
      At line 3142 in file ..\Exercise
      At line 3143 in file ..\Exercise
      At line 3144 in file ..\Exercise
      At line 3145 in file ..\Exercise
      At line 3146 in file ..\Exercise
      At line 3147 in file ..\Exercise
      At line 3148 in file ..\Exercise



ARM Macro Assembler    Page 291 Alphabetic symbol ordering
Absolute symbols

      At line 3149 in file ..\Exercise
      At line 3150 in file ..\Exercise
      At line 3151 in file ..\Exercise
      At line 3152 in file ..\Exercise
      At line 3153 in file ..\Exercise
      At line 3154 in file ..\Exercise
      At line 3155 in file ..\Exercise
      At line 3156 in file ..\Exercise
      At line 3157 in file ..\Exercise
      At line 3158 in file ..\Exercise
      At line 3159 in file ..\Exercise
      At line 3160 in file ..\Exercise
      At line 3161 in file ..\Exercise
      At line 3162 in file ..\Exercise
      At line 3163 in file ..\Exercise

PORTB_GPCHR 4004A084

Symbol: PORTB_GPCHR
   Definitions
      At line 3162 in file ..\Exercise
   Uses
      None
Comment: PORTB_GPCHR unused
PORTB_GPCHR_OFFSET 00000084

Symbol: PORTB_GPCHR_OFFSET
   Definitions
      At line 3127 in file ..\Exercise
   Uses
      At line 3162 in file ..\Exercise
Comment: PORTB_GPCHR_OFFSET used once
PORTB_GPCLR 4004A080

Symbol: PORTB_GPCLR
   Definitions
      At line 3161 in file ..\Exercise
   Uses
      None
Comment: PORTB_GPCLR unused
PORTB_GPCLR_OFFSET 00000080

Symbol: PORTB_GPCLR_OFFSET
   Definitions
      At line 3126 in file ..\Exercise
   Uses
      At line 3161 in file ..\Exercise
Comment: PORTB_GPCLR_OFFSET used once
PORTB_ISFR 4004A0A0

Symbol: PORTB_ISFR
   Definitions
      At line 3163 in file ..\Exercise
   Uses
      None
Comment: PORTB_ISFR unused
PORTB_ISFR_OFFSET 000000A0

Symbol: PORTB_ISFR_OFFSET



ARM Macro Assembler    Page 292 Alphabetic symbol ordering
Absolute symbols

   Definitions
      At line 3128 in file ..\Exercise
   Uses
      At line 3163 in file ..\Exercise
Comment: PORTB_ISFR_OFFSET used once
PORTB_PCR0 4004A000

Symbol: PORTB_PCR0
   Definitions
      At line 3129 in file ..\Exercise
   Uses
      None
Comment: PORTB_PCR0 unused
PORTB_PCR0_OFFSET 00000000

Symbol: PORTB_PCR0_OFFSET
   Definitions
      At line 3094 in file ..\Exercise
   Uses
      At line 3129 in file ..\Exercise
Comment: PORTB_PCR0_OFFSET used once
PORTB_PCR1 4004A004

Symbol: PORTB_PCR1
   Definitions
      At line 3130 in file ..\Exercise
   Uses
      None
Comment: PORTB_PCR1 unused
PORTB_PCR10 4004A028

Symbol: PORTB_PCR10
   Definitions
      At line 3139 in file ..\Exercise
   Uses
      None
Comment: PORTB_PCR10 unused
PORTB_PCR10_OFFSET 00000028

Symbol: PORTB_PCR10_OFFSET
   Definitions
      At line 3104 in file ..\Exercise
   Uses
      At line 3139 in file ..\Exercise
Comment: PORTB_PCR10_OFFSET used once
PORTB_PCR11 4004A02C

Symbol: PORTB_PCR11
   Definitions
      At line 3140 in file ..\Exercise
   Uses
      None
Comment: PORTB_PCR11 unused
PORTB_PCR11_OFFSET 0000002C

Symbol: PORTB_PCR11_OFFSET
   Definitions
      At line 3105 in file ..\Exercise
   Uses



ARM Macro Assembler    Page 293 Alphabetic symbol ordering
Absolute symbols

      At line 3140 in file ..\Exercise
Comment: PORTB_PCR11_OFFSET used once
PORTB_PCR12 4004A030

Symbol: PORTB_PCR12
   Definitions
      At line 3141 in file ..\Exercise
   Uses
      None
Comment: PORTB_PCR12 unused
PORTB_PCR12_OFFSET 00000030

Symbol: PORTB_PCR12_OFFSET
   Definitions
      At line 3106 in file ..\Exercise
   Uses
      At line 3141 in file ..\Exercise
Comment: PORTB_PCR12_OFFSET used once
PORTB_PCR13 4004A034

Symbol: PORTB_PCR13
   Definitions
      At line 3142 in file ..\Exercise
   Uses
      None
Comment: PORTB_PCR13 unused
PORTB_PCR13_OFFSET 00000034

Symbol: PORTB_PCR13_OFFSET
   Definitions
      At line 3107 in file ..\Exercise
   Uses
      At line 3142 in file ..\Exercise
Comment: PORTB_PCR13_OFFSET used once
PORTB_PCR14 4004A038

Symbol: PORTB_PCR14
   Definitions
      At line 3143 in file ..\Exercise
   Uses
      None
Comment: PORTB_PCR14 unused
PORTB_PCR14_OFFSET 00000038

Symbol: PORTB_PCR14_OFFSET
   Definitions
      At line 3108 in file ..\Exercise
   Uses
      At line 3143 in file ..\Exercise
Comment: PORTB_PCR14_OFFSET used once
PORTB_PCR15 4004A03C

Symbol: PORTB_PCR15
   Definitions
      At line 3144 in file ..\Exercise
   Uses
      None
Comment: PORTB_PCR15 unused
PORTB_PCR15_OFFSET 0000003C



ARM Macro Assembler    Page 294 Alphabetic symbol ordering
Absolute symbols


Symbol: PORTB_PCR15_OFFSET
   Definitions
      At line 3109 in file ..\Exercise
   Uses
      At line 3144 in file ..\Exercise
Comment: PORTB_PCR15_OFFSET used once
PORTB_PCR16 4004A040

Symbol: PORTB_PCR16
   Definitions
      At line 3145 in file ..\Exercise
   Uses
      None
Comment: PORTB_PCR16 unused
PORTB_PCR16_OFFSET 00000040

Symbol: PORTB_PCR16_OFFSET
   Definitions
      At line 3110 in file ..\Exercise
   Uses
      At line 3145 in file ..\Exercise
Comment: PORTB_PCR16_OFFSET used once
PORTB_PCR17 4004A044

Symbol: PORTB_PCR17
   Definitions
      At line 3146 in file ..\Exercise
   Uses
      None
Comment: PORTB_PCR17 unused
PORTB_PCR17_OFFSET 00000044

Symbol: PORTB_PCR17_OFFSET
   Definitions
      At line 3111 in file ..\Exercise
   Uses
      At line 3146 in file ..\Exercise
Comment: PORTB_PCR17_OFFSET used once
PORTB_PCR18 4004A048

Symbol: PORTB_PCR18
   Definitions
      At line 3147 in file ..\Exercise
   Uses
      None
Comment: PORTB_PCR18 unused
PORTB_PCR18_OFFSET 00000048

Symbol: PORTB_PCR18_OFFSET
   Definitions
      At line 3112 in file ..\Exercise
   Uses
      At line 3147 in file ..\Exercise
Comment: PORTB_PCR18_OFFSET used once
PORTB_PCR19 4004A04C

Symbol: PORTB_PCR19
   Definitions



ARM Macro Assembler    Page 295 Alphabetic symbol ordering
Absolute symbols

      At line 3148 in file ..\Exercise
   Uses
      None
Comment: PORTB_PCR19 unused
PORTB_PCR19_OFFSET 0000004C

Symbol: PORTB_PCR19_OFFSET
   Definitions
      At line 3113 in file ..\Exercise
   Uses
      At line 3148 in file ..\Exercise
Comment: PORTB_PCR19_OFFSET used once
PORTB_PCR1_OFFSET 00000004

Symbol: PORTB_PCR1_OFFSET
   Definitions
      At line 3095 in file ..\Exercise
   Uses
      At line 3130 in file ..\Exercise
Comment: PORTB_PCR1_OFFSET used once
PORTB_PCR2 4004A008

Symbol: PORTB_PCR2
   Definitions
      At line 3131 in file ..\Exercise
   Uses
      None
Comment: PORTB_PCR2 unused
PORTB_PCR20 4004A050

Symbol: PORTB_PCR20
   Definitions
      At line 3149 in file ..\Exercise
   Uses
      None
Comment: PORTB_PCR20 unused
PORTB_PCR20_OFFSET 00000050

Symbol: PORTB_PCR20_OFFSET
   Definitions
      At line 3114 in file ..\Exercise
   Uses
      At line 3149 in file ..\Exercise
Comment: PORTB_PCR20_OFFSET used once
PORTB_PCR21 4004A054

Symbol: PORTB_PCR21
   Definitions
      At line 3150 in file ..\Exercise
   Uses
      None
Comment: PORTB_PCR21 unused
PORTB_PCR21_OFFSET 00000054

Symbol: PORTB_PCR21_OFFSET
   Definitions
      At line 3115 in file ..\Exercise
   Uses
      At line 3150 in file ..\Exercise



ARM Macro Assembler    Page 296 Alphabetic symbol ordering
Absolute symbols

Comment: PORTB_PCR21_OFFSET used once
PORTB_PCR22 4004A058

Symbol: PORTB_PCR22
   Definitions
      At line 3151 in file ..\Exercise
   Uses
      None
Comment: PORTB_PCR22 unused
PORTB_PCR22_OFFSET 00000058

Symbol: PORTB_PCR22_OFFSET
   Definitions
      At line 3116 in file ..\Exercise
   Uses
      At line 3151 in file ..\Exercise
Comment: PORTB_PCR22_OFFSET used once
PORTB_PCR23 4004A05C

Symbol: PORTB_PCR23
   Definitions
      At line 3152 in file ..\Exercise
   Uses
      None
Comment: PORTB_PCR23 unused
PORTB_PCR23_OFFSET 0000005C

Symbol: PORTB_PCR23_OFFSET
   Definitions
      At line 3117 in file ..\Exercise
   Uses
      At line 3152 in file ..\Exercise
Comment: PORTB_PCR23_OFFSET used once
PORTB_PCR24 4004A060

Symbol: PORTB_PCR24
   Definitions
      At line 3153 in file ..\Exercise
   Uses
      None
Comment: PORTB_PCR24 unused
PORTB_PCR24_OFFSET 00000060

Symbol: PORTB_PCR24_OFFSET
   Definitions
      At line 3118 in file ..\Exercise
   Uses
      At line 3153 in file ..\Exercise
Comment: PORTB_PCR24_OFFSET used once
PORTB_PCR25 4004A064

Symbol: PORTB_PCR25
   Definitions
      At line 3154 in file ..\Exercise
   Uses
      None
Comment: PORTB_PCR25 unused
PORTB_PCR25_OFFSET 00000064




ARM Macro Assembler    Page 297 Alphabetic symbol ordering
Absolute symbols

Symbol: PORTB_PCR25_OFFSET
   Definitions
      At line 3119 in file ..\Exercise
   Uses
      At line 3154 in file ..\Exercise
Comment: PORTB_PCR25_OFFSET used once
PORTB_PCR26 4004A068

Symbol: PORTB_PCR26
   Definitions
      At line 3155 in file ..\Exercise
   Uses
      None
Comment: PORTB_PCR26 unused
PORTB_PCR26_OFFSET 00000068

Symbol: PORTB_PCR26_OFFSET
   Definitions
      At line 3120 in file ..\Exercise
   Uses
      At line 3155 in file ..\Exercise
Comment: PORTB_PCR26_OFFSET used once
PORTB_PCR27 4004A06C

Symbol: PORTB_PCR27
   Definitions
      At line 3156 in file ..\Exercise
   Uses
      None
Comment: PORTB_PCR27 unused
PORTB_PCR27_OFFSET 0000006C

Symbol: PORTB_PCR27_OFFSET
   Definitions
      At line 3121 in file ..\Exercise
   Uses
      At line 3156 in file ..\Exercise
Comment: PORTB_PCR27_OFFSET used once
PORTB_PCR28 4004A070

Symbol: PORTB_PCR28
   Definitions
      At line 3157 in file ..\Exercise
   Uses
      None
Comment: PORTB_PCR28 unused
PORTB_PCR28_OFFSET 00000070

Symbol: PORTB_PCR28_OFFSET
   Definitions
      At line 3122 in file ..\Exercise
   Uses
      At line 3157 in file ..\Exercise
Comment: PORTB_PCR28_OFFSET used once
PORTB_PCR29 4004A074

Symbol: PORTB_PCR29
   Definitions
      At line 3158 in file ..\Exercise



ARM Macro Assembler    Page 298 Alphabetic symbol ordering
Absolute symbols

   Uses
      None
Comment: PORTB_PCR29 unused
PORTB_PCR29_OFFSET 00000074

Symbol: PORTB_PCR29_OFFSET
   Definitions
      At line 3123 in file ..\Exercise
   Uses
      At line 3158 in file ..\Exercise
Comment: PORTB_PCR29_OFFSET used once
PORTB_PCR2_OFFSET 00000008

Symbol: PORTB_PCR2_OFFSET
   Definitions
      At line 3096 in file ..\Exercise
   Uses
      At line 3131 in file ..\Exercise
Comment: PORTB_PCR2_OFFSET used once
PORTB_PCR3 4004A00C

Symbol: PORTB_PCR3
   Definitions
      At line 3132 in file ..\Exercise
   Uses
      None
Comment: PORTB_PCR3 unused
PORTB_PCR30 4004A078

Symbol: PORTB_PCR30
   Definitions
      At line 3159 in file ..\Exercise
   Uses
      None
Comment: PORTB_PCR30 unused
PORTB_PCR30_OFFSET 00000078

Symbol: PORTB_PCR30_OFFSET
   Definitions
      At line 3124 in file ..\Exercise
   Uses
      At line 3159 in file ..\Exercise
Comment: PORTB_PCR30_OFFSET used once
PORTB_PCR31 4004A07C

Symbol: PORTB_PCR31
   Definitions
      At line 3160 in file ..\Exercise
   Uses
      None
Comment: PORTB_PCR31 unused
PORTB_PCR31_OFFSET 0000007C

Symbol: PORTB_PCR31_OFFSET
   Definitions
      At line 3125 in file ..\Exercise
   Uses
      At line 3160 in file ..\Exercise
Comment: PORTB_PCR31_OFFSET used once



ARM Macro Assembler    Page 299 Alphabetic symbol ordering
Absolute symbols

PORTB_PCR3_OFFSET 0000000C

Symbol: PORTB_PCR3_OFFSET
   Definitions
      At line 3097 in file ..\Exercise
   Uses
      At line 3132 in file ..\Exercise
Comment: PORTB_PCR3_OFFSET used once
PORTB_PCR4 4004A010

Symbol: PORTB_PCR4
   Definitions
      At line 3133 in file ..\Exercise
   Uses
      None
Comment: PORTB_PCR4 unused
PORTB_PCR4_OFFSET 00000010

Symbol: PORTB_PCR4_OFFSET
   Definitions
      At line 3098 in file ..\Exercise
   Uses
      At line 3133 in file ..\Exercise
Comment: PORTB_PCR4_OFFSET used once
PORTB_PCR5 4004A014

Symbol: PORTB_PCR5
   Definitions
      At line 3134 in file ..\Exercise
   Uses
      None
Comment: PORTB_PCR5 unused
PORTB_PCR5_OFFSET 00000014

Symbol: PORTB_PCR5_OFFSET
   Definitions
      At line 3099 in file ..\Exercise
   Uses
      At line 3134 in file ..\Exercise
Comment: PORTB_PCR5_OFFSET used once
PORTB_PCR6 4004A018

Symbol: PORTB_PCR6
   Definitions
      At line 3135 in file ..\Exercise
   Uses
      None
Comment: PORTB_PCR6 unused
PORTB_PCR6_OFFSET 00000018

Symbol: PORTB_PCR6_OFFSET
   Definitions
      At line 3100 in file ..\Exercise
   Uses
      At line 3135 in file ..\Exercise
Comment: PORTB_PCR6_OFFSET used once
PORTB_PCR7 4004A01C

Symbol: PORTB_PCR7



ARM Macro Assembler    Page 300 Alphabetic symbol ordering
Absolute symbols

   Definitions
      At line 3136 in file ..\Exercise
   Uses
      None
Comment: PORTB_PCR7 unused
PORTB_PCR7_OFFSET 0000001C

Symbol: PORTB_PCR7_OFFSET
   Definitions
      At line 3101 in file ..\Exercise
   Uses
      At line 3136 in file ..\Exercise
Comment: PORTB_PCR7_OFFSET used once
PORTB_PCR8 4004A020

Symbol: PORTB_PCR8
   Definitions
      At line 3137 in file ..\Exercise
   Uses
      None
Comment: PORTB_PCR8 unused
PORTB_PCR8_OFFSET 00000020

Symbol: PORTB_PCR8_OFFSET
   Definitions
      At line 3102 in file ..\Exercise
   Uses
      At line 3137 in file ..\Exercise
Comment: PORTB_PCR8_OFFSET used once
PORTB_PCR9 4004A024

Symbol: PORTB_PCR9
   Definitions
      At line 3138 in file ..\Exercise
   Uses
      None
Comment: PORTB_PCR9 unused
PORTB_PCR9_OFFSET 00000024

Symbol: PORTB_PCR9_OFFSET
   Definitions
      At line 3103 in file ..\Exercise
   Uses
      At line 3138 in file ..\Exercise
Comment: PORTB_PCR9_OFFSET used once
PORTC_BASE 4004B000

Symbol: PORTC_BASE
   Definitions
      At line 3166 in file ..\Exercise
   Uses
      At line 3202 in file ..\Exercise
      At line 3203 in file ..\Exercise
      At line 3204 in file ..\Exercise
      At line 3205 in file ..\Exercise
      At line 3206 in file ..\Exercise
      At line 3207 in file ..\Exercise
      At line 3208 in file ..\Exercise
      At line 3209 in file ..\Exercise



ARM Macro Assembler    Page 301 Alphabetic symbol ordering
Absolute symbols

      At line 3210 in file ..\Exercise
      At line 3211 in file ..\Exercise
      At line 3212 in file ..\Exercise
      At line 3213 in file ..\Exercise
      At line 3214 in file ..\Exercise
      At line 3215 in file ..\Exercise
      At line 3216 in file ..\Exercise
      At line 3217 in file ..\Exercise
      At line 3218 in file ..\Exercise
      At line 3219 in file ..\Exercise
      At line 3220 in file ..\Exercise
      At line 3221 in file ..\Exercise
      At line 3222 in file ..\Exercise
      At line 3223 in file ..\Exercise
      At line 3224 in file ..\Exercise
      At line 3225 in file ..\Exercise
      At line 3226 in file ..\Exercise
      At line 3227 in file ..\Exercise
      At line 3228 in file ..\Exercise
      At line 3229 in file ..\Exercise
      At line 3230 in file ..\Exercise
      At line 3231 in file ..\Exercise
      At line 3232 in file ..\Exercise
      At line 3233 in file ..\Exercise
      At line 3234 in file ..\Exercise
      At line 3235 in file ..\Exercise
      At line 3236 in file ..\Exercise

PORTC_GPCHR 4004B084

Symbol: PORTC_GPCHR
   Definitions
      At line 3235 in file ..\Exercise
   Uses
      None
Comment: PORTC_GPCHR unused
PORTC_GPCHR_OFFSET 00000084

Symbol: PORTC_GPCHR_OFFSET
   Definitions
      At line 3200 in file ..\Exercise
   Uses
      At line 3235 in file ..\Exercise
Comment: PORTC_GPCHR_OFFSET used once
PORTC_GPCLR 4004B080

Symbol: PORTC_GPCLR
   Definitions
      At line 3234 in file ..\Exercise
   Uses
      None
Comment: PORTC_GPCLR unused
PORTC_GPCLR_OFFSET 00000080

Symbol: PORTC_GPCLR_OFFSET
   Definitions
      At line 3199 in file ..\Exercise
   Uses
      At line 3234 in file ..\Exercise



ARM Macro Assembler    Page 302 Alphabetic symbol ordering
Absolute symbols

Comment: PORTC_GPCLR_OFFSET used once
PORTC_ISFR 4004B0A0

Symbol: PORTC_ISFR
   Definitions
      At line 3236 in file ..\Exercise
   Uses
      None
Comment: PORTC_ISFR unused
PORTC_ISFR_OFFSET 000000A0

Symbol: PORTC_ISFR_OFFSET
   Definitions
      At line 3201 in file ..\Exercise
   Uses
      At line 3236 in file ..\Exercise
Comment: PORTC_ISFR_OFFSET used once
PORTC_PCR0 4004B000

Symbol: PORTC_PCR0
   Definitions
      At line 3202 in file ..\Exercise
   Uses
      None
Comment: PORTC_PCR0 unused
PORTC_PCR0_OFFSET 00000000

Symbol: PORTC_PCR0_OFFSET
   Definitions
      At line 3167 in file ..\Exercise
   Uses
      At line 3202 in file ..\Exercise
Comment: PORTC_PCR0_OFFSET used once
PORTC_PCR1 4004B004

Symbol: PORTC_PCR1
   Definitions
      At line 3203 in file ..\Exercise
   Uses
      None
Comment: PORTC_PCR1 unused
PORTC_PCR10 4004B028

Symbol: PORTC_PCR10
   Definitions
      At line 3212 in file ..\Exercise
   Uses
      None
Comment: PORTC_PCR10 unused
PORTC_PCR10_OFFSET 00000028

Symbol: PORTC_PCR10_OFFSET
   Definitions
      At line 3177 in file ..\Exercise
   Uses
      At line 3212 in file ..\Exercise
Comment: PORTC_PCR10_OFFSET used once
PORTC_PCR11 4004B02C




ARM Macro Assembler    Page 303 Alphabetic symbol ordering
Absolute symbols

Symbol: PORTC_PCR11
   Definitions
      At line 3213 in file ..\Exercise
   Uses
      None
Comment: PORTC_PCR11 unused
PORTC_PCR11_OFFSET 0000002C

Symbol: PORTC_PCR11_OFFSET
   Definitions
      At line 3178 in file ..\Exercise
   Uses
      At line 3213 in file ..\Exercise
Comment: PORTC_PCR11_OFFSET used once
PORTC_PCR12 4004B030

Symbol: PORTC_PCR12
   Definitions
      At line 3214 in file ..\Exercise
   Uses
      None
Comment: PORTC_PCR12 unused
PORTC_PCR12_OFFSET 00000030

Symbol: PORTC_PCR12_OFFSET
   Definitions
      At line 3179 in file ..\Exercise
   Uses
      At line 3214 in file ..\Exercise
Comment: PORTC_PCR12_OFFSET used once
PORTC_PCR13 4004B034

Symbol: PORTC_PCR13
   Definitions
      At line 3215 in file ..\Exercise
   Uses
      None
Comment: PORTC_PCR13 unused
PORTC_PCR13_OFFSET 00000034

Symbol: PORTC_PCR13_OFFSET
   Definitions
      At line 3180 in file ..\Exercise
   Uses
      At line 3215 in file ..\Exercise
Comment: PORTC_PCR13_OFFSET used once
PORTC_PCR14 4004B038

Symbol: PORTC_PCR14
   Definitions
      At line 3216 in file ..\Exercise
   Uses
      None
Comment: PORTC_PCR14 unused
PORTC_PCR14_OFFSET 00000038

Symbol: PORTC_PCR14_OFFSET
   Definitions
      At line 3181 in file ..\Exercise



ARM Macro Assembler    Page 304 Alphabetic symbol ordering
Absolute symbols

   Uses
      At line 3216 in file ..\Exercise
Comment: PORTC_PCR14_OFFSET used once
PORTC_PCR15 4004B03C

Symbol: PORTC_PCR15
   Definitions
      At line 3217 in file ..\Exercise
   Uses
      None
Comment: PORTC_PCR15 unused
PORTC_PCR15_OFFSET 0000003C

Symbol: PORTC_PCR15_OFFSET
   Definitions
      At line 3182 in file ..\Exercise
   Uses
      At line 3217 in file ..\Exercise
Comment: PORTC_PCR15_OFFSET used once
PORTC_PCR16 4004B040

Symbol: PORTC_PCR16
   Definitions
      At line 3218 in file ..\Exercise
   Uses
      None
Comment: PORTC_PCR16 unused
PORTC_PCR16_OFFSET 00000040

Symbol: PORTC_PCR16_OFFSET
   Definitions
      At line 3183 in file ..\Exercise
   Uses
      At line 3218 in file ..\Exercise
Comment: PORTC_PCR16_OFFSET used once
PORTC_PCR17 4004B044

Symbol: PORTC_PCR17
   Definitions
      At line 3219 in file ..\Exercise
   Uses
      None
Comment: PORTC_PCR17 unused
PORTC_PCR17_OFFSET 00000044

Symbol: PORTC_PCR17_OFFSET
   Definitions
      At line 3184 in file ..\Exercise
   Uses
      At line 3219 in file ..\Exercise
Comment: PORTC_PCR17_OFFSET used once
PORTC_PCR18 4004B048

Symbol: PORTC_PCR18
   Definitions
      At line 3220 in file ..\Exercise
   Uses
      None
Comment: PORTC_PCR18 unused



ARM Macro Assembler    Page 305 Alphabetic symbol ordering
Absolute symbols

PORTC_PCR18_OFFSET 00000048

Symbol: PORTC_PCR18_OFFSET
   Definitions
      At line 3185 in file ..\Exercise
   Uses
      At line 3220 in file ..\Exercise
Comment: PORTC_PCR18_OFFSET used once
PORTC_PCR19 4004B04C

Symbol: PORTC_PCR19
   Definitions
      At line 3221 in file ..\Exercise
   Uses
      None
Comment: PORTC_PCR19 unused
PORTC_PCR19_OFFSET 0000004C

Symbol: PORTC_PCR19_OFFSET
   Definitions
      At line 3186 in file ..\Exercise
   Uses
      At line 3221 in file ..\Exercise
Comment: PORTC_PCR19_OFFSET used once
PORTC_PCR1_OFFSET 00000004

Symbol: PORTC_PCR1_OFFSET
   Definitions
      At line 3168 in file ..\Exercise
   Uses
      At line 3203 in file ..\Exercise
Comment: PORTC_PCR1_OFFSET used once
PORTC_PCR2 4004B008

Symbol: PORTC_PCR2
   Definitions
      At line 3204 in file ..\Exercise
   Uses
      None
Comment: PORTC_PCR2 unused
PORTC_PCR20 4004B050

Symbol: PORTC_PCR20
   Definitions
      At line 3222 in file ..\Exercise
   Uses
      None
Comment: PORTC_PCR20 unused
PORTC_PCR20_OFFSET 00000050

Symbol: PORTC_PCR20_OFFSET
   Definitions
      At line 3187 in file ..\Exercise
   Uses
      At line 3222 in file ..\Exercise
Comment: PORTC_PCR20_OFFSET used once
PORTC_PCR21 4004B054

Symbol: PORTC_PCR21



ARM Macro Assembler    Page 306 Alphabetic symbol ordering
Absolute symbols

   Definitions
      At line 3223 in file ..\Exercise
   Uses
      None
Comment: PORTC_PCR21 unused
PORTC_PCR21_OFFSET 00000054

Symbol: PORTC_PCR21_OFFSET
   Definitions
      At line 3188 in file ..\Exercise
   Uses
      At line 3223 in file ..\Exercise
Comment: PORTC_PCR21_OFFSET used once
PORTC_PCR22 4004B058

Symbol: PORTC_PCR22
   Definitions
      At line 3224 in file ..\Exercise
   Uses
      None
Comment: PORTC_PCR22 unused
PORTC_PCR22_OFFSET 00000058

Symbol: PORTC_PCR22_OFFSET
   Definitions
      At line 3189 in file ..\Exercise
   Uses
      At line 3224 in file ..\Exercise
Comment: PORTC_PCR22_OFFSET used once
PORTC_PCR23 4004B05C

Symbol: PORTC_PCR23
   Definitions
      At line 3225 in file ..\Exercise
   Uses
      None
Comment: PORTC_PCR23 unused
PORTC_PCR23_OFFSET 0000005C

Symbol: PORTC_PCR23_OFFSET
   Definitions
      At line 3190 in file ..\Exercise
   Uses
      At line 3225 in file ..\Exercise
Comment: PORTC_PCR23_OFFSET used once
PORTC_PCR24 4004B060

Symbol: PORTC_PCR24
   Definitions
      At line 3226 in file ..\Exercise
   Uses
      None
Comment: PORTC_PCR24 unused
PORTC_PCR24_OFFSET 00000060

Symbol: PORTC_PCR24_OFFSET
   Definitions
      At line 3191 in file ..\Exercise
   Uses



ARM Macro Assembler    Page 307 Alphabetic symbol ordering
Absolute symbols

      At line 3226 in file ..\Exercise
Comment: PORTC_PCR24_OFFSET used once
PORTC_PCR25 4004B064

Symbol: PORTC_PCR25
   Definitions
      At line 3227 in file ..\Exercise
   Uses
      None
Comment: PORTC_PCR25 unused
PORTC_PCR25_OFFSET 00000064

Symbol: PORTC_PCR25_OFFSET
   Definitions
      At line 3192 in file ..\Exercise
   Uses
      At line 3227 in file ..\Exercise
Comment: PORTC_PCR25_OFFSET used once
PORTC_PCR26 4004B068

Symbol: PORTC_PCR26
   Definitions
      At line 3228 in file ..\Exercise
   Uses
      None
Comment: PORTC_PCR26 unused
PORTC_PCR26_OFFSET 00000068

Symbol: PORTC_PCR26_OFFSET
   Definitions
      At line 3193 in file ..\Exercise
   Uses
      At line 3228 in file ..\Exercise
Comment: PORTC_PCR26_OFFSET used once
PORTC_PCR27 4004B06C

Symbol: PORTC_PCR27
   Definitions
      At line 3229 in file ..\Exercise
   Uses
      None
Comment: PORTC_PCR27 unused
PORTC_PCR27_OFFSET 0000006C

Symbol: PORTC_PCR27_OFFSET
   Definitions
      At line 3194 in file ..\Exercise
   Uses
      At line 3229 in file ..\Exercise
Comment: PORTC_PCR27_OFFSET used once
PORTC_PCR28 4004B070

Symbol: PORTC_PCR28
   Definitions
      At line 3230 in file ..\Exercise
   Uses
      None
Comment: PORTC_PCR28 unused
PORTC_PCR28_OFFSET 00000070



ARM Macro Assembler    Page 308 Alphabetic symbol ordering
Absolute symbols


Symbol: PORTC_PCR28_OFFSET
   Definitions
      At line 3195 in file ..\Exercise
   Uses
      At line 3230 in file ..\Exercise
Comment: PORTC_PCR28_OFFSET used once
PORTC_PCR29 4004B074

Symbol: PORTC_PCR29
   Definitions
      At line 3231 in file ..\Exercise
   Uses
      None
Comment: PORTC_PCR29 unused
PORTC_PCR29_OFFSET 00000074

Symbol: PORTC_PCR29_OFFSET
   Definitions
      At line 3196 in file ..\Exercise
   Uses
      At line 3231 in file ..\Exercise
Comment: PORTC_PCR29_OFFSET used once
PORTC_PCR2_OFFSET 00000008

Symbol: PORTC_PCR2_OFFSET
   Definitions
      At line 3169 in file ..\Exercise
   Uses
      At line 3204 in file ..\Exercise
Comment: PORTC_PCR2_OFFSET used once
PORTC_PCR3 4004B00C

Symbol: PORTC_PCR3
   Definitions
      At line 3205 in file ..\Exercise
   Uses
      None
Comment: PORTC_PCR3 unused
PORTC_PCR30 4004B078

Symbol: PORTC_PCR30
   Definitions
      At line 3232 in file ..\Exercise
   Uses
      None
Comment: PORTC_PCR30 unused
PORTC_PCR30_OFFSET 00000078

Symbol: PORTC_PCR30_OFFSET
   Definitions
      At line 3197 in file ..\Exercise
   Uses
      At line 3232 in file ..\Exercise
Comment: PORTC_PCR30_OFFSET used once
PORTC_PCR31 4004B07C

Symbol: PORTC_PCR31
   Definitions



ARM Macro Assembler    Page 309 Alphabetic symbol ordering
Absolute symbols

      At line 3233 in file ..\Exercise
   Uses
      None
Comment: PORTC_PCR31 unused
PORTC_PCR31_OFFSET 0000007C

Symbol: PORTC_PCR31_OFFSET
   Definitions
      At line 3198 in file ..\Exercise
   Uses
      At line 3233 in file ..\Exercise
Comment: PORTC_PCR31_OFFSET used once
PORTC_PCR3_OFFSET 0000000C

Symbol: PORTC_PCR3_OFFSET
   Definitions
      At line 3170 in file ..\Exercise
   Uses
      At line 3205 in file ..\Exercise
Comment: PORTC_PCR3_OFFSET used once
PORTC_PCR4 4004B010

Symbol: PORTC_PCR4
   Definitions
      At line 3206 in file ..\Exercise
   Uses
      None
Comment: PORTC_PCR4 unused
PORTC_PCR4_OFFSET 00000010

Symbol: PORTC_PCR4_OFFSET
   Definitions
      At line 3171 in file ..\Exercise
   Uses
      At line 3206 in file ..\Exercise
Comment: PORTC_PCR4_OFFSET used once
PORTC_PCR5 4004B014

Symbol: PORTC_PCR5
   Definitions
      At line 3207 in file ..\Exercise
   Uses
      None
Comment: PORTC_PCR5 unused
PORTC_PCR5_OFFSET 00000014

Symbol: PORTC_PCR5_OFFSET
   Definitions
      At line 3172 in file ..\Exercise
   Uses
      At line 3207 in file ..\Exercise
Comment: PORTC_PCR5_OFFSET used once
PORTC_PCR6 4004B018

Symbol: PORTC_PCR6
   Definitions
      At line 3208 in file ..\Exercise
   Uses
      None



ARM Macro Assembler    Page 310 Alphabetic symbol ordering
Absolute symbols

Comment: PORTC_PCR6 unused
PORTC_PCR6_OFFSET 00000018

Symbol: PORTC_PCR6_OFFSET
   Definitions
      At line 3173 in file ..\Exercise
   Uses
      At line 3208 in file ..\Exercise
Comment: PORTC_PCR6_OFFSET used once
PORTC_PCR7 4004B01C

Symbol: PORTC_PCR7
   Definitions
      At line 3209 in file ..\Exercise
   Uses
      None
Comment: PORTC_PCR7 unused
PORTC_PCR7_OFFSET 0000001C

Symbol: PORTC_PCR7_OFFSET
   Definitions
      At line 3174 in file ..\Exercise
   Uses
      At line 3209 in file ..\Exercise
Comment: PORTC_PCR7_OFFSET used once
PORTC_PCR8 4004B020

Symbol: PORTC_PCR8
   Definitions
      At line 3210 in file ..\Exercise
   Uses
      None
Comment: PORTC_PCR8 unused
PORTC_PCR8_OFFSET 00000020

Symbol: PORTC_PCR8_OFFSET
   Definitions
      At line 3175 in file ..\Exercise
   Uses
      At line 3210 in file ..\Exercise
Comment: PORTC_PCR8_OFFSET used once
PORTC_PCR9 4004B024

Symbol: PORTC_PCR9
   Definitions
      At line 3211 in file ..\Exercise
   Uses
      None
Comment: PORTC_PCR9 unused
PORTC_PCR9_OFFSET 00000024

Symbol: PORTC_PCR9_OFFSET
   Definitions
      At line 3176 in file ..\Exercise
   Uses
      At line 3211 in file ..\Exercise
Comment: PORTC_PCR9_OFFSET used once
PORTC_PORTD_IPR E000E41C




ARM Macro Assembler    Page 311 Alphabetic symbol ordering
Absolute symbols

Symbol: PORTC_PORTD_IPR
   Definitions
      At line 2694 in file ..\Exercise
   Uses
      None
Comment: PORTC_PORTD_IPR unused
PORTC_PORTD_IRQ 0000001F

Symbol: PORTC_PORTD_IRQ
   Definitions
      At line 2764 in file ..\Exercise
   Uses
      At line 2798 in file ..\Exercise
Comment: PORTC_PORTD_IRQ used once
PORTC_PORTD_IRQ_MASK 80000000

Symbol: PORTC_PORTD_IRQ_MASK
   Definitions
      At line 2798 in file ..\Exercise
   Uses
      None
Comment: PORTC_PORTD_IRQ_MASK unused
PORTC_PORTD_IRQn 0000001F

Symbol: PORTC_PORTD_IRQn
   Definitions
      At line 177 in file ..\Exercise
   Uses
      None
Comment: PORTC_PORTD_IRQn unused
PORTC_PORTD_PRI_POS 0000001E

Symbol: PORTC_PORTD_PRI_POS
   Definitions
      At line 2730 in file ..\Exercise
   Uses
      None
Comment: PORTC_PORTD_PRI_POS unused
PORTD_BASE 4004C000

Symbol: PORTD_BASE
   Definitions
      At line 3239 in file ..\Exercise
   Uses
      At line 3275 in file ..\Exercise
      At line 3276 in file ..\Exercise
      At line 3277 in file ..\Exercise
      At line 3278 in file ..\Exercise
      At line 3279 in file ..\Exercise
      At line 3280 in file ..\Exercise
      At line 3281 in file ..\Exercise
      At line 3282 in file ..\Exercise
      At line 3283 in file ..\Exercise
      At line 3284 in file ..\Exercise
      At line 3285 in file ..\Exercise
      At line 3286 in file ..\Exercise
      At line 3287 in file ..\Exercise
      At line 3288 in file ..\Exercise
      At line 3289 in file ..\Exercise



ARM Macro Assembler    Page 312 Alphabetic symbol ordering
Absolute symbols

      At line 3290 in file ..\Exercise
      At line 3291 in file ..\Exercise
      At line 3292 in file ..\Exercise
      At line 3293 in file ..\Exercise
      At line 3294 in file ..\Exercise
      At line 3295 in file ..\Exercise
      At line 3296 in file ..\Exercise
      At line 3297 in file ..\Exercise
      At line 3298 in file ..\Exercise
      At line 3299 in file ..\Exercise
      At line 3300 in file ..\Exercise
      At line 3301 in file ..\Exercise
      At line 3302 in file ..\Exercise
      At line 3303 in file ..\Exercise
      At line 3304 in file ..\Exercise
      At line 3305 in file ..\Exercise
      At line 3306 in file ..\Exercise
      At line 3307 in file ..\Exercise
      At line 3308 in file ..\Exercise
      At line 3309 in file ..\Exercise
      At line 421 in file ..\Exercise

PORTD_GPCHR 4004C084

Symbol: PORTD_GPCHR
   Definitions
      At line 3308 in file ..\Exercise
   Uses
      None
Comment: PORTD_GPCHR unused
PORTD_GPCHR_OFFSET 00000084

Symbol: PORTD_GPCHR_OFFSET
   Definitions
      At line 3273 in file ..\Exercise
   Uses
      At line 3308 in file ..\Exercise
Comment: PORTD_GPCHR_OFFSET used once
PORTD_GPCLR 4004C080

Symbol: PORTD_GPCLR
   Definitions
      At line 3307 in file ..\Exercise
   Uses
      None
Comment: PORTD_GPCLR unused
PORTD_GPCLR_OFFSET 00000080

Symbol: PORTD_GPCLR_OFFSET
   Definitions
      At line 3272 in file ..\Exercise
   Uses
      At line 3307 in file ..\Exercise
Comment: PORTD_GPCLR_OFFSET used once
PORTD_ISFR 4004C0A0

Symbol: PORTD_ISFR
   Definitions
      At line 3309 in file ..\Exercise



ARM Macro Assembler    Page 313 Alphabetic symbol ordering
Absolute symbols

   Uses
      None
Comment: PORTD_ISFR unused
PORTD_ISFR_OFFSET 000000A0

Symbol: PORTD_ISFR_OFFSET
   Definitions
      At line 3274 in file ..\Exercise
   Uses
      At line 3309 in file ..\Exercise
Comment: PORTD_ISFR_OFFSET used once
PORTD_PCR0 4004C000

Symbol: PORTD_PCR0
   Definitions
      At line 3275 in file ..\Exercise
   Uses
      None
Comment: PORTD_PCR0 unused
PORTD_PCR0_OFFSET 00000000

Symbol: PORTD_PCR0_OFFSET
   Definitions
      At line 3240 in file ..\Exercise
   Uses
      At line 3275 in file ..\Exercise
Comment: PORTD_PCR0_OFFSET used once
PORTD_PCR1 4004C004

Symbol: PORTD_PCR1
   Definitions
      At line 3276 in file ..\Exercise
   Uses
      None
Comment: PORTD_PCR1 unused
PORTD_PCR10 4004C028

Symbol: PORTD_PCR10
   Definitions
      At line 3285 in file ..\Exercise
   Uses
      None
Comment: PORTD_PCR10 unused
PORTD_PCR10_OFFSET 00000028

Symbol: PORTD_PCR10_OFFSET
   Definitions
      At line 3250 in file ..\Exercise
   Uses
      At line 3285 in file ..\Exercise
Comment: PORTD_PCR10_OFFSET used once
PORTD_PCR11 4004C02C

Symbol: PORTD_PCR11
   Definitions
      At line 3286 in file ..\Exercise
   Uses
      None
Comment: PORTD_PCR11 unused



ARM Macro Assembler    Page 314 Alphabetic symbol ordering
Absolute symbols

PORTD_PCR11_OFFSET 0000002C

Symbol: PORTD_PCR11_OFFSET
   Definitions
      At line 3251 in file ..\Exercise
   Uses
      At line 3286 in file ..\Exercise
Comment: PORTD_PCR11_OFFSET used once
PORTD_PCR12 4004C030

Symbol: PORTD_PCR12
   Definitions
      At line 3287 in file ..\Exercise
   Uses
      None
Comment: PORTD_PCR12 unused
PORTD_PCR12_OFFSET 00000030

Symbol: PORTD_PCR12_OFFSET
   Definitions
      At line 3252 in file ..\Exercise
   Uses
      At line 3287 in file ..\Exercise
Comment: PORTD_PCR12_OFFSET used once
PORTD_PCR13 4004C034

Symbol: PORTD_PCR13
   Definitions
      At line 3288 in file ..\Exercise
   Uses
      None
Comment: PORTD_PCR13 unused
PORTD_PCR13_OFFSET 00000034

Symbol: PORTD_PCR13_OFFSET
   Definitions
      At line 3253 in file ..\Exercise
   Uses
      At line 3288 in file ..\Exercise
Comment: PORTD_PCR13_OFFSET used once
PORTD_PCR14 4004C038

Symbol: PORTD_PCR14
   Definitions
      At line 3289 in file ..\Exercise
   Uses
      None
Comment: PORTD_PCR14 unused
PORTD_PCR14_OFFSET 00000038

Symbol: PORTD_PCR14_OFFSET
   Definitions
      At line 3254 in file ..\Exercise
   Uses
      At line 3289 in file ..\Exercise
Comment: PORTD_PCR14_OFFSET used once
PORTD_PCR15 4004C03C

Symbol: PORTD_PCR15



ARM Macro Assembler    Page 315 Alphabetic symbol ordering
Absolute symbols

   Definitions
      At line 3290 in file ..\Exercise
   Uses
      None
Comment: PORTD_PCR15 unused
PORTD_PCR15_OFFSET 0000003C

Symbol: PORTD_PCR15_OFFSET
   Definitions
      At line 3255 in file ..\Exercise
   Uses
      At line 3290 in file ..\Exercise
Comment: PORTD_PCR15_OFFSET used once
PORTD_PCR16 4004C040

Symbol: PORTD_PCR16
   Definitions
      At line 3291 in file ..\Exercise
   Uses
      None
Comment: PORTD_PCR16 unused
PORTD_PCR16_OFFSET 00000040

Symbol: PORTD_PCR16_OFFSET
   Definitions
      At line 3256 in file ..\Exercise
   Uses
      At line 3291 in file ..\Exercise
Comment: PORTD_PCR16_OFFSET used once
PORTD_PCR17 4004C044

Symbol: PORTD_PCR17
   Definitions
      At line 3292 in file ..\Exercise
   Uses
      None
Comment: PORTD_PCR17 unused
PORTD_PCR17_OFFSET 00000044

Symbol: PORTD_PCR17_OFFSET
   Definitions
      At line 3257 in file ..\Exercise
   Uses
      At line 3292 in file ..\Exercise
Comment: PORTD_PCR17_OFFSET used once
PORTD_PCR18 4004C048

Symbol: PORTD_PCR18
   Definitions
      At line 3293 in file ..\Exercise
   Uses
      None
Comment: PORTD_PCR18 unused
PORTD_PCR18_OFFSET 00000048

Symbol: PORTD_PCR18_OFFSET
   Definitions
      At line 3258 in file ..\Exercise
   Uses



ARM Macro Assembler    Page 316 Alphabetic symbol ordering
Absolute symbols

      At line 3293 in file ..\Exercise
Comment: PORTD_PCR18_OFFSET used once
PORTD_PCR19 4004C04C

Symbol: PORTD_PCR19
   Definitions
      At line 3294 in file ..\Exercise
   Uses
      None
Comment: PORTD_PCR19 unused
PORTD_PCR19_OFFSET 0000004C

Symbol: PORTD_PCR19_OFFSET
   Definitions
      At line 3259 in file ..\Exercise
   Uses
      At line 3294 in file ..\Exercise
Comment: PORTD_PCR19_OFFSET used once
PORTD_PCR1_OFFSET 00000004

Symbol: PORTD_PCR1_OFFSET
   Definitions
      At line 3241 in file ..\Exercise
   Uses
      At line 3276 in file ..\Exercise
Comment: PORTD_PCR1_OFFSET used once
PORTD_PCR2 4004C008

Symbol: PORTD_PCR2
   Definitions
      At line 3277 in file ..\Exercise
   Uses
      None
Comment: PORTD_PCR2 unused
PORTD_PCR20 4004C050

Symbol: PORTD_PCR20
   Definitions
      At line 3295 in file ..\Exercise
   Uses
      None
Comment: PORTD_PCR20 unused
PORTD_PCR20_OFFSET 00000050

Symbol: PORTD_PCR20_OFFSET
   Definitions
      At line 3260 in file ..\Exercise
   Uses
      At line 3295 in file ..\Exercise
Comment: PORTD_PCR20_OFFSET used once
PORTD_PCR21 4004C054

Symbol: PORTD_PCR21
   Definitions
      At line 3296 in file ..\Exercise
   Uses
      None
Comment: PORTD_PCR21 unused
PORTD_PCR21_OFFSET 00000054



ARM Macro Assembler    Page 317 Alphabetic symbol ordering
Absolute symbols


Symbol: PORTD_PCR21_OFFSET
   Definitions
      At line 3261 in file ..\Exercise
   Uses
      At line 3296 in file ..\Exercise
Comment: PORTD_PCR21_OFFSET used once
PORTD_PCR22 4004C058

Symbol: PORTD_PCR22
   Definitions
      At line 3297 in file ..\Exercise
   Uses
      None
Comment: PORTD_PCR22 unused
PORTD_PCR22_OFFSET 00000058

Symbol: PORTD_PCR22_OFFSET
   Definitions
      At line 3262 in file ..\Exercise
   Uses
      At line 3297 in file ..\Exercise
Comment: PORTD_PCR22_OFFSET used once
PORTD_PCR23 4004C05C

Symbol: PORTD_PCR23
   Definitions
      At line 3298 in file ..\Exercise
   Uses
      None
Comment: PORTD_PCR23 unused
PORTD_PCR23_OFFSET 0000005C

Symbol: PORTD_PCR23_OFFSET
   Definitions
      At line 3263 in file ..\Exercise
   Uses
      At line 3298 in file ..\Exercise
Comment: PORTD_PCR23_OFFSET used once
PORTD_PCR24 4004C060

Symbol: PORTD_PCR24
   Definitions
      At line 3299 in file ..\Exercise
   Uses
      None
Comment: PORTD_PCR24 unused
PORTD_PCR24_OFFSET 00000060

Symbol: PORTD_PCR24_OFFSET
   Definitions
      At line 3264 in file ..\Exercise
   Uses
      At line 3299 in file ..\Exercise
Comment: PORTD_PCR24_OFFSET used once
PORTD_PCR25 4004C064

Symbol: PORTD_PCR25
   Definitions



ARM Macro Assembler    Page 318 Alphabetic symbol ordering
Absolute symbols

      At line 3300 in file ..\Exercise
   Uses
      None
Comment: PORTD_PCR25 unused
PORTD_PCR25_OFFSET 00000064

Symbol: PORTD_PCR25_OFFSET
   Definitions
      At line 3265 in file ..\Exercise
   Uses
      At line 3300 in file ..\Exercise
Comment: PORTD_PCR25_OFFSET used once
PORTD_PCR26 4004C068

Symbol: PORTD_PCR26
   Definitions
      At line 3301 in file ..\Exercise
   Uses
      None
Comment: PORTD_PCR26 unused
PORTD_PCR26_OFFSET 00000068

Symbol: PORTD_PCR26_OFFSET
   Definitions
      At line 3266 in file ..\Exercise
   Uses
      At line 3301 in file ..\Exercise
Comment: PORTD_PCR26_OFFSET used once
PORTD_PCR27 4004C06C

Symbol: PORTD_PCR27
   Definitions
      At line 3302 in file ..\Exercise
   Uses
      None
Comment: PORTD_PCR27 unused
PORTD_PCR27_OFFSET 0000006C

Symbol: PORTD_PCR27_OFFSET
   Definitions
      At line 3267 in file ..\Exercise
   Uses
      At line 3302 in file ..\Exercise
Comment: PORTD_PCR27_OFFSET used once
PORTD_PCR28 4004C070

Symbol: PORTD_PCR28
   Definitions
      At line 3303 in file ..\Exercise
   Uses
      None
Comment: PORTD_PCR28 unused
PORTD_PCR28_OFFSET 00000070

Symbol: PORTD_PCR28_OFFSET
   Definitions
      At line 3268 in file ..\Exercise
   Uses
      At line 3303 in file ..\Exercise



ARM Macro Assembler    Page 319 Alphabetic symbol ordering
Absolute symbols

Comment: PORTD_PCR28_OFFSET used once
PORTD_PCR29 4004C074

Symbol: PORTD_PCR29
   Definitions
      At line 3304 in file ..\Exercise
   Uses
      None
Comment: PORTD_PCR29 unused
PORTD_PCR29_OFFSET 00000074

Symbol: PORTD_PCR29_OFFSET
   Definitions
      At line 3269 in file ..\Exercise
   Uses
      At line 3304 in file ..\Exercise
Comment: PORTD_PCR29_OFFSET used once
PORTD_PCR2_OFFSET 00000008

Symbol: PORTD_PCR2_OFFSET
   Definitions
      At line 3242 in file ..\Exercise
   Uses
      At line 3277 in file ..\Exercise
Comment: PORTD_PCR2_OFFSET used once
PORTD_PCR3 4004C00C

Symbol: PORTD_PCR3
   Definitions
      At line 3278 in file ..\Exercise
   Uses
      None
Comment: PORTD_PCR3 unused
PORTD_PCR30 4004C078

Symbol: PORTD_PCR30
   Definitions
      At line 3305 in file ..\Exercise
   Uses
      None
Comment: PORTD_PCR30 unused
PORTD_PCR30_OFFSET 00000078

Symbol: PORTD_PCR30_OFFSET
   Definitions
      At line 3270 in file ..\Exercise
   Uses
      At line 3305 in file ..\Exercise
Comment: PORTD_PCR30_OFFSET used once
PORTD_PCR31 4004C07C

Symbol: PORTD_PCR31
   Definitions
      At line 3306 in file ..\Exercise
   Uses
      None
Comment: PORTD_PCR31 unused
PORTD_PCR31_OFFSET 0000007C




ARM Macro Assembler    Page 320 Alphabetic symbol ordering
Absolute symbols

Symbol: PORTD_PCR31_OFFSET
   Definitions
      At line 3271 in file ..\Exercise
   Uses
      At line 3306 in file ..\Exercise
Comment: PORTD_PCR31_OFFSET used once
PORTD_PCR3_OFFSET 0000000C

Symbol: PORTD_PCR3_OFFSET
   Definitions
      At line 3243 in file ..\Exercise
   Uses
      At line 3278 in file ..\Exercise
Comment: PORTD_PCR3_OFFSET used once
PORTD_PCR4 4004C010

Symbol: PORTD_PCR4
   Definitions
      At line 3279 in file ..\Exercise
   Uses
      None
Comment: PORTD_PCR4 unused
PORTD_PCR4_OFFSET 00000010

Symbol: PORTD_PCR4_OFFSET
   Definitions
      At line 3244 in file ..\Exercise
   Uses
      At line 3279 in file ..\Exercise
Comment: PORTD_PCR4_OFFSET used once
PORTD_PCR5 4004C014

Symbol: PORTD_PCR5
   Definitions
      At line 3280 in file ..\Exercise
   Uses
      None
Comment: PORTD_PCR5 unused
PORTD_PCR5_OFFSET 00000014

Symbol: PORTD_PCR5_OFFSET
   Definitions
      At line 3245 in file ..\Exercise
   Uses
      At line 3280 in file ..\Exercise
      At line 423 in file ..\Exercise

PORTD_PCR6 4004C018

Symbol: PORTD_PCR6
   Definitions
      At line 3281 in file ..\Exercise
   Uses
      None
Comment: PORTD_PCR6 unused
PORTD_PCR6_OFFSET 00000018

Symbol: PORTD_PCR6_OFFSET
   Definitions



ARM Macro Assembler    Page 321 Alphabetic symbol ordering
Absolute symbols

      At line 3246 in file ..\Exercise
   Uses
      At line 3281 in file ..\Exercise
Comment: PORTD_PCR6_OFFSET used once
PORTD_PCR7 4004C01C

Symbol: PORTD_PCR7
   Definitions
      At line 3282 in file ..\Exercise
   Uses
      None
Comment: PORTD_PCR7 unused
PORTD_PCR7_OFFSET 0000001C

Symbol: PORTD_PCR7_OFFSET
   Definitions
      At line 3247 in file ..\Exercise
   Uses
      At line 3282 in file ..\Exercise
Comment: PORTD_PCR7_OFFSET used once
PORTD_PCR8 4004C020

Symbol: PORTD_PCR8
   Definitions
      At line 3283 in file ..\Exercise
   Uses
      None
Comment: PORTD_PCR8 unused
PORTD_PCR8_OFFSET 00000020

Symbol: PORTD_PCR8_OFFSET
   Definitions
      At line 3248 in file ..\Exercise
   Uses
      At line 3283 in file ..\Exercise
Comment: PORTD_PCR8_OFFSET used once
PORTD_PCR9 4004C024

Symbol: PORTD_PCR9
   Definitions
      At line 3284 in file ..\Exercise
   Uses
      None
Comment: PORTD_PCR9 unused
PORTD_PCR9_OFFSET 00000024

Symbol: PORTD_PCR9_OFFSET
   Definitions
      At line 3249 in file ..\Exercise
   Uses
      At line 3284 in file ..\Exercise
Comment: PORTD_PCR9_OFFSET used once
PORTD_Vector 0000002F

Symbol: PORTD_Vector
   Definitions
      At line 2848 in file ..\Exercise
   Uses
      None



ARM Macro Assembler    Page 322 Alphabetic symbol ordering
Absolute symbols

Comment: PORTD_Vector unused
PORTE_BASE 4004D000

Symbol: PORTE_BASE
   Definitions
      At line 3312 in file ..\Exercise
   Uses
      At line 3348 in file ..\Exercise
      At line 3349 in file ..\Exercise
      At line 3350 in file ..\Exercise
      At line 3351 in file ..\Exercise
      At line 3352 in file ..\Exercise
      At line 3353 in file ..\Exercise
      At line 3354 in file ..\Exercise
      At line 3355 in file ..\Exercise
      At line 3356 in file ..\Exercise
      At line 3357 in file ..\Exercise
      At line 3358 in file ..\Exercise
      At line 3359 in file ..\Exercise
      At line 3360 in file ..\Exercise
      At line 3361 in file ..\Exercise
      At line 3362 in file ..\Exercise
      At line 3363 in file ..\Exercise
      At line 3364 in file ..\Exercise
      At line 3365 in file ..\Exercise
      At line 3366 in file ..\Exercise
      At line 3367 in file ..\Exercise
      At line 3368 in file ..\Exercise
      At line 3369 in file ..\Exercise
      At line 3370 in file ..\Exercise
      At line 3371 in file ..\Exercise
      At line 3372 in file ..\Exercise
      At line 3373 in file ..\Exercise
      At line 3374 in file ..\Exercise
      At line 3375 in file ..\Exercise
      At line 3376 in file ..\Exercise
      At line 3377 in file ..\Exercise
      At line 3378 in file ..\Exercise
      At line 3379 in file ..\Exercise
      At line 3380 in file ..\Exercise
      At line 3381 in file ..\Exercise
      At line 3382 in file ..\Exercise
      At line 417 in file ..\Exercise

PORTE_GPCHR 4004D084

Symbol: PORTE_GPCHR
   Definitions
      At line 3381 in file ..\Exercise
   Uses
      None
Comment: PORTE_GPCHR unused
PORTE_GPCHR_OFFSET 00000084

Symbol: PORTE_GPCHR_OFFSET
   Definitions
      At line 3346 in file ..\Exercise
   Uses
      At line 3381 in file ..\Exercise



ARM Macro Assembler    Page 323 Alphabetic symbol ordering
Absolute symbols

Comment: PORTE_GPCHR_OFFSET used once
PORTE_GPCLR 4004D080

Symbol: PORTE_GPCLR
   Definitions
      At line 3380 in file ..\Exercise
   Uses
      None
Comment: PORTE_GPCLR unused
PORTE_GPCLR_OFFSET 00000080

Symbol: PORTE_GPCLR_OFFSET
   Definitions
      At line 3345 in file ..\Exercise
   Uses
      At line 3380 in file ..\Exercise
Comment: PORTE_GPCLR_OFFSET used once
PORTE_ISFR 4004D0A0

Symbol: PORTE_ISFR
   Definitions
      At line 3382 in file ..\Exercise
   Uses
      None
Comment: PORTE_ISFR unused
PORTE_ISFR_OFFSET 000000A0

Symbol: PORTE_ISFR_OFFSET
   Definitions
      At line 3347 in file ..\Exercise
   Uses
      At line 3382 in file ..\Exercise
Comment: PORTE_ISFR_OFFSET used once
PORTE_PCR0 4004D000

Symbol: PORTE_PCR0
   Definitions
      At line 3348 in file ..\Exercise
   Uses
      None
Comment: PORTE_PCR0 unused
PORTE_PCR0_OFFSET 00000000

Symbol: PORTE_PCR0_OFFSET
   Definitions
      At line 3313 in file ..\Exercise
   Uses
      At line 3348 in file ..\Exercise
Comment: PORTE_PCR0_OFFSET used once
PORTE_PCR1 4004D004

Symbol: PORTE_PCR1
   Definitions
      At line 3349 in file ..\Exercise
   Uses
      None
Comment: PORTE_PCR1 unused
PORTE_PCR10 4004D028




ARM Macro Assembler    Page 324 Alphabetic symbol ordering
Absolute symbols

Symbol: PORTE_PCR10
   Definitions
      At line 3358 in file ..\Exercise
   Uses
      None
Comment: PORTE_PCR10 unused
PORTE_PCR10_OFFSET 00000028

Symbol: PORTE_PCR10_OFFSET
   Definitions
      At line 3323 in file ..\Exercise
   Uses
      At line 3358 in file ..\Exercise
Comment: PORTE_PCR10_OFFSET used once
PORTE_PCR11 4004D02C

Symbol: PORTE_PCR11
   Definitions
      At line 3359 in file ..\Exercise
   Uses
      None
Comment: PORTE_PCR11 unused
PORTE_PCR11_OFFSET 0000002C

Symbol: PORTE_PCR11_OFFSET
   Definitions
      At line 3324 in file ..\Exercise
   Uses
      At line 3359 in file ..\Exercise
Comment: PORTE_PCR11_OFFSET used once
PORTE_PCR12 4004D030

Symbol: PORTE_PCR12
   Definitions
      At line 3360 in file ..\Exercise
   Uses
      None
Comment: PORTE_PCR12 unused
PORTE_PCR12_OFFSET 00000030

Symbol: PORTE_PCR12_OFFSET
   Definitions
      At line 3325 in file ..\Exercise
   Uses
      At line 3360 in file ..\Exercise
Comment: PORTE_PCR12_OFFSET used once
PORTE_PCR13 4004D034

Symbol: PORTE_PCR13
   Definitions
      At line 3361 in file ..\Exercise
   Uses
      None
Comment: PORTE_PCR13 unused
PORTE_PCR13_OFFSET 00000034

Symbol: PORTE_PCR13_OFFSET
   Definitions
      At line 3326 in file ..\Exercise



ARM Macro Assembler    Page 325 Alphabetic symbol ordering
Absolute symbols

   Uses
      At line 3361 in file ..\Exercise
Comment: PORTE_PCR13_OFFSET used once
PORTE_PCR14 4004D038

Symbol: PORTE_PCR14
   Definitions
      At line 3362 in file ..\Exercise
   Uses
      None
Comment: PORTE_PCR14 unused
PORTE_PCR14_OFFSET 00000038

Symbol: PORTE_PCR14_OFFSET
   Definitions
      At line 3327 in file ..\Exercise
   Uses
      At line 3362 in file ..\Exercise
Comment: PORTE_PCR14_OFFSET used once
PORTE_PCR15 4004D03C

Symbol: PORTE_PCR15
   Definitions
      At line 3363 in file ..\Exercise
   Uses
      None
Comment: PORTE_PCR15 unused
PORTE_PCR15_OFFSET 0000003C

Symbol: PORTE_PCR15_OFFSET
   Definitions
      At line 3328 in file ..\Exercise
   Uses
      At line 3363 in file ..\Exercise
Comment: PORTE_PCR15_OFFSET used once
PORTE_PCR16 4004D040

Symbol: PORTE_PCR16
   Definitions
      At line 3364 in file ..\Exercise
   Uses
      None
Comment: PORTE_PCR16 unused
PORTE_PCR16_OFFSET 00000040

Symbol: PORTE_PCR16_OFFSET
   Definitions
      At line 3329 in file ..\Exercise
   Uses
      At line 3364 in file ..\Exercise
Comment: PORTE_PCR16_OFFSET used once
PORTE_PCR17 4004D044

Symbol: PORTE_PCR17
   Definitions
      At line 3365 in file ..\Exercise
   Uses
      None
Comment: PORTE_PCR17 unused



ARM Macro Assembler    Page 326 Alphabetic symbol ordering
Absolute symbols

PORTE_PCR17_OFFSET 00000044

Symbol: PORTE_PCR17_OFFSET
   Definitions
      At line 3330 in file ..\Exercise
   Uses
      At line 3365 in file ..\Exercise
Comment: PORTE_PCR17_OFFSET used once
PORTE_PCR18 4004D048

Symbol: PORTE_PCR18
   Definitions
      At line 3366 in file ..\Exercise
   Uses
      None
Comment: PORTE_PCR18 unused
PORTE_PCR18_OFFSET 00000048

Symbol: PORTE_PCR18_OFFSET
   Definitions
      At line 3331 in file ..\Exercise
   Uses
      At line 3366 in file ..\Exercise
Comment: PORTE_PCR18_OFFSET used once
PORTE_PCR19 4004D04C

Symbol: PORTE_PCR19
   Definitions
      At line 3367 in file ..\Exercise
   Uses
      None
Comment: PORTE_PCR19 unused
PORTE_PCR19_OFFSET 0000004C

Symbol: PORTE_PCR19_OFFSET
   Definitions
      At line 3332 in file ..\Exercise
   Uses
      At line 3367 in file ..\Exercise
Comment: PORTE_PCR19_OFFSET used once
PORTE_PCR1_OFFSET 00000004

Symbol: PORTE_PCR1_OFFSET
   Definitions
      At line 3314 in file ..\Exercise
   Uses
      At line 3349 in file ..\Exercise
Comment: PORTE_PCR1_OFFSET used once
PORTE_PCR2 4004D008

Symbol: PORTE_PCR2
   Definitions
      At line 3350 in file ..\Exercise
   Uses
      None
Comment: PORTE_PCR2 unused
PORTE_PCR20 4004D050

Symbol: PORTE_PCR20



ARM Macro Assembler    Page 327 Alphabetic symbol ordering
Absolute symbols

   Definitions
      At line 3368 in file ..\Exercise
   Uses
      None
Comment: PORTE_PCR20 unused
PORTE_PCR20_OFFSET 00000050

Symbol: PORTE_PCR20_OFFSET
   Definitions
      At line 3333 in file ..\Exercise
   Uses
      At line 3368 in file ..\Exercise
Comment: PORTE_PCR20_OFFSET used once
PORTE_PCR21 4004D054

Symbol: PORTE_PCR21
   Definitions
      At line 3369 in file ..\Exercise
   Uses
      None
Comment: PORTE_PCR21 unused
PORTE_PCR21_OFFSET 00000054

Symbol: PORTE_PCR21_OFFSET
   Definitions
      At line 3334 in file ..\Exercise
   Uses
      At line 3369 in file ..\Exercise
Comment: PORTE_PCR21_OFFSET used once
PORTE_PCR22 4004D058

Symbol: PORTE_PCR22
   Definitions
      At line 3370 in file ..\Exercise
   Uses
      None
Comment: PORTE_PCR22 unused
PORTE_PCR22_OFFSET 00000058

Symbol: PORTE_PCR22_OFFSET
   Definitions
      At line 3335 in file ..\Exercise
   Uses
      At line 3370 in file ..\Exercise
Comment: PORTE_PCR22_OFFSET used once
PORTE_PCR23 4004D05C

Symbol: PORTE_PCR23
   Definitions
      At line 3371 in file ..\Exercise
   Uses
      None
Comment: PORTE_PCR23 unused
PORTE_PCR23_OFFSET 0000005C

Symbol: PORTE_PCR23_OFFSET
   Definitions
      At line 3336 in file ..\Exercise
   Uses



ARM Macro Assembler    Page 328 Alphabetic symbol ordering
Absolute symbols

      At line 3371 in file ..\Exercise
Comment: PORTE_PCR23_OFFSET used once
PORTE_PCR24 4004D060

Symbol: PORTE_PCR24
   Definitions
      At line 3372 in file ..\Exercise
   Uses
      None
Comment: PORTE_PCR24 unused
PORTE_PCR24_OFFSET 00000060

Symbol: PORTE_PCR24_OFFSET
   Definitions
      At line 3337 in file ..\Exercise
   Uses
      At line 3372 in file ..\Exercise
Comment: PORTE_PCR24_OFFSET used once
PORTE_PCR25 4004D064

Symbol: PORTE_PCR25
   Definitions
      At line 3373 in file ..\Exercise
   Uses
      None
Comment: PORTE_PCR25 unused
PORTE_PCR25_OFFSET 00000064

Symbol: PORTE_PCR25_OFFSET
   Definitions
      At line 3338 in file ..\Exercise
   Uses
      At line 3373 in file ..\Exercise
Comment: PORTE_PCR25_OFFSET used once
PORTE_PCR26 4004D068

Symbol: PORTE_PCR26
   Definitions
      At line 3374 in file ..\Exercise
   Uses
      None
Comment: PORTE_PCR26 unused
PORTE_PCR26_OFFSET 00000068

Symbol: PORTE_PCR26_OFFSET
   Definitions
      At line 3339 in file ..\Exercise
   Uses
      At line 3374 in file ..\Exercise
Comment: PORTE_PCR26_OFFSET used once
PORTE_PCR27 4004D06C

Symbol: PORTE_PCR27
   Definitions
      At line 3375 in file ..\Exercise
   Uses
      None
Comment: PORTE_PCR27 unused
PORTE_PCR27_OFFSET 0000006C



ARM Macro Assembler    Page 329 Alphabetic symbol ordering
Absolute symbols


Symbol: PORTE_PCR27_OFFSET
   Definitions
      At line 3340 in file ..\Exercise
   Uses
      At line 3375 in file ..\Exercise
Comment: PORTE_PCR27_OFFSET used once
PORTE_PCR28 4004D070

Symbol: PORTE_PCR28
   Definitions
      At line 3376 in file ..\Exercise
   Uses
      None
Comment: PORTE_PCR28 unused
PORTE_PCR28_OFFSET 00000070

Symbol: PORTE_PCR28_OFFSET
   Definitions
      At line 3341 in file ..\Exercise
   Uses
      At line 3376 in file ..\Exercise
Comment: PORTE_PCR28_OFFSET used once
PORTE_PCR29 4004D074

Symbol: PORTE_PCR29
   Definitions
      At line 3377 in file ..\Exercise
   Uses
      None
Comment: PORTE_PCR29 unused
PORTE_PCR29_OFFSET 00000074

Symbol: PORTE_PCR29_OFFSET
   Definitions
      At line 3342 in file ..\Exercise
   Uses
      At line 3377 in file ..\Exercise
      At line 419 in file ..\Exercise

PORTE_PCR2_OFFSET 00000008

Symbol: PORTE_PCR2_OFFSET
   Definitions
      At line 3315 in file ..\Exercise
   Uses
      At line 3350 in file ..\Exercise
Comment: PORTE_PCR2_OFFSET used once
PORTE_PCR3 4004D00C

Symbol: PORTE_PCR3
   Definitions
      At line 3351 in file ..\Exercise
   Uses
      None
Comment: PORTE_PCR3 unused
PORTE_PCR30 4004D078

Symbol: PORTE_PCR30



ARM Macro Assembler    Page 330 Alphabetic symbol ordering
Absolute symbols

   Definitions
      At line 3378 in file ..\Exercise
   Uses
      None
Comment: PORTE_PCR30 unused
PORTE_PCR30_OFFSET 00000078

Symbol: PORTE_PCR30_OFFSET
   Definitions
      At line 3343 in file ..\Exercise
   Uses
      At line 3378 in file ..\Exercise
Comment: PORTE_PCR30_OFFSET used once
PORTE_PCR31 4004D07C

Symbol: PORTE_PCR31
   Definitions
      At line 3379 in file ..\Exercise
   Uses
      None
Comment: PORTE_PCR31 unused
PORTE_PCR31_OFFSET 0000007C

Symbol: PORTE_PCR31_OFFSET
   Definitions
      At line 3344 in file ..\Exercise
   Uses
      At line 3379 in file ..\Exercise
Comment: PORTE_PCR31_OFFSET used once
PORTE_PCR3_OFFSET 0000000C

Symbol: PORTE_PCR3_OFFSET
   Definitions
      At line 3316 in file ..\Exercise
   Uses
      At line 3351 in file ..\Exercise
Comment: PORTE_PCR3_OFFSET used once
PORTE_PCR4 4004D010

Symbol: PORTE_PCR4
   Definitions
      At line 3352 in file ..\Exercise
   Uses
      None
Comment: PORTE_PCR4 unused
PORTE_PCR4_OFFSET 00000010

Symbol: PORTE_PCR4_OFFSET
   Definitions
      At line 3317 in file ..\Exercise
   Uses
      At line 3352 in file ..\Exercise
Comment: PORTE_PCR4_OFFSET used once
PORTE_PCR5 4004D014

Symbol: PORTE_PCR5
   Definitions
      At line 3353 in file ..\Exercise
   Uses



ARM Macro Assembler    Page 331 Alphabetic symbol ordering
Absolute symbols

      None
Comment: PORTE_PCR5 unused
PORTE_PCR5_OFFSET 00000014

Symbol: PORTE_PCR5_OFFSET
   Definitions
      At line 3318 in file ..\Exercise
   Uses
      At line 3353 in file ..\Exercise
Comment: PORTE_PCR5_OFFSET used once
PORTE_PCR6 4004D018

Symbol: PORTE_PCR6
   Definitions
      At line 3354 in file ..\Exercise
   Uses
      None
Comment: PORTE_PCR6 unused
PORTE_PCR6_OFFSET 00000018

Symbol: PORTE_PCR6_OFFSET
   Definitions
      At line 3319 in file ..\Exercise
   Uses
      At line 3354 in file ..\Exercise
Comment: PORTE_PCR6_OFFSET used once
PORTE_PCR7 4004D01C

Symbol: PORTE_PCR7
   Definitions
      At line 3355 in file ..\Exercise
   Uses
      None
Comment: PORTE_PCR7 unused
PORTE_PCR7_OFFSET 0000001C

Symbol: PORTE_PCR7_OFFSET
   Definitions
      At line 3320 in file ..\Exercise
   Uses
      At line 3355 in file ..\Exercise
Comment: PORTE_PCR7_OFFSET used once
PORTE_PCR8 4004D020

Symbol: PORTE_PCR8
   Definitions
      At line 3356 in file ..\Exercise
   Uses
      None
Comment: PORTE_PCR8 unused
PORTE_PCR8_OFFSET 00000020

Symbol: PORTE_PCR8_OFFSET
   Definitions
      At line 3321 in file ..\Exercise
   Uses
      At line 3356 in file ..\Exercise
Comment: PORTE_PCR8_OFFSET used once
PORTE_PCR9 4004D024



ARM Macro Assembler    Page 332 Alphabetic symbol ordering
Absolute symbols


Symbol: PORTE_PCR9
   Definitions
      At line 3357 in file ..\Exercise
   Uses
      None
Comment: PORTE_PCR9 unused
PORTE_PCR9_OFFSET 00000024

Symbol: PORTE_PCR9_OFFSET
   Definitions
      At line 3322 in file ..\Exercise
   Uses
      At line 3357 in file ..\Exercise
Comment: PORTE_PCR9_OFFSET used once
PORT_PCR_DSE_MASK 00000040

Symbol: PORT_PCR_DSE_MASK
   Definitions
      At line 3000 in file ..\Exercise
   Uses
      None
Comment: PORT_PCR_DSE_MASK unused
PORT_PCR_DSE_SHIFT 00000006

Symbol: PORT_PCR_DSE_SHIFT
   Definitions
      At line 3001 in file ..\Exercise
   Uses
      None
Comment: PORT_PCR_DSE_SHIFT unused
PORT_PCR_IRCQ_MASK 000F0000

Symbol: PORT_PCR_IRCQ_MASK
   Definitions
      At line 2996 in file ..\Exercise
   Uses
      None
Comment: PORT_PCR_IRCQ_MASK unused
PORT_PCR_IRCQ_SHIFT 00000010

Symbol: PORT_PCR_IRCQ_SHIFT
   Definitions
      At line 2997 in file ..\Exercise
   Uses
      None
Comment: PORT_PCR_IRCQ_SHIFT unused
PORT_PCR_ISF_MASK 01000000

Symbol: PORT_PCR_ISF_MASK
   Definitions
      At line 2994 in file ..\Exercise
   Uses
      At line 82 in file ..\Exercise
      At line 84 in file ..\Exercise
      At line 232 in file ..\Exercise
      At line 236 in file ..\Exercise

PORT_PCR_ISF_SHIFT 00000018



ARM Macro Assembler    Page 333 Alphabetic symbol ordering
Absolute symbols


Symbol: PORT_PCR_ISF_SHIFT
   Definitions
      At line 2995 in file ..\Exercise
   Uses
      None
Comment: PORT_PCR_ISF_SHIFT unused
PORT_PCR_MUX_MASK 00000700

Symbol: PORT_PCR_MUX_MASK
   Definitions
      At line 2998 in file ..\Exercise
   Uses
      None
Comment: PORT_PCR_MUX_MASK unused
PORT_PCR_MUX_SELECT_0_MASK 00000000

Symbol: PORT_PCR_MUX_SELECT_0_MASK
   Definitions
      At line 3010 in file ..\Exercise
   Uses
      None
Comment: PORT_PCR_MUX_SELECT_0_MASK unused
PORT_PCR_MUX_SELECT_1_MASK 00000100

Symbol: PORT_PCR_MUX_SELECT_1_MASK
   Definitions
      At line 3011 in file ..\Exercise
   Uses
      None
Comment: PORT_PCR_MUX_SELECT_1_MASK unused
PORT_PCR_MUX_SELECT_2_MASK 00000200

Symbol: PORT_PCR_MUX_SELECT_2_MASK
   Definitions
      At line 3012 in file ..\Exercise
   Uses
      At line 82 in file ..\Exercise
      At line 84 in file ..\Exercise

PORT_PCR_MUX_SELECT_3_MASK 00000300

Symbol: PORT_PCR_MUX_SELECT_3_MASK
   Definitions
      At line 3013 in file ..\Exercise
   Uses
      None
Comment: PORT_PCR_MUX_SELECT_3_MASK unused
PORT_PCR_MUX_SELECT_4_MASK 00000400

Symbol: PORT_PCR_MUX_SELECT_4_MASK
   Definitions
      At line 3014 in file ..\Exercise
   Uses
      None
Comment: PORT_PCR_MUX_SELECT_4_MASK unused
PORT_PCR_MUX_SELECT_5_MASK 00000500

Symbol: PORT_PCR_MUX_SELECT_5_MASK



ARM Macro Assembler    Page 334 Alphabetic symbol ordering
Absolute symbols

   Definitions
      At line 3015 in file ..\Exercise
   Uses
      None
Comment: PORT_PCR_MUX_SELECT_5_MASK unused
PORT_PCR_MUX_SELECT_6_MASK 00000600

Symbol: PORT_PCR_MUX_SELECT_6_MASK
   Definitions
      At line 3016 in file ..\Exercise
   Uses
      None
Comment: PORT_PCR_MUX_SELECT_6_MASK unused
PORT_PCR_MUX_SELECT_7_MASK 00000700

Symbol: PORT_PCR_MUX_SELECT_7_MASK
   Definitions
      At line 3017 in file ..\Exercise
   Uses
      None
Comment: PORT_PCR_MUX_SELECT_7_MASK unused
PORT_PCR_MUX_SHIFT 00000008

Symbol: PORT_PCR_MUX_SHIFT
   Definitions
      At line 2999 in file ..\Exercise
   Uses
      At line 230 in file ..\Exercise
      At line 234 in file ..\Exercise

PORT_PCR_PE_MASK 00000002

Symbol: PORT_PCR_PE_MASK
   Definitions
      At line 3006 in file ..\Exercise
   Uses
      None
Comment: PORT_PCR_PE_MASK unused
PORT_PCR_PE_SHIFT 00000001

Symbol: PORT_PCR_PE_SHIFT
   Definitions
      At line 3007 in file ..\Exercise
   Uses
      None
Comment: PORT_PCR_PE_SHIFT unused
PORT_PCR_PFE_MASK 00000010

Symbol: PORT_PCR_PFE_MASK
   Definitions
      At line 3002 in file ..\Exercise
   Uses
      None
Comment: PORT_PCR_PFE_MASK unused
PORT_PCR_PFE_SHIFT 00000004

Symbol: PORT_PCR_PFE_SHIFT
   Definitions
      At line 3003 in file ..\Exercise



ARM Macro Assembler    Page 335 Alphabetic symbol ordering
Absolute symbols

   Uses
      None
Comment: PORT_PCR_PFE_SHIFT unused
PORT_PCR_PS_MASK 00000001

Symbol: PORT_PCR_PS_MASK
   Definitions
      At line 3008 in file ..\Exercise
   Uses
      None
Comment: PORT_PCR_PS_MASK unused
PORT_PCR_PS_SHIFT 00000000

Symbol: PORT_PCR_PS_SHIFT
   Definitions
      At line 3009 in file ..\Exercise
   Uses
      None
Comment: PORT_PCR_PS_SHIFT unused
PORT_PCR_SET_PTA1_UART0_RX 01000200

Symbol: PORT_PCR_SET_PTA1_UART0_RX
   Definitions
      At line 82 in file ..\Exercise
   Uses
      At line 928 in file ..\Exercise
Comment: PORT_PCR_SET_PTA1_UART0_RX used once
PORT_PCR_SET_PTA2_UART0_TX 01000200

Symbol: PORT_PCR_SET_PTA2_UART0_TX
   Definitions
      At line 84 in file ..\Exercise
   Uses
      At line 932 in file ..\Exercise
Comment: PORT_PCR_SET_PTA2_UART0_TX used once
PORT_PCR_SRE_MASK 00000004

Symbol: PORT_PCR_SRE_MASK
   Definitions
      At line 3004 in file ..\Exercise
   Uses
      None
Comment: PORT_PCR_SRE_MASK unused
PORT_PCR_SRE_SHIFT 00000002

Symbol: PORT_PCR_SRE_SHIFT
   Definitions
      At line 3005 in file ..\Exercise
   Uses
      None
Comment: PORT_PCR_SRE_SHIFT unused
POS_GREEN 00000005

Symbol: POS_GREEN
   Definitions
      At line 238 in file ..\Exercise
   Uses
      At line 240 in file ..\Exercise
Comment: POS_GREEN used once



ARM Macro Assembler    Page 336 Alphabetic symbol ordering
Absolute symbols

POS_RED 0000001D

Symbol: POS_RED
   Definitions
      At line 237 in file ..\Exercise
   Uses
      At line 239 in file ..\Exercise
Comment: POS_RED used once
PRIMASK_PM_MASK 00000001

Symbol: PRIMASK_PM_MASK
   Definitions
      At line 62 in file ..\Exercise
   Uses
      None
Comment: PRIMASK_PM_MASK unused
PRIMASK_PM_SHIFT 00000000

Symbol: PRIMASK_PM_SHIFT
   Definitions
      At line 63 in file ..\Exercise
   Uses
      None
Comment: PRIMASK_PM_SHIFT unused
PSR_C_MASK 20000000

Symbol: PSR_C_MASK
   Definitions
      At line 119 in file ..\Exercise
   Uses
      None
Comment: PSR_C_MASK unused
PSR_C_SHIFT 0000001D

Symbol: PSR_C_SHIFT
   Definitions
      At line 120 in file ..\Exercise
   Uses
      None
Comment: PSR_C_SHIFT unused
PSR_EXCEPTION_MASK 0000003F

Symbol: PSR_EXCEPTION_MASK
   Definitions
      At line 125 in file ..\Exercise
   Uses
      None
Comment: PSR_EXCEPTION_MASK unused
PSR_EXCEPTION_SHIFT 00000000

Symbol: PSR_EXCEPTION_SHIFT
   Definitions
      At line 126 in file ..\Exercise
   Uses
      None
Comment: PSR_EXCEPTION_SHIFT unused
PSR_N_MASK 80000000

Symbol: PSR_N_MASK



ARM Macro Assembler    Page 337 Alphabetic symbol ordering
Absolute symbols

   Definitions
      At line 115 in file ..\Exercise
   Uses
      None
Comment: PSR_N_MASK unused
PSR_N_SHIFT 0000001F

Symbol: PSR_N_SHIFT
   Definitions
      At line 116 in file ..\Exercise
   Uses
      None
Comment: PSR_N_SHIFT unused
PSR_T_MASK 01000000

Symbol: PSR_T_MASK
   Definitions
      At line 123 in file ..\Exercise
   Uses
      None
Comment: PSR_T_MASK unused
PSR_T_SHIFT 00000018

Symbol: PSR_T_SHIFT
   Definitions
      At line 124 in file ..\Exercise
   Uses
      None
Comment: PSR_T_SHIFT unused
PSR_V_MASK 10000000

Symbol: PSR_V_MASK
   Definitions
      At line 121 in file ..\Exercise
   Uses
      None
Comment: PSR_V_MASK unused
PSR_V_SHIFT 0000001C

Symbol: PSR_V_SHIFT
   Definitions
      At line 122 in file ..\Exercise
   Uses
      None
Comment: PSR_V_SHIFT unused
PSR_Z_MASK 40000000

Symbol: PSR_Z_MASK
   Definitions
      At line 117 in file ..\Exercise
   Uses
      None
Comment: PSR_Z_MASK unused
PSR_Z_SHIFT 0000001E

Symbol: PSR_Z_SHIFT
   Definitions
      At line 118 in file ..\Exercise
   Uses



ARM Macro Assembler    Page 338 Alphabetic symbol ordering
Absolute symbols

      None
Comment: PSR_Z_SHIFT unused
PTD5_MUX_GPIO 00000100

Symbol: PTD5_MUX_GPIO
   Definitions
      At line 230 in file ..\Exercise
   Uses
      At line 232 in file ..\Exercise
Comment: PTD5_MUX_GPIO used once
PTE29_MUX_GPIO 00000100

Symbol: PTE29_MUX_GPIO
   Definitions
      At line 234 in file ..\Exercise
   Uses
      At line 236 in file ..\Exercise
Comment: PTE29_MUX_GPIO used once
PWM_DUTY_10 000016A8

Symbol: PWM_DUTY_10
   Definitions
      At line 251 in file ..\Exercise
   Uses
      At line 1095 in file ..\Exercise
      At line 1096 in file ..\Exercise
      At line 1097 in file ..\Exercise
      At line 1098 in file ..\Exercise

PWM_DUTY_5 000007D0

Symbol: PWM_DUTY_5
   Definitions
      At line 250 in file ..\Exercise
   Uses
      At line 1096 in file ..\Exercise
      At line 1096 in file ..\Exercise
      At line 1097 in file ..\Exercise
      At line 1097 in file ..\Exercise
      At line 1098 in file ..\Exercise
      At line 1098 in file ..\Exercise
      At line 1099 in file ..\Exercise

PWM_PERIOD_20ms 0000EA60

Symbol: PWM_PERIOD_20ms
   Definitions
      At line 249 in file ..\Exercise
   Uses
      None
Comment: PWM_PERIOD_20ms unused
PendSR_Vector 0000000E

Symbol: PendSR_Vector
   Definitions
      At line 2815 in file ..\Exercise
   Uses
      None
Comment: PendSR_Vector unused



ARM Macro Assembler    Page 339 Alphabetic symbol ordering
Absolute symbols

PendSV_IRQn FFFFFFFE

Symbol: PendSV_IRQn
   Definitions
      At line 141 in file ..\Exercise
   Uses
      None
Comment: PendSV_IRQn unused
Q_BUF_SZ 00000004

Symbol: Q_BUF_SZ
   Definitions
      At line 226 in file ..\Exercise
   Uses
      At line 451 in file ..\Exercise
      At line 794 in file ..\Exercise
      At line 1112 in file ..\Exercise
      At line 1115 in file ..\Exercise
      At line 1118 in file ..\Exercise

Q_REC_SZ 00000012

Symbol: Q_REC_SZ
   Definitions
      At line 227 in file ..\Exercise
   Uses
      At line 1113 in file ..\Exercise
      At line 1116 in file ..\Exercise
      At line 1119 in file ..\Exercise

RDRF_CHARSET_MASK 00000020

Symbol: RDRF_CHARSET_MASK
   Definitions
      At line 228 in file ..\Exercise
   Uses
      None
Comment: RDRF_CHARSET_MASK unused
RET_ADDR_T_MASK 00000001

Symbol: RET_ADDR_T_MASK
   Definitions
      At line 34 in file ..\Exercise
   Uses
      None
Comment: RET_ADDR_T_MASK unused
RTC_IPR E000E414

Symbol: RTC_IPR
   Definitions
      At line 2683 in file ..\Exercise
   Uses
      None
Comment: RTC_IPR unused
RTC_IRQ 00000014

Symbol: RTC_IRQ
   Definitions
      At line 2753 in file ..\Exercise



ARM Macro Assembler    Page 340 Alphabetic symbol ordering
Absolute symbols

   Uses
      At line 2787 in file ..\Exercise
Comment: RTC_IRQ used once
RTC_IRQ_MASK 00100000

Symbol: RTC_IRQ_MASK
   Definitions
      At line 2787 in file ..\Exercise
   Uses
      None
Comment: RTC_IRQ_MASK unused
RTC_IRQn 00000014

Symbol: RTC_IRQn
   Definitions
      At line 166 in file ..\Exercise
   Uses
      None
Comment: RTC_IRQn unused
RTC_PRI_POS 00000006

Symbol: RTC_PRI_POS
   Definitions
      At line 2719 in file ..\Exercise
   Uses
      None
Comment: RTC_PRI_POS unused
RTC_Seconds_IPR E000E414

Symbol: RTC_Seconds_IPR
   Definitions
      At line 2684 in file ..\Exercise
   Uses
      None
Comment: RTC_Seconds_IPR unused
RTC_Seconds_IRQ 00000015

Symbol: RTC_Seconds_IRQ
   Definitions
      At line 2754 in file ..\Exercise
   Uses
      At line 2788 in file ..\Exercise
Comment: RTC_Seconds_IRQ used once
RTC_Seconds_IRQ_MASK 00200000

Symbol: RTC_Seconds_IRQ_MASK
   Definitions
      At line 2788 in file ..\Exercise
   Uses
      None
Comment: RTC_Seconds_IRQ_MASK unused
RTC_Seconds_IRQn 00000015

Symbol: RTC_Seconds_IRQn
   Definitions
      At line 167 in file ..\Exercise
   Uses
      None
Comment: RTC_Seconds_IRQn unused



ARM Macro Assembler    Page 341 Alphabetic symbol ordering
Absolute symbols

RTC_Seconds_PRI_POS 0000000E

Symbol: RTC_Seconds_PRI_POS
   Definitions
      At line 2720 in file ..\Exercise
   Uses
      None
Comment: RTC_Seconds_PRI_POS unused
RTC_Seconds_Vector 00000025

Symbol: RTC_Seconds_Vector
   Definitions
      At line 2838 in file ..\Exercise
   Uses
      None
Comment: RTC_Seconds_Vector unused
RTC_Vector 00000024

Symbol: RTC_Vector
   Definitions
      At line 2837 in file ..\Exercise
   Uses
      None
Comment: RTC_Vector unused
Reserved04_Vector 00000004

Symbol: Reserved04_Vector
   Definitions
      At line 2805 in file ..\Exercise
   Uses
      None
Comment: Reserved04_Vector unused
Reserved05_Vector 00000005

Symbol: Reserved05_Vector
   Definitions
      At line 2806 in file ..\Exercise
   Uses
      None
Comment: Reserved05_Vector unused
Reserved06_Vector 00000006

Symbol: Reserved06_Vector
   Definitions
      At line 2807 in file ..\Exercise
   Uses
      None
Comment: Reserved06_Vector unused
Reserved07_Vector 00000007

Symbol: Reserved07_Vector
   Definitions
      At line 2808 in file ..\Exercise
   Uses
      None
Comment: Reserved07_Vector unused
Reserved08_Vector 00000008

Symbol: Reserved08_Vector



ARM Macro Assembler    Page 342 Alphabetic symbol ordering
Absolute symbols

   Definitions
      At line 2809 in file ..\Exercise
   Uses
      None
Comment: Reserved08_Vector unused
Reserved09_Vector 00000009

Symbol: Reserved09_Vector
   Definitions
      At line 2810 in file ..\Exercise
   Uses
      None
Comment: Reserved09_Vector unused
Reserved10_Vector 0000000A

Symbol: Reserved10_Vector
   Definitions
      At line 2811 in file ..\Exercise
   Uses
      None
Comment: Reserved10_Vector unused
Reserved12_Vector 0000000C

Symbol: Reserved12_Vector
   Definitions
      At line 2813 in file ..\Exercise
   Uses
      None
Comment: Reserved12_Vector unused
Reserved13_Vector 0000000D

Symbol: Reserved13_Vector
   Definitions
      At line 2814 in file ..\Exercise
   Uses
      None
Comment: Reserved13_Vector unused
Reserved20_IPR E000E404

Symbol: Reserved20_IPR
   Definitions
      At line 2667 in file ..\Exercise
   Uses
      None
Comment: Reserved20_IPR unused
Reserved20_IRQ 00000004

Symbol: Reserved20_IRQ
   Definitions
      At line 2737 in file ..\Exercise
   Uses
      At line 2771 in file ..\Exercise
Comment: Reserved20_IRQ used once
Reserved20_IRQ_MASK 00000010

Symbol: Reserved20_IRQ_MASK
   Definitions
      At line 2771 in file ..\Exercise
   Uses



ARM Macro Assembler    Page 343 Alphabetic symbol ordering
Absolute symbols

      None
Comment: Reserved20_IRQ_MASK unused
Reserved20_IRQn 00000004

Symbol: Reserved20_IRQn
   Definitions
      At line 150 in file ..\Exercise
   Uses
      None
Comment: Reserved20_IRQn unused
Reserved20_PRI_POS 00000006

Symbol: Reserved20_PRI_POS
   Definitions
      At line 2703 in file ..\Exercise
   Uses
      None
Comment: Reserved20_PRI_POS unused
Reserved20_Vector 00000014

Symbol: Reserved20_Vector
   Definitions
      At line 2821 in file ..\Exercise
   Uses
      None
Comment: Reserved20_Vector unused
Reset_Vector 00000001

Symbol: Reset_Vector
   Definitions
      At line 2802 in file ..\Exercise
   Uses
      None
Comment: Reset_Vector unused
SERVO_POSITIONS 00000005

Symbol: SERVO_POSITIONS
   Definitions
      At line 255 in file ..\Exercise
   Uses
      At line 1102 in file ..\Exercise
      At line 1103 in file ..\Exercise
      At line 1104 in file ..\Exercise
      At line 1105 in file ..\Exercise
      At line 1106 in file ..\Exercise

SET_PTD5_GPIO 01000100

Symbol: SET_PTD5_GPIO
   Definitions
      At line 232 in file ..\Exercise
   Uses
      At line 422 in file ..\Exercise
Comment: SET_PTD5_GPIO used once
SET_PTE29_GPIO 01000100

Symbol: SET_PTE29_GPIO
   Definitions
      At line 236 in file ..\Exercise



ARM Macro Assembler    Page 344 Alphabetic symbol ordering
Absolute symbols

   Uses
      At line 418 in file ..\Exercise
Comment: SET_PTE29_GPIO used once
SIM_BASE 40047000

Symbol: SIM_BASE
   Definitions
      At line 3385 in file ..\Exercise
   Uses
      At line 3405 in file ..\Exercise
      At line 3406 in file ..\Exercise
      At line 3407 in file ..\Exercise
      At line 3408 in file ..\Exercise
      At line 3409 in file ..\Exercise
      At line 3410 in file ..\Exercise
      At line 3411 in file ..\Exercise
      At line 3412 in file ..\Exercise
      At line 3413 in file ..\Exercise
      At line 3414 in file ..\Exercise
      At line 3415 in file ..\Exercise
      At line 3416 in file ..\Exercise
      At line 3417 in file ..\Exercise
      At line 3418 in file ..\Exercise
      At line 3419 in file ..\Exercise
      At line 3420 in file ..\Exercise
      At line 3421 in file ..\Exercise
      At line 3422 in file ..\Exercise
      At line 3423 in file ..\Exercise

SIM_CLKDIV1 40048044

Symbol: SIM_CLKDIV1
   Definitions
      At line 3405 in file ..\Exercise
   Uses
      None
Comment: SIM_CLKDIV1 unused
SIM_CLKDIV1_OFFSET 00001044

Symbol: SIM_CLKDIV1_OFFSET
   Definitions
      At line 3397 in file ..\Exercise
   Uses
      At line 3405 in file ..\Exercise
Comment: SIM_CLKDIV1_OFFSET used once
SIM_CLKDIV1_OUTDIV1_MASK F0000000

Symbol: SIM_CLKDIV1_OUTDIV1_MASK
   Definitions
      At line 3436 in file ..\Exercise
   Uses
      None
Comment: SIM_CLKDIV1_OUTDIV1_MASK unused
SIM_CLKDIV1_OUTDIV1_SHIFT 0000001C

Symbol: SIM_CLKDIV1_OUTDIV1_SHIFT
   Definitions
      At line 3437 in file ..\Exercise
   Uses



ARM Macro Assembler    Page 345 Alphabetic symbol ordering
Absolute symbols

      None
Comment: SIM_CLKDIV1_OUTDIV1_SHIFT unused
SIM_CLKDIV1_OUTDIV4_MASK 00070000

Symbol: SIM_CLKDIV1_OUTDIV4_MASK
   Definitions
      At line 3438 in file ..\Exercise
   Uses
      None
Comment: SIM_CLKDIV1_OUTDIV4_MASK unused
SIM_CLKDIV1_OUTDIV4_SHIFT 00000010

Symbol: SIM_CLKDIV1_OUTDIV4_SHIFT
   Definitions
      At line 3439 in file ..\Exercise
   Uses
      None
Comment: SIM_CLKDIV1_OUTDIV4_SHIFT unused
SIM_COPC 40048100

Symbol: SIM_COPC
   Definitions
      At line 3406 in file ..\Exercise
   Uses
      None
Comment: SIM_COPC unused
SIM_COPC_OFFSET 00001100

Symbol: SIM_COPC_OFFSET
   Definitions
      At line 3403 in file ..\Exercise
   Uses
      At line 3406 in file ..\Exercise
Comment: SIM_COPC_OFFSET used once
SIM_FCFG1 4004804C

Symbol: SIM_FCFG1
   Definitions
      At line 3407 in file ..\Exercise
   Uses
      None
Comment: SIM_FCFG1 unused
SIM_FCFG1_OFFSET 0000104C

Symbol: SIM_FCFG1_OFFSET
   Definitions
      At line 3398 in file ..\Exercise
   Uses
      At line 3407 in file ..\Exercise
Comment: SIM_FCFG1_OFFSET used once
SIM_FCFG2 40048050

Symbol: SIM_FCFG2
   Definitions
      At line 3408 in file ..\Exercise
   Uses
      None
Comment: SIM_FCFG2 unused
SIM_FCFG2_OFFSET 00001050



ARM Macro Assembler    Page 346 Alphabetic symbol ordering
Absolute symbols


Symbol: SIM_FCFG2_OFFSET
   Definitions
      At line 3399 in file ..\Exercise
   Uses
      At line 3408 in file ..\Exercise
Comment: SIM_FCFG2_OFFSET used once
SIM_SCGC4 40048034

Symbol: SIM_SCGC4
   Definitions
      At line 3409 in file ..\Exercise
   Uses
      At line 915 in file ..\Exercise
Comment: SIM_SCGC4 used once
SIM_SCGC4_CMP_MASK 00080000

Symbol: SIM_SCGC4_CMP_MASK
   Definitions
      At line 3481 in file ..\Exercise
   Uses
      None
Comment: SIM_SCGC4_CMP_MASK unused
SIM_SCGC4_CMP_SHIFT 00000013

Symbol: SIM_SCGC4_CMP_SHIFT
   Definitions
      At line 3482 in file ..\Exercise
   Uses
      None
Comment: SIM_SCGC4_CMP_SHIFT unused
SIM_SCGC4_I2C0_MASK 00000040

Symbol: SIM_SCGC4_I2C0_MASK
   Definitions
      At line 3493 in file ..\Exercise
   Uses
      None
Comment: SIM_SCGC4_I2C0_MASK unused
SIM_SCGC4_I2C0_SHIFT 00000006

Symbol: SIM_SCGC4_I2C0_SHIFT
   Definitions
      At line 3494 in file ..\Exercise
   Uses
      None
Comment: SIM_SCGC4_I2C0_SHIFT unused
SIM_SCGC4_I2C1_MASK 00000080

Symbol: SIM_SCGC4_I2C1_MASK
   Definitions
      At line 3491 in file ..\Exercise
   Uses
      None
Comment: SIM_SCGC4_I2C1_MASK unused
SIM_SCGC4_I2C1_SHIFT 00000007

Symbol: SIM_SCGC4_I2C1_SHIFT
   Definitions



ARM Macro Assembler    Page 347 Alphabetic symbol ordering
Absolute symbols

      At line 3492 in file ..\Exercise
   Uses
      None
Comment: SIM_SCGC4_I2C1_SHIFT unused
SIM_SCGC4_OFFSET 00001034

Symbol: SIM_SCGC4_OFFSET
   Definitions
      At line 3393 in file ..\Exercise
   Uses
      At line 3409 in file ..\Exercise
Comment: SIM_SCGC4_OFFSET used once
SIM_SCGC4_SPI0_MASK 00400000

Symbol: SIM_SCGC4_SPI0_MASK
   Definitions
      At line 3479 in file ..\Exercise
   Uses
      None
Comment: SIM_SCGC4_SPI0_MASK unused
SIM_SCGC4_SPI0_SHIFT 00000016

Symbol: SIM_SCGC4_SPI0_SHIFT
   Definitions
      At line 3480 in file ..\Exercise
   Uses
      None
Comment: SIM_SCGC4_SPI0_SHIFT unused
SIM_SCGC4_SPI1_MASK 00800000

Symbol: SIM_SCGC4_SPI1_MASK
   Definitions
      At line 3477 in file ..\Exercise
   Uses
      None
Comment: SIM_SCGC4_SPI1_MASK unused
SIM_SCGC4_SPI1_SHIFT 00000017

Symbol: SIM_SCGC4_SPI1_SHIFT
   Definitions
      At line 3478 in file ..\Exercise
   Uses
      None
Comment: SIM_SCGC4_SPI1_SHIFT unused
SIM_SCGC4_UART0_MASK 00000400

Symbol: SIM_SCGC4_UART0_MASK
   Definitions
      At line 3489 in file ..\Exercise
   Uses
      At line 916 in file ..\Exercise
Comment: SIM_SCGC4_UART0_MASK used once
SIM_SCGC4_UART0_SHIFT 0000000A

Symbol: SIM_SCGC4_UART0_SHIFT
   Definitions
      At line 3490 in file ..\Exercise
   Uses
      None



ARM Macro Assembler    Page 348 Alphabetic symbol ordering
Absolute symbols

Comment: SIM_SCGC4_UART0_SHIFT unused
SIM_SCGC4_UART1_MASK 00000800

Symbol: SIM_SCGC4_UART1_MASK
   Definitions
      At line 3487 in file ..\Exercise
   Uses
      None
Comment: SIM_SCGC4_UART1_MASK unused
SIM_SCGC4_UART1_SHIFT 0000000B

Symbol: SIM_SCGC4_UART1_SHIFT
   Definitions
      At line 3488 in file ..\Exercise
   Uses
      None
Comment: SIM_SCGC4_UART1_SHIFT unused
SIM_SCGC4_UART2_MASK 00001000

Symbol: SIM_SCGC4_UART2_MASK
   Definitions
      At line 3485 in file ..\Exercise
   Uses
      None
Comment: SIM_SCGC4_UART2_MASK unused
SIM_SCGC4_UART2_SHIFT 0000000C

Symbol: SIM_SCGC4_UART2_SHIFT
   Definitions
      At line 3486 in file ..\Exercise
   Uses
      None
Comment: SIM_SCGC4_UART2_SHIFT unused
SIM_SCGC4_USBOTG_MASK 00040000

Symbol: SIM_SCGC4_USBOTG_MASK
   Definitions
      At line 3483 in file ..\Exercise
   Uses
      None
Comment: SIM_SCGC4_USBOTG_MASK unused
SIM_SCGC4_USBOTG_SHIFT 00000012

Symbol: SIM_SCGC4_USBOTG_SHIFT
   Definitions
      At line 3484 in file ..\Exercise
   Uses
      None
Comment: SIM_SCGC4_USBOTG_SHIFT unused
SIM_SCGC5 40048038

Symbol: SIM_SCGC5
   Definitions
      At line 3410 in file ..\Exercise
   Uses
      At line 410 in file ..\Exercise
      At line 921 in file ..\Exercise

SIM_SCGC5_LPTMR_MASK 00000001



ARM Macro Assembler    Page 349 Alphabetic symbol ordering
Absolute symbols


Symbol: SIM_SCGC5_LPTMR_MASK
   Definitions
      At line 3525 in file ..\Exercise
   Uses
      None
Comment: SIM_SCGC5_LPTMR_MASK unused
SIM_SCGC5_LPTMR_SHIFT 00000000

Symbol: SIM_SCGC5_LPTMR_SHIFT
   Definitions
      At line 3526 in file ..\Exercise
   Uses
      None
Comment: SIM_SCGC5_LPTMR_SHIFT unused
SIM_SCGC5_OFFSET 00001038

Symbol: SIM_SCGC5_OFFSET
   Definitions
      At line 3394 in file ..\Exercise
   Uses
      At line 3410 in file ..\Exercise
Comment: SIM_SCGC5_OFFSET used once
SIM_SCGC5_PORTA_MASK 00000200

Symbol: SIM_SCGC5_PORTA_MASK
   Definitions
      At line 3521 in file ..\Exercise
   Uses
      At line 922 in file ..\Exercise
Comment: SIM_SCGC5_PORTA_MASK used once
SIM_SCGC5_PORTA_SHIFT 00000009

Symbol: SIM_SCGC5_PORTA_SHIFT
   Definitions
      At line 3522 in file ..\Exercise
   Uses
      None
Comment: SIM_SCGC5_PORTA_SHIFT unused
SIM_SCGC5_PORTB_MASK 00000400

Symbol: SIM_SCGC5_PORTB_MASK
   Definitions
      At line 3519 in file ..\Exercise
   Uses
      None
Comment: SIM_SCGC5_PORTB_MASK unused
SIM_SCGC5_PORTB_SHIFT 0000000A

Symbol: SIM_SCGC5_PORTB_SHIFT
   Definitions
      At line 3520 in file ..\Exercise
   Uses
      None
Comment: SIM_SCGC5_PORTB_SHIFT unused
SIM_SCGC5_PORTC_MASK 00000800

Symbol: SIM_SCGC5_PORTC_MASK
   Definitions



ARM Macro Assembler    Page 350 Alphabetic symbol ordering
Absolute symbols

      At line 3517 in file ..\Exercise
   Uses
      None
Comment: SIM_SCGC5_PORTC_MASK unused
SIM_SCGC5_PORTC_SHIFT 0000000B

Symbol: SIM_SCGC5_PORTC_SHIFT
   Definitions
      At line 3518 in file ..\Exercise
   Uses
      None
Comment: SIM_SCGC5_PORTC_SHIFT unused
SIM_SCGC5_PORTD_MASK 00001000

Symbol: SIM_SCGC5_PORTD_MASK
   Definitions
      At line 3515 in file ..\Exercise
   Uses
      At line 412 in file ..\Exercise
Comment: SIM_SCGC5_PORTD_MASK used once
SIM_SCGC5_PORTD_SHIFT 0000000C

Symbol: SIM_SCGC5_PORTD_SHIFT
   Definitions
      At line 3516 in file ..\Exercise
   Uses
      None
Comment: SIM_SCGC5_PORTD_SHIFT unused
SIM_SCGC5_PORTE_MASK 00002000

Symbol: SIM_SCGC5_PORTE_MASK
   Definitions
      At line 3513 in file ..\Exercise
   Uses
      At line 412 in file ..\Exercise
Comment: SIM_SCGC5_PORTE_MASK used once
SIM_SCGC5_PORTE_SHIFT 0000000D

Symbol: SIM_SCGC5_PORTE_SHIFT
   Definitions
      At line 3514 in file ..\Exercise
   Uses
      None
Comment: SIM_SCGC5_PORTE_SHIFT unused
SIM_SCGC5_SLCD_MASK 00080000

Symbol: SIM_SCGC5_SLCD_MASK
   Definitions
      At line 3511 in file ..\Exercise
   Uses
      None
Comment: SIM_SCGC5_SLCD_MASK unused
SIM_SCGC5_SLCD_SHIFT 00000013

Symbol: SIM_SCGC5_SLCD_SHIFT
   Definitions
      At line 3512 in file ..\Exercise
   Uses
      None



ARM Macro Assembler    Page 351 Alphabetic symbol ordering
Absolute symbols

Comment: SIM_SCGC5_SLCD_SHIFT unused
SIM_SCGC5_TSI_MASK 00000020

Symbol: SIM_SCGC5_TSI_MASK
   Definitions
      At line 3523 in file ..\Exercise
   Uses
      None
Comment: SIM_SCGC5_TSI_MASK unused
SIM_SCGC5_TSI_SHIFT 00000006

Symbol: SIM_SCGC5_TSI_SHIFT
   Definitions
      At line 3524 in file ..\Exercise
   Uses
      None
Comment: SIM_SCGC5_TSI_SHIFT unused
SIM_SCGC6 4004803C

Symbol: SIM_SCGC6
   Definitions
      At line 3411 in file ..\Exercise
   Uses
      At line 335 in file ..\Exercise
Comment: SIM_SCGC6 used once
SIM_SCGC6_ADC0_MASK 08000000

Symbol: SIM_SCGC6_ADC0_MASK
   Definitions
      At line 3547 in file ..\Exercise
   Uses
      None
Comment: SIM_SCGC6_ADC0_MASK unused
SIM_SCGC6_ADC0_SHIFT 0000001B

Symbol: SIM_SCGC6_ADC0_SHIFT
   Definitions
      At line 3548 in file ..\Exercise
   Uses
      None
Comment: SIM_SCGC6_ADC0_SHIFT unused
SIM_SCGC6_DAC0_MASK 80000000

Symbol: SIM_SCGC6_DAC0_MASK
   Definitions
      At line 3543 in file ..\Exercise
   Uses
      None
Comment: SIM_SCGC6_DAC0_MASK unused
SIM_SCGC6_DAC0_SHIFT 0000001F

Symbol: SIM_SCGC6_DAC0_SHIFT
   Definitions
      At line 3544 in file ..\Exercise
   Uses
      None
Comment: SIM_SCGC6_DAC0_SHIFT unused
SIM_SCGC6_DMAMUX_MASK 00000002




ARM Macro Assembler    Page 352 Alphabetic symbol ordering
Absolute symbols

Symbol: SIM_SCGC6_DMAMUX_MASK
   Definitions
      At line 3557 in file ..\Exercise
   Uses
      None
Comment: SIM_SCGC6_DMAMUX_MASK unused
SIM_SCGC6_DMAMUX_SHIFT 00000001

Symbol: SIM_SCGC6_DMAMUX_SHIFT
   Definitions
      At line 3558 in file ..\Exercise
   Uses
      None
Comment: SIM_SCGC6_DMAMUX_SHIFT unused
SIM_SCGC6_FTF_MASK 00000001

Symbol: SIM_SCGC6_FTF_MASK
   Definitions
      At line 3559 in file ..\Exercise
   Uses
      None
Comment: SIM_SCGC6_FTF_MASK unused
SIM_SCGC6_FTF_SHIFT 00000000

Symbol: SIM_SCGC6_FTF_SHIFT
   Definitions
      At line 3560 in file ..\Exercise
   Uses
      None
Comment: SIM_SCGC6_FTF_SHIFT unused
SIM_SCGC6_OFFSET 0000103C

Symbol: SIM_SCGC6_OFFSET
   Definitions
      At line 3395 in file ..\Exercise
   Uses
      At line 3411 in file ..\Exercise
Comment: SIM_SCGC6_OFFSET used once
SIM_SCGC6_PIT_MASK 00800000

Symbol: SIM_SCGC6_PIT_MASK
   Definitions
      At line 3555 in file ..\Exercise
   Uses
      At line 336 in file ..\Exercise
Comment: SIM_SCGC6_PIT_MASK used once
SIM_SCGC6_PIT_SHIFT 00000017

Symbol: SIM_SCGC6_PIT_SHIFT
   Definitions
      At line 3556 in file ..\Exercise
   Uses
      None
Comment: SIM_SCGC6_PIT_SHIFT unused
SIM_SCGC6_RTC_MASK 20000000

Symbol: SIM_SCGC6_RTC_MASK
   Definitions
      At line 3545 in file ..\Exercise



ARM Macro Assembler    Page 353 Alphabetic symbol ordering
Absolute symbols

   Uses
      None
Comment: SIM_SCGC6_RTC_MASK unused
SIM_SCGC6_RTC_SHIFT 0000001D

Symbol: SIM_SCGC6_RTC_SHIFT
   Definitions
      At line 3546 in file ..\Exercise
   Uses
      None
Comment: SIM_SCGC6_RTC_SHIFT unused
SIM_SCGC6_TPM0_MASK 01000000

Symbol: SIM_SCGC6_TPM0_MASK
   Definitions
      At line 3553 in file ..\Exercise
   Uses
      None
Comment: SIM_SCGC6_TPM0_MASK unused
SIM_SCGC6_TPM0_SHIFT 00000018

Symbol: SIM_SCGC6_TPM0_SHIFT
   Definitions
      At line 3554 in file ..\Exercise
   Uses
      None
Comment: SIM_SCGC6_TPM0_SHIFT unused
SIM_SCGC6_TPM1_MASK 02000000

Symbol: SIM_SCGC6_TPM1_MASK
   Definitions
      At line 3551 in file ..\Exercise
   Uses
      None
Comment: SIM_SCGC6_TPM1_MASK unused
SIM_SCGC6_TPM1_SHIFT 00000019

Symbol: SIM_SCGC6_TPM1_SHIFT
   Definitions
      At line 3552 in file ..\Exercise
   Uses
      None
Comment: SIM_SCGC6_TPM1_SHIFT unused
SIM_SCGC6_TPM2_MASK 04000000

Symbol: SIM_SCGC6_TPM2_MASK
   Definitions
      At line 3549 in file ..\Exercise
   Uses
      None
Comment: SIM_SCGC6_TPM2_MASK unused
SIM_SCGC6_TPM2_SHIFT 0000001A

Symbol: SIM_SCGC6_TPM2_SHIFT
   Definitions
      At line 3550 in file ..\Exercise
   Uses
      None
Comment: SIM_SCGC6_TPM2_SHIFT unused



ARM Macro Assembler    Page 354 Alphabetic symbol ordering
Absolute symbols

SIM_SCGC7 40048040

Symbol: SIM_SCGC7
   Definitions
      At line 3412 in file ..\Exercise
   Uses
      None
Comment: SIM_SCGC7 unused
SIM_SCGC7_OFFSET 00001040

Symbol: SIM_SCGC7_OFFSET
   Definitions
      At line 3396 in file ..\Exercise
   Uses
      At line 3412 in file ..\Exercise
Comment: SIM_SCGC7_OFFSET used once
SIM_SDID 40048024

Symbol: SIM_SDID
   Definitions
      At line 3413 in file ..\Exercise
   Uses
      None
Comment: SIM_SDID unused
SIM_SDID_OFFSET 00001024

Symbol: SIM_SDID_OFFSET
   Definitions
      At line 3392 in file ..\Exercise
   Uses
      At line 3413 in file ..\Exercise
Comment: SIM_SDID_OFFSET used once
SIM_SOPT1 40047000

Symbol: SIM_SOPT1
   Definitions
      At line 3414 in file ..\Exercise
   Uses
      None
Comment: SIM_SOPT1 unused
SIM_SOPT1CFG 40047004

Symbol: SIM_SOPT1CFG
   Definitions
      At line 3415 in file ..\Exercise
   Uses
      None
Comment: SIM_SOPT1CFG unused
SIM_SOPT1CFG_OFFSET 00000004

Symbol: SIM_SOPT1CFG_OFFSET
   Definitions
      At line 3387 in file ..\Exercise
   Uses
      At line 3415 in file ..\Exercise
Comment: SIM_SOPT1CFG_OFFSET used once
SIM_SOPT1_OFFSET 00000000

Symbol: SIM_SOPT1_OFFSET



ARM Macro Assembler    Page 355 Alphabetic symbol ordering
Absolute symbols

   Definitions
      At line 3386 in file ..\Exercise
   Uses
      At line 3414 in file ..\Exercise
Comment: SIM_SOPT1_OFFSET used once
SIM_SOPT1_OSC32KSEL_MASK 000C0000

Symbol: SIM_SOPT1_OSC32KSEL_MASK
   Definitions
      At line 3575 in file ..\Exercise
   Uses
      None
Comment: SIM_SOPT1_OSC32KSEL_MASK unused
SIM_SOPT1_OSC32KSEL_SHIFT 00000012

Symbol: SIM_SOPT1_OSC32KSEL_SHIFT
   Definitions
      At line 3576 in file ..\Exercise
   Uses
      None
Comment: SIM_SOPT1_OSC32KSEL_SHIFT unused
SIM_SOPT1_USBREGEN_MASK 80000000

Symbol: SIM_SOPT1_USBREGEN_MASK
   Definitions
      At line 3581 in file ..\Exercise
   Uses
      None
Comment: SIM_SOPT1_USBREGEN_MASK unused
SIM_SOPT1_USBREGEN_SHIFT 0000001F

Symbol: SIM_SOPT1_USBREGEN_SHIFT
   Definitions
      At line 3582 in file ..\Exercise
   Uses
      None
Comment: SIM_SOPT1_USBREGEN_SHIFT unused
SIM_SOPT1_USBSSTBY_MASK 40000000

Symbol: SIM_SOPT1_USBSSTBY_MASK
   Definitions
      At line 3579 in file ..\Exercise
   Uses
      None
Comment: SIM_SOPT1_USBSSTBY_MASK unused
SIM_SOPT1_USBSSTBY_SHIFT 0000001E

Symbol: SIM_SOPT1_USBSSTBY_SHIFT
   Definitions
      At line 3580 in file ..\Exercise
   Uses
      None
Comment: SIM_SOPT1_USBSSTBY_SHIFT unused
SIM_SOPT1_USBVSTBY_MASK 20000000

Symbol: SIM_SOPT1_USBVSTBY_MASK
   Definitions
      At line 3577 in file ..\Exercise
   Uses



ARM Macro Assembler    Page 356 Alphabetic symbol ordering
Absolute symbols

      None
Comment: SIM_SOPT1_USBVSTBY_MASK unused
SIM_SOPT1_USBVSTBY_SHIFT 0000001D

Symbol: SIM_SOPT1_USBVSTBY_SHIFT
   Definitions
      At line 3578 in file ..\Exercise
   Uses
      None
Comment: SIM_SOPT1_USBVSTBY_SHIFT unused
SIM_SOPT2 40048004

Symbol: SIM_SOPT2
   Definitions
      At line 3416 in file ..\Exercise
   Uses
      At line 901 in file ..\Exercise
Comment: SIM_SOPT2 used once
SIM_SOPT2_CLKOUTSEL_MASK 000000E0

Symbol: SIM_SOPT2_CLKOUTSEL_MASK
   Definitions
      At line 3626 in file ..\Exercise
   Uses
      None
Comment: SIM_SOPT2_CLKOUTSEL_MASK unused
SIM_SOPT2_CLKOUTSEL_SHIFT 00000005

Symbol: SIM_SOPT2_CLKOUTSEL_SHIFT
   Definitions
      At line 3627 in file ..\Exercise
   Uses
      None
Comment: SIM_SOPT2_CLKOUTSEL_SHIFT unused
SIM_SOPT2_OFFSET 00001004

Symbol: SIM_SOPT2_OFFSET
   Definitions
      At line 3388 in file ..\Exercise
   Uses
      At line 3416 in file ..\Exercise
Comment: SIM_SOPT2_OFFSET used once
SIM_SOPT2_PLLFLLSEL_MASK 00010000

Symbol: SIM_SOPT2_PLLFLLSEL_MASK
   Definitions
      At line 3624 in file ..\Exercise
   Uses
      At line 101 in file ..\Exercise
Comment: SIM_SOPT2_PLLFLLSEL_MASK used once
SIM_SOPT2_PLLFLLSEL_SHIFT 00000010

Symbol: SIM_SOPT2_PLLFLLSEL_SHIFT
   Definitions
      At line 3625 in file ..\Exercise
   Uses
      None
Comment: SIM_SOPT2_PLLFLLSEL_SHIFT unused
SIM_SOPT2_RTCCLKOUTSEL_MASK 00000010



ARM Macro Assembler    Page 357 Alphabetic symbol ordering
Absolute symbols


Symbol: SIM_SOPT2_RTCCLKOUTSEL_MASK
   Definitions
      At line 3628 in file ..\Exercise
   Uses
      None
Comment: SIM_SOPT2_RTCCLKOUTSEL_MASK unused
SIM_SOPT2_RTCCLKOUTSEL_SHIFT 00000004

Symbol: SIM_SOPT2_RTCCLKOUTSEL_SHIFT
   Definitions
      At line 3629 in file ..\Exercise
   Uses
      None
Comment: SIM_SOPT2_RTCCLKOUTSEL_SHIFT unused
SIM_SOPT2_TPMSRC_MASK 03000000

Symbol: SIM_SOPT2_TPMSRC_MASK
   Definitions
      At line 3620 in file ..\Exercise
   Uses
      None
Comment: SIM_SOPT2_TPMSRC_MASK unused
SIM_SOPT2_TPMSRC_SHIFT 00000018

Symbol: SIM_SOPT2_TPMSRC_SHIFT
   Definitions
      At line 3621 in file ..\Exercise
   Uses
      None
Comment: SIM_SOPT2_TPMSRC_SHIFT unused
SIM_SOPT2_UART0SRC_MASK 0C000000

Symbol: SIM_SOPT2_UART0SRC_MASK
   Definitions
      At line 3618 in file ..\Exercise
   Uses
      At line 902 in file ..\Exercise
Comment: SIM_SOPT2_UART0SRC_MASK used once
SIM_SOPT2_UART0SRC_MCGPLLCLK 04000000

Symbol: SIM_SOPT2_UART0SRC_MCGPLLCLK
   Definitions
      At line 99 in file ..\Exercise
   Uses
      At line 101 in file ..\Exercise
Comment: SIM_SOPT2_UART0SRC_MCGPLLCLK used once
SIM_SOPT2_UART0SRC_SHIFT 0000001A

Symbol: SIM_SOPT2_UART0SRC_SHIFT
   Definitions
      At line 3619 in file ..\Exercise
   Uses
      At line 99 in file ..\Exercise
Comment: SIM_SOPT2_UART0SRC_SHIFT used once
SIM_SOPT2_UART0_MCGPLLCLK_DIV2 04010000

Symbol: SIM_SOPT2_UART0_MCGPLLCLK_DIV2
   Definitions



ARM Macro Assembler    Page 358 Alphabetic symbol ordering
Absolute symbols

      At line 101 in file ..\Exercise
   Uses
      At line 905 in file ..\Exercise
Comment: SIM_SOPT2_UART0_MCGPLLCLK_DIV2 used once
SIM_SOPT2_USBSRC_MASK 00040000

Symbol: SIM_SOPT2_USBSRC_MASK
   Definitions
      At line 3622 in file ..\Exercise
   Uses
      None
Comment: SIM_SOPT2_USBSRC_MASK unused
SIM_SOPT2_USBSRC_SHIFT 00000012

Symbol: SIM_SOPT2_USBSRC_SHIFT
   Definitions
      At line 3623 in file ..\Exercise
   Uses
      None
Comment: SIM_SOPT2_USBSRC_SHIFT unused
SIM_SOPT4 4004800C

Symbol: SIM_SOPT4
   Definitions
      At line 3417 in file ..\Exercise
   Uses
      None
Comment: SIM_SOPT4 unused
SIM_SOPT4_OFFSET 0000100C

Symbol: SIM_SOPT4_OFFSET
   Definitions
      At line 3389 in file ..\Exercise
   Uses
      At line 3417 in file ..\Exercise
Comment: SIM_SOPT4_OFFSET used once
SIM_SOPT5 40048010

Symbol: SIM_SOPT5
   Definitions
      At line 3418 in file ..\Exercise
   Uses
      At line 909 in file ..\Exercise
Comment: SIM_SOPT5 used once
SIM_SOPT5_OFFSET 00001010

Symbol: SIM_SOPT5_OFFSET
   Definitions
      At line 3390 in file ..\Exercise
   Uses
      At line 3418 in file ..\Exercise
Comment: SIM_SOPT5_OFFSET used once
SIM_SOPT5_UART0ODE_MASK 00010000

Symbol: SIM_SOPT5_UART0ODE_MASK
   Definitions
      At line 3659 in file ..\Exercise
   Uses
      At line 110 in file ..\Exercise



ARM Macro Assembler    Page 359 Alphabetic symbol ordering
Absolute symbols

Comment: SIM_SOPT5_UART0ODE_MASK used once
SIM_SOPT5_UART0ODE_SHIFT 00000010

Symbol: SIM_SOPT5_UART0ODE_SHIFT
   Definitions
      At line 3660 in file ..\Exercise
   Uses
      None
Comment: SIM_SOPT5_UART0ODE_SHIFT unused
SIM_SOPT5_UART0RXSRC_MASK 00000004

Symbol: SIM_SOPT5_UART0RXSRC_MASK
   Definitions
      At line 3665 in file ..\Exercise
   Uses
      At line 110 in file ..\Exercise
Comment: SIM_SOPT5_UART0RXSRC_MASK used once
SIM_SOPT5_UART0RXSRC_SHIFT 00000002

Symbol: SIM_SOPT5_UART0RXSRC_SHIFT
   Definitions
      At line 3666 in file ..\Exercise
   Uses
      None
Comment: SIM_SOPT5_UART0RXSRC_SHIFT unused
SIM_SOPT5_UART0TXSRC_MASK 00000003

Symbol: SIM_SOPT5_UART0TXSRC_MASK
   Definitions
      At line 3667 in file ..\Exercise
   Uses
      At line 110 in file ..\Exercise
Comment: SIM_SOPT5_UART0TXSRC_MASK used once
SIM_SOPT5_UART0TXSRC_SHIFT 00000000

Symbol: SIM_SOPT5_UART0TXSRC_SHIFT
   Definitions
      At line 3668 in file ..\Exercise
   Uses
      None
Comment: SIM_SOPT5_UART0TXSRC_SHIFT unused
SIM_SOPT5_UART0_EXTERN_MASK_CLEAR 00010007

Symbol: SIM_SOPT5_UART0_EXTERN_MASK_CLEAR
   Definitions
      At line 110 in file ..\Exercise
   Uses
      At line 910 in file ..\Exercise
Comment: SIM_SOPT5_UART0_EXTERN_MASK_CLEAR used once
SIM_SOPT5_UART1ODE_MASK 00020000

Symbol: SIM_SOPT5_UART1ODE_MASK
   Definitions
      At line 3657 in file ..\Exercise
   Uses
      None
Comment: SIM_SOPT5_UART1ODE_MASK unused
SIM_SOPT5_UART1ODE_SHIFT 00000011




ARM Macro Assembler    Page 360 Alphabetic symbol ordering
Absolute symbols

Symbol: SIM_SOPT5_UART1ODE_SHIFT
   Definitions
      At line 3658 in file ..\Exercise
   Uses
      None
Comment: SIM_SOPT5_UART1ODE_SHIFT unused
SIM_SOPT5_UART1RXSRC_MASK 00000040

Symbol: SIM_SOPT5_UART1RXSRC_MASK
   Definitions
      At line 3661 in file ..\Exercise
   Uses
      None
Comment: SIM_SOPT5_UART1RXSRC_MASK unused
SIM_SOPT5_UART1RXSRC_SHIFT 00000006

Symbol: SIM_SOPT5_UART1RXSRC_SHIFT
   Definitions
      At line 3662 in file ..\Exercise
   Uses
      None
Comment: SIM_SOPT5_UART1RXSRC_SHIFT unused
SIM_SOPT5_UART1TXSRC_MASK 00000030

Symbol: SIM_SOPT5_UART1TXSRC_MASK
   Definitions
      At line 3663 in file ..\Exercise
   Uses
      None
Comment: SIM_SOPT5_UART1TXSRC_MASK unused
SIM_SOPT5_UART1TXSRC_SHIFT 00000004

Symbol: SIM_SOPT5_UART1TXSRC_SHIFT
   Definitions
      At line 3664 in file ..\Exercise
   Uses
      None
Comment: SIM_SOPT5_UART1TXSRC_SHIFT unused
SIM_SOPT5_UART2ODE_MASK 00040000

Symbol: SIM_SOPT5_UART2ODE_MASK
   Definitions
      At line 3655 in file ..\Exercise
   Uses
      None
Comment: SIM_SOPT5_UART2ODE_MASK unused
SIM_SOPT5_UART2ODE_SHIFT 00000012

Symbol: SIM_SOPT5_UART2ODE_SHIFT
   Definitions
      At line 3656 in file ..\Exercise
   Uses
      None
Comment: SIM_SOPT5_UART2ODE_SHIFT unused
SIM_SOPT7 40048018

Symbol: SIM_SOPT7
   Definitions
      At line 3419 in file ..\Exercise



ARM Macro Assembler    Page 361 Alphabetic symbol ordering
Absolute symbols

   Uses
      None
Comment: SIM_SOPT7 unused
SIM_SOPT7_OFFSET 00001018

Symbol: SIM_SOPT7_OFFSET
   Definitions
      At line 3391 in file ..\Exercise
   Uses
      At line 3419 in file ..\Exercise
Comment: SIM_SOPT7_OFFSET used once
SIM_SRVCOP 40048104

Symbol: SIM_SRVCOP
   Definitions
      At line 3420 in file ..\Exercise
   Uses
      None
Comment: SIM_SRVCOP unused
SIM_SRVCOP_OFFSET 00001104

Symbol: SIM_SRVCOP_OFFSET
   Definitions
      At line 3404 in file ..\Exercise
   Uses
      At line 3420 in file ..\Exercise
Comment: SIM_SRVCOP_OFFSET used once
SIM_UIDL 40048060

Symbol: SIM_UIDL
   Definitions
      At line 3421 in file ..\Exercise
   Uses
      None
Comment: SIM_UIDL unused
SIM_UIDL_OFFSET 00001060

Symbol: SIM_UIDL_OFFSET
   Definitions
      At line 3402 in file ..\Exercise
   Uses
      At line 3421 in file ..\Exercise
Comment: SIM_UIDL_OFFSET used once
SIM_UIDMH 40048058

Symbol: SIM_UIDMH
   Definitions
      At line 3422 in file ..\Exercise
   Uses
      None
Comment: SIM_UIDMH unused
SIM_UIDMH_OFFSET 00001058

Symbol: SIM_UIDMH_OFFSET
   Definitions
      At line 3400 in file ..\Exercise
   Uses
      At line 3422 in file ..\Exercise
Comment: SIM_UIDMH_OFFSET used once



ARM Macro Assembler    Page 362 Alphabetic symbol ordering
Absolute symbols

SIM_UIDML 4004805C

Symbol: SIM_UIDML
   Definitions
      At line 3423 in file ..\Exercise
   Uses
      None
Comment: SIM_UIDML unused
SIM_UIDML_OFFSET 0000105C

Symbol: SIM_UIDML_OFFSET
   Definitions
      At line 3401 in file ..\Exercise
   Uses
      At line 3423 in file ..\Exercise
Comment: SIM_UIDML_OFFSET used once
SPI0_IPR E000E408

Symbol: SPI0_IPR
   Definitions
      At line 2673 in file ..\Exercise
   Uses
      None
Comment: SPI0_IPR unused
SPI0_IRQ 0000000A

Symbol: SPI0_IRQ
   Definitions
      At line 2743 in file ..\Exercise
   Uses
      At line 2777 in file ..\Exercise
Comment: SPI0_IRQ used once
SPI0_IRQ_MASK 00000400

Symbol: SPI0_IRQ_MASK
   Definitions
      At line 2777 in file ..\Exercise
   Uses
      None
Comment: SPI0_IRQ_MASK unused
SPI0_IRQn 0000000A

Symbol: SPI0_IRQn
   Definitions
      At line 156 in file ..\Exercise
   Uses
      None
Comment: SPI0_IRQn unused
SPI0_PRI_POS 00000016

Symbol: SPI0_PRI_POS
   Definitions
      At line 2709 in file ..\Exercise
   Uses
      None
Comment: SPI0_PRI_POS unused
SPI0_Vector 0000001A

Symbol: SPI0_Vector



ARM Macro Assembler    Page 363 Alphabetic symbol ordering
Absolute symbols

   Definitions
      At line 2827 in file ..\Exercise
   Uses
      None
Comment: SPI0_Vector unused
SPI1_IPR E000E408

Symbol: SPI1_IPR
   Definitions
      At line 2674 in file ..\Exercise
   Uses
      None
Comment: SPI1_IPR unused
SPI1_IRQ 0000000B

Symbol: SPI1_IRQ
   Definitions
      At line 2744 in file ..\Exercise
   Uses
      At line 2778 in file ..\Exercise
Comment: SPI1_IRQ used once
SPI1_IRQ_MASK 00000800

Symbol: SPI1_IRQ_MASK
   Definitions
      At line 2778 in file ..\Exercise
   Uses
      None
Comment: SPI1_IRQ_MASK unused
SPI1_IRQn 0000000B

Symbol: SPI1_IRQn
   Definitions
      At line 157 in file ..\Exercise
   Uses
      None
Comment: SPI1_IRQn unused
SPI1_PRI_POS 0000001E

Symbol: SPI1_PRI_POS
   Definitions
      At line 2710 in file ..\Exercise
   Uses
      None
Comment: SPI1_PRI_POS unused
SPI1_Vector 0000001B

Symbol: SPI1_Vector
   Definitions
      At line 2828 in file ..\Exercise
   Uses
      None
Comment: SPI1_Vector unused
SVCall_IRQn FFFFFFFB

Symbol: SVCall_IRQn
   Definitions
      At line 140 in file ..\Exercise
   Uses



ARM Macro Assembler    Page 364 Alphabetic symbol ordering
Absolute symbols

      None
Comment: SVCall_IRQn unused
SVCall_Vector 0000000B

Symbol: SVCall_Vector
   Definitions
      At line 2812 in file ..\Exercise
   Uses
      None
Comment: SVCall_Vector unused
SysTick_IRQn FFFFFFFF

Symbol: SysTick_IRQn
   Definitions
      At line 143 in file ..\Exercise
   Uses
      None
Comment: SysTick_IRQn unused
SysTick_Vector 0000000F

Symbol: SysTick_Vector
   Definitions
      At line 2816 in file ..\Exercise
   Uses
      None
Comment: SysTick_Vector unused
TMP0_IPR E000E410

Symbol: TMP0_IPR
   Definitions
      At line 2680 in file ..\Exercise
   Uses
      None
Comment: TMP0_IPR unused
TMP0_IRQ 0000000F

Symbol: TMP0_IRQ
   Definitions
      At line 2750 in file ..\Exercise
   Uses
      At line 2784 in file ..\Exercise
Comment: TMP0_IRQ used once
TMP0_IRQ_MASK 00008000

Symbol: TMP0_IRQ_MASK
   Definitions
      At line 2784 in file ..\Exercise
   Uses
      None
Comment: TMP0_IRQ_MASK unused
TMP0_PRI_POS 0000000E

Symbol: TMP0_PRI_POS
   Definitions
      At line 2716 in file ..\Exercise
   Uses
      None
Comment: TMP0_PRI_POS unused
TMP0_Vector 00000021



ARM Macro Assembler    Page 365 Alphabetic symbol ordering
Absolute symbols


Symbol: TMP0_Vector
   Definitions
      At line 2834 in file ..\Exercise
   Uses
      None
Comment: TMP0_Vector unused
TPM0_BASE 40038000

Symbol: TPM0_BASE
   Definitions
      At line 3856 in file ..\Exercise
   Uses
      At line 3857 in file ..\Exercise
      At line 3858 in file ..\Exercise
      At line 3859 in file ..\Exercise
      At line 3860 in file ..\Exercise
      At line 3861 in file ..\Exercise
      At line 3862 in file ..\Exercise
      At line 3863 in file ..\Exercise
      At line 3864 in file ..\Exercise
      At line 3865 in file ..\Exercise
      At line 3866 in file ..\Exercise
      At line 3867 in file ..\Exercise
      At line 3868 in file ..\Exercise
      At line 3869 in file ..\Exercise
      At line 3870 in file ..\Exercise
      At line 3871 in file ..\Exercise
      At line 3872 in file ..\Exercise
      At line 3873 in file ..\Exercise

TPM0_C0SC 4003800C

Symbol: TPM0_C0SC
   Definitions
      At line 3860 in file ..\Exercise
   Uses
      None
Comment: TPM0_C0SC unused
TPM0_C0V 40038010

Symbol: TPM0_C0V
   Definitions
      At line 3861 in file ..\Exercise
   Uses
      None
Comment: TPM0_C0V unused
TPM0_C1SC 40038014

Symbol: TPM0_C1SC
   Definitions
      At line 3862 in file ..\Exercise
   Uses
      None
Comment: TPM0_C1SC unused
TPM0_C1V 40038018

Symbol: TPM0_C1V
   Definitions



ARM Macro Assembler    Page 366 Alphabetic symbol ordering
Absolute symbols

      At line 3863 in file ..\Exercise
   Uses
      None
Comment: TPM0_C1V unused
TPM0_C2SC 4003801C

Symbol: TPM0_C2SC
   Definitions
      At line 3864 in file ..\Exercise
   Uses
      None
Comment: TPM0_C2SC unused
TPM0_C2V 40038020

Symbol: TPM0_C2V
   Definitions
      At line 3865 in file ..\Exercise
   Uses
      None
Comment: TPM0_C2V unused
TPM0_C3SC 40038024

Symbol: TPM0_C3SC
   Definitions
      At line 3866 in file ..\Exercise
   Uses
      None
Comment: TPM0_C3SC unused
TPM0_C3V 40038028

Symbol: TPM0_C3V
   Definitions
      At line 3867 in file ..\Exercise
   Uses
      None
Comment: TPM0_C3V unused
TPM0_C4SC 4003802C

Symbol: TPM0_C4SC
   Definitions
      At line 3868 in file ..\Exercise
   Uses
      None
Comment: TPM0_C4SC unused
TPM0_C4V 40038030

Symbol: TPM0_C4V
   Definitions
      At line 3869 in file ..\Exercise
   Uses
      None
Comment: TPM0_C4V unused
TPM0_C5SC 40038034

Symbol: TPM0_C5SC
   Definitions
      At line 3870 in file ..\Exercise
   Uses
      None



ARM Macro Assembler    Page 367 Alphabetic symbol ordering
Absolute symbols

Comment: TPM0_C5SC unused
TPM0_C5V 40038038

Symbol: TPM0_C5V
   Definitions
      At line 3871 in file ..\Exercise
   Uses
      None
Comment: TPM0_C5V unused
TPM0_CNT 40038004

Symbol: TPM0_CNT
   Definitions
      At line 3858 in file ..\Exercise
   Uses
      None
Comment: TPM0_CNT unused
TPM0_CONF 40038084

Symbol: TPM0_CONF
   Definitions
      At line 3873 in file ..\Exercise
   Uses
      None
Comment: TPM0_CONF unused
TPM0_IRQn 00000011

Symbol: TPM0_IRQn
   Definitions
      At line 163 in file ..\Exercise
   Uses
      None
Comment: TPM0_IRQn unused
TPM0_MOD 40038008

Symbol: TPM0_MOD
   Definitions
      At line 3859 in file ..\Exercise
   Uses
      None
Comment: TPM0_MOD unused
TPM0_SC 40038000

Symbol: TPM0_SC
   Definitions
      At line 3857 in file ..\Exercise
   Uses
      None
Comment: TPM0_SC unused
TPM0_STATUS 40038050

Symbol: TPM0_STATUS
   Definitions
      At line 3872 in file ..\Exercise
   Uses
      None
Comment: TPM0_STATUS unused
TPM1_BASE 40039000




ARM Macro Assembler    Page 368 Alphabetic symbol ordering
Absolute symbols

Symbol: TPM1_BASE
   Definitions
      At line 3876 in file ..\Exercise
   Uses
      At line 3877 in file ..\Exercise
      At line 3878 in file ..\Exercise
      At line 3879 in file ..\Exercise
      At line 3880 in file ..\Exercise
      At line 3881 in file ..\Exercise
      At line 3882 in file ..\Exercise
      At line 3883 in file ..\Exercise
      At line 3884 in file ..\Exercise
      At line 3885 in file ..\Exercise
      At line 3886 in file ..\Exercise
      At line 3887 in file ..\Exercise
      At line 3888 in file ..\Exercise
      At line 3889 in file ..\Exercise
      At line 3890 in file ..\Exercise
      At line 3891 in file ..\Exercise
      At line 3892 in file ..\Exercise
      At line 3893 in file ..\Exercise

TPM1_C0SC 4003900C

Symbol: TPM1_C0SC
   Definitions
      At line 3880 in file ..\Exercise
   Uses
      None
Comment: TPM1_C0SC unused
TPM1_C0V 40039010

Symbol: TPM1_C0V
   Definitions
      At line 3881 in file ..\Exercise
   Uses
      None
Comment: TPM1_C0V unused
TPM1_C1SC 40039014

Symbol: TPM1_C1SC
   Definitions
      At line 3882 in file ..\Exercise
   Uses
      None
Comment: TPM1_C1SC unused
TPM1_C1V 40039018

Symbol: TPM1_C1V
   Definitions
      At line 3883 in file ..\Exercise
   Uses
      None
Comment: TPM1_C1V unused
TPM1_C2SC 4003901C

Symbol: TPM1_C2SC
   Definitions
      At line 3884 in file ..\Exercise



ARM Macro Assembler    Page 369 Alphabetic symbol ordering
Absolute symbols

   Uses
      None
Comment: TPM1_C2SC unused
TPM1_C2V 40039020

Symbol: TPM1_C2V
   Definitions
      At line 3885 in file ..\Exercise
   Uses
      None
Comment: TPM1_C2V unused
TPM1_C3SC 40039024

Symbol: TPM1_C3SC
   Definitions
      At line 3886 in file ..\Exercise
   Uses
      None
Comment: TPM1_C3SC unused
TPM1_C3V 40039028

Symbol: TPM1_C3V
   Definitions
      At line 3887 in file ..\Exercise
   Uses
      None
Comment: TPM1_C3V unused
TPM1_C4SC 4003902C

Symbol: TPM1_C4SC
   Definitions
      At line 3888 in file ..\Exercise
   Uses
      None
Comment: TPM1_C4SC unused
TPM1_C4V 40039030

Symbol: TPM1_C4V
   Definitions
      At line 3889 in file ..\Exercise
   Uses
      None
Comment: TPM1_C4V unused
TPM1_C5SC 40039034

Symbol: TPM1_C5SC
   Definitions
      At line 3890 in file ..\Exercise
   Uses
      None
Comment: TPM1_C5SC unused
TPM1_C5V 40039038

Symbol: TPM1_C5V
   Definitions
      At line 3891 in file ..\Exercise
   Uses
      None
Comment: TPM1_C5V unused



ARM Macro Assembler    Page 370 Alphabetic symbol ordering
Absolute symbols

TPM1_CNT 40039004

Symbol: TPM1_CNT
   Definitions
      At line 3878 in file ..\Exercise
   Uses
      None
Comment: TPM1_CNT unused
TPM1_CONF 40039084

Symbol: TPM1_CONF
   Definitions
      At line 3893 in file ..\Exercise
   Uses
      None
Comment: TPM1_CONF unused
TPM1_IPR E000E410

Symbol: TPM1_IPR
   Definitions
      At line 2681 in file ..\Exercise
   Uses
      None
Comment: TPM1_IPR unused
TPM1_IRQ 00000012

Symbol: TPM1_IRQ
   Definitions
      At line 2751 in file ..\Exercise
   Uses
      At line 2785 in file ..\Exercise
Comment: TPM1_IRQ used once
TPM1_IRQ_MASK 00040000

Symbol: TPM1_IRQ_MASK
   Definitions
      At line 2785 in file ..\Exercise
   Uses
      None
Comment: TPM1_IRQ_MASK unused
TPM1_IRQn 00000012

Symbol: TPM1_IRQn
   Definitions
      At line 164 in file ..\Exercise
   Uses
      None
Comment: TPM1_IRQn unused
TPM1_MOD 40039008

Symbol: TPM1_MOD
   Definitions
      At line 3879 in file ..\Exercise
   Uses
      None
Comment: TPM1_MOD unused
TPM1_PRI_POS 00000016

Symbol: TPM1_PRI_POS



ARM Macro Assembler    Page 371 Alphabetic symbol ordering
Absolute symbols

   Definitions
      At line 2717 in file ..\Exercise
   Uses
      None
Comment: TPM1_PRI_POS unused
TPM1_SC 40039000

Symbol: TPM1_SC
   Definitions
      At line 3877 in file ..\Exercise
   Uses
      None
Comment: TPM1_SC unused
TPM1_STATUS 40039050

Symbol: TPM1_STATUS
   Definitions
      At line 3892 in file ..\Exercise
   Uses
      None
Comment: TPM1_STATUS unused
TPM1_Vector 00000022

Symbol: TPM1_Vector
   Definitions
      At line 2835 in file ..\Exercise
   Uses
      None
Comment: TPM1_Vector unused
TPM2_BASE 4003A000

Symbol: TPM2_BASE
   Definitions
      At line 3896 in file ..\Exercise
   Uses
      At line 3897 in file ..\Exercise
      At line 3898 in file ..\Exercise
      At line 3899 in file ..\Exercise
      At line 3900 in file ..\Exercise
      At line 3901 in file ..\Exercise
      At line 3902 in file ..\Exercise
      At line 3903 in file ..\Exercise
      At line 3904 in file ..\Exercise
      At line 3905 in file ..\Exercise
      At line 3906 in file ..\Exercise
      At line 3907 in file ..\Exercise
      At line 3908 in file ..\Exercise
      At line 3909 in file ..\Exercise
      At line 3910 in file ..\Exercise
      At line 3911 in file ..\Exercise
      At line 3912 in file ..\Exercise
      At line 3913 in file ..\Exercise

TPM2_C0SC 4003A00C

Symbol: TPM2_C0SC
   Definitions
      At line 3900 in file ..\Exercise
   Uses



ARM Macro Assembler    Page 372 Alphabetic symbol ordering
Absolute symbols

      None
Comment: TPM2_C0SC unused
TPM2_C0V 4003A010

Symbol: TPM2_C0V
   Definitions
      At line 3901 in file ..\Exercise
   Uses
      None
Comment: TPM2_C0V unused
TPM2_C1SC 4003A014

Symbol: TPM2_C1SC
   Definitions
      At line 3902 in file ..\Exercise
   Uses
      None
Comment: TPM2_C1SC unused
TPM2_C1V 4003A018

Symbol: TPM2_C1V
   Definitions
      At line 3903 in file ..\Exercise
   Uses
      None
Comment: TPM2_C1V unused
TPM2_C2SC 4003A01C

Symbol: TPM2_C2SC
   Definitions
      At line 3904 in file ..\Exercise
   Uses
      None
Comment: TPM2_C2SC unused
TPM2_C2V 4003A020

Symbol: TPM2_C2V
   Definitions
      At line 3905 in file ..\Exercise
   Uses
      None
Comment: TPM2_C2V unused
TPM2_C3SC 4003A024

Symbol: TPM2_C3SC
   Definitions
      At line 3906 in file ..\Exercise
   Uses
      None
Comment: TPM2_C3SC unused
TPM2_C3V 4003A028

Symbol: TPM2_C3V
   Definitions
      At line 3907 in file ..\Exercise
   Uses
      None
Comment: TPM2_C3V unused
TPM2_C4SC 4003A02C



ARM Macro Assembler    Page 373 Alphabetic symbol ordering
Absolute symbols


Symbol: TPM2_C4SC
   Definitions
      At line 3908 in file ..\Exercise
   Uses
      None
Comment: TPM2_C4SC unused
TPM2_C4V 4003A030

Symbol: TPM2_C4V
   Definitions
      At line 3909 in file ..\Exercise
   Uses
      None
Comment: TPM2_C4V unused
TPM2_C5SC 4003A034

Symbol: TPM2_C5SC
   Definitions
      At line 3910 in file ..\Exercise
   Uses
      None
Comment: TPM2_C5SC unused
TPM2_C5V 4003A038

Symbol: TPM2_C5V
   Definitions
      At line 3911 in file ..\Exercise
   Uses
      None
Comment: TPM2_C5V unused
TPM2_CNT 4003A004

Symbol: TPM2_CNT
   Definitions
      At line 3898 in file ..\Exercise
   Uses
      None
Comment: TPM2_CNT unused
TPM2_CONF 4003A084

Symbol: TPM2_CONF
   Definitions
      At line 3913 in file ..\Exercise
   Uses
      None
Comment: TPM2_CONF unused
TPM2_IPR E000E410

Symbol: TPM2_IPR
   Definitions
      At line 2682 in file ..\Exercise
   Uses
      None
Comment: TPM2_IPR unused
TPM2_IRQ 00000013

Symbol: TPM2_IRQ
   Definitions



ARM Macro Assembler    Page 374 Alphabetic symbol ordering
Absolute symbols

      At line 2752 in file ..\Exercise
   Uses
      At line 2786 in file ..\Exercise
Comment: TPM2_IRQ used once
TPM2_IRQ_MASK 00080000

Symbol: TPM2_IRQ_MASK
   Definitions
      At line 2786 in file ..\Exercise
   Uses
      None
Comment: TPM2_IRQ_MASK unused
TPM2_IRQn 00000013

Symbol: TPM2_IRQn
   Definitions
      At line 165 in file ..\Exercise
   Uses
      None
Comment: TPM2_IRQn unused
TPM2_MOD 4003A008

Symbol: TPM2_MOD
   Definitions
      At line 3899 in file ..\Exercise
   Uses
      None
Comment: TPM2_MOD unused
TPM2_PRI_POS 0000001E

Symbol: TPM2_PRI_POS
   Definitions
      At line 2718 in file ..\Exercise
   Uses
      None
Comment: TPM2_PRI_POS unused
TPM2_SC 4003A000

Symbol: TPM2_SC
   Definitions
      At line 3897 in file ..\Exercise
   Uses
      None
Comment: TPM2_SC unused
TPM2_STATUS 4003A050

Symbol: TPM2_STATUS
   Definitions
      At line 3912 in file ..\Exercise
   Uses
      None
Comment: TPM2_STATUS unused
TPM2_Vector 00000023

Symbol: TPM2_Vector
   Definitions
      At line 2836 in file ..\Exercise
   Uses
      None



ARM Macro Assembler    Page 375 Alphabetic symbol ordering
Absolute symbols

Comment: TPM2_Vector unused
TPM_C0SC_OFFSET 0000000C

Symbol: TPM_C0SC_OFFSET
   Definitions
      At line 3674 in file ..\Exercise
   Uses
      At line 3860 in file ..\Exercise
      At line 3880 in file ..\Exercise
      At line 3900 in file ..\Exercise

TPM_C0V_OFFSET 00000010

Symbol: TPM_C0V_OFFSET
   Definitions
      At line 3675 in file ..\Exercise
   Uses
      At line 3861 in file ..\Exercise
      At line 3881 in file ..\Exercise
      At line 3901 in file ..\Exercise

TPM_C1SC_OFFSET 00000014

Symbol: TPM_C1SC_OFFSET
   Definitions
      At line 3676 in file ..\Exercise
   Uses
      At line 3862 in file ..\Exercise
      At line 3882 in file ..\Exercise
      At line 3902 in file ..\Exercise

TPM_C1V_OFFSET 00000018

Symbol: TPM_C1V_OFFSET
   Definitions
      At line 3677 in file ..\Exercise
   Uses
      At line 3863 in file ..\Exercise
      At line 3883 in file ..\Exercise
      At line 3903 in file ..\Exercise

TPM_C2SC_OFFSET 0000001C

Symbol: TPM_C2SC_OFFSET
   Definitions
      At line 3678 in file ..\Exercise
   Uses
      At line 3864 in file ..\Exercise
      At line 3884 in file ..\Exercise
      At line 3904 in file ..\Exercise

TPM_C2V_OFFSET 00000020

Symbol: TPM_C2V_OFFSET
   Definitions
      At line 3679 in file ..\Exercise
   Uses
      At line 3865 in file ..\Exercise
      At line 3885 in file ..\Exercise



ARM Macro Assembler    Page 376 Alphabetic symbol ordering
Absolute symbols

      At line 3905 in file ..\Exercise

TPM_C3SC_OFFSET 00000024

Symbol: TPM_C3SC_OFFSET
   Definitions
      At line 3680 in file ..\Exercise
   Uses
      At line 3866 in file ..\Exercise
      At line 3886 in file ..\Exercise
      At line 3906 in file ..\Exercise

TPM_C3V_OFFSET 00000028

Symbol: TPM_C3V_OFFSET
   Definitions
      At line 3681 in file ..\Exercise
   Uses
      At line 3867 in file ..\Exercise
      At line 3887 in file ..\Exercise
      At line 3907 in file ..\Exercise

TPM_C4SC_OFFSET 0000002C

Symbol: TPM_C4SC_OFFSET
   Definitions
      At line 3682 in file ..\Exercise
   Uses
      At line 3868 in file ..\Exercise
      At line 3888 in file ..\Exercise
      At line 3908 in file ..\Exercise

TPM_C4V_OFFSET 00000030

Symbol: TPM_C4V_OFFSET
   Definitions
      At line 3683 in file ..\Exercise
   Uses
      At line 3869 in file ..\Exercise
      At line 3889 in file ..\Exercise
      At line 3909 in file ..\Exercise

TPM_C5SC_OFFSET 00000034

Symbol: TPM_C5SC_OFFSET
   Definitions
      At line 3684 in file ..\Exercise
   Uses
      At line 3870 in file ..\Exercise
      At line 3890 in file ..\Exercise
      At line 3910 in file ..\Exercise

TPM_C5V_OFFSET 00000038

Symbol: TPM_C5V_OFFSET
   Definitions
      At line 3685 in file ..\Exercise
   Uses
      At line 3871 in file ..\Exercise



ARM Macro Assembler    Page 377 Alphabetic symbol ordering
Absolute symbols

      At line 3891 in file ..\Exercise
      At line 3911 in file ..\Exercise

TPM_CNT_OFFSET 00000004

Symbol: TPM_CNT_OFFSET
   Definitions
      At line 3672 in file ..\Exercise
   Uses
      At line 3858 in file ..\Exercise
      At line 3878 in file ..\Exercise
      At line 3898 in file ..\Exercise

TPM_CONF_CROT_MASK 00040000

Symbol: TPM_CONF_CROT_MASK
   Definitions
      At line 3780 in file ..\Exercise
   Uses
      None
Comment: TPM_CONF_CROT_MASK unused
TPM_CONF_CROT_SHIFT 00000012

Symbol: TPM_CONF_CROT_SHIFT
   Definitions
      At line 3781 in file ..\Exercise
   Uses
      None
Comment: TPM_CONF_CROT_SHIFT unused
TPM_CONF_CSOO_MASK 00020000

Symbol: TPM_CONF_CSOO_MASK
   Definitions
      At line 3782 in file ..\Exercise
   Uses
      None
Comment: TPM_CONF_CSOO_MASK unused
TPM_CONF_CSOO_SHIFT 00000011

Symbol: TPM_CONF_CSOO_SHIFT
   Definitions
      At line 3783 in file ..\Exercise
   Uses
      None
Comment: TPM_CONF_CSOO_SHIFT unused
TPM_CONF_CSOT_MASK 00010000

Symbol: TPM_CONF_CSOT_MASK
   Definitions
      At line 3784 in file ..\Exercise
   Uses
      None
Comment: TPM_CONF_CSOT_MASK unused
TPM_CONF_CSOT_SHIFT 00000010

Symbol: TPM_CONF_CSOT_SHIFT
   Definitions
      At line 3785 in file ..\Exercise
   Uses



ARM Macro Assembler    Page 378 Alphabetic symbol ordering
Absolute symbols

      None
Comment: TPM_CONF_CSOT_SHIFT unused
TPM_CONF_DBGMODE_MASK 000000C0

Symbol: TPM_CONF_DBGMODE_MASK
   Definitions
      At line 3788 in file ..\Exercise
   Uses
      None
Comment: TPM_CONF_DBGMODE_MASK unused
TPM_CONF_DBGMODE_SHIFT 00000006

Symbol: TPM_CONF_DBGMODE_SHIFT
   Definitions
      At line 3789 in file ..\Exercise
   Uses
      None
Comment: TPM_CONF_DBGMODE_SHIFT unused
TPM_CONF_DOZEEN_MASK 00000020

Symbol: TPM_CONF_DOZEEN_MASK
   Definitions
      At line 3790 in file ..\Exercise
   Uses
      None
Comment: TPM_CONF_DOZEEN_MASK unused
TPM_CONF_DOZEEN_SHIFT 00000005

Symbol: TPM_CONF_DOZEEN_SHIFT
   Definitions
      At line 3791 in file ..\Exercise
   Uses
      None
Comment: TPM_CONF_DOZEEN_SHIFT unused
TPM_CONF_GTBEEN_MASK 00000200

Symbol: TPM_CONF_GTBEEN_MASK
   Definitions
      At line 3786 in file ..\Exercise
   Uses
      None
Comment: TPM_CONF_GTBEEN_MASK unused
TPM_CONF_GTBEEN_SHIFT 00000009

Symbol: TPM_CONF_GTBEEN_SHIFT
   Definitions
      At line 3787 in file ..\Exercise
   Uses
      None
Comment: TPM_CONF_GTBEEN_SHIFT unused
TPM_CONF_OFFSET 00000084

Symbol: TPM_CONF_OFFSET
   Definitions
      At line 3687 in file ..\Exercise
   Uses
      At line 3873 in file ..\Exercise
      At line 3893 in file ..\Exercise
      At line 3913 in file ..\Exercise



ARM Macro Assembler    Page 379 Alphabetic symbol ordering
Absolute symbols


TPM_CONF_TRGSEL_MASK 0F000000

Symbol: TPM_CONF_TRGSEL_MASK
   Definitions
      At line 3778 in file ..\Exercise
   Uses
      None
Comment: TPM_CONF_TRGSEL_MASK unused
TPM_CONF_TRGSEL_SHIFT 00000018

Symbol: TPM_CONF_TRGSEL_SHIFT
   Definitions
      At line 3779 in file ..\Exercise
   Uses
      None
Comment: TPM_CONF_TRGSEL_SHIFT unused
TPM_CnSC_CDMA_MASK 00000001

Symbol: TPM_CnSC_CDMA_MASK
   Definitions
      At line 3728 in file ..\Exercise
   Uses
      None
Comment: TPM_CnSC_CDMA_MASK unused
TPM_CnSC_CDMA_SHIFT 00000000

Symbol: TPM_CnSC_CDMA_SHIFT
   Definitions
      At line 3729 in file ..\Exercise
   Uses
      None
Comment: TPM_CnSC_CDMA_SHIFT unused
TPM_CnSC_CHF_MASK 00000080

Symbol: TPM_CnSC_CHF_MASK
   Definitions
      At line 3716 in file ..\Exercise
   Uses
      None
Comment: TPM_CnSC_CHF_MASK unused
TPM_CnSC_CHF_SHIFT 00000007

Symbol: TPM_CnSC_CHF_SHIFT
   Definitions
      At line 3717 in file ..\Exercise
   Uses
      None
Comment: TPM_CnSC_CHF_SHIFT unused
TPM_CnSC_CHIE_MASK 00000040

Symbol: TPM_CnSC_CHIE_MASK
   Definitions
      At line 3718 in file ..\Exercise
   Uses
      None
Comment: TPM_CnSC_CHIE_MASK unused
TPM_CnSC_CHIE_SHIFT 00000006




ARM Macro Assembler    Page 380 Alphabetic symbol ordering
Absolute symbols

Symbol: TPM_CnSC_CHIE_SHIFT
   Definitions
      At line 3719 in file ..\Exercise
   Uses
      None
Comment: TPM_CnSC_CHIE_SHIFT unused
TPM_CnSC_ELSA_MASK 00000004

Symbol: TPM_CnSC_ELSA_MASK
   Definitions
      At line 3726 in file ..\Exercise
   Uses
      None
Comment: TPM_CnSC_ELSA_MASK unused
TPM_CnSC_ELSA_SHIFT 00000002

Symbol: TPM_CnSC_ELSA_SHIFT
   Definitions
      At line 3727 in file ..\Exercise
   Uses
      None
Comment: TPM_CnSC_ELSA_SHIFT unused
TPM_CnSC_ELSB_MASK 00000008

Symbol: TPM_CnSC_ELSB_MASK
   Definitions
      At line 3724 in file ..\Exercise
   Uses
      None
Comment: TPM_CnSC_ELSB_MASK unused
TPM_CnSC_ELSB_SHIFT 00000003

Symbol: TPM_CnSC_ELSB_SHIFT
   Definitions
      At line 3725 in file ..\Exercise
   Uses
      None
Comment: TPM_CnSC_ELSB_SHIFT unused
TPM_CnSC_MSA_MASK 00000010

Symbol: TPM_CnSC_MSA_MASK
   Definitions
      At line 3722 in file ..\Exercise
   Uses
      None
Comment: TPM_CnSC_MSA_MASK unused
TPM_CnSC_MSA_SHIFT 00000004

Symbol: TPM_CnSC_MSA_SHIFT
   Definitions
      At line 3723 in file ..\Exercise
   Uses
      None
Comment: TPM_CnSC_MSA_SHIFT unused
TPM_CnSC_MSB_MASK 00000020

Symbol: TPM_CnSC_MSB_MASK
   Definitions
      At line 3720 in file ..\Exercise



ARM Macro Assembler    Page 381 Alphabetic symbol ordering
Absolute symbols

   Uses
      None
Comment: TPM_CnSC_MSB_MASK unused
TPM_CnSC_MSB_SHIFT 00000005

Symbol: TPM_CnSC_MSB_SHIFT
   Definitions
      At line 3721 in file ..\Exercise
   Uses
      None
Comment: TPM_CnSC_MSB_SHIFT unused
TPM_CnV_VAL_MASK 0000FFFF

Symbol: TPM_CnV_VAL_MASK
   Definitions
      At line 3734 in file ..\Exercise
   Uses
      None
Comment: TPM_CnV_VAL_MASK unused
TPM_CnV_VAL_SHIFT 00000000

Symbol: TPM_CnV_VAL_SHIFT
   Definitions
      At line 3735 in file ..\Exercise
   Uses
      None
Comment: TPM_CnV_VAL_SHIFT unused
TPM_MOD_MOD_MASK 0000FFFF

Symbol: TPM_MOD_MOD_MASK
   Definitions
      At line 3796 in file ..\Exercise
   Uses
      None
Comment: TPM_MOD_MOD_MASK unused
TPM_MOD_MOD_SHIFT 0000FFFF

Symbol: TPM_MOD_MOD_SHIFT
   Definitions
      At line 3797 in file ..\Exercise
   Uses
      None
Comment: TPM_MOD_MOD_SHIFT unused
TPM_MOD_OFFSET 00000008

Symbol: TPM_MOD_OFFSET
   Definitions
      At line 3673 in file ..\Exercise
   Uses
      At line 3859 in file ..\Exercise
      At line 3879 in file ..\Exercise
      At line 3899 in file ..\Exercise

TPM_SC_CMOD_MASK 00000018

Symbol: TPM_SC_CMOD_MASK
   Definitions
      At line 3825 in file ..\Exercise
   Uses



ARM Macro Assembler    Page 382 Alphabetic symbol ordering
Absolute symbols

      None
Comment: TPM_SC_CMOD_MASK unused
TPM_SC_CMOD_SHIFT 00000003

Symbol: TPM_SC_CMOD_SHIFT
   Definitions
      At line 3826 in file ..\Exercise
   Uses
      None
Comment: TPM_SC_CMOD_SHIFT unused
TPM_SC_CPWMS_MASK 00000020

Symbol: TPM_SC_CPWMS_MASK
   Definitions
      At line 3823 in file ..\Exercise
   Uses
      None
Comment: TPM_SC_CPWMS_MASK unused
TPM_SC_CPWMS_SHIFT 00000005

Symbol: TPM_SC_CPWMS_SHIFT
   Definitions
      At line 3824 in file ..\Exercise
   Uses
      None
Comment: TPM_SC_CPWMS_SHIFT unused
TPM_SC_DMA_MASK 00000100

Symbol: TPM_SC_DMA_MASK
   Definitions
      At line 3817 in file ..\Exercise
   Uses
      None
Comment: TPM_SC_DMA_MASK unused
TPM_SC_DMA_SHIFT 00000008

Symbol: TPM_SC_DMA_SHIFT
   Definitions
      At line 3818 in file ..\Exercise
   Uses
      None
Comment: TPM_SC_DMA_SHIFT unused
TPM_SC_OFFSET 00000000

Symbol: TPM_SC_OFFSET
   Definitions
      At line 3671 in file ..\Exercise
   Uses
      At line 3857 in file ..\Exercise
      At line 3877 in file ..\Exercise
      At line 3897 in file ..\Exercise

TPM_SC_PS_MASK 00000007

Symbol: TPM_SC_PS_MASK
   Definitions
      At line 3827 in file ..\Exercise
   Uses
      None



ARM Macro Assembler    Page 383 Alphabetic symbol ordering
Absolute symbols

Comment: TPM_SC_PS_MASK unused
TPM_SC_PS_SHIFT 00000000

Symbol: TPM_SC_PS_SHIFT
   Definitions
      At line 3828 in file ..\Exercise
   Uses
      None
Comment: TPM_SC_PS_SHIFT unused
TPM_SC_TOF_MASK 00000080

Symbol: TPM_SC_TOF_MASK
   Definitions
      At line 3819 in file ..\Exercise
   Uses
      None
Comment: TPM_SC_TOF_MASK unused
TPM_SC_TOF_SHIFT 00000007

Symbol: TPM_SC_TOF_SHIFT
   Definitions
      At line 3820 in file ..\Exercise
   Uses
      None
Comment: TPM_SC_TOF_SHIFT unused
TPM_SC_TOIE_MASK 00000040

Symbol: TPM_SC_TOIE_MASK
   Definitions
      At line 3821 in file ..\Exercise
   Uses
      None
Comment: TPM_SC_TOIE_MASK unused
TPM_SC_TOIE_SHIFT 00000006

Symbol: TPM_SC_TOIE_SHIFT
   Definitions
      At line 3822 in file ..\Exercise
   Uses
      None
Comment: TPM_SC_TOIE_SHIFT unused
TPM_STATUS_CH0F_MASK 00000001

Symbol: TPM_STATUS_CH0F_MASK
   Definitions
      At line 3852 in file ..\Exercise
   Uses
      None
Comment: TPM_STATUS_CH0F_MASK unused
TPM_STATUS_CH0F_SHIFT 00000000

Symbol: TPM_STATUS_CH0F_SHIFT
   Definitions
      At line 3853 in file ..\Exercise
   Uses
      None
Comment: TPM_STATUS_CH0F_SHIFT unused
TPM_STATUS_CH1F_MASK 00000002




ARM Macro Assembler    Page 384 Alphabetic symbol ordering
Absolute symbols

Symbol: TPM_STATUS_CH1F_MASK
   Definitions
      At line 3850 in file ..\Exercise
   Uses
      None
Comment: TPM_STATUS_CH1F_MASK unused
TPM_STATUS_CH1F_SHIFT 00000001

Symbol: TPM_STATUS_CH1F_SHIFT
   Definitions
      At line 3851 in file ..\Exercise
   Uses
      None
Comment: TPM_STATUS_CH1F_SHIFT unused
TPM_STATUS_CH2F_MASK 00000004

Symbol: TPM_STATUS_CH2F_MASK
   Definitions
      At line 3848 in file ..\Exercise
   Uses
      None
Comment: TPM_STATUS_CH2F_MASK unused
TPM_STATUS_CH2F_SHIFT 00000002

Symbol: TPM_STATUS_CH2F_SHIFT
   Definitions
      At line 3849 in file ..\Exercise
   Uses
      None
Comment: TPM_STATUS_CH2F_SHIFT unused
TPM_STATUS_CH3F_MASK 00000008

Symbol: TPM_STATUS_CH3F_MASK
   Definitions
      At line 3846 in file ..\Exercise
   Uses
      None
Comment: TPM_STATUS_CH3F_MASK unused
TPM_STATUS_CH3F_SHIFT 00000003

Symbol: TPM_STATUS_CH3F_SHIFT
   Definitions
      At line 3847 in file ..\Exercise
   Uses
      None
Comment: TPM_STATUS_CH3F_SHIFT unused
TPM_STATUS_CH4F_MASK 00000010

Symbol: TPM_STATUS_CH4F_MASK
   Definitions
      At line 3844 in file ..\Exercise
   Uses
      None
Comment: TPM_STATUS_CH4F_MASK unused
TPM_STATUS_CH4F_SHIFT 00000004

Symbol: TPM_STATUS_CH4F_SHIFT
   Definitions
      At line 3845 in file ..\Exercise



ARM Macro Assembler    Page 385 Alphabetic symbol ordering
Absolute symbols

   Uses
      None
Comment: TPM_STATUS_CH4F_SHIFT unused
TPM_STATUS_CH5F_MASK 00000020

Symbol: TPM_STATUS_CH5F_MASK
   Definitions
      At line 3842 in file ..\Exercise
   Uses
      None
Comment: TPM_STATUS_CH5F_MASK unused
TPM_STATUS_CH5F_SHIFT 00000005

Symbol: TPM_STATUS_CH5F_SHIFT
   Definitions
      At line 3843 in file ..\Exercise
   Uses
      None
Comment: TPM_STATUS_CH5F_SHIFT unused
TPM_STATUS_OFFSET 00000050

Symbol: TPM_STATUS_OFFSET
   Definitions
      At line 3686 in file ..\Exercise
   Uses
      At line 3872 in file ..\Exercise
      At line 3892 in file ..\Exercise
      At line 3912 in file ..\Exercise

TPM_STATUS_TOF_MASK 00000100

Symbol: TPM_STATUS_TOF_MASK
   Definitions
      At line 3840 in file ..\Exercise
   Uses
      None
Comment: TPM_STATUS_TOF_MASK unused
TPM_STATUS_TOF_SHIFT 00000008

Symbol: TPM_STATUS_TOF_SHIFT
   Definitions
      At line 3841 in file ..\Exercise
   Uses
      None
Comment: TPM_STATUS_TOF_SHIFT unused
TSI0_IPR E000E418

Symbol: TSI0_IPR
   Definitions
      At line 2689 in file ..\Exercise
   Uses
      None
Comment: TSI0_IPR unused
TSI0_IRQ 0000001A

Symbol: TSI0_IRQ
   Definitions
      At line 2759 in file ..\Exercise
   Uses



ARM Macro Assembler    Page 386 Alphabetic symbol ordering
Absolute symbols

      At line 2793 in file ..\Exercise
Comment: TSI0_IRQ used once
TSI0_IRQ_MASK 04000000

Symbol: TSI0_IRQ_MASK
   Definitions
      At line 2793 in file ..\Exercise
   Uses
      None
Comment: TSI0_IRQ_MASK unused
TSI0_IRQn 0000001A

Symbol: TSI0_IRQn
   Definitions
      At line 172 in file ..\Exercise
   Uses
      None
Comment: TSI0_IRQn unused
TSI0_PRI_POS 00000016

Symbol: TSI0_PRI_POS
   Definitions
      At line 2725 in file ..\Exercise
   Uses
      None
Comment: TSI0_PRI_POS unused
TSI0_Vector 0000002A

Symbol: TSI0_Vector
   Definitions
      At line 2843 in file ..\Exercise
   Uses
      None
Comment: TSI0_Vector unused
UART0_BASE 4006A000

Symbol: UART0_BASE
   Definitions
      At line 3916 in file ..\Exercise
   Uses
      At line 3929 in file ..\Exercise
      At line 3930 in file ..\Exercise
      At line 3931 in file ..\Exercise
      At line 3932 in file ..\Exercise
      At line 3933 in file ..\Exercise
      At line 3934 in file ..\Exercise
      At line 3935 in file ..\Exercise
      At line 3936 in file ..\Exercise
      At line 3937 in file ..\Exercise
      At line 3938 in file ..\Exercise
      At line 3939 in file ..\Exercise
      At line 3940 in file ..\Exercise
      At line 780 in file ..\Exercise
      At line 797 in file ..\Exercise
      At line 805 in file ..\Exercise
      At line 811 in file ..\Exercise
      At line 872 in file ..\Exercise
      At line 935 in file ..\Exercise
      At line 959 in file ..\Exercise



ARM Macro Assembler    Page 387 Alphabetic symbol ordering
Absolute symbols


UART0_BDH 4006A000

Symbol: UART0_BDH
   Definitions
      At line 3929 in file ..\Exercise
   Uses
      None
Comment: UART0_BDH unused
UART0_BDH_9600 00000001

Symbol: UART0_BDH_9600
   Definitions
      At line 121 in file ..\Exercise
   Uses
      At line 960 in file ..\Exercise
Comment: UART0_BDH_9600 used once
UART0_BDH_LBKDIE_MASK 00000080

Symbol: UART0_BDH_LBKDIE_MASK
   Definitions
      At line 3947 in file ..\Exercise
   Uses
      None
Comment: UART0_BDH_LBKDIE_MASK unused
UART0_BDH_LBKDIE_SHIFT 00000007

Symbol: UART0_BDH_LBKDIE_SHIFT
   Definitions
      At line 3948 in file ..\Exercise
   Uses
      None
Comment: UART0_BDH_LBKDIE_SHIFT unused
UART0_BDH_OFFSET 00000000

Symbol: UART0_BDH_OFFSET
   Definitions
      At line 3917 in file ..\Exercise
   Uses
      At line 3929 in file ..\Exercise
      At line 961 in file ..\Exercise

UART0_BDH_RXEDGIE_MASK 00000040

Symbol: UART0_BDH_RXEDGIE_MASK
   Definitions
      At line 3949 in file ..\Exercise
   Uses
      None
Comment: UART0_BDH_RXEDGIE_MASK unused
UART0_BDH_RXEDGIE_SHIFT 00000006

Symbol: UART0_BDH_RXEDGIE_SHIFT
   Definitions
      At line 3950 in file ..\Exercise
   Uses
      None
Comment: UART0_BDH_RXEDGIE_SHIFT unused
UART0_BDH_SBNS_MASK 00000020



ARM Macro Assembler    Page 388 Alphabetic symbol ordering
Absolute symbols


Symbol: UART0_BDH_SBNS_MASK
   Definitions
      At line 3951 in file ..\Exercise
   Uses
      None
Comment: UART0_BDH_SBNS_MASK unused
UART0_BDH_SBNS_SHIFT 00000005

Symbol: UART0_BDH_SBNS_SHIFT
   Definitions
      At line 3952 in file ..\Exercise
   Uses
      None
Comment: UART0_BDH_SBNS_SHIFT unused
UART0_BDH_SBR_MASK 0000001F

Symbol: UART0_BDH_SBR_MASK
   Definitions
      At line 3953 in file ..\Exercise
   Uses
      None
Comment: UART0_BDH_SBR_MASK unused
UART0_BDH_SBR_SHIFT 00000000

Symbol: UART0_BDH_SBR_SHIFT
   Definitions
      At line 3954 in file ..\Exercise
   Uses
      None
Comment: UART0_BDH_SBR_SHIFT unused
UART0_BDL 4006A001

Symbol: UART0_BDL
   Definitions
      At line 3930 in file ..\Exercise
   Uses
      None
Comment: UART0_BDL unused
UART0_BDL_9600 00000038

Symbol: UART0_BDL_9600
   Definitions
      At line 129 in file ..\Exercise
   Uses
      At line 962 in file ..\Exercise
Comment: UART0_BDL_9600 used once
UART0_BDL_OFFSET 00000001

Symbol: UART0_BDL_OFFSET
   Definitions
      At line 3918 in file ..\Exercise
   Uses
      At line 3930 in file ..\Exercise
      At line 963 in file ..\Exercise

UART0_BDL_SBR_MASK 000000FF

Symbol: UART0_BDL_SBR_MASK



ARM Macro Assembler    Page 389 Alphabetic symbol ordering
Absolute symbols

   Definitions
      At line 3958 in file ..\Exercise
   Uses
      None
Comment: UART0_BDL_SBR_MASK unused
UART0_BDL_SBR_SHIFT 00000000

Symbol: UART0_BDL_SBR_SHIFT
   Definitions
      At line 3959 in file ..\Exercise
   Uses
      None
Comment: UART0_BDL_SBR_SHIFT unused
UART0_C1 4006A002

Symbol: UART0_C1
   Definitions
      At line 3931 in file ..\Exercise
   Uses
      None
Comment: UART0_C1 unused
UART0_C1_8N1 00000000

Symbol: UART0_C1_8N1
   Definitions
      At line 141 in file ..\Exercise
   Uses
      At line 964 in file ..\Exercise
Comment: UART0_C1_8N1 used once
UART0_C1_DOZEEN_MASK 00000040

Symbol: UART0_C1_DOZEEN_MASK
   Definitions
      At line 3972 in file ..\Exercise
   Uses
      None
Comment: UART0_C1_DOZEEN_MASK unused
UART0_C1_DOZEEN_SHIFT 00000006

Symbol: UART0_C1_DOZEEN_SHIFT
   Definitions
      At line 3973 in file ..\Exercise
   Uses
      None
Comment: UART0_C1_DOZEEN_SHIFT unused
UART0_C1_ILT_MASK 00000004

Symbol: UART0_C1_ILT_MASK
   Definitions
      At line 3980 in file ..\Exercise
   Uses
      None
Comment: UART0_C1_ILT_MASK unused
UART0_C1_ILT_SHIFT 00000002

Symbol: UART0_C1_ILT_SHIFT
   Definitions
      At line 3981 in file ..\Exercise
   Uses



ARM Macro Assembler    Page 390 Alphabetic symbol ordering
Absolute symbols

      None
Comment: UART0_C1_ILT_SHIFT unused
UART0_C1_LOOPS_MASK 00000080

Symbol: UART0_C1_LOOPS_MASK
   Definitions
      At line 3970 in file ..\Exercise
   Uses
      None
Comment: UART0_C1_LOOPS_MASK unused
UART0_C1_LOOPS_SHIFT 00000007

Symbol: UART0_C1_LOOPS_SHIFT
   Definitions
      At line 3971 in file ..\Exercise
   Uses
      None
Comment: UART0_C1_LOOPS_SHIFT unused
UART0_C1_M_MASK 00000010

Symbol: UART0_C1_M_MASK
   Definitions
      At line 3976 in file ..\Exercise
   Uses
      None
Comment: UART0_C1_M_MASK unused
UART0_C1_M_SHIFT 00000004

Symbol: UART0_C1_M_SHIFT
   Definitions
      At line 3977 in file ..\Exercise
   Uses
      None
Comment: UART0_C1_M_SHIFT unused
UART0_C1_OFFSET 00000002

Symbol: UART0_C1_OFFSET
   Definitions
      At line 3919 in file ..\Exercise
   Uses
      At line 3931 in file ..\Exercise
      At line 965 in file ..\Exercise

UART0_C1_PE_MASK 00000002

Symbol: UART0_C1_PE_MASK
   Definitions
      At line 3982 in file ..\Exercise
   Uses
      None
Comment: UART0_C1_PE_MASK unused
UART0_C1_PE_SHIFT 00000001

Symbol: UART0_C1_PE_SHIFT
   Definitions
      At line 3983 in file ..\Exercise
   Uses
      None
Comment: UART0_C1_PE_SHIFT unused



ARM Macro Assembler    Page 391 Alphabetic symbol ordering
Absolute symbols

UART0_C1_PT_MASK 00000001

Symbol: UART0_C1_PT_MASK
   Definitions
      At line 3984 in file ..\Exercise
   Uses
      None
Comment: UART0_C1_PT_MASK unused
UART0_C1_PT_SHIFT 00000000

Symbol: UART0_C1_PT_SHIFT
   Definitions
      At line 3985 in file ..\Exercise
   Uses
      None
Comment: UART0_C1_PT_SHIFT unused
UART0_C1_RSRC_MASK 00000020

Symbol: UART0_C1_RSRC_MASK
   Definitions
      At line 3974 in file ..\Exercise
   Uses
      None
Comment: UART0_C1_RSRC_MASK unused
UART0_C1_RSRC_SHIFT 00000005

Symbol: UART0_C1_RSRC_SHIFT
   Definitions
      At line 3975 in file ..\Exercise
   Uses
      None
Comment: UART0_C1_RSRC_SHIFT unused
UART0_C1_WAKE_MASK 00000008

Symbol: UART0_C1_WAKE_MASK
   Definitions
      At line 3978 in file ..\Exercise
   Uses
      None
Comment: UART0_C1_WAKE_MASK unused
UART0_C1_WAKE_SHIFT 00000003

Symbol: UART0_C1_WAKE_SHIFT
   Definitions
      At line 3979 in file ..\Exercise
   Uses
      None
Comment: UART0_C1_WAKE_SHIFT unused
UART0_C2 4006A003

Symbol: UART0_C2
   Definitions
      At line 3932 in file ..\Exercise
   Uses
      None
Comment: UART0_C2 unused
UART0_C2_ILIE_MASK 00000010

Symbol: UART0_C2_ILIE_MASK



ARM Macro Assembler    Page 392 Alphabetic symbol ordering
Absolute symbols

   Definitions
      At line 4002 in file ..\Exercise
   Uses
      None
Comment: UART0_C2_ILIE_MASK unused
UART0_C2_ILIE_SHIFT 00000004

Symbol: UART0_C2_ILIE_SHIFT
   Definitions
      At line 4003 in file ..\Exercise
   Uses
      None
Comment: UART0_C2_ILIE_SHIFT unused
UART0_C2_OFFSET 00000003

Symbol: UART0_C2_OFFSET
   Definitions
      At line 3920 in file ..\Exercise
   Uses
      At line 3932 in file ..\Exercise
      At line 781 in file ..\Exercise
      At line 802 in file ..\Exercise
      At line 873 in file ..\Exercise
      At line 937 in file ..\Exercise
      At line 939 in file ..\Exercise
      At line 980 in file ..\Exercise

UART0_C2_RE_MASK 00000004

Symbol: UART0_C2_RE_MASK
   Definitions
      At line 4006 in file ..\Exercise
   Uses
      At line 152 in file ..\Exercise
Comment: UART0_C2_RE_MASK used once
UART0_C2_RE_SHIFT 00000002

Symbol: UART0_C2_RE_SHIFT
   Definitions
      At line 4007 in file ..\Exercise
   Uses
      None
Comment: UART0_C2_RE_SHIFT unused
UART0_C2_RIE_MASK 00000020

Symbol: UART0_C2_RIE_MASK
   Definitions
      At line 4000 in file ..\Exercise
   Uses
      At line 153 in file ..\Exercise
Comment: UART0_C2_RIE_MASK used once
UART0_C2_RIE_SHIFT 00000005

Symbol: UART0_C2_RIE_SHIFT
   Definitions
      At line 4001 in file ..\Exercise
   Uses
      None
Comment: UART0_C2_RIE_SHIFT unused



ARM Macro Assembler    Page 393 Alphabetic symbol ordering
Absolute symbols

UART0_C2_RWU_MASK 00000002

Symbol: UART0_C2_RWU_MASK
   Definitions
      At line 4008 in file ..\Exercise
   Uses
      None
Comment: UART0_C2_RWU_MASK unused
UART0_C2_RWU_SHIFT 00000001

Symbol: UART0_C2_RWU_SHIFT
   Definitions
      At line 4009 in file ..\Exercise
   Uses
      None
Comment: UART0_C2_RWU_SHIFT unused
UART0_C2_SBK_MASK 00000001

Symbol: UART0_C2_SBK_MASK
   Definitions
      At line 4010 in file ..\Exercise
   Uses
      None
Comment: UART0_C2_SBK_MASK unused
UART0_C2_SBK_SHIFT 00000000

Symbol: UART0_C2_SBK_SHIFT
   Definitions
      At line 4011 in file ..\Exercise
   Uses
      None
Comment: UART0_C2_SBK_SHIFT unused
UART0_C2_TCIE_MASK 00000040

Symbol: UART0_C2_TCIE_MASK
   Definitions
      At line 3998 in file ..\Exercise
   Uses
      None
Comment: UART0_C2_TCIE_MASK unused
UART0_C2_TCIE_SHIFT 00000006

Symbol: UART0_C2_TCIE_SHIFT
   Definitions
      At line 3999 in file ..\Exercise
   Uses
      None
Comment: UART0_C2_TCIE_SHIFT unused
UART0_C2_TE_MASK 00000008

Symbol: UART0_C2_TE_MASK
   Definitions
      At line 4004 in file ..\Exercise
   Uses
      At line 152 in file ..\Exercise
Comment: UART0_C2_TE_MASK used once
UART0_C2_TE_SHIFT 00000003

Symbol: UART0_C2_TE_SHIFT



ARM Macro Assembler    Page 394 Alphabetic symbol ordering
Absolute symbols

   Definitions
      At line 4005 in file ..\Exercise
   Uses
      None
Comment: UART0_C2_TE_SHIFT unused
UART0_C2_TIE_MASK 00000080

Symbol: UART0_C2_TIE_MASK
   Definitions
      At line 3996 in file ..\Exercise
   Uses
      At line 154 in file ..\Exercise
Comment: UART0_C2_TIE_MASK used once
UART0_C2_TIE_SHIFT 00000007

Symbol: UART0_C2_TIE_SHIFT
   Definitions
      At line 3997 in file ..\Exercise
   Uses
      None
Comment: UART0_C2_TIE_SHIFT unused
UART0_C2_TI_RI 000000AC

Symbol: UART0_C2_TI_RI
   Definitions
      At line 154 in file ..\Exercise
   Uses
      At line 871 in file ..\Exercise
Comment: UART0_C2_TI_RI used once
UART0_C2_T_R 0000000C

Symbol: UART0_C2_T_R
   Definitions
      At line 152 in file ..\Exercise
   Uses
      At line 153 in file ..\Exercise
      At line 936 in file ..\Exercise

UART0_C2_T_RI 0000002C

Symbol: UART0_C2_T_RI
   Definitions
      At line 153 in file ..\Exercise
   Uses
      At line 154 in file ..\Exercise
      At line 801 in file ..\Exercise
      At line 979 in file ..\Exercise

UART0_C3 4006A006

Symbol: UART0_C3
   Definitions
      At line 3935 in file ..\Exercise
   Uses
      None
Comment: UART0_C3 unused
UART0_C3_FEIE_MASK 00000002

Symbol: UART0_C3_FEIE_MASK



ARM Macro Assembler    Page 395 Alphabetic symbol ordering
Absolute symbols

   Definitions
      At line 4035 in file ..\Exercise
   Uses
      None
Comment: UART0_C3_FEIE_MASK unused
UART0_C3_FEIE_SHIFT 00000001

Symbol: UART0_C3_FEIE_SHIFT
   Definitions
      At line 4036 in file ..\Exercise
   Uses
      None
Comment: UART0_C3_FEIE_SHIFT unused
UART0_C3_NEIE_MASK 00000004

Symbol: UART0_C3_NEIE_MASK
   Definitions
      At line 4033 in file ..\Exercise
   Uses
      None
Comment: UART0_C3_NEIE_MASK unused
UART0_C3_NEIE_SHIFT 00000002

Symbol: UART0_C3_NEIE_SHIFT
   Definitions
      At line 4034 in file ..\Exercise
   Uses
      None
Comment: UART0_C3_NEIE_SHIFT unused
UART0_C3_NO_TXINV 00000000

Symbol: UART0_C3_NO_TXINV
   Definitions
      At line 168 in file ..\Exercise
   Uses
      At line 966 in file ..\Exercise
Comment: UART0_C3_NO_TXINV used once
UART0_C3_OFFSET 00000006

Symbol: UART0_C3_OFFSET
   Definitions
      At line 3923 in file ..\Exercise
   Uses
      At line 3935 in file ..\Exercise
      At line 967 in file ..\Exercise

UART0_C3_ORIE_MASK 00000008

Symbol: UART0_C3_ORIE_MASK
   Definitions
      At line 4031 in file ..\Exercise
   Uses
      None
Comment: UART0_C3_ORIE_MASK unused
UART0_C3_ORIE_SHIFT 00000003

Symbol: UART0_C3_ORIE_SHIFT
   Definitions
      At line 4032 in file ..\Exercise



ARM Macro Assembler    Page 396 Alphabetic symbol ordering
Absolute symbols

   Uses
      None
Comment: UART0_C3_ORIE_SHIFT unused
UART0_C3_PEIE_MASK 00000001

Symbol: UART0_C3_PEIE_MASK
   Definitions
      At line 4037 in file ..\Exercise
   Uses
      None
Comment: UART0_C3_PEIE_MASK unused
UART0_C3_PEIE_SHIFT 00000000

Symbol: UART0_C3_PEIE_SHIFT
   Definitions
      At line 4038 in file ..\Exercise
   Uses
      None
Comment: UART0_C3_PEIE_SHIFT unused
UART0_C3_R8T9_MASK 00000080

Symbol: UART0_C3_R8T9_MASK
   Definitions
      At line 4023 in file ..\Exercise
   Uses
      None
Comment: UART0_C3_R8T9_MASK unused
UART0_C3_R8T9_SHIFT 00000007

Symbol: UART0_C3_R8T9_SHIFT
   Definitions
      At line 4024 in file ..\Exercise
   Uses
      None
Comment: UART0_C3_R8T9_SHIFT unused
UART0_C3_R9T8_MASK 00000040

Symbol: UART0_C3_R9T8_MASK
   Definitions
      At line 4025 in file ..\Exercise
   Uses
      None
Comment: UART0_C3_R9T8_MASK unused
UART0_C3_R9T8_SHIFT 00000006

Symbol: UART0_C3_R9T8_SHIFT
   Definitions
      At line 4026 in file ..\Exercise
   Uses
      None
Comment: UART0_C3_R9T8_SHIFT unused
UART0_C3_TXDIR_MASK 00000020

Symbol: UART0_C3_TXDIR_MASK
   Definitions
      At line 4027 in file ..\Exercise
   Uses
      None
Comment: UART0_C3_TXDIR_MASK unused



ARM Macro Assembler    Page 397 Alphabetic symbol ordering
Absolute symbols

UART0_C3_TXDIR_SHIFT 00000005

Symbol: UART0_C3_TXDIR_SHIFT
   Definitions
      At line 4028 in file ..\Exercise
   Uses
      None
Comment: UART0_C3_TXDIR_SHIFT unused
UART0_C3_TXINV_MASK 00000010

Symbol: UART0_C3_TXINV_MASK
   Definitions
      At line 4029 in file ..\Exercise
   Uses
      None
Comment: UART0_C3_TXINV_MASK unused
UART0_C3_TXINV_SHIFT 00000004

Symbol: UART0_C3_TXINV_SHIFT
   Definitions
      At line 4030 in file ..\Exercise
   Uses
      None
Comment: UART0_C3_TXINV_SHIFT unused
UART0_C4 4006A00A

Symbol: UART0_C4
   Definitions
      At line 3939 in file ..\Exercise
   Uses
      None
Comment: UART0_C4 unused
UART0_C4_M10_MASK 00000020

Symbol: UART0_C4_M10_MASK
   Definitions
      At line 4051 in file ..\Exercise
   Uses
      None
Comment: UART0_C4_M10_MASK unused
UART0_C4_M10_SHIFT 00000005

Symbol: UART0_C4_M10_SHIFT
   Definitions
      At line 4052 in file ..\Exercise
   Uses
      None
Comment: UART0_C4_M10_SHIFT unused
UART0_C4_MAEN1_MASK 00000080

Symbol: UART0_C4_MAEN1_MASK
   Definitions
      At line 4047 in file ..\Exercise
   Uses
      None
Comment: UART0_C4_MAEN1_MASK unused
UART0_C4_MAEN1_SHIFT 00000007

Symbol: UART0_C4_MAEN1_SHIFT



ARM Macro Assembler    Page 398 Alphabetic symbol ordering
Absolute symbols

   Definitions
      At line 4048 in file ..\Exercise
   Uses
      None
Comment: UART0_C4_MAEN1_SHIFT unused
UART0_C4_MAEN2_MASK 00000040

Symbol: UART0_C4_MAEN2_MASK
   Definitions
      At line 4049 in file ..\Exercise
   Uses
      None
Comment: UART0_C4_MAEN2_MASK unused
UART0_C4_MAEN2_SHIFT 00000006

Symbol: UART0_C4_MAEN2_SHIFT
   Definitions
      At line 4050 in file ..\Exercise
   Uses
      None
Comment: UART0_C4_MAEN2_SHIFT unused
UART0_C4_NO_MATCH_OSR_16 0000000F

Symbol: UART0_C4_NO_MATCH_OSR_16
   Definitions
      At line 178 in file ..\Exercise
   Uses
      At line 968 in file ..\Exercise
Comment: UART0_C4_NO_MATCH_OSR_16 used once
UART0_C4_OFFSET 0000000A

Symbol: UART0_C4_OFFSET
   Definitions
      At line 3927 in file ..\Exercise
   Uses
      At line 3939 in file ..\Exercise
      At line 969 in file ..\Exercise

UART0_C4_OSR_16 0000000F

Symbol: UART0_C4_OSR_16
   Definitions
      At line 177 in file ..\Exercise
   Uses
      At line 178 in file ..\Exercise
Comment: UART0_C4_OSR_16 used once
UART0_C4_OSR_MASK 0000001F

Symbol: UART0_C4_OSR_MASK
   Definitions
      At line 4053 in file ..\Exercise
   Uses
      None
Comment: UART0_C4_OSR_MASK unused
UART0_C4_OSR_SHIFT 00000000

Symbol: UART0_C4_OSR_SHIFT
   Definitions
      At line 4054 in file ..\Exercise



ARM Macro Assembler    Page 399 Alphabetic symbol ordering
Absolute symbols

   Uses
      None
Comment: UART0_C4_OSR_SHIFT unused
UART0_C5 4006A00B

Symbol: UART0_C5
   Definitions
      At line 3940 in file ..\Exercise
   Uses
      None
Comment: UART0_C5 unused
UART0_C5_BOTHEDGE_MASK 00000002

Symbol: UART0_C5_BOTHEDGE_MASK
   Definitions
      At line 4067 in file ..\Exercise
   Uses
      None
Comment: UART0_C5_BOTHEDGE_MASK unused
UART0_C5_BOTHEDGE_SHIFT 00000001

Symbol: UART0_C5_BOTHEDGE_SHIFT
   Definitions
      At line 4068 in file ..\Exercise
   Uses
      None
Comment: UART0_C5_BOTHEDGE_SHIFT unused
UART0_C5_NO_DMA_SSR_SYNC 00000000

Symbol: UART0_C5_NO_DMA_SSR_SYNC
   Definitions
      At line 187 in file ..\Exercise
   Uses
      At line 970 in file ..\Exercise
Comment: UART0_C5_NO_DMA_SSR_SYNC used once
UART0_C5_OFFSET 0000000B

Symbol: UART0_C5_OFFSET
   Definitions
      At line 3928 in file ..\Exercise
   Uses
      At line 3940 in file ..\Exercise
      At line 971 in file ..\Exercise

UART0_C5_RDMAE_MASK 00000020

Symbol: UART0_C5_RDMAE_MASK
   Definitions
      At line 4065 in file ..\Exercise
   Uses
      None
Comment: UART0_C5_RDMAE_MASK unused
UART0_C5_RDMAE_SHIFT 00000005

Symbol: UART0_C5_RDMAE_SHIFT
   Definitions
      At line 4066 in file ..\Exercise
   Uses
      None



ARM Macro Assembler    Page 400 Alphabetic symbol ordering
Absolute symbols

Comment: UART0_C5_RDMAE_SHIFT unused
UART0_C5_RESYNCDIS_MASK 00000001

Symbol: UART0_C5_RESYNCDIS_MASK
   Definitions
      At line 4069 in file ..\Exercise
   Uses
      None
Comment: UART0_C5_RESYNCDIS_MASK unused
UART0_C5_RESYNCDIS_SHIFT 00000000

Symbol: UART0_C5_RESYNCDIS_SHIFT
   Definitions
      At line 4070 in file ..\Exercise
   Uses
      None
Comment: UART0_C5_RESYNCDIS_SHIFT unused
UART0_C5_TDMAE_MASK 00000080

Symbol: UART0_C5_TDMAE_MASK
   Definitions
      At line 4063 in file ..\Exercise
   Uses
      None
Comment: UART0_C5_TDMAE_MASK unused
UART0_C5_TDMAE_SHIFT 00000007

Symbol: UART0_C5_TDMAE_SHIFT
   Definitions
      At line 4064 in file ..\Exercise
   Uses
      None
Comment: UART0_C5_TDMAE_SHIFT unused
UART0_D 4006A007

Symbol: UART0_D
   Definitions
      At line 3936 in file ..\Exercise
   Uses
      None
Comment: UART0_D unused
UART0_D_OFFSET 00000007

Symbol: UART0_D_OFFSET
   Definitions
      At line 3924 in file ..\Exercise
   Uses
      At line 3936 in file ..\Exercise
      At line 798 in file ..\Exercise
      At line 812 in file ..\Exercise

UART0_D_R0T0_MASK 00000001

Symbol: UART0_D_R0T0_MASK
   Definitions
      At line 4103 in file ..\Exercise
   Uses
      None
Comment: UART0_D_R0T0_MASK unused



ARM Macro Assembler    Page 401 Alphabetic symbol ordering
Absolute symbols

UART0_D_R0T0_SHIFT 00000000

Symbol: UART0_D_R0T0_SHIFT
   Definitions
      At line 4104 in file ..\Exercise
   Uses
      None
Comment: UART0_D_R0T0_SHIFT unused
UART0_D_R1T1_MASK 00000002

Symbol: UART0_D_R1T1_MASK
   Definitions
      At line 4101 in file ..\Exercise
   Uses
      None
Comment: UART0_D_R1T1_MASK unused
UART0_D_R1T1_SHIFT 00000001

Symbol: UART0_D_R1T1_SHIFT
   Definitions
      At line 4102 in file ..\Exercise
   Uses
      None
Comment: UART0_D_R1T1_SHIFT unused
UART0_D_R2T2_MASK 00000004

Symbol: UART0_D_R2T2_MASK
   Definitions
      At line 4099 in file ..\Exercise
   Uses
      None
Comment: UART0_D_R2T2_MASK unused
UART0_D_R2T2_SHIFT 00000002

Symbol: UART0_D_R2T2_SHIFT
   Definitions
      At line 4100 in file ..\Exercise
   Uses
      None
Comment: UART0_D_R2T2_SHIFT unused
UART0_D_R3T3_MASK 00000008

Symbol: UART0_D_R3T3_MASK
   Definitions
      At line 4097 in file ..\Exercise
   Uses
      None
Comment: UART0_D_R3T3_MASK unused
UART0_D_R3T3_SHIFT 00000003

Symbol: UART0_D_R3T3_SHIFT
   Definitions
      At line 4098 in file ..\Exercise
   Uses
      None
Comment: UART0_D_R3T3_SHIFT unused
UART0_D_R4T4_MASK 00000010

Symbol: UART0_D_R4T4_MASK



ARM Macro Assembler    Page 402 Alphabetic symbol ordering
Absolute symbols

   Definitions
      At line 4095 in file ..\Exercise
   Uses
      None
Comment: UART0_D_R4T4_MASK unused
UART0_D_R4T4_SHIFT 00000004

Symbol: UART0_D_R4T4_SHIFT
   Definitions
      At line 4096 in file ..\Exercise
   Uses
      None
Comment: UART0_D_R4T4_SHIFT unused
UART0_D_R5T5_MASK 00000020

Symbol: UART0_D_R5T5_MASK
   Definitions
      At line 4093 in file ..\Exercise
   Uses
      None
Comment: UART0_D_R5T5_MASK unused
UART0_D_R5T5_SHIFT 00000005

Symbol: UART0_D_R5T5_SHIFT
   Definitions
      At line 4094 in file ..\Exercise
   Uses
      None
Comment: UART0_D_R5T5_SHIFT unused
UART0_D_R6T6_MASK 00000040

Symbol: UART0_D_R6T6_MASK
   Definitions
      At line 4091 in file ..\Exercise
   Uses
      None
Comment: UART0_D_R6T6_MASK unused
UART0_D_R6T6_SHIFT 00000006

Symbol: UART0_D_R6T6_SHIFT
   Definitions
      At line 4092 in file ..\Exercise
   Uses
      None
Comment: UART0_D_R6T6_SHIFT unused
UART0_D_R7T7_MASK 00000080

Symbol: UART0_D_R7T7_MASK
   Definitions
      At line 4089 in file ..\Exercise
   Uses
      None
Comment: UART0_D_R7T7_MASK unused
UART0_D_R7T7_SHIFT 00000007

Symbol: UART0_D_R7T7_SHIFT
   Definitions
      At line 4090 in file ..\Exercise
   Uses



ARM Macro Assembler    Page 403 Alphabetic symbol ordering
Absolute symbols

      None
Comment: UART0_D_R7T7_SHIFT unused
UART0_IPR E000E40C

Symbol: UART0_IPR
   Definitions
      At line 2675 in file ..\Exercise
   Uses
      At line 942 in file ..\Exercise
Comment: UART0_IPR used once
UART0_IRQ 0000000C

Symbol: UART0_IRQ
   Definitions
      At line 2745 in file ..\Exercise
   Uses
      At line 2779 in file ..\Exercise
Comment: UART0_IRQ used once
UART0_IRQ_MASK 00001000

Symbol: UART0_IRQ_MASK
   Definitions
      At line 2779 in file ..\Exercise
   Uses
      At line 32 in file ..\Exercise
      At line 40 in file ..\Exercise
      At line 53 in file ..\Exercise

UART0_IRQ_PRIORITY 00000003

Symbol: UART0_IRQ_PRIORITY
   Definitions
      At line 44 in file ..\Exercise
   Uses
      At line 46 in file ..\Exercise
Comment: UART0_IRQ_PRIORITY used once
UART0_IRQn 0000000C

Symbol: UART0_IRQn
   Definitions
      At line 158 in file ..\Exercise
   Uses
      None
Comment: UART0_IRQn unused
UART0_MA1 4006A008

Symbol: UART0_MA1
   Definitions
      At line 3937 in file ..\Exercise
   Uses
      None
Comment: UART0_MA1 unused
UART0_MA1_MA_MASK 000000FF

Symbol: UART0_MA1_MA_MASK
   Definitions
      At line 4108 in file ..\Exercise
   Uses
      None



ARM Macro Assembler    Page 404 Alphabetic symbol ordering
Absolute symbols

Comment: UART0_MA1_MA_MASK unused
UART0_MA1_MA_SHIFT 00000000

Symbol: UART0_MA1_MA_SHIFT
   Definitions
      At line 4109 in file ..\Exercise
   Uses
      None
Comment: UART0_MA1_MA_SHIFT unused
UART0_MA1_OFFSET 00000008

Symbol: UART0_MA1_OFFSET
   Definitions
      At line 3925 in file ..\Exercise
   Uses
      At line 3937 in file ..\Exercise
Comment: UART0_MA1_OFFSET used once
UART0_MA2 4006A009

Symbol: UART0_MA2
   Definitions
      At line 3938 in file ..\Exercise
   Uses
      None
Comment: UART0_MA2 unused
UART0_MA2_MA_MASK 000000FF

Symbol: UART0_MA2_MA_MASK
   Definitions
      At line 4113 in file ..\Exercise
   Uses
      None
Comment: UART0_MA2_MA_MASK unused
UART0_MA2_MA_SHIFT 00000000

Symbol: UART0_MA2_MA_SHIFT
   Definitions
      At line 4114 in file ..\Exercise
   Uses
      None
Comment: UART0_MA2_MA_SHIFT unused
UART0_MA2_OFFSET 00000009

Symbol: UART0_MA2_OFFSET
   Definitions
      At line 3926 in file ..\Exercise
   Uses
      At line 3938 in file ..\Exercise
Comment: UART0_MA2_OFFSET used once
UART0_PRI_POS 00000006

Symbol: UART0_PRI_POS
   Definitions
      At line 2711 in file ..\Exercise
   Uses
      At line 45 in file ..\Exercise
      At line 46 in file ..\Exercise

UART0_S1 4006A004



ARM Macro Assembler    Page 405 Alphabetic symbol ordering
Absolute symbols


Symbol: UART0_S1
   Definitions
      At line 3933 in file ..\Exercise
   Uses
      None
Comment: UART0_S1 unused
UART0_S1_CLEAR_FLAGS 0000001F

Symbol: UART0_S1_CLEAR_FLAGS
   Definitions
      At line 198 in file ..\Exercise
   Uses
      At line 972 in file ..\Exercise
Comment: UART0_S1_CLEAR_FLAGS used once
UART0_S1_FE_MASK 00000002

Symbol: UART0_S1_FE_MASK
   Definitions
      At line 4137 in file ..\Exercise
   Uses
      None
Comment: UART0_S1_FE_MASK unused
UART0_S1_FE_SHIFT 00000001

Symbol: UART0_S1_FE_SHIFT
   Definitions
      At line 4138 in file ..\Exercise
   Uses
      None
Comment: UART0_S1_FE_SHIFT unused
UART0_S1_IDLE_MASK 00000010

Symbol: UART0_S1_IDLE_MASK
   Definitions
      At line 4131 in file ..\Exercise
   Uses
      None
Comment: UART0_S1_IDLE_MASK unused
UART0_S1_IDLE_SHIFT 00000004

Symbol: UART0_S1_IDLE_SHIFT
   Definitions
      At line 4132 in file ..\Exercise
   Uses
      None
Comment: UART0_S1_IDLE_SHIFT unused
UART0_S1_NF_MASK 00000004

Symbol: UART0_S1_NF_MASK
   Definitions
      At line 4135 in file ..\Exercise
   Uses
      None
Comment: UART0_S1_NF_MASK unused
UART0_S1_NF_SHIFT 00000002

Symbol: UART0_S1_NF_SHIFT
   Definitions



ARM Macro Assembler    Page 406 Alphabetic symbol ordering
Absolute symbols

      At line 4136 in file ..\Exercise
   Uses
      None
Comment: UART0_S1_NF_SHIFT unused
UART0_S1_OFFSET 00000004

Symbol: UART0_S1_OFFSET
   Definitions
      At line 3921 in file ..\Exercise
   Uses
      At line 3933 in file ..\Exercise
      At line 788 in file ..\Exercise
      At line 806 in file ..\Exercise
      At line 973 in file ..\Exercise

UART0_S1_OR_MASK 00000008

Symbol: UART0_S1_OR_MASK
   Definitions
      At line 4133 in file ..\Exercise
   Uses
      None
Comment: UART0_S1_OR_MASK unused
UART0_S1_OR_SHIFT 00000003

Symbol: UART0_S1_OR_SHIFT
   Definitions
      At line 4134 in file ..\Exercise
   Uses
      None
Comment: UART0_S1_OR_SHIFT unused
UART0_S1_PF_MASK 00000001

Symbol: UART0_S1_PF_MASK
   Definitions
      At line 4139 in file ..\Exercise
   Uses
      None
Comment: UART0_S1_PF_MASK unused
UART0_S1_PF_SHIFT 00000000

Symbol: UART0_S1_PF_SHIFT
   Definitions
      At line 4140 in file ..\Exercise
   Uses
      None
Comment: UART0_S1_PF_SHIFT unused
UART0_S1_RDRF_MASK 00000020

Symbol: UART0_S1_RDRF_MASK
   Definitions
      At line 4129 in file ..\Exercise
   Uses
      None
Comment: UART0_S1_RDRF_MASK unused
UART0_S1_RDRF_SHIFT 00000005

Symbol: UART0_S1_RDRF_SHIFT
   Definitions



ARM Macro Assembler    Page 407 Alphabetic symbol ordering
Absolute symbols

      At line 4130 in file ..\Exercise
   Uses
      None
Comment: UART0_S1_RDRF_SHIFT unused
UART0_S1_TC_MASK 00000040

Symbol: UART0_S1_TC_MASK
   Definitions
      At line 4127 in file ..\Exercise
   Uses
      None
Comment: UART0_S1_TC_MASK unused
UART0_S1_TC_SHIFT 00000006

Symbol: UART0_S1_TC_SHIFT
   Definitions
      At line 4128 in file ..\Exercise
   Uses
      None
Comment: UART0_S1_TC_SHIFT unused
UART0_S1_TDRE_MASK 00000080

Symbol: UART0_S1_TDRE_MASK
   Definitions
      At line 4125 in file ..\Exercise
   Uses
      None
Comment: UART0_S1_TDRE_MASK unused
UART0_S1_TDRE_SHIFT 00000007

Symbol: UART0_S1_TDRE_SHIFT
   Definitions
      At line 4126 in file ..\Exercise
   Uses
      None
Comment: UART0_S1_TDRE_SHIFT unused
UART0_S2 4006A005

Symbol: UART0_S2
   Definitions
      At line 3934 in file ..\Exercise
   Uses
      None
Comment: UART0_S2 unused
UART0_S2_BRK13_MASK 00000004

Symbol: UART0_S2_BRK13_MASK
   Definitions
      At line 4161 in file ..\Exercise
   Uses
      None
Comment: UART0_S2_BRK13_MASK unused
UART0_S2_BRK13_SHIFT 00000002

Symbol: UART0_S2_BRK13_SHIFT
   Definitions
      At line 4162 in file ..\Exercise
   Uses
      None



ARM Macro Assembler    Page 408 Alphabetic symbol ordering
Absolute symbols

Comment: UART0_S2_BRK13_SHIFT unused
UART0_S2_LBKDE_MASK 00000002

Symbol: UART0_S2_LBKDE_MASK
   Definitions
      At line 4163 in file ..\Exercise
   Uses
      None
Comment: UART0_S2_LBKDE_MASK unused
UART0_S2_LBKDE_SHIFT 00000001

Symbol: UART0_S2_LBKDE_SHIFT
   Definitions
      At line 4164 in file ..\Exercise
   Uses
      None
Comment: UART0_S2_LBKDE_SHIFT unused
UART0_S2_LBKDIF_MASK 00000080

Symbol: UART0_S2_LBKDIF_MASK
   Definitions
      At line 4151 in file ..\Exercise
   Uses
      None
Comment: UART0_S2_LBKDIF_MASK unused
UART0_S2_LBKDIF_SHIFT 00000007

Symbol: UART0_S2_LBKDIF_SHIFT
   Definitions
      At line 4152 in file ..\Exercise
   Uses
      None
Comment: UART0_S2_LBKDIF_SHIFT unused
UART0_S2_MSBF_MASK 00000020

Symbol: UART0_S2_MSBF_MASK
   Definitions
      At line 4155 in file ..\Exercise
   Uses
      None
Comment: UART0_S2_MSBF_MASK unused
UART0_S2_MSBF_SHIFT 00000005

Symbol: UART0_S2_MSBF_SHIFT
   Definitions
      At line 4156 in file ..\Exercise
   Uses
      None
Comment: UART0_S2_MSBF_SHIFT unused
UART0_S2_NO_RXINV_BRK10_NO_LBKDETECT_CLEAR_FLAGS 000000C0

Symbol: UART0_S2_NO_RXINV_BRK10_NO_LBKDETECT_CLEAR_FLAGS
   Definitions
      At line 211 in file ..\Exercise
   Uses
      At line 975 in file ..\Exercise
Comment: UART0_S2_NO_RXINV_BRK10_NO_LBKDETECT_CLEAR_FLAGS used once
UART0_S2_OFFSET 00000005




ARM Macro Assembler    Page 409 Alphabetic symbol ordering
Absolute symbols

Symbol: UART0_S2_OFFSET
   Definitions
      At line 3922 in file ..\Exercise
   Uses
      At line 3934 in file ..\Exercise
      At line 976 in file ..\Exercise

UART0_S2_RAF_MASK 00000001

Symbol: UART0_S2_RAF_MASK
   Definitions
      At line 4165 in file ..\Exercise
   Uses
      None
Comment: UART0_S2_RAF_MASK unused
UART0_S2_RAF_SHIFT 00000000

Symbol: UART0_S2_RAF_SHIFT
   Definitions
      At line 4166 in file ..\Exercise
   Uses
      None
Comment: UART0_S2_RAF_SHIFT unused
UART0_S2_RWUID_MASK 00000008

Symbol: UART0_S2_RWUID_MASK
   Definitions
      At line 4159 in file ..\Exercise
   Uses
      None
Comment: UART0_S2_RWUID_MASK unused
UART0_S2_RWUID_SHIFT 00000003

Symbol: UART0_S2_RWUID_SHIFT
   Definitions
      At line 4160 in file ..\Exercise
   Uses
      None
Comment: UART0_S2_RWUID_SHIFT unused
UART0_S2_RXEDGIF_MASK 00000040

Symbol: UART0_S2_RXEDGIF_MASK
   Definitions
      At line 4153 in file ..\Exercise
   Uses
      None
Comment: UART0_S2_RXEDGIF_MASK unused
UART0_S2_RXEDGIF_SHIFT 00000006

Symbol: UART0_S2_RXEDGIF_SHIFT
   Definitions
      At line 4154 in file ..\Exercise
   Uses
      None
Comment: UART0_S2_RXEDGIF_SHIFT unused
UART0_S2_RXINV_MASK 00000010

Symbol: UART0_S2_RXINV_MASK
   Definitions



ARM Macro Assembler    Page 410 Alphabetic symbol ordering
Absolute symbols

      At line 4157 in file ..\Exercise
   Uses
      None
Comment: UART0_S2_RXINV_MASK unused
UART0_S2_RXINV_SHIFT 00000004

Symbol: UART0_S2_RXINV_SHIFT
   Definitions
      At line 4158 in file ..\Exercise
   Uses
      None
Comment: UART0_S2_RXINV_SHIFT unused
UART0_Vector 0000001C

Symbol: UART0_Vector
   Definitions
      At line 2829 in file ..\Exercise
   Uses
      None
Comment: UART0_Vector unused
UART1_BASE 4006B000

Symbol: UART1_BASE
   Definitions
      At line 4180 in file ..\Exercise
   Uses
      At line 4181 in file ..\Exercise
      At line 4182 in file ..\Exercise
      At line 4183 in file ..\Exercise
      At line 4184 in file ..\Exercise
      At line 4185 in file ..\Exercise
      At line 4186 in file ..\Exercise
      At line 4187 in file ..\Exercise
      At line 4188 in file ..\Exercise
      At line 4189 in file ..\Exercise

UART1_BDH 4006B000

Symbol: UART1_BDH
   Definitions
      At line 4181 in file ..\Exercise
   Uses
      None
Comment: UART1_BDH unused
UART1_BDL 4006B001

Symbol: UART1_BDL
   Definitions
      At line 4182 in file ..\Exercise
   Uses
      None
Comment: UART1_BDL unused
UART1_C1 4006B002

Symbol: UART1_C1
   Definitions
      At line 4183 in file ..\Exercise
   Uses
      None



ARM Macro Assembler    Page 411 Alphabetic symbol ordering
Absolute symbols

Comment: UART1_C1 unused
UART1_C2 4006B003

Symbol: UART1_C2
   Definitions
      At line 4184 in file ..\Exercise
   Uses
      None
Comment: UART1_C2 unused
UART1_C3 4006B006

Symbol: UART1_C3
   Definitions
      At line 4187 in file ..\Exercise
   Uses
      None
Comment: UART1_C3 unused
UART1_C4 4006B008

Symbol: UART1_C4
   Definitions
      At line 4189 in file ..\Exercise
   Uses
      None
Comment: UART1_C4 unused
UART1_D 4006B007

Symbol: UART1_D
   Definitions
      At line 4188 in file ..\Exercise
   Uses
      None
Comment: UART1_D unused
UART1_IPR E000E40C

Symbol: UART1_IPR
   Definitions
      At line 2676 in file ..\Exercise
   Uses
      None
Comment: UART1_IPR unused
UART1_IRQ 0000000D

Symbol: UART1_IRQ
   Definitions
      At line 2746 in file ..\Exercise
   Uses
      At line 2780 in file ..\Exercise
Comment: UART1_IRQ used once
UART1_IRQ_MASK 00002000

Symbol: UART1_IRQ_MASK
   Definitions
      At line 2780 in file ..\Exercise
   Uses
      None
Comment: UART1_IRQ_MASK unused
UART1_IRQn 0000000D




ARM Macro Assembler    Page 412 Alphabetic symbol ordering
Absolute symbols

Symbol: UART1_IRQn
   Definitions
      At line 159 in file ..\Exercise
   Uses
      None
Comment: UART1_IRQn unused
UART1_PRI_POS 0000000E

Symbol: UART1_PRI_POS
   Definitions
      At line 2712 in file ..\Exercise
   Uses
      None
Comment: UART1_PRI_POS unused
UART1_S1 4006B004

Symbol: UART1_S1
   Definitions
      At line 4185 in file ..\Exercise
   Uses
      None
Comment: UART1_S1 unused
UART1_S2 4006B005

Symbol: UART1_S2
   Definitions
      At line 4186 in file ..\Exercise
   Uses
      None
Comment: UART1_S2 unused
UART1_Vector 0000001D

Symbol: UART1_Vector
   Definitions
      At line 2830 in file ..\Exercise
   Uses
      None
Comment: UART1_Vector unused
UART2_BASE 4006C000

Symbol: UART2_BASE
   Definitions
      At line 4192 in file ..\Exercise
   Uses
      At line 4193 in file ..\Exercise
      At line 4194 in file ..\Exercise
      At line 4195 in file ..\Exercise
      At line 4196 in file ..\Exercise
      At line 4197 in file ..\Exercise
      At line 4198 in file ..\Exercise
      At line 4199 in file ..\Exercise
      At line 4200 in file ..\Exercise
      At line 4201 in file ..\Exercise

UART2_BDH 4006C000

Symbol: UART2_BDH
   Definitions
      At line 4193 in file ..\Exercise



ARM Macro Assembler    Page 413 Alphabetic symbol ordering
Absolute symbols

   Uses
      None
Comment: UART2_BDH unused
UART2_BDL 4006C001

Symbol: UART2_BDL
   Definitions
      At line 4194 in file ..\Exercise
   Uses
      None
Comment: UART2_BDL unused
UART2_C1 4006C002

Symbol: UART2_C1
   Definitions
      At line 4195 in file ..\Exercise
   Uses
      None
Comment: UART2_C1 unused
UART2_C2 4006C003

Symbol: UART2_C2
   Definitions
      At line 4196 in file ..\Exercise
   Uses
      None
Comment: UART2_C2 unused
UART2_C3 4006C006

Symbol: UART2_C3
   Definitions
      At line 4199 in file ..\Exercise
   Uses
      None
Comment: UART2_C3 unused
UART2_C4 4006C008

Symbol: UART2_C4
   Definitions
      At line 4201 in file ..\Exercise
   Uses
      None
Comment: UART2_C4 unused
UART2_D 4006C007

Symbol: UART2_D
   Definitions
      At line 4200 in file ..\Exercise
   Uses
      None
Comment: UART2_D unused
UART2_IPR E000E40C

Symbol: UART2_IPR
   Definitions
      At line 2677 in file ..\Exercise
   Uses
      None
Comment: UART2_IPR unused



ARM Macro Assembler    Page 414 Alphabetic symbol ordering
Absolute symbols

UART2_IRQ 0000000E

Symbol: UART2_IRQ
   Definitions
      At line 2747 in file ..\Exercise
   Uses
      At line 2781 in file ..\Exercise
Comment: UART2_IRQ used once
UART2_IRQ_MASK 00004000

Symbol: UART2_IRQ_MASK
   Definitions
      At line 2781 in file ..\Exercise
   Uses
      None
Comment: UART2_IRQ_MASK unused
UART2_IRQn 0000000E

Symbol: UART2_IRQn
   Definitions
      At line 160 in file ..\Exercise
   Uses
      None
Comment: UART2_IRQn unused
UART2_PRI_POS 00000016

Symbol: UART2_PRI_POS
   Definitions
      At line 2713 in file ..\Exercise
   Uses
      None
Comment: UART2_PRI_POS unused
UART2_S1 4006C004

Symbol: UART2_S1
   Definitions
      At line 4197 in file ..\Exercise
   Uses
      None
Comment: UART2_S1 unused
UART2_S2 4006C005

Symbol: UART2_S2
   Definitions
      At line 4198 in file ..\Exercise
   Uses
      None
Comment: UART2_S2 unused
UART2_Vector 0000001E

Symbol: UART2_Vector
   Definitions
      At line 2831 in file ..\Exercise
   Uses
      None
Comment: UART2_Vector unused
UART_BDH_LBKDIE_MASK 00000080

Symbol: UART_BDH_LBKDIE_MASK



ARM Macro Assembler    Page 415 Alphabetic symbol ordering
Absolute symbols

   Definitions
      At line 4208 in file ..\Exercise
   Uses
      None
Comment: UART_BDH_LBKDIE_MASK unused
UART_BDH_LBKDIE_SHIFT 00000007

Symbol: UART_BDH_LBKDIE_SHIFT
   Definitions
      At line 4209 in file ..\Exercise
   Uses
      None
Comment: UART_BDH_LBKDIE_SHIFT unused
UART_BDH_OFFSET 00000000

Symbol: UART_BDH_OFFSET
   Definitions
      At line 4169 in file ..\Exercise
   Uses
      At line 4181 in file ..\Exercise
      At line 4193 in file ..\Exercise

UART_BDH_RXEDGIE_MASK 00000040

Symbol: UART_BDH_RXEDGIE_MASK
   Definitions
      At line 4210 in file ..\Exercise
   Uses
      None
Comment: UART_BDH_RXEDGIE_MASK unused
UART_BDH_RXEDGIE_SHIFT 00000006

Symbol: UART_BDH_RXEDGIE_SHIFT
   Definitions
      At line 4211 in file ..\Exercise
   Uses
      None
Comment: UART_BDH_RXEDGIE_SHIFT unused
UART_BDH_SBNS_MASK 00000020

Symbol: UART_BDH_SBNS_MASK
   Definitions
      At line 4212 in file ..\Exercise
   Uses
      None
Comment: UART_BDH_SBNS_MASK unused
UART_BDH_SBNS_SHIFT 00000005

Symbol: UART_BDH_SBNS_SHIFT
   Definitions
      At line 4213 in file ..\Exercise
   Uses
      None
Comment: UART_BDH_SBNS_SHIFT unused
UART_BDH_SBR_MASK 0000001F

Symbol: UART_BDH_SBR_MASK
   Definitions
      At line 4214 in file ..\Exercise



ARM Macro Assembler    Page 416 Alphabetic symbol ordering
Absolute symbols

   Uses
      None
Comment: UART_BDH_SBR_MASK unused
UART_BDH_SBR_SHIFT 00000000

Symbol: UART_BDH_SBR_SHIFT
   Definitions
      At line 4215 in file ..\Exercise
   Uses
      None
Comment: UART_BDH_SBR_SHIFT unused
UART_BDL_OFFSET 00000001

Symbol: UART_BDL_OFFSET
   Definitions
      At line 4170 in file ..\Exercise
   Uses
      At line 4182 in file ..\Exercise
      At line 4194 in file ..\Exercise

UART_BDL_SBR_MASK 000000FF

Symbol: UART_BDL_SBR_MASK
   Definitions
      At line 4219 in file ..\Exercise
   Uses
      None
Comment: UART_BDL_SBR_MASK unused
UART_BDL_SBR_SHIFT 00000000

Symbol: UART_BDL_SBR_SHIFT
   Definitions
      At line 4220 in file ..\Exercise
   Uses
      None
Comment: UART_BDL_SBR_SHIFT unused
UART_C1_ILT_MASK 00000004

Symbol: UART_C1_ILT_MASK
   Definitions
      At line 4241 in file ..\Exercise
   Uses
      None
Comment: UART_C1_ILT_MASK unused
UART_C1_ILT_SHIFT 00000002

Symbol: UART_C1_ILT_SHIFT
   Definitions
      At line 4242 in file ..\Exercise
   Uses
      None
Comment: UART_C1_ILT_SHIFT unused
UART_C1_LOOPS_MASK 00000080

Symbol: UART_C1_LOOPS_MASK
   Definitions
      At line 4231 in file ..\Exercise
   Uses
      None



ARM Macro Assembler    Page 417 Alphabetic symbol ordering
Absolute symbols

Comment: UART_C1_LOOPS_MASK unused
UART_C1_LOOPS_SHIFT 00000007

Symbol: UART_C1_LOOPS_SHIFT
   Definitions
      At line 4232 in file ..\Exercise
   Uses
      None
Comment: UART_C1_LOOPS_SHIFT unused
UART_C1_M_MASK 00000010

Symbol: UART_C1_M_MASK
   Definitions
      At line 4237 in file ..\Exercise
   Uses
      None
Comment: UART_C1_M_MASK unused
UART_C1_M_SHIFT 00000004

Symbol: UART_C1_M_SHIFT
   Definitions
      At line 4238 in file ..\Exercise
   Uses
      None
Comment: UART_C1_M_SHIFT unused
UART_C1_OFFSET 00000002

Symbol: UART_C1_OFFSET
   Definitions
      At line 4171 in file ..\Exercise
   Uses
      At line 4183 in file ..\Exercise
      At line 4195 in file ..\Exercise

UART_C1_PE_MASK 00000002

Symbol: UART_C1_PE_MASK
   Definitions
      At line 4243 in file ..\Exercise
   Uses
      None
Comment: UART_C1_PE_MASK unused
UART_C1_PE_SHIFT 00000001

Symbol: UART_C1_PE_SHIFT
   Definitions
      At line 4244 in file ..\Exercise
   Uses
      None
Comment: UART_C1_PE_SHIFT unused
UART_C1_PT_MASK 00000001

Symbol: UART_C1_PT_MASK
   Definitions
      At line 4245 in file ..\Exercise
   Uses
      None
Comment: UART_C1_PT_MASK unused
UART_C1_PT_SHIFT 00000000



ARM Macro Assembler    Page 418 Alphabetic symbol ordering
Absolute symbols


Symbol: UART_C1_PT_SHIFT
   Definitions
      At line 4246 in file ..\Exercise
   Uses
      None
Comment: UART_C1_PT_SHIFT unused
UART_C1_RSRC_MASK 00000020

Symbol: UART_C1_RSRC_MASK
   Definitions
      At line 4235 in file ..\Exercise
   Uses
      None
Comment: UART_C1_RSRC_MASK unused
UART_C1_RSRC_SHIFT 00000005

Symbol: UART_C1_RSRC_SHIFT
   Definitions
      At line 4236 in file ..\Exercise
   Uses
      None
Comment: UART_C1_RSRC_SHIFT unused
UART_C1_UARTSWAI_MASK 00000040

Symbol: UART_C1_UARTSWAI_MASK
   Definitions
      At line 4233 in file ..\Exercise
   Uses
      None
Comment: UART_C1_UARTSWAI_MASK unused
UART_C1_UARTSWAI_SHIFT 00000006

Symbol: UART_C1_UARTSWAI_SHIFT
   Definitions
      At line 4234 in file ..\Exercise
   Uses
      None
Comment: UART_C1_UARTSWAI_SHIFT unused
UART_C1_WAKE_MASK 00000008

Symbol: UART_C1_WAKE_MASK
   Definitions
      At line 4239 in file ..\Exercise
   Uses
      None
Comment: UART_C1_WAKE_MASK unused
UART_C1_WAKE_SHIFT 00000003

Symbol: UART_C1_WAKE_SHIFT
   Definitions
      At line 4240 in file ..\Exercise
   Uses
      None
Comment: UART_C1_WAKE_SHIFT unused
UART_C2_ILIE_MASK 00000010

Symbol: UART_C2_ILIE_MASK
   Definitions



ARM Macro Assembler    Page 419 Alphabetic symbol ordering
Absolute symbols

      At line 4263 in file ..\Exercise
   Uses
      None
Comment: UART_C2_ILIE_MASK unused
UART_C2_ILIE_SHIFT 00000004

Symbol: UART_C2_ILIE_SHIFT
   Definitions
      At line 4264 in file ..\Exercise
   Uses
      None
Comment: UART_C2_ILIE_SHIFT unused
UART_C2_OFFSET 00000003

Symbol: UART_C2_OFFSET
   Definitions
      At line 4172 in file ..\Exercise
   Uses
      At line 4184 in file ..\Exercise
      At line 4196 in file ..\Exercise

UART_C2_RE_MASK 00000004

Symbol: UART_C2_RE_MASK
   Definitions
      At line 4267 in file ..\Exercise
   Uses
      None
Comment: UART_C2_RE_MASK unused
UART_C2_RE_SHIFT 00000002

Symbol: UART_C2_RE_SHIFT
   Definitions
      At line 4268 in file ..\Exercise
   Uses
      None
Comment: UART_C2_RE_SHIFT unused
UART_C2_RIE_MASK 00000020

Symbol: UART_C2_RIE_MASK
   Definitions
      At line 4261 in file ..\Exercise
   Uses
      None
Comment: UART_C2_RIE_MASK unused
UART_C2_RIE_SHIFT 00000005

Symbol: UART_C2_RIE_SHIFT
   Definitions
      At line 4262 in file ..\Exercise
   Uses
      None
Comment: UART_C2_RIE_SHIFT unused
UART_C2_RWU_MASK 00000002

Symbol: UART_C2_RWU_MASK
   Definitions
      At line 4269 in file ..\Exercise
   Uses



ARM Macro Assembler    Page 420 Alphabetic symbol ordering
Absolute symbols

      None
Comment: UART_C2_RWU_MASK unused
UART_C2_RWU_SHIFT 00000001

Symbol: UART_C2_RWU_SHIFT
   Definitions
      At line 4270 in file ..\Exercise
   Uses
      None
Comment: UART_C2_RWU_SHIFT unused
UART_C2_SBK_MASK 00000001

Symbol: UART_C2_SBK_MASK
   Definitions
      At line 4271 in file ..\Exercise
   Uses
      None
Comment: UART_C2_SBK_MASK unused
UART_C2_SBK_SHIFT 00000000

Symbol: UART_C2_SBK_SHIFT
   Definitions
      At line 4272 in file ..\Exercise
   Uses
      None
Comment: UART_C2_SBK_SHIFT unused
UART_C2_TCIE_MASK 00000040

Symbol: UART_C2_TCIE_MASK
   Definitions
      At line 4259 in file ..\Exercise
   Uses
      None
Comment: UART_C2_TCIE_MASK unused
UART_C2_TCIE_SHIFT 00000006

Symbol: UART_C2_TCIE_SHIFT
   Definitions
      At line 4260 in file ..\Exercise
   Uses
      None
Comment: UART_C2_TCIE_SHIFT unused
UART_C2_TE_MASK 00000008

Symbol: UART_C2_TE_MASK
   Definitions
      At line 4265 in file ..\Exercise
   Uses
      None
Comment: UART_C2_TE_MASK unused
UART_C2_TE_SHIFT 00000003

Symbol: UART_C2_TE_SHIFT
   Definitions
      At line 4266 in file ..\Exercise
   Uses
      None
Comment: UART_C2_TE_SHIFT unused
UART_C2_TIE_MASK 00000080



ARM Macro Assembler    Page 421 Alphabetic symbol ordering
Absolute symbols


Symbol: UART_C2_TIE_MASK
   Definitions
      At line 4257 in file ..\Exercise
   Uses
      None
Comment: UART_C2_TIE_MASK unused
UART_C2_TIE_SHIFT 00000007

Symbol: UART_C2_TIE_SHIFT
   Definitions
      At line 4258 in file ..\Exercise
   Uses
      None
Comment: UART_C2_TIE_SHIFT unused
UART_C3_FEIE_MASK 00000002

Symbol: UART_C3_FEIE_MASK
   Definitions
      At line 4295 in file ..\Exercise
   Uses
      None
Comment: UART_C3_FEIE_MASK unused
UART_C3_FEIE_SHIFT 00000001

Symbol: UART_C3_FEIE_SHIFT
   Definitions
      At line 4296 in file ..\Exercise
   Uses
      None
Comment: UART_C3_FEIE_SHIFT unused
UART_C3_NEIE_MASK 00000004

Symbol: UART_C3_NEIE_MASK
   Definitions
      At line 4293 in file ..\Exercise
   Uses
      None
Comment: UART_C3_NEIE_MASK unused
UART_C3_NEIE_SHIFT 00000002

Symbol: UART_C3_NEIE_SHIFT
   Definitions
      At line 4294 in file ..\Exercise
   Uses
      None
Comment: UART_C3_NEIE_SHIFT unused
UART_C3_OFFSET 00000006

Symbol: UART_C3_OFFSET
   Definitions
      At line 4175 in file ..\Exercise
   Uses
      At line 4187 in file ..\Exercise
      At line 4199 in file ..\Exercise

UART_C3_ORIE_MASK 00000008

Symbol: UART_C3_ORIE_MASK



ARM Macro Assembler    Page 422 Alphabetic symbol ordering
Absolute symbols

   Definitions
      At line 4291 in file ..\Exercise
   Uses
      None
Comment: UART_C3_ORIE_MASK unused
UART_C3_ORIE_SHIFT 00000003

Symbol: UART_C3_ORIE_SHIFT
   Definitions
      At line 4292 in file ..\Exercise
   Uses
      None
Comment: UART_C3_ORIE_SHIFT unused
UART_C3_PEIE_MASK 00000001

Symbol: UART_C3_PEIE_MASK
   Definitions
      At line 4297 in file ..\Exercise
   Uses
      None
Comment: UART_C3_PEIE_MASK unused
UART_C3_PEIE_SHIFT 00000000

Symbol: UART_C3_PEIE_SHIFT
   Definitions
      At line 4298 in file ..\Exercise
   Uses
      None
Comment: UART_C3_PEIE_SHIFT unused
UART_C3_R8_MASK 00000080

Symbol: UART_C3_R8_MASK
   Definitions
      At line 4283 in file ..\Exercise
   Uses
      None
Comment: UART_C3_R8_MASK unused
UART_C3_R8_SHIFT 00000007

Symbol: UART_C3_R8_SHIFT
   Definitions
      At line 4284 in file ..\Exercise
   Uses
      None
Comment: UART_C3_R8_SHIFT unused
UART_C3_T8_MASK 00000040

Symbol: UART_C3_T8_MASK
   Definitions
      At line 4285 in file ..\Exercise
   Uses
      None
Comment: UART_C3_T8_MASK unused
UART_C3_T8_SHIFT 00000006

Symbol: UART_C3_T8_SHIFT
   Definitions
      At line 4286 in file ..\Exercise
   Uses



ARM Macro Assembler    Page 423 Alphabetic symbol ordering
Absolute symbols

      None
Comment: UART_C3_T8_SHIFT unused
UART_C3_TXDIR_MASK 00000020

Symbol: UART_C3_TXDIR_MASK
   Definitions
      At line 4287 in file ..\Exercise
   Uses
      None
Comment: UART_C3_TXDIR_MASK unused
UART_C3_TXDIR_SHIFT 00000005

Symbol: UART_C3_TXDIR_SHIFT
   Definitions
      At line 4288 in file ..\Exercise
   Uses
      None
Comment: UART_C3_TXDIR_SHIFT unused
UART_C3_TXINV_MASK 00000010

Symbol: UART_C3_TXINV_MASK
   Definitions
      At line 4289 in file ..\Exercise
   Uses
      None
Comment: UART_C3_TXINV_MASK unused
UART_C3_TXINV_SHIFT 00000004

Symbol: UART_C3_TXINV_SHIFT
   Definitions
      At line 4290 in file ..\Exercise
   Uses
      None
Comment: UART_C3_TXINV_SHIFT unused
UART_C4_OFFSET 00000008

Symbol: UART_C4_OFFSET
   Definitions
      At line 4177 in file ..\Exercise
   Uses
      At line 4189 in file ..\Exercise
      At line 4201 in file ..\Exercise

UART_C4_RDMAS_MASK 00000020

Symbol: UART_C4_RDMAS_MASK
   Definitions
      At line 4309 in file ..\Exercise
   Uses
      None
Comment: UART_C4_RDMAS_MASK unused
UART_C4_RDMAS_SHIFT 00000005

Symbol: UART_C4_RDMAS_SHIFT
   Definitions
      At line 4310 in file ..\Exercise
   Uses
      None
Comment: UART_C4_RDMAS_SHIFT unused



ARM Macro Assembler    Page 424 Alphabetic symbol ordering
Absolute symbols

UART_C4_TDMAS_MASK 00000080

Symbol: UART_C4_TDMAS_MASK
   Definitions
      At line 4307 in file ..\Exercise
   Uses
      None
Comment: UART_C4_TDMAS_MASK unused
UART_C4_TDMAS_SHIFT 00000007

Symbol: UART_C4_TDMAS_SHIFT
   Definitions
      At line 4308 in file ..\Exercise
   Uses
      None
Comment: UART_C4_TDMAS_SHIFT unused
UART_D_OFFSET 00000007

Symbol: UART_D_OFFSET
   Definitions
      At line 4176 in file ..\Exercise
   Uses
      At line 4188 in file ..\Exercise
      At line 4200 in file ..\Exercise

UART_S1_FE_MASK 00000002

Symbol: UART_S1_FE_MASK
   Definitions
      At line 4333 in file ..\Exercise
   Uses
      None
Comment: UART_S1_FE_MASK unused
UART_S1_FE_SHIFT 00000001

Symbol: UART_S1_FE_SHIFT
   Definitions
      At line 4334 in file ..\Exercise
   Uses
      None
Comment: UART_S1_FE_SHIFT unused
UART_S1_IDLE_MASK 00000010

Symbol: UART_S1_IDLE_MASK
   Definitions
      At line 4327 in file ..\Exercise
   Uses
      None
Comment: UART_S1_IDLE_MASK unused
UART_S1_IDLE_SHIFT 00000004

Symbol: UART_S1_IDLE_SHIFT
   Definitions
      At line 4328 in file ..\Exercise
   Uses
      None
Comment: UART_S1_IDLE_SHIFT unused
UART_S1_NF_MASK 00000004




ARM Macro Assembler    Page 425 Alphabetic symbol ordering
Absolute symbols

Symbol: UART_S1_NF_MASK
   Definitions
      At line 4331 in file ..\Exercise
   Uses
      None
Comment: UART_S1_NF_MASK unused
UART_S1_NF_SHIFT 00000002

Symbol: UART_S1_NF_SHIFT
   Definitions
      At line 4332 in file ..\Exercise
   Uses
      None
Comment: UART_S1_NF_SHIFT unused
UART_S1_OFFSET 00000004

Symbol: UART_S1_OFFSET
   Definitions
      At line 4173 in file ..\Exercise
   Uses
      At line 4185 in file ..\Exercise
      At line 4197 in file ..\Exercise

UART_S1_OR_MASK 00000008

Symbol: UART_S1_OR_MASK
   Definitions
      At line 4329 in file ..\Exercise
   Uses
      None
Comment: UART_S1_OR_MASK unused
UART_S1_OR_SHIFT 00000003

Symbol: UART_S1_OR_SHIFT
   Definitions
      At line 4330 in file ..\Exercise
   Uses
      None
Comment: UART_S1_OR_SHIFT unused
UART_S1_PF_MASK 00000001

Symbol: UART_S1_PF_MASK
   Definitions
      At line 4335 in file ..\Exercise
   Uses
      None
Comment: UART_S1_PF_MASK unused
UART_S1_PF_SHIFT 00000000

Symbol: UART_S1_PF_SHIFT
   Definitions
      At line 4336 in file ..\Exercise
   Uses
      None
Comment: UART_S1_PF_SHIFT unused
UART_S1_RDRF_MASK 00000020

Symbol: UART_S1_RDRF_MASK
   Definitions



ARM Macro Assembler    Page 426 Alphabetic symbol ordering
Absolute symbols

      At line 4325 in file ..\Exercise
   Uses
      None
Comment: UART_S1_RDRF_MASK unused
UART_S1_RDRF_SHIFT 00000005

Symbol: UART_S1_RDRF_SHIFT
   Definitions
      At line 4326 in file ..\Exercise
   Uses
      None
Comment: UART_S1_RDRF_SHIFT unused
UART_S1_TC_MASK 00000040

Symbol: UART_S1_TC_MASK
   Definitions
      At line 4323 in file ..\Exercise
   Uses
      None
Comment: UART_S1_TC_MASK unused
UART_S1_TC_SHIFT 00000006

Symbol: UART_S1_TC_SHIFT
   Definitions
      At line 4324 in file ..\Exercise
   Uses
      None
Comment: UART_S1_TC_SHIFT unused
UART_S1_TDRE_MASK 00000080

Symbol: UART_S1_TDRE_MASK
   Definitions
      At line 4321 in file ..\Exercise
   Uses
      None
Comment: UART_S1_TDRE_MASK unused
UART_S1_TDRE_SHIFT 00000007

Symbol: UART_S1_TDRE_SHIFT
   Definitions
      At line 4322 in file ..\Exercise
   Uses
      None
Comment: UART_S1_TDRE_SHIFT unused
UART_S2_BRK13_MASK 00000004

Symbol: UART_S2_BRK13_MASK
   Definitions
      At line 4355 in file ..\Exercise
   Uses
      None
Comment: UART_S2_BRK13_MASK unused
UART_S2_BRK13_SHIFT 00000002

Symbol: UART_S2_BRK13_SHIFT
   Definitions
      At line 4356 in file ..\Exercise
   Uses
      None



ARM Macro Assembler    Page 427 Alphabetic symbol ordering
Absolute symbols

Comment: UART_S2_BRK13_SHIFT unused
UART_S2_LBKDE_MASK 00000002

Symbol: UART_S2_LBKDE_MASK
   Definitions
      At line 4357 in file ..\Exercise
   Uses
      None
Comment: UART_S2_LBKDE_MASK unused
UART_S2_LBKDE_SHIFT 00000001

Symbol: UART_S2_LBKDE_SHIFT
   Definitions
      At line 4358 in file ..\Exercise
   Uses
      None
Comment: UART_S2_LBKDE_SHIFT unused
UART_S2_LBKDIF_MASK 00000080

Symbol: UART_S2_LBKDIF_MASK
   Definitions
      At line 4347 in file ..\Exercise
   Uses
      None
Comment: UART_S2_LBKDIF_MASK unused
UART_S2_LBKDIF_SHIFT 00000007

Symbol: UART_S2_LBKDIF_SHIFT
   Definitions
      At line 4348 in file ..\Exercise
   Uses
      None
Comment: UART_S2_LBKDIF_SHIFT unused
UART_S2_OFFSET 00000005

Symbol: UART_S2_OFFSET
   Definitions
      At line 4174 in file ..\Exercise
   Uses
      At line 4186 in file ..\Exercise
      At line 4198 in file ..\Exercise

UART_S2_RAF_MASK 00000001

Symbol: UART_S2_RAF_MASK
   Definitions
      At line 4359 in file ..\Exercise
   Uses
      None
Comment: UART_S2_RAF_MASK unused
UART_S2_RAF_SHIFT 00000000

Symbol: UART_S2_RAF_SHIFT
   Definitions
      At line 4360 in file ..\Exercise
   Uses
      None
Comment: UART_S2_RAF_SHIFT unused
UART_S2_RWUID_MASK 00000008



ARM Macro Assembler    Page 428 Alphabetic symbol ordering
Absolute symbols


Symbol: UART_S2_RWUID_MASK
   Definitions
      At line 4353 in file ..\Exercise
   Uses
      None
Comment: UART_S2_RWUID_MASK unused
UART_S2_RWUID_SHIFT 00000003

Symbol: UART_S2_RWUID_SHIFT
   Definitions
      At line 4354 in file ..\Exercise
   Uses
      None
Comment: UART_S2_RWUID_SHIFT unused
UART_S2_RXEDGIF_MASK 00000040

Symbol: UART_S2_RXEDGIF_MASK
   Definitions
      At line 4349 in file ..\Exercise
   Uses
      None
Comment: UART_S2_RXEDGIF_MASK unused
UART_S2_RXEDGIF_SHIFT 00000006

Symbol: UART_S2_RXEDGIF_SHIFT
   Definitions
      At line 4350 in file ..\Exercise
   Uses
      None
Comment: UART_S2_RXEDGIF_SHIFT unused
UART_S2_RXINV_MASK 00000010

Symbol: UART_S2_RXINV_MASK
   Definitions
      At line 4351 in file ..\Exercise
   Uses
      None
Comment: UART_S2_RXINV_MASK unused
UART_S2_RXINV_SHIFT 00000004

Symbol: UART_S2_RXINV_SHIFT
   Definitions
      At line 4352 in file ..\Exercise
   Uses
      None
Comment: UART_S2_RXINV_SHIFT unused
USB0_IPR E000E418

Symbol: USB0_IPR
   Definitions
      At line 2687 in file ..\Exercise
   Uses
      None
Comment: USB0_IPR unused
USB0_IRQ 00000018

Symbol: USB0_IRQ
   Definitions



ARM Macro Assembler    Page 429 Alphabetic symbol ordering
Absolute symbols

      At line 2757 in file ..\Exercise
   Uses
      At line 2791 in file ..\Exercise
Comment: USB0_IRQ used once
USB0_IRQ_MASK 01000000

Symbol: USB0_IRQ_MASK
   Definitions
      At line 2791 in file ..\Exercise
   Uses
      None
Comment: USB0_IRQ_MASK unused
USB0_IRQn 00000018

Symbol: USB0_IRQn
   Definitions
      At line 170 in file ..\Exercise
   Uses
      None
Comment: USB0_IRQn unused
USB0_PRI_POS 00000006

Symbol: USB0_PRI_POS
   Definitions
      At line 2723 in file ..\Exercise
   Uses
      None
Comment: USB0_PRI_POS unused
USB0_Vector 00000028

Symbol: USB0_Vector
   Definitions
      At line 2841 in file ..\Exercise
   Uses
      None
Comment: USB0_Vector unused
VECTOR_SIZE 00000004

Symbol: VECTOR_SIZE
   Definitions
      At line 40 in file ..\Exercise
   Uses
      None
Comment: VECTOR_SIZE unused
VECTOR_TABLE_SIZE 000000C0

Symbol: VECTOR_TABLE_SIZE
   Definitions
      At line 39 in file ..\Exercise
   Uses
      None
Comment: VECTOR_TABLE_SIZE unused
WORD_SIZE 00000004

Symbol: WORD_SIZE
   Definitions
      At line 29 in file ..\Exercise
   Uses
      None



ARM Macro Assembler    Page 430 Alphabetic symbol ordering
Absolute symbols

Comment: WORD_SIZE unused
__CM0PLUS_REV 00000000

Symbol: __CM0PLUS_REV
   Definitions
      At line 129 in file ..\Exercise
   Uses
      None
Comment: __CM0PLUS_REV unused
__MPU_PRESENT 00000000

Symbol: __MPU_PRESENT
   Definitions
      At line 130 in file ..\Exercise
   Uses
      None
Comment: __MPU_PRESENT unused
__NVIC_PRIO_BITS 00000002

Symbol: __NVIC_PRIO_BITS
   Definitions
      At line 131 in file ..\Exercise
   Uses
      None
Comment: __NVIC_PRIO_BITS unused
__VTOR_PRESENT 00000001

Symbol: __VTOR_PRESENT
   Definitions
      At line 134 in file ..\Exercise
   Uses
      None
Comment: __VTOR_PRESENT unused
__Vendor_SysTickConfig 00000000

Symbol: __Vendor_SysTickConfig
   Definitions
      At line 132 in file ..\Exercise
   Uses
      None
Comment: __Vendor_SysTickConfig unused
3085 symbols
3508 symbols in table
