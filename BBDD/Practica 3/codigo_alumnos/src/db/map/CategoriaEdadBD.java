package db.map;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import db.AdministradorConexion;
import model.CategoriaEdad;

public class CategoriaEdadBD {
	/**
	 * Obtiene de la base de datos todas las categor�a de edad devolviendo una lista de objetos CategoriaEdad 
	 * @return
	 * @throws SQLException
	 */
	public static List<CategoriaEdad> getAll(){
		// TODO: Implementar
		List<CategoriaEdad> list = new ArrayList<CategoriaEdad>();
		try {
			Statement st = AdministradorConexion.getStatement();
			ResultSet rs = st.executeQuery("SELECT * FROM categoria_edad" );
			while (rs.next()) {
				Integer id = rs.getInt("id");
				String nombre = rs.getString("nombre");
				String descripcion = rs.getString("descripcion");
				Integer edadMinima = rs.getInt("edad_minima");
				Integer edadMaxima = rs.getInt("edad_maxima");
				CategoriaEdad result = new CategoriaEdad(id, nombre, descripcion, edadMinima, edadMaxima);
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
	 * 
	 * @param categoriaEdad
	 * @return Obtiene de la base de datos la categor�a de edad con id igual al par�metro categoriaEdad, 
	 *    creando un objeto del tipo model.CategoriaEdad
	 */
	public static CategoriaEdad getById(int categoriaEdad) {
		// TODO: Implementar
		CategoriaEdad result = null;
		try{
			Statement st = AdministradorConexion.getStatement();
			ResultSet rs = st.executeQuery("SELECT * FROM categoria_edad WHERE id = "+categoriaEdad);
		
			Integer id = rs.getInt("id");
			String nombre = rs.getString("nombre");
			String descripcion = rs.getString("descripcion");
			Integer edad_minima = rs.getInt("edad_minima");
			Integer edad_maxima = rs.getInt("edad_maxima");
			result = new CategoriaEdad(id, nombre, descripcion, edad_minima, edad_maxima);

			rs.close();
			st.close();	

		} catch (SQLException e) {
			e.printStackTrace();
		}	
		return result;
	}

	/**
	 * 
	 * @param ce
	 * @return Borra de la base de datos la categor�a de edad con id igual al identificador del objeto ce
	 */
	public static boolean deleteCategoria(CategoriaEdad ce){
		// TODO: Implementar	
		boolean result = false;	
		try {
		Statement st = AdministradorConexion.getStatement();
		ResultSet rs = st.executeQuery("DROP * FROM categoria_edad WHERE id = "+ce.getId());

		if (!getAll().contains(ce))
			result = true;

		rs.close();
		st.close();	
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return result;
	}
	
	/**
	 * Este m�todo guarda en la base de datos (actualiza o crea) los objetos del tipo CategoriaEdad que recibe en
	 * la lista data
	 * Si el objeto CategoriaEdad tiene id igual a -1 (se ha creado en Java) se realiza un insert y se actualiza el
	 * id en el objeto
	 * Si el objeto tiene id (se ha recuperado de la bbdd) se hace un update
	 * @param data
	 */
	public static void saveAll(List<CategoriaEdad> data) {
		String queryInsert = "INSERT INTO categoria_edad (nombre, descripcion, edad_minima, edad_maxima) VALUES (?,?,?,?); " ;
		String queryUpdate = "UPDATE categoria_edad SET nombre=?, descripcion=?, edad_minima=?, edad_maxima=? WHERE id=?; " ;
		PreparedStatement psInsert = null, psUpdate = null;
		try {
			psInsert = AdministradorConexion.prepareStatement(queryInsert);
			psUpdate = AdministradorConexion.prepareStatement(queryUpdate);
			for (CategoriaEdad ce : data) {
				if (ce.getId()<0) {
					psInsert.setString(1, ce.getNombre());
					psInsert.setString(2, ce.getDescripcion());
					psInsert.setInt(3, ce.getEdadMinima());
					psInsert.setInt(4, ce.getEdadMaxima());
					//boolean done = 
					psInsert.execute();	
					ResultSet rs = psInsert.getGeneratedKeys();
					if (rs.next()) {
					  int newId = rs.getInt(1);
					  ce.setId(newId);
					}
				}
				else {
					psUpdate.setString(1, ce.getNombre());
					psUpdate.setString(2, ce.getDescripcion());
					psUpdate.setInt(3, ce.getEdadMinima());
					psUpdate.setInt(4, ce.getEdadMaxima());
					psUpdate.setInt(5, ce.getId());
					//boolean done = 
					psUpdate.execute();
				}
			}
			
		} catch (SQLException e) {
			e.printStackTrace();
			try {
				if (psInsert!=null && !psInsert.isClosed())
					psInsert.close();
				if (psUpdate!=null && !psUpdate.isClosed())
					psUpdate.close();
					
			} catch (SQLException e1) {
				e1.printStackTrace();
			}
		}
		
	}
}
