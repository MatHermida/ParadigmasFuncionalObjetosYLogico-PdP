import hormigas.*
import alimento.*
import coordenadas.*

class Hormiguero {

	const hormigas = []
	var property depositoAlimento = 0
	const property posicion = [0, 0]

	method aniadirHormigas(hormiga) {
		hormigas.add(hormiga)
	}

	/** Hormigas y Hormigueros **/
	method cantidadDeHormigas() {
		return hormigas.size()
	}

	method cantidadDeAlimentoDeLasHormigas() {
		return hormigas.sum({ hormiga => hormiga.cantidadDeAlimento() })
	}

	method cantidadDeHormigasAlLimite() {
		return hormigas.count({ hormiga => hormiga.estaAlLimite() })
	}

	method llamarHormigas() {		
		hormigas.forEach({ hormiga => hormiga.responderAlLlamadoDelHormiguero() })
	}
	
	method recibirAlimento(cantidadDeAlimento) {
		depositoAlimento += cantidadDeAlimento
	}

	method cantidadDeAlimentoTotal() {
		return depositoAlimento + self.cantidadDeAlimentoDeLasHormigas()
	}

	/** El mundo se expande (REVISAR!!!!)**/
	method distanciaRecorridaTotalPorHormigas() {
		return hormigas.sum({ hormiga => hormiga.distanciaRecorridaTotal() })
	}

	method hormigas() {
		return hormigas
	}
	
	/** ¡Enemigos! **/
	method detectarIntruso(unBicho) {
		if (self.consideraIntruso(unBicho)) {
			self.defenderseDe(unBicho)
		}
	}
	
	method consideraIntruso(unBicho) {
		return self.estaMasCercaDe(2, unBicho) and not hormigas.contains(unBicho)
	}
	
	method estaMasCercaDe(distancia, unBicho) {
		return coordenadas.distanciaEntrePuntos(posicion, unBicho.ubicacionActual()) < distancia
	}
	
	method defenderseDe(unBicho) {
		hormigas.forEach({ hormiga => hormiga.atacar(unBicho) })
	}
	
	method eliminarHormiga(hormiga) {
		hormigas.remove(hormiga)
	}
	
	
}

class HormigueroCercano inherits Hormiguero {
	override method defenderseDe(unBicho) {
		hormigas.filter({ hormiga => self.estaMasCercaDe(5, hormiga) }).forEach({ hormiga => hormiga.atacar(unBicho) })
	}
}

class HormigueroCualesquiera inherits Hormiguero {
	override method defenderseDe(unBicho) {
		self.seleccionarDiezHormigasCualesquiera().forEach({ hormiga => hormiga.atacar(unBicho) })
	}
	
	method seleccionarDiezHormigasCualesquiera() {
		const hormigasAtacantes = #{ }
		10.times({ i => hormigasAtacantes.add( hormigas.anyOne() ) })
		return hormigasAtacantes
	}
}

class HormigueroViolento inherits Hormiguero {
	override method defenderseDe(unBicho) {
		hormigas.filter({ hormiga => hormiga.esViolenta() }).forEach({ hormiga => hormiga.atacar(unBicho) })
	}
}









