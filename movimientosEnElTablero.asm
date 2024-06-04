extern  printf
extern puts

;macro que muueve el elemento situado en una celda a otra celda, y dejando vacia la celda anterior
%macro moverElemento 4
    ;%1: filaActual, %2: columnaActual, %3 filaObjetivo, %4columnaObjetivo

    mov     rax, [%1]              ; Cargar fila actual en rax
    mov     rcx, qword[longFila]   ; Cargar longitud de la fila
    dec     rax                    ; Convertir a índice base 0
    imul    rax, rcx               ; rax = fila * longFila

    mov     rbx, [%2]              ; Cargar columna actual en rbx
    mov     r8, qword[longElemento]; Cargar longitud del elemento
    dec     rbx                    ; Convertir a índice base 0
    imul    rbx, r8                ; rbx = columna * longElemento

    add     rax, rbx               ; rax = rax + rbx, posición total en el tablero
    mov     rdx, qword[tablero + rax] ; Cargar el valor desde tablero[rax]
    mov     qword[aux], rdx         ; guardo en la variable auxiliar el elemento que habia ahi

    mov     qword[tablero + rax], 0 ; marco como vacia esa celda
    mov     rax, [%3]              ; Cargar fila objetivo en rax
    mov     rcx, qword[longFila]   ; Cargar longitud de la fila
    dec     rax                    ; Convertir a índice base 0
    imul    rax, rcx               ; rax = fila * longFila

    mov     rbx, [%4]              ; Cargar columna objetivo en rbx
    mov     r8, qword[longElemento]; Cargar longitud del elemento
    dec     rbx                    ; Convertir a índice base 0
    imul    rbx, r8                ; rbx = columna * longElemento

    add     rax, rbx               ; rax = rax + rbx, posición total en el tablero
    
    mov     rbx, qword [aux]    ; Cargar el valor auxiliar en rbx
    mov     qword[tablero + rax], rbx ; Mover el valor de rbx a la celda objetivo
%endmacro

section  .data
    filaZorro       dq 5 ;fila actual del zorro
    columnaZorro    dq 4 ;columna actual del zorro
    filaObjetivo    dq 5 ;fila a la que se quiere mover el zorro
    columnaObjetivo dq 4 ;columna a la que se quiere mover el zorro
    numFormat           db  '%li', 0  ; %i 32 bits / %li 64 bits
    mensajeDireccionesZorro db 10, 'Zorro: Seleccione en que dirección moverse', 10, '8: Arriba', 10, '6: Derecha', 10, '4: Izquierda', 10, '2: Abajo', 10, '9: Diagonal arriba/derecha', 10, '7: Diagonal arriba/izquierda', 10, '1: Diagonal abajo/izquierda', 10, '3: Diagonal abajo/derecha', 10,10, 0
    mensajeDireccionesOca db 10, 'Oca: Seleccione en que dirección moverse', 10, 0
       
section  .bss
    aux                 resq 1
    buffer              resb 64
    numQueIngreso       resq 1
    booleano            resq 1

section  .text

booleanoTrue:
    mov qword[booleano], 0; si se llamo a esta subrutina el booleano tiene que convertirse en 0 (true)
    
    ret

verSiEstaVacio:    
    mov     rax, [filaObjetivo]    ; Cargar fila actual en rax
    mov     rcx, qword[longFila]   ; Cargar longitud de la fila
    dec     rax                    ; Convertir a índice base 0
    imul    rax, rcx               ; rax = fila * longFila

    mov     rbx, [columnaObjetivo]              ; Cargar columna actual en rbx
    mov     r8, qword[longElemento]; Cargar longitud del elemento
    dec     rbx                    ; Convertir a índice base 0
    imul    rbx, r8                ; rbx = columna * longElemento

    add     rax, rbx               ; rax = rax + rbx, posición total en el tablero
    mov     rdx, qword[tablero + rax] ; Cargar el valor desde tablero[rax]
    
    cmp     qword[tablero + rax], 0; si la celda objetivo es 0(esta vacia)
    je      booleanoTrue; saltamos aca
    mov     qword[booleano], 1; si no ocurrio el booleano tiene que ser 1 (false)

    ret

solicitarMovimiento:

    mostrarString mensajeDireccionesZorro

    ;Pido al usuario un numero
    mov     rdi, buffer
    sub     rsp, 8
    call    gets
    add     rsp ,8

    ; Verifico que sea entero
    mov     rdi, buffer       ; Parametro 1: campo donde están los datos a leer
    mov     rsi, numFormat    ; Parametro 2: dir del string que contiene los formatos
    mov     rdx, numQueIngreso ; Parametro 3: dir del campo que recibirá el dato formateado
   
    sub     rsp, 8
    call    sscanf
    add     rsp, 8

    ; Si no es entero se lo pido de nuevo
    cmp     rax, 1            ; rax tiene la cantidad de campos que pudo formatear correctamente
    jl      noMoverse

    ; aca preguntamos que teca valida ingreso y saltamso a la parte correspondiente, si no ingresa nada valido, no hacemos nada
    cmp     qword[numQueIngreso], 8
    je      movArriba

    cmp     qword[numQueIngreso], 6
    je      movDerecha

    cmp     qword[numQueIngreso], 2
    je      movAbajo

    cmp     qword[numQueIngreso], 4
    je      movIzquierda

    cmp     qword[numQueIngreso], 7
    je      movDiagonalArribaIzquierda

    cmp     qword[numQueIngreso], 9
    je      movDiagonalArribaDerecha

    cmp     qword[numQueIngreso], 1
    je      movDiagonalAbajoIzquierda

    cmp     qword[numQueIngreso], 3
    je      movDiagonalAbajoDerecha

    ret


; aca dependiendo que ingreso, modificamos la fila y/o columna correspondiente. Validamos que no se salio del limite y si la celda objetivo esta vacia.
; si esto se cumple, movemos el zorro a esa direccion. Sino, no movemos nada
movArriba:
    dec qword[filaObjetivo]

    cmp qword[filaObjetivo], 0
    je noMoverse

    sub     rsp, 8
    call    verSiEstaVacio
    add     rsp ,8

    cmp qword[booleano], 0
    je  moverse

    jmp noMoverse

movDerecha:
    inc qword[columnaObjetivo]
    
    cmp qword[columnaObjetivo], 8
    je noMoverse

    sub     rsp, 8
    call    verSiEstaVacio
    add     rsp ,8

    cmp qword[booleano], 0
    je  moverse

    jmp noMoverse
movAbajo:
    inc qword[filaObjetivo]

    cmp qword[filaObjetivo], 8
    je noMoverse

    sub     rsp, 8
    call    verSiEstaVacio
    add     rsp ,8

    cmp qword[booleano], 0
    je  moverse

    jmp noMoverse

movIzquierda:
    dec qword[columnaObjetivo]

    cmp qword[columnaObjetivo], 0
    je noMoverse

    sub     rsp, 8
    call    verSiEstaVacio
    add     rsp ,8

    cmp qword[booleano], 0
    je  moverse

    jmp noMoverse

movDiagonalArribaDerecha:
    dec qword[filaObjetivo]
    inc qword[columnaObjetivo]

    cmp qword[columnaObjetivo], 8
    je noMoverse

    sub     rsp, 8
    call    verSiEstaVacio
    add     rsp ,8

    cmp qword[booleano], 0
    je  moverse

    jmp noMoverse

movDiagonalAbajoDerecha:
    inc qword[filaObjetivo]
    inc qword[columnaObjetivo]

    cmp qword[columnaObjetivo], 8
    je noMoverse

    sub     rsp, 8
    call    verSiEstaVacio
    add     rsp ,8
    
    cmp qword[booleano], 0
    je  moverse

    jmp noMoverse

movDiagonalArribaIzquierda:
    dec qword[filaObjetivo]
    dec qword[columnaObjetivo]

    cmp qword[columnaObjetivo], 8
    je noMoverse

    sub     rsp, 8
    call    verSiEstaVacio
    add     rsp ,8

    cmp qword[booleano], 0
    je  moverse

    jmp noMoverse

movDiagonalAbajoIzquierda:
    inc qword[filaObjetivo]
    dec qword[columnaObjetivo]

    cmp qword[columnaObjetivo], 0
    je main

    sub     rsp, 8
    call    verSiEstaVacio
    add     rsp ,8

    cmp qword[booleano], 0
    je  moverse

    jmp noMoverse


moverse:
    moverElemento filaZorro, columnaZorro, filaObjetivo, columnaObjetivo; movemos el elemento en el tablero
    
    ;actualizamos la posicion del zorro por la posicion a la que se acaba de mover
    mov rax, qword[filaObjetivo]
    mov rbx, qword[columnaObjetivo]
    mov qword[filaZorro], rax
    mov qword[columnaZorro], rbx
    jmp volverAPedirMovimiento

noMoverse:
    ;actualizamos la columna y fila objeitov por si las modificamos y no decidimos movernos
    mov rax, qword[filaZorro]
    mov rbx, qword[columnaZorro]
    mov qword[filaObjetivo], rax
    mov qword[columnaObjetivo], rbx
    jmp volverAPedirMovimiento

volverAPedirMovimiento:
    ;retornamos al punto donde estabamos
    ret



