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
;    Notes:  Este programa hace diferentes secuencias un total de 4 van                                                         *
;       estas van en el PORTA                                                               *
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
	
;CONFIGURACION DE PUERTOS
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

;INICIO DEL PROGRAMA Y COMPARACIONES 

INICIO
	
	CLRF	PORTB
	MOVLW	b'00000001'
	
	BTFSC	PORTA,0
	GOTO 	CON_2
	GOTO	CON_1
	
	
CON_1
	BTFSC	PORTA,1
	GOTO	SEC_2
	GOTO	SEC_0
	

CON_2
	BTFSC	PORTA,1
	GOTO	SEC_3
	GOTO	SEC_1


;SECUENCIAS
SEC_0
	GOTO	COMPLETO	
SEC_1
	MOVWF	PORTB
	GOTO 	IZQ
SEC_2
	MOVLW	B'10000000'
	MOVWF	PORTB
	GOTO 	DERE
SEC_3
	GOTO 	ULTI

;PRIMERA SECUENCIA

COMPLETO
	CALL	CHECAR_0	
	BCF		STATUS,0	
	MOVWF	PORTB		
	CALL	RETARDO		
	BTFSS	PORTB,7			
	GOTO	SEVA_IZQ		
	GOTO	SEVA_DER		

SEVA_IZQ
	CALL	CHECAR_0	
	RLF		PORTB,W		
	GOTO	COMPLETO	

SEVA_DER
	CALL	CHECAR_0	
	RRF		PORTB,W		
	BCF		STATUS,0	
	MOVWF	PORTB		
	CALL	RETARDO			
	BTFSS	PORTB,0			
	GOTO	SEVA_DER			
	GOTO	SEVA_IZQ	
;CHECAR 
CHECAR_0
	BTFSC	PORTA,0		
	GOTO	LIMPIAR
	BTFSC	PORTA,1		
	GOTO	LIMPIAR
	RETURN				


;SEGUNDA SECUENCIA

IZQ
	CALL	CHECAR_1
	BCF		STATUS,0	
	CALL	RETARDO		
	RLF		PORTB,1		
	BTFSS	PORTB,7		
	GOTO	IZQ				
	CALL	RETARDO			
	GOTO	INICIO			
;CHECAR 
CHECAR_1
	BTFSS	PORTA,0			
	GOTO	LIMPIAR	
	BTFSC	PORTA,1			
	GOTO	LIMPIAR
	RETURN					



;TERCERA SECUENCIA

DERE
	CALL	CHECAR_2	
	BCF		STATUS,0	
	CALL	RETARDO		
	RRF		PORTB,1		
	BTFSS	PORTB,0			
	GOTO	DERE		
	CALL	RETARDO		
	GOTO	INICIO			
;CHECAR 
CHECAR_2

	BTFSC	PORTA,0			
	GOTO	LIMPIAR	
	BTFSS	PORTA,1		
	GOTO	LIMPIAR
	RETURN					



;CUARTA SECUENCIA

;CONTADOR SE LIMPIA
ULTI
	CLRF	ELCONT
;CONTADOR		
PROCEDI
	CALL	CHECAR_3	
	MOVF	ELCONT,W	
	CALL	TABLA			
	MOVWF	PORTB		
	CALL	RETARDO		
	INCF	ELCONT,F	
	MOVLW	.6			
	XORWF	ELCONT,W	
	BTFSS	STATUS,Z	; SI HAY 1 EN B Z	
	GOTO	PROCEDI		;SE SIGUE HACIENDO
	GOTO	ULTI		;COMIENZA DE NUEVO
	
;CHECAR 
CHECAR_3
	BTFSS	PORTA,0			
	GOTO	LIMPIAR	
	BTFSS	PORTA,1			
	GOTO	LIMPIAR
	RETURN

TABLA
	ADDWF	PCL,F			
	RETLW	B'10000001'
	RETLW	B'01000010'
	RETLW	B'00100100'
	RETLW	B'00011000'
	RETLW	B'00100100'
	RETLW	B'01000010'
;	RETLW	B'10000001'




LIMPIAR
	CLRF	PORTB		
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

