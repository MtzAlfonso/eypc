title "Proyecto 02 - Calculadora"
    .model small
    .386
    .stack 64
.data
    ; variables para almacenar los numeros y los resultados
    num1                dw      0
    num2                dw      0
    sum 		        dw 		0
    res 		        dw 		0
    mult 		        dw		0,0
    coc			        dw 		0
    residuo		        dw 		0

    diezmil		        dw		10000d
    mil			        dw		1000d
    cien 		        dw 		100d
    diez		        dw		10d

    temp                dw      0
    nega 		        db 		0
    bandera             db      0

    clear               db      20h,20h,20h,20h

    num 		        dw      0          ; Almacena el valor de num1 o num2 según lo requiera el procedimiento impr
    aux1                db      0,0,0,0    ; Almacena los digitos del primer numero
    aux2                db      0,0,0,0    ; Almacena los digitos del segundo numero
    mAux 		        dw 	    0,0

    num_boton           db      0          ; Almacena el digitos del numero presionado
    conta1              dw      0          ; Contador para determinar cuantos digitos se han introducido del primer numero
    conta2              dw      0          ; Contador para determinar cuantos digitos se han introducido del segundo numero
    operador            db      0          ; Almacena el operando seleccionado de la operacion

    msjZero 	        db	    "N/D","$"
    clean 		        db 	    "               ","$"

    col_aux             db      0          ; Variable auxiliar para el manejo de coordenadas del mouse (columna)
    ren_aux             db      0          ; Variable auxiliar para el manejo de coordenadas del mouse (renglon)

.code

    include m_dib.inc
    include m_func.inc
    include proced.inc

inicio:
    mov ax,@data
    mov ds,ax

    modoGraf                               ; rectangulo inicial
    diburect                               ; pantallita
    caja                                   ; dibuja cuadrado
    botones
    escribir '=',5,2,14                    ; escribe caracter en pantalla
    raton

mouse:
    revisaClicIzquierdo
    ; Al final de la macro anterior, obtenemos las coordenadas del mouse
    ; DX es el numero del renglon, que puede ser desde 0 hasta 200
    ; CX es el numero de la columna, que puede ser desde 0 hasta 320

    ; Revisar si el mouse se presiono en X para cerrar
    ; ;En res 320x200, X inicia en (240,0) y termina en (247,8)
    cmp dx,8
    jle botonX

    ; Rango de columnas en donde esta la primera columna de botones (botones izquierdos)
    ; minimo 9, ya se hizo la comparacion por ese valor anteriormente
    ; maximo 48
    cmp cx,48
    jle botones_AC_1_4_7

    cmp cx,98
    jle botones_0_2_5_8

    cmp cx,148
    jle botones_C_3_6_9

    cmp cx,198
    jle botones_operaciones

    cmp cx,248
    jle botones_operaciones2

    jmp mouse
botones_AC_1_4_7:
    ; Ya se compararon columnas, ahora renglones

    ; Coordenadas del boton 1
    ; Esquina superior izquierda: (134,9) renglon,columna
    ; Esquina inferior derecha: (158,48) renglon,columna
    cmp dx,98
    jle boton7
    cmp dx,128
    jle boton4
    cmp dx,158
    jle boton1
    cmp dx,188
    jle botonAC
    ; Si DX es menor a 158, es posible que se haya presionado sobre el boton 1
    ; pero aun no es seguro porque puede ser menor a 134
    ; si cumple, salta a boton1 donde se haran mas comparaciones
botones_0_2_5_8:
    cmp dx,98
    jle boton8
    cmp dx,128
    jle boton5
    cmp dx,158
    jle boton2
    cmp dx,188
    jle boton0
botones_C_3_6_9:
    cmp dx,98
    jle boton9
    cmp dx,128
    jle boton6
    cmp dx,158
    jle boton3
    cmp dx,188
    jle botonC
botones_operaciones:
    cmp dx,98
    jle botonMultiplicacion
    cmp dx,128
    jle botonDivisionCociente
    cmp dx,158
    jle botonResta
    cmp dx,188
    jle botonSuma
botones_operaciones2:
    cmp dx,98
    jle botonDivisionResiduo
    cmp dx,188
    jle botonResultado

boton7:
    isButton 9,49,74,98
    mov [num_boton],7
    jmp lee_num1
boton4:
    isButton 9,49,104,128
    mov [num_boton],4
    jmp lee_num1
boton1:
    isButton 9,49,134,158
    mov [num_boton],1
    jmp lee_num1
botonAC:
    isButton 9,49,164,188
borrar:
    cmp conta1,0
    je salto
    borra conta1,2
    cmp conta2,0
    je salto
    borra conta2,4
salto:
    escribir '',3,2,14                     ; escribe caracter en pantalla
    borraResultado
    mov aux1,0
    mov aux2,0
    mov conta1,0
    mov conta2,0
    mov ren_aux,0
    mov col_aux,0
    mov operador,0
    mov num1,0
    mov num2,0
    mov bandera,0
    jmp mouse

boton8:
    isButton 59,99,74,98
    mov [num_boton],8
    jmp lee_num1
boton5:
    isButton 59,99,104,128
    mov [num_boton],5
    jmp lee_num1
boton2:
    isButton 59,99,134,158
    mov [num_boton],2
    jmp lee_num1
boton0:
    isButton 59,99,164,188
    mov [num_boton],0
    jmp lee_num1

boton9:
    isButton 109,149,74,98
    mov [num_boton],9
    jmp lee_num1
boton6:
    isButton 109,149,104,128
    mov [num_boton],6
    jmp lee_num1
boton3:
    isButton 109,149,134,158
    mov [num_boton],3
    jmp lee_num1
botonC:
    isButton 109,149,164,188
    cmp [bandera],0
    jne borrar
    cmp [operador],0
    jne botonC2
    cmp conta1,0
    je mouse
    borra conta1,2
    dec conta1
    jmp w
botonC2:
    cmp conta2,0
    je mouse
    borra conta2,4
    dec conta2
    cmp conta2,0
    jne x
    escribir '',3,2,14                     ; escribe caracter en pantalla
    mov [operador],0
    mov [ren_aux],2
    mov [col_aux],29
    mov aux2,0


botonX:
    isButton 240,247,0,8
    jmp salir

botonMultiplicacion:
    isButton 159,198,74,98
    cmp [conta1],0
    je mouse
    mov [operador],'x'
    escribir [operador],3,2,14             ; escribe caracter en pantalla
botonDivisionCociente:
    isButton 159,198,104,128
    cmp [conta1],0
    je mouse
    mov [operador],'/'
    escribir [operador],3,2,14             ; escribe caracter en pantalla
botonResta:
    isButton 159,198,134,158
    cmp [conta1],0
    je mouse
    mov [operador],'-'
    escribir [operador],3,2,14             ; escribe caracter en pantalla
botonSuma:
    isButton 159,198,164,188
    cmp [conta1],0
    je mouse
    mov [operador],'+'
    escribir [operador],3,2,14             ; escribe caracter en pantalla

botonDivisionResiduo:
    isButton 209,248,74,98
    cmp [conta1],0
    je mouse
    mov [operador],'%'
    escribir [operador],3,2,14             ; escribe caracter en pantalla
botonResultado:
    isButton 209,248,104,188
    cmp [conta2],0
    je mouse
    call procesarNumero1
    mov num1,ax
    call procesarNumero2
    mov num2,ax
    borraResultado
    operacion [operador]
    mov bandera,1
no_lee_num:
    jmp mouse
lee_num1:
    cmp [bandera],0
    jne mouse
    cmp [operador],0                       ; compara el valor del operador que puede ser 0, '+', '-', '*', '/', '%'
    jne lee_num2                           ; Si el operador es diferente de 0, entonces lee el segundo numero
    cmp [conta1],4                         ; compara si el contador para num1 llego al maximo
    jae no_lee_num                         ; si conta1 es mayor o igual a 4, entonces se ha alcanzado el numero de digitos
                                           ; y no hace nada
    mov al,num_boton                       ; valor del boton presionado en AL
    mov di,[conta1]                        ; copia el valor de conta1 en registro indice DI
    mov [aux1+di],al                       ; num1 es un arreglo de tipo byte
                                           ; se utiliza di para acceder el elemento di-esimo del arreglo num1
                                           ; se guarda el valor del boton presionado en el arreglo
    inc [conta1]                           ; incrementa conta1 por numero correctamente leido
w:
    ; Se imprime el numero del arreglo num1 de acuerdo a conta1
    xor di,di                              ; limpia DI para utilizarlo
    mov cx,[conta1]                        ; prepara CX para loop de acuerdo al numero de digitos introducidos
    mov [ren_aux],2                        ; variable ren_aux para poner cursor en pantalla
                                           ; ren_aux se mantiene fijo a lo largo del siguiente loop
                                           ; Loop para imprimir numero

imprime_num1:
    push cx                                ; guarda el valor de CX en la pila
    cmp conta1,0
    je mouse
    mov [col_aux],30                       ; variable col_aux para mover cursor en pantalla
    sub [col_aux],cl                       ; Para calcular la columna en donde comienza a imprimir en pantalla de acuerdo a CX
    mov cl,[aux1+di]                       ; copia el digito en CL
    add cl,30h                             ; Pasa valor a ASCII
    escribir cl,[ren_aux],[col_aux],15     ; escribe caracter en pantalla
    inc di                                 ; incrementa DI para recorrer el arreglo num1
    pop cx                                 ; recupera el valor de CX al inicio del loop
    loop imprime_num1
    ; Fin loop
    jmp mouse

    ; ;;;;;;;;;;;;;;;;;;;;
    ; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ; ;;;;;;;;;;;;;;;;;;;;

    ; lee_num2:
    ; AGREGAR LOGICA PARA EL SEGUNDO NUMERO
  no_lee_num2:
    jmp mouse
lee_num2:
    cmp [conta2],4                         ; compara si el contador para num2 llego al maximo
    jae no_lee_num2                        ; si conta1 es mayor o igual a 4, entonces se ha alcanzado el numero de digitos
                                           ; y no hace nada
    mov al,num_boton                       ; valor del boton presionado en AL
    mov di,[conta2]                        ; copia el valor de conta1 en registro indice DI
    mov [aux2+di],al                       ; num2 es un arreglo de tipo byte
                                           ; se utiliza di para acceder el elemento di-esimo del arreglo num2
                                           ; se guarda el valor del boton presionado en el arreglo
    inc [conta2]                           ; incrementa conta1 por numero correctamente leido
x:
    ; Se imprime el numero del arreglo num2 de acuerdo a conta1
    xor di,di                              ; limpia DI para utilizarlo
    mov cx,[conta2]                        ; prepara CX para loop de acuerdo al numero de digitos introducidos
    mov [ren_aux],4                        ; variable ren_aux para poner cursor en pantalla
                                           ; ren_aux se mantiene fijo a lo largo del siguiente loop
                                           ; Loop para imprimir numero

imprime_num2:
    push cx                                ; guarda el valor de CX en la pila
    cmp conta2,0
    je mouse
    mov [col_aux],30                       ; variable col_aux para mover cursor en pantalla
                                           ; para recorrer la pantalla al imprimir el numero
    sub [col_aux],cl                       ; Para calcular la columna en donde comienza a imprimir en pantalla de acuerdo a CX
    mov cl,[aux2+di]                       ; copia el digito en CL
    add cl,30h                             ; Pasa valor a ASCII
    escribir cl,[ren_aux],[col_aux],15     ; escribe caracter en pantalla
    inc di                                 ; incrementa DI para recorrer el arreglo num2
    pop cx                                 ; recupera el valor de CX al inicio del loop
    loop imprime_num2
    ; Fin loop
    jmp mouse

salir:
  modoText                                 ; Para limpiar la pantalla y devolverla a su estado original
                                           ; para salir del programa sin tener que apagar DOS
  mov ah, 4Ch
  mov al, 0
  int 21h

  end inicio