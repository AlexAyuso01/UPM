package model;

public class CategoriaCompeticion {
	private int id = -1;
	private String nombre;
	private String descripcion;
	private int numeroMaxEquipos;
	
	public CategoriaCompeticion(int id, String nombre, String descripcion, int numeroMaxEquipos) {
		super();
		this.id = id;
		this.nombre = nombre;
		this.descripcion = descripcion;
		this.numeroMaxEquipos = numeroMaxEquipos;
	}
	
	public CategoriaCompeticion (String nombre, String descripcion, int numeroMaxEquipos) {
		super();
		this.nombre = nombre;
		this.descripcion = descripcion;
		this.numeroMaxEquipos = numeroMaxEquipos;
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

	public int getNumeroMaxEquipos() {
		return numeroMaxEquipos;
	}

	public void setNumeroMaxEquipos(int numeroMaxEquipos) {
		this.numeroMaxEquipos = numeroMaxEquipos;
	}

	@Override
	public String toString() {
		return "CategoriaEdad [id=" + id + ", nombre=" + nombre + ", descripcion=" + descripcion + ", numeroMaxEquipos="
				+ numeroMaxEquipos + "]";
	}
	
	
	

}
