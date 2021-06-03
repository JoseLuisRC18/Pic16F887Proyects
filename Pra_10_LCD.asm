;**********************************************************************
;                                                                     *
;    Filename:	    Practica10.asm                                    *
;    Date:     7 de Mayo  2021                                        *
;                                                                     *
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
	list		 p=16f887	    
	#include	<p16f887.inc>	

	__CONFIG    _CONFIG1, _LVP_OFF & _FCMEN_ON & _IESO_OFF & _BOR_OFF & _CPD_OFF & _CP_OFF & _MCLRE_ON & _PWRTE_ON & _WDT_OFF & _INTRC_OSC_NOCLKOUT
	__CONFIG    _CONFIG2, _WRT_OFF & _BOR21V

		ORG 0x00
	#DEFINE RS PORTD,6					;PORD6  
	#DEFINE E  PORTD,7					;PORD7 enable
	CBLOCK 0x20
		CONT,DIS,COMP,R1,R2,R3,R4,R5,R6
	ENDC
										        ;PUERTOS
			 BSF  			STATUS,RP0
			 CLRF 			TRISB 				;Salida
			 CLRF 			TRISD 				;Salida comandos
			 BCF  			STATUS,RP0
			 CLRF 			PORTB 				;limpiamos puertos
			 CLRF 			PORTD 
			 MOVLW  		H'38' 				;Config del bus de 8 
			 CALL   		CTR	
			 MOVLW			H'0C'				;encender el LCD
			 CALL   		CTR			
			 MOVLW  		H'02' 				;Comando cursor en el inicio 
			 CALL   		CTR	
			 MOVLW  		H'14' 				;derecha
			 CALL   		CTR					
			 MOVLW  		H'01' 				;Limpiamos LCD comando 
			 CALL   		CTR			;Pocicionar 

	
	CICLO						        		;Caracteres en el LCD
	 		 CLRF			DIS
	DEZPLA
			 CLRF			COMP
			 MOVF			DIS,W
			 MOVWF			CONT
			 MOVLW			H'80'				;cambio a segunda linea
			 CALL			CTR

	PRIMERA 
			 MOVF   		CONT,W
			 CALL			TABLA_ARRIBA
			 CALL			CR_PIN
			 INCF			CONT,F          	;Incrementamos el contador
			 INCF			COMP,F
			 MOVLW			.16
			 XORWF  		CONT,W
			 BTFSS			STATUS,Z
			 GOTO			PRIMERA
			 CLRF			CONT

	MUESTRA
			 MOVLW			.16
			 XORWF  		COMP,W
			 BTFSS			STATUS,Z			;condiciones
			 GOTO   		SIGUE
			 GOTO			MOS_SEGUNDA

	SIGUE
			 MOVF   		CONT,W
			 CALL			TABLA_ARRIBA
			 CALL			CR_PIN				;Mandar datos de la tabla arriba
			 INCF			CONT,F
			 INCF			COMP,F
			 GOTO			MUESTRA

	MOS_SEGUNDA
			 CLRF			COMP
			 MOVF			DIS,W
			 MOVWF			CONT
			 MOVLW			.193				;donde empieza la segunda linea
			 CALL			CTR

	SEG 
			 MOVF   		CONT,W
			 CALL			TABLA_ABAJO
			 CALL			CR_PIN				
			 INCF			CONT,F				;incremento al contador
			 INCF			COMP,F
			 MOVLW			.16
			 XORWF  		CONT,W
			 BTFSS			STATUS,Z
			 GOTO			SEG
			 CLRF			CONT

	MUESTRA2
			 MOVLW			.16
			 XORWF  		COMP,W
			 BTFSS			STATUS,Z
			 GOTO   		SIGUE2
			 GOTO			VACIA

	SIGUE2
			 MOVF   		CONT,W
			 CALL			TABLA_ABAJO			;llamamos la tabla pra la palabra de abajo
			 CALL			CR_PIN
			 INCF			CONT,F
			 INCF			COMP,F
			 GOTO			MUESTRA2

	VACIA 
	
			 CALL			RET_2
			 MOVLW  		H'01' 				;LCD limpio comando 
			 CALL   		CTR
			 CALL			RET_1
			 INCF			DIS,F
			 MOVLW			.15
			 XORWF 			DIS,W
			 BTFSS			STATUS,Z
			 GOTO			DEZPLA					
			 GOTO			CICLO				;volvemos al principio

	
	TABLA_ARRIBA
			 ADDWF			PCL,F				;DT es como retlw es para simplificar 
			 DT				"Practica  LCD  "  	;primera linea
	TABLA_ABAJO
			 ADDWF			PCL,F
			 DT				"Jose Luis RCh  "   ;segunda linea
	CR_PIN
			 BSF			RS					;caracteres 
			 GOTO   		ENABLE
	CTR 
	 		 BCF 			RS					;RS manda cero 
	ENABLE				
			 MOVWF  		PORTB
			 BSF			E					;ponemos 1 al enable
			 CALL			RET_1
			 BCF			E					;ponemos 0 al enable
			 CALL			RET_1
			 RETURN



	RET_1
			 MOVLW  		.1  				;Retraso de 1 m/s
			 MOVWF  		R1 					;movemos a R1
	LOOP1
			 MOVLW  		.20 				;Hacemos 20 ciclos
			 MOVWF  		R2					;movemos a R2
	LOOP2
			 MOVLW  		.1 				
			 MOVWF  		R3					;Movemos a R3
	LOOP3
			 DECFSZ 		R3,1 				;Decrementa y cambia si es 0
			 GOTO   		LOOP3 				;se va loop3
			 DECFSZ 		R2,1 				;Decrementa y cambia si es 0
			 GOTO   		LOOP2 				;se va loop2
			 DECFSZ 		R1,1 				;Decrementa si es 0
			 GOTO   		LOOP1 				;Si  loop1
			 RETURN


	RET_2
			 MOVLW  		.15  				;Retraso  15 m/s
			 MOVWF  		R4 				    ;Mueve a R4
	LOOP4
			 MOVLW  		.50  				;Hacemos 50 ciclos
			 MOVWF  		R5				    ;Mueve a R5
	LOOP5
			 MOVLW  		.200 				;200 ciclos
			 MOVWF  		R6 			    	;Mueve a R6
	LOOP6
			 DECFSZ 		R6,1 				;Decrementa si es 0
			 GOTO   		LOOP6 				;se va loop6
			 DECFSZ 		R5,1 				;Decrementa si es 0
			 GOTO   		LOOP5 				;Se va loop5
			 DECFSZ 		R4,1 				;Decrementa si es 0
			 GOTO   		LOOP4 				;Se va loop4
			 RETURN
	END