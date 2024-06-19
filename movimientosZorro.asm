extern  printf
extern puts
section  .data
     mensajeDireccionesZorro                    db 10, '« « « Turno Zorro » » »', 10, 'Seleccione en que dirección moverse', 10, '8: Arriba', 10, '6: Derecha', 10, '4: Izquierda', 10, '2: Abajo', 10, '9: Diagonal arriba/derecha', 10, '7: Diagonal arriba/izquierda', 10, '1: Diagonal abajo/izquierda', 10, '3: Diagonal abajo/derecha', 10,'0: FIN DEL JUEGO',10,10,0
     mensajeQuiereMoverDeNuevo                  db 10, 10, 'Zorro: ¡Acabas de comer una oca! ¿Quieres volver a mover?', 10, '1: Si', 10, '2: No',10,10,0
     mensajeMostrarEstadistica                  db 10, 'Estadisticas del Zorro en todas las direcciones:  ', 10, 0
     mensajecantMovZorroArriba                  db 10, 'Arriba: %li', 10, 0
     mensajecantMovZorroAbajo                   db 'Abajo: %li', 10, 0
     mensajecantMovZorroDerecha                 db 'Derecha: %li', 10, 0 
     mensajecantMovZorroIzquierda               db 'Izquierda: %li', 10, 0 
     mensajecantMovZorroDiagArribaDer           db 'Diagonal Arriba Derecha: %li', 10, 0 
     mensajecantMovZorroDiagArribaIzq           db 'Diagonal Arriba Izquierda: %li', 10, 0 
     mensajecantMovZorroDiagAbajoIzq            db 'Diagonal Abajo Derecha: %li', 10, 0 
     mensajecantMovZorroDiagAbajoDer            db 'Diagonal Abajo Izquierda: %li', 10, 0  
     ocaAcabaDeSerComida                        dq 1
     ocasComidas                                dq 0
     cantMovZorroArriba                         dq 0
     cantMovZorroAbajo                          dq 0
     cantMovZorroDerecha                        dq 0
     cantMovZorroIzquierda                      dq 0
     cantMovZorroDiagArribaDer                  dq 0
     cantMovZorroDiagArribaIzq                  dq 0
     cantMovZorroDiagAbajoDer                   dq 0
     cantMovZorroDiagAbajoIzq                   dq 0

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
    mov rax, qword[ocasComidas]
    inc rax
    mov qword[ocasComidas], rax

    cambiarCelda filaOcaAComer, columnaOcaAComer, 1    
    mov qword[ocaAcabaDeSerComida], 0
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
    je  movZorroHaciaArriba

    sub     rsp, 8
    call    verSiSePuedeComerOca
    add     rsp ,8

    cmp qword[booleano], 0
    je  movZorroHaciaArriba

    jmp noMoverseZorro

movDerechaZorro:
    inc qword[columnaObjetivo]
    
    cmp qword[columnaObjetivo], 8
    je noMoverseZorro

    sub     rsp, 8
    call    verSiEstaVacio
    add     rsp ,8

    cmp qword[booleano], 0
    je  movZorroHaciaDerecha

    sub     rsp, 8
    call    verSiSePuedeComerOca
    add     rsp ,8

    cmp qword[booleano], 0
    je  movZorroHaciaDerecha

    jmp noMoverseZorro
movAbajoZorro:
    inc qword[filaObjetivo]

    cmp qword[filaObjetivo], 8
    je noMoverseZorro

    sub     rsp, 8
    call    verSiEstaVacio
    add     rsp ,8

    cmp qword[booleano], 0
    je  movZorroHaciaAbajo

    sub     rsp, 8
    call    verSiSePuedeComerOca
    add     rsp ,8

    cmp qword[booleano], 0
    je  movZorroHaciaAbajo

    jmp noMoverseZorro

movIzquierdaZorro:
    dec qword[columnaObjetivo]

    cmp qword[columnaObjetivo], 0
    je noMoverseZorro

    sub     rsp, 8
    call    verSiEstaVacio
    add     rsp ,8

    cmp qword[booleano], 0
    je  movZorroHaciaIzquierda

    sub     rsp, 8
    call    verSiSePuedeComerOca
    add     rsp ,8


    cmp qword[booleano], 0
    je  movZorroHaciaIzquierda

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
    je  movZorroHaciaDiagArribaDer

    sub     rsp, 8
    call    verSiSePuedeComerOca
    add     rsp ,8


    cmp qword[booleano], 0
    je  movZorroHaciaDiagArribaDer

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
    je  movZorroHaciaDiagAbajoDer

    sub     rsp, 8
    call    verSiSePuedeComerOca
    add     rsp ,8

    
    cmp qword[booleano], 0
    je  movZorroHaciaDiagAbajoDer

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
    je  movZorroHaciaDiagArribaIzq

    sub     rsp, 8
    call    verSiSePuedeComerOca
    add     rsp ,8


    cmp qword[booleano], 0
    je  movZorroHaciaDiagArribaIzq

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
    je  movZorroHaciaDiagAbajoIzq

    sub     rsp, 8
    call    verSiSePuedeComerOca
    add     rsp ,8

    cmp qword[booleano], 0
    je  movZorroHaciaDiagAbajoIzq

    jmp noMoverseZorro


movZorroHaciaArriba:
    inc qword[cantMovZorroArriba]
    jmp moverZorro

movZorroHaciaAbajo:
    inc qword[cantMovZorroAbajo]
    jmp moverZorro

movZorroHaciaDerecha:
    inc qword[cantMovZorroDerecha]
    jmp moverZorro

movZorroHaciaIzquierda:
    inc qword[cantMovZorroIzquierda]
    jmp moverZorro

movZorroHaciaDiagArribaDer:
    inc qword[cantMovZorroDiagArribaDer]
    jmp moverZorro

movZorroHaciaDiagArribaIzq:
    inc qword[cantMovZorroDiagArribaIzq]
    jmp moverZorro
movZorroHaciaDiagAbajoIzq:
    inc qword[cantMovZorroDiagAbajoIzq]
    jmp moverZorro 

movZorroHaciaDiagAbajoDer:
    inc qword[cantMovZorroDiagAbajoDer]
    jmp moverZorro     

verSiZorroTieneMovimientoPosibles:

    mov qword[sePuedeMoverZorro], 1

    
    sub rsp, 8
    call verSiZorroPuedeMoverseHaciaArriba ;solicitio un movimiento ya sea al Zorro o a las Ocas
    add rsp, 8

    cmp qword[sePuedeMoverZorro], 0
    je hayMovimientoPosibleZorro

    sub rsp, 8
    call verSiZorroPuedeMoverseHaciaAbajo ;solicitio un movimiento ya sea al Zorro o a las Ocas
    add rsp, 8

    cmp qword[sePuedeMoverZorro], 0
    je hayMovimientoPosibleZorro

    sub rsp, 8
    call verSiZorroPuedeMoverseHaciaADerecha ;solicitio un movimiento ya sea al Zorro o a las Ocas
    add rsp, 8

    cmp qword[sePuedeMoverZorro], 0
    je hayMovimientoPosibleZorro

    sub rsp, 8
    call verSiZorroPuedeMoverseHaciaIzquierda ;solicitio un movimiento ya sea al Zorro o a las Ocas
    add rsp, 8

    cmp qword[sePuedeMoverZorro], 0
    je hayMovimientoPosibleZorro

    sub rsp, 8
    call verSiZorroPuedeMoverseHaciaDiagonalArribaDer ;solicitio un movimiento ya sea al Zorro o a las Ocas
    add rsp, 8

    cmp qword[sePuedeMoverZorro], 0
    je hayMovimientoPosibleZorro

    sub rsp, 8
    call verSiZorroPuedeMoverseHaciaDiagonalArribaIzq ;solicitio un movimiento ya sea al Zorro o a las Ocas
    add rsp, 8

    cmp qword[sePuedeMoverZorro], 0
    je hayMovimientoPosibleZorro

    sub rsp, 8
    call verSiZorroPuedeMoverseHaciaDiagonalAbajoDer ;solicitio un movimiento ya sea al Zorro o a las Ocas
    add rsp, 8

    cmp qword[sePuedeMoverZorro], 0
    je hayMovimientoPosibleZorro

    sub rsp, 8
    call verSiZorroPuedeMoverseHaciaDiagonalAbajoIzq ;solicitio un movimiento ya sea al Zorro o a las Ocas
    add rsp, 8

    cmp qword[sePuedeMoverZorro], 0
    je hayMovimientoPosibleZorro

    
    ret

hayMovimientoPosibleZorro:
    ret

noHayMovimientoPosibleZorro:
    mov qword[sePuedeMoverZorro], 1
    ret

verSiZorroPuedeMoverseHaciaArriba:
    mov rax, qword[columnaZorro]
    mov rbx, qword[filaZorro]
    mov qword[columnaObjetivo], rax
    mov qword[filaObjetivo], rbx

    ;me fijo si hay movimiento hacia arriba
    dec qword[filaObjetivo]

    ;mostrarString mensajeComisteOcas
    ;mostrarNumero qword[filaObjetivo]

    cmp qword[filaObjetivo], 0
    je zorroNoSePuedeMoverEnDireccion

    sub     rsp, 8
    call    verSiEstaVacio
    add     rsp ,8
    
    cmp qword[booleano], 0
    je zorroSePuedeMoverEnDireccion

    ;de nuevo
    dec qword[filaObjetivo]

    cmp qword[filaObjetivo], 0
    je zorroNoSePuedeMoverEnDireccion

    sub     rsp, 8
    call    verSiEstaVacio
    add     rsp ,8
    
    cmp qword[booleano], 0
    je zorroSePuedeMoverEnDireccion

    jmp zorroNoSePuedeMoverEnDireccion

verSiZorroPuedeMoverseHaciaAbajo:
    mov rax, qword[columnaZorro]
    mov rbx, qword[filaZorro]
    mov qword[columnaObjetivo], rax
    mov qword[filaObjetivo], rbx

    ;me fijo si hay movimiento hacia arriba
    inc qword[filaObjetivo]

    ;mostrarString mensajeComisteOcas
    ;mostrarNumero qword[filaObjetivo]

    cmp qword[filaObjetivo], 8
    je zorroNoSePuedeMoverEnDireccion

    sub     rsp, 8
    call    verSiEstaVacio
    add     rsp ,8
    
    cmp qword[booleano], 0
    je zorroSePuedeMoverEnDireccion

    ;de nuevo
    inc qword[filaObjetivo]

    cmp qword[filaObjetivo], 8
    je zorroNoSePuedeMoverEnDireccion

    sub     rsp, 8
    call    verSiEstaVacio
    add     rsp ,8
    
    cmp qword[booleano], 0
    je zorroSePuedeMoverEnDireccion

    jmp zorroNoSePuedeMoverEnDireccion

verSiZorroPuedeMoverseHaciaADerecha:
    mov rax, qword[columnaZorro]
    mov rbx, qword[filaZorro]
    mov qword[columnaObjetivo], rax
    mov qword[filaObjetivo], rbx

    ;me fijo si hay movimiento hacia arriba
    inc qword[columnaObjetivo]

    ;mostrarString mensajeComisteOcas
    ;mostrarNumero qword[filaObjetivo]

    cmp qword[columnaObjetivo], 8
    je zorroNoSePuedeMoverEnDireccion

    sub     rsp, 8
    call    verSiEstaVacio
    add     rsp ,8
    
    cmp qword[booleano], 0
    je zorroSePuedeMoverEnDireccion

    ;de nuevo
    inc qword[columnaObjetivo]

    cmp qword[columnaObjetivo], 8
    je zorroNoSePuedeMoverEnDireccion

    sub     rsp, 8
    call    verSiEstaVacio
    add     rsp ,8
    
    cmp qword[booleano], 0
    je zorroSePuedeMoverEnDireccion

    jmp zorroNoSePuedeMoverEnDireccion

verSiZorroPuedeMoverseHaciaIzquierda:
    mov rax, qword[columnaZorro]
    mov rbx, qword[filaZorro]
    mov qword[columnaObjetivo], rax
    mov qword[filaObjetivo], rbx

    ;me fijo si hay movimiento hacia arriba
    dec qword[columnaObjetivo]

    ;mostrarString mensajeComisteOcas
    ;mostrarNumero qword[filaObjetivo]

    cmp qword[columnaObjetivo], 0
    je zorroNoSePuedeMoverEnDireccion

    sub     rsp, 8
    call    verSiEstaVacio
    add     rsp ,8
    
    cmp qword[booleano], 0
    je zorroSePuedeMoverEnDireccion

    ;de nuevo
    dec qword[columnaObjetivo]

    cmp qword[columnaObjetivo], 0
    je zorroNoSePuedeMoverEnDireccion

    sub     rsp, 8
    call    verSiEstaVacio
    add     rsp ,8
    
    cmp qword[booleano], 0
    je zorroSePuedeMoverEnDireccion

    jmp zorroNoSePuedeMoverEnDireccion

verSiZorroPuedeMoverseHaciaDiagonalArribaDer:
    mov rax, qword[columnaZorro]
    mov rbx, qword[filaZorro]
    mov qword[columnaObjetivo], rax
    mov qword[filaObjetivo], rbx

    ;me fijo si hay movimiento hacia arriba
    dec qword[filaObjetivo]
    inc qword[columnaObjetivo]

    ;mostrarString mensajeComisteOcas
    ;mostrarNumero qword[filaObjetivo]

    cmp qword[filaObjetivo], 0
    je zorroNoSePuedeMoverEnDireccion

    sub     rsp, 8
    call    verSiEstaVacio
    add     rsp ,8
    
    cmp qword[booleano], 0
    je zorroSePuedeMoverEnDireccion

    ;de nuevo
    dec qword[filaObjetivo]
    inc qword[columnaObjetivo]

    cmp qword[filaObjetivo], 0
    je zorroNoSePuedeMoverEnDireccion

    sub     rsp, 8
    call    verSiEstaVacio
    add     rsp ,8
    
    cmp qword[booleano], 0
    je zorroSePuedeMoverEnDireccion

    jmp zorroNoSePuedeMoverEnDireccion

verSiZorroPuedeMoverseHaciaDiagonalArribaIzq:
    mov rax, qword[columnaZorro]
    mov rbx, qword[filaZorro]
    mov qword[columnaObjetivo], rax
    mov qword[filaObjetivo], rbx

    ;me fijo si hay movimiento hacia arriba
    dec qword[filaObjetivo]
    dec qword[columnaObjetivo]

    ;mostrarString mensajeComisteOcas
    ;mostrarNumero qword[filaObjetivo]

    cmp qword[filaObjetivo], 0
    je zorroNoSePuedeMoverEnDireccion

    sub     rsp, 8
    call    verSiEstaVacio
    add     rsp ,8
    
    cmp qword[booleano], 0
    je zorroSePuedeMoverEnDireccion

    ;de nuevo
    dec qword[filaObjetivo]
    dec qword[columnaObjetivo]

    cmp qword[filaObjetivo], 0
    je zorroNoSePuedeMoverEnDireccion

    sub     rsp, 8
    call    verSiEstaVacio
    add     rsp ,8
    
    cmp qword[booleano], 0
    je zorroSePuedeMoverEnDireccion

    jmp zorroNoSePuedeMoverEnDireccion

verSiZorroPuedeMoverseHaciaDiagonalAbajoIzq:
    mov rax, qword[columnaZorro]
    mov rbx, qword[filaZorro]
    mov qword[columnaObjetivo], rax
    mov qword[filaObjetivo], rbx

    ;me fijo si hay movimiento hacia arriba
    inc qword[filaObjetivo]
    dec qword[columnaObjetivo]

    ;mostrarString mensajeComisteOcas
    ;mostrarNumero qword[filaObjetivo]

    cmp qword[filaObjetivo], 8
    je zorroNoSePuedeMoverEnDireccion

    sub     rsp, 8
    call    verSiEstaVacio
    add     rsp ,8
    
    cmp qword[booleano], 0
    je zorroSePuedeMoverEnDireccion

    ;de nuevo
    inc qword[filaObjetivo]
    dec qword[columnaObjetivo]

    cmp qword[filaObjetivo], 8
    je zorroNoSePuedeMoverEnDireccion

    sub     rsp, 8
    call    verSiEstaVacio
    add     rsp ,8
    
    cmp qword[booleano], 0
    je zorroSePuedeMoverEnDireccion

    jmp zorroNoSePuedeMoverEnDireccion

verSiZorroPuedeMoverseHaciaDiagonalAbajoDer:
    mov rax, qword[columnaZorro]
    mov rbx, qword[filaZorro]
    mov qword[columnaObjetivo], rax
    mov qword[filaObjetivo], rbx

    ;me fijo si hay movimiento hacia arriba
    inc qword[filaObjetivo]
    inc qword[columnaObjetivo]

    ;mostrarString mensajeComisteOcas
    ;mostrarNumero qword[filaObjetivo]

    cmp qword[filaObjetivo], 8
    je zorroNoSePuedeMoverEnDireccion

    sub     rsp, 8
    call    verSiEstaVacio
    add     rsp ,8
    
    cmp qword[booleano], 0
    je zorroSePuedeMoverEnDireccion

    ;de nuevo
    inc qword[filaObjetivo]
    inc qword[columnaObjetivo]

    cmp qword[filaObjetivo], 8
    je zorroNoSePuedeMoverEnDireccion

    sub     rsp, 8
    call    verSiEstaVacio
    add     rsp ,8
    
    cmp qword[booleano], 0
    je zorroSePuedeMoverEnDireccion

    jmp zorroNoSePuedeMoverEnDireccion

zorroSePuedeMoverEnDireccion:
    mov qword[sePuedeMoverZorro], 0
    ret

zorroNoSePuedeMoverEnDireccion:
    ret


moverZorro:
    moverElemento filaZorro, columnaZorro, filaObjetivo, columnaObjetivo; movemos el elemento en el tablero
    ;actualizamos la posicion del zorro por la posicion a la que se acaba de mover
    mov rax, qword[filaObjetivo]
    mov rbx, qword[columnaObjetivo]
    mov qword[filaZorro], rax
    mov qword[columnaZorro], rbx
    mov qword[turno], 1

    cmp qword[ocaAcabaDeSerComida], 0
    je preguntarSiQuiereMoverDeNuevo 

    jmp volverAPedirMovimiento

noMoverseZorro:
    ;actualizamos la columna y fila objetivo por si las modificamos y no decidimos movernos
    mov rax, qword[filaZorro]
    mov rbx, qword[columnaZorro]
    mov qword[filaObjetivo], rax
    mov qword[columnaObjetivo], rbx
    jmp volverAPedirMovimiento

preguntarSiQuiereMoverDeNuevo:

    mov qword[ocaAcabaDeSerComida], 1
    mov qword[numQueIngreso], 10

    reiniciarPantalla
    mostrarString mensajeQuiereMoverDeNuevo
    pedirNumeroAlUsuario preguntarSiQuiereMoverDeNuevo

    mov     rax, qword[numQueIngreso]

    cmp     rax, 1
    je      noCambiarTurno

    cmp     rax, 2
    je      cambiarTurno

    jmp preguntarSiQuiereMoverDeNuevo

noCambiarTurno:
    mov qword[turno], 0
    ret
cambiarTurno:
    ret

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
    

