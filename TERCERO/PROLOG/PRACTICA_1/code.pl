:- module(_,_,[]).
author_data('Ayuso', 'Exposito', 'Alejandro', '190238').

%color
color(o).
color(x).

%rule/3
rule(o,o,o,_,o). % regla nula
rule(x,o,o,r(A,_,_,_,_,_,_),A) :- color(A).
rule(o,x,o,r(_,B,_,_,_,_,_),B) :- color(B).
rule(o,o,x,r(_,_,C,_,_,_,_),C) :- color(C).
rule(x,o,x,r(_,_,_,D,_,_,_),D) :- color(D).
rule(x,x,o,r(_,_,_,_,E,_,_),E) :- color(E).
rule(o,x,x,r(_,_,_,_,_,F,_),F) :- color(F).
rule(x,x,x,r(_,_,_,_,_,_,G),G) :- color(G).

% my_reverse/3
my_reverse(Xs, Ys) :- my_reverse(Xs, [], Ys).

my_reverse([], Acc, Acc).
my_reverse([X|Xs], Acc, Ys) :- my_reverse(Xs, [X|Acc], Ys).

% my_length/3
my_length(Xs, N) :- my_length(Xs, 0, N).

my_length([], N, N).
my_length([_|Xs], Acc, N) :- my_length(Xs, s(Acc), N).

% my_append/3
my_append([], Ys, Ys).
my_append([X|Xs], Ys, [X|Zs]) :- my_append(Xs, Ys, Zs).

% apply_rules/3
apply_rules([], _, []).
apply_rules([A,B,C|StateIn], Rules, [X|StateOut]) :-
    apply_rule(A,B,C,Rules,X),
    apply_rules([B,C|StateIn], Rules, StateOut).

% apply_rule/5
apply_rule(A, B, C, Rules, X) :-
    rule(A,B,C,Rules,X),
    color(X).

% first_last_cells/3
first_last_cells(State, First, Last) :- State = [First|_], my_reverse(State, [Last|_]).

% check_valid_state/1
check_valid_state(State) :-
    my_length(State, Len),
    my_length(s(s(o)), MinLen),
    len_ge(Len, MinLen),
    first_last_cells(State, First, Last),
    First = o, Last = o.

% len_ge/2 (helper function to check if Len >= MinLen using Peano arithmetic)
len_ge(X, Y) :- len_ge(X, Y, o).

len_ge(X, X, _).
len_ge(s(X), Y, s(Z)) :- len_ge(X, Y, Z).

% cells/3
cells(StateIn, Rules, StateOut) :-
    check_valid_state(StateIn),
    apply_rules(StateIn, Rules, StateOut0),
    my_append(StateOut0, [o,o], StateOut),
    check_valid_state(StateOut),
    StateOut = [_|StateOut1],
    StateOut1 = [o|_],
    !.


