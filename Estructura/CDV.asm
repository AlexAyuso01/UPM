;||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
;||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
;|||||||||||/54209205E  Calvo Aguiar, Hernán \||||/ 05863960Z Ayuso Expósito, Alejandro \||||||||||
;||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
;||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
;
;--------------------------------------------------------------
;	r1: registro que guarda la direccion de retorno para que se pueda volver al anterior Contador de Programa(PC)
;	r2 & r3: Estos registros estan reservados y solo se deberian usar para MACROs
;	r4 - r10: Registros para variables  
;	r11 - r16: Registros para operaciones aritmeticas
;	r17,r18,r19: Registros para comparaciones logicas
;	r20 - r24: Resevado para argumentos pasados a una subrutina
;	r25 - r28: Registros auxiliares que no tienen un proposito concreto
;	r29: registro que almacena el valor de retorno de una subrutina 
;	r30 y r31: Regsitros reservados para operaciones con el Puntero de Pila 

;--------------------------------------------------------------

LEA:                MACRO(reg,ETIQ)        ; macro LEA
                    or reg,r0,low(ETIQ)
                    or.u reg,reg,high(ETIQ)
                    ENDMACRO

LOAD:               MACRO(reg,ETIQ)        ; macro LOAD
                    LEA (reg,ETIQ)
                    ld reg,reg,0
                    ENDMACRO

PUSH:               MACRO(reg)             ; macro PUSH
                    subu r30,r30,4
                    st reg,r30,r0
                    ENDMACRO

POP:                MACRO(reg)             ; macro POP
                    ld reg,r30,r0
                    addu r30,r30,4
                    ENDMACRO

POPSR:		    MACRO(reg)				; macro pop pero sin return del ultimo
		    addu r30, r30, 4
		    ENDMACRO
					
DBNZ:               MACRO(reg,ETIQ)           ; macro DBNZ     
                    sub reg,reg,1                 
		    cmp r7,reg,0                 
		    bb0 2,r7,ETIQ                 
		    ENDMACRO		

MARCOPUSH:          MACRO()
                    PUSH(r1)
                    PUSH(r31)
                    or r31, r30, r30       ; creamos el marco de pila
                    ENDMACRO

MARCOPOP:          MACRO()
                    or r30, r31, r31       ; destruimos el marco de pila 
                    POP(r31)              
                    POP(r1) 
                    ENDMACRO

PRUEBALongCad:      MACRO(CADENA)
                    MARCOPUSH()
                    LEA(r30,PILA)
                    LEA(r20,CADENA)
                    PUSH(r20)
                    bsr LongCad
                    POP(r20)
                    MARCOPOP()
                    jmp(r1)
                    ENDMACRO

PRUEBABuscaCar:     MACRO(C,REF,FROM,TO)
                    MARCOPUSH()
                    LEA(r30,PILA)
                    LEA(r20,C)
                    LEA(r21,REF)
                    LEA(r22,FROM)
                    LEA(r23,TO)
                    PUSH(r23)
                    PUSH(r22)
                    PUSH(r21)
                    PUSH(r20)
                    bsr LongCad
                    POP(r20)
                    POP(r21)
                    POP(r22)
                    POP(r23)
                    MARCOPOP()
                    jmp(r1)
                    ENDMACRO

PruebaCoincidenCad: MACRO(CADENA1,CADENA2)
                    MARCOPUSH()
                    LEA(r30,PILA)
                    LEA(r20,CADENA1)
                    LEA(r21,CADENA2)
                    PUSH(r20)
                    PUSH(r21)
                    bsr CoincidenCad
                    POP(r21)
                    POP(r20)
                    MARCOPOP()
                    jmp(r1)
                    ENDMACRO


;--------------------------------------------------------------
		org 0
		nF: 	data	0x00 
		org 0x0000F000
		PILA:	data	0		
		org 50000
                MEGAPILA:
                data	0		
		org 40000
;--------------------------------------------------------------
;SETS DE CADENAS DE PRUEBA
org 55000
Cadena1: 
data "Prueba\0"
Cadena2: 
data "Cerveza\0"
Cadena3: 
data "Cervatillo\0"
Cadena4: 
data "\0"
Cadena5:
data "eeeeee\0"

Car1:
data "C"
Car2:
data "e"
Car3:
data "z"
Car4:
data "l"

BIEN: data 0x69696969
MAL:  data 0xFFFFFFFF
;--------------------------------------------------------------
;			INICIO TESTERS
;--------------------------------------------------------------
;TESTER LongCad                                  
TESTERLongCad:      LEA(r30,MEGAPILA)
                    or  r4, r0, r0
                    addu r4, r4, 1
                    PUSH(r4)
                    PRUEBALongCad(Cadena1)
                    cmp r17, r29, 6
                    bb0 eq, r17, FinMAL
                    POP(r4)
                    addu r4, r4, 1
                    PUSH(r4)
                    PRUEBALongCad(Cadena2)
                    cmp r17, r29, 7
                    bb0 eq, r17, FinMAL
                    POP(r4)
                    addu r4, r4, 1
                    PUSH(r4)
                    PRUEBALongCad(Cadena3)
                    cmp r17, r29, 10
                    bb0 eq, r17, FinMAL
                    POP(r4)
                    addu r4, r4, 1
                    PUSH(r4)
                    PRUEBALongCad(Cadena4)
                    cmp r17, r29, 0
                    bb0 eq, r17, FinMAL
FinBIEN:            LEA(r29,BIEN)
                    ld r29, r29, 0
                    stop
FinMAL:             LEA(r29,MAL)
                    ld r29, r29, 0
                    stop     


;--------------------------------------------------------------

;PRUEBA 1: dos cadenas iguales


TESTERBuscaCar:     LEA(r30,MEGAPILA)
                    or  r4, r0, r0
                    addu r4, r4, 1
                    PUSH(r4)
                    ;Prueba 1
                    PRUEBABuscaCar(Car1,Cadena1,0,5)
                    cmp r17, r29, 0
                    bb0 eq, r17, FinMAL
                    POP(r4)
                    addu r4, r4, 1
                    PUSH(r4)
                    addu r4, r4, 1
                    PUSH(r4)
                    ;Prueba 2
                    PRUEBABuscaCar(Car1,Cadena2,1,3)
                    cmp r17, r29, 0
                    bb0 eq, r17, FinMAL
                    POP(r4)
                    addu r4, r4, 1
                    PUSH(r4)
                    ;Prueba 3
                    PRUEBABuscaCar(Car1,Cadena2,0,3)
                    cmp r17, r29, 1
                    bb0 eq, r17, FinMAL
                    POP(r4)
                    addu r4, r4, 1
                    PUSH(r4)
                    ;Prueba 4
                     PRUEBABuscaCar(Car4,Cadena3,3,9)
                    cmp r17, r29, 4
                    bb0 eq, r17, FinMAL
                    POP(r4)
                    addu r4, r4, 1
                    PUSH(r4)
FinBIEN:            LEA(r29,BIEN)
                    ld r29, r29, 0
                    stop
FinMAL:             LEA(r29,MAL)
                    ld r29, r29, 0
                    stop
                    
;---------------------------------------------------------------
TESTERLCoincidenCad:LEA(r30,MEGAPILA)
                    or  r4, r0, r0
                    addu r4, r4, 1
                    PUSH(r4)
                    PruebaCoincidenCad(Cadena1,Cadena1)
                    cmp r17, r29, 6
                    bb0 eq, r17, FinMAL
                    POP(r4)
                    addu r4, r4, 1
                    PUSH(r4)
                    PruebaCoincidenCad(Cadena1,Cadena2)
                    cmp r17, r29, 0
                    bb0 eq, r17, FinMAL
                    POP(r4)
                    addu r4, r4, 1
                    PUSH(r4)
                    PruebaCoincidenCad(Cadena2,Cadena3)
                    cmp r17, r29, 3
                    bb0 eq, r17, FinMAL
                    POP(r4)
                    addu r4, r4, 1
                    PUSH(r4)
                    PruebaCoincidenCad(Cadena1,Cadena4)
                    cmp r17, r29, 0
                    bb0 eq, r17, FinMAL
FinBIEN:            LEA(r29,BIEN)
                    ld r29, r29, 0
                    stop

FinMAL:             LEA(r29,MAL)
                    ld r29, r29, 0
                    stop
;---------------------------------------------------------------
;			INICIO SUBRUTINAS 
;---------------------------------------------------------------
LongCad:            MARCOPUSH()       ; creamos el marco de pila 
                    ld r20, r31, 8 
                    ld.bu r4, r20, 0          ; creamos un puntero y guardamos su contenido
                    or r5, r0, 0           ; inicializamos el contador a 0
Bucle_LC:           cmp r17, r4, 0x00
                    bb1 eq, r17, FinLC     ; miramos si el contenido del puntero es igual al caracter de fin de cadena (0x00)
                    addu r5, r5, 1
                    addu r20, r20, 1
                    ld.bu r4, r20, 0          ; recargamos el valor del puntero
                    br Bucle_LC
FinLC:              or r29, r5, r5         ; devolvemos la longitud de la cadena en r29
                    MARCOPOP()      ; destruimos el marco de pila 
                    jmp(r1)


;--------------------------------------------------------------
BuscaCar:           MARCOPUSH()               ; creamos el marco de pila 
                    ld r20, r31, 8         ; caracter
                    ld r21, r31, 12        ; referencia
                    ld r22, r31, 16        ; from
                    ld r23, r31, 20        ; to
                    or r6, r0, 0           ; contador a 0
                    ld r4, r21, 0       ; puntero de texto
                    addu r4, r22, r0       ; nos desplazamos al from con el puntero
                    addu r6, r22, r0       ; el contado toma el valor de from 
Buc_Busca:          ld.bu r5, r4, 0           ; texto, Inicio bucle
                    cmp r17, r5, r20
                    bb1 eq, r17, FinBusc2
                    cmp r17, r4, r23        
                    bb1 eq, r17, FinBusc1
                    addu r4, r4, 1          
                    addu r6, r6, 1          
                    br Buc_Busca
FinBusc1:           or r29, r23, r23
                    br FinBC                  ; un poco improvisado, ahorraria etiqueta fin?
FinBusc2:           or r29, r6, r6
FinBC:              MARCOPOP()               ; destruimos el marco de pila
                    jmp(r1)           
                     

;--------------------------------------------------------------
CoincidenCad:       MARCOPUSH()         ; creamos el marco de pila 
                    ld r20, r31, 8         ; puntero de cadena 1
                    ld r21, r31, 12        ; puntero de cadena 2
                    ld.bu r4, r20, 0          ; primer elemento de cadena 1
                    ld.bu r5, r21, 0          ; primer elemento de cadena 2
                    or r6, r0, 0           ; inicializo contador a 0
Bucle_CC:           cmp r17, r4, 0x00
                    bb1 eq, r17, FinCC
                    cmp r18, r5, 0x00
                    bb1 eq, r18, FinCC
                    cmp r19, r4, r5
                    bb0 eq, r19, FinCC 
                    addu r6, r6, 1         ; contador ++
                    addu r20, r20, 1       ; puntero cad1 ++
                    addu r21, r21, 1       ; puntero cad2 ++ 
                    ld.bu r4, r20, 0       ; siguiente elemento cad 1
                    ld.bu r5, r21, 0       ; siguiente elemento cad 2
                    br Bucle_CC
FinCC:              or r29, r6, r6         ; cargamos en r29 el numero de caracteres que coinciden 
                    MARCOPOP()              ; destruimos el marco de pila
                    jmp(r1)
;--------------------------------------------------------------



