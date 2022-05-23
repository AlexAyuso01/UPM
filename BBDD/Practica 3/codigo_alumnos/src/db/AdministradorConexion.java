package db;

import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.Statement;

public class AdministradorConexion {
	private static String server = "127.0.0.1", schema = "balonmano", user = "aplicacion", password = "aplicacion", port = "3306"; 
	
	private static Conexion conn = null;
	
	private static void openConnection() {
		if (conn == null)
			conn = new Conexion(server, schema, port, user, password);
	}

	public static Statement getStatement() throws SQLException {
		openConnection();
		return conn.getStatement();
	}
	
	public static PreparedStatement prepareStatement(String sqlQuery) throws SQLException {
		openConnection();
		return conn.prepareStatement(sqlQuery);
	}
	
	

}