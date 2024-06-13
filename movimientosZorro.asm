extern  printf
extern puts
section  .data
     mensajeDireccionesZorro db 10, '« « « Turno Zorro » » »', 10, 'Seleccione en que dirección moverse', 10, '8: Arriba', 10, '6: Derecha', 10, '4: Izquierda', 10, '2: Abajo', 10, '9: Diagonal arriba/derecha', 10, '7: Diagonal arriba/izquierda', 10, '1: Diagonal abajo/izquierda', 10, '3: Diagonal abajo/derecha', 10,'0: FIN DEL JUEGO',10,10,0

section  .bss
    columnaOcaAComer    resq 1
    filaOcaAComer       resq 1
    contadorAux         resq 1 

section  .text


solicitarMovimientoZorro:
    reiniciarPantalla
    
    mov rax, qword[filaZorro]
    mov rbx, qword[columnaZorro]
    mov qword[filaObjetivo], rax
    mov qword[columnaObjetivo], rbx

    mostrarString mensajeDireccionesZorro
    mov qword[numQueIngreso], 10 

    pedirNumeroAlUsuario noMoverseZorro

    mov     rax, qword[numQueIngreso]
    mov     qword[ultimoMovimiento], rax

    ; aca preguntamos que teca valida ingreso y saltamso a la parte correspondiente, si no ingresa nada valido, no hacemos nada
    cmp     rax, qword[teclaMovArriba]
    je      movArribaZorro

    cmp     rax, qword[teclaMovDer]
    je      movDerechaZorro

    cmp     rax, qword[teclaMovAbajo]
    je      movAbajoZorro

    cmp     rax, qword[teclaMovIzq]
    je      movIzquierdaZorro

    cmp     rax, qword[teclaMovDiagIzqArriba]
    je      movDiagonalArribaIzquierdaZorro

    cmp     rax, qword[teclaMovDiagDerArriba]
    je      movDiagonalArribaDerechaZorro

    cmp     rax, qword[teclaMovDiagIzqAbajo]
    je      movDiagonalAbajoIzquierdaZorro

    cmp     rax, qword[teclaMovDiagDerAbajo]
    je      movDiagonalAbajoDerechaZorro

    cmp     rax, qword[teclaFinDelJuego]
    je      finalizarJuego

    jmp     noMoverseZorro

verSiSePuedeComerOca:
    mov rax, qword[filaObjetivo]
    mov rbx, qword[columnaObjetivo]
    mov qword[filaOcaAComer], rax
    mov qword[columnaOcaAComer], rbx
  
    calcularDesplazamineto filaObjetivo, columnaObjetivo
    mov     rdx, qword[tablero + rax] ; Cargar el valor desde tablero[rax]
    
    cmp     qword[tablero + rax], 3; si la celda objetivo es 2(hay una oca)
    je      verSiPuedeComerEnEsaDireccion; saltamos aca

    mov   qword[booleano], 1
    ret

;salta a la subrutina correspondiente dependiendo de que movimiento proviene el Zorro
verSiPuedeComerEnEsaDireccion:

    cmp qword[ultimoMovimiento], 8
    je verSiPuedeComerOcaParaArriba

    cmp qword[ultimoMovimiento], 2
    je verSiPuedeComerOcaParaAbajo

    cmp qword[ultimoMovimiento], 6
    je verSiPuedeComerOcaParaDer

    cmp qword[ultimoMovimiento], 4
    je verSiPuedeComerOcaParaIzq

    cmp qword[ultimoMovimiento], 7
    je verSiPuedeComerOcaParaDiagArribaIzq

    cmp qword[ultimoMovimiento], 9
    je verSiPuedeComerOcaParaDiagArribaDer

    cmp qword[ultimoMovimiento], 1
    je verSiPuedeComerOcaParaDiagAbajoIzq

    cmp qword[ultimoMovimiento], 3
    je verSiPuedeComerOcaParaDiagAbajoDer

    mov  qword[booleano], 1
    ret

;se fija si puede comer oca viendo si esta vacia la celda subsiguiente a la oca
verSiPuedeComerOcaParaArriba:
    dec qword[filaObjetivo]

    sub   rsp, 8
    call  verSiEstaVacio
    add   rsp, 8

    cmp qword[booleano], 0
    je pisarOcas

    mov qword[booleano], 1
    ret

verSiPuedeComerOcaParaAbajo:
    inc qword[filaObjetivo]

    sub   rsp, 8
    call  verSiEstaVacio
    add   rsp, 8

    cmp qword[booleano], 0
    je pisarOcas

    mov qword[booleano], 1
    ret

verSiPuedeComerOcaParaDer:
    inc qword[columnaObjetivo]

    sub   rsp, 8
    call  verSiEstaVacio
    add   rsp, 8

    cmp qword[booleano], 0
    je pisarOcas

    mov qword[booleano], 1
    ret

verSiPuedeComerOcaParaIzq:
    dec qword[columnaObjetivo]

    sub   rsp, 8
    call  verSiEstaVacio
    add   rsp, 8

    cmp qword[booleano], 0
    je pisarOcas

    mov qword[booleano], 1
    ret

verSiPuedeComerOcaParaDiagArribaIzq:
    dec qword[columnaObjetivo]
    dec qword[filaObjetivo]

    sub   rsp, 8
    call  verSiEstaVacio
    add   rsp, 8

    cmp qword[booleano], 0
    je pisarOcas

    mov qword[booleano], 1
    ret

verSiPuedeComerOcaParaDiagArribaDer:
    inc qword[columnaObjetivo]
    dec qword[filaObjetivo]

    sub   rsp, 8
    call  verSiEstaVacio
    add   rsp, 8

    cmp qword[booleano], 0
    je pisarOcas

    mov qword[booleano], 1
    ret

verSiPuedeComerOcaParaDiagAbajoIzq:
    dec qword[columnaObjetivo]
    inc qword[filaObjetivo]

    sub   rsp, 8
    call  verSiEstaVacio
    add   rsp, 8

    cmp qword[booleano], 0
    je pisarOcas

    mov qword[booleano], 1
    ret

verSiPuedeComerOcaParaDiagAbajoDer:
    inc qword[columnaObjetivo]
    inc qword[filaObjetivo]

    sub   rsp, 8
    call  verSiEstaVacio
    add   rsp, 8

    cmp qword[booleano], 0
    je pisarOcas

    mov qword[booleano], 1
    ret

;vuelve vacia a la celda donde esta la oca que comió
pisarOcas:
    cambiarCelda filaOcaAComer, columnaOcaAComer, 1    
    ret

; aca dependiendo que ingreso, modificamos la fila y/o columna correspondiente. Validamos que no se salio del limite y si la celda objetivo esta vacia.
; si esto se cumple, movemos el zorro a esa direccion. Sino, no movemos nada
movArribaZorro:
    dec qword[filaObjetivo]

    cmp qword[filaObjetivo], 0
    je noMoverseZorro

    sub     rsp, 8
    call    verSiEstaVacio
    add     rsp ,8

    cmp qword[booleano], 0
    je  moverZorro

    sub     rsp, 8
    call    verSiSePuedeComerOca
    add     rsp ,8

    cmp qword[booleano], 0
    je  moverZorro

    jmp noMoverseZorro

movDerechaZorro:
    inc qword[columnaObjetivo]
    
    cmp qword[columnaObjetivo], 8
    je noMoverseZorro

    sub     rsp, 8
    call    verSiEstaVacio
    add     rsp ,8

    cmp qword[booleano], 0
    je  moverZorro

    sub     rsp, 8
    call    verSiSePuedeComerOca
    add     rsp ,8


    cmp qword[booleano], 0
    je  moverZorro

    jmp noMoverseZorro
movAbajoZorro:
    inc qword[filaObjetivo]

    cmp qword[filaObjetivo], 8
    je noMoverseZorro

    sub     rsp, 8
    call    verSiEstaVacio
    add     rsp ,8

    cmp qword[booleano], 0
    je  moverZorro

    sub     rsp, 8
    call    verSiSePuedeComerOca
    add     rsp ,8

    cmp qword[booleano], 0
    je  moverZorro

    jmp noMoverseZorro

movIzquierdaZorro:
    dec qword[columnaObjetivo]

    cmp qword[columnaObjetivo], 0
    je noMoverseZorro

    sub     rsp, 8
    call    verSiEstaVacio
    add     rsp ,8

    cmp qword[booleano], 0
    je  moverZorro

    sub     rsp, 8
    call    verSiSePuedeComerOca
    add     rsp ,8


    cmp qword[booleano], 0
    je  moverZorro

    jmp noMoverseZorro

movDiagonalArribaDerechaZorro:
    dec qword[filaObjetivo]
    inc qword[columnaObjetivo]

    cmp qword[columnaObjetivo], 8
    je noMoverseZorro

    sub     rsp, 8
    call    verSiEstaVacio
    add     rsp ,8

    cmp qword[booleano], 0
    je  moverZorro

    sub     rsp, 8
    call    verSiSePuedeComerOca
    add     rsp ,8


    cmp qword[booleano], 0
    je  moverZorro

    jmp noMoverseZorro

movDiagonalAbajoDerechaZorro:
    inc qword[filaObjetivo]
    inc qword[columnaObjetivo]

    cmp qword[columnaObjetivo], 8
    je noMoverseZorro

    sub     rsp, 8
    call    verSiEstaVacio
    add     rsp ,8

    cmp qword[booleano], 0
    je  moverZorro

    sub     rsp, 8
    call    verSiSePuedeComerOca
    add     rsp ,8

    
    cmp qword[booleano], 0
    je  moverZorro

    jmp noMoverseZorro

movDiagonalArribaIzquierdaZorro:
    dec qword[filaObjetivo]
    dec qword[columnaObjetivo]

    cmp qword[columnaObjetivo], 8
    je noMoverseZorro

    sub     rsp, 8
    call    verSiEstaVacio
    add     rsp ,8

    cmp qword[booleano], 0
    je  moverZorro

    sub     rsp, 8
    call    verSiSePuedeComerOca
    add     rsp ,8


    cmp qword[booleano], 0
    je  moverZorro

    jmp noMoverseZorro

movDiagonalAbajoIzquierdaZorro:
    inc qword[filaObjetivo]
    dec qword[columnaObjetivo]

    cmp qword[columnaObjetivo], 0
    je main

    sub     rsp, 8
    call    verSiEstaVacio
    add     rsp ,8

    cmp qword[booleano], 0
    je  moverZorro

    sub     rsp, 8
    call    verSiSePuedeComerOca
    add     rsp ,8

    cmp qword[booleano], 0
    je  moverZorro

    jmp noMoverseZorro


moverZorro:
    moverElemento filaZorro, columnaZorro, filaObjetivo, columnaObjetivo; movemos el elemento en el tablero
    
    ;actualizamos la posicion del zorro por la posicion a la que se acaba de mover
    mov rax, qword[filaObjetivo]
    mov rbx, qword[columnaObjetivo]
    mov qword[filaZorro], rax
    mov qword[columnaZorro], rbx
    mov qword[turno], 1
    jmp volverAPedirMovimiento

noMoverseZorro:
    ;actualizamos la columna y fila objetivo por si las modificamos y no decidimos movernos
    mov rax, qword[filaZorro]
    mov rbx, qword[columnaZorro]
    mov qword[filaObjetivo], rax
    mov qword[columnaObjetivo], rbx
    jmp volverAPedirMovimiento


    

