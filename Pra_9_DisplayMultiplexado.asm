;**********************************************************************
	;                                                                     *
	;    Filename:	    xxx.asm                                           *
	;    Date:     30 de ABRIL  2021                                     *
	;    File Version:                                                    *
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
	list		p=16f887	; list directive to define processor
	#include	<p16f887.inc>	; processor specific variable definitions

	__CONFIG    _CONFIG1, _LVP_OFF & _FCMEN_ON & _IESO_OFF & _BOR_OFF & _CPD_OFF & _CP_OFF & _MCLRE_ON & _PWRTE_ON & _WDT_OFF & _INTRC_OSC_NOCLKOUT
	__CONFIG    _CONFIG2, _WRT_OFF & _BOR21V

	CBLOCK 0X20									; Direcció De Memoria Para Las Variables
		T1, T2, T3                  			; Variable Para El Retardo
		W_RES, STATUS_RES						; Variables Para El Programa
		CONT, PUNTERO, HABILITA					; Variables Para El Programa
		CONVE, CONVEX							; Variables Para El Programa	
	ENDC										; Fin De Bloque De Librerías 

	ORG 0X00									; Inicio Del Programa
		GOTO			CONFIGURACION			; Etiqueta Configuración
	ORG 0X04									; Dirreción de la Interrupcion
		GOTO			INTERRUPCION			; Etiqueta Interrupcion

	CONFIGURACION:
			CLRW								; Limpiar W (Poner en 0's)
			BSF 				STATUS, RP0		; RP0 = Registro 1 de status
			MOVLW				0X00			; 00000000
			MOVWF				TRISB			; Puerto B Como Salida
			MOVLW				0XF0				; 11110000
			MOVWF				TRISA			; Puerto A como Entrada y Salida
			BCF					STATUS, RP0		; RP0 = Registro Status
			CLRF				PORTA			; Limpiar PORTA (Poner en 0's)
			CLRF				PORTB			; Limpiar PORTB (Poner en 0's)
			BSF					HABILITA,3		; Poner En 1 El Bit 3 De Habilita

	CONFI_TMR0:
			MOVLW				b'10100000'		; Configurar TMR0
	
	INTCONN:
			MOVWF				INTCON			; Asignación  De Valores A Las Banderas Del Registro
			BSF					STATUS, RP0
			MOVLW				b'10000010'		; Configurar OPTION_REG

	OPTION_REGG:
			MOVWF				OPTION_REG		; Asignación De Valores A Las Banderas Del Registro
			BCF					STATUS, RP0	
			CLRF				CONT			; Limpiar La Variable CONT
			CLRF				PUNTERO			; Limpiar La Variable PUNTERO

	INICIO:
			CALL				RETARDO			; Mandar A Llamar Subrutina RETARDO
			INCF				PUNTERO, 1		; PUNTERO =PUNTERO+1
			MOVF				PUNTERO, 0		; W = PUNTERO
			SUBLW				.36				; Resta 36 A W
			BTFSS				STATUS, Z		; Verifica SI Z == 1
			GOTO 				INICIO			; No (Se Va A Inicio)
			CLRF				PUNTERO			; Si (Limpia La Variable PUNTERO)
			GOTO 				INICIO			; Se Va Inicio


	INTERRUPCION:
			MOVWF				W_RES			; Mueve W a W_REs
			SWAPF				STATUS, W		; Intercambia STATUS En W
			MOVWF				STATUS_RES		; W = STATUS_RES
			MOVF				CONT, 0			; Mueve Cont A W
			SUBLW				0X04			; Resta 4 A W
			BTFSS				STATUS, Z		; Verifica Si Z == 1
			GOTO 				CICLO			; No (Se Va A Ciclo)
			CLRF				CONT			; Si (Se Limpia Contador)
			CLRF				HABILITA			; Se Limpia HABILITA
			BSF					HABILITA, 3		; Se Pone En 1 El Bit 3 De HABILITA

	CICLO:
			MOVF				CONT,0			; Mueve CONT A W
			ADDWF				PUNTERO,0		; Suma Puntero A W
			CALL				TABLA			; Manda A Llamar TABLA
			MOVWF				CONVE				; Variable Para Invertir
			COMF				CONVE,W			; Hace Cl Complemento De La Salida
			MOVWF				PORTB			; Se Muestra El Resultado En PUERTB
			MOVF				HABILITA,0		; W <- HABILITA
			MOVWF				CONVEX			; Variable para invertir
			COMF				CONVEX,W		; Hace el complemento de la salida
			MOVWF				PORTA			; Se Muestra En PUERTA
			INCF				CONT,1			; CONT = CONT+1
			RRF					HABILITA,F		; Rota Hacia La Derecha HABILITA
			SWAPF				STATUS_RES,W	; W = SWAP(STATUS_RES)
			MOVWF				STATUS			; W = STATUS
			SWAPF				W_RES,W_RES		; W_RES = SWAPF(W_RES)
			SWAPF				W_RES,W			; W = SWAPF(W_RES)
			BCF					INTCON, T0IF		; Limpia El Bit T0IF Del Registro INTCON
			RETFIE								; Termina La Interrupción

TABLA
	ADDWF				PCL, 1					; PCL = W + PCL
			RETLW	b'11111111'	; ESPACIO
			RETLW	b'10001001';H
			RETLW	b'11000000';O
			RETLW   b'11000111';L
			RETLW	b'10001000';A
			RETLW	b'11111111';ESPACIO
			RETLW	b'00010001';y
			RETLW	b'11000000';O
			RETLW	b'11111111';ESPACIO
			RETLW	b'10010010';S
			RETLW	b'11000000';O
			RETLW	b'00010001';y
			RETLW	b'11111111';ESPACIO
			RETLW	b'11100001';J
			RETLW	b'11000000';O
			RETLW	b'10010010';S
			RETLW	b'10000110';E
			RETLW	b'11111111';ESPACIO
			RETLW	b'11000111';L
			RETLW	b'11000001';U
			RETLW	b'11001111';I
			RETLW	b'10010010';S
			RETLW	b'11111111'; ESPACIO
			RETLW	b'10101111';R
			RETLW	b'11000001';U
			RETLW	b'11001111';I
			RETLW	b'10100100';Z
			RETLW	b'11111111'; ESPACIO
			RETLW	b'11000110';C
			RETLW	b'10001001';H
			RETLW	b'10001000';A
			RETLW	b'11100011';V
			RETLW	b'10000110';E
			RETLW	b'10100100';Z
			RETLW	b'11111111'; ESPACIO
			RETLW	b'11001111';I
			RETLW	b'11000110';C
			RETLW	b'11000000';O
			RETLW	b'11111111'; ESPACIO




	RETARDO 									; Etiqueta para el retardo
		    MOVLW    D'4' 						; Retraso de 1 milisegundo
		    MOVWF    T1 						; Mueve a la variable T1
	LOOP1
		    MOVLW    D'155'						; Carga el valor en decimal de 40 ciclos
		    MOVWF    T2 						; Lo mueve a la variable T2
	LOOP2
		    MOVLW    D'207' 					; Carga el valor en decimal de 30 ciclos
		    MOVWF    T3 						; Lo mueve a la variable T3
	LOOP3
		    DECFSZ   T3, 1 						; Decrementa el registro y salta si es cero
		    GOTO     LOOP3 						; Lo envía al loop3
		    DECFSZ   T2, 1 					    ; Decrementa el registro y salta si es cero
		    GOTO     LOOP2 					    ; Si no lo envía al loop2
		    DECFSZ   T1, 1 						; Decrementa si es cero salta
		    GOTO     LOOP1			    		; Si no lo envía al loop1
		    RETURN                              ; Repite la instrucción
       END