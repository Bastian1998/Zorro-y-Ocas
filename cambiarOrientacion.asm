section  .data
    mensajeMenuCambioOrientacion db 10,10,'Presione la opcion deseada: ',10,10, '1. Girar tablero 90°', 10,10,'2. Salir',10,10,0
        
section  .bss
        
section  .text


cambiarOrientacion:

    mov qword[numQueIngreso], 10

    reiniciarPantalla
    mostrarString mensajeMenuCambioOrientacion
    pedirNumeroAlUsuario cambiarOrientacion

    mov     rax, qword[numQueIngreso]

    cmp     rax, 1
    je      rotarMatriz

    cmp     rax, 2
    je      menuInicial

    jmp cambiarOrientacion
    
rotarMatriz:
    jmp cambiarOrientacion