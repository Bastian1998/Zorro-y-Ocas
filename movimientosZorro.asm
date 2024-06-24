extern  printf
extern puts
section  .data
     mensajeDireccionesZorro                    db 10, '« « « Turno Zorro » » »', 10, 'Seleccione en que dirección moverse', 10, '8: Arriba', 10, '6: Derecha', 10, '4: Izquierda', 10, '2: Abajo', 10, '9: Diagonal arriba/derecha', 10, '7: Diagonal arriba/izquierda', 10, '1: Diagonal abajo/izquierda', 10, '3: Diagonal abajo/derecha', 10,'0: Volver al menu principal',10,10,0
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
    
    ;reiniciamos fila y columna objetivo a la actual del zorro
    mov rax, qword[filaZorro]
    mov rbx, qword[columnaZorro]
    mov qword[filaObjetivo], rax
    mov qword[columnaObjetivo], rbx

    mostrarString mensajeDireccionesZorro
    mov qword[numQueIngreso], 10 ;limpiamos buffer por si acaso

    pedirNumeroAlUsuario noMoverseZorro

    mov     rax, qword[numQueIngreso]
    mov     qword[ultimoMovimiento], rax ;actualizamos al ultimo movimiento al que acaba de ingresar

    ; aca preguntamos que teca valida ingreso y saltamso a la parte correspondiente, si no ingresa nada valido, no hacemos nada
    cmp     rax, qword[teclaMovArriba]
    je      intentarMovZorroHaciaArriba

    cmp     rax, qword[teclaMovDer]
    je      intentarMovZorroHaciaDerecha

    cmp     rax, qword[teclaMovAbajo]
    je      intentarMovZorroHaciaAbajo

    cmp     rax, qword[teclaMovIzq]
    je      intentarMovZorroHaciaIzquierda

    cmp     rax, qword[teclaMovDiagIzqArriba]
    je      intentarMovZorroHaciaDiagIzqArriba

    cmp     rax, qword[teclaMovDiagDerArriba]
    je      intentarMovZorroHaciaDiagDerArriba

    cmp     rax, qword[teclaMovDiagIzqAbajo]
    je      intentarMovZorroHaciaDiagIzqAbajo

    cmp     rax, qword[teclaMovDiagDerAbajo]
    je      intentarMovZorroHaciaDiagDerAbajo

    cmp     rax, qword[teclaVolver]
    je      volverAlMenu

    jmp     noMoverseZorro

verSiSePuedeComerOca:

    ;reiniciamos fila y columna objetivo a la actual del zorro
    mov rax, qword[filaObjetivo]
    mov rbx, qword[columnaObjetivo]
    mov qword[filaOcaAComer], rax
    mov qword[columnaOcaAComer], rbx
  
    calcularDesplazamineto filaObjetivo, columnaObjetivo
    mov     rdx, qword[tablero + rax] ; Cargar el valor desde tablero[rax]
    
    cmp     qword[tablero + rax], 3; si la celda objetivo es 2(hay una oca)
    je      verSiPuedeComerEnDireccionCorrespondiente; vamos a ver si se puede comer en la direccion correspondiente

    mov   qword[booleano], 1
    ret

;salta a la subrutina correspondiente dependiendo de que movimiento proviene el Zorro
verSiPuedeComerEnDireccionCorrespondiente:

    ;analizamos la situacion particulas dependiende de cual fue el ultimo movimiento (la direccion que se quiso mover el Zorro)

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

    mov  qword[booleano], 1; si no es en ninguno el booleano pasa a ser negativo
    ret

;FORMATO
;modificamos variable obejtivo dependiendo de la direccion
;vemos si esa posicion esta vacia (si hay celda vacia subsiguiente a la oca)
;si hay entonces piso las ocas

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
    ;aumentamos ocas comidas
    inc qword[ocasComidas]

    ;modificamos celda a vacia y cambiamos booleano
    cambiarCelda filaOcaAComer, columnaOcaAComer, 1    
    mov qword[ocaAcabaDeSerComida], 0

    ret

;FORMATO
; aca dependiendo que ingreso, modificamos la fila y/o columna correspondiente. Validamos que no se salio del limite y si la celda objetivo esta vacia.
; si esto se cumple, movemos el zorro a esa direccion. Sino, verifciamos si hay una oca y si se puede comer. Si esto ocurre movemos al zorro (y comemos la oca)
; si no se puede el zorro no se mueve
intentarMovZorroHaciaArriba:
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

intentarMovZorroHaciaDerecha:
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
intentarMovZorroHaciaAbajo:
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

intentarMovZorroHaciaIzquierda:
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

intentarMovZorroHaciaDiagDerArriba:
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

intentarMovZorroHaciaDiagDerAbajo:
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

intentarMovZorroHaciaDiagIzqArriba:
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

intentarMovZorroHaciaDiagIzqAbajo:
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

; Estas subrutinas son para encapsular que variable incrementar dependiendo de a que direccion se movio el zorro
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

;Ahora esta parte es para ver si el zorro quedo encerrado o no.
verSiZorroTieneMovimientoPosibles:

    ;inicializamos variable como que el zorro no puede moverse
    mov qword[sePuedeMoverZorro], 1

    ;me fijo si puede moverse en todas las direcciones, si se puede mover en alguna se trasnforma el booleano en TRUE (0) y se retorna. Si no retorna con la variable en FALSE (1)

    sub rsp, 8
    call verSiZorroPuedeMoverseHaciaArriba 
    add rsp, 8

    cmp qword[sePuedeMoverZorro], 0
    je hayMovimientoPosibleZorro

    sub rsp, 8
    call verSiZorroPuedeMoverseHaciaAbajo 
    add rsp, 8

    cmp qword[sePuedeMoverZorro], 0
    je hayMovimientoPosibleZorro

    sub rsp, 8
    call verSiZorroPuedeMoverseHaciaADerecha 
    add rsp, 8

    cmp qword[sePuedeMoverZorro], 0
    je hayMovimientoPosibleZorro

    sub rsp, 8
    call verSiZorroPuedeMoverseHaciaIzquierda 
    add rsp, 8

    cmp qword[sePuedeMoverZorro], 0
    je hayMovimientoPosibleZorro

    sub rsp, 8
    call verSiZorroPuedeMoverseHaciaDiagonalArribaDer 
    add rsp, 8

    cmp qword[sePuedeMoverZorro], 0
    je hayMovimientoPosibleZorro

    sub rsp, 8
    call verSiZorroPuedeMoverseHaciaDiagonalArribaIzq 
    add rsp, 8

    cmp qword[sePuedeMoverZorro], 0
    je hayMovimientoPosibleZorro

    sub rsp, 8
    call verSiZorroPuedeMoverseHaciaDiagonalAbajoDer 
    add rsp, 8

    cmp qword[sePuedeMoverZorro], 0
    je hayMovimientoPosibleZorro

    sub rsp, 8
    call verSiZorroPuedeMoverseHaciaDiagonalAbajoIzq 
    add rsp, 8

    cmp qword[sePuedeMoverZorro], 0
    je hayMovimientoPosibleZorro

    
    ret

; FORMATO
; Reiniciamos variables obejtivos
; Modificamos el obejtivo dependiendo de la direccion
; nos fijamos si salio del limite del tablero
; si esta vacio vamos a la subrutina que modifica las variables y retorna
; modifcamos el objetivo de nuevo en esa direccion (es decir habia una oca y hay que ver si la proxima celda esta vacia y eso significaria que la oca se puede comer)
; si esta vacio vamos a la subrutina que modifica las variables y retorna
; sino es que no hay movimientos posibles en esta direccion

verSiZorroPuedeMoverseHaciaArriba:
    mov rax, qword[columnaZorro]
    mov rbx, qword[filaZorro]
    mov qword[columnaObjetivo], rax
    mov qword[filaObjetivo], rbx

    dec qword[filaObjetivo]

    cmp qword[filaObjetivo], 0
    je zorroNoSePuedeMoverEnDireccion

    sub     rsp, 8
    call    verSiEstaVacio
    add     rsp ,8
    
    cmp qword[booleano], 0
    je zorroSePuedeMoverEnDireccion

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

    inc qword[filaObjetivo]

    cmp qword[filaObjetivo], 8
    je zorroNoSePuedeMoverEnDireccion

    sub     rsp, 8
    call    verSiEstaVacio
    add     rsp ,8
    
    cmp qword[booleano], 0
    je zorroSePuedeMoverEnDireccion

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

    inc qword[columnaObjetivo]

    cmp qword[columnaObjetivo], 8
    je zorroNoSePuedeMoverEnDireccion

    sub     rsp, 8
    call    verSiEstaVacio
    add     rsp ,8
    
    cmp qword[booleano], 0
    je zorroSePuedeMoverEnDireccion

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

    dec qword[columnaObjetivo]

    cmp qword[columnaObjetivo], 0
    je zorroNoSePuedeMoverEnDireccion

    sub     rsp, 8
    call    verSiEstaVacio
    add     rsp ,8
    
    cmp qword[booleano], 0
    je zorroSePuedeMoverEnDireccion

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

    dec qword[filaObjetivo]
    inc qword[columnaObjetivo]

    cmp qword[filaObjetivo], 0
    je zorroNoSePuedeMoverEnDireccion

    sub     rsp, 8
    call    verSiEstaVacio
    add     rsp ,8
    
    cmp qword[booleano], 0
    je zorroSePuedeMoverEnDireccion

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

    dec qword[filaObjetivo]
    dec qword[columnaObjetivo]

    cmp qword[filaObjetivo], 0
    je zorroNoSePuedeMoverEnDireccion

    sub     rsp, 8
    call    verSiEstaVacio
    add     rsp ,8
    
    cmp qword[booleano], 0
    je zorroSePuedeMoverEnDireccion

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

    inc qword[filaObjetivo]
    dec qword[columnaObjetivo]

    cmp qword[filaObjetivo], 8
    je zorroNoSePuedeMoverEnDireccion

    sub     rsp, 8
    call    verSiEstaVacio
    add     rsp ,8
    
    cmp qword[booleano], 0
    je zorroSePuedeMoverEnDireccion

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

    inc qword[filaObjetivo]
    inc qword[columnaObjetivo]

    cmp qword[filaObjetivo], 8
    je zorroNoSePuedeMoverEnDireccion

    sub     rsp, 8
    call    verSiEstaVacio
    add     rsp ,8
    
    cmp qword[booleano], 0
    je zorroSePuedeMoverEnDireccion

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

;subrutinas de retorno
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

    ;cambiamos turno
    mov qword[turno], 1

    ;si acaba de comer una oca preguntamos por saltos multiples
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
    mov qword[ocaAcabaDeSerComida], 1 ;modificamos variable para reiniciarla
    mov qword[numQueIngreso], 10 ;limpiamos buffer por si acaso

    reiniciarPantalla
    mostrarString mensajeQuiereMoverDeNuevo
    pedirNumeroAlUsuario preguntarSiQuiereMoverDeNuevo

    mov     rax, qword[numQueIngreso]

    cmp     rax, 1
    je      noCambiarTurno

    cmp     rax, 2
    je      cambiarTurno

    jmp preguntarSiQuiereMoverDeNuevo

;subrutinas de retorno dependiendo la situacion
noCambiarTurno:
    mov qword[turno], 0
    ret
cambiarTurno:
    ret

hayMovimientoPosibleZorro:
    ret

noHayMovimientoPosibleZorro:
    mov qword[sePuedeMoverZorro], 1
    ret

volverAlMenu:
    ;llamamos al menu incial de nuevo

    sub rsp, 8
    call menuInicial
    add rsp, 8
    
    ret

