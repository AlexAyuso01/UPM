package db.map;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

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
		String query = "SELECT * FROM equipo WHERE licencia = "+licenciaEquipo+";";
		PreparedStatement ps = null;
		Equipo result = null;
		try {	
			//inicion coexion 	
			ps = AdministradorConexion.prepareStatement(query);
			ps.execute();
			// datos de la base de datos
			ResultSet rs = ps.getResultSet();
			//get de esos datos
			if (rs.next()) {
				Integer licencia = rs.getInt("licencia");
				String nombre = rs.getString("nombre");
				Integer telefono = rs.getInt("telefono");
				String nombre_club = rs.getString("nombre_club");
				Integer categoriaEdad = rs.getInt("id_categoria_edad");
				Integer categoriaCompeticion = rs.getInt("id_categoria_competicion");
				result = new Equipo(licencia, nombre, telefono, nombre_club, categoriaEdad, categoriaCompeticion);
				
			}
			return result;
		}
		catch(SQLException e){
			e.printStackTrace();
			try {
				if (ps!=null && !ps.isClosed())
					ps.close();
					//cierre de la conexion
			} catch (SQLException e1) {
				e1.printStackTrace();
			}			
			return result;
		}
		
	}
	
}
