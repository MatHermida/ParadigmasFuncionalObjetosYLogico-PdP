class Hormiga {

	var cantidadDeAlimento = 0
	const puntosRecorridos = [ [0,0] ]
	const distanciaDeViajes = [ 0 ]
	var estadoDeEnergia = "normal"

	/** Hormigas y Hormigueros **/
	method cantidadMaximaDeAlimento() {
		if (estadoDeEnergia != "exaltada") {
			return 10
		} else {
			return 10 * 2
		}
	}

	method cantidadDeAlimento() {
		return cantidadDeAlimento
	}

	method estaAlLimite() {
		return cantidadDeAlimento.between(9, 10)
	}

	method vaciarAlimentoQueLleva() {
		cantidadDeAlimento = 0
	}

	/** El mundo se expande (REVISAR!!!!)**/
	method desplazarseA(punto) {
		if (not self.estaCansada()) {
			distanciaDeViajes.add(self.distanciaAlPunto(punto))
			puntosRecorridos.add(punto)
		}
		
		self.cansarse()
	}

	method ubicacionActual() {
		return puntosRecorridos.last()
	}

	method distanciaAlPunto(punto) {
		return (self.distEnX(punto) ** 2 + self.distEnY(punto) ** 2).squareRoot()
	}

	method distEnX(punto) {
		return punto.get(0) - self.ubicacionActual().get(0)
	}

	method distEnY(punto) {
		return punto.get(1) - self.ubicacionActual().get(1)
	}

	method distanciaRecorridaTotal() {
		return distanciaDeViajes.sum({ dist => dist })
	}

	method distanciaRecorridaPromedio() {
		return self.distanciaRecorridaTotal() / (distanciaDeViajes.size() - 1)
	}

	method puntosRecorridos() {
		return puntosRecorridos
	}

	method distanciaRecorridaTotalEnNViajes(cantViajes) {
		return distanciaDeViajes.drop( distanciaDeViajes.size() - cantViajes ).sum({ dist => dist })
	}
	
	method distanciaRecorridaPromedioEnNViajes(cantViajes) {
		return self.distanciaRecorridaTotalEnNViajes(cantViajes) / cantViajes
	}

	/** ¡¡Comidaaaaa!! **/
	method obtenerAlimentoDe(alimento) {
		if (not self.estaCansada()) {
			self.desplazarseA(alimento.posicion())
			self.extraerAlimentoDe(alimento)
		}
	}

	method extraerAlimentoDe(alimento) {
		const cantAExtraer = self.cantMaxPosibleDeExtraerDe(alimento)
		if (self.puedeExtraerAlgo(cantAExtraer)) {
			cantidadDeAlimento += cantAExtraer
			alimento.extraerAlimento(cantAExtraer)
		}
	}

	method cantMaxPosibleDeExtraerDe(alimento) {
		return (self.cantQueLeFaltaHastaPesoMaximo()).min(alimento.cantMaxPosibleDeExtraer())
	}

	method cantQueLeFaltaHastaPesoMaximo() {
		return self.cantidadMaximaDeAlimento() - cantidadDeAlimento
	}

	method puedeExtraerAlgo(cantAExtraer) {
		return not cantAExtraer.equals(0)
	}

	/** Cansancio **/
	method estadoDeEnergia() {
		return estadoDeEnergia
	}

	method descansar() {
		if (estadoDeEnergia == "cansada") {
			estadoDeEnergia = "normal"
		} else if (estadoDeEnergia == "normal") {
			estadoDeEnergia = "exaltada"
		}
	}

	method cansarse() {
		if (self.distanciaRecorridaTotal() >= 10) {
			estadoDeEnergia = "cansada"
		} else if ((estadoDeEnergia == "exaltada") and (self.distanciaRecorridaTotal() >= 5)) {
			estadoDeEnergia = "normal"
		}
	}

	method estaCansada() {
		return estadoDeEnergia == "cansada"
	}

}

