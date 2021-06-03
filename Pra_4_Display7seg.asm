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

	CounterC	EQU		0X20	
	CounterB	EQU		0X22
	CounterA	EQU		0X21
	

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

	MOVWF	b'00000001'		;le damos el valor de uno a w
	MOVWF	PORTB			;w se va al puerto b
	CALL	RETARDO			;mandamos a llamar la funcion retardo
	
	BTFSS	PORTB,7			;utilizamos esta funcion como un if
	GOTO	IZQUIERDA		;salta a funcion izquierda	
	GOTO	DERECHA			;Salta a la funcion derecha

IZQUIERDA			
	RLF		PORTB,W			;vamos recorriendo los bits a la izquierda del portb y se van w
	MOVWF	PORTB			; de w se regresan al PORTB
	
	GOTO	INICIO	;hacemos el salto a INICIO
	
	
DERECHA	
	RRF		PORTB,W			;Vamos recorriendo los bits a la derecha
	MOVWF	PORTB			;lo mandamos a de nuevo a PORTB
	CALL	RETARDO 		;Llamamos a la funcion retardo
	BTFSS	PORTB,0			;condicion si hay un uno en el RB0
	GOTO	DERECHA			;se ejecuta hasta que se cumpla
	GOTO	IZQUIERDA		;Al terminar se vuleve ejecutar hacia la derecha
	
	
	
RETARDO						;Funcion retardo hecha con el software
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
			

	END 