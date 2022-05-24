package db.stats;

import java.sql.SQLException;
import java.sql.Statement;
import java.time.LocalDate;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import db.AdministradorConexion;
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
		List<Jugador> list = new ArrayList<Jugador>();
		try{
			Statement st = AdministradorConexion.getStatement();
			ResultSet rs = st.executeQuery("SELECT * FROM jugador WHERE nif IN (SELECT nif_jugador FROM jugador_milita_equipo WHERE fecha_inicio > cast('"+anio+"-12-12' AS date) || fecha_fin < cast('"+anio+"-00-00' AS date))");
			while (rs.next()){
				Integer nif = rs.getInt("nif");
				String nombre = rs.getString("nombre");
				String apellido1 = rs.getString("apellido1");
				String apellido2 = rs.getString("apellido2");
				LocalDate fechaNacimiento = rs.getDate("fechaNacimiento").toLocalDate();
				//Creamos jugador 
				Jugador jugador = new Jugador(nif, nombre, apellido1, apellido2, fechaNacimiento);
				//anadimos a la lista
				list.add(jugador);
			}
			rs.close();
			st.close();
			return list;
		}catch(SQLException e){
			e.printStackTrace();
			return null;
		}
		
	}
	
	/**
	 * M�todo que devuelve el n�mero de equipos del mismo club m�ximo en los que alg�n jugador ha estado
	 * @return
	 */
	public static int getNumeroMaximoEquiposDelMismoClubHaEstadoUnJugador(){
		int max = 0;
		try {
			Statement st = AdministradorConexion.getStatement();
			// ResultSet rs = st.executeQuery("SELECT * FROM jugador WHERE nif IN( SELECT * FROM jugador_milita_equipo WHERE licencia_equipo IN (SELECT * FROM equipo))");
			ResultSet rs = st.executeQuery("SELECT nif_jugador, nombre_club, licencia_equipo FROM jugador_milita_equipo LEFT JOIN equipo ON jugador_milita_equipo.licencia_equipo = equipo.licencia UNION SELECT nif_jugador, nombre_club, licencia_equipo FROM jugador_milita_equipo RIGHT JOIN equipo ON jugador_milita_equipo.licencia_equipo = equipo.licencia; ");
			Map<String, Integer> map = new HashMap<String,Integer>();
			
			while (rs.next()) {
				String nif = rs.getString("nif_jugador");
				String club = rs.getString("nombre_club");
				String key = nif+club;
				if(!map.containsKey(key))
					map.put(key, 1);
				else
					map.put(key, map.get(key)+1);
			}
			for (String k : map.keySet()){
				if (map.get(k) > max){
					max = map.get(k);
				}
			}
			return max;
		} catch (SQLException e) {
			e.printStackTrace();
			return -1;
		}
	}
	
	/**
	 * M�todo que debe devolver el listado de los jugadores que han estado en el mayor n�mero de equipos
	 * del mismo club 
	 * @return
	 */
	public static List<Jugador> getJugadoresMasEquiposMismoClub(){
		int max = 0;
		try {
			Statement st = AdministradorConexion.getStatement();
			//ResultSet rs = st.executeQuery("SELECT * FROM jugador INNER JOIN jugador_milita_equipo ON jugador.nif = jugador_milita_equipo.nif_jugador;");
			ResultSet rs = st.executeQuery("SELECT nif_jugador, nombre_club, licencia_equipo FROM jugador_milita_equipo LEFT JOIN equipo ON jugador_milita_equipo.licencia_equipo = equipo.licencia UNION SELECT nif_jugador, nombre_club, licencia_equipo FROM jugador_milita_equipo RIGHT JOIN equipo ON jugador_milita_equipo.licencia_equipo = equipo.licencia; ");
			ResultSet rs2 = null;
			Map<String, Integer> map = new HashMap<String,Integer>();
			List<Jugador> jugs = new ArrayList<Jugador>();

			while (rs.next()) {
				String nif = rs.getString("nif_jugador");
				String club = rs.getString("nombre_club");
				String key = nif+club;
				if(!map.containsKey(key))
					map.put(key, 1);
				else
					map.put(key, map.get(key)+1);
			}

			for (String k : map.keySet()){
				if (map.get(k) > max){
					max = map.get(k);
				}
			}	

			for (String k : map.keySet()){
				if (map.get(k) == max){
					String nif = k.substring(0,8);
					rs2 = st.executeQuery("SELECT * FROM jugador WHERE nif ="+ nif );
					Integer dni = rs2.getInt("nif");
					String nombre = rs2.getString("nombre");
					String apellido1 = rs2.getString("apellido_1");
					String apellido2 = rs2.getString("apellido_2");
					LocalDate fechaNacimiento = rs2.getDate("fecha_nacimiento").toLocalDate();
					//selecciono el jugador
					Jugador jugador = new Jugador(dni, nombre, apellido1, apellido2, fechaNacimiento);
					jugs.add(jugador);
				}
			}
			rs.close();
			rs2.close();
			st.close();
			return jugs;	
		} catch (SQLException e) {
			e.printStackTrace();
			return null;
		}
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
		List<Jugador> list = new ArrayList<Jugador>();
		try {
			Statement st = AdministradorConexion.getStatement();
			ResultSet rs = st.executeQuery("SELECT * FROM jugador WHERE nif IN (SELECT nif_jugador FROM jugador_milita_equipo WHERE licencia_equipo = "+equipo.getLicencia()+" && (fecha_inicio <= cast('"+anio+"-12-12' AS date) || fecha_fin >= cast('"+anio+"-00-00' AS date)))");
			while(rs.next()){
				Integer nif = rs.getInt("nif");
				String nombre = rs.getString("nombre");
				String apellido1 = rs.getString("apellido1");
				String apellido2 = rs.getString("apellido2");
				LocalDate fechaNacimiento = rs.getDate("fechaNacimiento").toLocalDate();
				//Creamos jugador 
				Jugador jugador = new Jugador(nif, nombre, apellido1, apellido2, fechaNacimiento);
				//anadimos a la lista
				list.add(jugador);
			}			
		} catch (SQLException e) {
			e.printStackTrace();
			return null;
		}		
		return list;
	}
}
