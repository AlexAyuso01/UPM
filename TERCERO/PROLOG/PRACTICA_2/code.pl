:- module(_,_,[assertions,regtypes]).
:- use_module(library(sets)).
:- use_module(library(lists)).
:- use_module(library(aggregates)).

/**
 * Autor: Alejandro Ayuso Exposito (190238)
 */
author_data('Ayuso', 'Exposito', 'Alejandro', '190238').

% Direcciones permitidas
direcciones_permitidas([dir(n,3), dir(s,4), dir(o,2), dir(se,10)]).

/**
 * Predicado efectuar_movimiento/3
 * efectuar_movimiento(+PosicionActual, +Direccion, -NuevaPosicion)
 * Se encarga de realizar un movimiento en la dirección dada desde la posición actual.
 * PosicionActual: Posición actual en formato pos(Row, Col).
 * Direccion: Dirección en la que se realizará el movimiento.
 * NuevaPosicion: Nueva posición luego del movimiento.
 */
efectuar_movimiento(pos(Row, Col), n, pos(NewRow, Col)) :-
  NewRow is Row - 1.
efectuar_movimiento(pos(Row, Col), s, pos(NewRow, Col)) :-
  NewRow is Row + 1.
efectuar_movimiento(pos(Row, Col), e, pos(Row, NewCol)) :-
  NewCol is Col + 1.
efectuar_movimiento(pos(Row, Col), o, pos(Row, NewCol)) :-
  NewCol is Col - 1.
efectuar_movimiento(pos(Row, Col), ne, pos(NewRow, NewCol)) :-
  NewRow is Row - 1,
  NewCol is Col + 1.
efectuar_movimiento(pos(Row, Col), se, pos(NewRow, NewCol)) :-
  NewRow is Row + 1,
  NewCol is Col + 1.
efectuar_movimiento(pos(Row, Col), so, pos(NewRow, NewCol)) :-
  NewRow is Row + 1,
  NewCol is Col - 1.
efectuar_movimiento(pos(Row, Col), no, pos(NewRow, NewCol)) :-
  NewRow is Row - 1,
  NewCol is Col - 1.

/**
 * Predicado movimiento_valido/3
 * movimiento_valido(+N, +PosicionActual, +Direccion)
 * Verifica si un movimiento en la dirección dada desde la posición actual es válido dentro de una cuadrícula de tamaño N.
 * N: Tamaño de la cuadrícula.
 * PosicionActual: Posición actual en formato pos(Row, Col).
 * Direccion: Dirección del movimiento.
 */
movimiento_valido(N, pos(Row, Col), Dir) :-
  efectuar_movimiento(pos(Row, Col), Dir, pos(NewRow, NewCol)),
  NewRow >= 1,
  NewRow =< N,
  NewCol >= 1,
  NewCol =< N.

/**
 * Predicado board1/1
 * board1(-Board)
 * Devuelve una lista de celdas que representan un tablero.
 * Board: Lista de celdas en el formato [cell(Posicion, Operacion), ...].
 */
board1([
  cell(pos(1,1),op(*,-3)),
  cell(pos(1,2),op(-,1)),
  cell(pos(1,3),op(-,4)),
  cell(pos(1,4),op(-,555)),
  cell(pos(2,1),op(-,3)),
  cell(pos(2,2),op(+,2000)),
  cell(pos(2,3),op(*,133)),
  cell(pos(2,4),op(-,444)),
  cell(pos(3,1),op(*,0)),
  cell(pos(3,2),op(*,155)),
  cell(pos(3,3),op(//,2)),
  cell(pos(3,4),op(+,20)),
  cell(pos(4,1),op(-,2)),
  cell(pos(4,2),op(-,1000)),
  cell(pos(4,3),op(-,9)),
  cell(pos(4,4),op(*,4))
]).

/**
 * Predicado cell/4
 * cell(+Posicion, +Operacion, +Tablero, -NuevoTablero)
 * Selecciona una celda del tablero y devuelve el nuevo tablero sin la celda seleccionada.
 * Posicion: Posición de la celda en formato pos(Row, Col).
 * Operacion: Operación asociada a la celda.
 * Tablero: Tablero actual en formato de lista de celdas.
 * NuevoTablero: Nuevo tablero sin la celda seleccionada.
 */
cell(pos(Row, Col), Op, Board, NewBoard) :-
  select_cell(pos(Row, Col), Op, Board, NewBoard).

/**
 * Predicado select_cell/4
 * select_cell(+Posicion, +Operacion, +Tablero, -NuevoTablero)
 * Selecciona la celda con la posición y operación dadas del tablero y devuelve el nuevo tablero sin la celda seleccionada.
 * Posicion: Posición de la celda en formato pos(Row, Col).
 * Operacion: Operación asociada a la celda.
 * Tablero: Tablero actual en formato de lista de celdas.
 * NuevoTablero: Nuevo tablero sin la celda seleccionada.
 */
select_cell(IPos, Op, [cell(IPos, Op)|Board], Board).
select_cell(IPos, Op, [cell(Pos, Op2)|Board], [cell(Pos, Op2)|NewBoard]) :-
    select_cell(IPos, Op, Board, NewBoard).

/**
 * Predicado select_dir/3
 * select_dir(+Direccion, +Direcciones, -NuevasDirecciones)
 * Selecciona la dirección de la lista de direcciones y devuelve la lista sin la dirección seleccionada.
 * Direccion: Dirección a seleccionar.
 * Direcciones: Lista de direcciones en el formato [dir(Direccion, Numero), ...].
 * NuevasDirecciones: Nueva lista de direcciones sin la dirección seleccionada.
 */
select_dir(Dir, [dir(Dir, 1)|Dirs], Dirs).
select_dir(Dir, [dir(Dir, Num)|Dirs], Dirs1) :-
    Num > 1,
    Num1 is Num - 1,
    Dirs1 = [dir(Dir, Num1)|Dirs].
select_dir(Dir, [dir(Dir2, Num)|Dirs], [dir(Dir2, Num)|Dirs1]) :-
    Dir \= Dir2,
    select_dir(Dir, Dirs, Dirs1).

/**
 * Predicado aplicar_op/3
 * aplicar_op(+Operacion, +Valor, -NuevoValor)
 * Aplica una operación a un valor y devuelve el nuevo valor resultante.
 * Operacion: Operación a aplicar ('+', '-', '*', '//').
 * Valor: Valor original.
 * NuevoValor: Nuevo valor resultante de la operación.
 */
aplicar_op(op(Op, Operand), Value, Value2) :-
    (
        Op = '+' -> Value2 is Value + Operand ;
        Op = '-' -> Value2 is Value - Operand ;
        Op = '*' -> Value2 is Value * Operand ;
        Op = '//' -> Value2 is Value // Operand
    ).

/**
 * Predicado generar_recorrido/6
 * generar_recorrido(+PosicionInicial, +N, +Tablero, +Direcciones, -Recorrido, -ValorFinal)
 * Genera un recorrido válido en el tablero comenzando desde la posición inicial y siguiendo las direcciones permitidas.
 * PosicionInicial: Posición inicial en formato pos(Row, Col).
 * N: Tamaño del tablero.
 * Tablero: Tablero actual en formato de lista de celdas.
 * Direcciones: Lista de direcciones permitidas en el formato [dir(Direccion, Numero), ...].
 * Recorrido: Recorrido generado en el formato [(Posicion, Valor), ...].
 * ValorFinal: Valor final del recorrido.
 */
generar_recorrido(_, _, [], _, [], 0).

generar_recorrido(Ipos, N, Board, Dirs, [(Ipos, Valor)|Recorrido], ValorFinal) :-
    select_cell(Ipos, Op, Board, NewBoard),
    aplicar_op(Op, 0, Valor),
    select_dir(Dir, Dirs, NewDirs),
    efectuar_movimiento(Ipos, Dir, NewIpos),
    movimiento_valido(N, NewIpos, Dir),
    generar_recorrido(NewIpos, N, NewBoard, NewDirs, Recorrido, RecorridoValor),
    aplicar_op(Op, RecorridoValor, ValorFinal).

/**
 * Predicado generar_recorridos/5
 * generar_recorridos(+N, +Tablero, +Direcciones, -Recorrido, -Valor)
 * Genera todos los recorridos posibles en el tablero y devuelve el recorrido con su valor correspondiente.
 * N: Tamaño del tablero.
 * Tablero: Tablero actual en formato de lista de celdas.
 * Direcciones: Lista de direcciones permitidas en el formato [dir(Direccion, Numero), ...].
 * Recorrido: Recorrido generado en el formato [(Posicion, Valor), ...].
 * Valor: Valor del recorrido generado.
 */
generar_recorridos(N, Board, Dirs, Recorrido, Valor) :-
    member(cell(Ipos, _), Board),
    generar_recorrido(Ipos, N, Board, Dirs, Recorrido, Valor).

/**
 * Predicado min_list/2
 * min_list(+Lista, -Minimo)
 * Encuentra el valor mínimo en una lista de números.
 * Lista: Lista de números.
 * Minimo: Valor mínimo en la lista.
 */
min_list([Min], Min).
min_list([H|T], Min) :-
    min_list(T, MinRest),
    Min is min(H, MinRest).

/**
 * Predicado tablero/5
 * tablero(+N, +Tablero, +Direcciones, -ValorMinimo, -NumeroDeRutasConValorMinimo)
 * Calcula el valor mínimo y el número de rutas con valor mínimo en los recorridos posibles en el tablero.
 * N: Tamaño del tablero.
 * Tablero: Tablero actual en formato de lista de celdas.
 * Direcciones: Lista de direcciones permitidas en el formato [dir(Direccion, Numero), ...].
 * ValorMinimo: Valor mínimo de los recorridos.
 * NumeroDeRutasConValorMinimo: Número de rutas con el valor mínimo.
 */
tablero(N, Board, Dirs, ValorMinimo, NumeroDeRutasConValorMinimo) :-
    % Generar una lista de todos los valores posibles
    findall(Valor, generar_recorridos(N, Board, Dirs, _, Valor), Valores),
    
    % Encontrar el valor mínimo
    min_list(Valores, ValorMinimo),
    
    % Generar una lista de todos los valores que son iguales al valor mínimo
    findall(ValorMinimo, member(ValorMinimo, Valores), ValoresMinimos),
    
    % Contar cuántos valores mínimos hay
    length(ValoresMinimos, NumeroDeRutasConValorMinimo).
