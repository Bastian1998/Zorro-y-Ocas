global  main
%include 'mostrarTablero.asm'
%include 'movimientosEnElTablero.asm'
extern  gets
extern  sscanf      
extern system     


%macro mostrarNumeroDebug 1
    mov rdi, numeroDebug ;cargo el string
    mov rsi, %1
    sub rsp,8 
    call printf
    add rsp,8
%endmacro

%macro limpiarPantalla 0
    mov rdi, cdmClear
    sub rsp,8
    call system
    add rsp,8
%endmacro

section  .data
        numeroDebug   db 10,'el numero es %li',10,10, 0
        cdmClear      db 'clear',0

        tablero     dq  -1,-1,2,2,2,-1,-1
                    dq  -1,-1,2,2,2,-1,-1
                    dq   2,2,2,2,2,2,2
                    dq   2,0,0,0,0,0,2
                    dq	 2,0,0,1,0,0,2
                    dq	-1,-1,0,0,0,-1,-1
                    dq	-1,-1,0,0,0,-1,-1

section  .bss
        
section  .text
main:

    limpiarPantalla

    sub rsp, 8
    call mostrarMatriz
    add rsp, 8

    sub rsp, 8
    call solicitarMovimiento
    add rsp, 8

    jmp main
    ret
    

    





