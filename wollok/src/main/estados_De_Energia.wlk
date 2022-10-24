object cansada {

	method cantidadMaximaDeAlimento() {
		return normal.cantidadMaximaDeAlimento()
	}

	method entregarAlimentoAlHormiguero(hormiga, hormiguero) {
	}

	method desplazarHormigaA(hormiga, punto) {
	}

	method obtenerAlimentoDe(hormiga, alimento) {
	}

	method descansarHormiga(hormiga) {
		hormiga.pasarAEstadoDeEnergia(normal)
	}

	method cansarHormiga(hormiga) {
	}

	method esCansada() {
		return true
	}

}

object normal {

	method cantidadMaximaDeAlimento() {
		return 10
	}

	method entregarAlimentoAlHormiguero(hormiga, hormiguero) {
		hormiga.desplazarseA(hormiguero.posicion())
		hormiguero.recibirAlimento(hormiga.cantidadDeAlimento())
		hormiga.vaciarAlimentoQueLleva()
	}

	method desplazarHormigaA(hormiga, punto) {
		hormiga.registrarViajeA(punto)
		hormiga.cansarse()
	}

	method obtenerAlimentoDe(hormiga, alimento) {
		hormiga.desplazarseA(alimento.posicion())
		hormiga.extraerAlimentoDe(alimento)
	}

	method descansarHormiga(hormiga) {
		hormiga.pasarAEstadoDeEnergia(exaltada)
	}

	method cansarHormiga(hormiga) {
		if (hormiga.distanciaRecorridaTotal() >= 10) {
			hormiga.pasarAEstadoDeEnergia(cansada)
		}
	}

	method esCansada() {
		return false
	}

}

object exaltada {

	method cantidadMaximaDeAlimento() {
		return normal.cantidadMaximaDeAlimento() * 2
	}

	method entregarAlimentoAlHormiguero(hormiga, hormiguero) {
		normal.entregarAlimentoAlHormiguero(hormiga, hormiguero)
	}

	method desplazarHormigaA(hormiga, punto) {
		normal.desplazarHormigaA(hormiga, punto)
	}

	method obtenerAlimentoDe(hormiga, alimento) {
		normal.obtenerAlimentoDe(hormiga, alimento)
	}

	method descansarHormiga(hormiga) {
	}

	method cansarHormiga(hormiga) {
		if (hormiga.distanciaRecorridaTotal() >= 5) {
			hormiga.pasarAEstadoDeEnergia(normal)
		}
	}

	method esCansada() {
		return false
	}

}

