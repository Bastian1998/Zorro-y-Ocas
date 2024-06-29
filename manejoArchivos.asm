extern puts
extern fopen
extern fgetc
extern fputs
extern fclose
extern sprintf
extern read

%macro escribirNumeroEnElArchivo 1
    ;%1: entero a escribir
    ;transformo el numero recibio por parametro en un string y lo inserto en el archivo

    mov rdi, numeroAEscribir   
    mov rsi, formato        		
    mov rdx, %1
    
    sub rsp, 8           			
    call sprintf; trasnformo a string
    add rsp, 8

    mov rdi, numeroAEscribir
    mov rsi, [fileHandle]

    sub rsp, 8
    call fputs; escribo en archivo
    add rsp, 8

%endmacro

%macro obtenerProximoNumeroArchivo 0
    ;obtengo el proximo caracter el archivo (siempre va a ser un numero) y lo convierto en entero (guardo en RAX)

    mov rdi, [fileHandle]
    
    sub rsp, 8
    call fgetc; obtengo proximo caracter
    add rsp, 8

    sub rax, '0'; trasnformo en entero
%endmacro

%macro escribirElemento 2
    ; %1: Fila actual, %2: Columna actual

    calcularDesplazamineto %1, %2; caluclo desplazamiento necesario para obetenr el elemento en la matriz
    mov     rdx, qword[tablero + rax] ; Cargar el valor en rdx
    lea     r8, qword[rdx]; cargo en r8 la direccion del elemento que esta en rdx

    escribirNumeroEnElArchivo r8; escribo en el archivo el numero 
%endmacro

%macro lecturaElemento 2
    ; %1: Fila actual, %2: Columna actual

    mov     r11, [%1]              ; Cargar fila en r11
    mov     rcx, qword[longFila]   ; Cargar longitud de la fila
    dec     r11                    ; Convertir a índice base 0
    imul    r11, rcx               ; r11 = fila * longFila

    mov     rbx, [%2]              ; Cargar columna en rbx
    mov     r8, qword[longElemento]; Cargar longitud del elemento
    dec     rbx                    ; Convertir a índice base 0
    imul    rbx, r8                ; rbx = columna * longElemento

    add r11, rbx; en r11 se carga el desplazamiento necesario para obtener la posicion de memoria de la fila y columna

    mov rdi, [fileHandle]; cargo en el rdi el puntero al archivo
    mov qword[auxiliar], r11; guardo en auxiliar el desplazamiento (el fgetc me modificaba r11 a veces)

    sub rsp, 8
    call fgetc; leo el proximo elemento del archvio
    add rsp, 8

    sub rax, '0'; transformo el string en un numero          
    mov r11, qword[auxiliar]; vuelvo a cargar en r11

    mov qword[tablero + r11], rax; inserto en la matriz el numero correspondiente

%endmacro

section  .data
; cada elemento es de 8 bytes. -1 es si es invalido , 0 si la celda esta vacio, 2 si hay una oca, 1 si esta el zorro

    formato    		        db  '%d', 0
    fileName		        db	"partidaGuardada.txt", 0
	modoEscritura           db	"w+", 0
    modoLectura             db  "r", 0
    mensajeErrorApertura    db  10, "La partida no pudo ser cargada correctamente. Deberan arrancar de nuevo", 10, 0
    auxiliar                dq  0

section  .bss
    fileHandle      	resq 1    ; Espacio para el puntero al archivo    
    elementoArchivo     resq 1    ; Variable temporal para almacenar valores convertidos
    numeroAEscribir     resq 1    ; Variable que recibe los numeros ya convertidos a enteros

section  .text

guardarArchivo:

    mov rdi, fileName
    mov rsi, modoEscritura

    sub rsp, 8 
    call fopen; abro archivo
    add rsp, 8

    cmp rax, 0
    jg archivoAbiertoEscritura; si se abrio el archivo voy a escribir

    mostrarString mensajeErrorApertura
    ret

archivoAbiertoEscritura:
    mov qword[fileHandle], rax
    mov qword[filaActual], 1
    mov qword[columnaActual], 1
	jmp filasArchivoEscritura

filasArchivoEscritura:
    escribirElemento filaActual, columnaActual ; escribimos el elemento i,j
    inc qword[columnaActual]    ; incrementamos en 1 la columna

    cmp qword[columnaActual], 8
    je proximaFilaEscritura     ; si la columna es > 7; saltamos a la siguiente fila

    jmp filasArchivoEscritura; sino volvemos al loop

proximaFilaEscritura:
    mov qword[columnaActual], 1 ; reiniciamos columnas
    add qword[filaActual], 1    ; aumentamos en uno la fila

    cmp qword[filaActual], 8
    je finEscrituraArchivo      ; si fila > 7, damos por finalizada la matriz

    jmp filasArchivoEscritura

escrbirEstadoActualEstadisticas:
    ;escribimos todas las estadisticas necesarias

    escribirNumeroEnElArchivo qword[filaZorro]
    escribirNumeroEnElArchivo qword[columnaZorro]
    escribirNumeroEnElArchivo qword[turno]
    escribirNumeroEnElArchivo qword[ocasComidas]
    escribirNumeroEnElArchivo qword[cantMovZorroArriba]
    escribirNumeroEnElArchivo qword[cantMovZorroAbajo]
    escribirNumeroEnElArchivo qword[cantMovZorroDerecha]
    escribirNumeroEnElArchivo qword[cantMovZorroIzquierda]
    escribirNumeroEnElArchivo qword[cantMovZorroDiagArribaDer]
    escribirNumeroEnElArchivo qword[cantMovZorroDiagArribaIzq]
    escribirNumeroEnElArchivo qword[cantMovZorroDiagAbajoDer]
    escribirNumeroEnElArchivo qword[cantMovZorroDiagAbajoIzq]
    escribirNumeroEnElArchivo qword[orientacionTablero]
    escribirNumeroEnElArchivo qword[direccionProhibidaOca]

    ret

finEscrituraArchivo:

    sub rsp, 8 
    call escrbirEstadoActualEstadisticas ; escribimos le estado actual de las estadisticas
    add rsp, 8

    jmp cerrarArchivo

lecturaArchivo:
    mov rdi, fileName
    mov rsi, modoLectura

    sub rsp, 8 
    call fopen ;abrimos archivo
    add rsp, 8 

    cmp rax, 0
    jg archivoAbiertoLectura; si se logro abrir el archivo vamos a leerlo

    mov qword[seAbrioArchivo], 1; modificamos la variable que identifica si se abrio el archivo
    ret

archivoAbiertoLectura:
    mov [fileHandle], rax
    mov qword[filaActual], 1
    mov qword[columnaActual], 1
	jmp filasArchivoLectura

filasArchivoLectura:
    lecturaElemento filaActual, columnaActual
    inc qword[columnaActual]    ; incrementamos en 1 la columna

    cmp qword[columnaActual], 8
    je proximaFilaLectura       ; si la columna es >7; saltamos a la siguiente fila
    
    jmp filasArchivoLectura

proximaFilaLectura:
    mov qword[columnaActual], 1 ; reiniciamos columnas
    add qword[filaActual], 1    ; aumentamos en uno la fila

    cmp qword[filaActual], 8
    je finLecturaArchivo        ; si fila > 7, damos por finalizada la matriz
    
    jmp filasArchivoLectura

leerEstadoActualEstadisticas:
    ;leemos las estadisticas necesarias y las cargamos en las variables

    obtenerProximoNumeroArchivo
    mov qword[filaZorro], rax

    obtenerProximoNumeroArchivo
    mov qword[columnaZorro], rax

    obtenerProximoNumeroArchivo
    mov qword[turno], rax

    obtenerProximoNumeroArchivo
    mov qword[ocasComidas], rax

    obtenerProximoNumeroArchivo
    mov qword[cantMovZorroArriba], rax

    obtenerProximoNumeroArchivo
    mov qword[cantMovZorroAbajo], rax

    obtenerProximoNumeroArchivo
    mov qword[cantMovZorroDerecha], rax

    obtenerProximoNumeroArchivo
    mov qword[cantMovZorroIzquierda], rax

    obtenerProximoNumeroArchivo
    mov qword[cantMovZorroDiagArribaDer], rax

    obtenerProximoNumeroArchivo
    mov qword[cantMovZorroDiagArribaIzq], rax

    obtenerProximoNumeroArchivo
    mov qword[cantMovZorroDiagAbajoDer], rax

    obtenerProximoNumeroArchivo
    mov qword[cantMovZorroDiagAbajoIzq], rax

    obtenerProximoNumeroArchivo
    mov qword[orientacionTablero], rax

    obtenerProximoNumeroArchivo
    mov qword[direccionProhibidaOca], rax
    
    ret

finLecturaArchivo:

    sub rsp, 8 
    call leerEstadoActualEstadisticas; leemos y cargamos las estadisticas del archivo
    add rsp, 8

    jmp cerrarArchivo	

cerrarArchivo:
    mov rdi, [fileHandle]     ; Manejador de archivo

    sub rsp, 8                 ; Ajustar la pila para alineación
    call fclose                ; Llamar a fclose
    add rsp, 8                 ; Restaurar la pila
    
    ret	





