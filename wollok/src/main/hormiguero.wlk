import hormigas.*
import alimento.*

class Hormiguero {

	const hormigas = []
	var property depositoAlimento = 0
	const posicion = [0, 0]

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
		hormigas.forEach({ hormiga => self.llamarHormiga(hormiga) })
		hormigas.forEach({ hormiga => self.recibirAlimento(hormiga) })
	}

	method llamarHormiga(hormiga) {
		if (not hormiga.estaCansada()) {
			hormiga.desplazarseA(posicion)
		}
	}
	
	method recibirAlimento(hormiga) {
		if (not hormiga.estaCansada()) {
			depositoAlimento += hormiga.cantidadDeAlimento()
			hormiga.vaciarAlimentoQueLleva()
		}
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
}




