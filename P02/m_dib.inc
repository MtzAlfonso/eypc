; Cambia la resolucion de pantalla a modo texto ademas de limpiarla
modoText macro
    mov ah,0
    mov al,3
    int 10h
endm

modoGraf macro
    mov ah,0
    mov al,13H
    int 10H
endm

escribir macro CHAR,R,C,COL
    mov ah,0Bh
    mov bh,0h
    mov bl,3
    int 10h
    mov ah,2
    mov bh,0
    mov dh,R
    mov dl,C
    int 10h
    mov ah,9
    mov al,CHAR
    mov bl,COL
    mov cx,1
    int 10h
endm

limpiar macro
    mov cx,0
    mov dx,0
    mov ax,0
    mov bx,0
endm

lineahor macro X,Y,Z,C                  ; linea Horizontal de x a y en z FIJA
    LOCAL L1

    mov cx,X
    mov dx,Z

L1:
    mov ah,0CH
    mov al,C
    int 10H
    inc CX
    cmp CX,Y
    jnz L1
endm

lineaver macro X,Y,Z,C                  ; linea vertical de x a y FIJA
    LOCAL L2

    mov cx,Z
    mov dx,X

L2:
    mov ah,0CH
    mov al,C
    int 10H
    inc DX
    cmp DX,Y
    jnz L2
endm

dibu1 macro X,Y,Z,C                     ; linea vertical de x a y
    LOCAL L2

    mov cx,Z
    mov dx,X

L2:
    mov ah,0CH
    mov al,C
    int 10H

    inc DX
    inc CX
    cmp DX,Y
    jnz L2
endm

dibu2 macro X,Y,Z,C                     ; linea vertical de x a y fija
    LOCAL L2

    mov cx,Z
    mov dx,Y

L2:
    mov ah,0CH
    mov al,C
    int 10H

    dec DX
    inc CX
    cmp DX,X
    jnz L2
endm

; Dibujamos el rectangulo de afuera
diburect macro
    limpiar
    lineahor 4,254,4,1                  ; Primero alarga la linea horizontal (bajo) corto (alto)
    limpiar
    lineahor 4,255,194,1
    limpiar
    lineaver 4,194,4,1
    limpiar
    lineaver 4,194,254,1
    limpiar
endm

; Dibuja caja
caja macro
    limpiar
    lineahor 9,249,9,7                  ; El ultimo valor es el color
    limpiar
    lineahor 9,250,69,7                 ; El primero es hacia arriba
    limpiar
    lineaver 9,69,9,7                   ; El segundo hacia abajo
    limpiar
    lineaver 9,69,249,7                 ; La tercera linea divisioria de altura
    limpiar
endm

; DIBUJAMOS BOTONES
dibujarboton macro X, Y, C              ; 40 pixeles de ancho x 25 de alto
    limpiar
    lineahor Y,(Y+39),X,C
    limpiar
    lineahor Y,(Y+39),(X+24),C
    limpiar
    lineaver X,(X+24),Y,C
    limpiar
    lineaver X,(X+25),(Y+39),C
    limpiar
endm

botontipo macro X, Y, C
    limpiar
    lineahor Y,(Y+39),X,C
    limpiar
    lineahor Y,(Y+39),(X+35+25+25),C    ; linea horizontal  inf tamaño
    limpiar
    lineaver X,(X+35+25+25),Y,C
    limpiar
    lineaver X,(X+35+25+25),(Y+39),C
    limpiar
endm

botones macro
    ; botones izquierdos
    dibujarboton 74,9,15                ; boton 7: renglon=74,columna=9,Color=15(modo grafico)
    dibujarboton 104,9,15               ; boton 4: renglon=104,columna=9,Color=15(modo grafico)
    dibujarboton 134,9,15               ; boton 1: renglon=134,columna=9,Color=15(modo grafico)
    dibujarboton 164,9,40               ; boton AC: renglon=164,columna=9,Color=40(modo grafico)

    ; botones de en medio
    dibujarboton 74,59,15
    dibujarboton 104,59,15
    dibujarboton 134,59,15
    dibujarboton 164,59,15
    
    dibujarboton 164,109,40             ; boton derecho inferior
    dibujarboton 74,109,15
    dibujarboton 104,109,15
    dibujarboton 134,109,15

    dibujarboton 74,159,100
    dibujarboton 104,159,100
    dibujarboton 134,159,100
    dibujarboton 164,159,100

    ; botones derechos
    dibujarboton 74,209,100             ; boton izquierdo
    botontipo 104,209,10

    escribir '0',22,9,15
    escribir '1',18,3,15
    escribir '2',18,9,31
    escribir '3',18,16,15

    escribir '4',14,3,31
    escribir '5',14,9,31

    escribir '6',14,16,31

    escribir '7',10,3,31
    escribir '8',10,9,31
    escribir '9',10,16,31

    escribir 'x',10,22,100
    escribir '/',14,22,100
    escribir '-',18,22,100
    escribir '+',22,22,100

    escribir '%',10,28,100

    escribir '=',18,28,10               ; moviendo

    escribir 'A',22,3,40
    escribir 'C',22,4,40

    escribir 'D',22,15,40
    escribir 'E',22,16,40
    escribir 'L',22,17,40

    escribir 'X',0,30,40

endm

raton macro
    mov ax,00h
    int 33h                             ; Inicializa mouse
    mov ax,01h
    int 33h                             ; Muestra puntero del mouse
endm

; ;;;;;;;;;;;;;;;;;;;;;;;;
revisaClicIzquierdo macro
    local raton_no_presionado, lee_raton
raton_no_presionado:
    mov ax,0003h
    int 33h
    test bx,0001h                       ; Realiza una conjunción, bit por bit, de los operandos, pero a diferencia de AND esta instrucción
                                        ; no coloca el resultado en el operando destino, solo tiene efecto sobre el estado de las banderas.
    jnz raton_no_presionado             ; se cicla en raton_no_presionado mientras el clic izquierdo del raton esta presionado

lee_raton:
    mov ax,0003h
    int 33h
    test bx,0001h                       ; Realiza una conjunción, bit por bit, de los operandos, pero a diferencia de AND esta instrucción
                                        ; no coloca el resultado en el operando destino, solo tiene efecto sobre el estado de las banderas.
    jz lee_raton                        ; se cicla en lee_raton mientras el clic izquierdo del raton esta liberado

    res640x200_a_res320x200
endm

; Las coordenadas que devuelve la posicion del raton estan en resolucion 640x200
; La resolucion de la interfaz grafica es 320x200
; Esta macro hace la conversion de las coordenadas de resolucion 640x200 a 320x200
; Esta macro debe estar precedida por la int 33h con opcion 0003h con la cual se obtienen las coordenadas en los registros CX y DX
res640x200_a_res320x200 macro
    ; El valor de la coordenada en Y (renglon) permanece en DX ya que en ambas resoluciones el maximo es el mismo
    ; DX contiene el valor del renglon del mouse

    ; El valor de la coordenada en X (columna) pasa de resolucion 640 a un maximo de 320
    ; El valor del registro CX se divide a la mitad para hacer la conversion

    ; En sistema binario, un corrimiento a la derecha equivale a una division entre dos,
    ; por lo tanto se realiza un corrimiento a la derecha del valor de CX
    shr cx,1
endm
; ;;;;;;;;;;;;;;;;;;;;;;;;