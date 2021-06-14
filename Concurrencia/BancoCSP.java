// BancoCSP_skel.java
// Lars feat. Julio -- 2021
// esqueleto de codigo para JCSP
// (peticiones aplazadas)

package cc.banco;

import java.util.HashMap;
import java.util.LinkedList;
import java.util.Map;

import org.jcsp.lang.Alternative;
import org.jcsp.lang.AltingChannelInput;
import org.jcsp.lang.Any2OneChannel;
import org.jcsp.lang.CSProcess;
import org.jcsp.lang.Channel;
import org.jcsp.lang.Guard;
import org.jcsp.lang.One2OneChannel;
import org.jcsp.lang.ProcessManager;




public class BancoCSP implements Banco, CSProcess {

	// canales: uno por operacion
	// seran peticiones aplazadas
	private Any2OneChannel chIngresar;
	private Any2OneChannel chDisponible;
	private Any2OneChannel chTransferir;
	private Any2OneChannel chAlertar; 
	Map<String, Integer> cuentas;
	//TADs para peticiones que se han aplazado y por tratar
	LinkedList<TransferirReq> TransfBlock;
	LinkedList<AlertarReq> AlertarBlock;

	// clases para peticiones
	// regalamos una como ejemplo
	public class TransferirReq {
		// atributos (pueden ser publicos)
		String from;
		String to;
		int value;
		One2OneChannel resp;

		// constructor
		public TransferirReq(String from, String to, int value) {
			this.from = from; 
			this.to = to; 
			this.value = value; 
			this.resp = Channel.one2one();
		}
	}

	public class AlertarReq {
		String cuenta;
		int minimo;
		One2OneChannel resp;

		public AlertarReq(String cuenta, int minimo) {
			this.cuenta=cuenta;
			this.minimo=minimo;
			this.resp = Channel.one2one();
		}
	}	

	public class IngresarReq {
		String cuenta;
		int cantidad;
		One2OneChannel resp;

		public IngresarReq(String cuenta, int cantidad) {
			this.cuenta=cuenta;
			this.cantidad=cantidad;
			this.resp = Channel.one2one();
		}
	}

	public class DisponibleReq {
		String cuenta;
		One2OneChannel resp;
		public DisponibleReq(String cuenta) {
			this.cuenta = cuenta;
			this.resp = Channel.one2one();
		}
	}

	// constructor de BancoCSP
	public BancoCSP() {
		this.chIngresar = Channel.any2one();
		this.chAlertar = Channel.any2one();
		this.chDisponible = Channel.any2one();
		this.chTransferir = Channel.any2one();
		new ProcessManager(this).start();
		cuentas = new HashMap<String, Integer>();
		TransfBlock = new LinkedList<TransferirReq>();
		AlertarBlock = new LinkedList<AlertarReq>();
	}


	public void ingresar(String c, int v) {
		//Creacion de confirmacion + envio por canal correspondiente
		IngresarReq peticion = new IngresarReq(c, v);
		chIngresar.out().write(peticion);
		//Esperar confirmacion
		chIngresar.in().read();
		peticion.resp.in().read();

	}


	public void transferir(String o, String d, int v) {
		// comprobar PRE
		if(!o.equals(d)) {
			//Creacion de confirmacion + envio por canal correspondiente
			TransferirReq peticion = new TransferirReq(o, o, v);
			chTransferir.out().write(peticion);
			//Esperar confirmacion
			chTransferir.in().read();
			peticion.resp.in().read();
		}
		// no cumple PRE
		else {
			throw new IllegalArgumentException("La operacion transferencia tiene que tener como argumentos cuentas distintas");
		}
	}


	public int disponible(String c) {
		//no cumple la CPRE
		if(!cuentas.containsKey(c)) {
			throw new IllegalArgumentException("Cuenta no existe");
		}
		//Creacion de confirmacion + envio por canal correspondiente
		DisponibleReq peticion = new DisponibleReq(c);
		chDisponible.out().write(peticion);
		//Esperar resultado por canal 
		Integer saldo = (Integer) chDisponible.in().read();
		peticion.resp.in().read();
		return (int) saldo;

	}


	public void alertar(String c, int v) {
		//no cumple la CPRE
		if(!cuentas.containsKey(c)) {
			throw new IllegalArgumentException("Cuenta no existe");
		}
		//Creacion de confirmacion + envio por canal correspondiente
		AlertarReq peticion = new AlertarReq(c, v);
		chAlertar.out().write(peticion);
		//Esperar confirmacion
		peticion.resp.in().read();
	}

	// Codigo del servidor
	public void run() {
		// nombres simbolicos para las entradas
		final int INGRESAR   = 0;
		final int DISPONIBLE = 1;
		final int TRANSFERIR = 2;
		final int ALERTAR    = 3;

		// construimos la estructura para recepcion alternativa
		final Guard[] guards = new AltingChannelInput[4];
		guards[INGRESAR]   = chIngresar.in();
		guards[DISPONIBLE] = chDisponible.in();
		guards[TRANSFERIR] = chTransferir.in();
		guards[ALERTAR]    = chAlertar.in();
		Alternative servicios = new Alternative(guards);



		// Bucle principal del servicio
		while(true) {
			int servicio = servicios.fairSelect();

			switch (servicio) {
			case INGRESAR: {
				//Recibir peticion
				IngresarReq pet = (IngresarReq) chIngresar.in().read();
				//CPRE: cuenta esta en banco
				if(!cuentas.containsKey(pet.cuenta) ) {
					//Si no esta se anade
					cuentas.put(pet.cuenta, pet.cantidad);
				}
				else {
					//Cumple CPPRE -> saldo+=cantidad a ingresar
					cuentas.put(pet.cuenta,pet.cantidad + cuentas.get(pet.cuenta));
				}
				desbloqueoGeneral();
				break;
			}
			case DISPONIBLE: {
				DisponibleReq pet = (DisponibleReq) chDisponible.in().read();

				// recibir peticion
				if(cuentas.containsKey(pet.cuenta)) {
					int dinero = 0;
					dinero = cuentas.get(pet.cuenta);	
					pet.resp.out().write(dinero);
				}// COMPLETAD
				// responder
				// COMPLETAD
				break;
			}
			case TRANSFERIR: {
				TransferirReq pet = (TransferirReq) chTransferir.in().read();



				if (!cuentas.containsKey(pet.from) || !cuentas.containsKey(pet.to) || cuentas.get(pet.from) < pet.value) {
					TransfBlock.add(pet);
				}
				else {

					int saldoO = cuentas.get(pet.from);
					int saldoD = cuentas.get(pet.to);
					cuentas.put(pet.from,saldoO - pet.value);
					cuentas.put(pet.to,saldoD + pet.value);
					//Notifico transferencia
					pet.resp.out().write(null);
					desbloqueoGeneral(); //desbloqueo de transferencias
					break;
				}
			}
			case ALERTAR: {
				AlertarReq peticion = (AlertarReq) chAlertar.in().read();
				if(cuentas.get(peticion.cuenta) < peticion.minimo) {
					peticion.resp.out().write(peticion.minimo);
				}
				else { 
					AlertarBlock.add(peticion);
				}
				break;
			}
			}//Fin switch 

			//Tratamiento de peticiones aplazadas si es posible
			desbloqueoGeneral();
			//desbloqueoGeneral(AlertarBlock); // ????

		}
	}


	private  void desbloqueoGeneral() {
		boolean signaled = false;
		LinkedList<String> transfRd = new LinkedList<String>();
		int nt = TransfBlock.size();	
		for(int i = 0; i < nt; i++) {
			TransferirReq bt = TransfBlock.get(i);
			int SaldoO = cuentas.get(bt.from);
			int SaldoD = cuentas.get(bt.to);
			if(cuentas.containsKey(bt.from) && cuentas.containsKey(bt.to) && SaldoO >= bt.value && !tieneCuenta(transfRd,bt.from)) {
				cuentas.put(bt.from, SaldoO - bt.value);
				cuentas.put(bt.to, SaldoD + bt.value);

				TransfBlock.remove(i).resp.out().write(null);
				transfRd = new LinkedList<String>();

				i = -1;
				nt--;
			}
			else if(!tieneCuenta(transfRd, bt.from)) {
				transfRd.addLast(bt.from);
			}
		}
		int na = AlertarBlock.size();

		for(int i = 0; i < na;i++) {
			AlertarReq ba = AlertarBlock.get(i);
			int SaldoO = cuentas.get(ba.cuenta);
			if(SaldoO < ba.minimo) {
				AlertarBlock.remove(i).resp.out().write(null);
				i--;
				na--;
			}
		}
	}


	private boolean tieneCuenta(LinkedList<String> t, String from) {
		boolean signaled = false;
		for(int i = 0; i < t.size() && !signaled; i++ ) {
			if(t.get(i).equals(from)) {
				signaled = !signaled;
			}
		}
		return signaled;
	}

}





