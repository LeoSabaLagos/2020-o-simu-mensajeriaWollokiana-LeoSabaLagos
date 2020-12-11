import mensajes.*
import usuarios.*

class Chat {
	
	var participantes = #{}
	
	var mensajesEnviados = []
	
	// En nuestro servicio de mensajería, existen chats, y se pueden enviar los mensajes a esos chats
	
	method validarEnvio(mensaje){
		if(not self.sePuedeEnviarElMensaje(mensaje) )
			self.error("No se puede enviar el mensaje al chat")
		else
			self.registrarMensaje(mensaje)
	}
	
	// El emisor del mensaje debe estar entre los participantes del chat
	// además es necesario que cada participante tenga espacio libre suficiente para almacenarlo.
	method sePuedeEnviarElMensaje(mensaje) = self.emisorEsParticipanteDelChat(mensaje) and self.todosLosParticipantesTienenEspacioPara(mensaje)
	
	method registrarMensaje(mensaje){
		self.usuariosRecibenElMensaje(mensaje)
		self.aniadirMensajeAlChat(mensaje)
		
		//Esto es del Punto 5a
		// Al enviar un mensaje a un chat cada participante debe recibir una notificación.
		self.generarNotificacion()
	}
	
	method todosLosParticipantesTienenEspacioPara(mensaje) = participantes.all({ participante => participante.tieneEspacioPara(mensaje)})
	
	method emisorEsParticipanteDelChat(mensaje) = participantes.contains(mensaje.usuarioEmisor())
	
	method usuariosRecibenElMensaje(mensaje){
		participantes.forEach({ participante => participante.guardarMensaje(mensaje,self)})
	}
	
	method aniadirMensajeAlChat(mensaje){
		mensajesEnviados.add(mensaje)
	}
	
	method superaCantidadMensajes(cantidadMaxima) = mensajesEnviados.size() <= cantidadMaxima
	
	// Punto 1
	// Saber el espacio que ocupa un chat, que es la suma de los pesos de los mensajes enviados.
	method espacioQueOcupa() = mensajesEnviados.map({ mensaje => mensaje.pesoTotal() }).sum()
	
	// Punto 3
	// Un chat contiene el texto si tiene algún mensaje con ese texto
	method algunMensajeContiene(texto) = mensajesEnviados.any({mensaje => mensaje.contiene(texto)})
	
	// Punto 4
	method mensajeMasPesado() = mensajesEnviados.map({ mensaje => mensaje.pesoTotal() }).max()
	
	// Punto 5a
	// Al enviar un mensaje a un chat cada participante debe recibir una notificación.
	method generarNotificacion(){
		participantes.forEach({ participante => participante.recibirNotificacion(self)})
	}
}

class Premium inherits Chat {
	// Además de los chats clásicos, se pueden tener chats premium para tener otro control sobre el envío de mensajes. 
	// Además de las restricciones de los chats clásicos, se agrega una restricción adicional
	var restriccion 
	
	//Tanto esta restricción adicional como los integrantes de un chat premium pueden ser modificados en cualquier momento.
	method participantes(listaParticipantes){ 
		participantes = listaParticipantes
	}
	
	override method sePuedeEnviarElMensaje(mensaje) = super(mensaje) and restriccion.seCumple(mensaje,self)
}

/// TIPOS DE RESTRICCIONES /// 
// Difusión: solamente el creador del chat premium puede enviar mensajes.
class Difusion {
	
	var creador
	
	method emisorMensajeEsCreador(mensaje) = creador == mensaje.usuarioEmisor() 
	
	method seCumple(mensaje,_) = self.emisorMensajeEsCreador(mensaje)
}

// Restringido: determina un límite de mensajes que puede tener el chat, una vez llegada a esa cantidad no deja enviar más mensajes.

class Restringido {
	var limiteMensajes
	
	method seCumple(_,chat) = chat.superaCantidadMensajes(limiteMensajes)
}

// Ahorro: todos los integrantes pueden enviar solamente mensajes que no superen un peso máximo determinado.

class Ahorro {
	var pesoMaximo 
	
	method seCumple(mensaje,_) = mensaje.superaPeso(pesoMaximo)
}

