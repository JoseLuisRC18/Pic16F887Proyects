	;**********************************************************************
	;                                                                     *
	;    Filename:	    xxx.asm                                           *
	;    Date:     26 de Febrero 2021                                     *
	;    File Version: Cronometro                                                   *
	;                                                                     *
	;    Author:   Jose Luis Ruiz Chavez                                  *
	;    Company:   Sistemas Digitales                                    *
	;                                                                     *
	;                                                                     *
	;**********************************************************************
	;                                                                     *
	;    Files Required: P16F887.INC                                      *
	;                                                                     *
	;**********************************************************************
	;                                                                     *
	;    Notes:                                                           *
	;                                                                     *
	;**********************************************************************

	list		p=16f887 				; list directive to define processor
	#include	<p16f887.inc>			; processor specific variable definitions

	__CONFIG    _CONFIG1, _LVP_OFF & _FCMEN_ON & _IESO_OFF & _BOR_OFF & _CPD_OFF & _CP_OFF & _MCLRE_ON & _PWRTE_ON & _WDT_OFF & _INTRC_OSC_NOCLKOUT
	__CONFIG    _CONFIG2, _WRT_OFF & _BOR21V

	CBLOCK	0X20
		T1,T2,T3
		W_RES,STATUS_RES
		CONT,PTA
	ENDC

	CBLOCK	0X30
		UNIDAD,DECENA,CENTENA,MILLAR
	ENDC


	ORG     0x00             			; processor reset vector
  	goto    config_port         		; go to beginning of program


	ORG     0x04                		; interrupt vector location
	GOTO	INTERRUPCION

config_port
		CLRW
		BSF		STATUS,RP0	     			;PASAR AL BANK_1
		MOVLW	0X00
		MOVWF	TRISB
		MOVLW	0XF0
		MOVWF	TRISA
		BCF		STATUS,RP0
		CLRF	PORTA
		CLRF	PORTB
		BSF		PTA,0
	
CONFI_TMRO
		MOVLW	B'10100000'
		MOVWF	INTCON
		BSF		STATUS,RP0
		MOVLW	B'10000100'
		MOVWF	OPTION_REG
		BCF		STATUS,RP0
		CLRF	CONT

INICIO

		MOVLW 	0X00            			 ; Inicialización de la variable UNIDAD
		MOVWF	UNIDAD
		MOVLW	0X00             			 ; Inicialización de la variable DECENA
		MOVWF   DECENA
		MOVLW   0X00
		MOVWF   CENTENA        			     ; Inicialización de la variable CENTENA
		MOVLW   0X00 
		MOVWF   MILLAR

UNI
		CALL	RETARDO
		INCF	UNIDAD,1
		MOVF	UNIDAD,0
		SUBLW	0X0A
		BTFSS	STATUS,Z
		GOTO	UNI
		GOTO	DECE
DECE
		CLRF	UNIDAD
		INCF	DECENA,1
		MOVF	DECENA,0
		SUBLW	0X06
		BTFSS	STATUS,Z
		GOTO	UNI
		GOTO	CENTE
CENTE
		CLRF	UNIDAD
		CLRF	DECENA
		INCF	CENTENA,1
		MOVF	CENTENA,0
		SUBLW	0X0A
		BTFSS	STATUS,Z
		GOTO	UNI
		GOTO	MILL
MILL
		CLRF	UNIDAD
		CLRF	DECENA
		CLRF	CENTENA
		INCF	MILLAR,1
		MOVF	MILLAR,0
		SUBLW	0X06
		BTFSS	STATUS,Z
		GOTO	UNI
		GOTO	INICIO

INTERRUPCION
		MOVWF	W_RES
		SWAPF	STATUS,W
		MOVWF	STATUS_RES
		MOVF	CONT,0
		SUBLW	0X04
		BTFSS	STATUS,Z
		GOTO	CICLO
		CLRF	CONT
		CLRF	PTA
		BSF		PTA,0
	
CICLO
		MOVF	CONT,0
		ADDLW	0X30
		MOVWF	FSR
		MOVF	INDF,0
		CALL	TABLA
		MOVWF	PORTB
		COMF	PTA,0
		MOVWF	PORTA
		INCF	CONT,1
		RLF		PTA
		SWAPF	STATUS_RES,W
		MOVWF	STATUS
		SWAPF	W_RES,W_RES
		SWAPF	W_RES,W
		BCF		INTCON,T0IF
		RETFIE
	
TABLA
		ADDWF	PCL,F                 		   ;SUMA EL VALOR DE W CON PCL 
		RETLW B'00111111' ; 0
		RETLW B'00000110' ; 1
		RETLW B'01011011' ; 2
		RETLW B'01001111' ; 3
		RETLW B'01100110' ; 4
		RETLW B'01101101' ; 5
		RETLW B'01111101' ; 6
		RETLW B'00000111' ; 7
		RETLW B'01111111' ; 8
		RETLW B'01100111' ; 9

RETARDO
	
		MOVLW	.10
		MOVWF	T1
	LOOP1
		MOVLW	.155
		MOVWF	T2
	LOOP2
		MOVLW	.50
		MOVWF	T3
	LOOP3
		DECFSZ	T3,1
		GOTO	LOOP3
		DECFSZ	T2,1
		GOTO	LOOP2
		DECFSZ	T1,1
		GOTO	LOOP1
		RETURN
		   
	
		END 
