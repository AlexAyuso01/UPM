package cc.banco;

import es.upm.babel.cclib.Monitor;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.Map;

public class BancoMonitor implements Banco  {

	private Map<String,Integer> cuentas;
	private LinkedList<bloqueoTransf> TransfBlock;
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

		//primera parte del desbloqueo generico: recorre la lista de transferencias bloqueadas
		int nt = TransfBlock.size();
		for(int i = 0; i < nt && !signaled; i++) {
			LinkedList<bloqueoTransf> transfRd = new LinkedList<bloqueoTransf>();
			bloqueoTransf bloq = TransfBlock.get(i);	// guardamos: la primera entrada de la lista + saldo origen + saldo destino
			Integer saldoO =cuentas.get(bloq.ori);
			Integer saldoD =cuentas.get(bloq.dest);
			if(TransfBlock.isEmpty() || tieneCuenta(transfRd,bloq.ori)) {}
			else{
				// si la lista de bloqueos esta vacia o la lista con las transferencias ya vistas contiene la cuenta de origen, no se siguen con las comprobaciones
				if((saldoO != null && saldoO != -1) && 
						(cuentas.containsKey(bloq.dest) && saldoD != -1) && 
						(cuentas.get(bloq.ori) >= bloq.cant) && 
						(bloq.c.waiting() > 0) && !tieneCuenta(transfRd, bloq.ori)) {		// si el saldo de origen es nulo o = -1 (la cuenta no existia y se crea en la transferencia) no se sigue
					//transferencia + quito de la cola + cond.signal
					signaled = !signaled;
					TransfBlock.remove(bloq);
					bloq.c.signal();
				} 
				transfRd.add(bloq);
			}
		}


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

	public boolean tieneCuenta(LinkedList<bloqueoTransf> t, String o) {

		boolean found = false;
		for(int i = 0; i < t.size() && !found ;i++) {
			if(t.get(i).ori.equals(o)) {
				found = true;
			}
		}
		return found;
	}
	public boolean tieneCuentas(LinkedList<bloqueoTransf> t, String o, String d) {

		boolean found = false;
		for(int i = 0; i < t.size() && !found ;i++) {
			if(t.get(i).ori.equals(o) && t.get(i).dest.equals(d)) {
				found = true;
			}
		}
		return found;
	}

	//FIN METODOS AUXILIARES//



	public BancoMonitor() {
		this.cuentas = new HashMap<String, Integer>();
		TransfBlock = new LinkedList<bloqueoTransf>();
		AlertarBlock = new LinkedList<bloqueoAlerta>();
		this.mutex = new Monitor();
	}


	/**
	 * Un cajero pide que se ingrese una determinado valor v a una
	 * cuenta c. Si la cuenta no existe, se crea.
	 * @param c número de cuenta
	 * @param v valor a ingresar
	 * CPRE -> cierto
	 */
	public void ingresar(String c, int v) {
		//pre es cierto=vacio
		//post del primero
		mutex.enter();

		if(!cuentas.containsKey(c)) 
			cuentas.put(c,v);	

		else if (cuentas.get(c) == -1) 
			cuentas.put(c,v);

		else  
			cuentas.put(c,v+cuentas.get(c));

		desbloqueo_General();
		mutex.leave();
	}



	/**
	 * Un ordenante pide que se transfiera un determinado valor v desde
	 * una cuenta o a otra cuenta d.
	 * @param o número de cuenta origen
	 * @param d número de cuenta destino
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

		if(!cuentas.containsKey(o)) cuentas.put(o,-1);			// si la cuenta no esxiste la introducimos en la lista de cuentas (la creamos)
		if(!cuentas.containsKey(d)) cuentas.put(d,-1);			// si la cuenta no esxiste la introducimos en la lista de cuentas (la creamos)

		bloqueoTransf bt =  new bloqueoTransf(o, d, v);
		if(cuentas.get(o) < v || cuentas.get(d) == -1 || tieneCuenta(TransfBlock,o)) { // cuenta origen exite + saldo < valor a transferir + la cuenta ya tiene un bloqueo
			TransfBlock.add(bt);		//lo anado a la lista de transferencias bloqueadas hasta que se pueda realizar
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
	 * @param c número de la cuenta
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
	 * Un avisador establece una alerta para la cuenta c. La operación
	 * termina cuando el saldo de la cuenta c baja por debajo de m.
	 * @param c número de la cuenta
	 * @param m saldo mínimo
	 * @throws IllegalArgumentException si la cuenta c no existe
	 * CPRE -> c esta creada
	 */
	public void alertar(String c, int m) throws IllegalArgumentException {
		mutex.enter();
		//Cuenta no esta en banco o esta creada a la espera de ingresar
		if(!cuentas.containsKey(c) || cuentas.get(c)==-1) {
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