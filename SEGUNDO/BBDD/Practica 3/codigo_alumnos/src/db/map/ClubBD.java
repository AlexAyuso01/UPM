package db.map;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import db.AdministradorConexion;
import model.Club;

public class ClubBD {
	/**
	 * Obtiene de la base de datos el club con nombre igual al par�metro nombreClub, 
	 *    creando un objeto del tipo model.Club
	 * @param nombreClub
	 * @return
	 */
	public static Club getById(String nombreClub) {
		// TODO: Implementar
		String query = "SELECT * FROM club WHERE nombre = "+nombreClub+";";	
		PreparedStatement ps = null;	
		try {	
			//Inicio de la conexion
			ps = AdministradorConexion.prepareStatement(query);
			ps.execute();
			// campos de la base de datos 
			ResultSet rs = ps.getResultSet();
			//get de los datos
			Club result = null;
			if(rs.next()){
				String nombre = rs.getString("nombre");
				String calle = rs.getString("calle");
				Integer numero = rs.getInt("numero");
				Integer piso = rs.getInt("piso");
				Integer escalera = rs.getInt("escalera");
				Integer cp = rs.getInt("cp");
				String localidad = rs.getString("localidad");
				String telefono = rs.getString("telefono");
				String personaContacto = rs.getString("persona_contacto");
				result = new Club(nombre, calle, numero, piso, escalera, cp, localidad, telefono, personaContacto);
			}
			return result;
		} catch (SQLException e) {
			e.printStackTrace();
			try {
				if (ps!=null && !ps.isClosed())
					ps.close();
					//cierre de la conexion
			} catch (SQLException e1) {
				e1.printStackTrace();
			}
			return null;
		}				
	}
}
