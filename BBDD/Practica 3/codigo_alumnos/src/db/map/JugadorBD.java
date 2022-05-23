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
			ResultSet rs = st.executeQuery("SELECT * FROM categoria_edad" );
			while (rs.next()) {
				Integer nif = rs.getInt("nif");
				String nombre = rs.getString("nombre");
				String apellido1 = rs.getString("apellido_1");
				String apellido2 = rs.getString("apellido_2");
				LocalDate fechaNacimiento = rs.getDate("fecha_nacimiento").toLocalDate();
				Jugador result = new Jugador(nif, nombre, apellido1, apellido2, fechaNacimiento);
				list.add(result);
			}
			rs.close();
			st.close();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return list;
	}
	
	/**
	 * Obtiene de la base de datos el jugador con nif igual al par�metro nifJugador, 
	 *    creando un objeto del tipo model.Jugador
	 * @param nifJugador
	 * @return
	 */
	public static Jugador getById(String nifJugador) {
		// TODO: Implementar
		Jugador result = null;
		try {		
		Statement st = AdministradorConexion.getStatement();
		ResultSet rs = st.executeQuery("SELECT * FROM equipo WHERE id = "+nifJugador);
		
		Integer nif = rs.getInt("nif");
		String nombre = rs.getString("nombre");
		String apellido1 = rs.getString("apellido_1");
		String apellido2 = rs.getString("apellido_2");
		LocalDate fechaNacimiento = rs.getDate("fecha_nacimiento").toLocalDate();
		result = new Jugador(nif, nombre, apellido1, apellido2, fechaNacimiento);

		rs.close();
		st.close();	
		}
		catch(SQLException e){
			e.printStackTrace();
		}
		return result;		
	}
	
}
