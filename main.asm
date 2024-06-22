global  main
%include 'mostrarTablero.asm'
%include 'movimientosEnElTablero.asm'
%include 'manejoArchivos.asm'
%include 'menu.asm'
%include 'mensajesGrandes.asm'
%include 'cambiarOrientacion.asm'
%include 'personalizarSimbolos.asm'
extern  gets
extern  sscanf      
extern system  
extern unlink

section  .data
        numeroDebug                                 db 10,'el numero es %li',10,10, 0 ;string que uso para debuguear
        mensajeJuegoTerminadoPorOCas                db 10,'El juego ha terminado porque el Zorro comió 12 ocas. ¡Felicidades Zorro!.',10,10, 0 ;string que uso para debuguear
        mensajeJuegoTerminadoPorZorroEncerrado      db 10,'El juego ha terminado porque el Zorro esta encerrado. ¡Felicidades Ocas!.',10,10, 0 ;string que uso para debuguear
        mensajePorAhora                             db 10, 'Por ahora....', 10, 0
        cdmClear                                    db 'clear',0
        fin                                         dq  1
        sePuedeMoverZorro                           dq  0 
        tablero                                     dq  0,0,3,3,3,0,0 ; el tablero en su estado inicial
                                                    dq  0,0,3,3,3,0,0
                                                    dq  3,3,3,3,3,3,3
                                                    dq  3,1,1,1,1,1,3
                                                    dq	3,1,1,2,1,1,3
                                                    dq	0,0,1,1,1,0,0
                                                    dq	0,0,1,1,1,0,0

section  .bss
        
section  .text
main:

    sub rsp, 8
    call menu 
    add rsp, 8

    cmp qword[fin], 0
    je pausaElJuego

    sub rsp, 8
    call jugar 
    add rsp, 8

    ret

jugar:
    reiniciarPantalla

    sub rsp, 8
    call solicitarMovimiento ;solicitio un movimiento ya sea al Zorro o a las Ocas
    add rsp, 8

    sub rsp, 8
    call guardarArchivo; se guarda automaticamente todo el tiempo
    add rsp, 8

    cmp qword[fin], 0 ;termino el juego porque lo pausaron
    je  pausaElJuego

    sub rsp, 8
    call verSiTerminoElJuego ;solicitio un movimiento ya sea al Zorro o a las Ocas
    add rsp, 8

    cmp qword[fin], 0 ;termino el juego porque lo pausaron
    je  finDelJuego

    jmp jugar ;volvemos a iterar
    ret


verSiTerminoElJuego:
   
    cmp qword[ocasComidas], 12
    je  finalizarJuegoPorOcasComidas

    sub rsp, 8
    call verSiZorroTieneMovimientoPosibles ;solicitio un movimiento ya sea al Zorro o a las Ocas
    add rsp, 8

    cmp qword[sePuedeMoverZorro], 1
    je finalizarPorZorroEncerrado
    
    ret

finalizarJuegoPorOcasComidas:
    mov qword[fin], 0
    mostrarString mensajeJuegoTerminadoPorOCas
    ret

finalizarPorZorroEncerrado:
    mov qword[fin], 0
    reiniciarPantalla
    mostrarString mensajeJuegoTerminadoPorZorroEncerrado
    ret


pausaElJuego:
    reinicarPantalla
    mostrarString mensajeFin
    mostrarString mensajePorAhora
    sub rsp, 8
    call mostrarEstadisticasZorro
    add rsp, 8
    ;terminar el juego
    ret

finDelJuego:
    mostrarString mensajeGameOver
    sub rsp, 8
    call mostrarEstadisticasZorro
    add rsp, 8
    mov rdi, fileName

    sub rsp, 8
    call unlink
    add rsp, 8

    ;eliminarArchivo
    ;terminar el juego
    ret
