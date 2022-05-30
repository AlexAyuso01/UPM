package db.map;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
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
		String query ="SELECT * FROM jugador;";
		PreparedStatement ps = null;
		try {
			ps = AdministradorConexion.prepareStatement(query);
			ps.execute();
			ResultSet rs = ps.getResultSet();
			while (rs.next()) {
				String nif = rs.getString("nif");
				String nombre = rs.getString("nombre");
				String apellido1 = rs.getString("apellido_1");
				String apellido2 = rs.getString("apellido_2");
				LocalDate fechaNacimiento = rs.getDate("fecha_nacimiento").toLocalDate();
				//selecciono el jugador
				Jugador result = new Jugador(nif, nombre, apellido1, apellido2, fechaNacimiento);
				// lo anado a la lista 
				list.add(result);
			}
			return list;
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			try {
				if (ps!=null && !ps.isClosed())
					ps.close();
					// cierre de la conexion
			} catch (SQLException e1) {
				e1.printStackTrace();
			}				
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
		String query ="SELECT * FROM jugador WHERE id = " + nifJugador + ";";
		PreparedStatement ps = null;
		try {		
		//Inicio de la conexion
		ps = AdministradorConexion.prepareStatement(query);
		ps.executeQuery();
		// datos de la base de datos
		ResultSet rs = ps.getResultSet();
		//get de los datos de la base de datos
		String nif = rs.getString("nif");
		String nombre = rs.getString("nombre");
		String apellido1 = rs.getString("apellido_1");
		String apellido2 = rs.getString("apellido_2");
		LocalDate fechaNacimiento = rs.getDate("fecha_nacimiento").toLocalDate();
		Jugador result = new Jugador(nif, nombre, apellido1, apellido2, fechaNacimiento);
		return result;		
		}
		catch(SQLException e){
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
	}
}
//terminado 