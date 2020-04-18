title "P01: Calculadora"
    .model small            ; model small (segmentos de datos y codigo limitado hasta 64 KB cada uno)
    .386                    ; directiva para indicar version procesador
    .stack 64               ; tamano de stack/pila, define el tamano del segmento de stack, se mide en bytes

clear macro              	; macro para limpiar pantalla
    mov ah,0h 				;AH = 0
    mov al,3h 				;AL = 3h
    int 10h 				;Interrupcion 10h
endm clear

delete macro 				; macro para eliminar un caracter
	mov ah,02h
	mov dl,08h
	int 21h
	mov ah,02h
	mov dl,20h
	int 21h
	mov ah,02h
	mov dl,08h
	int 21h
endm delete

printDigito macro char       ; macro para imprimir un digito
    mov ah,02h               ; AH = 02H, prepara AH para imprimir un caracter
    mov dl,char              ; DL = AL, AL contiene el caracter a imprimir
    add dl,30h               ; DL = DL + 30h para obtener el equivalente en codigo ASCII
    int 21h                  ; Interrupcion 21h para controlar funciones del S.O.
endm printDigito

.data
    ; variables para guardar los digitos
    um				db 		0
    c 				db 		0
    d 				db 		0
    u 				db 		0

    ; variables para almacenar los numeros y los resultados
    num1			dw 		0
    num2			dw 		0
    sum 			dw 		0
    res 			dw 		0
    mult 			dw		0,0
    coc				dw 		0
    residuo			dw 		0

    ; variables auxiliares
    num             dw      0
    temp 			dw		0
    aux1 			dw 		0
    aux2			dw 		0
    nega 			db 		0
    resp 			db		0

    ; mensajes
    titulo			db 		10,13,7," ** PROYECTO 1 - CALCULADORA **",10,13,7,"$"
    descripcion		db		10,13,7," Programa que realiza las operaciones basicas dados dos numeros...",10,13,7,"$"
    msjIngrese1 	db 		10,13,7," Ingrese el primer numero: ","$"
    msjIngrese2 	db 		10,13,7," Ingrese el segundo numero: ","$"
    msjX		 	db 		10,13,7,"   x = ","$"
    msjY			db 		10,13,7,"   y = ","$"
    msjSuma 		db 		10,13,7,10,13,7," Suma: 		x + y =     ","$"
    msjResta		db 		10,13,7," Resta: 	x - y =     ","$"
    msjMult			db 		10,13,7," Mult.: 	x * y =  ","$"
    msjDiv			db 		10,13,7," Cociente: 	x / y =      ","$"
    msjRes			db 		10,13,7," Residuo: 	x % y =      ","$"
    msjZero 		db		10,13,7," Division: 	x / y =       N/D","$"
    msjInicio 		db 		10,13,7,10,13,7," Desea volver al inicio? [S/N]: ","$"
    msjError 		db 		10,13,7," INGRESE UNA OPCION CORRECTA ","$"

.code

printNumero proc             ; procedimiento para imprimir el número completo
    cmp cl,5                 ; Compara CL con 5
    jb imprime4              ; Si CL < 5 entonces imprime solo 4 dígitos

    mov bx,10000             ; BX = 10000
    xor dx,dx                ; DX = 0000h
    div bx                   ; DX:AX = AX / BX
    mov temp,dx              ; temp = DX

    printDigito al

    mov ax,temp              ; AX = temp
imprime4:
    mov bx,1000              ; BX = 1000
    xor dx,dx                ; DX = 0000h
    div bx                   ; DX:AX = AX / BX
    mov temp,dx              ; temp = DX

    printDigito al

    mov ax,temp              ; AX = temp

    mov bx,100               ; BX = 100
    xor dx,dx                ; DX = 0000h
    div bx                   ; DX:AX = AX / BX
    mov temp,dx              ; temp = DX

    printDigito al

    mov ax,temp              ; AX = temp

    mov bx,10                ; BX = 10
    xor dx,dx                ; DX = 0000h
    div bx                   ; DX:AX = AX / BX
    mov temp,dx              ; temp = DX

    printDigito al

    mov ax,temp              ; AX = temp

    printDigito al

    ret
endp printNumero

leerNum proc
    xor cl,cl
leer:
    mov ah,08h               ; Instrucción para ingresar datos sin verlos en pantalla
    int 21h                  ; Interrupcion 21h para controlar funciones del S.O.

    cmp cl,0                 ; Compara cl con 0
    je sinNumero             ; Si CL == 0, salta a la etiqueta sinNumero para obligar al usuario a ingresar por lo menos un digito

    cmp al,08h
    je borrar

    cmp al,0Dh               ; Compara el valor en AL con el valor hexadecimal del 'enter'
    je flujo2                ; Si el usuario da 'enter'
    jmp sinNumero

borrar:
    delete
    sub cl,1

sinNumero:
    cmp cl,4
    je leer
    cmp al,40h               ; Compara AL con 40h
    jae leer                 ; Si es mayor o igual a 40h vuelve a leer
    cmp al,30h               ; Compara AL con 30h
    jb leer                  ; Si es menor a 30h vuelve a leer

    mov ah,02h               ; AH = 02H, prepara AH para imprimir un caracter
    mov dl,al                ; DL = AL, AL contiene el caracter a imprimir
    int 21h                  ; Interrupcion 21h para controlar funciones del S.O.

    cmp cl,0                 ; Compara cl con 0
    je miles                 ; Si CL == 0 es porque es el primer digito

    cmp cl,1                 ; Compara CL con 1
    je centenas              ; Si CL == 1 es porque es el segundo digito

    cmp cl,2                 ; Compara cl con 2
    je decenas               ; Si CL == 2 es porque es el tercer digito

    cmp cl,3                 ; Compara cl con 3
    je unidades              ; Si CL == 3 es porque es el cuarto digito

miles:
    sub al,30h               ; Resta 30h para obtener el valor numerico del codigo ascii
    mov um,al                ; um = AL
    jmp flujo1               ; salta al flujo 1

centenas:
    sub al,30h               ; Resta 30h para obtener el valor numerico del codigo ascii
    mov c,al                 ; c = AL
    jmp flujo1               ; salta al flujo 1

decenas:
    sub al,30h               ; Resta 30h para obtener el valor numerico del codigo ascii
    mov d,al                 ; d = AL
    jmp flujo1               ; salta al flujo 1

unidades:
    sub al,30h               ; Resta 30h para obtener el valor numerico del codigo ascii
    mov u,al                 ; u = AL

flujo1:
    add cl,1                 ; CL = CL + 1
    cmp cl,5                 ; Compara CL con 4
    jb leer                  ; Si CL < 4 entonces lee el siguiente dígito

finalEnter:
    mov ah,08h               ; Instrucción para ingresar datos sin verlos en pantalla
    int 21h                  ; Interrupcion 21h para controlar funciones del S.O.

    cmp al,0Dh               ; Compara el valor en AL con el valor hexadecimal del 'enter'
    je flujo2                ; Si el usuario da 'enter' brinca al flujo2
    jmp finalEnter          ; Si NO da enter entonces sigue leyendo sin imprimir

flujo2:
    xor ah,ah                ; limpia la parte alta del registro AX
    mov al,um                ; AL = um
    mov bx,1000              ; BX = 1000
    mul bx                   ; DX:AX = AX * BX
    mov num,ax               ; num = AX

    xor ah,ah                ; limpia la parte alta del registro AX
    mov al,c                 ; AL = c
    mov bl,100               ; BL = 100
    mul bl                   ; AX = AL * BL
    add num,ax               ; num1 = num1 + AX

    xor ah,ah                ; limpia la parte alta del registro AX
    mov al,d                 ; AL = d
    mov bl,10                ; BL = 10
    mul bl                   ; AX = AL * BL
    add num,ax               ; num1 = num1 + AX

    xor ah,ah                ; limpia la parte alta del registro AX
    mov al,u                 ; AL = u
    add num,ax               ; num1 = num1 + AX

    cmp cl,1                 ; Compara CL con 1
    je i1                    ; Si Cl == 1 entonces salta a i1
    cmp cl,2                 ; Compara CL con 2
    je i2                    ; Si Cl == 2 entonces salta a i2
    cmp cl,3                 ; Compara CL con 3
    je i3                    ; Si Cl == 3 entonces salta a i3
    cmp cl,4                 ; Compara CL con 4
    je flujo3              ; Si Cl == 4 entonces salta a flujo3
i1:
    mov ax,num              ; AX = num1
    mov bx,1000              ; BX = 1000
    xor dx,dx
    div bx                   ; DX:AX = AX / BX
    mov num,ax              ; num = AX
    jmp flujo3             ; Salta a flujo3
i2:
    mov ax,num              ; AX = num1
    mov bx,100               ; BX = 100
    xor dx,dx
    div bx                   ; DX:AX = AX / BX
    mov num,ax              ; num = AX
    jmp flujo3             ; Salta a flujo3
i3:
    mov ax,num              ; AX = num1
    mov bx,10                ; BX = 10
    xor dx,dx
    div bx                   ; DX:AX = AX / BX
    mov num,ax              ; num = AX
    jmp flujo3             ; Salta a flujo3
flujo3:
    mov ax,num
    ret
endp leerNum

inicio:
    mov ax,@data             ; AX = directiva @data
    mov ds,ax                ; DS = AX, inicializa registro de segmento de datos

    mov ax,4321
    mov bx,123
    xor dx,dx
    div bx                   ; DX:AX = AX / BX
    
    mov coc,ax               ; coc = AX
    mov residuo,dx           ; residuo = DX

    mov ax,residuo           ; AX = residuo
        
    mov cl,4
    call printNumero         ; Imprime el número 

salir:						 ; inicia etiqueta Salir
    mov ah,4Ch               ; AH = 4Ch, opcion para terminar programa
    mov al,00h               ; AL = 0 exit Code, codigo devuelto al finalizar el programa
    int 21h                  ; Interrupcion 21h para controlar funciones del S.O.
    end inicio               ; Fin de etiqueta inicio, fin de programa