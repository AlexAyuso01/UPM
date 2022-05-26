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
		
		for(CategoriaEdad categoriaEdad : categorias) {
			System.out.println(categoriaEdad.toString());
		}

		System.out.println();

		categorias.remove(categorias.size()-1);
		categorias.get(0).setEdadMinima(4);
		
		for(CategoriaEdad categoriaEdad : categorias) {
			System.out.println(categoriaEdad.toString());
		}
		System.out.println();

		CategoriaEdadBD.saveAll(categorias);		
	}
	
	// Pruebas b�sicas
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
