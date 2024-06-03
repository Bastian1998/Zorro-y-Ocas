extern  printf
extern puts

%macro mostrarString 1
    mov rdi, %1 ;cargo el string
    sub rsp,8 
    call printf
    add rsp,8
%endmacro

%macro mostrarElemento 2
    ; %1: Fila actual, %2: Columna actual

    mostrarString simboloEspacio ;muestro un espacio en blanco para hacer mas clean el tablero

    mov     rax, [%1]              ; Cargar fila en rax
    mov     rcx, qword[longFila]   ; Cargar longitud de la fila
    dec     rax                    ; Convertir a índice base 0
    imul    rax, rcx               ; rax = fila * longFila

    mov     rbx, [%2]              ; Cargar columna en rbx
    mov     r8, qword[longElemento]; Cargar longitud del elemento
    dec     rbx                    ; Convertir a índice base 0
    imul    rbx, r8                ; rbx = columna * longElemento

    add     rax, rbx               ; rax = rax + rbx, posición total en el tablero
    mov     rdx, qword[tablero + rax] ; Cargar el valor desde tablero[rax]

    inc rdx ;sumo 1 para acomodar para buscar el string
    imul rdx, 2; multiplico por 2 (lo que pesa cada string, 2 bytes)

    lea rdx , qword[simboloCeldaInvalida + rdx]; copio la direccion de memoria del string correspondiente dependiendo de el elemento 
    mostrarString rdx ; Mostrar el número

    mostrarString simboloEspacio ;muestro un espacio en blanco para hacer mas clean el tablero

%endmacro


section  .data
; cada elemento es de 8 bytes. -1 es si es invalido , 0 si la celda esta vacio, 2 si hay una oca, 1 si esta el zorro

    numeroString         db  '%li', 0
    cantFilas            dq 7
    cantColumnas         dq 7
    longElemento         dq 8
    columnaActual        dq 1
    filaActual           dq 1
    longFila             dq 56
    simboloEspacio       db ' ',0

    ;estan definidas en este orden en especifco con una razon
    simboloCeldaInvalida db '-',0 
    simboloCeldaVacia    db ' ', 0
    simboloZorro         db 'Z', 0
    simboloOca           db 'O', 0

    ;simbolos auxiliares para dibujar el tablero
    pared                db '|', 0
    techoPiso            db '------------------------------', 10, 0
    saltoDeLinea         db 10, 0

                                   
section  .bss

section  .text


recorrerMatriz:
    mov qword[filaActual], 1
    mov qword[columnaActual], 1
    jmp recorrerFilas

recorrerFilas:
    mostrarString pared; mostramos una pared antes de mostrar un elemento

    mostrarElemento filaActual, columnaActual; mostramos el elemento i,j

    inc qword[columnaActual]; incrementamos en 1 la columna
    cmp qword[columnaActual], 8
    je siguienteFila ; si la columna es <7
    jmp recorrerFilas; saltamos a la siguiente fila

siguienteFila:
    mostrarString pared; mostramos pared al finalizar una linea
    mostrarString saltoDeLinea; saltamos de linea
    mov qword[columnaActual], 1; reiniciamos columnas
    add qword[filaActual], 1; aumentamos en uno la fila
    cmp qword[filaActual], 8
    je finLoop; si fila > 7, damos por finalizada la matriz
    jmp recorrerFilas

finLoop:
    ret


    
