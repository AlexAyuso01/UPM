package db.map;

// import java.sql.Connection;
// import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import db.AdministradorConexion;
import model.CategoriaCompeticion;

public class CategoriaCompeticionBD {
	/**
	 * 
	 * @param categoriaCompeticion
	 * @return Obtiene de la base de datos la categor�a de competici�n con id igual al par�metro categoriaCompeticion, 
	 *    creando un objeto del tipo model.CategoriaCompeticion
	 * @throws SQLException
	 */
	public static CategoriaCompeticion getById(int categoriaCompeticion) {
		// TODO: Implementar	
		CategoriaCompeticion result = null;
		try {	
			Statement st = AdministradorConexion.getStatement();
			ResultSet rs = st.executeQuery("SELECT * FROM categoria_competicion WHERE id = "+categoriaCompeticion);
			Integer id = rs.getInt("id");
			String nombre = rs.getString("nombre");
			String descripcion = rs.getString("descripcion");
			Integer numeroMaxEquipos = rs.getInt("numero_max_equipos");
			result = new CategoriaCompeticion(id, nombre, descripcion, numeroMaxEquipos);
	
			rs.close();
			st.close();	
		} catch (SQLException e) {
			e.printStackTrace();
		}
				
			return result;

	}
}
