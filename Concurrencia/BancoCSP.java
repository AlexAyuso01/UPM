package cc.banco;

import org.jcsp.lang.Alternative;
import org.jcsp.lang.AltingChannelInput;
import org.jcsp.lang.Any2OneChannel;
import org.jcsp.lang.CSProcess;
import org.jcsp.lang.Channel;
import org.jcsp.lang.Guard;
import org.jcsp.lang.One2OneChannel;
import org.jcsp.lang.ProcessManager;

import java.util.HashMap;
import java.util.Map;
import java.util.LinkedList;
import java.util.Queue;

public class BancoCSP implements Banco, CSProcess {

	// canales: uno por operacion
	// seran peticiones aplazadas
	private Any2OneChannel chIngresar;
	private Any2OneChannel chDisponible;
	private Any2OneChannel chTransferir;
	private Any2OneChannel chAlertar; 

	Map<String, Integer> cuentas;
	Map<String, Queue<TransferirReq>> transferencias;
	Map<String, Queue<AlertarReq>> alertas;
	LinkedList<TransferirReq> conflictos;
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

		@Override
		public String toString() {
			return "TransferirReq [from=" + from + ", to=" + to + ", value=" + value + "]";
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

		@Override
		public String toString() {
			return "AlertarReq [cuenta=" + cuenta + ", minimo=" + minimo + "]";
		}

	}	

	public class IngresarReq {
		String cuenta;
		int cantidad;

		public IngresarReq(String cuenta, int cantidad) {
			this.cuenta=cuenta;
			this.cantidad=cantidad;
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
		cuentas = new HashMap<String, Integer>();
		new ProcessManager(this).start();

	}


	public void ingresar(String c, int v) {
		//Creacion de confirmacion + envio por canal correspondiente
		IngresarReq peticion = new IngresarReq(c, v);
		chIngresar.out().write(peticion); // envia la peticion

	}


	public void transferir(String o, String d, int v) {
		// comprobar PRE
		if(o.equals(d)) throw new IllegalArgumentException("La operacion transferencia tiene que tener como argumentos cuentas distintas");

		// cumple PRE
		else {
			//Creacion de confirmacion + envio por canal correspondiente
			TransferirReq peticion = new TransferirReq(o, d, v);
			chTransferir.out().write(peticion);
			//Esperar confirmacion
			peticion.resp.in().read();
		}
	}


	public int disponible(String c) {
		//no cumple la CPRE
		if(c==null) throw new IllegalArgumentException("Cuenta no existente");

		//Creacion de confirmacion + envio por canal correspondiente
		DisponibleReq peticion = new DisponibleReq(c);
		chDisponible.out().write(peticion);
		//Esperar resultado por canal 
		Integer saldo = (Integer) peticion.resp.in().read();
		if(saldo==null) throw new IllegalArgumentException("Cuenta no existente");
		return (int) saldo;

	}


	public void alertar(String c, int v) {
		//no cumple la CPRE
		//if(c==null) throw new IllegalArgumentException("Cuenta no existe");

		//Creacion de confirmacion + envio por canal correspondiente
		AlertarReq peticion = new AlertarReq(c, v);
		chAlertar.out().write(peticion);
		//Esperar confirmacion
		Integer alerta = (Integer) peticion.resp.in().read();
		if(alerta==null) throw new IllegalArgumentException("Cuenta no existe");
		// tratar respuesta del servidor
	}

	// Codigo del servidor
	public void run() {
		// nombres simbolicos para las entradas
		final int INGRESAR = 0;
		final int DISPONIBLE = 1;
		final int TRANSFERIR = 2;
		final int ALERTAR = 3;

		// construimos la estructura para recepcion alternativa
		final Guard[] guards = new AltingChannelInput[4];
		guards[INGRESAR] = chIngresar.in();
		guards[DISPONIBLE] = chDisponible.in();
		guards[TRANSFERIR] = chTransferir.in();
		guards[ALERTAR] = chAlertar.in();
		Alternative servicios = new Alternative(guards);

		// mapas con las transferencias y alertas bloqueadas a demas de una cuenta q guarda 
		transferencias = new HashMap<String, Queue<TransferirReq>>();
		alertas =  new HashMap<String, Queue<AlertarReq>>();
		conflictos = new LinkedList<TransferirReq>();
		String cuentaD; 

		// Bucle principal del servicio
		while (true) {
			int servicio = servicios.fairSelect();
			cuentaD = null;
			switch (servicio) {
			case INGRESAR: {
				IngresarReq pet = (IngresarReq) chIngresar.in().read();
				String newAcc = pet.cuenta;
				Integer dinero = pet.cantidad;
				cuentaD = newAcc;
				if (!cuentas.containsKey(newAcc)) { // si la cuenta no existe 
					// crea una cuenta y mete el saldo necesario
					cuentas.put(newAcc, dinero);
					// si el saldo de la cuneta es nulo(0) se anade esa cuenta a los bloqueos pertinentes
					if (!alertas.containsKey(newAcc)) alertas.put(newAcc, new LinkedList<AlertarReq>());

					if (!transferencias.containsKey(newAcc)) transferencias.put(newAcc, new LinkedList<TransferirReq>());

					// ahora, si la cuenta existe
				} 
				else { 
					// se suma la cantidad a ingresar a el saldo previo
					int saldo = cuentas.get(newAcc) ;
					cuentas.put(newAcc,dinero + saldo);
				}
				//System.out.println("--ingresar\n");
				desbloqueo_transferencias(newAcc,transferencias,alertas);
				break;
			}
			case DISPONIBLE: {
				DisponibleReq pet = (DisponibleReq) chDisponible.in().read();
				Integer saldo = cuentas.get(pet.cuenta);
				// se envia el saldo de la cuenta
				pet.resp.out().write(saldo);
				break;
			}
			case TRANSFERIR: {
				TransferirReq pet = (TransferirReq) chTransferir.in().read();
				Queue<TransferirReq> tf = transferencias.get(pet.from);			

				//caso mas probable (existen ambas cuentas)
				if(cuentas.get(pet.from) != null && cuentas.get(pet.to) != null) {
					//miramos si las cuentas cumplen la CPRE
					if (transferencias.get(pet.from).isEmpty() && cuentas.get(pet.from) >= pet.value) {
						//la CPRE se cumple -> transferimos y notificamos
						// transferencia
						Integer saldoO = cuentas.get(pet.from);
						cuentas.put(pet.from, saldoO - pet.value);

						Integer saldoD = cuentas.get(pet.to);			
						cuentas.put(pet.to, saldoD + pet.value);
						// notificacion
						pet.resp.out().write(null);
						// miramos si con la transferencia se puede desbloquear alguna alerta u otra transf
						//System.out.println("--transferencia\n");
						desbloqueo_alertas(pet.from, alertas);
						//System.out.println("--transferencia\n");
						desbloqueo_transferencias(pet.from, transferencias, alertas);
						//en el caso de que este vacio y haya posibles desbloqueos en la cuenta que incrementa
						desbloqueo_transferencias(pet.to, transferencias, alertas);
					}
					else {
						if (tf == null) { 
							tf = new LinkedList<TransferirReq>();
							transferencias.put(pet.from, tf);
						}
						tf.add(pet);  // noCPRE, anadimos la peticion a la cola de transferencias
					}
				} else if (cuentas.get(pet.to) == null) {
					//caso no existe la que recibe la transferencia
					if (tf == null) { 
						tf = new LinkedList<TransferirReq>();
						transferencias.put(pet.to, tf);
					}
					tf.add(pet);
					//ademas anadimos en la estructura de conflictos
					conflictos.add(pet);
				} else {
					//caso no existe la cuenta que manda la transferencia
					if (tf == null) { 
						tf = new LinkedList<TransferirReq>();
						transferencias.put(pet.from, tf);
					}
					tf.add(pet);
					conflictos.add(pet);
				}
				break;
			}
			case ALERTAR: {
				AlertarReq pet = (AlertarReq) chAlertar.in().read();
				if(cuentas.get(pet.cuenta)!=null) {
					if(cuentas.get(pet.cuenta) < pet.minimo)  pet.resp.out().write(pet.minimo);

					// bloqueamos la alerta si no se cumple la CPRE				
					else  alertas.get(pet.cuenta).add(pet);
				}
				else  pet.resp.out().write(null);
				break;
			}
			}// END SWITCH
			// miramos si hay algun desbloqueo posible
			//desbloqueo_transferencias(cuentaD , transferencias, alertas);
		}
	} // END BUCLE SERVICIO

	private void desbloqueo_transferencias(String cuentaO, Map<String, Queue<TransferirReq>> transferencias,
			Map<String, Queue<AlertarReq>> alertas) {
		//hashPrint();
//		System.out.println("entro desbloqueo transf, cuenta: " + cuentaO + "\n");
		if (cuentaO != null && transferencias.get(cuentaO) != null) {
			Integer saldoO = cuentas.get(cuentaO);
			boolean signaled = false;
			if (saldoO != null) {
				Queue<TransferirReq> bloqt = transferencias.get(cuentaO);
//				System.out.println("cola transferencias de "+ cuentaO + " :" + bloqt.toString());
				while (!bloqt.isEmpty() && !signaled) { // transferencias bloqueadas > 0
					signaled = true;		//???? porque cerrariamos el bloque a la primera iteracion
					TransferirReq transf = bloqt.peek();			
					Integer saldoD = cuentas.get(transf.to);
					// la cuenta tiene el saldo suficinete y existe??
					if (saldoD != null && transf.value <= saldoO) {
						// CPRE cumplida:  se realiza la transferencia y se elimina de la lista
						//transferencia
						saldoO -= transf.value;
						cuentas.put(transf.from, saldoO);
						saldoD += transf.value;
						cuentas.put(transf.to, saldoD);
						//notificacion y desencolado
						transf.resp.out().write(0);
						bloqt.poll();
						//remove sobre la estructura de conflictos si existe la estructura en otros sitios
						conflictos.remove(transf);
						
						signaled = false;
//						System.out.println("**Desbloqueado transferencia origen: "+ cuentaO+", destino: "+ transf.to+"\n");
						desbloqueo_transferencias(transf.to, transferencias, alertas);
						//System.out.println("desbloqueo alertas desde desbloqueo transf.from\n");
						desbloqueo_alertas(transf.from, alertas);	
					}	
				}		
				//iteramos sobre la estructura de conflictos
				int conflictsize = conflictos.size();
				int i = 0;
				boolean signal = false;
				while (!conflictos.isEmpty() && i < conflictsize && !signal) {
					TransferirReq transf = conflictos.peek();
					Integer saldoD = cuentas.get(transf.to);
					// la cuenta tiene el saldo suficinete y existe??
					if (saldoD != null && cuentas.get(transf.from) != null && transf.value <= cuentas.get(transf.from)  ) {
						// CPRE cumplida:  se realiza la transferencia y se elimina de la lista
						//transferencia
						saldoO -= transf.value;
						cuentas.put(transf.from, saldoO);
						saldoD += transf.value;
						cuentas.put(transf.to, saldoD);
						//notificacion y desencolado
						transf.resp.out().write(0);
						//remove sobre la estructura de conflictos si existe la estructura en otros sitios
						conflictos.poll();
						bloqt = transferencias.get(transf.to);
						signal = !signal;
						if(bloqt.contains(transf)) bloqt.remove(transf);
						else {
						bloqt = transferencias.get(transf.from);
						if(bloqt.contains(transf)) bloqt.remove(transf);
						}
//						System.out.println("**Desbloqueado transferencia origen: "+ cuentaO+", destino: "+ transf.to+"\n");
						desbloqueo_transferencias(transf.to, transferencias, alertas);
						//System.out.println("desbloqueo alertas desde desbloqueo transf.from\n");
						desbloqueo_alertas(transf.from, alertas);	
					} else {
					conflictos.poll();
					conflictos.add(transf);
					}
					i++;
				}
			}
		}
	}

	private void desbloqueo_alertas(String cuentaO, Map<String, Queue<AlertarReq>> alertas) {
		if (cuentaO != null && alertas.get(cuentaO) != null) {
			Queue<AlertarReq> alerta = alertas.get(cuentaO);
//			System.out.println("entro en el desbloqueo de alertas con cuenta: "+ cuentaO +"\n");
//			System.out.println("cola alertas de "+ cuentaO + " :" + alerta.toString());
			int i = 0;
			int alertasize = alerta.size();
			while (i < alertasize) {
				AlertarReq bloqa = alerta.peek();
				if (cuentas.get(cuentaO) >= bloqa.minimo) { 
					//si no se desbloquea -> reencolo
					alerta.poll();
					alerta.add(bloqa);
				} else { // si se puede desbloquear
					//notificamos y eliminamos la alerta
					bloqa.resp.out().write(bloqa.minimo);
					alerta.poll();
					//System.out.println("**Desbloqueado alerta de cuenta: "+ cuentaO);
				}
				i++;
			}
		}
	}
	//test_second_mon_71 test_second_mon_72 test_third_csp_25 test_third_mon_29 
	//test_second_mon_74 test_third_csp_23 test_second_mon_75 test_third_mon_34
}
