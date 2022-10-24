import hormigas.*
import alimento.*
import coordenadas.*
import estados_De_Energia.*
import expediciones.*

class Hormiguero {

	const hormigas = []
	var property depositoAlimento = 0
	const property posicion = [ 0, 0 ]
	var expedicionActual = null

	method aniadirHormiga(hormiga) {
		hormigas.add(hormiga)
		hormiga.asignarHormiguero(self)
	}

	method hormigas() {
		return hormigas
	}

	/** Hormigas y Hormigueros **/
	method poblacionTotal() {
		return hormigas.size()
	}

	method cantidadDeAlimentoDeLasHormigas() {
		return hormigas.sum({ hormiga => hormiga.cantidadDeAlimento() })
	}

	method cantidadDeHormigasAlLimite() {
		return hormigas.count({ hormiga => hormiga.estaAlLimite() })
	}

	method reclamarAlimento() {
		hormigas.forEach({ hormiga => hormiga.entregarAlimentoAlHormiguero()})
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
		hormigas.forEach({ hormiga => hormiga.atacar(unBicho)})
	}

	method eliminarHormiga(hormiga) {
		hormigas.remove(hormiga)
	}

	/** Expediciones **/
	method expedicionActual() {
		return expedicionActual
	}
	
	method prepararExpedicion(unAlimento) {
		if (expedicionActual == null) {
				// 1.
			const hormigasSeleccionadas = self.seleccionarHormigasParaRecolectarAlimentoCompleto(unAlimento)
				// 2.
			expedicionActual = new Expedicion(alimento = unAlimento)
			expedicionActual.asignarHormigas(hormigasSeleccionadas)
			self.removerHormigas(hormigasSeleccionadas)
				// 3.
			self.reclamarAlimentoDe(hormigasSeleccionadas)
		} else {
			self.error("Ya hay una expedicion activa, entonces no se puede preparar otra expedicion")
		}
	}

	method cantHormigasNecesariasParaRecolectarAlimentoCompleto(alimento) {
		return ( alimento.peso() / normal.cantidadMaximaDeAlimento() ).roundUp()
	}

	method seleccionarHormigasParaRecolectarAlimentoCompleto(unAlimento) {
		return hormigas.take(self.cantHormigasNecesariasParaRecolectarAlimentoCompleto(unAlimento))
	}

	method removerHormigas(hormigasExpedicion) {
		hormigas.removeAllSuchThat({ hormiga => hormigasExpedicion.contains(hormiga)})
	}

	method reclamarAlimentoDe(hormigasSeleccionadas) {
		hormigasSeleccionadas.forEach({ hormiga => hormiga.entregarAlimentoAlHormiguero()})
	}

	method concretarExpedicion() {
		if (expedicionActual != null) {
			expedicionActual.concretarTarea()
		} else {
			self.error("No hay una expedicion activa, entonces no se puede enviar a recolectar alimento")
		}
	}

	method desarmarExpedicion() {
		if (expedicionActual != null) {
			hormigas.addAll(expedicionActual.hormigasExpedicion())
			expedicionActual.liberarHormigas()
			expedicionActual = null
		} else {
			self.error("No hay una expedicion activa, entonces no se puede desarmar una expedicion")
		}
	}

}

class HormigueroCercano inherits Hormiguero {

	override method defenderseDe(unBicho) {
		hormigas.filter({ hormiga => self.estaMasCercaDe(5, hormiga)}).forEach({ hormiga => hormiga.atacar(unBicho)})
	}

}

class HormigueroCualesquiera inherits Hormiguero {

	override method defenderseDe(unBicho) {
		self.seleccionarDiezHormigasCualesquiera().forEach({ hormiga => hormiga.atacar(unBicho)})
	}

	method seleccionarDiezHormigasCualesquiera() {
		const hormigasAtacantes = #{ }
		10.times({ i => hormigasAtacantes.add(hormigas.anyOne())})
		return hormigasAtacantes
	}

}

class HormigueroViolento inherits Hormiguero {

	override method defenderseDe(unBicho) {
		hormigas.filter({ hormiga => hormiga.esViolenta()}).forEach({ hormiga => hormiga.atacar(unBicho)})
	}

}






