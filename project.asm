        #INCLUDE "P16F877A.INC"

        __CONFIG _CP_OFF & _WDT_OFF & _PWRTE_OFF & _BODEN_OFF & _LVP_OFF & _HS_OSC




M10_REG         EQU     0X20
M1_REG          EQU     0X21
S10_REG         EQU     0X22
S1_REG          EQU     0X23
DLY1            EQU     0X24
SEC_CNT         EQU     0X25
PAUSE_FLAG      EQU     0X26
BTN_STATE       EQU     0X27
LCD_CNT         EQU     0X28       

DIP_BUF         EQU     0X29
TAF_VAL         EQU     0X2A
TBF_VAL         EQU     0X2B
TAF_OLD         EQU     0X2C
TBF_OLD         EQU     0X2D

RX_BUF          EQU     0X2E

SHOT_TEN        EQU     0X2F
SHOT_UNIT       EQU     0X30
SHOT_BASE_TEN   EQU     0X31
SHOT_BASE_UNIT  EQU     0X32
SHOT_BTN_STATE  EQU     0X33

BTN_C2_STATE    EQU     0X34
BTN_C3_STATE    EQU     0X35
BTN_C4_STATE    EQU     0X36
BTN_C5_STATE    EQU     0X37

REG1            EQU     0X40
REG2            EQU     0X41
REG3            EQU     0X42
REG5H           EQU     0X43
REG5L           EQU     0X44

        ORG     0X00




CONF
        BSF     STATUS,RP0

        MOVLW   B'10111111'
        MOVWF   TRISC          

        MOVLW   H'FF'
        MOVWF   TRISB          

        CLRF    TRISD          
        CLRF    TRISE          

        MOVLW   H'07'          
        MOVWF   ADCON1

        BCF     STATUS,RP0     




INIT
        CLRF    PORTD
        CLRF    PORTE

        CALL    UART_INIT

        CLRF    TAF_OLD
        CLRF    TBF_OLD

        
        CALL    CONFILCD

        CALL    LCD_PRINT_STATIC

        MOVLW   D'1'
        MOVWF   M10_REG
        CLRF    M1_REG
        CLRF    S10_REG
        CLRF    S1_REG

        CLRF    PAUSE_FLAG
        MOVLW   H'01'
        MOVWF   BTN_STATE

        MOVLW   D'2'
        MOVWF   SHOT_BASE_TEN
        MOVLW   D'4'
        MOVWF   SHOT_BASE_UNIT

        MOVF    SHOT_BASE_TEN,W
        MOVWF   SHOT_TEN
        MOVF    SHOT_BASE_UNIT,W
        MOVWF   SHOT_UNIT

        MOVLW   H'8D'
        CALL    COMMAND
        MOVF    SHOT_TEN,W
        ADDLW   '0'
        CALL    CHAR

        MOVLW   H'8E'
        CALL    COMMAND
        MOVF    SHOT_UNIT,W
        ADDLW   '0'
        CALL    CHAR

        MOVLW   H'01'
        MOVWF   SHOT_BTN_STATE

        MOVLW   H'01'
        MOVWF   BTN_C2_STATE
        MOVWF   BTN_C3_STATE
        MOVWF   BTN_C4_STATE
        MOVWF   BTN_C5_STATE




MAIN
        CALL    LCD_UPDATE_VALUES
        CALL    DISPLAY_1S

        MOVF    M10_REG,W
        IORWF   M1_REG,W
        IORWF   S10_REG,W
        IORWF   S1_REG,W
        BTFSC   STATUS,Z
        GOTO    HOLD_ZERO

        MOVF    PAUSE_FLAG,F
        BTFSC   STATUS,Z
        CALL    RUN_TICK

        GOTO    MAIN


HOLD_ZERO
HZ_LOOP
        CALL    LCD_UPDATE_VALUES
        CALL    DISPLAY_1S
        GOTO    HZ_LOOP


RUN_TICK
        CALL    DEC_1SEC
        CALL    SHOT_TICK
        RETURN


;COUNTDOWN CORE

DEC_1SEC
        MOVF    S1_REG,F
        BTFSC   STATUS,Z
        GOTO    S1_BORROW
        DECF    S1_REG,F
        RETURN

S1_BORROW
        MOVLW   D'9'
        MOVWF   S1_REG

        MOVF    S10_REG,F
        BTFSC   STATUS,Z
        GOTO    S10_BORROW
        DECF    S10_REG,F
        RETURN

S10_BORROW
        MOVLW   D'5'
        MOVWF   S10_REG

        MOVF    M1_REG,F
        BTFSC   STATUS,Z
        GOTO    M1_BORROW
        DECF    M1_REG,F
        RETURN

M1_BORROW
        MOVLW   D'9'
        MOVWF   M1_REG

        MOVF    M10_REG,F
        BTFSC   STATUS,Z
        RETURN
        DECF    M10_REG,F
        RETURN


;SHOT CLOCK 

SHOT_TICK
        MOVF    SHOT_TEN,W
        IORWF   SHOT_UNIT,W
        BTFSS   STATUS,Z
        GOTO    SHOT_DEC

        MOVF    SHOT_BASE_TEN,W
        MOVWF   SHOT_TEN
        MOVF    SHOT_BASE_UNIT,W
        MOVWF   SHOT_UNIT
        GOTO    LCD_UPDATE_SHOT

SHOT_DEC
        MOVF    SHOT_UNIT,F
        BTFSC   STATUS,Z
        GOTO    SHOT_BORROW

        DECF    SHOT_UNIT,F
        GOTO    LCD_UPDATE_SHOT

SHOT_BORROW
        MOVLW   D'9'
        MOVWF   SHOT_UNIT
        MOVF    SHOT_TEN,F
        BTFSC   STATUS,Z
        GOTO    LCD_UPDATE_SHOT
        DECF    SHOT_TEN,F

LCD_UPDATE_SHOT
        MOVLW   H'8D'
        CALL    COMMAND
        MOVF    SHOT_TEN,W
        ADDLW   '0'
        CALL    CHAR

        MOVLW   H'8E'
        CALL    COMMAND
        MOVF    SHOT_UNIT,W
        ADDLW   '0'
        CALL    CHAR

        RETURN


;CHECK BUTTONS TO SEND BLUETOOTH

CHECK_BUTTON
        BCF     STATUS,RP0

        BTFSC   PORTC,0
        GOTO    BTN_NOT_PRESSED

        MOVF    BTN_STATE,F
        BTFSS   STATUS,Z
        GOTO    NEW_PRESS
        GOTO    BTN_PRESSED_ALREADY

NEW_PRESS
        COMF    PAUSE_FLAG,F
        CLRF    BTN_STATE
        RETURN

BTN_PRESSED_ALREADY
        CLRF    BTN_STATE
        RETURN

BTN_NOT_PRESSED
        MOVLW   H'01'
        MOVWF   BTN_STATE
        RETURN


CHECK_SHOT_BUTTON
        BCF     STATUS,RP0

        BTFSC   PORTC,1
        GOTO    SHOT_BTN_NOT_PRESSED

        MOVF    SHOT_BTN_STATE,F
        BTFSS   STATUS,Z
        GOTO    SHOT_NEW_PRESS
        GOTO    SHOT_PRESSED_ALREADY

SHOT_NEW_PRESS
        MOVF    PAUSE_FLAG,F
        BTFSC   STATUS,Z
        GOTO    SHOT_MARK_PRESSED_ONLY

        MOVF    SHOT_BASE_TEN,W
        XORLW   D'2'
        BTFSC   STATUS,Z
        GOTO    SET_BASE_14

SET_BASE_24
        MOVLW   D'2'
        MOVWF   SHOT_BASE_TEN
        MOVLW   D'4'
        MOVWF   SHOT_BASE_UNIT
        GOTO    LOAD_BASE_TO_CURR

SET_BASE_14
        MOVLW   D'1'
        MOVWF   SHOT_BASE_TEN
        MOVLW   D'4'
        MOVWF   SHOT_BASE_UNIT

LOAD_BASE_TO_CURR
        MOVF    SHOT_BASE_TEN,W
        MOVWF   SHOT_TEN
        MOVF    SHOT_BASE_UNIT,W
        MOVWF   SHOT_UNIT

        CALL    LCD_UPDATE_SHOT

SHOT_MARK_PRESSED_ONLY
        CLRF    SHOT_BTN_STATE
        RETURN

SHOT_PRESSED_ALREADY
        CLRF    SHOT_BTN_STATE
        RETURN

SHOT_BTN_NOT_PRESSED
        MOVLW   H'01'
        MOVWF   SHOT_BTN_STATE
        RETURN


CHECK_TX_BUTTONS
        BCF     STATUS,RP0

        
        BTFSC   PORTC,2
        GOTO    C2_NOT_PRESSED

        MOVF    BTN_C2_STATE,F
        BTFSS   STATUS,Z
        GOTO    C2_NEW_PRESS
        GOTO    C2_PRESSED_HELD

C2_NEW_PRESS
        MOVLW   'A'
        CALL    UART_TX_CHAR
        CLRF    BTN_C2_STATE
        GOTO    CHECK_C3

C2_PRESSED_HELD
        CLRF    BTN_C2_STATE
        GOTO    CHECK_C3

C2_NOT_PRESSED
        MOVLW   H'01'
        MOVWF   BTN_C2_STATE



CHECK_C3
        BTFSC   PORTC,3
        GOTO    C3_NOT_PRESSED

        MOVF    BTN_C3_STATE,F
        BTFSS   STATUS,Z
        GOTO    C3_NEW_PRESS
        GOTO    C3_PRESSED_HELD

C3_NEW_PRESS
        MOVLW   'B'
        CALL    UART_TX_CHAR
        CLRF    BTN_C3_STATE
        GOTO    CHECK_C4

C3_PRESSED_HELD
        CLRF    BTN_C3_STATE
        GOTO    CHECK_C4

C3_NOT_PRESSED
        MOVLW   H'01'
        MOVWF   BTN_C3_STATE



CHECK_C4
        BTFSC   PORTC,4
        GOTO    C4_NOT_PRESSED

        MOVF    BTN_C4_STATE,F
        BTFSS   STATUS,Z
        GOTO    C4_NEW_PRESS
        GOTO    C4_PRESSED_HELD

C4_NEW_PRESS
        MOVLW   'a'
        CALL    UART_TX_CHAR
        CLRF    BTN_C4_STATE
        GOTO    CHECK_C5

C4_PRESSED_HELD
        CLRF    BTN_C4_STATE
        GOTO    CHECK_C5

C4_NOT_PRESSED
        MOVLW   H'01'
        MOVWF   BTN_C4_STATE



CHECK_C5
        BTFSC   PORTC,5
        GOTO    C5_NOT_PRESSED

        MOVF    BTN_C5_STATE,F
        BTFSS   STATUS,Z
        GOTO    C5_NEW_PRESS
        GOTO    C5_PRESSED_HELD

C5_NEW_PRESS
        MOVLW   'b'
        CALL    UART_TX_CHAR
        CLRF    BTN_C5_STATE
        RETURN

C5_PRESSED_HELD
        CLRF    BTN_C5_STATE
        RETURN

C5_NOT_PRESSED
        MOVLW   H'01'
        MOVWF   BTN_C5_STATE
        RETURN


;DISPLAY 1S

DISPLAY_1S
        MOVLW   D'250'
        MOVWF   SEC_CNT
D1S_LOOP
        CALL    SHOW_ALL_DIGITS
        CALL    CHECK_BUTTON
        CALL    CHECK_SHOT_BUTTON
        CALL    UART_RX_SERVICE
        CALL    CHECK_TX_BUTTONS
        DECFSZ  SEC_CNT,F
        GOTO    D1S_LOOP
        RETURN


SHOW_ALL_DIGITS
        CALL    SHOW_DIG0
        CALL    SHOW_DIG1
        CALL    SHOW_DIG2
        CALL    SHOW_DIG3
        RETURN


SHOW_DIG0
        CLRF    PORTD
        MOVF    M10_REG,W
        ANDLW   H'0F'
        MOVWF   PORTD
        BSF     PORTD,4
        CALL    DELAY_1MS
        RETURN

SHOW_DIG1
        CLRF    PORTD
        MOVF    M1_REG,W
        ANDLW   H'0F'
        MOVWF   PORTD
        BSF     PORTD,5
        CALL    DELAY_1MS
        RETURN

SHOW_DIG2
        CLRF    PORTD
        MOVF    S10_REG,W
        ANDLW   H'0F'
        MOVWF   PORTD
        BSF     PORTD,6
        CALL    DELAY_1MS
        RETURN

SHOW_DIG3
        CLRF    PORTD
        MOVF    S1_REG,W
        ANDLW   H'0F'
        MOVWF   PORTD
        BSF     PORTD,7
        CALL    DELAY_1MS
        RETURN


;BLUETOOTH RECEIVE 

UART_INIT
        BSF     STATUS,RP0

        MOVLW   D'25'
        MOVWF   SPBRG

        MOVLW   B'00100100'
        MOVWF   TXSTA

        BCF     STATUS,RP0

        MOVLW   B'10010000'
        MOVWF   RCSTA

        RETURN


UART_TX_CHAR
TX_WAIT
        BTFSS   PIR1,4
        GOTO    TX_WAIT
        MOVWF   TXREG
        RETURN


UART_RX_SERVICE
        BCF     STATUS,RP0

        BTFSS   PIR1,5
        RETURN

        BTFSC   RCSTA,1
        GOTO    UART_CLEAR_OERR

        MOVF    RCREG,W
        MOVWF   RX_BUF

        MOVF    RX_BUF,W
        XORLW   'C'
        BTFSC   STATUS,Z
        GOTO    RX_C_CAP

        MOVF    RX_BUF,W
        XORLW   'c'
        BTFSC   STATUS,Z
        GOTO    RX_C_LOW

        MOVF    RX_BUF,W
        XORLW   'T'
        BTFSC   STATUS,Z
        GOTO    RX_T_CAP

        MOVF    RX_BUF,W
        XORLW   't'
        BTFSC   STATUS,Z
        GOTO    RX_T_LOW

        MOVF    RX_BUF,W
        XORLW   'S'
        BTFSC   STATUS,Z
        GOTO    RX_S_CAP

        MOVF    RX_BUF,W
        XORLW   's'
        BTFSC   STATUS,Z
        GOTO    RX_S_LOW

        MOVF    RX_BUF,W
        XORLW   'G'
        BTFSC   STATUS,Z
        GOTO    RX_G_CAP

        MOVF    RX_BUF,W
        XORLW   'g'
        BTFSC   STATUS,Z
        GOTO    RX_G_LOW

        MOVF    RX_BUF,W
        XORLW   'D'
        BTFSC   STATUS,Z
        GOTO    RX_D_CAP

        MOVF    RX_BUF,W
        XORLW   '1'
        BTFSC   STATUS,Z
        GOTO    RX_Q_NUM

        MOVF    RX_BUF,W
        XORLW   '2'
        BTFSC   STATUS,Z
        GOTO    RX_Q_NUM

        MOVF    RX_BUF,W
        XORLW   '3'
        BTFSC   STATUS,Z
        GOTO    RX_Q_NUM

        MOVF    RX_BUF,W
        XORLW   '4'
        BTFSC   STATUS,Z
        GOTO    RX_Q_NUM

        RETURN


UART_CLEAR_OERR
        BCF     RCSTA,4
        BSF     RCSTA,4
        MOVF    RCREG,W
        RETURN


RX_C_CAP
        CALL    LCD_MSG_CHAL_TA
        RETURN

RX_C_LOW
        CALL    LCD_MSG_CHAL_TB
        RETURN

RX_T_CAP
        CALL    LCD_MSG_TIMEOUT_TA
        RETURN

RX_T_LOW
        CALL    LCD_MSG_TIMEOUT_TB
        RETURN

RX_S_CAP
        CALL    LCD_MSG_SUB_TA
        RETURN

RX_S_LOW
        CALL    LCD_MSG_SUB_TB
        RETURN

RX_G_CAP
        CALL    LCD_GAME_OVER_TA_WINS
        RETURN

RX_G_LOW
        CALL    LCD_GAME_OVER_TB_WINS
        RETURN

RX_D_CAP
        CALL    LCD_GAME_OVER_DRAW
        RETURN


RX_Q_NUM
        MOVLW   H'8B'
        CALL    COMMAND
        MOVF    RX_BUF,W
        CALL    CHAR
        RETURN






;LCD COMMANDS/INITIALIZE

CONFILCD
        CALL    DELAY20MS

        MOVLW   H'3C'
        CALL    COMMAND

        MOVLW   H'0C'
        CALL    COMMAND

        MOVLW   H'06'
        CALL    COMMAND

        MOVLW   H'01'
        CALL    COMMAND

        RETURN



COMMAND
        BCF     PORTE,2       
        BCF     PORTE,0       
        MOVWF   PORTD         
        NOP
        BSF     PORTE,0       
        NOP
        BCF     PORTE,0       
        CALL    DELAY3MS      
        RETURN



CHAR
        BSF     PORTE,2       
        BCF     PORTE,0       
        MOVWF   PORTD
        NOP
        BSF     PORTE,0
        NOP
        BCF     PORTE,0
        CALL    DELAY3MS
        RETURN


;LCD OUTPUT MESSAGES

LCD_PRINT_STATIC
        MOVLW   H'80'
        CALL    COMMAND

        MOVLW   'T'
        CALL    CHAR
        MOVLW   'A'
        CALL    CHAR
        MOVLW   'F'
        CALL    CHAR
        MOVLW   '0'
        CALL    CHAR
        MOVLW   ' '
        CALL    CHAR
        MOVLW   'T'
        CALL    CHAR
        MOVLW   'B'
        CALL    CHAR
        MOVLW   'F'
        CALL    CHAR
        MOVLW   '0'
        CALL    CHAR
        MOVLW   ' '
        CALL    CHAR
        MOVLW   'Q'
        CALL    CHAR
        MOVLW   '1'
        CALL    CHAR
        MOVLW   ' '
        CALL    CHAR
        MOVLW   '2'
        CALL    CHAR
        MOVLW   '4'
        CALL    CHAR
        MOVLW   's'
        CALL    CHAR

        RETURN


LCD_MSG_CHAL_TA
        MOVLW   H'C0'
        CALL    COMMAND

        MOVLW   ' '
        CALL    CHAR
        MOVLW   ' '
        CALL    CHAR
        MOVLW   'C'
        CALL    CHAR
        MOVLW   'h'
        CALL    CHAR
        MOVLW   'a'
        CALL    CHAR
        MOVLW   'l'
        CALL    CHAR
        MOVLW   'l'
        CALL    CHAR
        MOVLW   'e'
        CALL    CHAR
        MOVLW   'n'
        CALL    CHAR
        MOVLW   'g'
        CALL    CHAR
        MOVLW   'e'
        CALL    CHAR
        MOVLW   ' '
        CALL    CHAR
        MOVLW   'T'
        CALL    CHAR
        MOVLW   'A'
        CALL    CHAR
        MOVLW   ' '
        CALL    CHAR
        MOVLW   ' '
        CALL    CHAR

        CALL    FIVESCLEAR

        RETURN


LCD_MSG_CHAL_TB
        MOVLW   H'C0'
        CALL    COMMAND

        MOVLW   ' '
        CALL    CHAR
        MOVLW   ' '
        CALL    CHAR
        MOVLW   'C'
        CALL    CHAR
        MOVLW   'h'
        CALL    CHAR
        MOVLW   'a'
        CALL    CHAR
        MOVLW   'l'
        CALL    CHAR
        MOVLW   'l'
        CALL    CHAR
        MOVLW   'e'
        CALL    CHAR
        MOVLW   'n'
        CALL    CHAR
        MOVLW   'g'
        CALL    CHAR
        MOVLW   'e'
        CALL    CHAR
        MOVLW   ' '
        CALL    CHAR
        MOVLW   'T'
        CALL    CHAR
        MOVLW   'B'
        CALL    CHAR
        MOVLW   ' '
        CALL    CHAR
        MOVLW   ' '
        CALL    CHAR

        CALL    FIVESCLEAR
        RETURN


LCD_MSG_TIMEOUT_TA
        MOVLW   H'C0'
        CALL    COMMAND

        MOVLW   ' '
        CALL    CHAR
        MOVLW   ' '
        CALL    CHAR
        MOVLW   ' '
        CALL    CHAR
        MOVLW   'T'
        CALL    CHAR
        MOVLW   'i'
        CALL    CHAR
        MOVLW   'm'
        CALL    CHAR
        MOVLW   'e'
        CALL    CHAR
        MOVLW   'O'
        CALL    CHAR
        MOVLW   'u'
        CALL    CHAR
        MOVLW   't'
        CALL    CHAR
        MOVLW   ' '
        CALL    CHAR
        MOVLW   'T'
        CALL    CHAR
        MOVLW   'A'
        CALL    CHAR
        MOVLW   ' '
        CALL    CHAR
        MOVLW   ' '
        CALL    CHAR
        MOVLW   ' '
        CALL    CHAR

        CALL    FIVESCLEAR

        RETURN


LCD_MSG_TIMEOUT_TB
        MOVLW   H'C0'
        CALL    COMMAND

        MOVLW   ' '
        CALL    CHAR
        MOVLW   ' '
        CALL    CHAR
        MOVLW   ' '
        CALL    CHAR
        MOVLW   'T'
        CALL    CHAR
        MOVLW   'i'
        CALL    CHAR
        MOVLW   'm'
        CALL    CHAR
        MOVLW   'e'
        CALL    CHAR
        MOVLW   'O'
        CALL    CHAR
        MOVLW   'u'
        CALL    CHAR
        MOVLW   't'
        CALL    CHAR
        MOVLW   ' '
        CALL    CHAR
        MOVLW   'T'
        CALL    CHAR
        MOVLW   'B'
        CALL    CHAR
        MOVLW   ' '
        CALL    CHAR
        MOVLW   ' '
        CALL    CHAR
        MOVLW   ' '
        CALL    CHAR

        CALL    FIVESCLEAR

        RETURN


LCD_MSG_SUB_TA
        MOVLW   H'C0'
        CALL    COMMAND

        MOVLW   ' '
        CALL    CHAR
        MOVLW   'S'
        CALL    CHAR
        MOVLW   'u'
        CALL    CHAR
        MOVLW   'b'
        CALL    CHAR
        MOVLW   's'
        CALL    CHAR
        MOVLW   't'
        CALL    CHAR
        MOVLW   'i'
        CALL    CHAR
        MOVLW   't'
        CALL    CHAR
        MOVLW   'u'
        CALL    CHAR
        MOVLW   't'
        CALL    CHAR
        MOVLW   'e'
        CALL    CHAR
        MOVLW   ' '
        CALL    CHAR
        MOVLW   'T'
        CALL    CHAR
        MOVLW   'A'
        CALL    CHAR
        MOVLW   ' '
        CALL    CHAR
        MOVLW   ' '
        CALL    CHAR
        CALL    FIVESCLEAR
        RETURN


LCD_MSG_SUB_TB
        MOVLW   H'C0'
        CALL    COMMAND

        MOVLW   ' '
        CALL    CHAR
        MOVLW   'S'
        CALL    CHAR
        MOVLW   'u'
        CALL    CHAR
        MOVLW   'b'
        CALL    CHAR
        MOVLW   's'
        CALL    CHAR
        MOVLW   't'
        CALL    CHAR
        MOVLW   'i'
        CALL    CHAR
        MOVLW   't'
        CALL    CHAR
        MOVLW   'u'
        CALL    CHAR
        MOVLW   't'
        CALL    CHAR
        MOVLW   'e'
        CALL    CHAR
        MOVLW   ' '
        CALL    CHAR
        MOVLW   'T'
        CALL    CHAR
        MOVLW   'B'
        CALL    CHAR
        MOVLW   ' '
        CALL    CHAR
        MOVLW   ' '
        CALL    CHAR

        CALL    FIVESCLEAR

        RETURN


LCD_GAME_OVER_TA_WINS
        MOVLW   H'C0'
        CALL    COMMAND

        MOVLW   'G'
        CALL    CHAR
        MOVLW   'a'
        CALL    CHAR
        MOVLW   'm'
        CALL    CHAR
        MOVLW   'e'
        CALL    CHAR
        MOVLW   ' '
        CALL    CHAR
        MOVLW   'O'
        CALL    CHAR
        MOVLW   'v'
        CALL    CHAR
        MOVLW   'e'
        CALL    CHAR
        MOVLW   'r'
        CALL    CHAR
        MOVLW   ' '
        CALL    CHAR
        MOVLW   'T'
        CALL    CHAR
        MOVLW   'A'
        CALL    CHAR
        MOVLW   ' '
        CALL    CHAR
        MOVLW   'W'
        CALL    CHAR
        MOVLW   'I'
        CALL    CHAR
        MOVLW   'N'
        CALL    CHAR

        CALL    FIVESCLEAR

        GOTO    _FINISH


LCD_GAME_OVER_TB_WINS
        MOVLW   H'C0'
        CALL    COMMAND

        MOVLW   'G'
        CALL    CHAR
        MOVLW   'a'
        CALL    CHAR
        MOVLW   'm'
        CALL    CHAR
        MOVLW   'e'
        CALL    CHAR
        MOVLW   ' '
        CALL    CHAR
        MOVLW   'O'
        CALL    CHAR
        MOVLW   'v'
        CALL    CHAR
        MOVLW   'e'
        CALL    CHAR
        MOVLW   'r'
        CALL    CHAR
        MOVLW   ' '
        CALL    CHAR
        MOVLW   'T'
        CALL    CHAR
        MOVLW   'B'
        CALL    CHAR
        MOVLW   ' '
        CALL    CHAR
        MOVLW   'W'
        CALL    CHAR
        MOVLW   'I'
        CALL    CHAR
        MOVLW   'N'
        CALL    CHAR

        CALL    FIVESCLEAR

        GOTO    _FINISH


LCD_GAME_OVER_DRAW
        MOVLW   H'C0'
        CALL    COMMAND

        MOVLW   'G'
        CALL    CHAR
        MOVLW   'a'
        CALL    CHAR
        MOVLW   'm'
        CALL    CHAR
        MOVLW   'e'
        CALL    CHAR
        MOVLW   ' '
        CALL    CHAR
        MOVLW   'O'
        CALL    CHAR
        MOVLW   'v'
        CALL    CHAR
        MOVLW   'e'
        CALL    CHAR
        MOVLW   'r'
        CALL    CHAR
        MOVLW   ' '
        CALL    CHAR
        MOVLW   'D'
        CALL    CHAR
        MOVLW   'r'
        CALL    CHAR
        MOVLW   'a'
        CALL    CHAR
        MOVLW   'w'
        CALL    CHAR
        MOVLW   ' '
        CALL    CHAR
        MOVLW   ' '
        CALL    CHAR

        CALL    FIVESCLEAR

        GOTO    _FINISH


LCD_UPDATE_VALUES
        MOVF    PORTB,W
        MOVWF   DIP_BUF

        MOVF    DIP_BUF,W
        ANDLW   B'00000111'
        MOVWF   TAF_VAL

        MOVF    TAF_VAL,W
        SUBLW   D'5'
        BTFSC   STATUS,C
        GOTO    TAF_OK
        MOVLW   D'5'
        MOVWF   TAF_VAL
TAF_OK
        CLRF    TBF_VAL

        BTFSC   DIP_BUF,5
        BSF     TBF_VAL,0

        BTFSC   DIP_BUF,6
        BSF     TBF_VAL,1

        BTFSC   DIP_BUF,7
        BSF     TBF_VAL,2

        MOVF    TBF_VAL,W
        SUBLW   D'5'
        BTFSC   STATUS,C
        GOTO    TBF_OK
        MOVLW   D'5'
        MOVWF   TBF_VAL
TBF_OK
        MOVF    TAF_VAL,W
        XORWF   TAF_OLD,W
        BTFSS   STATUS,Z
        GOTO    DO_LCD_UPDATE

        MOVF    TBF_VAL,W
        XORWF   TBF_OLD,W
        BTFSS   STATUS,Z
        GOTO    DO_LCD_UPDATE

        RETURN

DO_LCD_UPDATE
        MOVF    TAF_VAL,W
        MOVWF   TAF_OLD
        MOVF    TBF_VAL,W
        MOVWF   TBF_OLD

        MOVLW   H'83'
        CALL    COMMAND
        MOVF    TAF_VAL,W
        ADDLW   '0'
        CALL    CHAR

        MOVLW   H'88'
        CALL    COMMAND
        MOVF    TBF_VAL,W
        ADDLW   '0'
        CALL    CHAR

        RETURN




FIVESCLEAR
        MOVLW   D'19'
        MOVWF   REG5H
        MOVLW   D'136'
        MOVWF   REG5L

DELAY_5S
        CALL    DELAY_1MS

        DECFSZ  REG5L, F
        GOTO    DELAY_5S

        DECFSZ  REG5H, F
        GOTO    DELAY_5S

        MOVLW   H'C0'
        CALL    COMMAND

        MOVLW   ' '
        CALL    CHAR
        MOVLW   ' '
        CALL    CHAR
        MOVLW   ' '
        CALL    CHAR
        MOVLW   ' '
        CALL    CHAR
        MOVLW   ' '
        CALL    CHAR
        MOVLW   ' '
        CALL    CHAR
        MOVLW   ' '
        CALL    CHAR
        MOVLW   ' '
        CALL    CHAR
        MOVLW   ' '
        CALL    CHAR
        MOVLW   ' '
        CALL    CHAR
        MOVLW   ' '
        CALL    CHAR
        MOVLW   ' '
        CALL    CHAR
        MOVLW   ' '
        CALL    CHAR
        MOVLW   ' '
        CALL    CHAR
        MOVLW   ' '
        CALL    CHAR

        RETURN


;DELAYS

DELAY20MS
        MOVLW   D'1'
        MOVWF   REG3
        MOVLW   D'25'
        MOVWF   REG2
        MOVLW   D'255'
        MOVWF   REG1
        DECFSZ  REG1,F
        GOTO    $-1
        DECFSZ  REG2,F
        GOTO    $-5
        DECFSZ  REG3,F
        GOTO    $-9
        RETURN


DELAY3MS
        MOVLW   D'1'
        MOVWF   REG3
        MOVLW   D'6'
        MOVWF   REG2
        MOVLW   D'166'
        MOVWF   REG1
        DECFSZ  REG1,F
        GOTO    $-1
        DECFSZ  REG2,F
        GOTO    $-5
        DECFSZ  REG3,F
        GOTO    $-9
        RETURN


DELAY_1MS
        MOVLW   D'1'
        MOVWF   REG3
        MOVLW   D'1'
        MOVWF   REG2
        MOVLW   D'200'
        MOVWF   REG1
        DECFSZ  REG1,F
        GOTO    $-1
        DECFSZ  REG2,F
        GOTO    $-5
        DECFSZ  REG3,F
        GOTO    $-9
        RETURN




_FINISH

        END
