package ui;

import java.util.List;

import db.map.CategoriaEdadBD;
import db.map.EquipoBD;
import db.map.JugadorBD;
import db.stats.Estadisticas;
import model.CategoriaEdad;
import model.Equipo;
import model.Jugador;

public class Main {
	// Prueba la creación, carga y borrado de Categorías de Edad
	public static void pruebaModificacionCategorias() {
		List<CategoriaEdad> categorias = CategoriaEdadBD.getAll();
		CategoriaEdad ce = new CategoriaEdad("Prueba", "Prueba de creación", 99, 110);
		categorias.add(ce);
		categorias.get(0).setEdadMinima(-2);
		CategoriaEdadBD.saveAll(categorias);
		System.out.println(categorias);
		
		CategoriaEdadBD.deleteCategoria(ce);
		categorias.remove(categorias.size()-1);
		categorias.get(0).setEdadMinima(4);
		CategoriaEdadBD.saveAll(categorias);
		System.out.println(categorias);
		
		
	}
	
	// Pruebas básicas
	// NO MODIFICAR LAS CABECERAS DE NINGUN METODO
	public static void main(String[] args) {
		
		pruebaModificacionCategorias();
		
		List<Jugador> jugadores = JugadorBD.getAll();
		System.out.println(jugadores.size());
		Equipo e = EquipoBD.getById("104517534");
		System.out.println(e);
		
		List<Jugador> resJugAnioEq = Estadisticas.getJugadoresEquipoAnio(e, 2021);
		System.out.println(resJugAnioEq);
		
		List<Jugador> resNoJugAnio = Estadisticas.getJugadoresNoHanEstadoEnEquipo(2021);
		System.out.println(resNoJugAnio.size());
		
		System.out.println(Estadisticas.getNumeroMaximoEquiposDelMismoClubHaEstadoUnJugador());
		
		List<Jugador> resJugMasAnios = Estadisticas.getJugadoresMasEquiposMismoClub();
		System.out.println(resJugMasAnios.size());
		
	
	}
}
