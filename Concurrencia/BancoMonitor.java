package cc.banco;

import es.upm.babel.cclib.Monitor;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedList;
import java.util.Map;

public class BancoMonitor implements Banco  {

	private Map<String,Integer> cuentas;
	private Map<String,LinkedList<bloqueoTransf>> TransfBlock;
	private LinkedList<bloqueoTransf> transf;
	private LinkedList<bloqueoAlerta> AlertarBlock; 
	private Monitor mutex;

	//METODOS AUXILIARES//
	public class bloqueoAlerta {
		public Monitor.Cond c;
		public String ori;
		public int cant;

		//para avisar (operaciones que solo necesitan que guarde una cuenta)
		public bloqueoAlerta (String ori, int cant) {
			c = mutex.newCond();
			this.ori = ori;
			this.cant = cant;
		}
	}
	public class bloqueoTransf {
		public Monitor.Cond c;
		public String ori;
		public String dest;
		public int cant;

		//para transferencia (operaciones que necesitan que guarde dos cuentas)
		public bloqueoTransf (String ori, String dest, int cant){
			this.c = mutex.newCond();
			this.ori = ori;
			this.dest = dest; 
			this.cant = cant;
		}

	}
	private void desbloqueo_General() {
		boolean signaled = false;
		LinkedList<bloqueoTransf> transfRd = new LinkedList<bloqueoTransf>();

		//primera parte del desbloqueo generico: recorre la lista de transferencias bloqueadas
		for(Map.Entry<String,LinkedList<bloqueoTransf>> entry : TransfBlock.entrySet()) {
			
			LinkedList<bloqueoTransf> bloqlist = entry.getValue();	// guardamos: la primera entrada de la lista + saldo origen + saldo destino

			for(int j = 0; j < bloqlist.size() && !signaled;j++){	// recorro la lista de bloqueos que corresponden a esa cuenta
				bloqueoTransf bloq = bloqlist.get(j);				// guardamos la primera entrada

				//				Integer saldoO =cuentas.get(bloq.ori);
				//				Integer saldoD =cuentas.get(bloq.dest);
				if((cuentas.containsKey(bloq.ori)) && 
						(cuentas.containsKey(bloq.dest)) && 
						(cuentas.get(bloq.ori) >= bloq.cant) &&
						bloq.c.waiting() > 0 && (!tieneCuentaBloq(transfRd,bloq.ori) && !bloqlist.isEmpty())) { //  cuenta de origen y detino existen +  origen tiene saldo suficiente -> desbloqueo + 
					transfRd.add(bloq); 											   // anado a la lista de bloqueos leidos + !signaled + elimino la entrada
					signaled = !signaled;				
					bloqlist.remove(j);
					bloq.c.signal();
				}
			}
		}
		//			bloqueoTransf bloq = TransfBlock.get(transf.get(i));	// guardamos: la primera entrada de la lista + saldo origen + saldo destino
		////			Integer saldoO =cuentas.get(bloq.ori);
		////			Integer saldoD =cuentas.get(bloq.dest);
		//			if((cuentas.containsKey(bloq.ori)) && 
		//					(cuentas.containsKey(bloq.dest) ) && 
		//					(cuentas.get(bloq.ori) >= bloq.cant)) {
		//					signaled = !signaled;
		//					TransfBlock.remove(bloq);
		//					bloq.c.signal();
		//					}
		//				}
		//		}
		//		}


		//Segunda parte de desbloque generico: recorre la lista de alertas bloqueadas 
		int na = AlertarBlock.size();
		//Recorre cola de alertas, si la que coje cumpple desbloquea
		for(int i = 0; !signaled && i < na; i++ ) {
			bloqueoAlerta bloqa = AlertarBlock.getFirst();
			//CPRE: saldo cuenta < minimo
			if(cuentas.get(bloqa.ori) < bloqa.cant) {
				//Alerta fuera de cola + salgo de bucle (regla 0/1) + signal para dicha alerta
				signaled = !signaled;
				AlertarBlock.poll();
				bloqa.c.signal();
			}
			//No cumple CPRE -> reencolo
			else {
				AlertarBlock.poll();
				AlertarBlock.add(bloqa);
			}
		}
	}

	public boolean tieneCuenta(Map<String,LinkedList<bloqueoTransf>> transfBlock2, String o) {

		boolean found = false;
		for(Map.Entry<String,LinkedList<bloqueoTransf>> entry : TransfBlock.entrySet()) {
			if(entry.getKey().equals(o)) {
				found = true;
			}
		}
		return found;
	}
	public boolean tieneCuentaBloq(LinkedList<bloqueoTransf> t, String o) {
		boolean found = false;
		for(int i = 0; i < t.size() && !found ;i++) {
			if(t.get(i).ori.equals(o)) {
				found = true;
			}
		}
		return found;
	}

	//FIN METODOS AUXILIARES//



	public BancoMonitor() {
		this.cuentas = new HashMap<String, Integer>();
		transf = new LinkedList<bloqueoTransf>();
		AlertarBlock = new LinkedList<bloqueoAlerta>();
		TransfBlock = new HashMap<>();
		this.mutex = new Monitor();
	}


	/**
	 * Un cajero pide que se ingrese una determinado valor v a una
	 * cuenta c. Si la cuenta no existe, se crea.
	 * @param c nÃºmero de cuenta
	 * @param v valor a ingresar
	 * CPRE -> cierto
	 */
	public void ingresar(String c, int v) {
		//pre es cierto=vacio
		//post del primero
		mutex.enter();

		if(!cuentas.containsKey(c)) 
			cuentas.put(c,v);	

		//		else if (cuentas.get(c) == -1) 
		//			cuentas.put(c,v);

		else  
			cuentas.put(c,v+cuentas.get(c));

		desbloqueo_General();
		mutex.leave();
	}



	/**
	 * Un ordenante pide que se transfiera un determinado valor v desde
	 * una cuenta o a otra cuenta d.
	 * @param o nÃºmero de cuenta origen
	 * @param d nÃºmero de cuenta destino
	 * @param v valor a transferir
	 * @throws IllegalArgumentException si o y d son las mismas cuentas
	 * PRE -> o /= d
	 * CPRE -> o y d estan creadas y el saldo de o >= v
	 */
	public void transferir(String o, String d, int v) throws IllegalArgumentException { 
		mutex.enter();
		if(o.equals(d)) { 
			mutex.leave();
			throw new IllegalArgumentException("Las cuentas son las mismas");
		}
		//
		//		if(!cuentas.containsKey(o)) cuentas.put(o,-1);			// si la cuenta no esxiste la introducimos en la lista de cuentas (la creamos)
		//		if(!cuentas.containsKey(d)) cuentas.put(d,-1);			// si la cuenta no esxiste la introducimos en la lista de cuentas (la creamos)

		bloqueoTransf bt =  new bloqueoTransf(o, d, v);
		if(!cuentas.containsKey(o) || !cuentas.containsKey(d) || cuentas.get(o) < v || tieneCuenta(TransfBlock, o)){
			transf.add(bt);
			TransfBlock.put(o, transf);	//lo anado al mapa de transferencias bloqueadas hasta que se pueda realizar
			//transferencia anadida a la cola de transferencias -> espera a desbloqueo 	
			bt.c.await();
		}

		//Se puede transferir
		cuentas.put(o,cuentas.get(o) - v);	
		cuentas.put(d,cuentas.get(d) + v);

		//Transferencia hecha -> desbloqueo si puedo
		desbloqueo_General();
		mutex.leave();   
	}

	/**
	 * Un consultor pide el saldo disponible de una cuenta c.
	 * @param c nÃºmero de la cuenta
	 * @return saldo disponible en la cuenta id
	 * @throws IllegalArgumentException si la cuenta c no existe
	 * CPRE -> cierto
	 */
	public int disponible(String c) throws IllegalArgumentException { 
		int result = 0;

		if(cuentas.containsKey(c)) { 	
			result = cuentas.get(c);
			return result;
		}
		else
			throw new IllegalArgumentException("La cuenta a consultar no existe");

	}

	/**
	 * Un avisador establece una alerta para la cuenta c. La operaciÃ³n
	 * termina cuando el saldo de la cuenta c baja por debajo de m.
	 * @param c nÃºmero de la cuenta
	 * @param m saldo mÃ­nimo
	 * @throws IllegalArgumentException si la cuenta c no existe
	 * CPRE -> c esta creada
	 */
	public void alertar(String c, int m) throws IllegalArgumentException {
		mutex.enter();
		//Cuenta no esta en banco o esta creada a la espera de ingresar
		if(!cuentas.containsKey(c)) {
			mutex.leave();
			throw new IllegalArgumentException(); 
		}
		//CPRE: saldo >= minimo
		if (cuentas.get(c)>=m) {
			//cumple CPRE -> alerta a cola + espera a desbloqueo
			bloqueoAlerta alerta = new bloqueoAlerta(c, m);
			AlertarBlock.add(alerta);
			alerta.c.await();
		}
		//Por si se puede
		desbloqueo_General();
		mutex.leave();  
	}

}
