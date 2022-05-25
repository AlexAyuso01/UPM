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

POPSR:				MACRO(reg)				; macro pop pero sin return del ultimo
					addu r30, r30, 4
					ENDMACRO
					
DBNZ:           	MACRO(reg,ETIQ)           ; macro DBNZ     
					sub reg,reg,1                 
					cmp r7,reg,0                 
					bb0 2,r7,ETIQ                 
					ENDMACRO		

CREAMARCO:          MACRO()
                    PUSH(r1)
                    PUSH(r31)
                    or r31, r30, r30       ; creamos el marco de pila
                    ENDMACRO

ROMPEMARCO:         MACRO()
                    or r30, r31, r31       ; destruimos el marco de pila 
                    POP(r31)              
                    POP(r1) 
                    ENDMACRO

buscaCar:           MACRO(c,ref,from,to)
                    PUSH(to)
                    PUSH(from)
                    PUSH(ref)
                    PUSH(c)
                    bsr BuscaCar
                    POP(c)
                    POP(ref)
                    POP(from)
                    POP(to)
                    ENDMACRO

coincidenCad:       MACRO(cad1,cad2)
                    PUSH(cad2)
                    PUSH(cad1)
                    bsr CoincidenCad
                    POP(cad1)
                    POP(cad2)
                    ENDMACRO

PRUEBALongCad:      MACRO(CADENA)
                    CREAMARCO()
                    LEA(r30,PILA)
                    LEA(r20,CADENA)
                    PUSH(r20)
                    bsr LongCad
                    POP(r20)
                    ROMPEMARCO()
                    jmp(r1)
                    ENDMACRO

PRUEBABuscaCar:     MACRO(C,REF,FROM,TO)
                    CREAMARCO()
                    LEA(r30,PILA)
                    LEA(r20,C)
                    LEA(r21,REF)
                    LEA(r22,FROM)
                    LEA(r23,TO)
                    PUSH(r23)
                    PUSH(r22)
                    PUSH(r21)
                    PUSH(r20)
                    ld r20, r20, 0
                    PUSH(r20)
                    bsr BuscaCar
                    POP(r20)
                    POP(r21)
                    POP(r22)
                    POP(r23)
                    ROMPEMARCO()
                    jmp(r1)
                    ENDMACRO

PruebaCoincidenCad: MACRO(CADENA1,CADENA2)
                    CREAMARCO()
                    LEA(r30,PILA)
                    LEA(r20,CADENA1)
                    LEA(r21,CADENA2)
                    PUSH(r20)
                    PUSH(r21)
                    bsr CoincidenCad
                    POP(r21)
                    POP(r20)
                    ROMPEMARCO()
                    jmp(r1)
                    ENDMACRO

PruebaCheckSum:     MACRO(CADENA1)
                    CREAMARCO()
                    LEA(r30,PILA)
                    LEA(r20,CADENA1)
                    PUSH(r20)
                    bsr Checksum
                    POP(r20)
                    ROMPEMARCO()
                    jmp(r1)
                    ENDMACRO

PruebaComrpimir:	MACRO(TEXTO,COMPRDO)
					CREAMARCO()
					LEA(r30,PILA)
					LEA(r20,TEXTO)
					LEA(r21,COMPRDO)
					PUSH(r21)
					PUSH(r20)
					bsr Comprime
					POP(r20)
					POP(r21)
					ROMPEMARCO()
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
        RESULTADO:
        data    0x86888A8C
        RESULTADO2:
        data    0x4142888A

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
Cadena6:
data "ABCDEFGHIJ\0"
Cadena7:
data "ABCDEF\0A"
Cadena8:
data "0123456789\0"

Cadena9:
data 0x01010101
data 0x02020202
data 0x03030303
data 0x00000000

Cadena10:
data 0xF1F1F1F1
data 0xF2F2F2F2
data 0xF3F3F3F3
data 0xF4F4F4F4
data 0x01010101
data 0x02020202
data 0x03030303
data 0x04040404
data 0xFFFFFFFF
data 0x03030303
data 0xDDDDDDDD
data 0xCCCCCCCC
data 0xFF00CCDD

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
                    bb0 eq, r17, FinMALBC
                    POP(r4)
                    addu r4, r4, 1
                    PUSH(r4)
PRUEBA2:            ;Prueba 2
                    PRUEBABuscaCar(Car1,Cadena2,1,3)
                    cmp r17, r29, 0
                    bb0 eq, r17, FinMALBC
                    POP(r4)
                    addu r4, r4, 1
                    PUSH(r4)
                    ;Prueba 3
                    PRUEBABuscaCar(Car1,Cadena2,0,3)
                    cmp r17, r29, 1
                    bb0 eq, r17, FinMALBC
                    POP(r4)
                    addu r4, r4, 1
                    PUSH(r4)
                    ;Prueba 4
                    PRUEBABuscaCar(Car4,Cadena3,3,9)
                    cmp r17, r29, 4
                    bb0 eq, r17, FinMALBC
                    POP(r4)
                    addu r4, r4, 1
                    PUSH(r4)
FinBIENBC:          LEA(r29,BIEN)
                    ld r29, r29, 0
                    stop
FinMALBC:           LEA(r29,MAL)
                    ld r29, r29, 0
                    stop
                    
;---------------------------------------------------------------
TESTERLCoincidenCad:LEA(r30,MEGAPILA)
                    or  r4, r0, r0
                    addu r4, r4, 1
                    PUSH(r4)
                    PruebaCoincidenCad(Cadena1,Cadena1)
                    cmp r17, r29, 6
                    bb0 eq, r17, FinMALCC
                    POP(r4)
                    addu r4, r4, 1
                    PUSH(r4)
                    PruebaCoincidenCad(Cadena1,Cadena2)
                    cmp r17, r29, 0
                    bb0 eq, r17, FinMALCC
                    POP(r4)
                    addu r4, r4, 1
                    PUSH(r4)
                    PruebaCoincidenCad(Cadena2,Cadena3)
                    cmp r17, r29, 3
                    bb0 eq, r17, FinMALCC
                    POP(r4)
                    addu r4, r4, 1
                    PUSH(r4)
                    PruebaCoincidenCad(Cadena1,Cadena4)
                    cmp r17, r29, 0
                    bb0 eq, r17, FinMALCC
FinBIENCC:          LEA(r29,BIEN)
                    ld r29, r29, 0
                    stop

FinMALCC:           LEA(r29,MAL)
                    ld r29, r29, 0
                    stop
;--------------------------------------------------------------
;Tester Checksum
TesterCheckSum:     LEA(r30,MEGAPILA)
                    or  r4, r0, r0
                    addu r4, r4, 1
                    PUSH(r4)
                    PruebaCheckSum(Cadena6)
                    LEA(r10, RESULTADO)
                    cmp r17, r29, r10
                    bb0 eq, r17, FinMALCS
                    POP(r4)
                    addu r4, r4, 1
                    PUSH(r4)
                    PruebaCheckSum(Cadena1)
                    LEA(r10,RESULTADO2)
                    cmp r17, r29, 0
                    bb0 eq, r17, FinMALCS
                    POP(r4)
FinBIENCS:          LEA(r29,BIEN)
                    ld r29, r29, 0
                    stop

FinMALCS:           LEA(r29,MAL)
                    ld r29, r29, 0
                    stop
;--------------------------------------------------------------
TesterComprime:     LEA(r30,MEGAPILA)
                    or  r4, r0, r0
                    addu r4, r4, 1
                    PUSH(r4)
                    PruebaComrpimir(Cadena8,0xD900)
                    LEA(r10, RESULTADO2)
                    cmp r17, r29, r10
                    bb0 eq, r17, FinMALCS
                    POP(r4)
                    addu r4, r4, 1
                    PUSH(r4)
                    PruebaComrpimir(Cadena7,0xD950)
                    LEA(r10,RESULTADO2)
                    cmp r17, r29, 0
                    bb0 eq, r17, FinMALCS
                    POP(r4)
FinBIENCm:          LEA(r29,BIEN)
                    ld r29, r29, 0
                    stop

FinMALCm:           LEA(r29,MAL)
                    ld r29, r29, 0
                    stop
;--------------------------------------------------------------

LongCad:            CREAMARCO()            ; creamos el marco de pila 
                    ld r20, r31, 8 
                    ld.bu r4, r20, 0       ; creamos un puntero y guardamos su contenido
                    or r5, r0, 0           ; inicializamos el contador a 0
Bucle_LC:           cmp r17, r4, 0x00
                    bb1 eq, r17, FinLC     ; miramos si el contenido del puntero es igual al caracter de fin de cadena (0x00)
                    addu r5, r5, 1
                    addu r20, r20, 1
                    ld.bu r4, r20, 0       ; recargamos el valor del puntero
                    br Bucle_LC
FinLC:              or r29, r5, r5         ; devolvemos la longitud de la cadena en r29
                    ROMPEMARCO()           ; destruimos el marco de pila 
                    jmp(r1)


;--------------------------------------------------------------
BuscaCar:           CREAMARCO()            ; creamos el marco de pila 
                    ld r20, r31, 8         ; caracter
                    ld r21, r31, 12        ; referencia
                    ld r22, r31, 16        ; from
                    ld r23, r31, 20        ; to
                    or r6, r0, 0           ; contador a 0   
                    addu r4, r21, r22      ; nos desplazamos al from con el puntero
                    addu r7, r21, r23      ; nos desplazamos al to con el puntero
                    addu r6, r22, r0       ; el contado toma el valor de from 
Buc_Busca:          ld.bu r5, r4, 0        ; cargo texto, Inicio bucle
                    cmp r17, r5, r20
                    bb1 eq, r17, FinBusc2
                    cmp r17, r4, r7        
                    bb1 eq, r17, FinBusc1
                    addu r4, r4, 1          
                    addu r6, r6, 1          
                    br Buc_Busca
FinBusc1:           or r29, r23, r23
                    br FinBC               
FinBusc2:           or r29, r6, r6
FinBC:              ROMPEMARCO()           ; destruimos el marco de pila
                    jmp(r1)           
                     

;--------------------------------------------------------------
CoincidenCad:       CREAMARCO()             ; creamos el marco de pila 
                    ld r20, r31, 8          ; puntero de cadena 1
                    ld r21, r31, 12         ; puntero de cadena 2
                    ld.bu r4, r20, 0        ; primer elemento de cadena 1
                    ld.bu r5, r21, 0        ; primer elemento de cadena 2
                    or r6, r0, 0            ; inicializo contador a 0
Bucle_CC:           cmp r17, r4, 0x00
                    bb1 eq, r17, FinCC
                    cmp r18, r5, 0x00
                    bb1 eq, r18, FinCC
                    cmp r19, r4, r5
                    bb0 eq, r19, FinCC 
                    addu r6, r6, 1          ; contador ++
                    addu r20, r20, 1        ; puntero cad1 ++
                    addu r21, r21, 1        ; puntero cad2 ++ 
                    ld.bu r4, r20, 0        ; siguiente elemento cad 1
                    ld.bu r5, r21, 0        ; siguiente elemento cad 2
                    br Bucle_CC
FinCC:              or r29, r6, r6          ; cargamos en r29 el numero de caracteres que coinciden 
                    ROMPEMARCO()            ; destruimos el marco de pila
                    jmp(r1)
;--------------------------------------------------------------
BuscaMax:           CREAMARCO()
                    subu r30, r30, 8        ; reservo 2 huecos 
                    ld r20, r31, 8          ; ref            8
                    ld r21, r31, 12         ; max			 12
                    ld r22, r31, 16         ; jj			 16
                    subu r4, r0, 1
                    st r4, r22, r0          ; guardo en jj -1 para empezar
                    or r4, r0, r0           ; ptr
                    or r5, r0, r0           ; L
                    ;necesidad de aux??
BucleBM:            cmp r17, r4, r21
                    bb1 ge, r17, FinBM
                    cmp r17, r5, 255
                    bb1 gt, r17, FinBM
                    st r4, r31, -4           ; guardo en MdP ptr y L
                    st r5, r31, -8
                    addu r11, r20, r21
                    PreBC:ld.bu r25, r11, r0         ; caracter en posicion max de cadena ref
                    buscaCar(r25,r20,r4,r21); buscaCar(ref[max],ref,ptr,max)
                    ld r20, r31, 8          ; restauro registros sucios
                    ld r21, r31, 12         ;
                    ld r22, r31, 16         ;
                    PostBC:ld r4, r31, -4
                    ld r5, r31, -8          ; saco de MdP ptr y L 
                    cmp r17, r21, r29        
                    bb1 eq, r17, FinBM
                    or r4, r29, r29
                    st r4, r31, -4           ; guardo en MdP ptr y L
                    st r5, r31, -8           
                    addu r11, r20, r4        ; cadena 1
                    PreCC:addu r12, r20, r21       ; cadena 2
                    coincidenCad(r11,r12)    ;
                    ld r20, r31, 8          ; restauro registros sucios
                    ld r21, r31, 12         ;
                    ld r22, r31, 16         ;
                    PostCC: ld r4, r31, -4
                    ld r5, r31, -8           ; saco de MdP ptr y L.
                    cmp r17, r29, 255
                    bb1 ge, r17, FinBMOvf   ; r29>=255?
                    cmp r17, r29, r5
                    bb0 gt, r17, RebucleBM   ; r29>L? actualizo L : p++ 
                    or r5, r29, r29
                    st r4, r22, r0          ;guardo en Mem(jj)<-ptr

RebucleBM:          addu r4, r4, 1          ;ptr++
                    br BucleBM


FinBMOvf:           bb1 eq, r17, 1
                    addu r29, r0, 255
                    st r4, r22, r0          ;guardo en Mem(jj)<-ptr TODO: CHEKEAR QUE NO SE PASE EL R4
                    br 2
FinBM:              or r29, r5, r5
                    addu r30, r30, 8       ; restauro reserva MdP
                    ROMPEMARCO()
                    jmp(r1)
;--------------------------------------------------------------
Checksum:           CREAMARCO()
                    subu r30, r30, 4        ; reservamos espacio para variables 
                    ld r20, r31, 8          ; r20 recibe la direccion del primer elemento del texto
                    PUSH(r20)
                    bsr LongCad
                    POP(r20)
					postLC:ld r4, r20, 0
                    st r0, r31, -4         	; Metemos en pila un hueco para guardar la suma
                    or r5, r29, r29          ; Guardamos en r5 el resultado de LongCad
                    or r6, r5, r5
Mul4:               divu r6, r6, 0x04		; 
					or r13, r6, r6			; numero de palabras enteras
                    mulu r6, r6, 0x04		;
                    subu r6, r5, r6			; numero de bytes antes del /0
					
					
					;HASTA AQUI TODO BIEN 
Suma_1:             cmp r17, r13, 0
                    bb1 eq, r17, PreSuma_2
					ld r14, r31, -4			  ; cargo 
                    addu r14, r14, r4         ; r7 <- r7 + m(r20)  
                    addu r20, r20, 4
                    ld r4, r20, 0  
					subu r13, r13, 1		  ; avanzo una palabra 
                    st r14, r31, -4
					br Suma_1
					
PreSuma_2:          cmp r17, r6, 0
					bb1 eq, r17, FinCS
Suma_2:				or r10, r0, 0
					or r9, r0, 0            ; contador para ver las palabras hasta 0x00
                    or r8, r0, 0            ; contador para ver desp dentro de palabra a 0x00
                    or r7, r0, 0            ; limpio r7 para hacer la suma 
					or r11, r6, r6			; parametro para hacer la suma y ver cuantos caracteres hay antes del /0
bc_suma_2:			ld.bu r7, r20, r8
					cmp r17, r11, 0			; miro si ya he sumado todas las palabras 
					bb1 eq, r17, Resul		; si?? => cargo la suma en el reistro correspondiente 
					mulu r9, r8, 8			; aplico el desplazamiento necesario
					mak r7, r7, r9			; 
					ld r9, r31, -4			; cargo la suma total de las palabras para la suma
					addu r9, r9, r7 		; le sumo el caracter correspondiente
					st r9, r31, -4			; guardo la suma en su lugar de memoria correspondiente
					addu r10, r10, r7 		; Guardo y avanzo punteros
					addu r8, r8, 1
					subu r11, r11, 1
					br bc_suma_2
					
Resul: 				ld r14, r31, -4         ; cargo el resultado de la suma total       
FinCS:              or r29, r14, r14		; lo devuelvo en r29
                    ROMPEMARCO()
                    jmp(r1)
;--------------------------------------------------------------					
Comprime:           CREAMARCO()
					
					ld r20, r31, 8			; Referencia a TEXTO							
					
					PUSH(r20)
					bsr LongCad				; Determino la longitud de TEXTO
					POP(r20)
					or r4, r29, r29			; Guardo en r4 L(TEXTO)
					
Ajuste:				divu r5, r4, 4			; Bucle para ajuste en exceso
					mulu r5, r5, 4
					cmp r17, r5, r29			; r5 >= r4??
					bb1 ge, r17, Res_mem
					addu r5, r4, 4
					addu r4, r4, 4
					br Ajuste				; El numero que nos va a decir el tamaño a reservar esta en r5
                    
					;RESERVO ESPACIO Y LO PONGO TODO ESE ESPACIO A 0
Res_mem:			subu r31, r31, r5		; Reservo espacio en pila para COMPRDO
					or r4, r0, 0
					or r6, r0, 0
Res_mem_bc:			cmp r17, r6, r5 		; pongo a 0 las palabras que sean(r5/4)
					bb1 eq, r17, Init
					st r0, r31, r4
					addu r4, r4, 4			; guardo en r4 el desplazamiento que vamos a aplicar en r31					
					addu r6, r6, 4			; r6 + 4 hasta que sea == r5
					br Res_mem_bc
					;INICIALIZO LAS VARIABLES 
Init:				ld r20, r30, 8
					or r22, r20, r20		; Puntero de TEXTO
					ld r21, r30, 12			; Referencia a COMPRDO
					or r23, r21, r21		; Puntero de COMPRDO
					or r6, r0, 1			; Numero de Byte
					or r7, r7, 7			; Numero de bit 
					or r8, r0, 0			; guardo el desplazamiento para cargar los caractereres
					or r9, r0, 0			; Registro para guardar L(subcadena)
					or r10, r0, 0			; Resgistro para guardar Dir(Ptr(Subcadena) == Dir(P) despues de llamar a buscaMax hacer ld de este registro en este registro para tener Dir(Dir(P)) == P 
					or r11, r0, 0			; Registro que va a guardar el caracter al que apunta r22
					or r12, r0, 0			; Registro para el mapa de bits
					or r13, r0, 0			; Registro que guarda el desplazamiento para cp en COMPRDO 
					or r14, r14, 1			; M = 1
					or r26, r0, 0			; Regsiros para el mapa de bits

Chars8xM:			cmp r17, r8, 8			; Miro si ya he copiado los 8 primeros caracteres
					bb1 eq, r17, bucleCMP
					ld r11, r22, 0			; Cargo los 4 primeros en r11
					st r11, r31, r8			; Los meto en pila
					addu r22, r22, 4		; Avanzo puntero de TEXTO
					addu r8, r8, 4			; Avanzo puntero de desplazamiento
					br Chars8xM

bucleCMP:			ld.bu r25, r22, 0
					cmp r17, r25, 0x00
					bb1 eq, r17, suma_total
					;Hago estos st para que despues de la llamada a busca max pueda recuperar sus valores previos a la llamada
				pre_BM:	
					subu r30, r30, 32
					sub r2, r30, r31
					sub r2, r2, r5
					st r4, r31, r2
					add r2, r2, 4
					st r5, r31, r2
					add r2, r2, 4
					st r6, r31, r2
					add r2, r2, 4
					st r7, r31, r2
					add r2, r2, 4
					st r11, r31, r2
					add r2, r2, 4
					st r21, r31, r2
					add r2, r2, 4
					st r22, r31, r2
					add r2, r2, 4
					st r23, r31, r2
					add r2, r2, 4	
					sub r30, r30, 12
				fin_st:
					PUSH(r20)
					PUSH(r8)
					PUSH(r10)
					bsr BuscaMax
					POP(r10)
					POP(r8)
					POP(r20)
				fin_busc:
					sub	r2, r2, 4	
					ld r23, r31, r2
					sub r2, r2, 4
					ld r22, r31, r2
					sub r2, r2, 4
					ld r21, r31, r2
					sub r2, r2, 4
					ld r11, r31, r2
					sub r2, r2, 4
					ld r7, r31, r2
					sub r2, r2, 4
					ld r6, r31, r2
					sub r2, r2, 4
					ld r5, r31, r2
					sub r2, r2, 4
					ld r4, r31, r2
					or r2, r0, 0
					addu r30, r30, 44
				fin_BM:		
					or r9, r29, r29			; L
					or r10, r8, r8			; P = Desplazamiento o posicion de la cadena dentro del texto 		
					cmp r17, r9, 4
					bb0 lt, r17, bc_no 
					ld.bu r11, r22, 0
					st.b r11, r31, r8 
					addu r8, r8, 1
					addu r22, r22, 1
					;HASTA AQUI BIEN :) 
					br suma_bit_0 
Conti_si:			sub r7, r7, 1
					cmp r18, r7, -1
					or r27, r0, 1
					bb1 eq, r18, Reinicio_bit
fin_bc_si:			br bucleCMP

bc_no:				st.b r10, r31, r8
					addu r8, r8, 2
					st r9, r31, r8
					addu r8, r8, 1
					addu r22, r22, r9
					br suma_bit_1
Conti_no:			sub r7, r7, 1
					cmp r18, r4, -1
					or r27, r0, 0
					bb1 eq, r18, Reinicio_bit
fin_bc_no:			br bucleCMP
					
carga_lmb:			cmp r17, r7, 7
					bb1 ge, r17, Copia_cab
					mulu r15, r6, 4
					addu r15, r15, r9			; Guardo en r15 el desplazamiento desde inicio de pila a el ultimo byte del mapa de bits 
					ld.bu r12, r31, r15 		; cargo en r12 los dos primeros bits 
					st.b r12, r31, r8			; lo meto en pila 
					addu r8, r8, 2
					addu r15, r15, 2
					addu r7, r7, 2
					br carga_lmb
					
Copia_cab:			st.b r4, r21, 0
					addu r13, r13, 2
					st.b r14, r21, r13
					addu r13, r13, 1
					;DETERMINO EL TAMAÑO DE MAPA DE BITS PARA LA CABECERA (TAM(MAPA_BITS) + 5 )
					addu r6, r6, 5
					st.b r6, r21, r13
					addu r13, r13, 2
Intro_mapabt:		ld r15, r31, 0
					addu r15, r15, r5
					addu r15, r15, r8
					addu r23, r23, 5
					or r25, r6, r6
salto:				cmp r17, r25, 5
					bb1 eq, r17, copy_txt_cdo
					ld r16, r15, 0
					st r16, r23, 0
					addu r15, r15, 4
					addu r23, r23, 4
					subu r25, r25, 1
					br salto
					or r24, r21, r21
					or r26, r8, r8
copy_txt_cdo:		cmp r17, r26, 0
					bb1 le, r17, suma_total
					ld r16, r24, 0
					st r16, r23, 0
					addu r23, r23, 4
					subu r26, r26, 4
					br copy_txt_cdo
suma_total: 		or r29, r0, 0
					addu r29, r6, r8
					ROMPEMARCO()
					jmp(r1)
					
suma_bit_0: 		addu r12, r12, 0x00000000
					br Conti_si
					
suma_bit_1:			or r24, r7, r7
					or r28, r0, 1
					cmp r17, r7, 7
					bb0 eq, r17, bit_6
	carga_7:		cmp r18, r24, 0
					bb1 eq, r18, suma_7
					mulu r24, r24, 16
					subu r24, r24, 1
					br carga_7
	suma_7:			addu r12, r12, r28
					br Conti_no
	bit_6:			cmp r17, r7, 6
					bb0 eq, r17, bit_5
	carga_6:		cmp r18, r24, 0
					bb1 eq, r18, suma_6
					mulu r24, r24, 16
					subu r24, r24, 1
					br carga_6
	suma_6:			addu r12, r12, r28
					br Conti_no
	bit_5:			cmp r17, r7, 5
					bb0 eq, r17, bit_4
	carga_5:		cmp r18, r24, 0
					bb1 eq, r18, suma_5
					mulu r24, r24, 16
					subu r24, r24, 1
					br carga_5
	suma_5:			addu r12, r12, r28
					br Conti_no
	bit_4:			cmp r17, r7, 4
					bb0 eq, r17, bit_3
	carga_4:		cmp r18, r24, 0
					bb1 eq, r18, suma_4
					mulu r24, r24, 16
					subu r24, r24, 1
					br carga_4
	suma_4:			addu r12, r12, r28
					br Conti_no
	bit_3:			cmp r17, r7, 3
					bb0 eq, r17, bit_2
					addu r12, r12, 4096
					br Conti_no
	bit_2:			cmp r17, r7, 2
					bb0 eq, r17, bit_1
					addu r12, r12, 256
					sub r7, r7, 1
					br Conti_no
	bit_1:			cmp r17, r7, 1
					bb0 eq, r17, bit_0
					addu r12, r12, 16
					br Conti_no
	bit_0:			cmp r17, r7, 0
					bb0 eq, r17, finbit
					addu r12, r12, 1
	finbit:			br Conti_no
Reinicio_bit:		or r7, r0, 7
					addu r6, r6, 1
					cmp r17, r27, 0
					bb1 eq, r17, fin_bc_no
					cmp r17, r27, 1
					bb0 eq, r17, fin_bc_si
					 
;--------------------------------------------------------------
Descomprime:		CREAMARCO()
					ROMPEMARCO()
					jmp(r1)
;--------------------------------------------------------------
Verifica:           CREAMARCO()
                    ROMPEMARCO()
                    jmp(r1)



