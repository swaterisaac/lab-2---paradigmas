%Dominios
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
%getSceneM(Scene,M).
%getSceneN(Scene,N).
%getSceneStatus(Scene,Status).
%getScenePlayer(Scene,Player).
%getSceneEnemies(Scene,Enemies).
%getSceneBullet(Scene,Bullet).
%deleteL(L,R,Lrel).
%deleteL2(L,N,Lrel).
%moveMember(SceneIn,Member,MoveDir,Seed,SceneOut)
%shoot(SceneIn, Member, ShootType, Angle, Seed, SceneOut).
%status(Status).
%sceneStatus(Scene,SceneOut).
%bullet(Bullet).
%createAllyBullet(Scene,Angle,Bullet).
%alcance(Bullet,R).
%shootINS(Scene,_,_,Angle,_,SceneOut).
%trayectoria(BulletIn,BulletOut).

%Metas principales
%createScene: Crea una escena a partir de la base de conocimiento (predicado scene).
%checkScene: Nos dice si una escena es válida o no.
%moveMember: Nos permite mover el jugador.
%shoot: Permite inicializar un disparo.
%updateScene: Permite seguir actualizando la escena si es que hay una bala.

%Metas secundarias


%Clausulas

%hechos

status(draw).
status(defeat).
status(playing).
status(win).

scene(1,10,5,2,1,[10,5,playing,1,[9,10],[]]).
scene(2,10,5,4,2,[10,5,playing,1,[7,8,9,10],[]]).
scene(3,10,5,5,3,[10,5,playing,1,[6,7,8,9,10],[]]).
scene(4,12,10,4,1,[12,10,playing,1,[9,10,11,12],[]]).
scene(5,12,10,6,2,[12,10,playing,1,[7,8,9,10,11,12],[]]).
scene(6,20,20,8,3,[20,20,playing,1,[13,14,15,16,17,18,19,20],[]]).


%Reglas
get([],_,[]).
get([X|_],0,X):-!.
get([_|Xs],N,R):- Nsig is N-1, get(Xs,Nsig,R).

deleteL([X],X,[]):-!.
deleteL([X|Xs],X,Xs):-!.
deleteL([Y|Xs],X,[Y|Xs2]):- deleteL(Xs,X,Xs2).


deleteL2([],0,[]):-!.
deleteL2([_|Xs],0,Xs):-!.
deleteL2(L,N,R):- get(L,N,E),deleteL(L,E,R).

createScene(N,M,E,D,_,Scene):-scene(_,M,N,E,D,Scene).

getSceneM(Scene,M):- get(Scene,0,M).
getSceneN(Scene,N):- get(Scene,1,N).
getSceneStatus(Scene,Status):- get(Scene,2,Status).
getScenePlayer(Scene,Player):- get(Scene,3,Player).
getSceneEnemies(Scene,Enemies):- get(Scene,4,Enemies).
getSceneBullet(Scene,Bullet):- get(Scene,5,Bullet).

sceneStatus([M,N,_,0,[],Bullet],SceneOut):- SceneOut = [M,N,draw,0,[],Bullet],!.
sceneStatus([M,N,_,0,[X|Xs],Bullet],SceneOut):- SceneOut = [M,N,defeat,0,[X|Xs],Bullet],!.
sceneStatus([M,N,_,X,[],Bullet],SceneOut):- X > 0, SceneOut = [M,N,win,X,[],Bullet],!.
sceneStatus([M,N,playing,Player,Enemies,Bullet],SceneOut):- SceneOut = [M,N,playing,Player,Enemies,Bullet],!.

nullbullet([]).
bullet([]).
bullet([X,Y,_]):- X >= 1, Y >= 1.

createAllyBullet(Scene,Angle,Bullet):- getScenePlayer(Scene,Player), Bullet = [Player,1,Angle].

alcance(BulletIn,Distance):- get(BulletIn,0,X),get(BulletIn,2,Angle),AngleRad is pi*Angle/180,
									Distance is round(X + 9*sin(2*AngleRad)).

trayectoria([X,Y,AngleX],BulletOut):- Angle is mod(AngleX,360),Angle =< 90, Angle >= 80, Ynew is Y+1, NewAngle is Angle - 10,
									BulletOut = [X,Ynew,NewAngle].
trayectoria([X,Y,AngleX],BulletOut):- Angle is mod(AngleX,360),Angle =< 80, Angle >= 30, Ynew is Y+1, Xnew is X+1, NewAngle is Angle - 10,
										BulletOut = [Xnew,Ynew,NewAngle].
trayectoria([X,Y,AngleX],BulletOut):-Angle is mod(AngleX,360), Angle =< 30, Ynew is Y-1, Xnew is X+1, NewAngle is Angle - 10,
										BulletOut = [Xnew,Ynew,NewAngle].
trayectoria([X,Y,AngleX],BulletOut):-Angle is mod(AngleX,360), Angle >= 270, Ynew is Y-1, NewAngle is Angle - 10,
										BulletOut = [X,Ynew,NewAngle].

worm(X):- X >= 1.

comprobatePlayer(_,[]).
comprobatePlayer(Player,[X|Xs]):- not(Player == X), comprobatePlayer(Player,Xs).


comprobateBullet(Num,Lista,Index):- nth0(Index,Lista,Num).



checkScene1(Scene):- getSceneM(Scene,M), getSceneN(Scene,N),getSceneStatus(Scene,Status),
					getScenePlayer(Scene,Player),getSceneBullet(Scene,Bullet),
					M >= 10, N >= 5, status(Status),bullet(Bullet),worm(Player),
					Player =< M.
					
checkScene2(Scene):- getScenePlayer(Scene,Player), getSceneEnemies(Scene,Enemies), comprobatePlayer(Player,Enemies).

checkScene(Scene):- checkScene1(Scene),checkScene2(Scene).
						
						

moveMember(SceneIn,_,MoveDir,_,SceneOut):- getSceneM(SceneIn,M),getSceneN(SceneIn,N),getSceneStatus(SceneIn,Status),
											getScenePlayer(SceneIn,Player),getSceneEnemies(SceneIn,Enemies),getSceneBullet(SceneIn,Bullet),
											Xnew is Player + MoveDir,SceneOut = [M,N,Status,Xnew,Enemies,Bullet],
											checkScene(SceneOut).
											
shootINS(SceneIn,_,_,Angle,_,SceneOut):- createAllyBullet(SceneIn,Angle,Bullet), alcance(Bullet,D), getSceneEnemies(SceneIn,Enemies),
										not(member(D,Enemies)),SceneOut = SceneIn.


shootINS(SceneIn,_,_,Angle,_,SceneOut):- getSceneM(SceneIn,M),getSceneN(SceneIn,N),getSceneStatus(SceneIn,Status),getScenePlayer(SceneIn,Player),
										getSceneEnemies(SceneIn,Enemies),getSceneBullet(SceneIn,BulletX),
										createAllyBullet(SceneIn,Angle,Bullet),alcance(Bullet,D),
										comprobateBullet(D,Enemies,Index),deleteL2(Enemies,Index,EnemiesNew),
										sceneStatus([M,N,Status,Player,EnemiesNew,BulletX],SceneOut).
										

shoot(SceneIn,_,_,Angle,_,SceneOut):- getSceneM(SceneIn,M),getSceneM(SceneIn,M),getSceneN(SceneIn,N),getSceneStatus(SceneIn,Status),getScenePlayer(SceneIn,Player),
										getSceneEnemies(SceneIn,Enemies), createAllyBullet(SceneIn,Angle,Bullet), sceneStatus([M,N,Status,Player,Enemies,Bullet],SceneOut).
										
updateScene(SceneIn,_,SceneOut):- getSceneBullet(SceneIn,Bullet), nullbullet(Bullet), SceneOut = SceneIn,!.
updateScene(SceneIn,_,SceneOut):- getSceneM(SceneIn,M),getSceneN(SceneIn,N),getSceneStatus(SceneIn,Status),
									getScenePlayer(SceneIn,Player), getSceneEnemies(SceneIn,Enemies), getSceneBullet(SceneIn,Bullet),
									get(Bullet,0,X), comprobateBullet(X,Enemies,Index), 
									deleteL2(Enemies,Index,NewEnemies), sceneStatus([M,N,Status,Player,NewEnemies,[]],SceneOut).
updateScene(SceneIn,_,SceneOut):- getSceneM(SceneIn,M),getSceneN(SceneIn,N),getSceneStatus(SceneIn,Status),
									getScenePlayer(SceneIn,Player), getSceneEnemies(SceneIn,Enemies), getSceneBullet(SceneIn,Bullet),
									bullet(Bullet),get(Bullet,0,X), X =< M, trayectoria(Bullet,BulletOut), 
									get(BulletOut,0,X2), bullet(BulletOut), X2 =< M,
									SceneOut = [M,N,Status,Player,Enemies,BulletOut].
updateScene(SceneIn,_,SceneOut):- getSceneM(SceneIn,M),getSceneN(SceneIn,N),getSceneStatus(SceneIn,Status),
									getScenePlayer(SceneIn,Player), getSceneEnemies(SceneIn,Enemies),SceneOut = [M,N,Status,Player,Enemies,[]],!.
									

					
/*fileString1(Scene,Ini,StringOut):- Ini is 1, fileString2(Scene,Ini,"").
fileString2([M|_],M,"").
fileString2(Scene,Ini,StringOut):- get(Scene,3,Player),Ini is Player, string_concat(StringOut,"P",NewString),
									NewIni is Ini + 1, fileString2(Scene,NewIni,NewString).
fileString2(Scene,Ini,StringOut):- get(Scene,4,Enemies),member(Ini,Enemies),string_concat(StringOut,"E",NewString),
									NewIni is Ini + 1, fileString2(Scene,NewIni,NewString).

%fileString2(Scene,Ini,StringOut):- get(Scene,5,Bullet), get(Bullet,0,X), Ini is X, string_concat(StringOut,"=",NewString),
%									NewIni is Ini + 1, fileString2(Scene,NewIni,NewString).
fileString2(Scene,Ini,StringOut):- NewIni is Ini+1, string_concat(StringOut," ",NewString), fileString2(Scene,NewIni,NewString).

fileString(Scene,StringOut):- fileString1(Scene,1,StringOut).											

*/

%string_concat(String1,String2,Result).
%number_string(Number,StringResult).















