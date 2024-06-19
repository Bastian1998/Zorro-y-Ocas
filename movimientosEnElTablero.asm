extern  printf
extern puts

%include 'auxiliar.asm'
%include 'movimientosZorro.asm'
%include 'movimientosOcas.asm'

section  .data
    ;numero que representan los movimeintos
    teclaMovArriba              dq 8
    teclaMovDer                 dq 6
    teclaMovIzq                 dq 4
    teclaMovAbajo               dq 2
    teclaMovDiagDerArriba       dq 9
    teclaMovDiagIzqArriba       dq 7
    teclaMovDiagIzqAbajo        dq 1
    teclaMovDiagDerAbajo        dq 3
    teclaFinDelJuego            dq 0
    teclaVolverASeleccionarOca  dq 5
       
    turno                   dq   0; 0 si es el turno del zorro, 1 si es el turno de las ocas   
    filaZorro               dq   5 ;fila actual del zorro
    columnaZorro            dq   4 ;columna actual del zorro
    filaObjetivo            dq   5 ;fila a la que se quiere mover ya seal el zorro o las ocas
    columnaObjetivo         dq   4 ;columna a la que se quiere mover ya sea el zorro o las ocas
    numFormat               db  '%li', 0  ; %i 32 bits / %li 64 bits
    mensajeFin              db   10, 10, '¡Haz decidio finalizar el juego en este estado! Es una pena.... Por suerte tu partida ha sido guardada automaticamente. Cuando vuelvas a ingresar al juego puedes continuar..', 10, 0; %i 32 bits / %li 64 bits
       
section  .bss
    aux                 resq 1
    buffer              resb 64
    numQueIngreso       resq 1
    booleano            resq 1
    ultimoMovimiento    resq 1

section  .text

booleanoTrue:
    mov qword[booleano], 0; si se llamo a esta subrutina el booleano tiene que convertirse en 0 (true)
    ret

solicitarMovimiento:

    ;solicito movimiento dependiendo de quien sea el turno

    cmp    qword[turno], 0
    je     solicitarMovimientoZorro

    cmp     qword[turno], 1
    je     solicitarAccionOca
    
    ret

volverAPedirMovimiento:
    ;retornamos al punto donde estabamos
    ret

finalizarJuego:
    ;limpiamos pantalla, mostramos ultimo estado actual y le avisamos al usuario que el juego terminó

    limpiarPantalla
    sub rsp, 8
    call mostrarMatriz
    add rsp, 8

    mov qword[fin], 0
    ret





