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

% Agregar elementos al inicio y al final de la lista
my_append([], L, L).
my_append([H|T], L, [H|Result]) :- my_append(T, L, Result).

%dar la vuelta a una lista
my_reverse([], []).
my_reverse([H|T], Reversed) :-
    my_reverse(T, ReversedT),
    my_append(ReversedT, [H], Reversed).

% Calcular la longitud de una lista
% my_length(+List, -Length)
% Length: longitud de List
my_length([], 0).
my_length([_|T], L) :- my_length(T, L1), L is L1 + 1.



% Verifica si un elemento pertenece a una lista
% my_member(+X, +List)
my_member(X, [X|_]).
my_member(X, [_|T]) :- my_member(X, T).



    %Cell/3
% Células en un estado inicial dado
cells(State, R, Result) :-
    % Verificar que la primera y la última célula son 'o'
    State = [First | _],
    State = [_ | _Rest],
    my_reverse(State, [Last | _]),
    my_reverse(State, [_ | _]),
    (First = o, Last = o ->
        % Agregar dos células blancas al principio y al final del estado
        my_append([o,o], State, PaddedState),
        my_append(PaddedState, [o,o], PaddedResult),
        % Aplicar reglas a cada conjunto de 3 células consecutivas
        apply_rules(PaddedResult, R, Result), !
    ;   % Si la primera o la última célula no son 'o', fallar
        fail
    ).

% Aplica la regla correspondiente a cada conjunto de 3 células consecutivas
apply_rules([C1,C2,C3 | Rest], R, [NewC1 | NewRest]) :-
    rule(C1, C2, C3, R, NewC1),
    apply_rules([C2,C3 | Rest], R, NewRest).
apply_rules(_, _, []). % Caso base: no hay más células

    %evol/3
% Definimos el estado inicial de la célula
initial_state([o,x,o]).

evol(0, _, [o,x,o]).
evol(s(N), RuleSet, Cells) :-
    evol(N, RuleSet, PrevCells),
    cells(PrevCells, RuleSet, Cells).
