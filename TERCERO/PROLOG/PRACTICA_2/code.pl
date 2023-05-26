:- module(_,_,[assertions,regtypes]).



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
efectuar_movimiento(pos(Row, Col), no, pos(NewRow, NewCol)) :-
  NewRow is Row - 1,
  NewCol is Col - 1.
efectuar_movimiento(pos(Row, Col), ne, pos(NewRow, NewCol)) :-
  NewRow is Row - 1,
  NewCol is Col + 1.
efectuar_movimiento(pos(Row, Col), so, pos(NewRow, NewCol)) :-
  NewRow is Row + 1,
  NewCol is Col - 1.
efectuar_movimiento(pos(Row, Col), se, pos(NewRow, NewCol)) :-
  NewRow is Row + 1,
  NewCol is Col + 1.

movimiento_valido(N, pos(Row, Col), Dir) :-
  efectuar_movimiento(pos(Row, Col), Dir, pos(NewRow, NewCol)),
  NewRow >= 1,
  NewRow =< N,
  NewCol >= 1,
  NewCol =< N.

% Predicado cell/4
cell(pos(Row, Col), Op, Board, NewBoard) :-
  % Implementación vacía
  true.


select_cell(pos(Row, Col), Op, Board, NewBoard) :-
  % Implementación vacía
  true.


select_dir(Dir, Dirs, NewDirs) :-
  % Implementación vacía
  true.

% Predicado aplicar_op/3
aplicar_op(Op, Valor, Valor2) :-
  % Implementación vacía
  true.

% Predicado generar_recorrido/6
generar_recorrido(Pos, Valor, Dirs, Board, NewBoard, Resultado) :-
  % Implementación vacía
  true.

% Predicado generar_recorridos/5
generar_recorridos(Pos, Valor, Dirs, Board, Resultados) :-
  % Implementación vacía
  true.

% Predicado tablero/5
tablero(N, DireccionesPermitidas, Board, Resultado, Recorridos) :-
  % Implementación vacía
  true.

