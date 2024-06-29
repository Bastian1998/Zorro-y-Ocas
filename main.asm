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
    call menu  ;llamada a menu inicial
    add rsp, 8

    cmp qword[fin], 0 ;pregunta si el usuario elijio salir desde 
    je pausaElJuego 

    sub rsp, 8
    call jugar; entrada al juego
    add rsp, 8

    ret

jugar:
    reiniciarPantalla

    sub rsp, 8
    call solicitarMovimiento ;solicitio un movimiento ya sea al Zorro o a las Ocas
    add rsp, 8

    sub rsp, 8
    call guardarArchivo; se guarda automaticamente todo el tiempo el juego, asi si hay alguna interrupcion del juego, no se pierde todo
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
    ;analizo todas las situaciones que podrian dar por terminada el juego

    cmp qword[ocasComidas], 12
    je  finalizarJuegoPorOcasComidas ;finalizo el juego si el zorro comio 12 ocas

    sub rsp, 8
    call verSiZorroTieneMovimientoPosibles ;verifico si el zorro tiene algun movimiento posible
    add rsp, 8

    cmp qword[sePuedeMoverZorro], 1
    je finalizarPorZorroEncerrado ; si la variable es 1(Falso), finalizo el juego por estar el zorro encerrado
    
    ret

finalizarJuegoPorOcasComidas:
    mov qword[fin], 0; cambio a 0 (True) la variable que representa la finalizacion del juego
    reiniciarPantalla 
    mostrarString mensajeJuegoTerminadoPorOCas; 
    ret

finalizarPorZorroEncerrado:
    mov qword[fin], 0 ;cambio a 0 (True) la variable que representa la finalizacion del juego
    reiniciarPantalla 
    mostrarString mensajeJuegoTerminadoPorZorroEncerrado
    ret


pausaElJuego:
    reinicarPantalla
    mostrarString mensajeFin
    mostrarString mensajePorAhora

    sub rsp, 8
    call mostrarEstadisticasZorro; muestro estadisticas actuales del juego
    add rsp, 8

    sub rsp, 8
    call guardarArchivo; se guarda automaticamente todo el tiempo el juego, asi si hay alguna interrupcion del juego, no se pierde todo
    add rsp, 8

    ;pausar el juego
    ret

finDelJuego:
    ;finalizacion de la partida, muestra las estadisticas finales y elimina el archivo, asi no hay punto de carga
    mostrarString mensajeGameOver
    sub rsp, 8
    call mostrarEstadisticasZorro; muestro estadisticas final del juego
    add rsp, 8

    mov rdi, fileName
    sub rsp, 8
    call unlink; elimino archivo
    add rsp, 8
    ;finalizo el juego
    ret
