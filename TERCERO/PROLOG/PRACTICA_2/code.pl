:- module(_,_,[assertions,regtypes]).
:- use_module(library(sets)).
:- use_module(library(lists)).
:- use_module(library(aggregates)).

% Autor: Alejandro Ayuso Exposito (190238)

% Direcciones permitidas
direcciones_permitidas([dir(n,3), dir(s,4), dir(o,2), dir(se,10)]).

/**
 * Predicado efectuar_movimiento/3
 *
 * @pred efectuar_movimiento(+PosicionActual, +Direccion, -NuevaPosicion)
 * @mode efectuar_movimiento(+, +, -)
 * @type efectuar_movimiento(+pos, +atom, -pos)
 * @error movimiento_invalido(Direccion) si la direccion no es valida para la posicion actual
 * @error posicion_invalida(Posicion) si la posicion actual esta fuera de rango
 *
 * Se encarga de realizar un movimiento en la direccion dada desde la posicion actual.
 *
 * @param PosicionActual Posicion actual en formato pos(Row, Col).
 * @param Direccion     Direccion en la que se realizara el movimiento.
 * @param NuevaPosicion Nueva posicion luego del movimiento.
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
 *
 * @pred movimiento_valido(+N, +PosicionActual, +Direccion)
 * @mode movimiento_valido(+, +, +)
 * @type movimiento_valido(+int, +pos, +atom)
 *
 * Verifica si un movimiento en la direccion dada desde la posicion actual es valido dentro de una cuadricula de tamano N.
 *
 * @param N              Tamano de la cuadricula.
 * @param PosicionActual Posicion actual en formato pos(Row, Col).
 * @param Direccion      Direccion del movimiento.
 */
movimiento_valido(N, pos(Row, Col), Dir) :-
  efectuar_movimiento(pos(Row, Col), Dir, pos(NewRow, NewCol)),
  NewRow >= 1,
  NewRow =< N,
  NewCol >= 1,
  NewCol =< N.

/**
 * Predicado board1/1
 *
 * @pred board1(-Board)
 * @mode board1(-)
 * @type board1(-list(cell))
 *
 * Devuelve una lista de celdas que representan un tablero.
 *
 * @param Board Lista de celdas en el formato [cell(Posicion, Operacion), ...].
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
 *
 * @pred cell(+Posicion, +Operacion, +Tablero, -NuevoTablero)
 * @mode cell(+, +, +, -)
 * @type cell(+pos, +atom, +list(cell), -list(cell))
 * @error celda_no_existente(Posicion, Tablero) si la celda no existe en el tablero
 *
 * Selecciona una celda del tablero y devuelve el nuevo tablero sin la celda seleccionada.
 *
 * @param Posicion    Posicion de la celda en formato pos(Row, Col).
 * @param Operacion   Operacion asociada a la celda.
 * @param Tablero     Tablero actual en formato de lista de celdas.
 * @param NuevoTablero Nuevo tablero sin la celda seleccionada.
 */
cell(pos(Row, Col), Op, Board, NewBoard) :-
  select_cell(pos(Row, Col), Op, Board, NewBoard).

/**
 * Predicado select_cell/4
 *
 * @pred select_cell(+Posicion, +Operacion, +Tablero, -NuevoTablero)
 * @mode select_cell(+, +, +, -)
 * @type select_cell(+pos, +atom, +list(cell), -list(cell))
 * @error celda_no_existente(Posicion, Tablero) si la celda no existe en el tablero
 *
 * Selecciona la celda con la posicion y operacion dadas del tablero y devuelve el nuevo tablero sin la celda seleccionada.
 *
 * @param Posicion       Posicion de la celda en formato pos(Row, Col).
 * @param Operacion      Operacion asociada a la celda.
 * @param Tablero        Tablero actual en formato de lista de celdas.
 * @param NuevoTablero   Nuevo tablero sin la celda seleccionada.
 */
select_cell(IPos, Op, [cell(IPos, Op)|Board], Board).
select_cell(IPos, Op, [cell(Pos, Op2)|Board], [cell(Pos, Op2)|NewBoard]) :-
    select_cell(IPos, Op, Board, NewBoard).

/**
 * Predicado select_dir/3
 *
 * @pred select_dir(+Direccion, +Direcciones, -NuevasDirecciones)
 * @mode select_dir(+, +, -)
 * @type select_dir(+atom, +list(dir), -list(dir))
 * @error direccion_no_existente(Direccion, Direcciones) si la direccion no existe en la lista de direcciones
 *
 * Selecciona la direccion de la lista de direcciones y devuelve la lista sin la direccion seleccionada.
 *
 * @param Direccion            Direccion a seleccionar.
 * @param Direcciones          Lista de direcciones en el formato [dir(Direccion, Numero), ...].
 * @param NuevasDirecciones    Nueva lista de direcciones sin la direccion seleccionada.
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
 *
 * @pred aplicar_op(+Operacion, +Valor, -NuevoValor)
 * @mode aplicar_op(+, +, -)
 * @type aplicar_op(+atom, +int, -int)
 *
 * Aplica una operacion a un valor y devuelve el nuevo valor resultante.
 *
 * @param Operacion    Operacion a aplicar ('+', '-', '*', '//').
 * @param Valor        Valor original.
 * @param NuevoValor   Nuevo valor resultante de la operacion.
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
 *
 * @pred generar_recorrido(+PosicionInicial, +N, +Tablero, +Direcciones, -Recorrido, -ValorFinal)
 * @mode generar_recorrido(+, +, +, +, -, -)
 * @type generar_recorrido(+pos, +int, +list(cell), +list(dir), -list(pair(pos, int)), -int)
 * @error movimiento_invalido(Direccion) si la direccion no es valida para la posicion actual
 * @error posicion_invalida(Posicion) si la posicion actual esta fuera de rango
 * @error celda_no_existente(Posicion, Tablero) si la celda no existe en el tablero
 *
 * Genera un recorrido valido en el tablero comenzando desde la posicion inicial y siguiendo las direcciones permitidas.
 *
 * @param PosicionInicial   Posicion inicial en formato pos(Row, Col).
 * @param N                Tamano del tablero.
 * @param Tablero          Tablero actual en formato de lista de celdas.
 * @param Direcciones      Lista de direcciones permitidas en el formato [dir(Direccion, Numero), ...].
 * @param Recorrido        Recorrido generado en el formato [(Posicion, Valor), ...].
 * @param ValorFinal       Valor final del recorrido.
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
 *
 * @pred generar_recorridos(+N, +Tablero, +Direcciones, -Recorrido, -Valor)
 * @mode generar_recorridos(+, +, +, -, -)
 * @type generar_recorridos(+int, +list(cell), +list(dir), -list(pair(pos, int)), -int)
 *
 * Genera todos los recorridos posibles en el tablero y devuelve el recorrido con su valor correspondiente.
 *
 * @param N              Tamano del tablero.
 * @param Tablero        Tablero actual en formato de lista de celdas.
 * @param Direcciones    Lista de direcciones permitidas en el formato [dir(Direccion, Numero), ...].
 * @param Recorrido      Recorrido generado en el formato [(Posicion, Valor), ...].
 * @param Valor          Valor del recorrido generado.
 */
generar_recorridos(N, Board, Dirs, Recorrido, Valor) :-
    member(cell(Ipos, _), Board),
    generar_recorrido(Ipos, N, Board, Dirs, Recorrido, Valor).

/**
 * Predicado min_list/2
 *
 * @pred min_list(+Lista, -Minimo)
 * @mode min_list(+, -)
 * @type min_list(+list(int), -int)
 *
 * Encuentra el valor minimo en una lista de numeros.
 *
 * @param Lista  Lista de numeros.
 * @param Minimo Valor minimo en la lista.
 */
min_list([Min], Min).
min_list([H|T], Min) :-
    min_list(T, MinRest),
    Min is min(H, MinRest).

/**
 * Predicado tablero/5
 *
 * @pred tablero(+N, +Tablero, +Direcciones, -ValorMinimo, -NumeroDeRutasConValorMinimo)
 * @mode tablero(+, +, +, -, -)
 * @type tablero(+int, +list(cell), +list(dir), -int, -int)
 *
 * Calcula el valor minimo y el numero de rutas con valor minimo en los recorridos posibles en el tablero.
 *
 * @param N                          Tamano del tablero.
 * @param Tablero                    Tablero actual en formato de lista de celdas.
 * @param Direcciones                Lista de direcciones permitidas en el formato [dir(Direccion, Numero), ...].
 * @param ValorMinimo                Valor minimo de los recorridos.
 * @param NumeroDeRutasConValorMinimo Numero de rutas con el valor minimo.
 */
tablero(N, Board, Dirs, ValorMinimo, NumeroDeRutasConValorMinimo) :-
    % Generar una lista de todos los valores posibles
    findall(Valor, generar_recorridos(N, Board, Dirs, _, Valor), Valores),

    % Encontrar el valor minimo
    min_list(Valores, ValorMinimo),

    % Generar una lista de todos los valores que son iguales al valor minimo
    findall(ValorMinimo, member(ValorMinimo, Valores), ValoresMinimos),

    % Contar cuantos valores minimos hay
    length(ValoresMinimos, NumeroDeRutasConValorMinimo).
