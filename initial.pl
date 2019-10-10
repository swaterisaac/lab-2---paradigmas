%Dominio
%ID: Número entero positivo que indica una identificación de un escenario. No pueden haber 2 ID iguales.
%M: Número entero positivo que representa la cantidad de suelo que hay en un escenario.
%N: Número entero positivo que representa la altura que posee un escenario.
%Scene: Lista

%L: Lista cualquiera
%E: Número entero que representa el elemento que queremos extraer de una lista
%R: El elemento extraído.
%Predicados
%scene(ID,M,N,Scene).
%get(L,N,R).


%hechos

get([X|_],0,X):-!.




%Reglas
get([_|Xs],N,R):- Nsig is N-1, get(Xs,Nsig,R).













