package db.map;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

import db.AdministradorConexion;
import model.Jugador;

public class JugadorBD {
	/**
	 * Obtiene de la base de datos todos los jugador, 
	 *    devolviendo una lista de objetos del tipo model.Jugador
	 * @return
	 */
	public static List<Jugador> getAll() {
		List<Jugador> list = new ArrayList<Jugador>();
		try {
			Statement st = AdministradorConexion.getStatement();
			ResultSet rs = st.executeQuery("SELECT * FROM jugador" );
			while (rs.next()) {
				Integer nif = rs.getInt("nif");
				String nombre = rs.getString("nombre");
				String apellido1 = rs.getString("apellido_1");
				String apellido2 = rs.getString("apellido_2");
				LocalDate fechaNacimiento = rs.getDate("fecha_nacimiento").toLocalDate();
				//selecciono el jugador
				Jugador result = new Jugador(nif, nombre, apellido1, apellido2, fechaNacimiento);
				// lo anado a la lista de
				list.add(result);
			}
			rs.close();
			st.close();
			return list;
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return null;
		}
		
	}
	
	/**
	 * Obtiene de la base de datos el jugador con nif igual al par�metro nifJugador, 
	 *    creando un objeto del tipo model.Jugador
	 * @param nifJugador
	 * @return
	 */
	public static Jugador getById(String nifJugador) {
		// TODO: Implementar
		
		try {		
		Statement st = AdministradorConexion.getStatement();
		ResultSet rs = st.executeQuery("SELECT * FROM equipo WHERE id = "+nifJugador);
		
		Integer nif = rs.getInt("nif");
		String nombre = rs.getString("nombre");
		String apellido1 = rs.getString("apellido_1");
		String apellido2 = rs.getString("apellido_2");
		LocalDate fechaNacimiento = rs.getDate("fecha_nacimiento").toLocalDate();
		Jugador result = new Jugador(nif, nombre, apellido1, apellido2, fechaNacimiento);

		rs.close();
		st.close();	
		return result;		
		}
		catch(SQLException e){
			e.printStackTrace();
			return null;		
		}
		
	}
	
}
