package model;

public class CategoriaEdad {
	private int id = -1;
	private String nombre;
	private String descripcion;
	private int edadMinima,edadMaxima;
	
	/**
	 * Constructor que debe ser llamado para objetos que vienen de la base de datos
	 * @param id
	 * @param nombre
	 * @param descripcion
	 * @param edadMinima
	 * @param edadMaxima
	 */
	public CategoriaEdad(int id, String nombre, String descripcion, int edadMinima, int edadMaxima) {
		super();
		this.id = id;
		this.nombre = nombre;
		this.descripcion = descripcion;
		this.edadMinima = edadMinima;
		this.edadMaxima = edadMaxima;
	}
	
	/**
	 * Constructor que debe ser llamado para objetos que se crean nuevos en java (al hacer el insert, la
	 * base de datos le asignará un id), pero hasta entonces su id será -1
	 * @param nombre
	 * @param descripcion
	 * @param edadMinima
	 * @param edadMaxima
	 */
	public CategoriaEdad (String nombre, String descripcion, int edadMinima, int edadMaxima) {
		super();
		this.nombre = nombre;
		this.descripcion = descripcion;
		this.edadMinima = edadMinima;
		this.edadMaxima = edadMaxima;
	}

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getNombre() {
		return nombre;
	}

	public void setNombre(String nombre) {
		this.nombre = nombre;
	}

	public String getDescripcion() {
		return descripcion;
	}

	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}

	public int getEdadMinima() {
		return edadMinima;
	}

	public void setEdadMinima(int edadMinima) {
		this.edadMinima = edadMinima;
	}

	public int getEdadMaxima() {
		return edadMaxima;
	}

	public void setEdadMaxima(int edadMaxima) {
		this.edadMaxima = edadMaxima;
	}

	@Override
	public String toString() {
		return "CategoriaEdad [id=" + id + ", nombre=" + nombre + ", descripcion=" + descripcion + ", edadMinima="
				+ edadMinima + ", edadMaxima=" + edadMaxima + "]";
	}
	
	
	

}
