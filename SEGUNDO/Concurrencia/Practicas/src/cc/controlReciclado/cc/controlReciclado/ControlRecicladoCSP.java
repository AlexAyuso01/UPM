// Esqueleto para realizar la practica mediante paso de mensajes y
// peticiones aplazadas (rellenad el cÃ³digo donde dice COMPLETAD y
// eliminad todos los comentarios espÃºreos, como este, antes de
// realizar la entrega)
package cc.controlReciclado;

import java.util.LinkedList;
import java.util.Queue;

import org.jcsp.lang.*;

// importar estructuras de datos para almacenar peticiones aplazadas

// COMPLETAD
// clase de bloqueo de gruas
class bloqueoGrua {
  public One2OneChannel pet;
  public int peso;
  public bloqueoGrua(int peso) {
    this.peso = peso;
    pet = Channel.one2one();
  }
}

public class ControlRecicladoCSP implements ControlReciclado, CSProcess {

  // constantes varias
  private enum Estado { LISTO, SUSTITUIBLE, SUSTITUYENDO }

  private final int MAX_P_CONTENEDOR; // a definir en el constructor
  private final int MAX_P_GRUA;       // a definir en el constructor

  // canales para comunicaciÃ³n con el servidor y RPC
  // uno por operacion (peticiones aplazadas)
  private final Any2OneChannel chNotificarPeso;
  private final Any2OneChannel chIncrementarPeso;
  private final Any2OneChannel chNotificarSoltar;
  private final Any2OneChannel chPrepararSustitucion;
  private final Any2OneChannel chNotificarSustitucion;
    
  // // para aplazar peticiones de incrementarPeso
  // // esta va de regalo
  // private static class PetIncrementarPeso {
  //   public int p;
  //   public One2OneChannel chACK;

  //   PetIncrementarPeso (int p) {
  //     this.p = p;
  //     this.chACK = Channel.one2one();
  //   }
  // }

  public ControlRecicladoCSP(int max_p_contenedor,
                             int max_p_grua) {
    // constantes del sistema
    MAX_P_CONTENEDOR = max_p_contenedor;
    MAX_P_GRUA       = max_p_grua;

    // creaciÃ³n de los canales 
    chNotificarPeso = Channel.any2one();
    chIncrementarPeso = Channel.any2one();
    chNotificarSoltar = Channel.any2one();
    chPrepararSustitucion = Channel.any2one();
    chNotificarSustitucion = Channel.any2one();
	
    // arranque del servidor desde el constructor OJO!!!
    new ProcessManager(this).start();
  }

  // interfaz ControlReciclado

  //  PRE: 0 < p < MAX_P_GRUA
  // CPRE: self.estado =/= SUSTITUYENDO
  // notificarPeso(p)
  public void notificarPeso(int p) throws IllegalArgumentException {
    // tratar PRE
    if(p <= 0 || p > MAX_P_GRUA) {
      throw new IllegalArgumentException("Peso no valido");
    }

    // COMPLETAD
    // PRE OK, enviar peticiÃ³n
    chNotificarPeso.out().write(p);

    chNotificarPeso.in().read();
  }

  //  PRE: 0 < p < MAX_P_GRUA
  // CPRE: self.estado =/= SUSTITUYENDO /\
  //       self.peso + p <= MAX_P_CONTENEDOR
  // incrementarPeso(p)
  public void incrementarPeso(int p) throws IllegalArgumentException {
    // tratar PRE
    if(p <= 0 || p > MAX_P_GRUA) {
      throw new IllegalArgumentException("Peso no valido");
    } 
	
    // PRE OK, creamos peticion para el servidor
    bloqueoGrua petincPeso = new bloqueoGrua(p);
    // enviamos peticion
    chIncrementarPeso.out().write(petincPeso);
    // esperar confirmacion
    petincPeso.pet.in().read();
  }

  //  PRE: --
  // CPRE: --
  // notificarSoltar()
  public void notificarSoltar() {
    // enviar peticion
    chNotificarSoltar.out().write(null);
  }

  //  PRE: --
  // CPRE: self = (_, sustituible, 0)
  // prepararSustitucion()
  public void prepararSustitucion() {
    // enviar peticion
    chPrepararSustitucion.out().write(null);
    // esperar confirmacion
    chPrepararSustitucion.in().read();
  }

  //  PRE: --
  // CPRE: --
  // notificarSustitucion()
  public void notificarSustitucion() {
    // enviar peticion
    chNotificarSustitucion.out().write(null);
  }

  // SERVIDOR
  public void run() {
    // estado del recurso
    int peso = 0;
    int acceso = 0;
    Estado estado = Estado.LISTO;
    Queue<bloqueoGrua> gruasbloq;
    boolean signaled = false;


    // para recepciÃ³n alternativa condicional
    Guard[] entradas = {
      chNotificarPeso.in(),
      chIncrementarPeso.in(),
      chNotificarSoltar.in(),
      chPrepararSustitucion.in(),
      chNotificarSustitucion.in()
    };
    Alternative servicios =  new Alternative (entradas);
    // OJO ORDEN!!
    final int NOTIFICAR_PESO = 0;
    final int INCREMENTAR_PESO = 1;
    final int NOTIFICAR_SOLTAR = 2;
    final int PREPARAR_SUSTITUCION = 3;
    final int NOTIFICAR_SUSTITUCION = 4;
    // condiciones de recepciÃ³n
    final boolean[] sincCond = new boolean[5];
	
    sincCond[NOTIFICAR_SOLTAR] = true; 
    sincCond[NOTIFICAR_SUSTITUCION] = true;

    // creamos colecciÃ³n para almacenar peticiones aplazadas
    gruasbloq = new LinkedList<bloqueoGrua>();
    // bucle de servicio
    while (true) {
      // vars. auxiliares para comunicaciÃ³n con clientes
      signaled = !signaled;

      // actualizaciÃ³n de condiciones de recepciÃ³n
      // Notificar peso
      if (!estado.equals(Estado.SUSTITUYENDO))
        sincCond[NOTIFICAR_PESO] = true;
       else 
        sincCond[NOTIFICAR_PESO] = false;
      // Incrementar peso
      if (!estado.equals(Estado.SUSTITUYENDO))
        sincCond[INCREMENTAR_PESO] = true;
       else 
        sincCond[INCREMENTAR_PESO] = false;
      // preparar sustitucion
      if (acceso == 0 && estado.equals(Estado.SUSTITUIBLE))
        sincCond[PREPARAR_SUSTITUCION] = true;
       else
        sincCond[PREPARAR_SUSTITUCION] = false;
      
      
      

      switch (servicios.fairSelect(sincCond)) {
      case NOTIFICAR_PESO:
        // estado != Estado.SUSTITUYENDO
        // leer peticiÃ³n
        int pnp = (int) chNotificarPeso.in().read();
        if(peso + pnp > MAX_P_CONTENEDOR)
          estado = Estado.SUSTITUIBLE;
        else if (peso + pnp <= MAX_P_CONTENEDOR)
          estado = Estado.LISTO;
        chNotificarPeso.out().write(null);
        break;

      case INCREMENTAR_PESO:
        // leer peticion 
        bloqueoGrua petincPeso = (bloqueoGrua) chIncrementarPeso.in().read();
        int pip = petincPeso.peso; 
        // incrementar peso
        if(petincPeso != null && peso + pip <= MAX_P_CONTENEDOR) {
          peso += pip;
          acceso++;
          chIncrementarPeso.out().write(null);
        } else 
          gruasbloq.add(petincPeso);
        break;

      case NOTIFICAR_SOLTAR:
        // accediendo > 0 (por protocolo de llamada)
        chNotificarSoltar.in().read();
        // tratar peticion
        acceso--;
        break;

      case PREPARAR_SUSTITUCION:
        // estado == Estado.SUSTITUIBLE && accediendo == 0
        chPrepararSustitucion.in().read();
        // COMPLETAD
        // tratar peticion
        estado = Estado.SUSTITUYENDO;
        chPrepararSustitucion.out().write(null);
        signaled = !signaled;
        break;
        
      case NOTIFICAR_SUSTITUCION:
        // estado == Estado.SUSTITUYENDO && accediendo == 0 
        // leer peticion
        chNotificarSustitucion.in().read();
        // tratar peticion
        peso = 0;
        estado = Estado.LISTO;
        acceso = 0;
        break;
      } // switch
      while(signaled){
        signaled = !signaled;
        while(!gruasbloq.isEmpty()){
          bloqueoGrua grua =gruasbloq.peek();
          if(grua.peso + peso <= MAX_P_CONTENEDOR){
            signaled = !signaled;
            peso += grua.peso;
            acceso++;
            gruasbloq.remove();
            grua.pet.out().write(null);
          } else {
            gruasbloq.remove();
            gruasbloq.add(grua);
          }
        }
      }
      // si estamos aqui esque no quedan peticiones 
      // aplazadas que podrian ser atendidas!!!!!!!!!!!!!!!!!!
	    
    } // bucle servicio
  } // run() SERVER
} // class ControlRecicladoCSP



