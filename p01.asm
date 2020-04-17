title "P01: Calculadora"
    .model small            ; model small (segmentos de datos y codigo limitado hasta 64 KB cada uno)
    .386                    ; directiva para indicar version procesador
    .stack 64               ; tamano de stack/pila, define el tamano del segmento de stack, se mide en bytes

clear macro              	; macro para limpiar pantalla
    mov ah,0 				;AH = 0
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

inicio:
    mov ax,@data             ; AX = directiva @data
    mov ds,ax                ; DS = AX, inicializa registro de segmento de datos
    xor cx,cx                ; CL = 0, hace la funcion de un contador

    clear                    ; limpiar pantalla
    mov ah,09h               ; Prepara registro ah para imprimir un mensaje en pantalla
    lea dx,titulo            ; Imprime el mensaje de titulo
    int 21h                  ; Interrupcion 21h para controlar funciones del S.O.
    mov ah,09h               ; Prepara registro ah para imprimir un mensaje en pantalla
    lea dx,descripcion       ; Imprime una descripcion del programa
    int 21h                  ; Interrupcion 21h para controlar funciones del S.O.

    mov ah,09h               ; Prepara registro ah para imprimir un mensaje en pantalla
    lea dx,msjIngrese1       ; Imprime mensaje solicitando el primer numero al usuario
    int 21h                  ; Interrupcion 21h para controlar funciones del S.O.
    mov ah,09h               ; Prepara registro ah para imprimir un mensaje en pantalla
    lea dx,msjX
    int 21h                  ; Interrupcion 21h para controlar funciones del S.O.

leer:
    mov ah,08h               ; Instrucción para ingresar datos sin verlos en pantalla
    int 21h                  ; Interrupcion 21h para controlar funciones del S.O.

    cmp cl,0                 ; Compara cl con 0
    je sinNumero             ; Si CL == 0, salta a la etiqueta sinNumero para obligar al usuario a ingresar por lo menos un digito

    cmp al,08h
    je borrar

    cmp al,0Dh               ; Compara el valor en AL con el valor hexadecimal del 'enter'
    je flujo2 	             ; Si el usuario da 'enter'
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

finalEnter1:
    mov ah,08h               ; Instrucción para ingresar datos sin verlos en pantalla
    int 21h                  ; Interrupcion 21h para controlar funciones del S.O.

    cmp al,0Dh               ; Compara el valor en AL con el valor hexadecimal del 'enter'
    je flujo2                ; Si el usuario da 'enter' brinca al flujo2
    jmp finalEnter1          ; Si NO da enter entonces sigue leyendo sin imprimir

flujo2:
    xor ah,ah                ; limpia la parte alta del registro AX
    mov al,um                ; AL = um
    mov bx,1000              ; BX = 1000
    mul bx                   ; DX:AX = AX * BX
    mov num1,ax              ; num = AX

    xor ah,ah                ; limpia la parte alta del registro AX
    mov al,c                 ; AL = c
    mov bl,100               ; BL = 100
    mul bl                   ; AX = AL * BL
    add num1,ax              ; num1 = num1 + AX

    xor ah,ah                ; limpia la parte alta del registro AX
    mov al,d                 ; AL = d
    mov bl,10                ; BL = 10
    mul bl                   ; AX = AL * BL
    add num1,ax              ; num1 = num1 + AX

    xor ah,ah                ; limpia la parte alta del registro AX
    mov al,u                 ; AL = u
    add num1,ax              ; num1 = num1 + AX

    cmp cl,1                 ; Compara CL con 1
    je i1                    ; Si Cl == 1 entonces salta a i1
    cmp cl,2                 ; Compara CL con 2
    je i2                    ; Si Cl == 2 entonces salta a i2
    cmp cl,3                 ; Compara CL con 3
    je i3                    ; Si Cl == 3 entonces salta a i3
    cmp cl,4                 ; Compara CL con 4
    je ingrese2              ; Si Cl == 4 entonces salta a ingrese2

i1:
    mov ax,num1              ; AX = num1
    mov bx,1000              ; BX = 1000
    div bx                   ; DX:AX = AX / BX
    mov num1,ax              ; num = AX
    jmp ingrese2             ; Salta a ingrese2
i2:
    mov ax,num1              ; AX = num1
    mov bx,100               ; BX = 100
    div bx                   ; DX:AX = AX / BX
    mov num1,ax              ; num = AX
    jmp ingrese2             ; Salta a ingrese2
i3:
    mov ax,num1              ; AX = num1
    mov bx,10                ; BX = 10
    div bx                   ; DX:AX = AX / BX
    mov num1,ax              ; num = AX
    jmp ingrese2             ; Salta a ingrese2

ingrese2:
    xor cx,cx                ; limpia el registro CX

                             ; Ingresar segundo numero
    mov ah,09h               ; Prepara registro ah para imprimir un mensaje en pantalla
    lea dx,msjIngrese2       ; Imprime mensaje solicitando el segundo numero al usuario
    int 21h                  ; Interrupcion 21h para controlar funciones del S.O.
    mov ah,09h               ; Prepara registro ah para imprimir un mensaje en pantalla
    lea dx,msjY
    int 21h                  ; Interrupcion 21h para controlar funciones del S.O.

leer2:
    mov ah,08h               ; Instrucción para ingresar datos sin verlos en pantalla
    int 21h                  ; Interrupcion 21h para controlar funciones del S.O.

    cmp cl,0                 ; Compara CL con 0
    je sinNumero2             ; Si CL == 0 entonces brinca a 'sinNumero2'

    cmp al,08h
    je borrar2

    cmp al,0Dh               ; Compara el valor en AL con el valor hexadecimal del 'enter'
    je flujo4                ; Si CL == 'enter' brinca al flujo 4
    jmp sinNumero2

borrar2:
	delete
	sub cl,1

sinNumero2:
	cmp cl,4
	je leer2
    cmp al,40h               ; Compara AL con 40h
    jae leer2                ; Si es mayor o igual a 40h vuelve a leer
    cmp al,30h               ; Compara AL con 30h
    jb leer2                 ; Si es menor a 30 vuelve a leer

    mov ah,02h               ; AH = 02H, prepara AH para imprimir un caracter
    mov dl,al                ; DL = AL, AL contiene el caracter a imprimir
    int 21h                  ; Interrupcion 21h para controlar funciones del S.O.

    cmp cl,0                 ; Compara CL con 0
    je miles2                ; Si CL == 0 es porque es el primer digito

    cmp cl,1                 ; Compara CL con 1
    je centenas2             ; Si CL == 1 es porque es el segundo digito

    cmp cl,2                 ; Compara CL con 2
    je decenas2              ; Si CL == 2 es porque es el tercer digito

    cmp cl,3                 ; Compara CL con 3
    je unidades2             ; Si CL == 3 es porque es el cuarto digito

miles2:
    sub al,30h               ; Resta 30h para obtener el valor numerico del codigo ascii
    mov um,al                ; um = AL

    jmp flujo3               ; Salta al flujo3

centenas2:
    sub al,30h               ; Resta 30h para obtener el valor numerico del codigo ascii
    mov c,al                 ; c = AL

    jmp flujo3               ; Salta al flujo3

decenas2:
    sub al,30h               ; Resta 30h para obtener el valor numerico del codigo ascii
    mov d,al                 ; d = AL

    jmp flujo3               ; Salta al flujo3

unidades2:
    sub al,30h               ; Resta 30h para obtener el valor numerico del codigo ascii
    mov u,al                 ; u = AL

flujo3:
    add cl,1                 ; CL = CL + 1
    cmp cl,5                 ; Compara CL con 4
    jb leer2                 ; Si CL < 4 entonces continua leyendo digitos

finalEnter2:
    mov ah,08h               ; Instrucción para ingresar datos sin verlos en pantalla
    int 21h                  ; Interrupcion 21h para controlar funciones del S.O.

    cmp al,0Dh               ; Compara el valor en AL con el valor hexadecimal del 'enter'
    je flujo4                ; Si el usuario da 'enter' brinca al flujo4
    jmp finalEnter2          ; Si NO da enter entonces sigue leyendo sin imprimir

flujo4:
    xor ah,ah                ; limpia la parte alta del registro AX
    mov al,um                ; AL = um
    mov bx,1000              ; BX = 1000
    mul bx                   ; DX:AX = AX * BX
    mov num2,ax              ; num2 = AX

    xor ah,ah                ; limpia la parte alta del registro AX
    mov al,c                 ; AL = c
    mov bl,100               ; BL = 100
    mul bl                   ; AX = AL * BL
    add num2,ax              ; num2 = num2 + AX

    xor ah,ah                ; limpia la parte alta del registro AX
    mov al,d                 ; AL = d
    mov bl,10                ; BL = 10
    mul bl                   ; AX = AL * BL
    add num2,ax              ; num2 = num2 + AX

    xor ah,ah                ; limpia la parte alta del registro AX
    mov al,u                 ; AL = u
    add num2,ax              ; num2 = num2 + AX

    cmp cl,1                 ; Compara CL con 1
    je j1                    ; Si Cl == 1 entonces salta a j1
    cmp cl,2                 ; Compara CL con 2
    je j2                    ; Si Cl == 2 entonces salta a j2
    cmp cl,3                 ; Compara CL con 3
    je j3                    ; Si Cl == 3 entonces salta a j3
    cmp cl,4                 ; Compara CL con 4
    je suma                  ; Si Cl == 4 entonces salta a suma

j1:
    mov ax,num2              ; AX = num2
    mov bx,1000              ; BX = 1000
    div bx                   ; DX:AX = AX / BX
    mov num2,ax              ; num2 = AX
    jmp suma                 ; Salta a suma
j2:
    mov ax,num2              ; AX = num2
    mov bx,100               ; BX = 100
    div bx                   ; DX:AX = AX / BX
    mov num2,ax              ; num2 = AX
    jmp suma                 ; Salta a suma
j3:
    mov ax,num2              ; AX = num2
    mov bx,10                ; BX = 10
    div bx                   ; DX:AX = AX / BX
    mov num2,ax              ; num2 = AX
    jmp suma                 ; Salta a suma

suma:
    mov ax,num1              ; AX = num1
    add ax,num2              ; AX = AX + num2
    mov sum,ax               ; sum = AX

    mov ah,09h               ; Prepara registro ah para imprimir un mensaje en pantalla
    lea dx,msjSuma           ; Imprime mensaje de suma
    int 21h                  ; Interrupcion 21h para controlar funciones del S.O.

    mov ax,sum               ; AX = sum

                             ;;; Imprime decena de millar ;;;
    mov bx,10000             ; BX = 10000
    xor dx,dx                ; DX = 0000h
    div bx                   ; DX:AX = AX / BX
    mov temp,dx              ; temp = DX

    mov ah,02h               ; AH = 02H, prepara AH para imprimir un caracter
    mov dl,al                ; DL = AL, AL contiene el caracter a imprimir
    add dl,30h               ; DL = DL + 30h para obtener el equivalente en codigo ASCII
    int 21h                  ; Interrupcion 21h para controlar funciones del S.O.

    mov ax,temp              ; AX = temp

                             ;;; Imprime unidades de millar ;;;
    mov bx,1000              ; BX = 1000
    xor dx,dx                ; DX = 0000h
    div bx                   ; DX:AX = AX / BX
    mov temp,dx              ; temp = DX

    mov ah,02h               ; AH = 02H, prepara AH para imprimir un caracter
    mov dl,al                ; DL = AL, AL contiene el caracter a imprimir
    add dl,30h               ; DL = DL + 30h para obtener el equivalente en codigo ASCII
    int 21h                  ; Interrupcion 21h para controlar funciones del S.O.

    mov ax,temp              ; AX = temp

                             ;;; Imprime centenas ;;;
    mov bx,100               ; BX = 100
    xor dx,dx                ; DX = 0000h
    div bx                   ; DX:AX = AX / BX
    mov temp,dx              ; temp = DX

    mov ah,02h               ; AH = 02H, prepara AH para imprimir un caracter
    mov dl,al                ; DL = AL, AL contiene el caracter a imprimir
    add dl,30h               ; DL = DL + 30h para obtener el equivalente en codigo ASCII
    int 21h                  ; Interrupcion 21h para controlar funciones del S.O.

    mov ax,temp              ; AX = temp

                             ;;; Imprime decenas ;;;
    mov bx,10                ; BX = 10
    xor dx,dx                ; DX = 0000h
    div bx                   ; DX:AX = AX / BX
    mov temp,dx              ; temp = DX

    mov ah,02h               ; AH = 02H, prepara AH para imprimir un caracter
    mov dl,al                ; DL = AL, AL contiene el caracter a imprimir
    add dl,30h               ; DL = DL + 30h para obtener el equivalente en codigo ASCII
    int 21h                  ; Interrupcion 21h para controlar funciones del S.O.

                             ;;; Imprime unidades ;;;
    mov ax,temp              ; AX = temp

    mov ah,02h               ; AH = 02H, prepara AH para imprimir un caracter
    mov dl,al                ; DL = AL, AL contiene el caracter a imprimir
    add dl,30h               ; DL = DL + 30h para obtener el equivalente en codigo ASCII
    int 21h                  ; Interrupcion 21h para controlar funciones del S.O.

resta:
    mov ax,num1              ; AX = num1
    mov bx,num2              ; BX = num2
    cmp ax,bx                ; Compara AX con BX
    jb menor                 ; Si el primer numero es menor que el segundo entonces brinca a etiqueta 'menor'
    sub ax,num2              ; Si el primer numero es mayor que el segundo realiza la resta directamente, AX = AX - num2
    mov res,ax               ; res = AX
    jmp flujo5               ; Brinca al flujo5 para imprimir el resultado

menor:
    sub bx,num1              ; Como el primero es menor entonces resta el primer numero al segundo, BX = BX - num1
    mov res,bx               ; res = BX
    add nega,1               ; nega = nega + 1, esta operacion sirve para comparar si el resultado debe ser negativo o no

flujo5:
    mov ah,09h               ; Prepara registro ah para imprimir un mensaje en pantalla
    lea dx, msjResta         ; Imprime el mensaje de Resta
    int 21h                  ; Interrupcion 21h para controlar funciones del S.O.

    mov cl,nega              ; CL = nega
    cmp cl,1                 ; Compara CL con 1
    jne positivo             ; Si CL != 1 quiere decir que el numero es positivo y por lo tanto sigue el flujo normal
    mov ah,02h               ; AH = 02H, prepara AH para imprimir un caracter
    mov dl,2Dh               ; DL = 2Dh, 2Dh es el codigo equivalente al simbolo del  signo negativo
    int 21h                  ; Interrupcion 21h para controlar funciones del S.O.
    sub nega,1               ; nega = nega - 1, limpia la variable 'nega' para iniciar nuevamente

positivo:
    cmp cl,1                 ; Compara CL con 1
    je flujo6                ; Si CL == 1, si es negativo entonces continua con el flujo normal
    mov ah,02h               ; AH = 02H, prepara AH para imprimir un caracter
    mov dl,20h               ; DL = 20h, imprime un espacio para dar mejor presentacion
    int 21h                  ; Interrupcion 21h para controlar funciones del S.O.
flujo6:
    mov ax,res               ; AX = res

    						 ;;; Imprime unidades de millar ;;;
    mov bx,1000              ; BX = 1000
    xor dx,dx                ; DX = 0000h
    div bx                   ; DX:AX = AX / BX
    mov temp,dx              ; temp = DX

    mov ah,02h               ; AH = 02H, prepara AH para imprimir un caracter
    mov dl,al                ; DL = AL, AL contiene el caracter a imprimir
    add dl,30h               ; DL = DL + 30h para obtener el equivalente en codigo ASCII
    int 21h                  ; Interrupcion 21h para controlar funciones del S.O.

    mov ax,temp              ; AX = temp

                             ;;; Imprime centenas ;;;
    mov bx,100               ; BX = 100
    xor dx,dx                ; DX = 0000h
    div bx                   ; DX:AX = AX / BX
    mov temp,dx              ; temp = DX

    mov ah,02h               ; AH = 02H, prepara AH para imprimir un caracter
    mov dl,al                ; DL = AL, AL contiene el caracter a imprimir
    add dl,30h               ; DL = DL + 30h para obtener el equivalente en codigo ASCII
    int 21h                  ; Interrupcion 21h para controlar funciones del S.O.

    mov ax,temp              ; AX = temp

                             ;;; Imprime decenas ;;;
    mov bx,10                ; BX = 10
    xor dx,dx                ; DX = 0000h
    div bx                   ; DX:AX = AX / BX
    mov temp,dx              ; temp = DX

    mov ah,02h               ; AH = 02H, prepara AH para imprimir un caracter
    mov dl,al                ; DL = AL, AL contiene el caracter a imprimir
    add dl,30h               ; DL = DL + 30h para obtener el equivalente en codigo ASCII
    int 21h                  ; Interrupcion 21h para controlar funciones del S.O.

                             ;;; Imprime unidades ;;;
    mov ax,temp              ; AX = temp

    mov ah,02h               ; AH = 02H, prepara AH para imprimir un caracter
    mov dl,al                ; DL = AL, AL contiene el caracter a imprimir
    add dl,30h               ; DL = DL + 30h para obtener el equivalente en codigo ASCII
    int 21h                  ; Interrupcion 21h para controlar funciones del S.O.

multiplicacion:
    mov ah,09h               ; Prepara registro ah para imprimir un mensaje en pantalla
    lea dx, msjMult 		 ; Imprime mensaje Multiplicacion
    int 21h                  ; Interrupcion 21h para controlar funciones del S.O.

    mov ax,num1              ; AX = num1
    mov bx,num2              ; BX = num2
    xor dx,dx                ; DX = 0000h
    mul bx                   ; DX:AX = AX * BX
    mov [mult],ax            ; [mult] = AX , guarda la parte baja del producto
    mov [mult+2],dx          ; [mult+2] = DX , guarda la parte alta del producto

    mov ax,mult              ; AX = mult
    mov bx,10000             ; BX = 10000
    div bx                   ; DX:AX = AX / BX, separa el producto en dos partes para imprimir el resultado en grupos de 4 digitos

    mov aux1,ax              ; aux1 = AX, los primeros cuatro digitos
    mov aux2,dx              ; aux2 = DX, los últimos cuatro digitos

parteAlta:
    mov ax,aux1              ; AX = aux1

    						 ;;; Imprime decenas de millon ;;;
    mov bx,1000              ; BX = 1000
    xor dx,dx                ; DX = 0000h
    div bx                   ; DX:AX = AX / BX
    mov temp,dx              ; temp = DX

    mov ah,02h               ; AH = 02H, prepara AH para imprimir un caracter
    mov dl,al                ; DL = AL, AL contiene el caracter a imprimir
    add dl,30h               ; DL = DL + 30h para obtener el equivalente en codigo ASCII
    int 21h                  ; Interrupcion 21h para controlar funciones del S.O.

    mov ax,temp              ; AX = temp

                             ;;; Imprime unidad de millon ;;;
    mov bx,100               ; BX = 100
    xor dx,dx                ; DX = 0000h
    div bx                   ; DX:AX = AX / BX
    mov temp,dx              ; temp = DX

    mov ah,02h               ; AH = 02H, prepara AH para imprimir un caracter
    mov dl,al                ; DL = AL, AL contiene el caracter a imprimir
    add dl,30h               ; DL = DL + 30h para obtener el equivalente en codigo ASCII
    int 21h                  ; Interrupcion 21h para controlar funciones del S.O.

    mov ax,temp              ; AX = temp

                             ;;; Imprime centenas de millar ;;;
    mov bx,10                ; BX = 10
    xor dx,dx                ; DX = 0000h
    div bx                   ; DX:AX = AX / BX
    mov temp,dx              ; temp = DX


    mov ah,02h               ; AH = 02H, prepara AH para imprimir un caracter
    mov dl,al                ; DL = AL, AL contiene el caracter a imprimir
    add dl,30h               ; DL = DL + 30h para obtener el equivalente en codigo ASCII
    int 21h                  ; Interrupcion 21h para controlar funciones del S.O.

                             ;;; Imprime decenas de millar ;;;
    mov ax,temp              ; AX = temp

    mov ah,02h               ; AH = 02H, prepara AH para imprimir un caracter
    mov dl,al                ; DL = AL, AL contiene el caracter a imprimir
    add dl,30h               ; DL = DL + 30h para obtener el equivalente en codigo ASCII
    int 21h                  ; Interrupcion 21h para controlar funciones del S.O.

parteBaja:
    mov ax,aux2              ; AX = aux2

    						 ;;; Imprime unidades de millar ;;; 
    mov bx,1000              ; BX = 1000
    xor dx,dx                ; DX = 0000h
    div bx                   ; DX:AX = AX / BX
    mov temp,dx              ; temp = DX

    mov ah,02h               ; AH = 02H, prepara AH para imprimir un caracter
    mov dl,al                ; DL = AL, AL contiene el caracter a imprimir
    add dl,30h               ; DL = DL + 30h para obtener el equivalente en codigo ASCII
    int 21h                  ; Interrupcion 21h para controlar funciones del S.O.

    mov ax,temp              ; AX = temp

                             ;;; Imprime centenas ;;;
    mov bx,100               ; BX = 100
    xor dx,dx                ; DX = 0000h
    div bx                   ; DX:AX = AX / BX
    mov temp,dx              ; temp = DX

    mov ah,02h               ; AH = 02H, prepara AH para imprimir un caracter
    mov dl,al                ; DL = AL, AL contiene el caracter a imprimir
    add dl,30h               ; DL = DL + 30h para obtener el equivalente en codigo ASCII
    int 21h                  ; Interrupcion 21h para controlar funciones del S.O.

    mov ax,temp              ; AX = temp

                             ;;; Imprime decenas ;;;
    mov bx,10                ; BX = 10
    xor dx,dx                ; DX = 0000h
    div bx                   ; DX:AX = AX / BX
    mov temp,dx              ; temp = DX

    mov ah,02h               ; AH = 02H, prepara AH para imprimir un caracter
    mov dl,al                ; DL = AL, AL contiene el caracter a imprimir
    add dl,30h               ; DL = DL + 30h para obtener el equivalente en codigo ASCII
    int 21h                  ; Interrupcion 21h para controlar funciones del S.O.

                             ;;; Imprime unidades ;;;
    mov ax,temp              ; AX = temp

    mov ah,02h               ; AH = 02H, prepara AH para imprimir un caracter
    mov dl,al                ; DL = AL, AL contiene el caracter a imprimir
    add dl,30h               ; DL = DL + 30h para obtener el equivalente en codigo ASCII
    int 21h                  ; Interrupcion 21h para controlar funciones del S.O.

division:
    mov ax,num1              ; AX = num1
    mov bx,num2              ; BX = num2
    cmp bx,0                 ; Compara BX con 0
    je isZero                ; Si BX == 0, si el divisor es 0 entonces brinca al bloque 'isZero'
    xor dx,dx                ; DX = 0000h
    div bx                   ; DX:AX = AX / BX
    mov coc,ax               ; coc = AX
    mov residuo,dx           ; residuo = DX

    mov ah,09h               ; Prepara registro ah para imprimir un mensaje en pantalla
    lea dx, msjDiv           ; Imprime el mensaje del Cociente
    int 21h                  ; Interrupcion 21h para controlar funciones del S.O.

    mov ax,coc               ; AX = coc

    						 ;;; Imprime unidades de millar ;;;
    mov bx,1000              ; BX = 1000
    xor dx,dx                ; DX = 0000h
    div bx                   ; DX:AX = AX / BX
    mov temp,dx              ; temp = DX

    mov ah,02h               ; AH = 02H, prepara AH para imprimir un caracter
    mov dl,al                ; DL = AL, AL contiene el caracter a imprimir
    add dl,30h               ; DL = DL + 30h para obtener el equivalente en codigo ASCII
    int 21h                  ; Interrupcion 21h para controlar funciones del S.O.

    mov ax,temp              ; AX = temp

                             ;;; Imprime centenas ;;;
    mov bx,100               ; BX = 100
    xor dx,dx                ; DX = 0000h
    div bx                   ; DX:AX = AX / BX
    mov temp,dx              ; temp = DX

    mov ah,02h               ; AH = 02H, prepara AH para imprimir un caracter
    mov dl,al                ; DL = AL, AL contiene el caracter a imprimir
    add dl,30h               ; DL = DL + 30h para obtener el equivalente en codigo ASCII
    int 21h                  ; Interrupcion 21h para controlar funciones del S.O.

    mov ax,temp              ; AX = temp

                             ;;; Imprime decenas ;;;
    mov bx,10                ; BX = 10
    xor dx,dx                ; DX = 0000h
    div bx                   ; DX:AX = AX / BX
    mov temp,dx              ; temp = DX

    mov ah,02h               ; AH = 02H, prepara AH para imprimir un caracter
    mov dl,al                ; DL = AL, AL contiene el caracter a imprimir
    add dl,30h               ; DL = DL + 30h para obtener el equivalente en codigo ASCII
    int 21h                  ; Interrupcion 21h para controlar funciones del S.O.

                             ;;; Imprime unidades ;;;
    mov ax,temp              ; AX = temp

    mov ah,02h               ; AH = 02H, prepara AH para imprimir un caracter
    mov dl,al                ; DL = AL, AL contiene el caracter a imprimir
    add dl,30h               ; DL = DL + 30h para obtener el equivalente en codigo ASCII
    int 21h                  ; Interrupcion 21h para controlar funciones del S.O.

    mov ah,09h               ; Prepara registro ah para imprimir un mensaje en pantalla
    lea dx,msjRes            ; Imprime mensaje del Residuo
    int 21h                  ; Interrupcion 21h para controlar funciones del S.O.

    mov ax,residuo           ; AX = residuo

    						 ;;; Imprime unidades de millar ;;;
    mov bx,1000              ; BX = 1000
    xor dx,dx                ; DX = 0000h
    div bx                   ; DX:AX = AX / BX
    mov temp,dx              ; temp = DX

    mov ah,02h               ; AH = 02H, prepara AH para imprimir un caracter
    mov dl,al                ; DL = AL, AL contiene el caracter a imprimir
    add dl,30h               ; DL = DL + 30h para obtener el equivalente en codigo ASCII
    int 21h                  ; Interrupcion 21h para controlar funciones del S.O.

    mov ax,temp              ; AX = temp

                             ;;; Imprime centenas ;;;
    mov bx,100               ; BX = 100
    xor dx,dx                ; DX = 0000h
    div bx                   ; DX:AX = AX / BX
    mov temp,dx              ; temp = DX

    mov ah,02h               ; AH = 02H, prepara AH para imprimir un caracter
    mov dl,al                ; DL = AL, AL contiene el caracter a imprimir
    add dl,30h               ; DL = DL + 30h para obtener el equivalente en codigo ASCII
    int 21h                  ; Interrupcion 21h para controlar funciones del S.O.

    mov ax,temp              ; AX = temp

                             ;;; Imprime decenas ;;;
    mov bx,10                ; BX = 10
    xor dx,dx                ; DX = 0000h
    div bx                   ; DX:AX = AX / BX
    mov temp,dx              ; temp = DX

    mov ah,02h               ; AH = 02H, prepara AH para imprimir un caracter
    mov dl,al                ; DL = AL, AL contiene el caracter a imprimir
    add dl,30h               ; DL = DL + 30h para obtener el equivalente en codigo ASCII
    int 21h                  ; Interrupcion 21h para controlar funciones del S.O.

                             ;;;; Imprime unidades ;;;
    mov ax,temp              ; AX = temp

    mov ah,02h               ; AH = 02H, prepara AH para imprimir un caracter
    mov dl,al                ; DL = AL, AL contiene el caracter a imprimir
    add dl,30h               ; DL = DL + 30h para obtener el equivalente en codigo ASCII
    int 21h                  ; Interrupcion 21h para controlar funciones del S.O.
    jmp menu                 ; Brinca al menu final

isZero:
    mov ah,09h               ; Prepara registro ah para imprimir un mensaje en pantalla
    lea dx,msjZero           ; Imprime un mensaje
    int 21h                  ; Interrupcion 21h para controlar funciones del S.O.

menu:
    						 ; Imprime el mensaje de menu
    mov ah,09h               ; Prepara registro ah para imprimir un mensaje en pantalla
    lea dx,msjInicio         ; Muestra mensaje para volver al inicio
    int 21h                  ; Interrupcion 21h para controlar funciones del S.O.

respuesta:
    mov ah,08h               ; Instrucción para ingresar datos sin verlos en pantalla
    int 21h                  ; Interrupcion 21h para controlar funciones del S.O.
    cmp al,21h               ; Compara AL con 21h, los caracteres menores a 21h son de control y no son imprimibles
    jb respuesta             ; Si AL es menor a 21h entonces vuelve a leer una respuesta del usuario del menu final

    mov ah,02h               ; AH = 02H, prepara AH para imprimir un caracter
    mov dl,al                ; DL = AL, AL contiene el caracter a imprimir
    int 21h                  ; Interrupcion 21h para controlar funciones del S.O.
    mov resp,al              ; resp = AL, guarda la respuesta del usuario
    mov cl,1

typeEnter:
    mov ah,08h               ; Instrucción para ingresar datos sin verlos en pantalla
    int 21h                  ; Interrupcion 21h para controlar funciones del S.O.

    cmp al,08h
    jne flujo7
    delete
    jmp respuesta

flujo7:
    cmp al,0Dh               ; Compara el valor en AL con el valor hexadecimal del 'enter'
    jne typeEnter            ; Si no digita 'enter' entonces continua leyendo respuestas sin mostrarlas en pantalla

    mov al,resp              ; AL = resp

    cmp al,'S'               ; Compara AL con 'S'
    je inicio                ; Si AL == 'S' vuelve al inicio del programa
    cmp al,'s'               ; Compara AL con 's'
    je inicio                ; Si AL == 's' vuelve al inicio del programa
    cmp al,'N'               ; Compara AL con 'N'
    je salir                 ; Si AL == 'N' sale del programa
    cmp al,'n'               ; Compara AL con 'n'
    je salir                 ; Si AL == 'n' sale del programa
    mov ah,09h               ; Prepara registro ah para imprimir un mensaje en pantalla
    lea dx, msjError         ; Si no se cumple ninguna condicion anterior, imprime un mensaje de error solicitando una opcion correcta
    int 21h                  ; Interrupcion 21h para controlar funciones del S.O.
    jmp menu                 ; Regresa al menu final

salir:						 ; inicia etiqueta Salir
    clear
    mov ah,4Ch               ; AH = 4Ch, opcion para terminar programa
    mov al,00h               ; AL = 0 exit Code, codigo devuelto al finalizar el programa
    int 21h                  ; Interrupcion 21h para controlar funciones del S.O.
    end inicio               ; Fin de etiqueta inicio, fin de programa