package db.stats;

import java.util.List;

import model.Equipo;
import model.Jugador;

public class Estadisticas {
	/**
	 * Método que debe devolver el listado de los jugadores que no han estado en ningún equipo 
	 * en el año recibido como parámetro
	 * @param anio
	 * @return
	 */
	public static List<Jugador> getJugadoresNoHanEstadoEnEquipo(int anio){
		// TODO: Implementar
		return null;
	}
	
	/**
	 * Método que devuelve el número de equipos del mismo club máximo en los que algún jugador ha estado
	 * @return
	 */
	public static int getNumeroMaximoEquiposDelMismoClubHaEstadoUnJugador(){
		// TODO: Implementar
		return -1;
	}
	
	/**
	 * Método que debe devolver el listado de los jugadores que han estado en el mayor número de equipos
	 * del mismo club 
	 * @return
	 */
	public static List<Jugador> getJugadoresMasEquiposMismoClub(){
		// TODO: Implementar
		return null;
	}

	/**
	 * Método que debe devolver el listado de los jugadores que han estado en el equipo recibido como
	 * parámetro el año (anio)
	 * @param equipo
	 * @param anio
	 * @return
	 */
	public static List<Jugador> getJugadoresEquipoAnio(Equipo equipo, int anio) {
		// TODO: Implementar
		return null;
	}
}
