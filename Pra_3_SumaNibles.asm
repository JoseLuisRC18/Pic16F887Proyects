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

	NIBLE_ONE	EQU		0X20	
	NIBLE_TWO	EQU		0X22
	SUMA_PORTA	EQU		0X21
	

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

	MOVF	PORTA,W			;mandamos lo del puerto a w
	ANDLW	0X0F			;aplicamos la operacion and con un valor 0X0F
	MOVWF	NIBLE_ONE				;MANDAMOS W a la variable

	SWAPF	PORTA,W			;con esta instruccion cambiamos del lugar los bibles
	ANDLW	0X0F			;se aplica and como en el caso anterior
	ADDWF	NIBLE_ONE,W			;agregamos a doble el valor de la variable
	MOVWF	SUMA_PORTA			;mandamos a w la suma 

	;mandamos la entrada del puerto c a w 
	MOVF	PORTC,W			
	ANDLW	0X0F			;como en las operaciones pasadas asignamos este valor hexadecimal
	MOVWF	NIBLE_TWO				;mandamos w a la variable 
	SWAPF	PORTC,W			;igual como antes ocupas esta instruccion para intercambiar los nibles
	ANDLW	0X0F	

	;Aqui hacemos las sumas de los dos puertos
	ADDWF	NIBLE_TWO,W			
	ADDWF	SUMA_PORTA,W		

	CLRF	PORTD				;limpio el PORTD para que no salga nada 

	MOVWF	PORTB			;mandamos el resultado al portb
	GOTO 	INICIO			
		

	END 