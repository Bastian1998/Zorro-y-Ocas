extern puts

;macro que mueve el contenido de una posicion de memoria a otra
%macro moverElemento 2
    ;%1origen %2destino
    mov rax, qword[%1]
    mov [%2], rax
%endmacro

section  .data
    mensajeMenuCambioOrientacion db 10, 10, 'Presione la opcion deseada: ',10,10, '1. Girar tablero 90 (anti horario)°', 10,10,'2. Salir',10,10,0
    rangoMatriz                  dq 6       ;rango ajustado de la matriz cuando i y j empiezan en 0
    direccionProhibidaOca        dq 8
        
section  .bss

    bufferMatriz    resq 49 ; Espacio para la matriz buffer
    filaAux         resq 1
    columAux        resq 1
        
section  .text

cambiarOrientacion:

    mov qword[numQueIngreso], 10; limpio buffer por si acaso

    reiniciarPantalla
    mostrarString mensajeMenuCambioOrientacion
    pedirNumeroAlUsuario cambiarOrientacion

    mov     rax, qword[numQueIngreso]

    cmp     rax, 1
    je      transponerMatriz

    cmp     rax, 2
    je      menuInicial

    jmp cambiarOrientacion
    

transponerMatriz:
    inc qword[orientacionTablero]
    mov rax, qword[orientacionTablero]
    and rax, 3
    mov qword[orientacionTablero], rax

    sub rsp, 8
    call actualizarMovimientosOcas
    add rsp, 8

    xor rbx, rbx                ; índice de fila i = 0
    xor rcx, rcx                ; índice de columna j = 0

bucleExteriorTransponer:

    cmp rcx, 7
    jg intercambiarFilasMatriz       ; Si j > 7 termina el bucle
    mov rbx, 0       ; Reiniciar i = 0
    
bucleInteriorTransponer:

    mov rdx, rbx    ; rdx = i
    imul rdx, qword[longFila]
    mov r8, qword[longElemento]
    imul r8, rcx
    add rdx, r8         ; rdx = i * longFila + j * longElemento
    
    mov r9, qword[tablero + rdx]   ; Cargar elemento de la matriz original [j][i]

    xor rdx, rdx ; Limpiar registros auxiliares
    xor r8, r8

    mov rdx, rcx    ; rdx = j
    imul rdx, qword[longFila]
    mov r8, qword[longElemento]
    imul r8, rbx
    add rdx, r8         ; rdx = j * longFila + i * longElemento

    mov qword[bufferMatriz + rdx], r9    ; Almacenar elemento en buffer [i][j]

    inc rbx          ; i += 1
    cmp rbx, 7
    jl bucleInteriorTransponer     ; Saltar a bucleInteriorTransponer si rbx < 7 (i < 7)
    inc rcx
    jmp bucleExteriorTransponer

intercambiarFilasMatriz:

    xor rbx, rbx                ; índice de fila i = 0
    xor rcx, rcx                ; índice de columna j = 0

bucleExteriorIntercambiar:

    cmp rcx, 7
    je finIntercambioBucle       ; Si j > 7 termina el bucle
    mov rbx, 0                   ; Reiniciar i = 0
    
bucleInteriorIntercambiar:

    mov rdx, rcx    ; rdx = j
    imul rdx, qword[longFila]
    mov r8, qword[longElemento]
    imul r8, rbx
    add rdx, r8         ; rdx = i * longFila + j * longElemento
    
    mov r9, qword[bufferMatriz + rdx]   ; Cargar elemento del buffer [j][i]

    xor rdx, rdx ; Limpiar registros auxiliares
    xor r8, r8

    mov rdx, rcx    ; rdx = j
    mov r10, qword[rangoMatriz]  ; r10 = 6
    sub r10, rdx  ; r10 = 6 - j (fila opuesta)

    mov qword[filaAux], r10
    mov qword[columAux], rbx

    mov rdx, r10    ; rdx = 6 - j
    imul rdx, qword[longFila]
    mov r8, qword[longElemento]
    imul r8, rbx
    add rdx, r8         ; rdx = (6 - j) * longFila + i * longElemento
    

    mov qword[tablero + rdx], r9    ; Almacenar elemento en tablero [6 - j][i]
    
    sub rsp, 8
    call verNuevaPosicionZorro ;vemos si el elemento es el Zorro, para asi actualizar su nueva posicion
    add rsp, 8

    inc rbx          ; i += 1
    cmp rbx, 7
    jl bucleInteriorIntercambiar     ; Saltar a bucleInteriorIntercambiar si rbx < 7 (i < 7)
    inc rcx
    jmp bucleExteriorIntercambiar

finIntercambioBucle:
    xor rbx, rbx                ; i = 0
    xor rcx, rcx                ; j = 0
    jmp cambiarOrientacion

verNuevaPosicionZorro:

    cmp r9, 2
    je actualizarPosicionZorro ;si el elemento es 2(Zorro), actualizamos los valores

    ret
actualizarPosicionZorro:
    ; esta subrutina actualiza los valores de la fila y la columna del zorro (se le suma 1 porque en esta logica las columnas y filas van de 0 a 6 y en la otra de 1 a 7)
    mov rax, qword[filaAux]
    mov r11, qword[columAux]

    mov qword[filaZorro], rax
    inc qword[filaZorro]
    mov qword[columnaZorro], r11
    inc qword[columnaZorro]

    ret

actualizarMovimientosOcas:

    sub rsp, 8
    call actualizarEstadisticasRotacion ;si se roto la matriz, se rotan las estadisticas
    add rsp, 8
    
    ;actualizamos la direccion prohibida de la oca
    cmp qword[orientacionTablero], 0
    je actualizarMovOcasDireccionCero

    cmp qword[orientacionTablero], 1
    je actualizarMovOcasDireccionUno

    cmp qword[orientacionTablero], 2
    je actualizarMovOcasDireccionDos

    cmp qword[orientacionTablero], 3
    je actualizarMovOcasDireccionTres

    ret

;actualizamos en cada subrutina la nueva direccion prohibida
actualizarMovOcasDireccionCero:
    mov rax, 8
    mov qword[direccionProhibidaOca], rax
    ret

actualizarMovOcasDireccionUno:
    mov rax, 4
    mov qword[direccionProhibidaOca], rax
    ret

actualizarMovOcasDireccionDos:
    mov rax, 2
    mov qword[direccionProhibidaOca], rax
    ret

actualizarMovOcasDireccionTres:
    mov rax, 6
    mov qword[direccionProhibidaOca], rax
    ret

;rotamos las estadisticas 90 grados.
actualizarEstadisticasRotacion:
    moverElemento cantMovZorroAbajo, aux
    moverElemento cantMovZorroIzquierda, cantMovZorroAbajo
    moverElemento cantMovZorroArriba, cantMovZorroIzquierda
    moverElemento cantMovZorroDerecha, cantMovZorroArriba
    moverElemento aux, cantMovZorroDerecha

    moverElemento cantMovZorroDiagArribaDer, aux 
    moverElemento cantMovZorroDiagAbajoDer, cantMovZorroDiagArribaDer
    moverElemento cantMovZorroDiagAbajoIzq, cantMovZorroDiagAbajoDer
    moverElemento cantMovZorroDiagArribaIzq, cantMovZorroDiagAbajoIzq
    moverElemento aux, cantMovZorroDiagArribaIzq

    ret

