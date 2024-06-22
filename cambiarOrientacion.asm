extern puts
section  .data
    mensajeMenuCambioOrientacion db 10,10,'Presione la opcion deseada: ',10,10, '1. Girar tablero 90°', 10,10,'2. Salir',10,10,0
    matrixRank  dq 6        ; adjusted matrix rank when i and j start at 0
        
section  .bss

    matrixBuffer    resq 49 ; Espacio para la matriz buffer
        
section  .text


cambiarOrientacion:

    mov qword[numQueIngreso], 10

    reiniciarPantalla
    mostrarString mensajeMenuCambioOrientacion
    pedirNumeroAlUsuario cambiarOrientacion

    mov     rax, qword[numQueIngreso]

    cmp     rax, 1
    je      transposeMatrix

    cmp     rax, 2
    je      menuInicial

    jmp cambiarOrientacion
    

transposeMatrix:

    xor rbx, rbx                ; row index i = 0
    xor rcx, rcx                ; column index j = 0

transposeOuterLoop:

    cmp rcx, 7
    jg swapMatrixRows       ; If j > 7 end loop
    mov rbx, 0       ; Reset i = 0
    
transposeInnerLoop:

    mov rdx, rbx    ; rdx = i
    imul rdx, qword[longFila]
    mov r8, qword[longElemento]
    imul r8, rcx
    add rdx, r8         ; rdx = i * longFila + j * longElemento
    
    mov r9, qword[tablero + rdx]   ; Load element from source matrix[j][i]

    xor rdx, rdx ; Clean aux registers
    xor r8, r8

    mov rdx, rcx    ; rdx = j
    imul rdx, qword[longFila]
    mov r8, qword[longElemento]
    imul r8, rbx
    add rdx, r8         ; rdx = j * longFila + i * longElemento

    mov qword[matrixBuffer + rdx], r9    ; Store element in buffer[i][j]

    inc rbx          ; i += 1
    cmp rbx, 7
    jl transposeInnerLoop     ; Jump to innerLoop if rbx < 7 (i < 7)
    inc rcx
    jmp transposeOuterLoop

swapMatrixRows:

    xor rbx, rbx                ; row index i = 0
    xor rcx, rcx                ; column index j = 0

swapOuterLoop:

    cmp rcx, 7
    jg swapEndLoop       ; If j > 7 end loop
    mov rbx, 0       ; Reset i = 0
    
swapInnerLoop:

    mov rdx, rcx    ; rdx = j
    imul rdx, qword[longFila]
    mov r8, qword[longElemento]
    imul r8, rbx
    add rdx, r8         ; rdx = i * longFila + j * longElemento
    
    mov r9, qword[matrixBuffer + rdx]   ; Load element from source buffer[j][i]

    xor rdx, rdx ; Clean aux registers
    xor r8, r8

    mov rdx, rcx    ; rdx = j
    mov r10, qword[matrixRank]  ; r10 = 6
    sub r10, rdx  ; r10 = 6 - j (fila opuesta)
    mov rdx, r10    ;rdx = 6 - j
    imul rdx, qword[longFila]
    mov r8, qword[longElemento]
    imul r8, rbx
    add rdx, r8         ; rdx = (6 - j) * longFila + i * longElemento
    
    mov qword[tablero + rdx], r9    ; Store element in tablero[6 - j][i]

    inc rbx          ; i += 1
    cmp rbx, 7
    jl swapInnerLoop     ; Jump to innerLoop if rbx < 7 (i < 7)
    inc rcx
    jmp swapOuterLoop

swapEndLoop:
    xor rbx, rbx                ; i = 0
    xor rcx, rcx                ; j = 0
    jmp cambiarOrientacion