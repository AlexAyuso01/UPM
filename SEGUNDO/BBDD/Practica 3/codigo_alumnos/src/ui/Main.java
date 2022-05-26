package ui;

import java.util.List;

import db.map.JugadorBD;
import db.map.CategoriaEdadBD;
import db.map.EquipoBD;
import db.stats.Estadisticas;
import model.CategoriaEdad;
import model.Equipo;
import model.Jugador;

public class Main {
	// Prueba la creaci�n, carga y borrado de Categor�as de Edad
	public static void pruebaModificacionCategorias() {
		List<CategoriaEdad> categorias = CategoriaEdadBD.getAll();
		CategoriaEdad ce = new CategoriaEdad("Prueba", "Prueba de creacion", 99, 110);
		categorias.add(ce);
		categorias.get(0).setEdadMinima(-2);
		CategoriaEdadBD.saveAll(categorias);
		CategoriaEdadBD.deleteCategoria(ce);
		categorias.remove(categorias.size()-1);
		categorias.get(0).setEdadMinima(4);
		CategoriaEdadBD.saveAll(categorias);	
		//Si imprime esto es que todo ha ido bien
	}
	
	// Pruebas b�sicas
	// NO MODIFICAR LAS CABECERAS DE NINGUN METODO
	public static void main(String[] args) {
		
		pruebaModificacionCategorias();
		
		System.out.println("\nTEST: TAMANYO LISTA DE JUGADORES");
		List<Jugador> jugadores = JugadorBD.getAll();
		System.out.println(jugadores.size());

		System.out.println("\nTEST: EQUIPO CON ID");
		Equipo e = EquipoBD.getById("104517534");
		System.out.println(e);
		
		System.out.println("\nTEST: JUGADORES JUGANDO EN UN EQUIPO (AÑO)");
		List<Jugador> resJugAnioEq = Estadisticas.getJugadoresEquipoAnio(e, 2021);
		String a = resJugAnioEq.toString();
		String b = "[Jugador [nif=50094645I, nombre=Silverio, apellido1=Bartel, apellido2=Ribot, fechaNacimiento=2008-05-22], Jugador [nif=50154394T, nombre=Juan Lucas, apellido1=Nuñez Cacho, apellido2=Mardaras, fechaNacimiento=2008-03-25], Jugador [nif=50171244C, nombre=Enrique Marcelo, apellido1=Perez Aradros, apellido2=Subtil, fechaNacimiento=2008-08-31], Jugador [nif=50178495Y, nombre=Francesc Ramon, apellido1=Pinel, apellido2=De Faria, fechaNacimiento=2008-10-03], Jugador [nif=50219814V, nombre=Iancu, apellido1=Cocero, apellido2=Telles, fechaNacimiento=2008-04-13], Jugador [nif=50283142U, nombre=Ariel Andres, apellido1=Morant, apellido2=Camesella, fechaNacimiento=2008-09-01], Jugador [nif=50427860E, nombre=Alfonso Joaquin, apellido1=Espildora, apellido2=Ozon, fechaNacimiento=2008-02-08], Jugador [nif=50493770P, nombre=Joaquin Adolfo, apellido1=Berasategi, apellido2=Mijarra, fechaNacimiento=2008-07-11], Jugador [nif=50494880I, nombre=Serigne Mbaye, apellido1=Tejeria, apellido2=Jabbouri, fechaNacimiento=2008-09-04], Jugador [nif=50636763T, nombre=Alexandru Razvan, apellido1=Salagre, apellido2=Jawo, fechaNacimiento=2008-10-21], Jugador [nif=50699699S, nombre=Jesus Enmanuel, apellido1=Gomez Lobo, apellido2=Berbegal, fechaNacimiento=2008-01-28], Jugador [nif=50897775B, nombre=Ayoube, apellido1=Fernandez De Labastida, apellido2=Tuñon, fechaNacimiento=2008-05-29]]";
		if(a.equals(b))	
			System.out.println("OK");

		System.out.println("\nTEST: JUGADORES QUE NO HAN ESTADO EN NINGUN EQUIPO EN FECHA (AÑO)");
		List<Jugador> resNoJugAnio = Estadisticas.getJugadoresNoHanEstadoEnEquipo(2021);
		System.out.println(resNoJugAnio.size());

		System.out.println("\nTEST: NUMERO MAX DE EQUIPOS UN JUGADOR");
		System.out.println(Estadisticas.getNumeroMaximoEquiposDelMismoClubHaEstadoUnJugador());
		
		System.out.println("\nTEST: JUGADORES CON MAX EQUIPOS = 2");
		List<Jugador> resJugMasAnios = Estadisticas.getJugadoresMasEquiposMismoClub();
		System.out.println(resJugMasAnios.size() + "\n");
		
	
	}
}
