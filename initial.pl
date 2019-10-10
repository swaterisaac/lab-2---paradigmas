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
%scene(ID,M,N,Scene).
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



%Reglas
















