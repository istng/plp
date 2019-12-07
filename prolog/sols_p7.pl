
%Ej 1

padre(juan, carlos).
padre(juan, luis).
padre(carlos, daniel).
padre(carlos, diego).
padre(luis,pablo).
padre(luis,manuel).
padre(luis,ramiro).
abuelo(X,Y):- padre(X,Z), padre(Z,Y).

%I) El resultado será "juan", ya que el padre de manuel es luis, y
%tanto manuel como luis no tienen ningún otro padre.

%II)
hijo(X,Y):- padre(Y,X).
hermano(X,Y):- padre(Z,X), padre(Z,Y).
descendiente(X,Y):- padre(Y,X).
descendiente(X,Y):- padre(Y,Z), descendiente(X,Z).
%La idea básicamente es: dame todos los hijos de Y, y después dame todos los
%hijos de Y devuelta, dandome ahora toda la descendencia de cada hijo.

%IV)
%abuelo(juan,Y).

%V)
%hermano(pablo,Y).

%VI)
%ancestro(X, X).
%ancestro(X, Y) :- ancestro(Z, Y), padre(X, Z).

%VII) Se cuelga y termian excediendo el stack.

%VIII) Tamién dando vuelta las reglas. Como está originalmente nunca
%instancia Z, se la vive entrando en ancestro...
ancestro(X,Y):- descendiente(Y,X).


%3)

natural(0).
natural(suc(X)) :- natural(X).
%menorOIgual(X, suc(Y)) :- menorOIgual(X, Y).
menorOIgual(X,X) :- natural(X).

%I) Se cuelga y excede el stack.

%II) Se cuelga cuando no puede unificar las variables instanciadas con nada en
%la circunstancia de entrar recursivamente a una función

%III) Cambiando el orden...
menorOIgual(X, suc(Y)) :- menorOIgual(X, Y).


%4)
concatenar([],YS,YS).
concatenar([X|XS],YS,[X|L]):- concatenar(XS, YS, L).

%5)
%I)
last([X|[]], X).
last([X|XS], U):- last(XS,U).

%II)
reverse([],[]).
reverse([X|XS],L):- reverse(XS, R), concatenar(R, [X], L).

%III)
prefijo([],_).
prefijo([X|XS],[Y|YS]):- X =:= Y, prefijo(XS,YS).

%IV)
sufijo(XS,YS):- reverse(XS,XR), reverse(YS,YR), prefijo(XR,YR).

sufijo2(S, L):-prefijo(P,L),append(P, S, L).

%V)
sublista(S,L):- prefijo(S,L).
sublista(S,[U|L]):- sublista(S,L).

%VI)
pertenece(X,[X|L]).
pertenece(X,[_|L]):- pertenece(X,L).


%6)


%8)
%I)
todasLasMezclas(L1,L2,L3):- concatenar(LP1,_,L1), concatenar(LP2,_,L2), 
  concatenar(LP1,LP2,L3).
estanTodos([],_,_).
estanTodos([X|L3],L1,L2) :- member(X,L1), member(X,L2), estanTodos(L3,L1,L2).
interseccion(L1,L2,L3):- todasLasMezclas(L1,L2,L3), estanTodos(L3,L1,L2).


interseccion2([],_,[],_).
interseccion2([X|L1],L2,L3,U):- not(member(X,L2)), interseccion2(L1,L2,L3,U).
interseccion2([X|L1],L2,[X|L3],U):- member(X,L2), not(member(X,U)), interseccion2(L1,L2,L3,[X|U]).
interseccion2([X|L1],L2,L3,U):- member(X,U), interseccion2(L1,L2,L3,U).
interseccionFinal(L1,L2,L3):- interseccion2(L1,L2,L3,[]).


partir(0,_,L1,L1).
partir(N,[X|L],L1,[X|L2]):- M is N-1, partir(M,L,L1,L2).
%N no es reversible porque nunca temrinaría de instanciarlo. L1 lo es, pero
%no busca una instanciación si no que deja la variable ya que es lo que entra.

%II)
borrar([],_,[]).
borrar([Y|LO],X,[Y|LS]):- Y \= X, borrar(LO,X,LS).
borrar([X|LO],X,LS):- borrar(LO,X,LS).

%III)
sacarDuplicadosAux([],[],_).
sacarDuplicadosAux([X|L1],L2,U):- member(X,U), sacarDuplicadosAux(L1,L2,U).
sacarDuplicadosAux([X|L1],[X|L2],U):- not(member(X,U)), sacarDuplicadosAux(L1,L2,[X|U]).
sacarDuplicados(L1,L2):- sacarDuplicadosAux(L1,L2,[]).

%IV)
permutacionAux([],[]).
permutacionAux([X|L1],L2):- member(X,L2), borrar(L1,X,LB1), borrar(L2,X,LB2), permutacionAux(LB1,LB2).
permutacion(L1,L2):- length(L1,N1), length(L2,N2), N1 =:= N2, permutacionAux(L1,L2).

%V)
listar([],[]).
listar([L|LListas],LL):- concatenar(L,Z,LL), listar(LListas,Z).
reparto(L,N,LListas):- length(LListas,LN), LN =:= N, listar(LListas,LL), L = LL.

%VI)
listarSV([],[]).
listarSV([L|LListas],LL):- concatenar(L,Z,LL), length(L,N), N =\= 0, listarSV(LListas,Z).
repartoSinVacias(L,LListas):- listarSV(LListas,LL), L = LL.


%10)
desde(X,X).
desde(X,Y) :- N is X+1, desde(N,Y).

%I) Con Y mayor a X, si no, nunca va a unificar y va a continuar llamandose con el +1.

%II)


%12)

arbolito(bin(bin(bin(nil,4,nil),2,bin(bin(nil,6,nil),5,nil)),1,bin(nil,3,bin(nil,7,nil)))).

vacio(nil).
raiz(bin(_,X,_),X).

maximo(X,Y,X):- X >= Y.
maximo(X,Y,Y):- X < Y.

altura(nil,0).
altura(bin(nil,_,nil),1).
altura(bin(Izq,_,Der),N):- altura(Izq,I), altura(Der,D), maximo(I,D,L), N is L+1.

cantidadDeNodos(nil,0).
cantidadDeNodos(bin(nil,_,nil),1).
cantidadDeNodos(bin(Izq,_,Der),N):- cantidadDeNodos(Izq,I), cantidadDeNodos(Der,D), L is I+D, N is L+1.


%13)
%I)
inorder(nil,[]).
inorder(bin(nil,V,nil), [V]).
inorder(bin(Izq,V,Der),L):- inorder(Izq, LI), inorder(Der, LD), concatenar(LI,[V],Z), concatenar(Z,LD,L).

%II)
arbolConInorder(L,AB):-inorder(AB,L).

%III)
abb(bin(bin(bin(nil,1,nil),5,bin(bin(nil,6,nil),7,nil)),10,bin(nil,11,bin(nil,13,nil)))).

aBB(nil).
aBB(bin(nil,_,nil)).
aBB(bin(bin(Izq,I,Der),V,nil)):- V >= I, aBB(bin(Izq,I,Der)).
aBB(bin(nil,V,bin(Izq,D,Der))):- D >= V, aBB(bin(Izq,D,Der)).
aBB(bin(bin(IIzq,I,IDer),V,bin(DIzq,D,DDer))):- V >= I, D >= V, aBB(bin(IIzq,I,IDer)), aBB(bin(DIzq,D,DDer)).