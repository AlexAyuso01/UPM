package model;

public class Club {
	private String nombre, calle, localidad, telefono, personaContacto;
	private int numero, piso, escalera, cp;
	
	public Club(String nombre, String calle, int numero,
			int piso, int escalera, int cp,
			String localidad, String telefono, String personaContacto) {
		super();
		this.nombre = nombre;
		this.calle = calle;
		this.localidad = localidad;
		this.telefono = telefono;
		this.personaContacto = personaContacto;
		this.numero = numero;
		this.piso = piso;
		this.escalera = escalera;
		this.cp = cp;
	}

	public String getNombre() {
		return nombre;
	}

	public void setNombre(String nombre) {
		this.nombre = nombre;
	}

	public String getCalle() {
		return calle;
	}

	public void setCalle(String calle) {
		this.calle = calle;
	}

	public String getLocalidad() {
		return localidad;
	}

	public void setLocalidad(String localidad) {
		this.localidad = localidad;
	}

	public String getTelefono() {
		return telefono;
	}

	public void setTelefono(String telefono) {
		this.telefono = telefono;
	}

	public String getPersonaContacto() {
		return personaContacto;
	}

	public void setPersonaContacto(String personaContacto) {
		this.personaContacto = personaContacto;
	}

	public int getNumero() {
		return numero;
	}

	public void setNumero(int numero) {
		this.numero = numero;
	}

	public int getPiso() {
		return piso;
	}

	public void setPiso(int piso) {
		this.piso = piso;
	}

	public int getEscalera() {
		return escalera;
	}

	public void setEscalera(int escalera) {
		this.escalera = escalera;
	}

	public int getCp() {
		return cp;
	}

	public void setCp(int cp) {
		this.cp = cp;
	}

	@Override
	public String toString() {
		return "Club [nombre=" + nombre + ", calle=" + calle + ", localidad=" + localidad + ", telefono=" + telefono
				+ ", personaContacto=" + personaContacto + ", numero=" + numero + ", piso=" + piso + ", escalera="
				+ escalera + ", cp=" + cp + "]";
	}
	
	
}
