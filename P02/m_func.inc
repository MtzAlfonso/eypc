isButton macro xmin,xmax,ymin,ymax
    ; Comparar que se haga clic dentro del boton
    cmp dx,ymin
    jl mouse                              ; Si DX < ymin, regresa a etiqueta 'mouse'
    cmp dx,ymax
    ja mouse                              ; Si DX > ymax, regresa a etiqueta 'mouse'
    cmp cx,xmin
    jl mouse                              ; Si CX < xmin, regresa a etiqueta 'mouse'
    cmp cx,xmax
    ja mouse                              ; Si CX > xmax, regresa a etiqueta 'mouse'
endm

borra macro cont,n
    local borra_num

    xor di,di                             ; limpia DI para utilizarlo
    mov cx,[cont]                         ; prepara CX para loop de acuerdo al numero de digitos introducidos
    mov [ren_aux],n                       ; variable ren_aux para poner cursor en pantalla
                                          ; ren_aux se mantiene fijo a lo largo del siguiente loop
borra_num:                                ; Loop para imprimir numero
    push cx                               ; guarda el valor de CX en la pila
    mov [col_aux],30                      ; variable col_aux para mover cursor en pantalla
    sub [col_aux],cl                      ; Para calcular la columna en donde comienza a imprimir en pantalla de acuerdo a CX
    mov cl,[clear+di]                     ; copia el digito en CL
    escribir cl,[ren_aux],[col_aux],15    ; escribe caracter en pantalla
    inc di                                ; incrementa DI para recorrer el arreglo num1
    pop cx                                ; recupera el valor de CX al inicio del loop
    loop borra_num
endm

borraResultado macro
    escribir '',5,2,14                    ; escribe caracter en pantalla
    mov ah,09h                            ; Prepara registro ah para imprimir un mensaje en pantalla
    lea dx,clean                          ; Limpia resultado
    int 21h                               ; Interrupcion 21h para controlar funciones del S.O.
    escribir '=',5,2,14                   ; escribe caracter en pantalla
    escribir '',5,4,14                    ; escribe caracter en pantalla
endm

operacion macro OPERADOR
    local flujo,flujo2
    cmp OPERADOR,'+'
    jne resta
    mov ax,num1                           ; AX = num1
    add ax,num2                           ; AX = AX + num2
    mov sum,ax                            ; sum = AX
    mov ax,sum                            ; AX = sum

    mov cl,5
    call printNumero                      ; Imprime el número

    jmp finish
resta:
    cmp OPERADOR,'-'
    jne multiplicacion
    mov ax,num1                           ; AX = num1
    mov bx,num2                           ; BX = num2
    cmp ax,bx                             ; Compara AX con BX
    jb menor                              ; Si el primer numero es menor que el segundo entonces brinca a etiqueta 'menor'
    sub ax,num2                           ; Si el primer numero es mayor que el segundo realiza la resta directamente, AX = AX - num2
    mov res,ax                            ; res = AX
    jmp flujo                             ; Brinca al flujo4 para imprimir el resultado

menor:
    sub bx,num1                           ; Como el primero es menor entonces resta el primer numero al segundo, BX = BX - num1
    mov res,bx                            ; res = BX
    add nega,1                            ; nega = nega + 1, esta operacion sirve para comparar si el resultado debe ser negativo o no

flujo:
    mov cl,nega                           ; CL = nega
    cmp cl,1                              ; Compara CL con 1
    jne positivo                          ; Si CL != 1 quiere decir que el numero es positivo y por lo tanto sigue el flujo normal
    mov ah,02h                            ; AH = 02H, prepara AH para imprimir un caracter
    mov dl,2Dh                            ; DL = 2Dh, 2Dh es el codigo equivalente al simbolo del  signo negativo
    int 21h                               ; Interrupcion 21h para controlar funciones del S.O.
    sub nega,1                            ; nega = nega - 1, limpia la variable 'nega' para iniciar nuevamente

positivo:
    cmp cl,1                              ; Compara CL con 1
    je flujo2                             ; Si CL == 1, si es negativo entonces continua con el flujo normal
    mov ah,02h                            ; AH = 02H, prepara AH para imprimir un caracter
    mov dl,20h                            ; DL = 20h, imprime un espacio para dar mejor presentacion
    int 21h                               ; Interrupcion 21h para controlar funciones del S.O.
flujo2:
    mov ax,res                            ; AX = res

    mov cl,4
    call printNumero                      ; Imprime el número

    jmp finish
multiplicacion:
    cmp OPERADOR,'x'
    jne divCociente
    mov ax,num1                           ; AX = num1
    mov bx,num2                           ; BX = num2
    xor dx,dx                             ; DX = 0000h
    mul bx                                ; DX:AX = AX * BX
    mov [mult],ax                         ; [mult] = AX , guarda la parte baja del producto
    mov [mult+2],dx                       ; [mult+2] = DX , guarda la parte alta del producto

    mov ax,mult                           ; AX = mult
    mov bx,10000                          ; BX = 10000
    div bx                                ; DX:AX = AX / BX, separa el producto en dos partes para imprimir el resultado en grupos de 4 digitos

    mov [mAux+2],ax                       ; aux1 = AX, los primeros cuatro digitos
    mov [mAux],dx                         ; aux2 = DX, los últimos cuatro digitos

                                          ; Primeros Cuatro Digitos
    mov ax,[mAux+2]                       ; AX = aux1

    mov cl,4
    call printNumero                      ; Imprime el número

                                          ; Segundos Cuatro Digitos
    mov ax,[mAux]                         ; AX = aux2

    mov cl,4
    call printNumero                      ; Imprime el número

    jmp finish
divCociente:
    cmp OPERADOR,'/'
    jne divResiduo

    mov ax,num1                           ; AX = num1
    mov bx,num2                           ; BX = num2
    cmp bx,0                              ; Compara BX con 0
    je isZero                             ; Si BX == 0, si el divisor es 0 entonces brinca al bloque 'isZero'
    xor dx,dx                             ; DX = 0000h
    div bx                                ; DX:AX = AX / BX
    mov coc,ax                            ; coc = AX
    mov ax,coc                            ; AX = coc

    mov cl,4
    call printNumero                      ; Imprime el número
    jmp finish

isZero:
    mov ah,09h                            ; Prepara registro ah para imprimir un mensaje en pantalla
    lea dx,msjZero                        ; Imprime un mensaje
    int 21h                               ; Interrupcion 21h para controlar funciones del S.O.
    jmp finish

divResiduo:
    cmp OPERADOR,'%'
    jne mouse
    mov ax,num1                           ; AX = num1
    mov bx,num2                           ; BX = num2
    cmp bx,0                              ; Compara BX con 0
    je isZero                             ; Si BX == 0, si el divisor es 0 entonces brinca al bloque 'isZero'
    xor dx,dx                             ; DX = 0000h
    div bx                                ; DX:AX = AX / BX
    mov residuo,dx                        ; residuo = DX

    mov ax,residuo                        ; AX = residuo

    mov cl,4
    call printNumero                      ; Imprime el número
finish:
endm