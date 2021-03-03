%declaracion de librerias para la interfaz

:-use_module(library(pce)).
:-use_module(library(pce_style_item)).

% metodo principal para iniciar la interfaz grafica, declaracion de
% botones, labels, y la pocicion en pantalla.
inicio:-
	new(Menu, dialog('Yerberito', size(1000,1000))),
	new(L,label(nombre,'Yerberito')),
	new(A,label(nombre,'S16120276 - C16120547')),
	new(@texto,label(nombre,'Responde unas preguntas')),
	new(@respl,label(nombre,'')),
	new(Salir,button('Salir',and(message(Menu, destroy),message(Menu,free)))),
	new(@boton,button('Inicio',message(@prolog,botones))),


	send(Menu,append(L)),new(@btncarrera,button('Diagnostico?')),
	send(Menu,display,L,point(80,20)),
	send(Menu,display,A,point(150,400)),
	send(Menu,display,@boton,point(100,150)),
	send(Menu,display,@texto,point(20,100)),
	send(Menu,display,Salir,point(20,400)),
	send(Menu,display,@respl,point(20,130)),
	send(Menu,open_centered).

%Descripcion de la planta y recomendaciones

fallas('Sufres de irritacion estomacal, el hígado 
inflamado o diarrea'):-irritacion,!.

fallas('Te encuentras constipado'):-constipado,!.

fallas('Tienes problemas estomacales y 
probablemente olores desagradables, 
si no, tienes, cólicos'):-digestion,!.

fallas('Sin resultados, usted no dio la 
informacion necesaria o suficiente').

% preguntas para dirigir a la planta adecuada con su respectivo
% identificador

irritacion:- sirritacion,
	pregunta('¿Dificultad para respirar?'),
	pregunta('¿Tienes asma?').

constipado:- schichigua,
	pregunta('¿Dificultad para respirar?'),
	pregunta('¿Constipado leve?').
	
digestion:- sdigestion,
	pregunta('¿Gases?'),
	pregunta('¿Mal olor?');
	pregunta('¿Cólicos?').

%identificador de falla que dirige a las preguntas correspondientes

sirritacion:-pregunta('¿Sufres de irritación?'),!.
sconstipado:-pregunta('¿Dolor corporal?'),!.
sdigestion:-pregunta('¿Digestión mala?'),!.

% proceso de la recomendación basado en preguntas de si y no, cuando el
% usuario dice si, se pasa a la siguiente pregunta del mismo ramo, si
% dice que no se pasa a la pregunta del siguiente ramo


:-dynamic si/1,no/1.
preguntar(Problema):- new(Di,dialog('Recomendación planta')),
     new(L2,label(texto,'Responde las siguientes preguntas')),
     new(La,label(prob,Problema)),
     new(B1,button(si,and(message(Di,return,si)))),
     new(B2,button(no,and(message(Di,return,no)))),

         send(Di,append(L2)),
	 send(Di,append(La)),
	 send(Di,append(B1)),
	 send(Di,append(B2)),

	 send(Di,default_button,si),
	 send(Di,open_centered),get(Di,confirm,Answer),
	 write(Answer),send(Di,destroy),
	 ((Answer==si)->assert(si(Problema));
	 assert(no(Problema)),fail).

% cada vez que se conteste una pregunta la pantalla se limpia para
% volver a preguntar

pregunta(S):-(si(S)->true; (no(S)->fail; preguntar(S))).
limpiar :- retract(si(_)),fail.
limpiar :- retract(no(_)),fail.
limpiar.

% proceso de eleccion de acuerdo al diagnostico basado en las preguntas
% anteriores

botones :- lim,
	send(@boton,free),
	send(@btncarrera,free),
	fallas(Falla),
	send(@texto,selection(' ')),
	send(@respl,selection(Falla)),
	new(@boton,button('inicia procedimiento mecanico',message(@prolog,botones))),
        send(Menu,display,@boton,point(40,50)),
        send(Menu,display,@btncarrera,point(20,50)),
limpiar.
lim :- send(@respl, selection('')).
