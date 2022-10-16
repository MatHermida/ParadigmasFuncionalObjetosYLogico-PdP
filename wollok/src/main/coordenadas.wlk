object coordenadas {
	method distanciaEntrePuntos(punto1, punto2) {
		return (self.distEnX(punto1, punto2) ** 2 + self.distEnY(punto1, punto2) ** 2).squareRoot()
	}

	method distEnX(punto1, punto2) {
		return punto1.get(0) - punto2.get(0)
	}

	method distEnY(punto1, punto2) {
		return punto1.get(1) - punto2.get(1)
	}
}