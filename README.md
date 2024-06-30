# Zorro-y-Ocas
Tp Orga Fiuba 2024

Aclaraciones de interpretación del enunciado:

- Saltos multiples lo tomamos como que el Zorro despues de comar una oca puede volver a saltar (puede elegir si hacerlo o no) e independientemente de si tiene posibilidad de volver a comer. El zorro NO puede comer dos ocas o mas.

- La rotacion de la matriz es 90 grados en direccion antihorario. El usuario puede elegir moverse arriba, abajo, derecha o izquierda (ademas de las diagonales para el caso del zorro). El movimiento es literal segun la perspectiva del usuario (arriba es literalmente para arriba).Si giro el tablero las opciones van a ser las mismas cuatro (aunque ahora signifiquen una cosa distinta para las ocas) Por ejemplo en la perspectiva inicial si decido moverme hacia arriba me voy a acercar a la triple fila de ocas. Para hacer ese mismo movimiento con el tablero rotado 90 grados antihorario habria que elegir moverse hacia la izquierda. Esto es tenido en cuenta en las estadisticas (si rotas el tablero se actualizan segun la orientacion).

- Las ocas no pueden moverse hacia atras (lo que seria hacia arriba en la perspectiva inicial), y varia segun la perspectiva que movimiento tienen prohibido.

- hay varias subrutinas que solo tienen RET pero se llaman distinto. Es para legibilidad y claridad del codigo. Se llaman dependiendo de la intencion que tenga ese return. Sobre todo en las partes del codigo donde se salta o no a subrutinas segun lo que ingreso el usuario.

Pasos para compilar proyecto:
- nasm main.asm -f elf64
- gcc main.o -o main.out -no-pie
- ./main.out

