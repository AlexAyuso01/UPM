* Calvo Aguiar, Hernan. Num mat:190090
* Ayuso Exposito, Alejandro. Num mat:190238
*
******************************************************************
*		PROCEDIMIENTOS DE FORMATEO
*	Las etiquetas que nombran a una subrutina no se tabulan	
*
*	Toda etiqueta dentro de una subrutina se tabula una vez
*
*	Toda etiqueta fuera de una subrutina NO SE TABULA
*
*	DefESCRIBIRciones se tabulan 1 vez
*
*	Codigo dentro de subrutinas se tabula 2 veces
*
*	
*	Los comentarios de subrutinas se tabulan dos veces a partir de 
*	la linea mas larga y tienen un espacio despues del asterisco
*
*	O, estan a ras con el codigo (misma tabulacion).
*
*	Tambien pueden no tener un espacio del asterisco a modo de titulo
*
*
*	Codigo comentado no tiene espacio despues del asterisco
*	
*	Los dobles asteriscos son notas de los alumnos a si mismos, no son para comunicar informacion al corrector
*	dicho esto, se intentara eliminar todas las anotaciones de los alumnos.
*
******************************************************************

**************************ESCRIBIRCIO DEL PROGRAMA*************

* ESCRIBIRcializa el SP y el PC
**************************
        ORG     $0
        DC.L    $8000           * Pila
        DC.L	INICIO         * PC

        ORG     $400
        

		*DEFESCRIBIRCION EQUIVALENCIAS 

MR1A	EQU		$effc01       * de modo A (escritura)
MR2A	EQU		$effc01       * de modo A (2 escritura)
SRA		EQU		$effc03       * de estado A (lectura)
CSRA	EQU		$effc03       * de seleccion de reloj A (escritura)
CRA		EQU		$effc05       * de control A (escritura)
TBA		EQU		$effc07       * buffer transmision A (escritura)
RBA		EQU		$effc07       * buffer recepcion A  (lectura)
ACR		EQU		$effc09	      * de control auxiliar
IMR		EQU		$effc0B       * de mascara de interrupcion A (escritura)
ISR		EQU		$effc0B       * de estado de interrupcion A (lectura)

MR1B	EQU		$effc11       * de modo B (escritura)
MR2B	EQU		$effc11       * de modo B (2 escritura)
CRB		EQU		$effc15	      * de control A (escritura)
TBB		EQU		$effc17       * buffer transmision B (escritura)
RBB		EQU		$effc17       * buffer recepcion B (lectura)
SRB		EQU		$effc13       * de estado B (lectura)
CSRB	EQU		$effc13       * de seleccion de reloj B (escritura)

IVR		EQU		$effc19		  * de vector de interrupción

*************************************************************************************

		*DEFESCRIBIRCION DE CONSTANTES PERTINENTES A BUFFERS
		*A/B+(S)END/(R)ECIEVE_(ESCRIBIR)CIO/(FIN)AL/(LEER)POINTER




		* LEER ES NUESTRO PUNTERO DE LEER
		* ESCRIBIR ES NUESTRO PUNTERO DE ESCRIBIR
		* FIN ES NUESTO PUNTERO DE  TAMANO DE BUFER
	TAMANO_BUF:		EQU		2001

	AR:		DS.B	TAMANO_BUF
	AS:		DS.B	TAMANO_BUF

	BR:		DS.B	TAMANO_BUF
	BS:		DS.B	TAMANO_BUF
	
	AS_LEER:		DS.B	4	
	AS_ESCRIBIR: 	DS.B	4
	AS_FIN:			DS.B	4
    AS_FLG:			DS.B	4

	AR_LEER:		DS.B	4
	AR_ESCRIBIR:	DS.B	4
	AR_FIN:			DS.B	4
	AR_FLG:			DS.B	4

	BS_LEER:		DS.B	4
	BS_ESCRIBIR:	DS.B	4
	BS_FIN:			DS.B	4
	BS_FLG:			DS.B	4

	BR_LEER:		DS.B	4
	BR_ESCRIBIR:	DS.B	4
	BR_FIN:			DS.B	4
	BR_FLG:			DS.B	4

	CPY_IMR:	DS.B	2
	
	FLAG_TBA:		DS.B	1
	FLAG_TBB:		DS.B	1
	
	FLAG_LEER:		DS.B	1
	
**************************** INIT *************************************************************
INIT:   MOVE.B		#%00010000,CRA      * ReESCRIBIRcia el puntero MR1
        MOVE.B		#%00010000,CRB		* ReESCRIBIRcia el puntero MR2
        
        MOVE.B		#%00000011,MR1A     * 8 bits por caracter.
        MOVE.B		#%00000011,MR1B		* 8 bits por caracter.
        
        MOVE.B		#%00000000,MR2A     * Eco desactivado en A.
        MOVE.B		#%00000000,MR2B		* Eco desactivado en B.
        
        MOVE.B		#%11001100,CSRA     * Velocidad = 38400 bp.
        MOVE.B		#%11001100,CSRB     * Velocidad = 38400 bp.
        
        MOVE.B		#%00000101,CRA      * Transmision y recepcion activados.
        MOVE.B		#%00000101,CRB      * Transmision y recepcion activados.
        
        MOVE.B		#%00000000,ACR      * Velocidad = 38400 bps.
        
        MOVE.B		#$040,IVR			* Vector interrupcion 40
		MOVE.B		#%00100010,CPY_IMR	* El copy de IMR habilita las interrupciones de A y B
		MOVE.B		CPY_IMR,IMR
		MOVE.L		#RTI,$100

		MOVE.B		#0,FLAG_TBA			* Flag de TBA a 0 
		MOVE.B		#0,FLAG_TBB			* Flag de TBB a 0


		*Inicializo punteros buffers		
		
		MOVE.L 		#TAMANO_BUF,D0			* D0 contiene el 2000, el tamano que vamos a ir sumando a cada puntero
		SUB.L 		#1,D0					* para obtener el fin 
		
		* AR
		MOVEM.L	(A7)+,A0/D0-D1
		
		MOVE.L 		#AR,AR_ESCRIBIR				* AR_ESCRIBIR tiene que valer la direccion de AR
		MOVE.L 		#AR,AR_LEER				* LEER ESCRIBIRcializado al principio del buffer para buffer vacio
		
		*Necesitamos hacer #AR+2000=AR_FIN
		
		MOVE.L 		#AR,A0
		MOVE.L 		A0,D1					* A0 guarda #AR 
		ADD.L 		D0,D1					* #AR+2000 me dara la direccion del puntero final
		MOVE.L 		D1,AR_FIN				* ahora AR_FIN guarda su final de bufer

		* AS


		MOVE.L 		#AS,AS_ESCRIBIR				* para evitar repetir comentarios, solo se explica 
		MOVE.L 		#AS,AS_LEER				* el procedimiento de ESCRIBIRcializacion del primer buffer
		
		MOVE.L 		#AS,A0
		MOVE.L 		A0,D1					
		ADD.L 		D0,D1					
		MOVE.L 		D1,AS_FIN				
		
		* BR
		
		MOVE.L 		#BR,BR_ESCRIBIR				
		MOVE.L 		#BR,BR_LEER				
		
		MOVE.L 		#BR,A0
		MOVE.L 		A0,D1					
		ADD.L 		D0,D1					
		MOVE.L 		D1,BR_FIN				
				
		* BS
		
		
		MOVE.L 		#BS,BS_ESCRIBIR				
		MOVE.L 		#BS,BS_LEER				
		MOVE.L 		#BS,A0
		MOVE.L 		A0,D1					
		ADD.L 		D0,D1					
		MOVE.L 		D1,BS_FIN
		
		MOVEM.L	(A7)+,A0/D0-D1
        RTS
**************************** FIN INIT *********************************************************

**************************** LEECAR *********************************************************
LEECAR:
		MOVEM.L		A0-A4/D1-D3,-(A7)		* Metemos a pila 
		
		MOVE.L		#TAMANO_BUF,D2
		*Compruebo lo que vale buffer (D0)
		
		* PARA AREC (0)
		CLR			D1				*D1 a 0
		CMP.B 		D1,D0			*Hacemos a altura de byte porque sabemos que tanto D0 como D1 solo tienen info relevante en el primer byte
		BEQ			E_AREC
		
		* PARA BREC (1)
		ADD.B		#1,D1			*D1 a 1
		CMP.B 		D1,D0 
		BEQ			BREC
		
		* PARA ASND (2)
		ADD.B		#1,D1			*D1 a 2
		CMP.B 		D1,D0 
		BEQ			ASND
		
		* PARA BSND (3)
		ADD.B		#1,D1			*D1 a 3
		CMP.B 		D1,D0 
		BEQ			BSND
		
		* Si no salta ningun BEQ, la subrutina no deberia hacer nada, solo saltar al fin
		JMP			L_FIN		
		
		
		*CARGA DE PUNTEROS BUFFER 
		
		
	AREC:		
		MOVE.L		AR_LEER,A1			* cargo LEER(A1), ESCRIBIR(A2) y FIN(A3)
		MOVE.L		AR_ESCRIBIR,A2			
		MOVE.L		AR_FIN,A3
		MOVE.L		AR_FLG,A0
		JMP L_AFTER_SEL
			
	BREC:		
		MOVE.L		BR_LEER,A1			* cargo LEER(A1), ESCRIBIR(A2) y FIN(A3)
		MOVE.L		BR_ESCRIBIR,A2			
		MOVE.L		BR_FIN,A3
		MOVE.L		BR_FLG,A0
		JMP L_AFTER_SEL	
					
	ASND:		
		MOVE.L		AS_LEER,A1			* cargo LEER(A1), ESCRIBIR(A2) y FIN(A3)
		MOVE.L		AS_ESCRIBIR,A2			
		MOVE.L		AS_FIN,A3
		MOVE.L		AS_FLG,A0
		JMP L_AFTER_SEL
	
	BSND:		
		MOVE.L		BS_LEER,A1			* cargo LEER(A1), ESCRIBIR(A2) y FIN(A3)
		MOVE.L		BS_ESCRIBIR,A2			
		MOVE.L		BS_FIN,A3
		MOVE.L		BS_FLG,A0	
		JMP L_AFTER_SEL

		
		
	L_AFTER_SEL:	
		CMP.L		#0,A0				* Si flag = 0 entonces vacio
		BEQ			VACIO
			

	*PARTE PRINCIPAL

		MOVE.L		(A1),D0				* cogemos el caracter al que apunta ESCRIBIR y lo guardamos en D0	
		
		MOVE.L		A1,A4				* creamos LEER aux para comprobar los edge cases y lo avanzamos
		ADD.L		#1,A4
		
		CMP			A4,A2				* Comprobamos si LEER=ESCRIBIR sabiendo que flag=1 (no vacio)
		BNE			L_PPAL

	L_UPDT_FLAG:
		CMP.B 		D1,D0			*Hacemos a altura de byte porque sabemos que tanto D0 como D1 solo tienen info relevante en el primer byte
		BEQ			L_AREC_FLG
		
		* PARA BREC (1)
		CMP.B 		D1,D0 
		BEQ			L_BREC_FLG
		
		* PARA ASND (2)
		CMP.B 		D1,D0 
		BEQ			L_ASND_FLG
		
		* PARA BSND (3)
		CMP.B 		D1,D0 
		BEQ			L_BSND_FLG


	L_AREC_FLG:
		MOVE.B		#1,AR_FLG

	L_BREC_FLG:
		MOVE.B		#1,BR_FLG

	L_ASND_FLG:
		MOVE.B		#1,AS_FLG

	L_BSND_FLG:
		MOVE.B		#1,BS_FLG


	L_PPAL:
		CMP.L		A1,A3				* comprobamos si estamos en el final del buffer
		BNE			READ				* si no, saltamos a actualizar el puntero
		SUB.L		D2,A4				* si lo estamos, aux-tamano buffer para ponerlo al ESCRIBIRcio 
		
		* comprobar el bufer y actualizar puntero correspondiente 
		
	READ:
		CMP.B 		#1,D1					*Hacemos a altura de byte porque sabemos que D1 solo tiene info relevante en el primer byte
		BNE			BREC_UPDT
		MOVE.L 		A4,AR_LEER				*Actualizamos puntero con auxiliar 	
		BRA 		L_FIN
			
	BREC_UPDT:
		CMP.B 		#2,D1	
		BNE			ASND_UPDT
		MOVE.L 		A4,BR_LEER				*Actualizamos puntero con auxiliar 	
		BRA 		L_FIN
		
	ASND_UPDT:
		CMP.B 		#3,D1	
		BNE			BSND_UPDT
		MOVE.L 		A4,AS_LEER				*ActualTizamos puntero con auxiliar 	
		BRA 		L_FIN
		
	BSND_UPDT:
		MOVE.L 		A4,BS_LEER				*Actualizamos puntero con auxiliar, sobra cmp porque es un ultimo caso posible
		BRA 		L_FIN
		
		**si no es ninguno de los datos se pone como vacio IMPORTANTE XRA PRUEBAS
		
	VACIO:
		CLR			D0					* vaciamos D0
		MOVE.L		#$ffffffff,D0		* introducimos dato = buffer vacio
	
	L_FIN:
		MOVEM.L	(A7)+,A0-A4/D1-D3
		
		RTS		
		
**************************** FIN LEECAR **************************************************************	

**************************** ESCCAR **************************************************************
ESCCAR:		
		* En ESCCAR podemos reutilizar gran parte de
		MOVEM.L		A0-A4/D1-D3,-(A7)
		MOVE.L		#TAMANO_BUF,D2
		MOVE.L		D1,D3				* Como usamos D1 lo copiamos a otro registro y nos ahorramos reescribir codigo
		
		*Compruebo lo que vale buffer (D0)
		
		* PARA AREC (0)
		CLR			D1				*D1 a 0
		CMP.B 		D1,D0			*Hacemos a altura de byte porque sabemos que tanto D0 como D1 solo tienen info relevante en el primer byte
		BEQ			E_AREC
		
		* PARA BREC (1)
		ADD.B		#1,D1			*D1 a 1
		CMP.B 		D1,D0 
		BEQ			E_BREC
		
		* PARA ASND (2)
		ADD.B		#1,D1			*D1 a 2
		CMP.B 		D1,D0 
		BEQ			E_ASND
		
		* PARA BSND (3)
		ADD.B		#1,D1			*D1 a 3
		CMP.B 		D1,D0 
		BEQ			E_BSND
		
		* Si no salta ningun BEQ, la subrutina no deberia hacer nada, solo saltar al fin
		JMP			E_FIN		
		
		
		*CARGA DE PUNTEROS BUFFER		
		
	E_AREC:		
		MOVE.L		AR_LEER,A1			* cargo LEER(A1), ESCRIBIR(A2) y FIN(A3) y FLAG
		MOVE.L		AR_ESCRIBIR,A2			
		MOVE.L		AR_FIN,A3
		MOVE.L 		AR_FLG,A0
		JMP E_AFTER_SEL
			
	E_BREC:		
		MOVE.L		BR_LEER,A1			* cargo LEER(A1), ESCRIBIR(A2) y FIN(A3)
		MOVE.L		BR_ESCRIBIR,A2			
		MOVE.L		BR_FIN,A3
		MOVE.L		BR_FLG,A0
		JMP E_AFTER_SEL		
					
	E_ASND:		
		MOVE.L		AS_LEER,A1			* cargo LEER(A1), ESCRIBIR(A2) y FIN(A3)
		MOVE.L		AS_ESCRIBIR,A2
		MOVE.L		AS_FIN,A3
		MOVE.L		AS_FLG,A0
		JMP E_AFTER_SEL	

	E_BSND:
       	MOVE.L      BS_LEER,A1            * cargo LEER(A1), ESCRIBIR(A2) y FIN(A3)
       	MOVE.L      BS_ESCRIBIR,A2
       	MOVE.L      BS_FIN,A3
		MOVE.L		BS_FLG,A0
       	JMP E_AFTER_SEL

	E_AFTER_SEL:	
		CMP			#0,A0				* si flag = 0 el buffer esta vacio
		BNE			E_PPAL
		CMP.B 		D1,D0 
		BEQ			E_BREC_FLG
		
		* PARA ASND (2)
		CMP.B 		D1,D0 
		BEQ			E_ASND_FLG
		CMP.B 		D1,D0 
		BEQ			E_BSND_FLG


	E_AREC_FLG:
		MOVE.B		#1,AR_FLG

	E_BREC_FLG:
		MOVE.B		#1,BR_FLG
		
	E_ASND_FLG:
		MOVE.B		#1,AS_FLG

	E_BSND_FLG:
		MOVE.B		#1,BS_FLG

		*PARTE PRINCIPAL	
		
	E_PPAL:
		CMP			A1,A2 
		BEQ			E_LLENO
		
		MOVE.L		A2,A4				* creamos LEER aux para comprobar los edge cases y lo avanzamos
		ADD.L		#1,A4
		
		CMP.L		A1,A3				* comprobamos si estamos en el final del buffer
		BNE			WRITE				* si no, saltamos a actualizar el puntero
		SUB.L		D2,A4				* si lo estamos, aux-tamano buffer para ponerlo al ESCRIBIRcio
		
	WRITE:
		CMP.L		A2,A1				* compruebo si el buffer esta lleno (Escritura + 1 == lectura)
		BEQ			E_LLENO				* Salto a E_LLENO
		MOVE.L 		D3,(A2)				* introduzco el caracter dentro del buffer (D3 porque lo hemos copiado)
		CLR 		D0					* Pongo D0 a 0
		
		
	*ACTUALIZACIÓN DE PUNTEROS:FIN INITparo si D3 es igual a 0 
		BNE			LEER_1				* si no es igual pasamos a la siguinete comprobacion 
		MOVE.L		A4,AR_ESCRIBIR			* A4 recibe el valor de AR_ESCRIBIR
		BRA 		E_FIN				* no se necesitan mas comprobaciones, terminamos

	LEER_1:
		CMP.B		#1,D1				* para evitar repetir comentarios, solo se explica 
		BNE			LEER_2				* el procedimiento de ESCRIBIRcializacion del primer buffer
		MOVE.L		A4,BR_ESCRIBIR
		BRA			E_FIN
		
	LEER_2:
		CMP.B		#2,D1
		BNE			LEER_3
		MOVE.L		A4,AS_ESCRIBIR
		BRA			E_FIN		
	
	LEER_3:	
		CMP.B		#3,D1				* si es distinto de 3, no hacemos nada y terminamos
		BNE			E_FIN
		MOVE.L		A4,BS_ESCRIBIR			* si es igual a 3, A4 recibe el valor de BS_ESCRIBIR y terminamos.
		BRA			E_FIN

	E_LLENO:
		MOVE.L		#$ffffffff,D0		* introducimos dato = buffer vacio

	E_FIN:
		MOVEM.L	(A7)+,A0-A4/D1-D3
		RTS
	***ARREGLAR***
**************************** FIN ESCCAR ***********************************************************		

********************************** SCAN ***********************************************************
SCAN:
		LINK		A6,#-36
		MOVEM.L 	A0-A4/D1-D4,-(A7)
		
	* LIMPIO D1, D2, D3
		
		CLR			D1					* Limpio D1 para descriptor			
		CLR			D2					* Limpio D2 para tamano
		MOVE.W 		D2,-40(A6)			* D2 a pila
		CLR			D3					* Contador a 0 
		CLR			D4					* Limpio D4
		
		MOVE.W		8(A6),A1			* Buffer en A1 (marco de pila + buffer)
		MOVE.W		12(A6),D1			* DescriptorMOVE.B		(A1)+,D5			* Avanzo el buffer y guardo el dato en D5 a D1(marco de pila + descriptor + buffer)
		MOVE.W		14(A6),D2			* Tamano a D2 (marco de pila + buffer + descriptor + tamano )
	
	* COMPARACIONES PARA SABER SI ES A O B Y TAMAÑO
		CMP.W		#0,D2				* Comparo si tamaño <= 0
		BLE			SC_FIN
		
		CMP.W		#0,D1				* Si es 0 escritura es en A
		BEQ			A_SCAN
		
		CMP.W		#1,D1				* Si es 1 escritura es en B
		BEQ			B_SCAN
		
	ERROR_SC: 
		MOVE.L		#$ffffffff,D0		* D0 = -1
		JMP			SC_FIN
	
	A_SCAN:
		MOVE.L		#0,D0				* Es 2 por el ESCCAR q si recibe 2 se va a buffer interno de transaminsion
		JMP			BUCLE_S
	B_SCAN:
		MOVE.L		#1,D0
		JMP			BUCLE_S
		
		JMP 		ERROR_SC				* Por si el descriptor esta mal
	*BUCLE DE SCAN:
	BUCLE_S:
		MOVE.W 		-40(A6),D2			* Saco D2 de pila			
		CMP.L		D3,D2				* Si contador == tamano, hemos terminado
		BEQ			SC_FIN
		 
		MOVE.B		(A1),D5			* Avanzo el buffer y guardo el dato en D5
		BSR			LEECAR
		ADD.L 		#1,A1			* INCREMENTO DE A1 
		
		MOVE.L 		#$ffffffff,D6
		CMP.L		D6,D0 				*Esccar dice q el buffer esta lleno, hemos acabado		
		BEQ 		SC_FIN
		ADD.L		#1,D3				* Contador + 1
		JMP			BUCLE_S
			
	SC_FIN:
		MOVE.L 		D3,D0
		MOVEM.L	(A7)+,A0-A4/D1-D4  
		UNLK		A6	
		RTS  
****************************** FIN SCAN ***********************************************************

********************************** PRINT **********************************************************
PRINT:
		LINK		A6,#-36
		MOVEM.L 	A0-A4/D1-D4,-(A7)
		
	* LIMPIO D1, D2, D3
		
		CLR			D1					* Limpio D1 para descriptor			
		CLR			D2					* Limpio D2 para tamano
		MOVE.W 		D2,-44(A6)			* D2 a pila
		CLR			D3					* Contador a 0 
		CLR			D4					* Limpio D4
		MOVE.B		(A1)+,D5			* Avanzo el buffer y guardo el dato en D5 pila
		MOVE.W		14(A6),D2			* Tamano a D2 (marco de pila + buffer + descriptor + tamano )
	
	* COMPARACIONES PARA SABER SI ES A O B
		
		CMP.W		#0,D1				* Si es 0 escritura es en A
		BEQ			A_PRINT
		
		CMP.W		#1,D1				* Si es 1 escritura es en B
		BEQ			B_PRINT
		
	ERROR_PR: 
		MOVE.L		#$ffffffff,D0		* D0 = -1
		JMP			P_TER
	
	A_PRINT:
		MOVE.L		#2,D0				* Es 2 por el ESCCAR q si recibe 2 se va a buffer interno de transaminsion
		BRA			BUCLE_P
	B_PRINT:
		MOVE.L		#3,D0
		JMP			BUCLE_P
		
	*BUCLE DE PRINT:
	BUCLE_P:
		MOVE.W 		-44(A6),D2		* D2 a pila
		CMP.L		D3,D2				* Si tamano == contador, hemos terminado
		BEQ			P_FIN
		 
		MOVE.B		(A1),D5			* Avanzo el buffer y guardo el dato en D5
		BSR			ESCCAR
		ADD.L		#1,A1
		
		MOVE.L 		#$ffffffff,D6
		CMP.L		D6,D0 		*Esccar dice q el buffer esta lleno, hemos acabado		
		BEQ 		P_TER
		ADD.L		#1,D3				* Contador + 1
		JMP			BUCLE_P
		
	P_TER:
		CMP.L		#0,D3
		BEQ			P_FIN
		*MOVE.B		CPY_IMR,D2			** MIRAR SI SOBRA O SE PUEDE QUITAR

		CLR 		D1					* Limpio D1
		MOVE.W 		-40(A6),D1			* Saco D1 de la pila

		* COMPROBACIONES
		CMP.W		#0,D1				* Compruebo si estamos en A
		BEQ			A_SET
		
		CMP.W		#1,D1				* Compruebo si estamos en B
		BEQ			B_SET
	
	A_SET:								* 
		BSET		#0,CPY_IMR  		
		JMP			FIN_SET

	B_SET:								*
		BSET		#4,CPY_IMR  

	FIN_SET:
		MOVE.B		CPY_IMR,IMR
			
	P_FIN:
		MOVE.L 		D3,D0
		MOVEM.L		(A7)+,A0-A4/D1-D4  
		UNLK		A6	MOVE.B		(A1)+,D5			* Avanzo el buffer y guardo el dato en D5***********************************
RTI:
		MOVEM.L		D0-D6,-(A7)		* Guardo los registros que vamos a usar en pila
		MOVE.L 		#$ffffffff,D4
		
	COMP_PREV:
		MOVE.B		CPY_IMR,D2		* Guardo en D2 el valor de la copia del IMR (mascara)
		MOVE.B 		ISR,D3			* Guardo en D3 el valor del ISR (Estado de Interrupción)
		AND.B 		D3,D2			* Aplico la mascara

		BTST		#0,D2
		BNE			RTI_TRANS_A		**TRANSMISION -> LEECAR

		BTST		#1,D2
		BNE			RTI_RECEP_A		** RECEPCION -> ESCCAR

		BTST		#4,D2
		BNE			RTI_TR_B		**TRANSMISION -> LEECAR
		
		BTST		#5,D2
		BNE			RTI_RC_B		** RECEPCION -> ESCCAR

	FIN_RTI:
		MOVEM.L		(A7)+,D0-D6		* Restauro los registros
		RTS
	
	RTI_TRANS_A:
		CMP.B   #0,FLAG_TBA      	* Se transmite caracter
        BEQ     RTI_L_A
        CLR.B   FLAG_TBA          	* Se pone el flag a normal
        MOVE.L  #A_PRINT,D0      	* Pone en D0 PRINT B
		CMP.L   #0,D0          		* Se inhiben interrupciones?
        BNE     COMP_PREV 
        BCLR    #0,CPY_IMR       	* AHORA inhibe interrupciones
        MOVE.B  CPY_IMR,IMR      	* Actualizoel IMR
        JMP     COMP_PREV
	RTI_L_A:
		MOVE.L  #A_PRINT,D0     	* Pone en D0 PRINT B
		BSR		LEECAR				* Llamamos a leecar
		MOVE.B	D0,FLAG_TBA			* mete el caracter 
		BNE     COMP_PREVMOVE.B		(A1)+,D5			* Avanzo el buffer y guardo el dato en D5
		
	RTI_RECEP_A:
		CLR			D0				* Pongo D0 a 0 -> ESCCAR uso buffer recepcion A
		CLR 		D1				* Pongo D1 a 0
		MOVE.B		RBA,D1			* Guardo los datos del buffer de recepcion de A en D1
		MOVE.L		#A_SCAN,D0
		BSR			ESCCAR			* LLamadita a ESCCAR
		CMP.L 		D4,D0			* Si D0 = -1 termino
		BEQ			FIN_RTI			
		JMP			COMP_PREV		* D0 != -1 a comparar otra vez

	RTI_TR_B:
		CMP.B   #0,FLAG_TBB      	* Se transmite caracter
        BEQ     RTI_L_B
        CLR.B   FLAG_TBB          	* Se pone el flag a normal
        MOVE.L  #B_PRINT,D0      	* Pone en D0 -> PRINT B
		CMP.L   #0,D0          		* Se inhiben interrupciones?
        BNE     COMP_PREV 
        BCLR    #0,CPY_IMR       	* AHIRA inhibe interrupciones
        MOVE.B  CPY_IMR,IMR      	* Actualizo el IMR
        JMP     COMP_PREV
	RTI_L_B:
		MOVE.L  #B_PRINT,D0     	* Pone en D0 PRINT B
		BSR		LEECAR				* Llamamos a leecar
		MOVE.B	D0,FLAG_TBB			* mete el caracter e
		BNE     COMP_PREV
		MOVE.B  #1,FLAG_TBB      	* Se activa el flag 
		JMP		COMP_PREV

	RTI_RC_B:
		MOVE.L		#1,D0			* Pongo D0 a 1 -> ESCCAR uso buffer recepcion B
		CLR 		D1				* Pongo D1 a 0
		MOVE.B		RBB,D1			* Guardo los datos del buffer de recepcion de B en D1
		MOVE.L		#B_SCAN,D0
		BSR			ESCCAR			* LLamadita a ESCCAR
		CMP.L 		D4,D0			* Si D0 = -1 termino
		BEQ			FIN_RTI			
		JMP			COMP_PREV		* D0 != -1 a comparar otra vez

****************************** FIN RTI ************************************************************

**************************** PROGRAMA PRINCIPAL ***************************************************

*Test LEECAR Y ESCCAR PARA LLENAR BUFFERS
INICIO:	BSR 		INIT
		CLR			D0
		CLR			D1
		ADD.L		#1,D1

	* Cargamos todos los buffers a maxima capacidad

	HASTADOSK:
		CMP			#2001,D1
		BSR 		ESCCAR
		ADD.L		#1,D1
		BNE			HASTADOSK

	E_SIG_BUFFER:
		CLR			D1
		ADD.L		#1,D1
		CMP 		#4,D0
		BEQ			VACIAR
		ADD.B		#1,D0
		BNE			HASTADOSK
	
	* Zona de prueba de leecar

	VACIAR:
		CLR 		D0
		CLR 		D1
		CLR			D2				* Copia auxilliar de D0
		ADD.L		#1,D1

	DOSKFUERA:
		CMP			#2001,D1
		BSR 		LEECAR
		CMP			D0,D1			* Anadida prueba extra para ver que desencola en orden por si acaso
		BNE			FIN_TST
		MOVE.L		D2,D0
		ADD.L		#1,D1
		BNE			DOSKFUERA

	L_SIG_BUFFER:
		CLR			D1
		ADD.L		#1,D1
		CMP 		#4,D0
		BEQ			FIN_TST	
		ADD.B		#1,D0
		MOVE.L		D0,D2
		BNE			DOSKFUERA	

	FIN_TST: 
		BREAK				
**************************** FIN PROGRAMA PRINCIPAL ******************************************		


** QUITAR EL + DE SCAN Y PRINT 
** DESPUES DEL BSR ADD.L 1 Y REG