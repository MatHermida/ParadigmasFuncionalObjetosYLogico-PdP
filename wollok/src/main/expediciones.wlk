class Expedicion {

	const alimento
	var property hormigasExpedicion = []

	method asignarHormigas(hormigasSeleccionadas) {
		hormigasExpedicion = hormigasSeleccionadas
	}

	method concretarTarea() {
		hormigasExpedicion.forEach({ hormiga => hormiga.cumplirExpedicion(alimento) })
	}
	
	method liberarHormigas() {
		hormigasExpedicion.clear()
	}

}
