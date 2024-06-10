
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

    mov     qword[tablero + rax], 1 ; marco como vacia esa celda
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

;macro que cambia una celda del tablero por el numero ingreado

%macro cambiarCelda 3
    ;%1: filaActual, %2: columnaActual

    mov     rax, [%1]              ; Cargar fila actual en rax
    mov     rcx, qword[longFila]   ; Cargar longitud de la fila
    dec     rax                    ; Convertir a índice base 0
    imul    rax, rcx               ; rax = fila * longFila

    mov     rbx, [%2]              ; Cargar columna actual en rbx
    mov     r8, qword[longElemento]; Cargar longitud del elemento
    dec     rbx                    ; Convertir a índice base 0
    imul    rbx, r8                ; rbx = columna * longElemento

    add     rax, rbx               ; rax = rax + rbx, posición total en el tablero
    mov     qword[tablero + rax], %3 ; marco como vacia esa celda
    
%endmacro

;macro que limpia la pantalla
%macro limpiarPantalla 0
    mov rdi, cdmClear
    sub rsp,8
    call system
    add rsp,8
%endmacro

;subrutina que se fija el el objetivo esta vacio
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
    
    cmp     qword[tablero + rax], 1; si la celda objetivo es 1(esta vacia)
    je      booleanoTrue; saltamos aca

    mov     qword[booleano], 1; si no ocurrio el booleano tiene que ser 1 (false)

    ret