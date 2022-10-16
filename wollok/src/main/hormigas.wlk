import coordenadas.*
import estados_De_Energia.*
import hormiguero.*

/** Diversificacion **/
class HormigaDesplazable {
	const puntosRecorridos = [ [0,0] ]
	const distanciaDeViajes = [ 0 ]

	/** El mundo se expande (REVISAR!!!!)**/
	method desplazarseA(punto)

	method ubicacionActual() {
		return puntosRecorridos.last()
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
}

class HormigaObrera inherits HormigaDesplazable {
	var cantidadDeAlimento = 0
	var estadoDeEnergia = normal
	const hormiguero = new Hormiguero()

	/** Hormigas y Hormigueros **/
	method cantidadMaximaDeAlimento() {
		return estadoDeEnergia.cantidadMaximaDeAlimento()
	}

	method cantidadDeAlimento() {
		return cantidadDeAlimento
	}

	method estaAlLimite() {
		return cantidadDeAlimento.between(9, 10)
	}

	method responderAlLlamadoDelHormiguero(){
		if (not self.estaCansada()) {
			self.desplazarseA(hormiguero.posicion())
			hormiguero.recibirAlimento( self.cantidadDeAlimento() )
			self.vaciarAlimentoQueLleva()
		}
	}
	
	method vaciarAlimentoQueLleva() {
		cantidadDeAlimento = 0
	}
	
	/** El mundo se expande (REVISAR!!!!)**/
	override method desplazarseA(punto) {
		if (not self.estaCansada()) {
			distanciaDeViajes.add(coordenadas.distanciaEntrePuntos(self.ubicacionActual(), punto))
			puntosRecorridos.add(punto)
		}
		
		self.cansarse()
	}

	/** ¡¡Comidaaaaa!! **/
	method obtenerAlimentoDe(alimento) {
		estadoDeEnergia.obtenerAlimentoDe(self, alimento)
	}

	method extraerAlimentoDe(alimento) {
		const cantAExtraer = self.cantMaxPosibleDeExtraerDe(alimento)
		if (/*not self.estaLlena() and alimento*/self.puedeExtraerAlgo(cantAExtraer)) {
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
		if (estadoDeEnergia === cansada) {
			estadoDeEnergia = normal
		} else if (estadoDeEnergia === normal) {
			estadoDeEnergia = exaltada
		}
	}

	method cansarse() {
		if (self.distanciaRecorridaTotal() >= 10) {
			estadoDeEnergia = cansada
		} else if ((estadoDeEnergia === exaltada) and (self.distanciaRecorridaTotal() >= 5)) {
			estadoDeEnergia = normal
		}
	}

	method estaCansada() {
		return estadoDeEnergia === cansada
	}

	/** ¡Enemigos! **/
	method cantidadDanio() {
		return 2
	}
	
	method atacar(unBicho) {
		unBicho.recibirAtaqueDe(self)
	}
	
	method recibirAtaqueDe(unBicho) {
		hormiguero.eliminarHormiga(self)
	}
	
	method esViolenta() {
		return false
	}
}

/** Diversificacion **/
class HormigaSoldado inherits HormigaDesplazable {
	const hormiguero
	var vida = 20
	
	method estaAlLimite() {
		return false
	}
	
	override method desplazarseA(punto) {
		distanciaDeViajes.add(coordenadas.distanciaEntrePuntos(self.ubicacionActual(), punto))
		puntosRecorridos.add(punto)
	}
	
	method responderAlLlamadoDelHormiguero(){
		self.desplazarseA(hormiguero.posicion())
	}
	
	/** ¡Enemigos! **/
	method cantidadDanio() {
		return 5
	}
	
	method atacar(unBicho) {
		unBicho.recibirAtaqueDe(self)
	}
	
	method recibirAtaqueDe(unBicho) {
		vida -= unBicho.cantidadDanio()
		if( not self.estaVivo() ){
			hormiguero.eliminarHormiga(self)
		}
	}
	
	method restaurarVida() {
		vida = 20
	}
	
	method estaVivo() {
		return vida > 0
	}
	
	method esViolenta() {
		return true
	}
}

class HormigaZangano {
	const hormiguero
	
	method estaAlLimite() {
		return true
	}
	
	method responderAlLlamadoDelHormiguero(){
		hormiguero.recibirAlimento( 1 )
	}
	
	/** ¡Enemigos! **/
	method cantidadDanio() {
		return 0
	}
	
	method atacar(unBicho) {
		unBicho.recibirAtaqueDe(self)
	}
	
	method recibirAtaqueDe(unBicho) {
		hormiguero.eliminarHormiga(self)
	}
	
	method esViolenta() {
		return false
	}
}

class HormigaReina {
	const hormiguero
	
	method estaAlLimite() {
		return false
	}
	
	method responderAlLlamadoDelHormiguero(){
		hormiguero.recibirAlimento( 0 )
	}
	
	/** ¡Enemigos! **/
	method cantidadDanio() {
		return 0
	}
	
	method atacar(unBicho) {
		unBicho.recibirAtaqueDe(self)
	}
	
	method recibirAtaqueDe(unBicho) {
		hormiguero.eliminarHormiga(self)
	}
	
	method esViolenta() {
		return false
	}
}

/** ********************************************* **/
object langosta {
	var vida = 50
	
	method cantidadDanio() {
		return 10
	}
	
	method atacar(unBicho) {
		unBicho.recibirAtaqueDe(self)
	}
	
	method recibirAtaqueDe(unBicho) {
		vida -= unBicho.cantidadDanio()
		self.atacar(unBicho)
	}
}






