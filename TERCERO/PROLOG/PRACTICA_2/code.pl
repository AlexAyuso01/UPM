:- module(_,_,[assertions,regtypes]).
:- use_module(library(sets)).
:- use_module(library(lists)).
:- use_module(library(aggregates)).
:- use_module(library(between)).


:- doc(title, "Segunda Practica(Progarmacion en ISO-Prolog)").

:- doc(subtitle, "Recorridos de valor minimo en tableros de opreaciones matematicas").

:- doc(author, "Ayuso Exposito, Alejandro, b190238").

:- doc(module, "
This module provides a set of predicates for the manipulation and interaction with a game board. The board is composed of cells that contain operations, and movements across the board are regulated by a set of directions.

@section{Author Data}
The @code{author_data/4} predicate holds information about the author of this module.

@section{Allowed Directions}
The @code{direcciones_permitidas/1} predicate defines a list of allowed directions for movement on the board.

@section{Movement Execution}
The @code{efectuar_movimiento/3} predicate calculates the result of moving in a certain direction from a certain position.

@section{Movement Validity Check}
The @code{movimiento_valido/3} predicate checks if a move in a certain direction from a certain position on a board of a certain size is valid.

@section{Board and Cells}
The @code{board1/1} predicate defines the board, and the @code{cell/4} predicate updates a board by applying an operation at a certain position.

@section{Direction Selection}
The @code{select_dir/3} and @code{select_dir_aux/3} predicates are used for selecting a direction from a list of allowed directions.

@section{Operation Application}
The @code{aplicar_op/3} predicate applies an operation to a value, resulting in a new value.

@section{Route Generation}
The @code{generar_recorrido/6} predicate generates a route on the board starting from a certain position, using certain directions, and calculates its final value. The @code{generar_recorridos/5} predicate generates all possible routes on the board and calculates their values.

@section{Board Analysis}
Finally, the @code{tablero/5} predicate finds the minimum route value and the number of routes with that value on a board of a certain size with certain directions.

@section{Tests}
Tests done manually in the ciao playground command line with the expected value

@subsection{Test for efectuar_movimiento:} 
@tt{
  ?- efectuar_movimiento(pos(1,1), n, X).}\n
      X = pos(0,1).

@subsection{Test for movimiento_valido:} 
@tt{
  ?- movimiento_valido(4, pos(1,1), n).}\n
      false.

@subsection{Test for aplicar_op:} 
@tt{
  ?- aplicar_op(op(+, 5), 10, X).}\n
      X = 15.

@subsection{Test for cell:} 
@tt{
  ?- cell(pos(1,1), op(+, 5), [cell(pos(1,1),op(-,3))], X).}\n
      X = [cell(pos(1,1),op(+,5))].

@subsection{Test for select_dir:} 
@tt{
  ?- select_dir(n, [dir(n,3), dir(s,4), dir(o,2), dir(se,10)], X).}\n
      X = [dir(n,2), dir(s,4), dir(o,2), dir(se,10)].

@subsection{Test for generar_recorrido:} 
@tt{
  ?- generar_recorrido(pos(1,1), 4, [cell(pos(1,1),op(-,3)), cell(pos(1,2),op(-,1)), cell(pos(2,1),op(-,3))], [dir(n,1), dir(s,1)], X, Y).}\n
      X = [(pos(1,1), -3), (pos(0,1), -6)],\n
      Y = -6.

@subsection{Test for generar_recorridos:} 
@tt{
  ?- generar_recorridos(4, [cell(pos(1,1),op(-,3)), cell(pos(1,2),op(-,1)), cell(pos(2,1),op(-,3))], [dir(n,1), dir(s,1)], X, Y).}\n
      X = [(pos(1,1), -3), (pos(0,1), -6)],\n
      Y = -6.

@subsection{Test for tablero:} 
@tt{
  ?- tablero(4, [cell(pos(1,1),op(-,3)), cell(pos(1,2),op(-,1)), cell(pos(2,1),op(-,3))], [dir(n,1), dir(s,1)], X, Y).}\n
      X = -6,\n
      Y = 1.
").


:- prop dir/1 #"@includedef{dir/1}".
dir(dir(Dir,Num)) :- atm(Dir), int(Num).

:- prop pos/1 #"@includedef{pos/1}".
pos(pos(Row,Col)) :- int(Row), int(Col).

:- prop op/1 #"@includedef{op/1}".
op(op(Op,Num)) :- atm(Op), int(Num).


:- prop board/1 #"@includedef{board/1}".
board(Board) :- list(cell(_), Board).



:- pred author_data(A, B, C, D) :: string * string * string * string
   # "@var{A}, @var{B}, @var{C}, and @var{D} hold information about the author.".
author_data('Ayuso', 'Exposito', 'Alejandro', '190238').


:- pred direcciones_permitidas(Dirs) :: list(Dirs)
# "@var{Dirs} is a list of allowed directions.".
direcciones_permitidas([dir(n,3), dir(s,4), dir(o,2), dir(se,10)]).



:- pred efectuar_movimiento(Pos, Dir, NewPos) :: pos * dir * pos
# "@var{NewPos} is the result of moving in direction @var{Dir} from position @var{Pos}.".

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

:- pred movimiento_valido(N, Pos, Dir) :: int * pos * dir
# "Checks if a move in direction @var{Dir} from position @var{Pos} on a @var{N} by @var{N} board is valid.".

movimiento_valido(N, pos(Row, Col), Dir) :-
  efectuar_movimiento(pos(Row, Col), Dir, pos(NewRow, NewCol)),
  NewRow >= 1,
  NewRow =< N,
  NewCol >= 1,
  NewCol =< N.

:- pred board1(Board) :: board
   #"@var{Board} is a predefined game board. ".
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


:- pred cell/2 :: pos * op
# "Predicate cell/2 which represents a cell with a @var{Pos} and a @var{Op} in the board.".
cell(Pos, Op) :- pos(Pos), op(Op).

:- pred select_cell(IPos, Op, Board, NewBoard) :: pos * op * board * board
# "Updates @var{Board} to @var{NewBoard} by applying operation @var{Op} at position @var{IPos}.".

select_cell(IPos, Op, [cell(IPos, Op)|Board], Board).
select_cell(IPos, Op, [cell(Pos, Op2)|Board], [cell(Pos, Op2)|NewBoard]) :-
    select_cell(IPos, Op, Board, NewBoard).

:- pred select_dir(Dir, Dirs, Dirs1) :: dir * list(dir) * list(dir) 
# "Selects @var{Dir} from @var{Dirs} and updates it to @var{Dirs1}.".

select_dir(Dir, [dir(Dir, Num)|Dirs], Dirs1) :-
    Num > 1,
    Num1 is Num - 1,
    Dirs1 = [dir(Dir, Num1)|Dirs].
select_dir(Dir, [dir(Dir, 1)|Dirs], Dirs).
select_dir(Dir, [dir(Dir2, Num)|Dirs], [dir(Dir2, Num)|Dirs1]) :-
    Dir \= Dir2,
    select_dir(Dir, Dirs, Dirs1).
:- pred select_dir_aux(Dir, Dirs, NewDirs) :: dir * list(dir) * list(dir)
# "Helper function for select_dir/3. Selects @var{Dir} from @var{Dirs} and updates it to @var{NewDirs}.".
select_dir_aux(Dir, [dir(Dir, _)|Dirs], Dirs).
select_dir_aux(Dir, [dir(Dir2, Num)|Dirs], [dir(Dir2, Num)|NewDirs]) :-
    Dir \= Dir2,
    select_dir_aux(Dir, Dirs, NewDirs).


% Predicado aplicar_op/3
:- pred aplicar_op(Op, Value, Value2) :: op * int * int 
# "@var{Value2} is the result of applying operation @var{Op} to @var{Value}.".
aplicar_op(op(+, Operando), Valor, Valor2) :-
    Valor2 is Valor + Operando.
aplicar_op(op(-, Operando), Valor, Valor2) :-
    Valor2 is Valor - Operando.
aplicar_op(op(*, Operando), Valor, Valor2) :-
    Valor2 is Valor * Operando.
aplicar_op(op(//, Operando), Valor, Valor2) :-
    (Operando =\= 0 -> Valor2 is Valor // Operando ; Valor2 = Valor).

% Predicado generar_recorrido/6
:- pred generar_recorrido(Ipos, N, Board, Dirs, Recorrido, ValorFinal) :: pos * int * board * list(dir) * list(list) * int
# "Generates a route @var{Recorrido} on @var{Board} starting from @var{Ipos}, using @var{Dirs} directions, and calculates its final value @var{ValorFinal}.".
% Caso base: no hay más direcciones disponibles.
generar_recorrido(Ipos, _, Board, [], [(Ipos, Valor)], Valor) :-
    select_cell(Ipos, Op, Board, _),
    aplicar_op(Op, 0, Valor).
generar_recorrido(Ipos, N, Board, [Dir|Dirs], Recorrido, ValorFinal) :-
    select_cell(Ipos, Op, Board, NewBoard),
    efectuar_movimiento(Ipos, Dir, NewIpos),
    movimiento_valido(N, NewIpos, Dir),
    generar_recorrido(NewIpos, N, NewBoard, Dirs, RecorridoResto, ValorResto),
    aplicar_op(Op, ValorResto, ValorRestoNuevo),  % Aplicar la operación y obtener ValorRestoNuevo
    ValorFinal is ValorResto + ValorRestoNuevo,  % Calcular el valor final correctamente
    Recorrido = [(NewIpos, ValorFinal) | RecorridoResto].





% Predicado generar_recorridos/5
:- pred generar_recorridos(N, Board, Dirs, Recorrido, Valor) :: int * board * list(dir) * list(list) * int 
# "Generates all possible routes @var{Recorrido} on @var{Board} of size @var{N} using @var{Dirs} directions, and calculates their values @var{Valor}.".

generar_recorridos(N, Board, Dirs, Recorrido, Valor) :-
    member(cell(Ipos, _), Board),
    generar_recorrido(Ipos, N, Board, Dirs, Recorrido, Valor).

min_list([Min], Min).
min_list([H|T], Min) :-
    min_list(T, MinRest),
    Min is min(H, MinRest).


% Predicado tablero/5
:- pred tablero(N, Board, Dirs, ValorMinimo, NumeroDeRutasConValorMinimo) :: int * board * list(dir) * int * int
# "On a @var{N} by @var{N} @var{Board} with @var{Dirs} directions, finds the minimum route value @var{ValorMinimo} and the number of routes @var{NumeroDeRutasConValorMinimo} with that value.".
tablero(N, Board, Dirs, ValorMinimo, NumeroDeRutasConValorMinimo) :-
    % Generar una lista de todos los valores posibles
    findall(Valor, generar_recorridos(N, Board, Dirs, _, Valor), Valores),
    
    % Encontrar el valor mínimo
    min_list(Valores, ValorMinimo),
    
    % Generar una lista de todos los valores que son iguales al valor mínimo
    findall(ValorMinimo, member(ValorMinimo, Valores), ValoresMinimos),
    
    % Contar cuántos valores mínimos hay
    length(ValoresMinimos, NumeroDeRutasConValorMinimo).


%Tests to run from lpdoc
%Efectuar Movimiento
:- test efectuar_movimiento(Pos, Dir, NewPos) : (Pos = pos(-2, 2), Dir = no) => (NewPos = pos(-3, 1)) + not_fails.

:- test movimiento_valido(N, Pos, Dir) : (N = 4, Pos = pos(1, 1)) => (Dir = s ; Dir = e ; Dir = se) + not_fails.

:- test select_cell(IPos, Op, Board, NewBoard) : (
    IPos = pos(1, 2),
    Op = op(-, 1),
    Board = [
        cell(pos(1, 1), op(*, -3)),
        cell(pos(1, 2), op(-, 1)),
        cell(pos(1, 3), op(-, 4))
    ]
) => (
    NewBoard = [
        cell(pos(1, 1), op(*, -3)),
        cell(pos(1, 3), op(-, 4))
    ]) + not_fails.

:- test select_dir(Dir, Dirs, Dirs1) : (
    Dir = n,
    Dirs = [dir(n, 5), dir(s, 6), dir(e, 7), dir(o, 4)]
    
) =>(Dirs1 = [dir(n, 4), dir(s, 6), dir(e, 7), dir(o, 4)]) + not_fails.

:- test aplicar_op(Op, Value, Value2) : (
    Op = op(+, 5),
    Value = 10  
) => (Value2 = 15) + not_fails.

:- test generar_recorrido(Ipos, N, Board, Dirs, Recorrido, ValorFinal) : (
    Ipos = pos(2, 2),
    N = 4,
    Board = [
        cell(pos(1, 1), op(*, -3)),
        cell(pos(1, 2), op(-, 1)),
        cell(pos(1, 3), op(-, 4)),
        cell(pos(2, 1), op(-, 3)),
        cell(pos(2, 2), op(+, 2000)),
        cell(pos(2, 3), op(*, 133)),
        cell(pos(3, 1), op(*, 0)),
        cell(pos(3, 2), op(*, 155)),
        cell(pos(3, 3), op(//, 2)),
        cell(pos(4, 1), op(-, 2)),
        cell(pos(4, 2), op(-, 1000))
    ],
    Dirs = []

) =>   (Recorrido = [(pos(2,2),2000)], ValorFinal = 2000) + not_fails.

:- test generar_recorridos(N, Board, Dirs, Recorrido, Valor) : (N = 2,Board = [
        cell(pos(1,1),op(*,-3)),
        cell(pos(1,2),op(-,1)),
        cell(pos(2,1),op(-,3)),
        cell(pos(2,2),op(+,2000))
    ],
    Dirs = [dir(n,2),dir(s,2),dir(e,2),dir(o,6)]) => (Recorrido = [(pos(1,1),0),(pos(1,2),-1),(pos(2,2),1999),(pos(2,1),1996)], Valor = 1996) + not_fails.

:- test tablero(N, Board, Dirs, ValorMinimo, NumeroDeRutasConValorMinimo) : (
    N = 2,
    Board = [
        cell(pos(1, 1), op(+, 1)),
        cell(pos(1, 2), op(-, 1)),
        cell(pos(2, 1), op(-, 2)),
        cell(pos(2, 2), op(*, 2))
    ],
    Dirs = [dir(n, 5), dir(s, 6), dir(e, 7), dir(o, 4)]) => (
    ValorMinimo = -1,
    NumeroDeRutasConValorMinimo = 1
)  + not_fails.
