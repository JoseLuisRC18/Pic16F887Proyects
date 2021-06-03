;**********************************************************************
;                                                                     *
;    Filename:	    xxx.asm                                           *
;    Date:     26 de Febrero 2021                                                   *
;    File Version:                                                    *
;                                                                     *
;    Author:   Jose Luis Ruiz Chavez                                                       *
;    Company:   Sistemas Digitales                                                      *
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


	list		p=16f887	; list directive to define processor
	#include	<p16f887.inc>	; processor specific variable definitions

	CBLOCK	0X20
			CounterA,CounterB,CounterC,ELCONT
	ENDC
	
	__CONFIG    _CONFIG1, _LVP_OFF & _FCMEN_ON & _IESO_OFF & _BOR_OFF & _CPD_OFF & _CP_OFF & _MCLRE_ON & _PWRTE_ON & _WDT_OFF & _INTRC_OSC_NOCLKOUT
	__CONFIG    _CONFIG2, _WRT_OFF & _BOR21V

			
	
	
	
	ORG     0x000             ; processor reset vector
	NOP
  	GOTO    config_port             ; go to beginning of program
	

config_port

	BSF		STATUS,RP0		 ;Cambio al Bank_0

	MOVLW	0xFF			;Configua el PORTA 
	MOVWF	TRISA				
;	MOVWF	TRISC

	MOVLW	0x00			;Configuramos el PORTB como salida 
	MOVWF	TRISB
	MOVWF	TRISC
	BSF		STATUS,RP1
	CLRF	ANSEL			;Configuramos el puerto como digital
	CLRF	ANSELH
	BCF		STATUS,RP0
	BCF		STATUS,RP1		;cambiamos de banco 
	MOVLW	0X00
	MOVWF	PORTA
	CLRF	PORTB
	CLRF	PORTC
	GOTO	INICIO

	CLRF	PORTA				;limpio el PORTA
	CLRF	PORTB				;limpio el PORTC
	CLRF	PORTC				;limpio el PORTC
	CLRF	PORTD				;limpio el PORTD




INICIO
	MOVLW	B'11111111'
	MOVWF	PORTB
	MOVLW	B'00000000'
	MOVWF	PORTC
	GOTO 	ULTI
	
	GOTO	INICIO

;CONTADOR SE LIMPIA
ULTI
	CLRF	ELCONT
;CONTADOR		
PROCEDI	
	MOVF	ELCONT,W
	CALL	TABLA_1		
	MOVWF	PORTB
	MOVF	ELCONT,W	
	CALL	TABLA		
	MOVWF	PORTC		
	CALL	RETARDO		
	INCF	ELCONT,F	
	MOVLW	.22			
	XORWF	ELCONT,W	
	BTFSS	STATUS,Z	
	GOTO	PROCEDI	
	GOTO	ULTI		
TABLA_1
	;		  HGFEDCBA 
	ADDWF	PCL,F			
	RETLW	b'01111100';J
	RETLW	b'11111111';O
	RETLW	b'10111011';S
	RETLW	b'11110011';E
	RETLW	b'00000000';ESPACIO
	RETLW	b'11110000';L
	RETLW	b'11111100';U
	RETLW	b'00110011';I
	RETLW	b'10111011';S
	RETLW	b'00000000';ESPACIO
	RETLW	b'11000111';R
	RETLW	b'11111100';U
	RETLW	b'00110011';I
	RETLW	b'00110011';Z
	RETLW	b'00000000';ESPACIO
	RETLW	b'11110011';C
	RETLW	b'11001100';H
	RETLW	b'11001111';A
	RETLW	b'11000000';V
	RETLW	b'11110011';E
	RETLW	b'00110011';Z
	RETLW	b'00000000';ESPACIO


TABLA
	;		  UTSRPNMK	
	ADDWF	PCL,F		
	RETLW	b'00000000';J
	RETLW	b'00000000';O
	RETLW	b'10001000';S
	RETLW	b'10000000';E
	RETLW	b'00000000';ESPACIO
	RETLW	b'00000000';L
	RETLW	b'00000000';U
	RETLW	b'00100010';I
	RETLW	b'10001000';S
	RETLW	b'00000000';ESPACIO
	RETLW	b'10011000';R
	RETLW	b'00000000';U
	RETLW	b'00100010';I
	RETLW	b'01000100';Z
	RETLW	b'00000000';ESPACIO
	RETLW	b'00000000';C
	RETLW	b'10001000';H
	RETLW	b'10001000';A
	RETLW	b'01000100';V
	RETLW	b'10000000';E
	RETLW	b'01000100';Z
	RETLW	b'00000000';ESPACIO
LIMPIAR
	CLRF	PORTB
	CLRF	PORTC		
	GOTO	INICIO		
	
RETARDO
	
		movlw	D'3'
		movwf	CounterC
		movlw	D'8'
		movwf	CounterB
		movlw	D'118'
		movwf	CounterA
	loop		decfsz	CounterA,1
		goto	loop
		decfsz	CounterB,1
		goto	loop
		decfsz	CounterC,1
		goto	loop
		retlw	0
	RETURN	
	END 