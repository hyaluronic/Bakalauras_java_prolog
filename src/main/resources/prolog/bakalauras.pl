% :- op(1130, xfy, <=>).
:- op(1110, xfy, =>).
%:- op(500, fy, '~').
:- op(600, xfy, and).
:- op(600, xfy, or).
:- op(500, fy, neg).
:- op(700, xfy, impl).
:- op(500, fy, next).
:- op(500, fy, always).

% Define state
% state(Theorem, Rule, Child).
state(_, _, _).

% ---------------------------
% Rule definitions
% ---------------------------

% Define the and-left rule
% pltl_and_left(Gamma, New_gamma)
% prove([p and q] => [p])
pltl_and_left([A and B | Tail], [A, B | Tail]):- !.
pltl_and_left([X | Tail], [X  | Result]):-
    pltl_and_left(Tail, Result).

% Define the and-right rule
% pltl_and_right(Delta, New_delta_1, New_delta_2)
% prove([p] => [p and q], R).
pltl_and_right([A and B | Tail], [A| Tail], [B | Tail]):- !.
pltl_and_right([X | Tail], [X | New_delta_1], [X | New_delta_2]):-
    pltl_and_right(Tail, New_delta_1, New_delta_2).

% Define the or-left rule
% pltl_or_left(Gamma, New_gamma_1, New_gamma_2)
% prove([p] => [p or q] )
pltl_or_left([A or B | Tail], [A| Tail], [B | Tail]):- !.
pltl_or_left([X | Tail], [X | New_gamma_1], [X | New_gamma_2]):-
    pltl_or_left(Tail, New_gamma_1, New_gamma_2).

% Define the or-right rule
% pltl_or_right(Delta, New_delta)
% prove([p] => [p or q] )
pltl_or_right([A or B | Tail], [A, B | Tail]):- !.
pltl_or_right([X | Tail], [X  | Result]):-
    pltl_or_right(Tail, Result).

% Define the negation-left rule
% pltl_neg_left(Gamma, Delta, New_gamma, New_delta)
% prove([c, g, neg p, a, p, d] => [s], R).
pltl_neg_left([neg A | Tail], Delta, Tail, [A | Delta]):- !.
pltl_neg_left([A | Tail], Delta, [A | New_gamma], New_delta):-
    pltl_neg_left(Tail, Delta, New_gamma, New_delta).

% Define the negation-right rule
% pltl_neg_rigth(Gamma, Delta, New_gamma, New_delta)
% prove([s] => [c, g, neg p, a, p, d], R).
pltl_neg_rigth(Gamma, [neg A | Tail], [A | Gamma], Tail):- !.
pltl_neg_rigth(Gamma, [X | Tail], New_gamma, [X | New_delta]):-
    pltl_neg_rigth(Gamma, Tail, New_gamma, New_delta).

% Define the impl-left rule
% pltl_impl_left(Gamma, Delta, New_gamma_1, New_delta_1, New_gamma_2)
% prove([d, c impl g, c] => [a, b, g], R).
pltl_impl_left([A impl B | Tail], Delta, Tail, [A | Delta], [B | Tail]):- !.
pltl_impl_left([X | Tail], Delta, [X | New_gamma_1], New_delta_1, [X | New_gamma_2]):-
    pltl_impl_left(Tail, Delta, New_gamma_1, New_delta_1, New_gamma_2).

% Define the implication-right rule
% pltl_impl_right(Gamma, Delta, New_gamma, New_delta)
% prove([a, b] => [d, c impl g, c], R).
pltl_impl_right(Gamma, [A impl B | Delta], [A | Gamma], [B | Delta]):- !.
pltl_impl_right(Gamma, [X | Tail], New_gamma, [X | New_delta]):-
    pltl_impl_right(Gamma, Tail, New_gamma, New_delta).

% Define the always-left rule
% pltl_always_left(Gamma, New_gamma)
% prove([d, always g, c] => [b, g], R).
pltl_always_left([always A | Tail], [A, next always A | Tail]):- !.
pltl_always_left([X | Tail], [X | New_gamma]):-
    pltl_always_left(Tail, New_gamma).

% Define the always-right rule
% pltl_always_left(Delta, New_delta_1, New_delta_2)
% prove([d, c, g] => [b, always g, z], R).
pltl_always_right([always A | Tail], [A | Tail], [next always A |Tail]):- !.
pltl_always_right([X | Tail], [X | New_delta_1], [X | New_delta_2]):-
    pltl_always_right(Tail, New_delta_1, New_delta_2).

% Define the next rule
% pltl_next(Input, Output).
% pltl_next(Gamma, New_gamma).
% pltl_next(Delta, New_delta).
% prove([p, q] => [next p], R).
pltl_next([], []):- !.
pltl_next([next A | Tail], [A | New_Tail]) :-
    pltl_next(Tail, New_Tail), !.
pltl_next([_ | Tail], New_tail) :-
    pltl_next(Tail, New_tail).


% program start
prove(Theorem):- prove(Theorem, _).
prove(Gamma => Delta, R):- prove(Gamma => Delta, R, [state((Gamma => Delta), root, mid)]).

% fail if both Delta and Gamma is empty.
prove([] => [], _, _):- !, fail.
% default, no proposition rules
% prove([(a and b)] => [a,b,c,d,e,r,(a and b)], R).
prove(Gamma => Delta, [], _):-
   proved(Gamma, Delta), !. % ! for one solution only as only one solution is needed for proof.

% ---------------------------
% Rule handling
% ---------------------------

% and-left
% prove([(a and b)] => [a,b,c,d,e,r], R).
prove(Gamma => Delta, [state((New_gamma => Delta), and_left, mid) , Result], States):-
   pltl_and_left(Gamma, New_gamma),
   prove(New_gamma => Delta, Result, [state((New_gamma => Delta), and_left, mid) | States]).

% and-right
% prove([a, b] => [a and b,c,d,e,r], R).
prove(Gamma => Delta, [state((Gamma => New_delta_1), and_right, left), Result_left, state((Gamma => New_delta_2), and_right, right), Result_right], States):-
   pltl_and_right(Delta, New_delta_1, New_delta_2),
   prove(Gamma => New_delta_1, Result_left, [state((Gamma => New_delta_1), and_right, left) | States]),
   prove(Gamma => New_delta_2, Result_right, [state((Gamma => New_delta_2), and_right, right) | States]).

% or-left
% prove([a or b] => [a,b,c,d,e,r], R).
prove(Gamma => Delta, [state((New_gamma_1 => Delta), or_left, left), Result_left, state((New_gamma_2 => Delta), or_left, right), Result_right], States):-
   pltl_or_left(Gamma, New_gamma_1, New_gamma_2),
   prove(New_gamma_1 => Delta, Result_left, [state((New_gamma_1 => Delta), or_left, left) | States]),
   prove(New_gamma_2 => Delta, Result_right, [state((New_gamma_2 => Delta), or_left, right) | States]).

% or-right
% prove([(a and b)] => [a or b,c,d,e,r], R).
prove(Gamma => Delta, [state((Gamma => New_delta), or_right, mid), Result], States):-
   pltl_or_right(Delta, New_delta),
   prove(Gamma => New_delta, Result, [state((Gamma => New_delta), or_right, mid) | States]).

% negation-left
prove(Gamma => Delta, [state((New_gamma => New_delta), neg_left, mid), Result], States):-
   pltl_neg_left(Gamma, Delta, New_gamma, New_delta),
   prove(New_gamma => New_delta, Result, [state((New_gamma => New_delta), neg_left, mid) | States]).

% negation-right
prove(Gamma => Delta, [state((New_gamma => New_delta), neg_rigth, mid), Result], States):-
   pltl_neg_rigth(Gamma, Delta, New_gamma, New_delta),
   prove(New_gamma => New_delta, Result, [state((New_gamma => New_delta), neg_rigth, mid) | States]).

% implication-left
prove(Gamma => Delta, [state((New_gamma_1 => New_delta_1), impl_left, left), Result_left, state((New_gamma_2 => Delta), impl_left, right), Result_right], States):-
   pltl_impl_left(Gamma, Delta, New_gamma_1, New_delta_1, New_gamma_2),
   prove(New_gamma_1 => New_delta_1, Result_left, [state((New_gamma_1 => New_delta_1), impl_left, left) | States]),
   prove(New_gamma_2 => Delta, Result_right, [state((New_gamma_2 => Delta), impl_left, right) | States]).

% implication-right
prove(Gamma => Delta, [state((New_gamma => New_delta), impl_right, mid), Result], States):-
   pltl_impl_right(Gamma, Delta, New_gamma, New_delta),
   prove(New_gamma => New_delta, Result, [state((New_gamma => New_delta), impl_right, mid) | States]).

% always-left
prove(Gamma => Delta, [state((New_gamma => Delta), always_left, mid), Result], States):-
   pltl_always_left(Gamma, New_gamma),
   prove(New_gamma => Delta, Result, [state((New_gamma => Delta), always_left, mid) | States]).

% always-right
prove(Gamma => Delta, [state((Gamma => New_delta_1), always_right, left), Result_left, state((Gamma => New_delta_2), always_right, right), Result_right], States):-
   pltl_always_right(Delta, New_delta_1, New_delta_2),
   prove(Gamma => New_delta_1, Result_left, [state((Gamma => New_delta_1), always_right, left) | States]),
   prove(Gamma => New_delta_2, Result_right, [state((Gamma => New_delta_2), always_right, right) | States]).

% next
prove(Gamma => Delta, [state((New_gamma => New_delta), next, mid), Result], States):-
    pltl_next(Gamma, New_gamma),
    pltl_next(Delta, New_delta), !,
    handle_derivation(state((New_gamma => New_delta), next, mid), States, Result).
% TODO: cia prideti ciklo atpazinima? lyg visada ciklus uztenka atpazinti tik po next taisykles?


% ---------------------------
% Derivation loop finding and handling
% ---------------------------

handle_derivation(State, States, []):-
    check_derivation_loop(State, States).
handle_derivation(state((New_gamma => New_delta), next, mid), States, Result):-
    prove(New_gamma => New_delta, Result, [state((New_gamma => New_delta), next, mid) | States]).

check_derivation_loop(_, []):- !, fail.
check_derivation_loop(state((Gamma => Delta), _, _), [state((Prev_gamma => Prev_delta), _, _) | _]):-
    subsumes(Prev_gamma, Gamma),
    subsumes(Prev_delta, Delta).
check_derivation_loop(State, [_ | Tail]):-
    check_derivation_loop(State, Tail).

% TODO: check for strong and weak loops? How to determin if false or true theorem?
% dabar tikrinu tik weak loopsus
% Check if S' subsumes S; S' <= S.
subsumes([], _):- !.
subsumes([X | Tail], S) :-
    member(X, S),
    subsumes(Tail, S).


% ---------------------------
% Check if theorem is proved
% ---------------------------

% proved([(a and b)], [a,b,c,d,e,r,(a and b)]).
% proved([(b and a)], [a,b,c,d,e,r,(a and b)]).
proved(_, []):- !, fail.
proved([X| _], Delta):- member(X, Delta).
proved([_| Tail], Delta):-
    proved(Tail, Delta).

% member((a and b), [a,b,c,d,e,r,(a and b)]).
% member((b and a), [a,b,c,d,e,r,(a and b)]).
member(X, [X| _]).
member((X and Y), [(Y and X)| _]).
member((X or Y), [(Y or X)| _]).
member(X, [_| Xs]) :- member(X, Xs).


% ---------------------------
% Manipulating with files
% ---------------------------

% Read file
read_file(Theorems):- read_file('C:/Users/user/Desktop/UNI/8 semestras/Bakalauras/input.txt', Theorems).
read_file(File, Theorems):-
    open(File, read, S),
    findall(B, read_one_term(S, B), Theorems),
    close(S).

read_one_term(S, B):-
    repeat,
    read(S, B),
    ( B = end_of_file, !, fail ; true ).

% File prove helper
prove_List([], []).
prove_List([Input | Tail], [Result_1 | Result]):-
    (prove(Input, Result_1) -> true ; Result_1 = "false" ),
    prove_List(Tail, Result).

% Write to file
write_to_file(Results):- write_to_file('C:/Users/user/Desktop/UNI/8 semestras/Bakalauras/output.txt', Results).
write_to_file(File, Results):-
    open(File, write, Out),
    write_by_line(Out, Results),
    close(Out).

write_by_line(_, []) :- !.
write_by_line(Out, [Head | Tail]):-
    write(Out, Head),
    write(Out, '\r\n'),
    write_by_line(Out, Tail).


% experimental :- better performence?, first loop all gamma, then loop all delta.

% TODO:
% Go through lists (Gamma, Delta),
% Test each element for all rules,
% If element is tested, don't test for rules match in next iteration,
% Test if only new variables match aksiom.
pltl_for_gamma([A and B | Tail], Delta, [A, B | Tail], Delta):- !.
pltl_for_gamma([neg A | Tail], Delta, Tail, [A | Delta]):- !.
pltl_for_gamma([A | Tail], Delta, [A | New_gamma], New_delta):-
    pltl_for_gamma(Tail, Delta, New_gamma, New_delta).

pltl_for_delta(Gamma, [A or B | Tail], Gamma, [A, B | Tail]):- !.
pltl_for_delta(Gamma, [neg A | Tail], [A | Gamma], Tail):- !.
pltl_for_delta(Gamma, [A impl B | Delta], [A | Gamma], [B | Delta]):- !.
pltl_for_delta(Gamma, [X | Tail], New_gamma, [X | New_delta]):-
    pltl_for_delta(Gamma, Tail, New_gamma, New_delta).

prove_all(Gamma => Delta):-
    pltl_for_gamma(Gamma, Delta, New_gamma, New_delta),
   (proved(New_gamma, New_delta) -> true, ! ; prove_all(New_gamma => New_delta)).

prove_all(Gamma => Delta):-
    pltl_for_delta(Gamma, Delta, New_gamma, New_delta),
   (proved(New_gamma, New_delta) -> true, ! ; prove_all(New_gamma => New_delta)).