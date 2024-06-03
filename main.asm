global  main

%include 'creacionMatriz.asm'                   
section  .bss

section  .text

    mensajeDireccionesZorro db 10, 'Zorro: Seleccione en que dirección moverse', 10, '8: Adelante', 10, '6: Derecha', 10, '4: Izquierda', 10, '2: Abajo', 10, '9: Diagonal arriba/derecha', 10, '7: Diagonal arriba/izquierda', 10, '1: Diagonal abajo/izquierda', 10, '3: Diagonal abajo/derecha', 10,10, 0
    mensajeDireccionesOca db 10, 'Oca: Seleccione en que dirección moverse', 10, 0

    tablero     dq  -1,-1,2,2,2,-1,-1
                dq  -1,-1,2,2,2,-1,-1
                dq   2,2,2,2,2,2,2
			    dq   2,0,0,0,0,0,2
			    dq	 2,0,0,1,0,0,2
			    dq	-1,-1,0,0,0,-1,-1
			    dq	-1,-1,0,0,0,-1,-1
main:

    sub rsp, 8
    call mostrarMatriz
    add rsp, 8

    sub rsp, 8
    call solicitarMovimiento
    add rsp, 8
    
    ret
    
mostrarMatriz:
    mostrarString techoPiso
    
    sub rsp, 8
    call recorrerMatriz;
    add rsp, 8

    mostrarString techoPiso
    ret

solicitarMovimiento:
    mostrarString mensajeDireccionesZorro

    

    ret

