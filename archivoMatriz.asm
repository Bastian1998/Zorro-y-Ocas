extern puts
extern fopen
extern fputs
extern fclose
extern sprintf

%macro escribirElemento 2
    ; %1: Fila actual, %2: Columna actual
    mov     rax, [%1]              ; Cargar fila en rax
    mov     rcx, qword[longFila]   ; Cargar longitud de la fila
    dec     rax                    ; Convertir a índice base 0
    imul    rax, rcx               ; rax = fila * longFila

    mov     rbx, [%2]              ; Cargar columna en rbx
    mov     r8, qword[longElemento]; Cargar longitud del elemento
    dec     rbx                    ; Convertir a índice base 0
    imul    rbx, r8                ; rbx = columna * longElemento

    add     rax, rbx               ; rax = rax + rbx, posición total en el tablero
    mov     rdx, qword[tablero + rax] ; Cargar el valor desde tablero[rax]

    lea     r8, qword[rdx] 			; copio la direccion de memoria del string correspondiente dependiendo de el elemento 

    mov rdi, numeroAEscribir    	; Destination numeroAEscribir
    mov rsi, formato        		; Format string
    mov rdx, r8           			; Number to format
    call sprintf

    mov rdi, numeroAEscribir
    mov rsi, [fileHandle]
    call fputs

%endmacro


section  .data
; cada elemento es de 8 bytes. -1 es si es invalido , 0 si la celda esta vacio, 2 si hay una oca, 1 si esta el zorro

    formato    		db '%d ', 0
    
    fileName		db	"partidaGuardada.txt", 0
	mode		    db	"w+", 0
	msgErrOpen      db  "Error en apertura de archivo", 0
    finLinea    	db 	10, 0
                                   
section  .bss
    fileHandle      	resq 1
    numeroAEscribir     resb 20
section  .text

guardarArchivo:
    sub rsp, 8 
    ; Open file for writing
    mov rdi, fileName
    mov rsi, mode
    call fopen

    cmp rax, 0
    jg archivoAbierto

    ; Error opening file
    mov rdi, msgErrOpen
    call puts
    jmp fin

archivoAbierto:
    mov [fileHandle], rax
    mov qword[filaActual], 1
    mov qword[columnaActual], 1
	jmp filasArc


filasArc:
    escribirElemento filaActual, columnaActual ; mostramos el elemento i,j

    inc qword[columnaActual]; incrementamos en 1 la columna
    cmp qword[columnaActual], 8
    je proximaFila ; si la columna es <7; saltamos a la siguiente fila
    jmp filasArc

proximaFila:
    mov rdi, saltoDeLinea
    mov rsi, [fileHandle]
    call fputs

    mov qword[columnaActual], 1; reiniciamos columnas
    add qword[filaActual], 1; aumentamos en uno la fila
    cmp qword[filaActual], 8
    je fin; si fila > 7, damos por finalizada la matriz
    jmp filasArc

fin:
    add rsp, 8 
    ret	