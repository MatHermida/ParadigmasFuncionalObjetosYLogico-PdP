:-style_check(-discontiguous).
%--------------- 1 ---------------
persona(bakunin).
persona(ravachol).
persona(rosaDubovsky).
persona(emmaGoldman).
persona(judithButler).
persona(elisaBachofen).
persona(juanSuriano).
persona(sebastienFaure).

trabajo(bakunin,        aviacionMilitar).
trabajo(ravachol,       inteligenciaMilitar).
trabajo(emmaGoldman,    profesoraDeJudo).
trabajo(emmaGoldman,    cineasta). 
trabajo(judithButler,   profesoraDeJudo).
trabajo(judithButler,   inteligenciaMilitar).
trabajo(elisaBachofen,  ingenieraMecanica).

esHabilidosoEn(bakunin,         conduciendoAutos).
esHabilidosoEn(ravachol,        tiroAlBlanco).
esHabilidosoEn(rosaDubovsky,    contruyendoPuentes).
esHabilidosoEn(rosaDubovsky,    mirarPeppaPig).
esHabilidosoEn(emmaGoldman, EsBuena) :-
    esHabilidosoEn(judithButler, EsBuena).
esHabilidosoEn(emmaGoldman, EsBuena) :-
    esHabilidosoEn(elisaBachofen, EsBuena).
esHabilidosoEn(judithButler,    judo).
esHabilidosoEn(elisaBachofen,   armarBombas).
esHabilidosoEn(juanSuriano,     judo).
esHabilidosoEn(juanSuriano,     armarBombas).
esHabilidosoEn(juanSuriano,     ringRaje).

leGusta(ravachol,       juegosDeAzar).
leGusta(ravachol,       ajedrez). 
leGusta(ravachol,       tiroAlBlanco).
leGusta(rosaDubovsky,   contruyendoPuentes).
leGusta(rosaDubovsky,   mirarPeppaPig).
leGusta(rosaDubovsky,   fisicaCuantica).
leGusta(emmaGoldman, Gustos) :-
    leGusta(judithButler, Gustos).
leGusta(judithButler,   judo).
leGusta(judithButler,   carrerasDeAutomovilismo).
leGusta(elisaBachofen,  fuego).
leGusta(elisaBachofen,  destruccion).
leGusta(juanSuriano,    judo).
leGusta(juanSuriano,    armarBombas).
leGusta(juanSuriano,    ringRaje).

histCriminal(bakunin,       roboDeAeronaves).
histCriminal(bakunin,       fraude).
histCriminal(bakunin,       tenenciaDeCafeina).
histCriminal(ravachol,      falsificacionDeVacunas).
histCriminal(ravachol,      fraude).
histCriminal(judithButler,  falsificacionDeCheques).
histCriminal(judithButler,  fraude).
histCriminal(juanSuriano,   falsificacionDeDinero).
histCriminal(juanSuriano,   fraude).

%--------------- 2 ---------------
vivienda(laSeverino).
vivienda(comisaria48).
vivienda(casaDePapel).
vivienda(casaDelSolNaciente).

viveEn(bakunin,         laSeverino).
viveEn(elisaBachofen,   laSeverino).
viveEn(rosaDubovsky,    laSeverino).
viveEn(ravachol,        comisaria48).
viveEn(emmaGoldman,     casaDePapel).
viveEn(juanSuriano,     casaDePapel).
viveEn(judithButler,    casaDePapel).

%Tipos de ambientes secretos:
%   cuartoSecreto(UnLado, OtroLado)
%   tunelSecreto(Largo)
%   pasadizo(Cantidad)

ambienteSecretoDe(laSeverino, cuartoSecreto(4, 8)).
ambienteSecretoDe(laSeverino, pasadizo(1)).
ambienteSecretoDe(laSeverino, tunelSecreto(8)).
ambienteSecretoDe(laSeverino, tunelSecreto(5)).

ambienteSecretoDe(casaDePapel, cuartoSecreto(5, 3)).
ambienteSecretoDe(casaDePapel, cuartoSecreto(4, 7)).
ambienteSecretoDe(casaDePapel, pasadizo(2)).
ambienteSecretoDe(casaDePapel, tunelSecreto(9)).
ambienteSecretoDe(casaDePapel, tunelSecreto(2)).

ambienteSecretoDe(casaDelSolNaciente, pasadizo(1)).

%--------------- 3 ---------------
esGuaridaRebelde(Vivienda) :-
    viveUnDisidente(Vivienda),
    superficieClandestinaTotal(Vivienda, SuperficieTotal),
    SuperficieTotal > 50.

viveUnDisidente(Vivienda) :-
    viveEn(Persona, Vivienda),
    esDisidente(Persona).

superficieClandestinaTotal(Vivienda, SuperficieTotal) :-
    vivienda(Vivienda),
    findall(Superficie, superficieClandestinaDeUnAmbiente(Vivienda, Superficie), ListaSuperficies),
    sum_list(ListaSuperficies, SuperficieTotal).

superficieClandestinaDeUnAmbiente(Vivienda, Superficie) :-
    ambienteSecretoDe(Vivienda, AmbienteSecreto),
    superficieDeAmbientePorTipo(AmbienteSecreto, Superficie).

superficieDeAmbientePorTipo(cuartoSecreto(Lado1, Lado2), Superficie) :-
    Superficie is Lado1 * Lado2.
superficieDeAmbientePorTipo(tunelSecreto(Largo), Superficie) :-
    Superficie is Largo * 2.
superficieDeAmbientePorTipo(pasadizo(CantidadPasadizos), Superficie) :-
    Superficie is CantidadPasadizos.

%--------------- 4 ---------------
noViveNadie(Vivienda) :-
    vivienda(Vivienda),
    not(viveEn(_, Vivienda)).

hayUnGustoEnComunEnVivienda(Vivienda) :-
    viveEn(UnaPersona, Vivienda),
    leGusta(UnaPersona, UnGusto),
    forall(viveEn(Persona, Vivienda), leGusta(Persona, UnGusto)).

%--------------- 5 ---------------
esDisidente(Persona) :-
    tieneHabilidadTerrorista(Persona),
    gustosSospechosos(Persona),
    esCercanoAUnCriminal(Persona).

tieneHabilidadTerrorista(Persona) :-
    esHabilidosoEn(Persona, Habilidad),
    esHabilidadTerrorista(Habilidad).

esHabilidadTerrorista(armarBombas).
esHabilidadTerrorista(tiroAlBlanco).
esHabilidadTerrorista(mirarPeppaPig).

gustosSospechosos(Persona) :-
    persona(Persona),
    not(leGusta(Persona, _)).
gustosSospechosos(Persona) :-
    persona(Persona),
    forall(esHabilidosoEn(Persona, Actividad), leGusta(Persona, Actividad)).

esCercanoAUnCriminal(Persona) :-
    esCriminal(Persona).
esCercanoAUnCriminal(Persona) :-
    conviveCon(Persona, OtraPersona),
    esCriminal(OtraPersona).

conviveCon(Persona, OtraPersona) :-
    viveEn(Persona, Vivienda),
    viveEn(OtraPersona, Vivienda),
    Persona \= OtraPersona.

esCriminal(Persona) :-
    histCriminal(Persona, UnCrimen),
    histCriminal(Persona, OtroCrimen),
    UnCrimen \= OtroCrimen.

%--------------- 6 ---------------
/* Gracias a haber utilizado functores para determinar los tipos de ambientes secretos y 
    gracias al polimorfismo del predicado "superficieDeAmbientePorTipo" con el cual
    evaluamos la superficie dependiendo del tipo de ambiente; 
    el unico cambio que requerimos hacer es agregar 1 clausula a ese predicado
    para que el polimorfismo pueda evaluar un tipo(functor) de bunker(Perimetro, SuperficieInterna)
*/
superficieDeAmbientePorTipo(bunker(Perimetro, SuperficieInterna), Superficie) :-
    Superficie is SuperficieInterna + Perimetro.

%--------------- 7 ---------------
batallonDeRebeldes(Batallon):-
    findall(Rebelde, esCercanoAUnCriminal(Rebelde), Rebeldes),
    list_to_set(Rebeldes, RebeldesSinRepetidos),
    batallon(RebeldesSinRepetidos, Batallon),
    sumanMasDe3HabilidadesEntreTodos(Batallon).

batallon([], []).
batallon([Rebelde|Rebeldes], [Rebelde|RestoDelBatallon]):-
    batallon(Rebeldes, RestoDelBatallon).
batallon([_|Rebeldes], RestoDelBatallon):-
    batallon(Rebeldes, RestoDelBatallon).

sumanMasDe3HabilidadesEntreTodos(Batallon) :-
    findall(Hab, (member(Persona, Batallon), esHabilidosoEn(Persona, Hab)), Habilidades),
    length(Habilidades, CantHab),
    CantHab > 3.

/*
Los conceptos que resuelven este ejercicio son:
 - findall para poder generar todos los Rebeldes que pueden formar parte de un batallon
 - list_to_set para poder eliminar a los Rebeldes repetidos de la lista de Rebeldes
 - mecanismo de backtracking de Prolog permite encontrar todas las soluciones posibles
 - El concepto de Explosión Combinatoria para poder generar todas las combinaciones posibles de Rebeldes 
    que juntos forman un batallon
*/