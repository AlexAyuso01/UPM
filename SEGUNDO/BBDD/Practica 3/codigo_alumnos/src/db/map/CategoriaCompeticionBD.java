package db.map;

import java.sql.PreparedStatement;
// import java.sql.Connection;
// import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;

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
		String query = "SELECT * FROM categoria_competicion WHERE id = "+ categoriaCompeticion + ";" ;
		PreparedStatement ps = null;
		CategoriaCompeticion result = null;
		try {
			ps = AdministradorConexion.prepareStatement(query);
			ps.execute();

			ResultSet rs = ps.getResultSet();
			if(rs.next()) {
				Integer id = rs.getInt("id");
				String nombre = rs.getString("nombre");
				String descripcion = rs.getString("descripcion");
				Integer numeroMaxEquipos = rs.getInt("numero_max_equipos");
				result = new CategoriaCompeticion(id, nombre, descripcion, numeroMaxEquipos);
			}
			return result;
		} catch (SQLException e) {
			e.printStackTrace();
			try {
				if (ps!=null && !ps.isClosed())
					ps.close();
			} catch (SQLException e1) {
				e1.printStackTrace();
			}
			return null;
		}
	}
}
