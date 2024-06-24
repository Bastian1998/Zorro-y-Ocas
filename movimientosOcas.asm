extern  printf
extern puts

;macro que uso para debuguear
%macro mostrarNumeroDebug 1
    mov rdi, numeroDebug 
    mov rsi, %1
    sub rsp,8 
    call printf
    add rsp,8
%endmacro

section  .data
    mensajeDireccionesOca         db 10, '« « « Turno Ocas » » »', 10, 'Oca: Seleccione en que dirección moverse', 10, '2: Abajo', 10, '6: Derecha', 10, '4: Izquierda',10,'5: Volver a seleccionar Oca',10, '0: Volver al menu principal', 10, 0
    mensajeDireccionCeroOca       db 10, '« « « Turno Ocas » » »', 10, 'Oca: Seleccione en que dirección moverse', 10, '2: Abajo', 10, '6: Derecha', 10, '4: Izquierda',10,'5: Volver a seleccionar Oca',10, '0: Volver al menu principal', 10, 0
    mensajeDireccionUnoOca        db 10, '« « « Turno Ocas » » »', 10, 'Oca: Seleccione en que dirección moverse', 10, '2: Abajo', 10, '6: Derecha', 10, '8: Arriba',10,'5: Volver a seleccionar Oca',10, '0: Volver al menu principal', 10, 0
    mensajeDireccionDosOca        db 10, '« « « Turno Ocas » » »', 10, 'Oca: Seleccione en que dirección moverse', 10, '8: Arriba', 10,'6: Derecha', 10, '4: Izquierda',10,'5: Volver a seleccionar Oca',10, '0: Volver al menu principal', 10, 0
    mensajeDireccionTresOca       db 10, '« « « Turno Ocas » » »', 10, 'Oca: Seleccione en que dirección moverse', 10, '2: Abajo', 10, '8: Arriba', 10,  '4: Izquierda',10,'5: Volver a seleccionar Oca',10, '0: Volver al menu principal', 10, 0
    mensajeFilaOca                db 10, '« « « Turno Ocas » » »', 10,'Jugador Ocas: Ingrese la fila de la oca que quiere mover.', 10, 0
    mensajeColumnaOca             db 10, 'Jugador Ocas: Ingrese la columna de la oca que quiere mover.', 10, 0
    mensajeErrorOca               db 10, '¡Ups! !La celda que seleccionaste no contiene una oca! Vuelve a intentarlo.', 10, 0
    mensajeOcaHaSidoMarcada       db 10, 'La oca que seleccionaste aparace marcada como Ø, ahora elige que movimiento deseas hacer.', 10, 0
    orientacionTablero            dq 0
                                
section  .bss
    filaOcaAMover         resq 1
    columnaOcaAMover      resq 1

section  .text

mostrarStringOcaSegunDireccion:
    cmp qword[orientacionTablero], 0
    je mostrarStringDireccionCero

    cmp qword[orientacionTablero], 1
    je mostrarStringDireccionUno

    cmp qword[orientacionTablero], 2
    je mostrarStringDireccionDos

    cmp qword[orientacionTablero], 3
    je mostrarStringDireccionTres

    ret

mostrarStringDireccionCero:
    mostrarString mensajeDireccionCeroOca
    ret

mostrarStringDireccionUno:
    mostrarString mensajeDireccionUnoOca
    ret

mostrarStringDireccionDos:
    mostrarString mensajeDireccionDosOca
    ret

mostrarStringDireccionTres:
    mostrarString mensajeDireccionTresOca
    ret

solicitarAccionOca:
    ;le solicitamos al usuario que oca desea mover
    sub  rsp, 8
    call solicitarOcaAMover
    add  rsp, 8

    ;inicializamos la fila y columna objetivo con el valor de la oca a mover
    mov rax, qword[columnaOcaAMover]
    mov rbx, qword[filaOcaAMover]
    mov qword[columnaObjetivo], rax
    mov qword[filaObjetivo], rbx

    ;le solicitamos al usuario que movimiento desea hacer
    sub  rsp, 8
    call solicitarMovimientoOca
    add  rsp, 8

    ;cambiamos turno al Zorro
    mov    qword[turno], 0

    ret

solicitarOcaAMover:

    ;solicitamos al usuario fila y columna de la oca que desea mover
    sub  rsp, 8
    call solicitarFilaOcaAMover
    add  rsp, 8

    sub  rsp, 8
    call solicitarColumnaOcaAMover
    add  rsp, 8

    ;validamos si hay realmente una oca en esa celda
    sub  rsp, 8
    call validarQueHayaOca
    add  rsp, 8

    ;si no hay oca mostramos error y volvemos a solicitar
    cmp  qword[booleano], 1
    je   OcaNoCorrecta

    ;marcamos la oca como oca seleccionada asi es mas facil para el usuario pensar movimientos
    cambiarCelda filaOcaAMover, columnaOcaAMover, 4

    ;limpiamos y mostramos para mas claridad
    reiniciarPantalla

    mostrarString mensajeOcaHaSidoMarcada
    ret

solicitarMovimientoOca:

    sub rsp, 8
    call mostrarStringOcaSegunDireccion
    add rsp, 8
    
    ;limpieza de buffer por si acaso
    mov qword[numQueIngreso], 10  

    pedirNumeroAlUsuario solicitarMovimientoOca

    mov     rax, qword[numQueIngreso]

    cmp     rax, qword[direccionProhibidaOca]
    je      solicitarMovimientoOca
    
    ;aca preguntamos que tecla valida ingreso y saltamso a la parte correspondiente, si no ingresa nada valido, se vuelve a preguntar
    cmp     rax, qword[teclaMovAbajo]
    je      movAbajoOca

    cmp     rax, qword[teclaMovDer]
    je      movDerechaOca

    cmp     rax, qword[teclaMovIzq]
    je      movIzqOca

    cmp     rax, qword[teclaMovArriba]
    je      movArribaOca

    cmp     rax, qword[teclaVolverASeleccionarOca]
    je      volverASeleccionarOca  

    cmp     rax, qword[teclaVolver]
    je      volverMenuDesdeOca

    jmp     solicitarMovimientoOca
    ret
    
volverMenuDesdeOca:
    ;si se finalizo desde la oca se desmarca la oca seleccionada
    cambiarCelda filaOcaAMover, columnaOcaAMover, 3
    sub rsp, 8
    call menuInicial
    add rsp, 8
    ret

volverASeleccionarOca:
    ;se desmarca la oca seleccionada, se limpia la pantalla y se vuelve a solicitar Oca
    cambiarCelda filaOcaAMover, columnaOcaAMover, 3
    reiniciarPantalla
    jmp  solicitarAccionOca

noMoverseOca:
    ;actualizamos la columna y fila objetivo por si las modificamos y no decidimos movernos
    mov rax, qword[filaOcaAMover]
    mov rbx, qword[columnaOcaAMover]
    mov qword[filaObjetivo], rax
    mov qword[columnaObjetivo], rbx
    jmp solicitarMovimientoOca


;estructura de los MovXXXOca
;1 - modificamos el objetivo dependiendo de la direccion seleccionada
;2 - si nos fuimos de los limites del tablero no se mueve la oca
;3 - verificamos si esta vacia la celda
;4-  si esta vacia nos movemos, sino no

movAbajoOca:
    inc qword[filaObjetivo]

    cmp qword[filaObjetivo], 8
    je noMoverseOca

    sub     rsp, 8
    call    verSiEstaVacio
    add     rsp ,8

    cmp qword[booleano], 0
    je  moverOca

    jmp noMoverseOca

movDerechaOca:
    inc qword[columnaObjetivo]

    cmp qword[columnaObjetivo], 8
    je noMoverseOca

    sub     rsp, 8
    call    verSiEstaVacio
    add     rsp ,8

    cmp qword[booleano], 0
    je  moverOca

    jmp noMoverseOca

movIzqOca:
    dec qword[columnaObjetivo]

    cmp qword[columnaObjetivo], 0
    je  noMoverseOca

    sub     rsp, 8
    call    verSiEstaVacio
    add     rsp ,8

    cmp qword[booleano], 0
    je  moverOca

    jmp noMoverseOca

movArribaOca:
    dec qword[filaObjetivo]

    cmp qword[filaObjetivo], 0
    je  noMoverseOca

    sub     rsp, 8
    call    verSiEstaVacio
    add     rsp ,8

    cmp qword[booleano], 0
    je  moverOca

    jmp noMoverseOca

moverOca:
    moverElemento filaOcaAMover, columnaOcaAMover, filaObjetivo, columnaObjetivo; movemos el elemento en el tablero
    ;actualizamos la posicion de la oca por la posicion a la que se acaba de mover
    cambiarCelda filaObjetivo, columnaObjetivo, 3

    mov qword[turno], 0
    jmp volverAPedirMovimiento

OcaNoCorrecta:
    ;mostramos mensaje de oca no correcta y volvemos a pedirla
    mostrarString mensajeErrorOca
    jmp solicitarOcaAMover


validarQueHayaOca:
    calcularDesplazamineto filaOcaAMover, columnaOcaAMover

    mov     qword[booleano], 1

    cmp     qword[tablero + rax], 3 ; me fijo si hay una oca en la celda
    je      booleanoTrue

    ret

solicitarFilaOcaAMover:

    mostrarString mensajeFilaOca

    mov qword[numQueIngreso], 10 ;limpiamos buffer por si acaso

    ;Pido al usuario un numero
    pedirNumeroAlUsuario solicitarFilaOcaAMover

    ;me fijo si la fila esta entre [1, 7], sino vuelvo a solicitar
    cmp     qword[numQueIngreso], 0
    jle     solicitarFilaOcaAMover

    cmp     qword[numQueIngreso], 8
    jge     solicitarFilaOcaAMover

    ;reemplazamos el numero que ingreso en la variable
    mov     rax, qword[numQueIngreso]
    mov     qword[filaOcaAMover], rax

    ret

solicitarColumnaOcaAMover:

    mostrarString mensajeColumnaOca

    mov qword[numQueIngreso], 10 

    pedirNumeroAlUsuario solicitarColumnaOcaAMover

    ;me fijo si la fila esta entre [1, 7], sino vuelvo a solicitar
    cmp     qword[numQueIngreso], 0
    jle     solicitarColumnaOcaAMover

    cmp     qword[numQueIngreso], 8
    jge     solicitarColumnaOcaAMover

    ;reemplazamos el numero que ingreso en la variable
    mov     rax, qword[numQueIngreso]
    mov    qword[columnaOcaAMover], rax

    ret

    

