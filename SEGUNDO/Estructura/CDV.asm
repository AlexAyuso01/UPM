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
                    POPSR()
                    POPSR()
                    POPSR()
                    POPSR()
                    ENDMACRO

coincidenCad:       MACRO(cad1,cad2)
                    PUSH(cad2)
                    PUSH(cad1)
                    bsr CoincidenCad
                    POPSR()
                    POPSR()
                    ENDMACRO


org 0
nF: 	data	0x00 
org 0x0000F000
PILA:	data	0		
org 50000
textoA_Comprime: data "He comprobado la longitud de la cadena y es correcta. He comprobado mediante comprime y descomprime por separado si funciona correctamente y funciona bien. Al llamar a verifica comprime y descomprime la cadena sin ningún problema, realizando los checksum de la cadena original y después de ser comprimida y descomprimida y son iguales, pues no tienen en cuenta el ABCDEFG del final.\0"
textoB_Comprime: data "0123456789\0"
textoC_Comprime: data "tres tristes tigres comen trigo en un trigal, el primer tigre que...\0"
textoD_Comprime: data "abcdefghijklmnopqrst\0"
Comprime_Prueba:	
			LEA (r30,PILA)
			LEA (r11, textoA_Comprime)	
			addu r12, r0, 0x4F0
			PUSH(r12)
			PUSH(r11)
			bsr Comprime  
			POP(r11)
			POP(r12)
			stop
Verifica_Prueba:	
			LEA (r30,PILA)
			LEA (r11, textoA_Comprime)	
			addu r12, r0, 1000
			addu r13, r0, 2000
			PUSH(r13)
			PUSH(r12)
			PUSH(r11)
			bsr Verifica  
			POP(r11)
			POP(r12)
			POP(r13)
			stop
;Datos para descomprime
;CMPR: data  0x0601015E, 0x4141A000, 0x41414141, 0x00004141, 0x00C85AC0, 0xAB000095
CMPR: data 0x0b010044, 0x10102400, 0x74004000, 0x20736572
data 0x73697274, 0x04000274, 0x00016769, 0x6d6f6304
data 0x00046e65, 0x206f6704, 0x75206e65, 0x61060018
data 0x65202c6c, 0x7270206c, 0x72656d69, 0x2006000c
data 0x2e657571, 0x00002e2e

Descomprime_Prueba:	
			LEA (r30,PILA)
			LEA (r11, CMPR)	
			or r12, r0, r0
			PUSH(r12)
			PUSH(r11)
			bsr Descomprime  
			POP(r11)
			POP(r12)
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
; r10 = jj para buscamax
; r20 = texto 
; r8 =  contrador de caracteres escritos
; r3 = tamanio del texto (sin comprimir)
; 

Comprime:             CREAMARCO()
                    subu r30, r30, 20
                    ld r20, r31, 8          ;hca puntero de texto
                    or r22, r20, r20        ;hca copia de Puntero de TEXTO
                    ld r21, r31, 12            ; Referencia a COMPRDO
                    or r23, r21, r21        ; Puntero de COMPRDO
                    or r6, r0, 0            ; Numero de Byte -----
                    st r6, r31, -16
                    or r7, r0, 7            ; Numero de bit -----
                    st r7, r31, -8
                    or r8, r0, 0            ; guardo el desplazamiento para cargar los caractereres
                    or r28, r0, 0           ; puntero/desplazamiento extraccion
                    or r9, r0, 0            ; Registro para guardar L(subcadena)
                    or r10, r0, 0            ; Resgistro para guardar Dir(Ptr(Subcadena) == Dir(P) despues de llamar a buscaMax hacer ld de este registro en este registro para tener Dir(Dir(P)) == P 
                    st r10, r31, -4
                    or r11, r0, 0            ; Registro que va a guardar el caracter al que apunta r22
                    or r12, r0, 0            ; Registro para el mapa de bits
                    st r12, r31, -12                 
                    or r13, r0, 0            ; Registro que guarda el desplazamiento para cp en COMPRDO 
                    or r14, r0, 1            ; M = 1 ---
                    or r26, r0, 0            ; Regsiros para el mapa de bits

					ld r20, r31, 8			;hca no es necesario, ya lo has cargado Referencia a TEXTO							
					PUSH(r20)               ; guardo el puntero de TEXTO en la pila
					bsr LongCad				; Determino la longitud de TEXTO
					POP(r20)
					or r3, r29, r29        ;hca operacion innecesaria
					st r3, r31, -20
					or r4, r29, r29			; Guardo en r4 L(TEXTO)

Ajuste:				divu r5, r4, 4			; Bucle para ajuste en exceso
					mulu r5, r5, 4
					cmp r17, r5, r29		; r5 >= r4??
					bb1 ge, r17, Res_mem    ; si r5=r29 entonces r5 es multiplo de 4 si no r5+4 y reservamos ese tamanyo  
					addu r5, r5, 4          ; El numero que nos va a decir el tamaño a reservar esta en r5
					;addu r4, r4, 4         ;hca operacion innecesaria
					;br Ajuste				;hca saltar de vuelta para volver a comprobar es innecesario
                                            

Res_mem:			subu r30, r30, r5		; Reservo espacio en pila para COMPRDO (r5)

Chars8xM:			cmp r17, r8, 8			; Miro si ya he copiado los 8 primeros caracteres
					bb1 eq, r17, bucleCMP  ;hca salto al inicio de la compresion 
					ld.bu r11, r22, 0			; Cargo los 4 primeros en r11
					st.b r11, r30, r8			; Los meto en pila
					addu r22, r22, 1		; Avanzo puntero de TEXTO
                    addu r23, r23, 1        ; hca Avanzo puntero de COMPRDO
					addu r8, r8, 1			; Avanzo puntero de desplazamiento
					addu r28, r28, 1
                    br Chars8xM	
;hca revisado hasta aquí 19:59 -----------------------------------------------------------------------------------------------------------------------
;hca bucleCMP-Start 
;hca borrado bucleCMP duplicado
					
bucleCMP:			ld r10, r31, -4
					ld r3, r31, -20
                    cmp r17, r8, r3         ;hca porque tienes dos bucleCMP???? si hemos copiado todo cargamos ultimo byte
					bb1 ge, r17, carga_lmb
                    PUSH(r21)
                    PUSH(r22)               ;copia puntero de texto
					PUSH(r10)			    ; JJ -> P
					PUSH(r8)			    ; MAX -> pos del ptr(TXT)
					PUSH(r20)               ; REF -> TEXTO
					bsr BuscaMax
					POP(r20)
					POP(r8)
					POP(r10)
                    POP(r22)    
                    POP(r21)
                   sb: or r9, r29, r29			; L
					;or r10, r8, r8			; P = Desplazamiento o posicion de la cadena dentro del texto 		

					cmp r18, r9, 4              ; longitud subcadena (r29)>=4 ?
					bb0 lt, r18, bc_no          ; si r29<4 saltamos a bc_no (apartado b del enunciado)
bc_si:              ld r7, r31, -8
                    ld.bu r11, r20, r8           ; la subcadena es menor que 4, cargo el primer caracter ld(pT)->r11
					st.b r11, r30, r28           ; guardo en marco de pila el caracter
					addu r8, r8, 1              ; avanzo puntero de desplazamiento de comprimido
					addu r28, r28, 1            ; avanzo puntero
                    addu r22, r22, 1            ; avanzo puntero de TEXTO
                    addu r23, r23, 1            ; avanzo puntero de COMPRDO
                    subu r7, r7, 1
                    cmp r18, r7, -1             ; r7 lleno? reinicio byte : sigo
					bb1 eq, r18, Reinicio_byte
                    st r7, r31, -8 
                    br bucleCMP 
		; L >= 4
bc_no:				ld r10, r10, 0			    ; Desplazamiento de JJ
					extu r24, r10 ,8<0>		    ; Primer byte de P (cacarcter) 
					st.b r24, r30, r28           ; y se guarda en pila 
					addu r28, r28, 1            ; avanzo puntero
                    extu r24, r10, 8<8>		    ; Segundo byte de P
					st.b r24, r30, r28
					addu r28, r28, 1
                    st.b r9, r30, r28		    ; guardo la longitud de la subcadena en pila
                    addu r28, r28, 1
                    addu r23, r23, r9
					addu r22, r22, r9
                    addu r8, r8, r9
					br suma_bit_1
Conti_no:           subu r7, r7, 1
        			cmp r18, r7, -1
                    bb1 eq, r18, Reinicio_byte
                    st r7, r31, -8
fin_bc_no:			br bucleCMP

carga_lmb:			ld r7, r31, -8
                    ld r6, r31, -16
                    ld r12, r31, -12
                    cmp r17, r7, 7
					bb1 eq, r17, Copia_cab
					addu r6, r6, 5				; sumo 5 al contador de bytes (cabecera + bytes que lleva introducidos el mapa de bits)
					st.b r12, r21, r6			; lo meto en cmpdo 
					subu r6, r6, 4				; sumo 1 a los bytes del mapa de bits
                    st r7, r31, -8
                    st r6, r31, -16
                    st r12, r31, -12

Copia_cab:			ld r3, r31, -20
					extu r13, r3, 8<0>
					st.b r13, r21, 0			; Guardo el byte mas significativo de L
					extu r13, r3, 8<8>
					st.b r13, r21, 1			; Guardo el byte menos significativo de L
					st.b r14, r21, 2			; Guardo M
					;DETERMINO EL TAMAÑO DE MAPA DE BITS PARA LA CABECERA (TAM(MAPA_BITS) + 5 )
					addu r6, r6, 5
					extu r13, r6, 8<0>
					st.b r13, r21, 3			; Guardo el byte mas significativo de bytes del mp (numero de bytes + 5 de cab)
					extu r13, r6, 8<8>
					st.b r13, r21, 4			; Guardo el byte menos significativo de bytes del mp (numero de bytes + 5 de cab)
					or r24, r0, 0				; desplazamiento en r30
					or r26, r28, r28
					or r23, r21, r21		    ; Puntero de COMPRDO
                    addu r23, r23, r6
copy_txt_cdo:		cmp r17, r26, 0
                    bb1 eq, r17, suma_total
                    ld.bu r16, r30, r24
                    st.b r16, r23, 0
                    addu r23, r23, 1 
                    addu r24, r24, 1
                    subu r26, r26, 1
                    br copy_txt_cdo
suma_bit_1:			;5c ultima parte PROBLEMAS 
					;r6 contador bytes
					;r7 contador bits 
					;r24 copia de r7 
					;r12 bits el mapa de bits 
                    ld r7, r31, -8
                    or r24, r7, r7
					set r24, r24, 1<5>
                    ld r12, r31, -12
					set r12, r12, r24
                    st r12, r31, -12
                    st r7, r31, -8
					br Conti_no
	
Reinicio_byte:		ld r7, r31, -8
                    ld r12, r31, -12
                    extu r12, r12, 8<0>			; cogemos el byte mas significativo
					ld r6, r31, -16
                    addu r6, r6, 5
					st.b r12, r21, r6 			; metemos este byte en la pos del mapa de bits de comprimido
					or r7, r0, 7				; restauramos el contador de bits
                    subu r6, r6, 4
                    st r7, r31, -8
                    st r6, r31, -16
                    or r12, r0, 0
                    st r12, r31, -12
                    br bucleCMP
                    
suma_total: 		addu r29, r28, r6
term:               st.b r0, r21, r29		
					ROMPEMARCO()
					jmp(r1)	 

; ------------------------------------------------------------- 
; Variables que usamos en la subrutina:
;
; comp - puntero comprimido
; desc - puntero descomprimido
; tam - tamanyo
;
; pT+desc = ptr texto descomprimido
; pb+comp+5 = ptr a mapa de bits
; pB+pos = ptr texto comprimido
;
; c8 = 8 caracteres?



Descomprime:        CREAMARCO()
                    ld r20, r31, 8          ; r20<-comp
                    ld r21, r31, 12         ; r21<-desc
                                            ; Inicializo resto de registros: 
                    or r6, r0, 0
                    ld.bu r4, r20, 1        ; tamano byte 1
                    mulu r4, r4, 0x100      ; desplazo 
                    ld.bu r5, r20, 0        ; tamano byte 0
                    addu r4, r4, r5         ; amano->r4
                    addu r5, r0, 0          ; pT->r5
                    addu r6, r6, 5          ; pb->r6
                    ld.bu r7, r20, 4        ; pos byte 1
                    mulu r7, r7, 0x100      ; desplazo
                    ld.bu r8, r20, 3        ; pos byte 0
                    addu r7, r7, r8         ; pos->r7
                    addu r7, r7, r20        ; pos ahora sirve para lds dentro de comp
                    or r8, r0, r0           ; pB->r8
                    or r9, r0, r0 
                    addu r9, r9, 31         ; c8->r9 
                    or r10, r0, r0          ; 

Desc1x8:            cmp r17, r8, 8          ; Paso 2, copia de com a desc los 8x1 (M=1) caracteres sin comprimir
                    bb1 eq, r17, BucleDESC
                    ld.bu r10, r7, r8
                    st.b r10, r21, r5
                    addu r5, r5, 1
                    addu r8, r8, 1
                    br Desc1x8

BucleDESC:          cmp r17, r5, r4         ; tamano==con
                    bb0 lt, r17, PreFinDESC
NewByte:            cmp r17, r9, 31         ; Byte de mapaBits terminado?->cargar nuevo
                    bb0 eq, r17, BitCheck   ; else saltar a comprobacion de bit
                    addu r9, r9, 8
                    or r11, r0, 0 
                    ld.bu r11, r20, r6
                    addu r6, r6, 1
                    br NewByte
BitCheck:           extu r12,r11,r9         ; Extraigo el bit en r12
               j:   cmp r17, r12, 1         ; bit==1? Caso bit=1
                    bb1 eq, r17, BitEs1
BitEs0:             ld.bu r13, r8, r7       ; Caso bit==0 
                    st.b r13, r21, r5      ; Copio el car com[pB]->desc[pT] *(notación simplificada de comp[pB])
                    addu r5, r5, 1
                    addu r8, r8, 1
                    br RebucleDESC

BitEs1:             ld.bu r14, r8, r7       ; cargo la mitad baja de la dirComp.
                    addu r8, r8, 1          ; avanzo 1 pB
                    ld.bu r15, r8, r7       ; cargo parte alta de la dirComp
                    mulu r15, r15, 0x100    ; desplazo la parte alta 1 byte
                    addu r14, r14, r15      ; dirComp cargado correctamente (suma=concat)
                    addu r8, r8, 1          ; avanzo 1 pB
                    ld.bu r15, r8, r7       ; cargo longitud
                    addu r8, r8, 1          ; dejo pB avanzado 
                    addu r16, r0, 0         ; inicializo contador de bucle a 0 : Es 0 o 1? funciona:)
BucleBE1:           cmp r17, r15, r16       ; longitud cad comprimida==contador de bucle? fin
                    bb1 eq, r17, RebucleDESC; else seguir
                    addu r10, r14, r16      ; com[L]
                    ld.bu r13, r10, r21     ; copio valor desc[L]
                    st.b r13, r21, r5       ; pego valor a desc[pT]
                    addu r16, r16, 1        ; avanzo contador de bucle
                    addu r5, r5, 1          ; avanzo pT
                    br BucleBE1

RebucleDESC:        subu r9, r9, 1
                    br BucleDESC

PreFinDESC:         or r8, r0, r0           ; Paso 4, principio del fin
                    st.b r8 , r21, r5       ; anado terminal
FinDESC:            or r29, r5, r5          ; Paso 5, fin de desc
                    ROMPEMARCO()
                    jmp(r1)
;--------------------------------------------------------------
Verifica:           CREAMARCO()
                    ld r20, r31, 8          ; texto
                    ld r21, r31, 12         ; CheckSum1
                    ld r22, r31, 16         ; CheckSum2
SizeCalc:   	    PUSH(r20)
                    bsr LongCad
                    POP(r20)
                    subu r30, r30, 12       ;reservo espacio para mis variables vitales (dir PilaCom, dir PilaDes)
                    st r29, r31, -12        ;guardo r29 en MdP 
                    addu r11, r0, 5         ; cabecera
                    addu r11, r11, r29      ; tamaño de texto
                    addu r12, r29, 7        ; (7+L0)
                    divu r12, r12, 8        ; (7+L0)/8 (mapa de bits)
                    addu r11, r11, r12      ; cabecera+(7+L0)/8
                    or r13, r11, r11       ; copio valor PilaCom
                    divu r13, r14, 0x04     ; PilaCom/4
                    mulu r13, r13, 0x04     ; PilaCom*4
                    subu r13, r11, r13      ; resto
                    addu r11, r11, r13      ; PilaCom + PilaCom%4  (número alinea palabra)
                    subu r30, r30, r11      ; Reservo PilaCom
                    or r4, r30, r30         ; copio pos inicio en pila de PilaCom
                    subu r30, r30, r11      ; reservo PilaDes (igual que PilaCom)
                    or r5, r30, r30         ; guardo inicio PilaDes 
ver:                    
                    st r5, r31, -4          ;PilaDes en MdP
                    st r4, r31, -8          ;PilaCom en MdP

CompNDesc:          PUSH(r4)                ; dir texto comprimido
                    PUSH(r20)               ;texto a comprimir
                    bsr Comprime
                    POP(r20)
                    POP(r4)
                pr: ld r5, r31, -4
                    PUSH(r5)                ; dir texto descomprimido
                    PUSH(r4)                ; dir texto a descomprimir
                    bsr Descomprime
                    POP(r4)
                    POP(r5)
                                 
SizeCheck:          ld r11, r31, -12 
                    cmp r17, r29, r11       ; comparo tamanyos
                    bb1 ne, r17, VMAL       ; tamanyos!=? vmal : empiezoChecksums

empiezoChecksums:   
                    PUSH(r5)
                    bsr Checksum
                    POP(r5)
                a:  ld r22, r31, 16
                    st r29, r22, 0          ; guardo r29 en M(r22)
                    ld r20, r31, 8          ;restauro r20
                    PUSH(r20)
                    bsr Checksum
                    POP(r20)
                b:  ld r21, r31, 12
                    st r29, r21, 0          ; guardo r29 en M(r21)
                                            ; se llama checksqd porque es un check de checksums :P
CheckSqd:       	ld r22, r31, 16
                    ld r12, r22, 0
                    cmp r17, r12, r29       ;comparo checksums 
VMAL:               bb1 eq, r17, VBIEN
                    or r29, r0, r0
                    subu r29, r29, 1
                    br VFIN
VBIEN:              or r29, r0, r0 
VFIN:               ROMPEMARCO()
                    jmp(r1)