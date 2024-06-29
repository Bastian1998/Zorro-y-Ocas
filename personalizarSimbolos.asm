section  .data
    mensajePersonalizarSimbolos db 10,10,'Presione la opcion deseada: ',10,10, '1. Personalizar Zorro', 10,10,'2. Personalizar Oca',10,10,'3. Restablecer simbolos por defecto',10,10,'4. Salir',10, 10, 0
    mensajePersonalizarZorro    db 10,10,'Ingrese el Simbolo que va a representar al Zorro', 10,0
    simboloZorroOriginal        db 'Z', 0
    simboloOcaOriginal          db 'O', 0
    
section  .bss
        
section  .text

%macro pedirCaracterUsuario 0
    ;subrutina que le pide un string al usuario y almacena en buffer un string que contiene solo el primer caracter

    mov     rdi, buffer

    sub     rsp, 8
    call    gets
    add     rsp ,8

    mov     byte[buffer + 1], 0
%endmacro


personalizarSimbolos:

    mov qword[numQueIngreso], 10; limpiamos buffer
    reiniciarPantalla

    mostrarString mensajePersonalizarSimbolos
    pedirNumeroAlUsuario personalizarSimbolos

    mov     rax, qword[numQueIngreso]
    ;vamos ala situacion correspondiente dependiendo que numero ingreso el usuario

    cmp     rax, 1
    je      personalizarZorro

    cmp     rax, 2
    je      personalizarOca

    cmp     rax, 3
    je      simbolosPorDefecto

    cmp     rax, 4
    je      menuInicial

    jmp     personalizarSimbolos

;Tanto como para Simbolo Zorro y Simbolo Oca pedimos el caracter y no importa cual sea lo modificamos
personalizarZorro:
    mostrarString mensajePersonalizarZorro
    pedirCaracterUsuario

    mov al, [buffer]            ; Leer el primer carácter del buffer
    mov [simboloZorro], al      ; Guardar el primer carácter en simboloZorro

    jmp personalizarSimbolos

personalizarOca:
    mostrarString mensajePersonalizarZorro
    pedirCaracterUsuario

    mov al, [buffer]            ; Leer el primer carácter del buffer
    mov [simboloOca], al      ; Guardar el primer carácter en simboloZorro

    jmp personalizarSimbolos

;reestablecemos los simbolos por los originales
simbolosPorDefecto:

    mov al, [simboloOcaOriginal]            ; Leer el primer carácter del buffer
    mov [simboloOca], al      ; Guardar el primer carácter en simboloZorro

    mov al, [simboloZorroOriginal]            ; Leer el primer carácter del buffer
    mov [simboloZorro], al      ; Guardar el primer carácter en simboloZorro

    jmp personalizarSimbolos



    
