%Dominio
%ID: Número entero positivo que indica una identificación de un escenario. No pueden haber 2 ID iguales.
%M: Número entero positivo que representa la cantidad de suelo que hay en un escenario.
%N: Número entero positivo que representa la altura que posee un escenario.
%Scene: Lista

%L: Lista cualquiera
%E: Número entero que representa el elemento que queremos extraer de una lista
%R: El elemento extraído.

%Lrel: Lista resultante después de haber hecho la operación correspondiente.
%Predicados
%scene(ID,M,N,E,D,Scene).
%get(L,N,R).
%deleteL(L,R,Lrel).
%deleteL2(L,N,Lrel).

%hechos
get([],_,[]).
get([X|_],0,X):-!.
get([_|Xs],N,R):- Nsig is N-1, get(Xs,Nsig,R).

deleteL([X],X,[]):-!.
deleteL([X|Xs],X,Xs):-!.
deleteL([Y|Xs],X,[Y|Xs2]):- deleteL(Xs,X,Xs2).


deleteL2([],0,[]):-!.
deleteL2([_|Xs],0,Xs):-!.
deleteL2(L,N,R):- get(L,N,E),deleteL(L,E,R).

scene(1,10,5,2,1,[10,5,playing,[1,1],[[9,1],[10,1]],[]]).
scene(2,10,5,4,2,[10,5,playing,[1,1],[[7,1],[8,1],[9,1],[10,1]],[]]).
scene(3,10,5,5,3,[10,5,playing,[1,1],[[6,1],[7,1],[8,1],[9,1],[10,1]],[]]).
scene(4,12,10,4,1,[12,10,playing,[1,1],[[9,1],[10,1],[11,1],[12,1]],[]]).
scene(5,12,10,6,2,[12,10,playing,[1,1],[[7,1],[8,1],[9,1],[10,1],[11,1],[12,1]],[]]).
scene(6,20,20,8,3,[20,20,playing,[1,1],[[13,1],[14,1],[15,1],[16,1],[17,1],[18,1],[19,1],[20,1]],[]]).

createScene(N,M,E,D,_,Scene):-scene(_,M,N,E,D,Scene).

%Reglas
















