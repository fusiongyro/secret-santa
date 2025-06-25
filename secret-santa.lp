% each partner in a couple is a person, surprisingly
person(X) :- couple(X, _).
person(X) :- couple(_, X).

% everybody is somebody's secret santa
{ match(P1, P2) : person(P2) } = 1 :- person(P1).

% everybody is some santa's secret
{ match(P1, P2) : person(P1) } = 1 :- person(P2).

% nobody gets themselves
:- match(X, X).

% no two people get each other (cliques of N=2)
:- match(P1, P2), match(P2, P1).

% nobody gets their spouse
:- match(P1, P2), couple(P1, P2).
:- match(P1, P2), couple(P2, P1).

% parents and children don't get matched
:- match(P1, P2), parent(P1, P2).
:- match(P1, P2), parent(P2, P1).
:- match(P1, P2), couple(P1, P3), parent(P2, P3).
:- match(P2, P1), couple(P1, P3), parent(P2, P3).


#show match/2.
