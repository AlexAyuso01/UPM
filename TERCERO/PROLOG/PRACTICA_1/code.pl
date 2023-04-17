:- module(_,_,[]).

author_data('Ayuso', 'Exposito', 'Alejandro', '190238').

color(o).
color(x).

rule(o,o,o,_,o). % regla nula
rule(x,o,o,r(A,_,_,_,_,_,_),A) :- color(A).
rule(o,x,o,r(_,B,_,_,_,_,_),B) :- color(B).
rule(o,o,x,r(_,_,C,_,_,_,_),C) :- color(C).
rule(x,o,x,r(_,_,_,D,_,_,_),D) :- color(D).
rule(x,x,o,r(_,_,_,_,E,_,_),E) :- color(E).
rule(o,x,x,r(_,_,_,_,_,F,_),F) :- color(F).
rule(x,x,x,r(_,_,_,_,_,_,G),G) :- color(G).
% Células en un estado inicial dado
% Caso base: un solo elemento en la lista
cells([o], _, [o,o,o]).
% Caso dos elementos en la lista
cells([C1,C2], R, [o,NewC1,NewC2,o]) :-
    rule(C1, C2, o, R, NewC1),
    rule(C2, o, o, R, NewC2).
% Caso recursivo: expandir el estado inicial y aplicar reglas
% Células en un estado inicial dado
% Agregar dos células blancas al principio y al final del estado
% Aplicar reglas a cada conjunto de 3 células consecutivas
cells(State, R, Result) :-
    my_append([o,o], State, PaddedState),
    my_append(PaddedState, [o,o], PaddedResult),
    apply_rules(PaddedResult, R, Result), !.

% Aplica la regla correspondiente a cada conjunto de 3 células consecutivas
apply_rules([C1,C2,C3 | Rest], R, [NewC1 | NewRest]) :-
    rule(C1, C2, C3, R, NewC1),
    apply_rules([C2,C3 | Rest], R, NewRest).
apply_rules(_, _, []). % Caso base: no hay más células

% Agregar elementos al inicio y al final de la lista
my_append([], L, L).
my_append([H|T], L, [H|Result]) :- my_append(T, L, Result).


