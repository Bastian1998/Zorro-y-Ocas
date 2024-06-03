extern  printf
extern puts

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


%macro verSiEstaVacio 2
    ;%1: fila, %2: columna

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
    cmp     rdx, 0
    je      booleanoTrue
    mov     qword[booleano], 1

%endmacro


section  .data
    elementoVacio dq 0
       
section  .bss
    aux resq 1

section  .text

booleanoTrue:
    mov qword[booleano], 0

