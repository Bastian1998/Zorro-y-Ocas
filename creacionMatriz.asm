global  main
extern  printf
extern puts

%macro mostrar_elemento 1
    mov     rdi,%1
    sub     rsp,8
    call    puts
    add     rsp,8
%endmacro

section  .data
; cada elemento es de 2 bytes. ' ' es si es invalido , 'V' si la celda esta vacio, O  si hay una ocas, X si esta el zorro
    tablero         dw  ' ', ' ', 'O', 'O', 'O', ' ', ' '   
                    dw  ' ', ' ', 'O', 'O', 'O', ' ', ' '
                    dw  'O', 'O', 'O', 'O', 'O', 'O', 'O' 
                    dw  'O', 'V', 'V', 'V', 'V', 'V', 'O'
                    dw  'O', 'V', 'V', 'X', 'V', 'V', 'O'
                    dw  ' ', ' ', 'V', 'V', 'V', ' ', ' ' 
                    dw  ' ', ' ', 'V', 'V', 'V', ' ', ' ' 
    mensaje             db  'PrintACA',0
    cantFilas           dq 7
    cantColumnas        dq 7
    longElemento        dq 2
    fila_actual         dq 1
    columna_actual      dq 1
                                   
section  .bss

section  .text
main:
    jmp     mostrar_elemento_i_j
    
mostrar_elemento_i_j:
    mov rax, [fila_actual]; movemos la fila actual
    mov rbx, [columna_actual]; movemos la columna actual
    mov rcx, tablero; movemos la direccion donde arranca la matriz (tablero)
    mov rdx, 2; muevo la longitud del elemento
    imul rdx, 7; Aca guardamos longitud de la fila 
    dec rax ; i -1
    imul rax, rdx; (i -1)*longitud de fila
    dec rbx; (j - 1)
    imul rbx, [longElemento]; (j -1)* longitud elemento
    add rax, rbx; RAX la posicion de (i, j)
    ;llega
    add rcx, rax; tablero + (i -1)*longitud de fila + (j -1)* longitud elemento
    mov r8, [rcx]
    ;no llega
    mostrar_elemento r8; llamo a la macros
    inc qword[columna_actual]; aumento la J
    cmp qword[columna_actual],8; si termine de mostrar la FILA entera
    je  siguiente_fila; paso a la siguiente
    jmp mostrar_elemento_i_j; vuelvo al LOOP

siguiente_fila:
    mov qword[columna_actual], 0; reinicio las columnas
    inc qword[fila_actual]; aumento la fila
    mostrar_elemento 10; muestro un salto de linea
    cmp qword[fila_actual], 8; me fijo se terminaron las FILAS
    je fin; termino el programa
    jmp  mostrar_elemento_i_j; vuelvo al loop


fin:
    ret
