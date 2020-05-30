procesarNumero1 proc
    xor ah,ah          ; limpia la parte alta del registro AX
    mov al,[aux1]      ; AL = um
    mov bx,1000        ; BX = 1000
    mul bx             ; DX:AX = AX * BX
    mov num,ax         ; num = AX

    xor ah,ah          ; limpia la parte alta del registro AX
    mov al,[aux1+1]    ; AL = c
    mov bl,100         ; BL = 100
    mul bl             ; AX = AL * BL
    add num,ax         ; num1 = num1 + AX

    xor ah,ah          ; limpia la parte alta del registro AX
    mov al,[aux1+2]    ; AL = d
    mov bl,10          ; BL = 10
    mul bl             ; AX = AL * BL
    add num,ax         ; num1 = num1 + AX

    xor ah,ah          ; limpia la parte alta del registro AX
    mov al,[aux1+3]    ; AL = u
    add num,ax         ; num1 = num1 + AX

    mov cx,conta1
    xor ch,ch
    cmp cl,1           ; Compara CL con 1
    je i1              ; Si Cl == 1 entonces salta a i1
    cmp cl,2           ; Compara CL con 2
    je i2              ; Si Cl == 2 entonces salta a i2
    cmp cl,3           ; Compara CL con 3
    je i3              ; Si Cl == 3 entonces salta a i3
    cmp cl,4           ; Compara CL con 4
    je flujo           ; Si Cl == 4 entonces salta a flujo3
i1:
    mov ax,num         ; AX = num1
    mov bx,mil         ; BX = 1000
    xor dx,dx
    div bx             ; DX:AX = AX / BX
    mov num,ax         ; num = AX
    jmp flujo          ; Salta a flujo3
i2:
    mov ax,num         ; AX = num1
    mov bx,cien        ; BX = 100
    xor dx,dx
    div bx             ; DX:AX = AX / BX
    mov num,ax         ; num = AX
    jmp flujo          ; Salta a flujo3
i3:
    mov ax,num         ; AX = num1
    mov bx,diez        ; BX = 10
    xor dx,dx
    div bx             ; DX:AX = AX / BX
    mov num,ax         ; num = AX
    jmp flujo          ; Salta a flujo3
flujo:
    mov ax,num
    ret
endp procesarNumero1

procesarNumero2 proc
    xor ah,ah          ; limpia la parte alta del registro AX
    mov al,[aux2]      ; AL = um
    mov bx,1000        ; BX = 1000
    mul bx             ; DX:AX = AX * BX
    mov num,ax         ; num = AX

    xor ah,ah          ; limpia la parte alta del registro AX
    mov al,[aux2+1]    ; AL = c
    mov bl,100         ; BL = 100
    mul bl             ; AX = AL * BL
    add num,ax         ; num1 = num1 + AX

    xor ah,ah          ; limpia la parte alta del registro AX
    mov al,[aux2+2]    ; AL = d
    mov bl,10          ; BL = 10
    mul bl             ; AX = AL * BL
    add num,ax         ; num1 = num1 + AX

    xor ah,ah          ; limpia la parte alta del registro AX
    mov al,[aux2+3]    ; AL = u
    add num,ax         ; num1 = num1 + AX

    mov cx,conta2
    xor ch,ch
    cmp cl,1           ; Compara CL con 1
    je i1              ; Si Cl == 1 entonces salta a i1
    cmp cl,2           ; Compara CL con 2
    je i2              ; Si Cl == 2 entonces salta a i2
    cmp cl,3           ; Compara CL con 3
    je i3              ; Si Cl == 3 entonces salta a i3
    cmp cl,4           ; Compara CL con 4
    je flujo2          ; Si Cl == 4 entonces salta a flujo3
j1:
    mov ax,num         ; AX = num1
    mov bx,mil         ; BX = 1000
    xor dx,dx
    div bx             ; DX:AX = AX / BX
    mov num,ax         ; num = AX
    jmp flujo2         ; Salta a flujo3
j2:
    mov ax,num         ; AX = num1
    mov bx,cien        ; BX = 100
    xor dx,dx
    div bx             ; DX:AX = AX / BX
    mov num,ax         ; num = AX
    jmp flujo2         ; Salta a flujo3
j3:
    mov ax,num         ; AX = num1
    mov bx,diez        ; BX = 10
    xor dx,dx
    div bx             ; DX:AX = AX / BX
    mov num,ax         ; num = AX
    jmp flujo2         ; Salta a flujo3
flujo2:
    mov ax,num
    ret
endp procesarNumero2

printDigito macro char ; macro para imprimir un digito
    mov ah,02h         ; AH = 02H, prepara AH para imprimir un caracter
    mov dl,char        ; DL = AL, AL contiene el caracter a imprimir
    add dl,30h         ; DL = DL + 30h para obtener el equivalente en codigo ASCII
    int 21h            ; Interrupcion 21h para controlar funciones del S.O.
endm printDigito

printNumero proc       ; procedimiento para imprimir el número completo
    cmp cl,5           ; Compara CL con 5
    jb imprime4        ; Si CL < 5 entonces imprime solo 4 dígitos

    mov bx,diezmil     ; BX = 10000
    xor dx,dx          ; DX = 0000h
    div bx             ; DX:AX = AX / BX
    mov temp,dx        ; temp = DX

    printDigito al

    mov ax,temp        ; AX = temp
imprime4:
    mov bx,mil         ; BX = 1000
    xor dx,dx          ; DX = 0000h
    div bx             ; DX:AX = AX / BX
    mov temp,dx        ; temp = DX

    printDigito al

    mov ax,temp        ; AX = temp

    mov bx,cien        ; BX = 100
    xor dx,dx          ; DX = 0000h
    div bx             ; DX:AX = AX / BX
    mov temp,dx        ; temp = DX

    printDigito al

    mov ax,temp        ; AX = temp

    mov bx,diez        ; BX = 10
    xor dx,dx          ; DX = 0000h
    div bx             ; DX:AX = AX / BX
    mov temp,dx        ; temp = DX

    printDigito al

    mov ax,temp        ; AX = temp

    printDigito al

    ret
endp printNumero