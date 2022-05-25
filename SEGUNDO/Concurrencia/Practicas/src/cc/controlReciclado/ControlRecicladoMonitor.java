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
  private LinkedList<bloqueoContenedor> contenedoresbloq;
  private LinkedList<bloqueoGrua> gruasbloq; 
  //creo que sobran 
  //private ApiContenedor contenedor;
  //private ApiGruas grua;


  public ControlRecicladoMonitor (int max_p_contenedor,
                                  int max_p_grua) {
    MAX_P_CONTENEDOR = max_p_contenedor;
    MAX_P_GRUA = max_p_grua;
    this.mutex = new Monitor();
    this.contenedoresbloq = new LinkedList<bloqueoContenedor>();
    this.gruasbloq = new LinkedList<bloqueoGrua>();
  }

  public void notificarPeso(int p) throws IllegalArgumentException {
    mutex.enter();
    if(p < 0 || p > MAX_P_GRUA){
      mutex.leave();
      throw new IllegalArgumentException();
    }
    if(estado == Estado.SUSTITUYENDO) {  // if !CPRE -> se bloquea y se añade a la lista de thrd esperando 
      bloqueoContenedor bc = new bloqueoContenedor(Estado.LISTO);
      contenedoresbloq.add(bc);
      bc.cond.await();
    }
    //se ouede notificar 
    if(peso + p > MAX_P_CONTENEDOR){
      estado = Estado.SUSTITUIBLE;
    } else if (peso + p <= MAX_P_CONTENEDOR){
      estado = Estado.LISTO;
    }
    desbloqueo_gruas();
    mutex.leave();
  }

  public void incrementarPeso(int p) throws IllegalArgumentException {
    mutex.enter();

    if(p < 0 || p > MAX_P_GRUA){ // SI NO CUMPLE PRE TERMINA
      mutex.leave();
      throw new IllegalArgumentException();
    }
    if(peso + p > MAX_P_CONTENEDOR || estado == Estado.SUSTITUYENDO){ // if !CPRE -> se bloquea y se añade a la lista de thrd esperando
      bloqueoGrua bg = new bloqueoGrua(p) ;
      gruasbloq.add(bg);
      bg.cond.await();
    } 
    //se puede incrementar
    peso += p;
    acceso++;
    desbloqueo_gruas();
    mutex.leave();
  }

  public void notificarSoltar() {
    mutex.enter();
    //no CPRE (cierto)
    acceso--;
    desbloqueo_gruas();
    mutex.leave();
  }

  public void prepararSustitucion() {
    mutex.enter();
    if(estado != Estado.SUSTITUIBLE || acceso != 0){ //si !CPRE -> bloqueamos
      bloqueoContenedor bc = new bloqueoContenedor(estado);
      contenedoresbloq.add(bc);
      bc.cond.await();
    }
    // se puede sustituir
    estado = Estado.SUSTITUYENDO;
    acceso = 0;
    desbloqueo_contenedores();
    mutex.leave();
  }

  public void notificarSustitucion() {
    mutex.enter();
    //no CPRE (cierto)
    peso = 0;
    estado = Estado.LISTO;
    acceso = 0;
    desbloqueo_contenedores();
    mutex.leave();
  }

  //METODOS AUXILIARES 

  public class bloqueoContenedor {
    public Monitor.Cond cond;
    public Estado estado;

    public bloqueoContenedor(Estado estado){
      this.cond = mutex.newCond();
      this.estado = estado;
    }
  }

  public class bloqueoGrua {
    public Monitor.Cond cond;
    public int peso;

    public bloqueoGrua(int peso){
      this.cond = mutex.newCond();
      this.peso = peso;
    }
  }

  private void desbloqueo_contenedores(){
    boolean signaled = false;
    // RECORREMOS LA LISTA DE BLOQUEOS DE CONTENEDORES 
    LinkedList<bloqueoContenedor> bcRead = new LinkedList<bloqueoContenedor>();
    for(int i = 0; i < contenedoresbloq.size() && !signaled; i++){
      bloqueoContenedor bloq = contenedoresbloq.get(i);
      if((bloq.estado != Estado.SUSTITUYENDO || (bloq.estado == Estado.SUSTITUIBLE && acceso == 0)) && bloq.cond.waiting() > 0 ){ // if CPRE desbloqueo()
        bcRead.add(bloq);
        signaled = !signaled;
        contenedoresbloq.remove(i);
        bloq.cond.signal();
      }
    }
  }
  private void desbloqueo_gruas(){
    boolean signaled = false;
    // RECORREMOS LA LISTA DE GRUAS BLOQUEADAS
    LinkedList<bloqueoGrua> bgRead = new LinkedList<bloqueoGrua>();
    for(int i = 0; i < gruasbloq.size() && !signaled; i++){
      bloqueoGrua bloq = gruasbloq.get(i);
      if(bloq.peso<= MAX_P_CONTENEDOR && estado != Estado.SUSTITUYENDO){
        bgRead.add(bloq);
        signaled = !signaled;
        gruasbloq.remove(i);
        bloq.cond.signal();
      }
    }
  }
}
