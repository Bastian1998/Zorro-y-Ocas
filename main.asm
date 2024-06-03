global  main


%include 'creacionMatriz.asm'
%include 'moverElemento.asm'
extern  gets
extern  sscanf           

section  .data
        numFormat           db  '%li', 0  ; %i 32 bits / %li 64 bits
        mensajeDireccionesZorro db 10, 'Zorro: Seleccione en que dirección moverse', 10, '8: Adelante', 10, '6: Derecha', 10, '4: Izquierda', 10, '2: Abajo', 10, '9: Diagonal arriba/derecha', 10, '7: Diagonal arriba/izquierda', 10, '1: Diagonal abajo/izquierda', 10, '3: Diagonal abajo/derecha', 10,10, 0
        mensajeDireccionesOca db 10, 'Oca: Seleccione en que dirección moverse', 10, 0

        tablero     dq  -1,-1,2,2,2,-1,-1
                    dq  -1,-1,2,2,2,-1,-1
                    dq   2,2,2,2,2,2,2
                    dq   2,0,0,0,0,0,2
                    dq	 2,0,0,1,0,0,2
                    dq	-1,-1,0,0,0,-1,-1
                    dq	-1,-1,0,0,0,-1,-1

        filaZorro       dq 5
        columnaZorro    dq 4
        filaObjetivo    dq 5
        columnaObjetivo dq 4

section  .bss
        buffer              resb 64
        numAux              resq 1
        booleano            resq 0
section  .text
main:

    sub rsp, 8
    call mostrarMatriz
    add rsp, 8

    sub rsp, 8
    call solicitarMovimiento
    add rsp, 8

    jmp main
    ret
    
mostrarMatriz:
    mostrarString columnasString
    mostrarString techoPiso
    
    sub rsp, 8
    call recorrerMatriz;
    add rsp, 8
    
    mostrarString techoPiso
    ret

solicitarMovimiento:
    mostrarString mensajeDireccionesZorro

     ; Pido al usuario un numero
    mov     rdi, buffer
    sub     rsp, 8
    call    gets
    add     rsp ,8

    ; Verifico que sea entero
    mov     rdi, buffer       ; Parametro 1: campo donde están los datos a leer
    mov     rsi, numFormat    ; Parametro 2: dir del string que contiene los formatos
    mov     rdx, numAux       ; Parametro 3: dir del campo que recibirá el dato formateado
   
    sub     rsp, 8
    call    sscanf
    add     rsp, 8

    ; Si no es entero se lo pido de nuevo
    cmp     rax, 1            ; rax tiene la cantidad de campos que pudo formatear correctamente
    jl      main

    ;aca va contador
    mov     rax, qword[numAux]  

    cmp     rax, 8
    je      movAdelante

    cmp     rax, 6
    je      movDerecha

    cmp     rax, 2
    je      movAbajo

    cmp     rax, 4
    je      movIzq

    cmp     rax, 7
    je      movDiagonalArribaIzquierda

    cmp     rax, 9
    je      movDiagonalArribaDerecha

    cmp     rax, 1
    je      movDiagonalAbajoIzquierda

    cmp     rax, 3
    je      movDiagonalAbajoDerecha

    jmp main
    ret

movAdelante:
    dec qword[filaObjetivo]

    cmp qword[filaObjetivo], 0
    je main

    verSiEstaVacio filaObjetivo, columnaObjetivo
    cmp qword[booleano], 0
    je  moverse

movDerecha:
    inc qword[columnaObjetivo]

    cmp qword[columnaObjetivo], 8
    je main

    verSiEstaVacio filaObjetivo, columnaObjetivo
    cmp qword[booleano], 0
    je  moverse

movAbajo:
    inc qword[filaObjetivo]

    cmp qword[columnaObjetivo], 8
    je main

    verSiEstaVacio filaObjetivo, columnaObjetivo
    cmp qword[booleano], 0
    je  moverse

movArriba:
    dec qword[filaObjetivo]
    verSiEstaVacio filaObjetivo, columnaObjetivo
    cmp qword[booleano], 0
    je  moverse

movIzq:
    dec qword[columnaObjetivo]
    verSiEstaVacio filaObjetivo, columnaObjetivo
    cmp qword[booleano], 0
    je  moverse

movDiagonalArribaDerecha:
    dec qword[filaObjetivo]
    inc qword[columnaObjetivo]
    verSiEstaVacio filaObjetivo, columnaObjetivo
    cmp qword[booleano], 0
    je  moverse

movDiagonalAbajoDerecha:
    inc qword[filaObjetivo]
    inc qword[columnaObjetivo]
    verSiEstaVacio filaObjetivo, columnaObjetivo
    cmp qword[booleano], 0
    je  moverse

movDiagonalAbajoIzquierda:
    dec qword[filaObjetivo]
    verSiEstaVacio filaObjetivo, columnaObjetivo
    cmp qword[booleano], 0
    je  moverse


moverse:
    ;aca
    moverElemento filaZorro, columnaZorro, filaObjetivo, columnaObjetivo
    mov rax, [filaObjetivo]
    mov rbx, [columnaObjetivo]
    mov qword[filaZorro], rax
    mov qword[columnaZorro], rbx
    jmp main




