global  main
%include 'mostrarTablero.asm'
%include 'movimientosEnElTablero.asm'
%include 'manejoArchivos.asm'

extern  gets
extern  sscanf      
extern system     

section  .data
        numeroDebug     db 10,'el numero es %li',10,10, 0 ;string que uso para debuguear
        cdmClear        db 'clear',0
        fin             dq  1

        tablero         dq  0,0,3,3,3,0,0 ; el tablero en su estado inicial
                        dq  0,0,3,3,3,0,0
                        dq  3,3,3,3,3,3,3
                        dq  3,1,1,1,1,1,3
                        dq	3,1,1,2,1,1,3
                        dq	0,0,1,1,1,0,0
                        dq	0,0,1,1,1,0,0

section  .bss
        
section  .text
main:
    limpiarPantalla; limpio la pantalla en cada iteración

    sub rsp, 8
    call mostrarMatriz ;muestro el estado actual del tablero
    add rsp, 8

    sub rsp, 8
    call solicitarMovimiento ;solicitio un movimiento ya sea al Zorro o a las Ocas
    add rsp, 8

    cmp qword[fin], 0 ;termino el juego
    je  finDelJuego

    jmp main ;volvemos a iterar
    ret
finDelJuego:
    ;terminar el juego
    sub rsp, 8
    call guardarArchivo
    add rsp, 8
    ret
