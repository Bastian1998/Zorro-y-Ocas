extern puts
extern fopen
extern fgetc
extern fputs
extern fclose
extern sprintf
extern read

%macro escribirNumeroEnElArchivo 1
    
    mov rdi, numeroAEscribir    	; Destination numeroAEscribir
    mov rsi, formato        		; Format string
    mov rdx, r8
    sub rsp, 8           			; Number to format
    call sprintf
    add rsp, 8

    mov rdi, numeroAEscribir
    mov rsi, [fileHandle]
    sub rsp, 8
    call fputs
    add rsp, 8

%endmacro

%macro escribirElemento 2
    ; %1: Fila actual, %2: Columna actual
    calcularDesplazamineto %1, %2
    mov     rdx, qword[tablero + rax] ; Cargar el valor desde tablero[rax]
    lea     r8, qword[rdx] 			; copio la direccion de memoria del string correspondiente dependiendo de el elemento 

    escribirNumeroEnElArchivo numeroAEscribir
%endmacro

%macro _mostrarString 1
    mov rdi, %1 ;cargo el string
    sub rsp,8 
    call printf
    add rsp,8
%endmacro

%macro lecturaElemento 2
    mov     r11, [%1]              ; Cargar fila en r11
    mov     rcx, qword[longFila]   ; Cargar longitud de la fila
    dec     r11                    ; Convertir a índice base 0
    imul    r11, rcx               ; r11 = fila * longFila

    mov     rbx, [%2]              ; Cargar columna en rbx
    mov     r8, qword[longElemento]; Cargar longitud del elemento
    dec     rbx                    ; Convertir a índice base 0
    imul    rbx, r8                ; rbx = columna * longElemento

    add r11, rbx

    mov rdi, [fileHandle]
    mov qword[auxiliar], r11
    call fgetc

    sub rax, '0'
    ; mov [elementoArchivo], rax           
    mov r11, qword[auxiliar]

    mov qword[tablero + r11], rax  

%endmacro

section  .data
; cada elemento es de 8 bytes. -1 es si es invalido , 0 si la celda esta vacio, 2 si hay una oca, 1 si esta el zorro

    formato    		db  '%d', 0
    fileName		db	"partidaGuardada.txt", 0
	modoEscritura   db	"w+", 0
    modoLectura     db  "r", 0
    msgErrOpen      db  "Error", 0
    finLinea    	db 	10, 0
    auxiliar         dq  0

section  .bss
    fileHandle      	resq 1    ; Espacio para el puntero al archivo    
    elementoArchivo     resq 1    ; Variable temporal para almacenar valores convertidos
    numeroAEscribir     resq 1

section  .text

guardarArchivo:

    mov rdi, fileName
    mov rsi, modoEscritura

    sub rsp, 8 
    call fopen
    add rsp, 8

    cmp rax, 0
    jg archivoAbiertoEscritura

    mov rdi, msgErrOpen
    call puts
    jmp fin

archivoAbiertoEscritura:
    mov [fileHandle], rax
    mov qword[filaActual], 1
    mov qword[columnaActual], 1
	jmp filasArchivoEscritura

filasArchivoEscritura:
    escribirElemento filaActual, columnaActual ; mostramos el elemento i,j
    inc qword[columnaActual]    ; incrementamos en 1 la columna
    cmp qword[columnaActual], 8
    je proximaFilaEscritura     ; si la columna es <7; saltamos a la siguiente fila
    jmp filasArchivoEscritura

proximaFilaEscritura:
    mov qword[columnaActual], 1 ; reiniciamos columnas
    add qword[filaActual], 1    ; aumentamos en uno la fila
    cmp qword[filaActual], 8
    je finArchivo               ; si fila > 7, damos por finalizada la matriz
    jmp filasArchivoEscritura

finArchivo:
    jmp escrbirEstadoActualEstadisticas
    ret	

lecturaArchivo:
    mov rdi, fileName
    mov rsi, modoLectura

    sub rsp, 8 
    call fopen
    add rsp, 8 

    cmp rax, 0
    jg archivoAbiertoLectura

    mov qword[seAbrioArchivo], 1
    jmp finArchivo

archivoAbiertoLectura:
    mov [fileHandle], rax
    mov qword[filaActual], 1
    mov qword[columnaActual], 1
	jmp filasArchivoLectura

filasArchivoLectura:
    lecturaElemento filaActual, columnaActual
    inc qword[columnaActual]    ; incrementamos en 1 la columna
    cmp qword[columnaActual], 8
    je proximaFilaLectura       ; si la columna es <7; saltamos a la siguiente fila
    
    jmp filasArchivoLectura

proximaFilaLectura:
    mov qword[columnaActual], 1 ; reiniciamos columnas
    add qword[filaActual], 1    ; aumentamos en uno la fila
    cmp qword[filaActual], 8
    je finArchivo               ; si fila > 7, damos por finalizada la matriz
    jmp filasArchivoLectura

escrbirEstadoActualEstadisticas:
    