global  main

%include 'creacionMatriz.asm'                   
section  .bss

section  .text

tablero     dq  -1,-1,2,2,2,-1,-1
            dq  -1,-1,2,2,2,-1,-1
            dq   2,2,2,2,2,2,2
			dq   2,0,0,0,0,0,2
			dq	 2,0,0,1,0,0,2
			dq	-1,-1,0,0,0,-1,-1
			dq	-1,-1,0,0,0,-1,-1
main:
    jmp mostrarMatriz
    ; W 
    A S D
    
mostrarMatriz:
    mostrarString techoPiso; mostramos techo
    jmp recorrerMatriz
    jmp fin


fin:
    mostrarString techoPiso
    ret

    
