package cc.controlReciclado;
import java.util.LinkedList;

import es.upm.babel.cclib.Monitor;

public final class ControlRecicladoMonitor implements ControlReciclado {
  private enum Estado { LISTO, SUSTITUIBLE, SUSTITUYENDO }

  private final int MAX_P_CONTENEDOR;
  private final int MAX_P_GRUA;

  private static int peso;
  private static Estado estado;
  private static int acceso;

  private Monitor mutex;
  private Monitor.Cond condNP;
  private Monitor.Cond condPS;
  private LinkedList<bloqueoGrua> gruasbloq; 

  public ControlRecicladoMonitor (int max_p_contenedor,
                                  int max_p_grua) {
    MAX_P_CONTENEDOR = max_p_contenedor;
    MAX_P_GRUA = max_p_grua;
    this.mutex = new Monitor();
    condNP = mutex.newCond();
    condPS = mutex.newCond();
    this.gruasbloq = new LinkedList<bloqueoGrua>();

    peso = 0;
    estado = Estado.LISTO;
    acceso = 0;


  }
  
 public void notificarPeso (int p) throws IllegalArgumentException{
  //PRE = p > 0 ^ p <= MAX_P_GRUA
  //CPRE = self.estado != sustituyendo 
  //CPOST = self.peso = selfpre.peso ^ self.accediendo = selfpre.accediendo ^ selfpre.peso + p > MAX_P_CONTENEDOR => self.estado = sustituible ^ selfpre.peso + p <= MAX_P_CONTENEDOR => self.estado = listo 
  mutex.enter();
    if (p <= 0 || p > MAX_P_GRUA) {
      mutex.leave();
      throw new IllegalArgumentException("Peso incorrecto");
    }
    if(estado.equals(Estado.SUSTITUYENDO)){  // if !CPRE -> se bloquea y se añade a la lista de thrd esperando 
      condNP.await();
    }
     //se ouede notificar 
    if(peso + p > MAX_P_CONTENEDOR){
      estado = Estado.SUSTITUIBLE;
    } else if (peso + p <= MAX_P_CONTENEDOR){
      estado = Estado.LISTO;
    }

    desbloqueo();
    mutex.leave();

}
  public void incrementarPeso(int p) throws IllegalArgumentException {
    mutex.enter();
    if (p <= 0 || p > MAX_P_GRUA) {
      mutex.leave();
      throw new IllegalArgumentException("Peso incorrecto");
    }
    if (!(!estado.equals(Estado.SUSTITUYENDO) && peso + p <= MAX_P_CONTENEDOR)) {
      bloqueoGrua bloqueo = new bloqueoGrua(p);
      gruasbloq.add(bloqueo);
      bloqueo.cond.await();
    }
      peso += p;
      acceso++; 

      desbloqueo();
    mutex.leave();
  }

  //CPRE = cierto
  // POST = selfpre = (p,e,a) ^ self = (p,e,a-1)
  public void notificarSoltar(){ //no toca el peso ni el estado pero el acceso disminuye en 1 
    mutex.enter();
    acceso--;
    desbloqueo();
    mutex.leave();
  }
  //CPRE = cierto
  // POST = selfpre = (p,e,a) ^ self = (p,e,a-1)

  //CPRE = self = (_,sustituible, 0)
  public void prepararSustitucion(){ //si el estado == sustituible y el acceso == 0 entonces se puede sustituir (estado => sustituyendo) sino se bloquea la llamada
    mutex.enter();
    if(!(estado.equals(Estado.SUSTITUIBLE) && acceso == 0)){
      condPS.await();
    }      
    estado = Estado.SUSTITUYENDO;
    mutex.leave();
  }
  //no CPRE (cierto)  
  public void notificarSustitucion() { //resetea todos los parametros
    mutex.enter();
    peso = 0;
    estado = Estado.LISTO;
    acceso = 0;

    desbloqueo();
    mutex.leave();
  }

  //METODOS AUXILIARES 
  public class bloqueoGrua {
    public Monitor.Cond cond;
    public int peso;

    public bloqueoGrua(int peso){
      this.cond = mutex.newCond();
      this.peso = peso;
    }
  }

  private void desbloqueo(){  //desbloquea todos los que estan esperando
    if (!estado.equals(Estado.SUSTITUYENDO) && condNP.waiting() > 0){
      condNP.signal();
    } else if(acceso == 0 && estado.equals(Estado.SUSTITUIBLE) && condPS.waiting() > 0){
      condPS.signal();
    } else {
      boolean signaled = false;
     // RECORREMOS LA LISTA DE GRUAS BLOQUEADAS
     LinkedList<bloqueoGrua> bgRead = new LinkedList<bloqueoGrua>();
     for(int i = 0; i < gruasbloq.size() && !signaled; i++){
       bloqueoGrua bloq = gruasbloq.get(i);
       if(bloq.peso + peso <= MAX_P_CONTENEDOR && !signaled){
        bgRead.add(bloq);
         signaled = !signaled;
         gruasbloq.remove(i);
         bloq.cond.signal();
        }
      }
    }
  } 
}
