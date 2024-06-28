extern  printf
extern puts
section  .data
    
    seAbrioArchivo       dq  0
    mensajeCargarArchivo db 10,'¿Deseas cargar la partida en el punto que la dejaste la última vez? (Si respondes que no tu ultima partida sera eliminada automaticamente)',10,10, '1. Si', 10,10,'2. No',10,10,0
    mensajeMenuInicial   db 10, 10, '1. Jugar',10, '2. Elegir orientiacón del tablero',10,'3. Personalizar simbolos',10,'4. Salir',10,10,10,0

section  .text

menu:
    limpiarPantalla
    
    sub rsp, 8
    call menuCargarPartida ;preguntamos al usuario si quiere cargar la partida
    add rsp, 8

    sub rsp, 8
    call menuInicial; vamos al menu inciial antes de arrancar a jugar (se puede volver aca desde el juego)
    add rsp, 8

    ret
    
menuInicial:
    limpiarPantalla
    mostrarString mensajeMenu
    mostrarString mensajeMenuInicial

    mov qword[numQueIngreso], 10; cargamos un numero invalido antes de preguntar, asi nunca hay errores por si hay algo cargado erroneo

    pedirNumeroAlUsuario menuInicial
    
    ;me dirijo a la opcion correspondiente dependiendo de lo ingresado por el usuario

    cmp     qword[numQueIngreso], 1
    je      continuarAJugar 

    cmp     qword[numQueIngreso], 2
    je      cambiarOrientacion

    cmp     qword[numQueIngreso], 3
    je      personalizarSimbolos

    cmp     qword[numQueIngreso], 4
    je      salirDelJuegoDesdeElMenu     

    ;sino volvemos al loop
    jmp     menuInicial

menuCargarPartida:
    limpiarPantalla
    ;mostrarString dibujoZorro (demasiado grande, lo dejo como easter egg)
    mostrarString bannerBienvenido
    mostrarString mensajeCargarArchivo

    mov qword[numQueIngreso], 10; cargamos un numero invalido antes de preguntar asi nunca hay errores por si hay algo cargado erroneo
    pedirNumeroAlUsuario menuCargarPartida

    ;me dirijo a la opcion correspondiente dependiendo de lo ingresado por el usuario

    cmp     qword[numQueIngreso], 1
    je      cargarArchivo

    cmp     qword[numQueIngreso], 2
    je      noCargarArchivo     

    ;sino vuelvo a loop
    jmp     menuCargarPartida

cargarArchivo:
    ;leemos archivo

    sub     rsp, 8
    call    lecturaArchivo
    add     rsp, 8

    ret

salirDelJuegoDesdeElMenu:

    mov qword[fin], 0 ;actualizamos la variable que respresenta el fin del juego
    reiniciarPantalla

    ret

continuarAJugar:
    ret

noCargarArchivo:
    ret



