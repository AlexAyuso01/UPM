package model;

import db.map.CategoriaCompeticionBD;
import db.map.CategoriaEdadBD;
import db.map.ClubBD;

public class Equipo {
	private String licencia, nombre;
	private int telefono;
	private Club club;
	private CategoriaEdad categoriaEdad;
	private CategoriaCompeticion categoriaCompeticion;
	public Equipo(String licencia, String nombre, int telefono, String nombreClub, int categoriaEdad,
			int categoriaCompeticion) {
		super();
		this.licencia = licencia;
		this.nombre = nombre;
		this.telefono = telefono;
		this.club = ClubBD.getById(nombreClub);
		this.categoriaEdad = CategoriaEdadBD.getById(categoriaEdad);
		this.categoriaCompeticion = CategoriaCompeticionBD.getById(categoriaCompeticion);
	}
	public String getLicencia() {
		return licencia;
	}
	public void setLicencia(String licencia) {
		this.licencia = licencia;
	}
	public String getNombre() {
		return nombre;
	}
	public void setNombre(String nombre) {
		this.nombre = nombre;
	}
	public int getTelefono() {
		return telefono;
	}
	public void setTelefono(int telefono) {
		this.telefono = telefono;
	}
	public Club getClub() {
		return club;
	}
	public void setClub(Club club) {
		this.club = club;
	}
	public CategoriaEdad getCategoriaEdad() {
		return categoriaEdad;
	}
	public void setCategoriaEdad(CategoriaEdad categoriaEdad) {
		this.categoriaEdad = categoriaEdad;
	}
	public CategoriaCompeticion getCategoriaCompeticion() {
		return categoriaCompeticion;
	}
	public void setCategoriaCompeticion(CategoriaCompeticion categoriaCompeticion) {
		this.categoriaCompeticion = categoriaCompeticion;
	}
	@Override
	public String toString() {
		return "Equipo [licencia=" + licencia + ", nombre=" + nombre + ", telefono=" + telefono + ", club=" + club.getNombre()
				+ ", categoriaEdad=" + categoriaEdad.getNombre() + ", categoriaCompeticion=" + categoriaCompeticion.getNombre() + "]";
	}
	
	
	
}
