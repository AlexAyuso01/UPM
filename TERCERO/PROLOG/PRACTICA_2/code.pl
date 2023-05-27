:- module(_,_,[assertions,regtypes]).
:- use_module(library(sets)).
:- use_module(library(lists)).
:- use_module(library(aggregates)).



%! author_data
%  Retorna informacion sobre el autor. 
author_data('Ayuso', 'Exposito', 'Alejandro', '190238').
%Direcciones permitidas
direcciones_permitidas([dir(n,3), dir(s,4), dir(o,2), dir(se,10)]).

%Predicado efectuar_movimiento
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


movimiento_valido(N, pos(Row, Col), Dir) :-
  efectuar_movimiento(pos(Row, Col), Dir, pos(NewRow, NewCol)),
  NewRow >= 1,
  NewRow =< N,
  NewCol >= 1,
  NewCol =< N.

% Predicado board1/1
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

% Predicado cell/4
cell(pos(Row, Col), Op, Board, NewBoard) :-
  select_cell(pos(Row, Col), Op, Board, NewBoard).

select_cell(IPos, Op, [cell(IPos, Op)|Board], Board).
select_cell(IPos, Op, [cell(Pos, Op2)|Board], [cell(Pos, Op2)|NewBoard]) :-
    select_cell(IPos, Op, Board, NewBoard).


select_dir(Dir, [dir(Dir, Num)|Dirs], Dirs1) :-
    Num > 1,
    Num1 is Num - 1,
    Dirs1 = [dir(Dir, Num1)|Dirs].
select_dir(Dir, [dir(Dir, 1)|Dirs], Dirs).
select_dir(Dir, [dir(Dir2, Num)|Dirs], [dir(Dir2, Num)|Dirs1]) :-
    Dir \= Dir2,
    select_dir(Dir, Dirs, Dirs1).

select_dir_aux(Dir, [dir(Dir, _)|Dirs], Dirs).
select_dir_aux(Dir, [dir(Dir2, Num)|Dirs], [dir(Dir2, Num)|NewDirs]) :-
    Dir \= Dir2,
    select_dir_aux(Dir, Dirs, NewDirs).



% Predicado aplicar_op/3
aplicar_op(op(Op, Operand), Value, Value2) :-
    (
        Op = '+' -> Value2 is Value + Operand ;
        Op = '-' -> Value2 is Value - Operand ;
        Op = '*' -> Value2 is Value * Operand ;
        Op = '//' -> Value2 is Value // Operand
    ).
% Predicado generar_recorrido/6
% Caso base: no hay más direcciones disponibles.
generar_recorrido(Ipos, _, Board, [], [(Ipos, Valor)], Valor) :-
    cell(Ipos, Op, Board, _),
    aplicar_op(Op, 0, Valor).

generar_recorrido(Ipos, N, Board, Dirs, [(Ipos, Valor)|Recorrido], ValorFinal) :-
    cell(Ipos, Op, Board, NewBoard),
    aplicar_op(Op, 0, Valor),
    select_dir(Dir, Dirs, NewDirs),
    efectuar_movimiento(Ipos, Dir, NewIpos),
    movimiento_valido(N, NewIpos, Dir),
    generar_recorrido(NewIpos, N, NewBoard, NewDirs, Recorrido, RecorridoValor),
    ValorFinal is Valor + RecorridoValor.


% Predicado generar_recorridos/5
generar_recorridos(N, Board, Dirs, Recorrido, Valor) :-
    member(cell(Ipos, _), Board),
    generar_recorrido(Ipos, N, Board, Dirs, Recorrido, Valor).

min_list([Min], Min).
min_list([H|T], Min) :-
    min_list(T, MinRest),
    Min is min(H, MinRest).


% Predicado tablero/5
tablero(N, Board, Dirs, ValorMinimo, NumeroDeRutasConValorMinimo) :-
    % Generar una lista de todos los valores posibles
    findall(Valor, generar_recorridos(N, Board, Dirs, _, Valor), Valores),
    
    % Encontrar el valor mínimo
    min_list(Valores, ValorMinimo),
    
    % Generar una lista de todos los valores que son iguales al valor mínimo
    findall(ValorMinimo, member(ValorMinimo, Valores), ValoresMinimos),
    
    % Contar cuántos valores mínimos hay
    length(ValoresMinimos, NumeroDeRutasConValorMinimo).


