:- op(1110, xfy, =>).
:- op(600, xfy, and).
:- op(600, xfy, or).
:- op(500, fy, neg).
:- op(700, xfy, impl).
:- op(500, fy, next).
:- op(500, fy, always).


:- dynamic(rule_used/1).
:- dynamic(pos_uni/1).
:- dynamic(uni_right/1).
:- dynamic(uni_left/1).
:- dynamic(lowest/1).
:- dynamic(does_subsume/1).


% Define state
% state(Theorem, Rule, Child, Formula, Level).
state(_, _, _, _, _).


% ---------------------------
% Rule definitions
% ---------------------------

% Define the and-left rule
% pltl_and_left(Gamma, New_gamma)
pltl_and_left([A and B | Tail], [A, B | Tail]):- !.
pltl_and_left([X | Tail], [X  | Result]):-
    pltl_and_left(Tail, Result).

% Define the and-right rule
% pltl_and_right(Delta, New_delta_1, New_delta_2)
pltl_and_right([A and B | Tail], [A| Tail], [B | Tail]):- !.
pltl_and_right([X | Tail], [X | New_delta_1], [X | New_delta_2]):-
    pltl_and_right(Tail, New_delta_1, New_delta_2).

% Define the or-left rule
% pltl_or_left(Gamma, New_gamma_1, New_gamma_2)
pltl_or_left([A or B | Tail], [A| Tail], [B | Tail]):- !.
pltl_or_left([X | Tail], [X | New_gamma_1], [X | New_gamma_2]):-
    pltl_or_left(Tail, New_gamma_1, New_gamma_2).

% Define the or-right rule
% pltl_or_right(Delta, New_delta)
pltl_or_right([A or B | Tail], [A, B | Tail]):- !.
pltl_or_right([X | Tail], [X  | Result]):-
    pltl_or_right(Tail, Result).

% Define the negation-left rule
% pltl_neg_left(Gamma, Delta, New_gamma, New_delta)
pltl_neg_left([neg A | Tail], Delta, Tail, [A | Delta]):- !.
pltl_neg_left([A | Tail], Delta, [A | New_gamma], New_delta):-
    pltl_neg_left(Tail, Delta, New_gamma, New_delta).

% Define the negation-right rule
% pltl_neg_right(Gamma, Delta, New_gamma, New_delta)
pltl_neg_right(Gamma, [neg A | Tail], [A | Gamma], Tail):- !.
pltl_neg_right(Gamma, [X | Tail], New_gamma, [X | New_delta]):-
    pltl_neg_right(Gamma, Tail, New_gamma, New_delta).

% Define the impl-left rule
% pltl_impl_left(Gamma, Delta, New_gamma_1, New_delta_1, New_gamma_2)
pltl_impl_left([A impl B | Tail], Delta, Tail, [A | Delta], [B | Tail]):- !.
pltl_impl_left([X | Tail], Delta, [X | New_gamma_1], New_delta_1, [X | New_gamma_2]):-
    pltl_impl_left(Tail, Delta, New_gamma_1, New_delta_1, New_gamma_2).

% Define the implication-right rule
% pltl_impl_right(Gamma, Delta, New_gamma, New_delta)
pltl_impl_right(Gamma, [A impl B | Delta], [A | Gamma], [B | Delta]):- !.
pltl_impl_right(Gamma, [X | Tail], New_gamma, [X | New_delta]):-
    pltl_impl_right(Gamma, Tail, New_gamma, New_delta).

% Define the next rule
% pltl_next(Input, Output).
% pltl_next(Gamma, New_gamma).
% pltl_next(Delta, New_delta).
pltl_next([], []):- !.
pltl_next([next A | Tail], [A | New_Tail]) :-
    pltl_next(Tail, New_Tail), !.
pltl_next([_ | Tail], New_tail) :-
    pltl_next(Tail, New_tail).

% Define the always-left rule
% pltl_always_left(Gamma, New_gamma)
pltl_always_left([always A | Tail], [A, next always A | Tail]):- !.
pltl_always_left([X | Tail], [X | New_gamma]):-
    pltl_always_left(Tail, New_gamma).

% Define the always-right rule
% pltl_always_left(Delta, New_delta_1, New_delta_2)
pltl_always_right([always A | Tail], [A | Tail], [next always A |Tail], A):- !.
pltl_always_right([X | Tail], [X | New_delta_1], [X | New_delta_2], Formula):-
    pltl_always_right(Tail, New_delta_1, New_delta_2, Formula).


% ---------------------------
% Program start
% ---------------------------

prove(Theorem):-
    prove(Theorem, _).
prove(Gamma => Delta, R):-
    retractall(pos_uni(_)),
    retractall(uni_right(_)),
    retractall(uni_left(_)),
    retractall(lowest(_)),
    retractall(rule_used(_)),
    prove(Gamma => Delta, R, [state((Gamma => Delta), root, mid, null, 0)], 0).


% ---------------------------
% Rule handling
% ---------------------------

% Axiom
% prove([a] => [a], R).
prove([] => [], _, _):- !, fail. % fail if both Delta and Gamma is empty.
prove(Gamma => Delta, [], _, _):-
   retractall(rule_used(_)),
   proved(Gamma, Delta), !.

% and-left
% prove([p and q] => [p], R).
prove(Gamma => Delta, [state((New_gamma => Delta), and_left, mid, null, New_level), Result], States, Level):-
   pltl_and_left(Gamma, New_gamma),
   assert(rule_used(yes)),
   New_level is Level+1,
   prove(New_gamma => Delta, Result, [state((New_gamma => Delta), and_left, mid, null, New_level) | States], New_level).

% and-right
% prove([p, q] => [p and q], R).
prove(Gamma => Delta, [state((Gamma => New_delta_1), and_right, left, null, New_level), Result_left, state((Gamma => New_delta_2), and_right, right, null, New_level), Result_right], States, Level):-
   pltl_and_right(Delta, New_delta_1, New_delta_2),
   assert(rule_used(yes)),
   New_level is Level+1,
   prove(Gamma => New_delta_1, Result_left, [state((Gamma => New_delta_1), and_right, left, null, New_level) | States], New_level),
   prove(Gamma => New_delta_2, Result_right, [state((Gamma => New_delta_2), and_right, right, null, New_level) | States], New_level).

% or-left
% prove([p] => [p or q], R).
prove(Gamma => Delta, [state((New_gamma_1 => Delta), or_left, left, null, New_level), Result_left, state((New_gamma_2 => Delta), or_left, right, null, New_level), Result_right], States, Level):-
   pltl_or_left(Gamma, New_gamma_1, New_gamma_2),
   assert(rule_used(yes)),
   New_level is Level+1,
   prove(New_gamma_1 => Delta, Result_left, [state((New_gamma_1 => Delta), or_left, left, null, New_level) | States], New_level),
   prove(New_gamma_2 => Delta, Result_right, [state((New_gamma_2 => Delta), or_left, right, null, New_level) | States], New_level).

% or-right
% prove([p] => [p or q], R).
prove(Gamma => Delta, [state((Gamma => New_delta), or_right, mid, null, New_level), Result], States, Level):-
   pltl_or_right(Delta, New_delta),
   assert(rule_used(yes)),
   New_level is Level+1,
   prove(Gamma => New_delta, Result, [state((Gamma => New_delta), or_right, mid, null, New_level) | States], Level).

% negation-left
% prove([c, g, neg p, a, p, d] => [s], R).
prove(Gamma => Delta, [state((New_gamma => New_delta), neg_left, mid, null, New_level), Result], States, Level):-
   pltl_neg_left(Gamma, Delta, New_gamma, New_delta),
   assert(rule_used(yes)),
   New_level is Level+1,
   prove(New_gamma => New_delta, Result, [state((New_gamma => New_delta), neg_left, mid, null, New_level) | States], Level).

% negation-right
% prove([s] => [c, g, neg p, a, p, d], R).
prove(Gamma => Delta, [state((New_gamma => New_delta), neg_right, mid, null, New_level), Result], States, Level):-
   pltl_neg_right(Gamma, Delta, New_gamma, New_delta),
   assert(rule_used(yes)),
   New_level is Level+1,
   prove(New_gamma => New_delta, Result, [state((New_gamma => New_delta), neg_right, mid, null, New_level) | States], Level).

% implication-left
% prove([d, c impl g, c] => [a, b, g], R).
prove(Gamma => Delta, [state((New_gamma_1 => New_delta_1), impl_left, left, null, New_level), Result_left, state((New_gamma_2 => Delta), impl_left, right, null, New_level), Result_right], States, Level):-
   pltl_impl_left(Gamma, Delta, New_gamma_1, New_delta_1, New_gamma_2),
   assert(rule_used(yes)),
   New_level is Level+1,
   prove(New_gamma_1 => New_delta_1, Result_left, [state((New_gamma_1 => New_delta_1), impl_left, left, null, New_level) | States], New_level),
   prove(New_gamma_2 => Delta, Result_right, [state((New_gamma_2 => Delta), impl_left, right, null, New_level) | States], New_level).

% implication-right
% prove([a, b] => [d, c impl g, c], R).
prove(Gamma => Delta, [state((New_gamma => New_delta), impl_right, mid, null, null, New_level), Result], States, Level):-
   pltl_impl_right(Gamma, Delta, New_gamma, New_delta),
   assert(rule_used(yes)),
   New_level is Level+1,
   prove(New_gamma => New_delta, Result, [state((New_gamma => New_delta), impl_right, mid, null, New_level) | States], Level).

% always-right
% prove([g, next always g] => [b, always g, z], R).
prove(Gamma => Delta, [state((Gamma => New_delta_1), always_right, left, Formula, New_level), Result_left, state((Gamma => New_delta_2), always_right, right, Formula, New_level), Result_right], States, Level):-
   pltl_always_right(Delta, New_delta_1, New_delta_2, Formula),
   assert(rule_used(yes)),
   New_level is Level+1,
   prove(Gamma => New_delta_1, Result_left, [state((Gamma => New_delta_1), always_right, left, Formula, New_level) | States], New_level),
   retract_uni(New_level),
   prove(Gamma => New_delta_2, Result_right, [state((Gamma => New_delta_2), always_right, right, Formula, New_level) | States], New_level),
   retract_uni(New_level).

% always-left
% prove([d, always g, c] => [b, g], R).
prove(Gamma => Delta, [state((New_gamma => Delta), always_left, mid, null, New_level), Result], States, Level):-
   pltl_always_left(Gamma, New_gamma),
   assert(rule_used(yes)),
   New_level is Level+1,
   prove(New_gamma => Delta, Result, [state((New_gamma => Delta), always_left, mid, null, New_level) | States], New_level).

% next
% prove([next always p, q] => [next p], R).
prove(Gamma => Delta, [state((New_gamma => New_delta), next, mid, null, New_level), Result], States, Level):-
    not(rule_used(_)),
    pltl_next(Gamma, New_gamma),
    pltl_next(Delta, New_delta), !,
    New_level is Level+1,
    handle_derivation(state((New_gamma => New_delta), next, mid, null, New_level), States, Result).


% ---------------------------
% Derivation loop finding and handling
% ---------------------------

retract_uni(Level):-
    (lowest(X), X > Level -> retractall(uni_right(_)), retractall(uni_left(_)); true).

handle_derivation(state(([]=>[]), _, _, _, _), _, _):- !, fail.
handle_derivation(state((Gamma => Delta), Rule, Child, Formula, Level), States, []):-
    retractall(pos_uni(_)),
    check_derivation_loop(state((Gamma => Delta), Rule, Child, Formula, Level), States).
handle_derivation(state((Gamma => Delta), Rule, Child, Formula, Level), States, Result):- !,
    (does_subsume(_), not(uni_right(_)) -> retractall(does_subsume(_)), fail; retractall(does_subsume(_))),
    prove(Gamma => Delta, Result, [state((Gamma => Delta), Rule, Child, Formula, Level) | States], Level).

check_derivation_loop(_, []):- false.
check_derivation_loop(state((Gamma => Delta), _, _, _, _), [state((Prev_gamma => Prev_delta), Prev_rule, Prev_child, Prev_formula, Prev_level) | _]):-
    fill_universlity_formulas(Prev_rule, Prev_child, Prev_formula),
    subsumes(Prev_gamma, Gamma),
    subsumes(Prev_delta, Delta), !,
    assert(does_subsume(a)),
    has_uni(Prev_delta),
    add_lowest(Prev_level).
check_derivation_loop(State, [_ | Tail]):-
    check_derivation_loop(State, Tail).

add_lowest(Level):-
   (lowest(X), X < Level -> true; retractall(lowest(_)), assert(lowest(Level))).

fill_universlity_formulas(always_right, right, Formula):-
    assert(uni_right(Formula)), !.
fill_universlity_formulas(always_right, left, Formula):-
    assert(uni_left(Formula)), !.
fill_universlity_formulas(_, _, _):- !.

% Check if S' subsumes S; S' <= S.
subsumes([], _):- !.
subsumes([X | Tail], S) :-
    member(X, S),
    subsumes(Tail, S).

has_uni([always X | _]):-
    uni_right(X),
    not(uni_left(X)).
has_uni([_ | Tail]):-
    has_uni(Tail).


% ---------------------------
% Checking if theorem is proved
% ---------------------------

proved(_, []):- !, fail.
proved([X| _], Delta):- member(X, Delta).
proved([_| Tail], Delta):-
    proved(Tail, Delta).

member(X, [X| _]).
member((X and Y), [(Y and X)| _]).
member((X or Y), [(Y or X)| _]).
member(X, [_| Xs]) :- member(X, Xs).


% ---------------------------
% Manipulating with files
% ---------------------------

% Read file
read_file(File, Theorems):-
    open(File, read, S),
    findall(B, read_one_term(S, B), Theorems),
    close(S).

read_one_term(S, B):-
    repeat,
    read(S, B),
    ( B = end_of_file, !, fail ; true ).

% Prove theorems list
prove_list([], []).
prove_list([Input | Tail], [Result_1 | Result]):-
    (prove(Input, Result_1) -> true ; Result_1 = "false" ),
    prove_list(Tail, Result).

% Write to file
write_to_file(File, Results):-
    open(File, write, Out),
    write_by_line(Out, Results),
    close(Out).

write_by_line(_, []) :- !.
write_by_line(Out, [Head | Tail]):-
    write(Out, Head),
    write(Out, '\r\n'),
    write_by_line(Out, Tail).