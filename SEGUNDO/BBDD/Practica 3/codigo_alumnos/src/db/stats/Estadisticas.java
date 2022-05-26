package db.stats;

import java.sql.SQLException;
import java.time.LocalDate;
import java.sql.PreparedStatement;
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
		String query = "SELECT * FROM jugador WHERE nif IN (SELECT nif_jugador FROM jugador_milita_equipo WHERE fecha_inicio > cast('"+anio+"-12-12' AS date) || fecha_fin < cast('"+anio+"-00-00' AS date))"+";";
		PreparedStatement ps = null;
		try{
			ps = AdministradorConexion.prepareStatement(query);
			ps.execute();
			ResultSet rs = ps.getResultSet();
			while (rs.next()){
				String nif = rs.getString("nif");
				String nombre = rs.getString("nombre");
				String apellido1 = rs.getString("apellido1");
				String apellido2 = rs.getString("apellido2");
				LocalDate fechaNacimiento = rs.getDate("fechaNacimiento").toLocalDate();
				//Creamos jugador 
				Jugador jugador = new Jugador(nif, nombre, apellido1, apellido2, fechaNacimiento);
				//anadimos a la lista
				list.add(jugador);
			}
			return list;
		}catch(SQLException e){
			e.printStackTrace();
			try {
				if( ps != null && !ps.isClosed()){
					ps.close();
				}
			} catch(SQLException e1){
				e1.printStackTrace();
			}
			return null;
		}
		
	}
	
	/**
	 * M�todo que devuelve el n�mero de equipos del mismo club m�ximo en los que alg�n jugador ha estado
	 * @return
	 */
	public static int getNumeroMaximoEquiposDelMismoClubHaEstadoUnJugador(){
		int max = 0;
		String query = "SELECT nif_jugador, nombre_club, licencia_equipo FROM jugador_milita_equipo LEFT JOIN equipo ON jugador_milita_equipo.licencia_equipo = equipo.licencia UNION SELECT nif_jugador, nombre_club, licencia_equipo FROM jugador_milita_equipo RIGHT JOIN equipo ON jugador_milita_equipo.licencia_equipo = equipo.licencia; ";
		PreparedStatement ps = null;
		try {
			ps = AdministradorConexion.prepareStatement(query);
			ps.execute();
			ResultSet rs = ps.getResultSet();
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
			try{
				if(ps!=null && !ps.isClosed()){
					ps.close();
				}
			} catch (SQLException e1) {
				e1.printStackTrace();
			}
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
		String query = "SELECT nif_jugador, nombre_club, licencia_equipo FROM jugador_milita_equipo LEFT JOIN equipo ON jugador_milita_equipo.licencia_equipo = equipo.licencia UNION SELECT nif_jugador, nombre_club, licencia_equipo FROM jugador_milita_equipo RIGHT JOIN equipo ON jugador_milita_equipo.licencia_equipo = equipo.licencia; ";
		PreparedStatement ps = null, ps2 = null;
		List<Jugador> jugs = new ArrayList<Jugador>();
		try {
			ps = AdministradorConexion.prepareStatement(query);
			ps.execute();
			ResultSet rs = ps.getResultSet();
			
			ResultSet rs2 = null;
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

			for (String k : map.keySet()){
				if (map.get(k) == max){
					String nif = k.substring(0,8);
					String query2 = "SELECT * FROM jugador WHERE nif ="+ nif + ";";
					ps2 = AdministradorConexion.prepareStatement(query2);
					ps2.execute();
					rs2 = ps2.getResultSet();
					String nif1 = rs.getString("nif");
					String nombre = rs2.getString("nombre");
					String apellido1 = rs2.getString("apellido_1");
					String apellido2 = rs2.getString("apellido_2");
					LocalDate fechaNacimiento = rs2.getDate("fecha_nacimiento").toLocalDate();
					//selecciono el jugador
					Jugador jugador = new Jugador(nif1, nombre, apellido1, apellido2, fechaNacimiento);
					jugs.add(jugador);
				}
			}	
		} catch (SQLException e) {
			e.printStackTrace();
			try {
				if(ps!=null && !ps.isClosed()){
					ps.close();
					// cierre de la conexion
				} 
			} catch(SQLException e1) {
				e1.printStackTrace();
			}
			return null;
		}
		return jugs;
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
		String query = "SELECT * FROM jugador WHERE nif IN (SELECT nif_jugador FROM jugador_milita_equipo WHERE licencia_equipo = "+equipo.getLicencia()+" && (fecha_inicio <= cast('"+anio+"-12-12' AS date) || fecha_fin >= cast('"+anio+"-00-00' AS date)))";
		PreparedStatement ps = null;
		try {
			ps = AdministradorConexion.prepareStatement(query);
			ps.execute();
			ResultSet rs = ps.getResultSet();
			while(rs.next()){
				String nif = rs.getString("nif");
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
			try {
				if(ps!=null && !ps.isClosed()){
					ps.close();
					// cierre de la conexion
				} 
			} catch(SQLException e1) {
				e1.printStackTrace();
			}
			return null;
		}		
		return list;
	}
}
