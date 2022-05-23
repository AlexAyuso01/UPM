package db.stats;

import java.util.List;

import model.Equipo;
import model.Jugador;

public class Estadisticas {
	/**
	 * M�todo que debe devolver el listado de los jugadores que no han estado en ning�n equipo 
	 * en el a�o recibido como par�metro
	 * @param anio
	 * @return
	 */
	public static List<Jugador> getJugadoresNoHanEstadoEnEquipo(int anio){
		// TODO: Implementar
		
		return null;
	}
	
	/**
	 * M�todo que devuelve el n�mero de equipos del mismo club m�ximo en los que alg�n jugador ha estado
	 * @return
	 */
	public static int getNumeroMaximoEquiposDelMismoClubHaEstadoUnJugador(){
		// TODO: Implementar
		return -1;
	}
	
	/**
	 * M�todo que debe devolver el listado de los jugadores que han estado en el mayor n�mero de equipos
	 * del mismo club 
	 * @return
	 */
	public static List<Jugador> getJugadoresMasEquiposMismoClub(){
		// TODO: Implementar
		return null;
	}

	/**
	 * M�todo que debe devolver el listado de los jugadores que han estado en el equipo recibido como
	 * par�metro el a�o (anio)
	 * @param equipo
	 * @param anio
	 * @return
	 */
	public static List<Jugador> getJugadoresEquipoAnio(Equipo equipo, int anio) {
		// TODO: Implementar
		return null;
	}
}
