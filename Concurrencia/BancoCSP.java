// BancoCSP_skel.java
// Lars feat. Julio -- 2021
// esqueleto de codigo para JCSP
// (peticiones aplazadas)

package cc.banco;

import java.util.HashMap;
import java.util.LinkedList;
import java.util.Map;
import java.util.Map.Entry;

import org.jcsp.lang.Alternative;
import org.jcsp.lang.AltingChannelInput;
import org.jcsp.lang.Any2OneChannel;
import org.jcsp.lang.CSProcess;
import org.jcsp.lang.Channel;
import org.jcsp.lang.Guard;
import org.jcsp.lang.One2OneChannel;
import org.jcsp.lang.ProcessManager;

import cc.banco.BancoMonitor.bloqueoTransf;




public class BancoCSP implements Banco, CSProcess {

	// canales: uno por operacion
	// seran peticiones aplazadas
	private Any2OneChannel chIngresar;
	private Any2OneChannel chDisponible;
	private Any2OneChannel chTransferir;
	private Any2OneChannel chAlertar; 
	
	Map<String, Integer> cuentas;
	//TADs para peticiones que se han aplazado y por tratar
	Map<String,LinkedList<TransferirReq>> TransfBlock = new HashMap<>();
	Map<String,LinkedList<AlertarReq>> AlertasBlock = new HashMap<>();

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

	}


	public void ingresar(String c, int v) {
		//Creacion de confirmacion + envio por canal correspondiente
		IngresarReq peticion = new IngresarReq(c, v);
		chIngresar.out().write(peticion); // envia la peticion

	}


	public void transferir(String o, String d, int v) {
		// comprobar PRE
		if(!o.equals(d)) {
			//Creacion de confirmacion + envio por canal correspondiente
			TransferirReq peticion = new TransferirReq(o, o, v);
			chTransferir.out().write(peticion);
			//Esperar confirmacion
			chTransferir.in().read();
			//peticion.resp.in().read();
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
		//peticion.resp.in().read();
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
		Integer resp = (Integer)peticion.resp.in().read();
		// tratar respuesta del servidor
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
				String newAcc = pet.cuenta;
				Integer dinerot = pet.cantidad;
				
				//CPRE: cuenta esta en banco
				if(!cuentas.containsKey(pet.cuenta) ) {
					//Si no esta se anade
					cuentas.put(newAcc, dinerot);
					if(!TransfBlock.containsKey(newAcc)) {
						TransfBlock.put(newAcc, new LinkedList<TransferirReq>());
					}
					if(!AlertasBlock.containsKey(newAcc)) {
						AlertasBlock.put(newAcc, new LinkedList<AlertarReq>());
					}
				}
				else {
					int saldo = cuentas.get(newAcc);
					//Cumple CPPRE -> saldo+=cantidad a ingresar
					cuentas.put(newAcc,dinerot + saldo);
				}
				desbloqueoGeneral();
				break;
			}
			case DISPONIBLE: {
				// recibir peticion
				DisponibleReq pet = (DisponibleReq) chDisponible.in().read();

					int dinero = cuentas.get(pet.cuenta);;
					pet.resp.out().write(dinero);
					
				// COMPLETAD
				// responder
				// COMPLETAD
				break;
			}
			case TRANSFERIR: {
				TransferirReq pet = (TransferirReq) chTransferir.in().read();


				if(TransfBlock.get(pet.from) == null) {
					TransfBlock.put(pet.from, new LinkedList<TransferirReq>());
				}
				if (!cuentas.containsKey(pet.from) || !cuentas.containsKey(pet.to) || cuentas.get(pet.from) < pet.value) {
					TransfBlock.get(pet.from).add(pet);
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
				AlertarReq pet= (AlertarReq) chAlertar.in().read();
				if(cuentas.get(pet.cuenta) < pet.minimo) {
					pet.resp.out().write(pet.minimo);
				}
				else { 
					AlertasBlock.get(pet.cuenta).add(pet);
				}
				break;
			}
			}//Fin switch 

			//Tratamiento de peticiones aplazadas si es posible
			desbloqueoGeneral();

		}
	}


	private  void desbloqueoGeneral() {
		for(Entry<String, LinkedList<TransferirReq>> entry : TransfBlock.entrySet()) {
			LinkedList<TransferirReq> bloqlist = entry.getValue();
			boolean done = false;
			for(int i = 0; i < bloqlist.size() && !done; i++) {
				TransferirReq bloq = bloqlist.get(i);
				int saldoO = cuentas.get(bloq.from);
				int saldoD = cuentas.get(bloq.to);
				if (cuentas.containsKey(bloq.from) && cuentas.containsKey(bloq.to)
						&& (cuentas.get(bloq.from) >= bloq.value)
						&& (!tieneCuenta(TransfBlock, bloq.from) && !tieneCuentaBloq(TransfBlock.get(bloq.from), bloq.from))) {
					saldoO = saldoO - bloq.value;
					saldoD = saldoD + bloq.value;
					
					cuentas.put(bloq.from,saldoO);
					cuentas.put(bloq.to, saldoD);
					
					bloq.resp.out().write(null);
					bloqlist.poll();
					done = true;
					
				}
			}
		}
		for(Entry<String, LinkedList<AlertarReq>> entry : AlertasBlock.entrySet()) {
			LinkedList<AlertarReq> bloqlist = entry.getValue();
			boolean done = false;
			for(int i = 0; i < bloqlist.size() && !done; i++) {
				AlertarReq bloq = bloqlist.get(i);
				int saldo = cuentas.get(bloq.cuenta);
				if (saldo < bloq.minimo) {
					bloq.resp.out().write(bloq.minimo);
					bloqlist.poll();
					done = true;
				}
				else {
					bloqlist.poll();
					bloqlist.add(bloq);
				}
			}
		}
//		int na = AlertarBlock.size();
//
//		for(int i = 0; i < na;i++) {
//			AlertarReq ba = AlertarBlock.get(i);
//			int SaldoO = cuentas.get(ba.cuenta);
//			if(SaldoO < ba.minimo) {
//				AlertarBlock.remove(i).resp.out().write(null);
//				i--;
//				na--;
//			}
//		}
	}


	private boolean tieneCuentaBloq(LinkedList<TransferirReq> t, String from) {
		boolean found = false;
		for(int i = 0; i < t.size() && !found ;i++) {
			if(t.get(i).from.equals(from)) {
				found = true;
			}
		}
		return found;
	}


	public boolean tieneCuenta(Map<String,LinkedList<TransferirReq>> transfBlock2, String o) {

		boolean found = false;
		for(Map.Entry<String,LinkedList<TransferirReq>> entry : TransfBlock.entrySet()) {
			if(entry.getKey().equals(o)) {
				found = true;
			}
		}
		return found;
	}

}
