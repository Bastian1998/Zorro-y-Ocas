extern  printf
extern puts

;macro que recibe un entero y un string (que contiene una variable) y lo muestra por pantalla
%macro mostrarNumeroConString 2
    mov rdi, %1 ;cargo el string
    mov rsi, %2 ;cargo el numero

    sub rsp,8 
    call printf
    add rsp,8

%endmacro

;macro que recibe un string y lo muestra por pantalla
%macro mostrarString 1
    mov rdi, %1 ;cargo el string

    sub rsp,8 
    call printf
    add rsp,8
    
%endmacro

;macro que recibe un entero y lo muestra por pantalla
%macro mostrarNumero 1
    mov rdi, numeroString ;cargo el string
    mov rsi, %1
    sub rsp,8 
    call printf
    add rsp,8
%endmacro

;macro que recibe una fila y una columna y te muestra por pantalla el elemento que contiene "tablero" en esa celda
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

    imul rdx, 2; multiplico por 2 (lo que pesa cada string, 2 bytes)

    ;esto es un truquito para que depende del elemento en la matriz muestra un string u otro (estos estan en la memoria de forma contigua)
    lea rdx , qword[simboloCeldaInvalida + rdx]; copio la direccion de memoria del string correspondiente dependiendo de el elemento 
    mostrarString rdx ; Mostrar el número

    mostrarString simboloEspacio ;muestro un espacio en blanco para hacer mas ligero visualmente el tablero

%endmacro


section  .data
; cada elemento es de 8 bytes. -1 es si es invalido , 0 si la celda esta vacio, 2 si hay una oca, 1 si esta el zorro

    numeroString         db  '%li ', 0
    cantFilas            dq 7
    cantColumnas         dq 7
    longElemento         dq 8
    columnaActual        dq 1
    filaActual           dq 1
    longFila             dq 56
    simboloEspacio       db ' ',0

    ;estan definidas en este orden en especifco con una razon
    simboloCeldaInvalida      db '-',0 
    simboloCeldaVacia         db ' ', 0
    simboloZorro              db 'Z', 0
    simboloOca                db 'O', 0
    simboloOcaSeleccionada    db 'Ø', 0

    ;simbolos auxiliares para dibujar el tablero
    pared                       db '║', 0
    techo                       db '  ╔═══╦═══╦═══╦═══╦═══╦═══╦═══╗', 10, 0
    piso                        db '  ╚═══╩═══╩═══╩═══╩═══╩═══╩═══╝', 10, 0
    pisoIntermedio              db '  ╠═══╬═══╬═══╬═══╬═══╬═══╬═══╣', 10, 0
    columnasString              db '    1   2   3   4   5   6   7', 10, 0
    mensajeCantidadOcasComidas  db 10, 'Cantidad de ocas comidas por el zorro: %li', 10, 0
    mensajeCuantasOcasFaltan    db 10, 'Al zorro le falta comer %li ocas para ganar.', 10, 0
    saltoDeLinea                db 10, 0

                                   
section  .bss

section  .text


mostrarMatriz:
    limpiarPantalla
    mostrarString columnasString; mostramos los numeros de las columnas

    mostrarString techo; mostramos el techo del tablero
    sub rsp, 8
    call recorrerMatriz ;mostramos matriz
    add rsp, 8
    mostrarString piso; mostramos el piso del tablero

    mostrarNumeroConString mensajeCantidadOcasComidas, qword[ocasComidas]; mostramos cantidad ocas comidas

    mov rax, 12
    sub rax, qword[ocasComidas]
    mostrarNumeroConString mensajeCuantasOcasFaltan, rax ; mostramos cuantas ocas faltan por comer para que el zorro gane

    ret

recorrerMatriz:
    mov qword[filaActual], 1 ;la fila actual comienza en 1 antes de mostrar la matriz
    mov qword[columnaActual], 1 ;la columna actual comienza en 1 antes de mostrar la matriz
    mostrarNumero [filaActual]

    jmp recorrerFilas ;vamos a recorrer las filas

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

    mostrarString pisoIntermedio
    mostrarNumero [filaActual]

    jmp recorrerFilas; volvemos a mostrar otra fila

mostrarEstadisticasZorro:
    mostrarString mensajeMostrarEstadistica                      
    mostrarNumeroConString mensajecantMovZorroArriba, qword[cantMovZorroArriba]               
    mostrarNumeroConString mensajecantMovZorroAbajo, qword[cantMovZorroAbajo]          
    mostrarNumeroConString mensajecantMovZorroDerecha, qword[cantMovZorroDerecha]                 
    mostrarNumeroConString mensajecantMovZorroIzquierda, qword[cantMovZorroIzquierda]             
    mostrarNumeroConString mensajecantMovZorroDiagArribaDer, qword[cantMovZorroDiagArribaDer]          
    mostrarNumeroConString mensajecantMovZorroDiagArribaIzq, qword[cantMovZorroDiagArribaIzq]          
    mostrarNumeroConString mensajecantMovZorroDiagAbajoIzq, qword[cantMovZorroDiagAbajoDer]            
    mostrarNumeroConString mensajecantMovZorroDiagAbajoDer, qword[cantMovZorroDiagAbajoIzq]
    ret

finLoop:
    ;terminamos de mostrar la matriz
    ret



    
