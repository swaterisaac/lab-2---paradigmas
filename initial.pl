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
%moveMember(SceneIn,Member,MoveDir,Seed,SceneOut)

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

status(draw).
status(defeat).
status(playing).
status(win).

sceneStatus([M,N,_,0,[],Bullet],SceneOut):- SceneOut = [M,N,draw,0,[],Bullet].
sceneStatus([M,N,_,0,[X|Xs],Bullet],SceneOut):- SceneOut = [M,N,defeat,0,[X|Xs],Bullet].
sceneStatus([M,N,_,X,[],Bullet],SceneOut):- X > 0, SceneOut = [M,N,win,X,[],Bullet].
sceneStatus([M,N,playing,Player,Enemies,Bullet],SceneOut):- SceneOut = [M,N,playing,Player,Enemies,Bullet].


bullet([]).
bullet([X,Y,_]):- X >= 1, Y >= 1.

alcance(BulletIn,Distance):- get(BulletIn,0,X),get(BulletIn,2,Angle),AngleRad is pi*Angle/180,
									Distance is round(X + 9*sin(2*AngleRad)).

worm(X):- X >= 1.

comprobatePlayer(_,[]).
comprobatePlayer(Player,[X|Xs]):- not(Player == X), comprobatePlayer(Player,Xs).

scene(1,10,5,2,1,[10,5,playing,1,[9,10],[]]).
scene(2,10,5,4,2,[10,5,playing,1,[7,8,9,10],[]]).
scene(3,10,5,5,3,[10,5,playing,1,[6,7,8,9,10],[]]).
scene(4,12,10,4,1,[12,10,playing,1,[9,10,11,12],[]]).
scene(5,12,10,6,2,[12,10,playing,1,[7,8,9,10,11,12],[]]).
scene(6,20,20,8,3,[20,20,playing,1,[13,14,15,16,17,18,19,20],[]]).

createScene(N,M,E,D,_,Scene):-scene(_,M,N,E,D,Scene).


checkScene1(Scene):- get(Scene,0,M),get(Scene,1,N),get(Scene,2,Status),
					get(Scene,3,Player),get(Scene,5,Bullet),
					M >= 10, N >= 5, status(Status),bullet(Bullet),worm(Player),
					Player =< M.
					
checkScene2(Scene):- get(Scene,3,Player), get(Scene,4,Enemies), comprobatePlayer(Player,Enemies).

checkScene(Scene):- checkScene1(Scene),checkScene2(Scene).
						
						


moveMember(SceneIn,_,MoveDir,_,SceneOut):- get(SceneIn,0,M),get(SceneIn,1,N),get(SceneIn,2,Status),
											get(SceneIn,3,Player),get(SceneIn,4,Enemies),get(SceneIn,5,Bullet),
											Xnew is Player + MoveDir,SceneOut = [M,N,Status,Xnew,Enemies,Bullet],
											checkScene(SceneOut).
											
%Reglas
















