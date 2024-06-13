extern  printf
extern puts
section  .data
    
    seAbrioArchivo  dq  0
    mensajeCargarArchivo db 10,'¿Deseas cargar la partida en el punto que la dejaste la última vez?',10,10, '1. Si', 10,10,'2. No',10,10,0
    mensajeMenuInicial   db 10,10,'1. Iniciar partida',10, '2. Elegir orientiacón del tablero',10,'3. Personalizar simbolos',10,'4. Salir',10,10,10,0

section  .text

menu:
    limpiarPantalla
    
    sub rsp, 8
    call cargarPartida 
    add rsp, 8

    sub rsp, 8
    call menuInicial 
    add rsp, 8

    ret
    
menuInicial:
    limpiarPantalla
    mostrarString mensajeMenu
    mostrarString mensajeMenuInicial

    pedirNumeroAlUsuario menuInicial

    ;me fijo si la fila esta entre [1, 7], sino vuelvo a solicitar
    cmp     qword[numQueIngreso], 1
    je      retornar

    ;cmp     qword[numQueIngreso], 2
    ;je      cambiarOrientacion

    ;cmp     qword[numQueIngreso], 3
    ;je      personalizarSimbolos

    cmp     qword[numQueIngreso], 4
    je      finDelJuego     

    jmp     menuInicial

cargarPartida:
    limpiarPantalla
    mostrarString dibujoZorro
    mostrarString bannerBienvenido
    mostrarString mensajeCargarArchivo

    pedirNumeroAlUsuario cargarPartida

    cmp     qword[numQueIngreso], 1
    je      cargarArchivo

    cmp     qword[numQueIngreso], 2
    je      retornar     

    jmp     cargarPartida

cargarArchivo:
    sub     rsp, 8
    call    lecturaArchivo
    add     rsp, 8
    ret

retornar:
    ret



