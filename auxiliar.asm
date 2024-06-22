
%macro calcularDesplazamineto 2
; %1: Fila actual, %2: Columna actual
    mov     rax, [%1]              ; Cargar fila en rax
    mov     rcx, qword[longFila]   ; Cargar longitud de la fila
    dec     rax                    ; Convertir a índice base 0
    imul    rax, rcx               ; rax = fila * longFila

    mov     rbx, [%2]              ; Cargar columna en rbx
    mov     r8, qword[longElemento]; Cargar longitud del elemento
    dec     rbx                    ; Convertir a índice base 0
    imul    rbx, r8                ; rbx = columna * longElemento

    add     rax, rbx               ; rax = rax + rbx, posición total en el tablero
%endmacro

%macro pedirNumeroAlUsuario 1
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
    jl      %1; si no  es un entero me voy a la parte del codigo pasada por parametro
%endmacro

;macro que muueve el elemento situado en una celda a otra celda, y dejando vacia la celda anterior
%macro moverElemento 4
    ;%1: filaActual, %2: columnaActual, %3 filaObjetivo, %4columnaObjetivo

    calcularDesplazamineto %1, %2
    mov     rdx, qword[tablero + rax] ; Cargar el valor desde tablero[rax]
    mov     qword[aux], rdx         ; guardo en la variable auxiliar el elemento que habia ahi

    mov     qword[tablero + rax], 1 ; marco como vacia esa celda

    calcularDesplazamineto %3, %4
    mov     rbx, qword [aux]    ; Cargar el valor auxiliar en rbx
    mov     qword[tablero + rax], rbx ; Mover el valor de rbx a la celda objetivo
%endmacro

;macro que cambia una celda del tablero por el numero ingreado

%macro cambiarCelda 3
    ;%1: filaActual, %2: columnaActual

    calcularDesplazamineto %1, %2
    mov     qword[tablero + rax], %3 ; marco como vacia esa celda
    
%endmacro

;macro que limpia la pantalla
%macro limpiarPantalla 0
    mov rdi, cdmClear
    sub rsp,8
    call system
    add rsp,8
%endmacro

;macro que reinicia la pantalla y muestra el estado actual del tablero
%macro reiniciarPantalla 0
    limpiarPantalla
    sub rsp, 8
    call mostrarMatriz
    add rsp, 8
%endmacro

;subrutina que se fija el el objetivo esta vacio
verSiEstaVacio:    
    calcularDesplazamineto filaObjetivo, columnaObjetivo
    mov     rdx, qword[tablero + rax] ; Cargar el valor desde tablero[rax]
    
    cmp     qword[tablero + rax], 1; si la celda objetivo es 1(esta vacia)
    je      booleanoTrue; saltamos aca

    mov     qword[booleano], 1; si no ocurrio el booleano tiene que ser 1 (false)

    ret