package db.map;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import db.AdministradorConexion;
import model.Equipo;

public class EquipoBD {
	/**
	 * Obtiene de la base de datos el equipo con licencia igual al par�metro licenciaEquipo, 
	 *    creando un objeto del tipo model.Equipo
	 * @param licenciaEquipo
	 * @return
	 */
	public static Equipo getById(String licenciaEquipo){
		// TODO: Implementar
		Equipo result = null;
		try {		
		Statement st = AdministradorConexion.getStatement();
		ResultSet rs = st.executeQuery("SELECT * FROM equipo WHERE id = "+licenciaEquipo);
		
		Integer licencia = rs.getInt("licencia");
		String nombre = rs.getString("nombre");
		Integer telefono = rs.getInt("telefono");
		String nombre_club = rs.getString("nombre_club");
		Integer categoriaEdad = rs.getInt("id_categoria_edad");
		Integer categoriaCompeticion = rs.getInt("id_categoria_competicion");
		result = new Equipo(licencia, nombre, telefono, nombre_club, categoriaEdad, categoriaCompeticion);

		rs.close();
		st.close();	
		}
		catch(SQLException e){
			e.printStackTrace();
		}
		return result;

	}
	
}
