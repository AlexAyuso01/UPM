package db.map;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

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
		Club result = null;	
		try {		
			Statement st = AdministradorConexion.getStatement();
			ResultSet rs = st.executeQuery("SELECT * FROM club WHERE id = "+nombreClub);
			
			String nombre = rs.getString("nombre");
			String calle = rs.getString("calle");
			Integer numero = rs.getInt("numero");
			Integer piso = rs.getInt("piso");
			Integer escalera = rs.getInt("escalera");
			Integer cp = rs.getInt("cp");
			String localidad = rs.getString("localidad");
			String telefono = rs.getString("telefono");
			String personaContacto = rs.getString("persona_contacto");

			result =new Club(nombre, calle, numero, piso, escalera, cp, localidad, telefono, personaContacto);

			rs.close();
			st.close();	
		} catch (SQLException e) {
			e.printStackTrace();
		}	
			return result;
	}
	
}
