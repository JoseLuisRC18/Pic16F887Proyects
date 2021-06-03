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


	__CONFIG    _CONFIG1, _LVP_OFF & _FCMEN_ON & _IESO_OFF & _BOR_OFF & _CPD_OFF & _CP_OFF & _MCLRE_ON & _PWRTE_ON & _WDT_OFF & _INTRC_OSC_NOCLKOUT
	__CONFIG    _CONFIG2, _WRT_OFF & _BOR21V


	ORG     0x000             ; processor reset vector
	NOP
  	GOTO    config_port             ; go to beginning of program
	

config_port

	BSF		STATUS,RP0		 ;Cambio al Bank_0

	MOVLW	0xFF			;Configua el PORTA 
	MOVWF	TRISA				
	MOVWF	TRISC

	MOVLW	0x00			;Configuramos el PORTB como salida 
	MOVWF	TRISB
	MOVWF	TRISD
	BSF		STATUS,RP1
	CLRF	ANSEL			;Configuramos el puerto como digital
	CLRF	ANSELH
	BCF		STATUS,RP0
	BCF		STATUS,RP1		;cambiamos de banco 
	MOVLW	0X00
	MOVWF	PORTA
	CLRF	PORTB
	MOVWF	PORTC
	GOTO	INICIO

	CLRF	PORTA				;limpio el PORTA
	CLRF	PORTB				;limpio el PORTC
	CLRF	PORTC				;limpio el PORTC
	CLRF	PORTD				;limpio el PORTD

INICIO
	BTFSS	PORTD,7
	GOTO	ARITMETICA
	GOTO	LOGICA

ARITMETICA 

	MOVF	PORTA,W			;movemos el registro del PORTA a W
	ADDWF	PORTC,0 	;hacemos la suma del del puerto C a W  
	MOVWF	PORTB		;Movemos lo que hay en W al puerto B que es nuestro f 
	BTFSS	STATUS,C			;btsfss es como un if
	GOTO 	TERMINA
	GOTO 	ACA
	

ACA 
	MOVLW	.1			
	MOVWF	PORTD			;PONEMOS UN 1 COMO ACARREO CUANDO SE DESBORDA
	GOTO	ARITMETICA 
	

TERMINA 
	 CLRF	PORTD 		;Aqui termina la suma aritmetica
							
	GOTO 	INICIO

LOGICA					;La suma Logica 
	MOVF	PORTA,W
	IORWF	PORTC,0			;hacemos la operacion similar a la aritmetica
	MOVWF	PORTB
	MOVLW	.0			
	MOVWF	PORTD			;ASIGNE el puerto d donde tenia el acarreo a 0 para que no prenda 
	GOTO	INICIO
	
	
	END 