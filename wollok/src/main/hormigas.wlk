import coordenadas.*
import estados_De_Energia.*
import estados_De_Vida.*
import hormiguero.*

class Hormiga {

	var hormiguero = null
	var estadoDeVida = viva

	method asignarHormiguero(unHormiguero) {
		hormiguero = unHormiguero
	}

	method cantidadDeAlimento()

	method estaAlLimite()
	
	method ubicacionActual()
	
	method distanciaRecorridaTotal()

	method entregarAlimentoAlHormiguero()

	method obtenerAlimentoDe(alimento)

	/** ¡Enemigos! **/
	method cantidadDanio()

	method atacar(unBicho) {
		unBicho.recibirAtaqueDe(self)
	}

	method recibirAtaqueDe(unBicho) {
		self.morir()
	}

	method morir() {
		hormiguero.eliminarHormiga(self)
		estadoDeVida = muerta
	}

	method estaViva() {
		return estadoDeVida.esViva()
	}

	method esViolenta() {
		return false
	}

}

/** Diversificacion **/
class HormigaDesplazable inherits Hormiga {

	const puntosRecorridos = [ [0,0] ]
	const distanciaDeViajes = [ 0 ]

	/** El mundo se expande (REVISAR!!!!)**/
	method desplazarseA(punto)

	override method ubicacionActual() {
		return puntosRecorridos.last()
	}

	override method distanciaRecorridaTotal() {
		return distanciaDeViajes.sum({ dist => dist })
	}

	method distanciaRecorridaPromedio() {
		return self.distanciaRecorridaTotal() / (distanciaDeViajes.size() - 1)
	}

	method puntosRecorridos() {
		return puntosRecorridos
	}

	method distanciaRecorridaTotalEnNViajes(cantViajes) {
		return distanciaDeViajes.drop(distanciaDeViajes.size() - cantViajes).sum({ dist => dist })
	}

	method distanciaRecorridaPromedioEnNViajes(cantViajes) {
		return self.distanciaRecorridaTotalEnNViajes(cantViajes) / cantViajes
	}

}

class HormigaObrera inherits HormigaDesplazable {

	var cantidadDeAlimento = 0
	var estadoDeEnergia = normal

	/** Hormigas y Hormigueros **/
	method cantidadMaximaDeAlimento() {
		return estadoDeEnergia.cantidadMaximaDeAlimento()
	}

	override method cantidadDeAlimento() {
		return cantidadDeAlimento
	}
		
	override method estaAlLimite() {
		return cantidadDeAlimento.between(9, 10)
	}

	override method entregarAlimentoAlHormiguero() {
		estadoDeEnergia.entregarAlimentoAlHormiguero(self, hormiguero)
	}

	method vaciarAlimentoQueLleva() {
		cantidadDeAlimento = 0
	}

	/** El mundo se expande (REVISAR!!!!)**/
	override method desplazarseA(punto) {
		estadoDeEnergia.desplazarHormigaA(self, punto)
	}

	method registrarViajeA(punto) {
		distanciaDeViajes.add(coordenadas.distanciaEntrePuntos(self.ubicacionActual(), punto))
		puntosRecorridos.add(punto)
	}

	/** ¡¡Comidaaaaa!! **/
	override method obtenerAlimentoDe(alimento) {
		estadoDeEnergia.obtenerAlimentoDe(self, alimento)
	}

	method extraerAlimentoDe(alimento) {
		const cantAConseguir = self.cantMaxPosibleDeConseguirDe(alimento)
		if (cantAConseguir > 0) {
			cantidadDeAlimento += cantAConseguir
			alimento.extraerAlimento(cantAConseguir)
		}
	}

	method cantMaxPosibleDeConseguirDe(alimento) {
		return (self.cantHastaPesoMaximo()).min(alimento.cantMaxPosibleDeExtraer())
	}

	method cantHastaPesoMaximo() {
		return self.cantidadMaximaDeAlimento() - cantidadDeAlimento
	}

	/** Cansancio **/
	method estadoDeEnergia() {
		return estadoDeEnergia
	}

	method descansar() {
		estadoDeEnergia.descansarHormiga(self)
	}

	method pasarAEstadoDeEnergia(ciertoEstadoDeDenergia) {
		estadoDeEnergia = ciertoEstadoDeDenergia
	}

	method cansarse() {
		estadoDeEnergia.cansarHormiga(self)
	}

	method estaCansada() {
		return estadoDeEnergia.esCansada()
	}

	/** ¡Enemigos! **/
	override method cantidadDanio() {
		return 2
	}
	
	/** Expedicion **/
	method cumplirExpedicion(alimento) {
		self.obtenerAlimentoDe(alimento)
		self.desplazarseA(hormiguero.posicion())
		hormiguero.recibirAlimento( self.cantidadDeAlimento() )
		self.vaciarAlimentoQueLleva()
	}
}

/** Diversificacion **/
class HormigaSoldado inherits HormigaDesplazable {

	var vida = 20

	method vida() {
		return vida
	}
	
	override method cantidadDeAlimento() {
		return 0
	}

	override method obtenerAlimentoDe(alimento) {
		throw new Exception(message = "hormiga soldado no puede recolectar alimento")
	}

	override method estaAlLimite() {
		return false
	}

	override method desplazarseA(punto) {
		distanciaDeViajes.add(coordenadas.distanciaEntrePuntos(self.ubicacionActual(), punto))
		puntosRecorridos.add(punto)
	}

	override method entregarAlimentoAlHormiguero() {
		self.desplazarseA(hormiguero.posicion())
	}

	/** ¡Enemigos! **/
	override method cantidadDanio() {
		return 5
	}

	override method recibirAtaqueDe(unBicho) {
		vida -= unBicho.cantidadDanio()
		if (self.vidaLlegoACero()) self.morir()
	}

	method vidaLlegoACero() {
		return vida <= 0
	}

	method restaurarVida() {
		vida = 20
		estadoDeVida = viva
	}

	override method esViolenta() {
		return true
	}

}

class HormigaZangano inherits Hormiga {

	override method cantidadDeAlimento() {
		return 0
	}
	
	override method ubicacionActual() {
		return hormiguero.posicion()
	}
	
	override method distanciaRecorridaTotal() {
		return 0
		//throw new Exception(message = "hormiga zangano no puede saber su distancia recorrida")
	}
	
	override method obtenerAlimentoDe(alimento) {
		throw new Exception(message = "hormiga zangano no puede recolectar alimento")
	}

	override method estaAlLimite() {
		return true
	}

	override method entregarAlimentoAlHormiguero() {
		hormiguero.recibirAlimento(1)
	}

	/** ¡Enemigos! **/
	override method cantidadDanio() {
		return 0
	}

}

class HormigaReina inherits Hormiga {
	
	override method cantidadDeAlimento() {
		return 0
	}
	
	override method ubicacionActual() {
		return hormiguero.posicion()
	}
	
	override method distanciaRecorridaTotal() {
		return 0
		//throw new Exception(message = "hormiga reina no puede saber su distancia recorrida")
	}

	override method obtenerAlimentoDe(alimento) {
		throw new Exception(message = "hormiga reina no puede recolectar alimento")
	}

	override method estaAlLimite() {
		return false
	}

	override method entregarAlimentoAlHormiguero() {
		hormiguero.recibirAlimento(0)
	}

	/** ¡Enemigos! **/
	override method cantidadDanio() {
		return 0
	}

}
