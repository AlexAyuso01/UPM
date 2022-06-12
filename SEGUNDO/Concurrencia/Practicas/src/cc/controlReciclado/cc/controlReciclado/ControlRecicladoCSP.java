// Esqueleto para realizar la practica mediante paso de mensajes y
// peticiones aplazadas (rellenad el cÃ³digo donde dice COMPLETAD y
// eliminad todos los comentarios espÃºreos, como este, antes de
// realizar la entrega)
package cc.controlReciclado;

import org.jcsp.lang.*;

// importar estructuras de datos para almacenar peticiones aplazadas
// 
// COMPLETAD

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
    
  // para aplazar peticiones de incrementarPeso
  // esta va de regalo
  private static class PetIncrementarPeso {
    public int p;
    public One2OneChannel chACK;

    PetIncrementarPeso (int p) {
      this.p = p;
      this.chACK = Channel.one2one();
    }
  }

  public ControlRecicladoCSP(int max_p_contenedor,
                             int max_p_grua) {
    // constantes del sistema
    MAX_P_CONTENEDOR = max_p_contenedor;
    MAX_P_GRUA       = max_p_grua;

    // creaciÃ³n de los canales 
    // 
    // 
    // COMPLETAD
    // 
    //
	
    // arranque del servidor desde el constructor OJO!!!
    new ProcessManager(this).start();
  }

  // interfaz ControlReciclado

  //  PRE: 0 < p < MAX_P_GRUA
  // CPRE: self.estado =/= SUSTITUYENDO
  // notificarPeso(p)
  public void notificarPeso(int p) throws IllegalArgumentException {
    // tratar PRE
    // 
    // COMPLETAD
    //
	
    // PRE OK, enviar peticiÃ³n
    // COMPLETAD
  }

  //  PRE: 0 < p < MAX_P_GRUA
  // CPRE: self.estado =/= SUSTITUYENDO /\
  //       self.peso + p <= MAX_P_CONTENEDOR
  // incrementarPeso(p)
  public void incrementarPeso(int p) throws IllegalArgumentException {
    // tratar PRE
    // 
    // COMPLETAD
    //
	
    // PRE OK, creamos peticion para el servidor
    // COMPLETAD
    // enviamos peticion
    // COMPLETAD
    // esperar confirmacion
    // COMPLETAD
  }

  //  PRE: --
  // CPRE: --
  // notificarSoltar()
  public void notificarSoltar() {
    // enviar peticion
    // COMPLETAD
  }

  //  PRE: --
  // CPRE: self = (_, sustituible, 0)
  // prepararSustitucion()
  public void prepararSustitucion() {
    // enviar peticion
    // COMPLETAD
  }

  //  PRE: --
  // CPRE: --
  // notificarSustitucion()
  public void notificarSustitucion() {
    // enviar peticion
    // COMPLETAD
  }

  // SERVIDOR
  public void run() {
    // estado del recurso
    // 
    // COMPLETAD
    // 

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
    // 
    // COMPLETAD
	

    // bucle de servicio
    while (true) {
      // vars. auxiliares para comunicaciÃ³n con clientes
      //
      // COMPLETAD

      // actualizaciÃ³n de condiciones de recepciÃ³n
      // 
      // COMPLETAD
      // 
      

      switch (servicios.fairSelect(sincCond)) {
      case NOTIFICAR_PESO:
        // estado != Estado.SUSTITUYENDO
        // leer peticiÃ³n
        // COMPLETAD
        // procesar peticiÃ³n
        // 
        //
        // COMPLETAD
        //
        // 
        break;
      case INCREMENTAR_PESO:
        // leer peticion 
        // COMPLETAD
        // tratar peticiÃ³n, y aplazar si no se cumple CPRE
        // o aplazar directamente
        //
        //
        //
        // COMPLETAD
        //
        //
        //
        break;
      case NOTIFICAR_SOLTAR:
        // accediendo > 0 (por protocolo de llamada)
        // leer peticion
        // COMPLETAD
        // tratar peticion
        // COMPLETAD
        break;
      case PREPARAR_SUSTITUCION:
        // estado == Estado.SUSTITUIBLE && accediendo == 0
        // leer peticion
        // COMPLETAD
        // tratar peticion
        // COMPLETAD
        break;
      case NOTIFICAR_SUSTITUCION:
        // estado == Estado.SUSTITUYENDO && accediendo == 0 
        // leer peticion
        // COMPLETAD
        // tratar peticion
        // 
        // COMPLETAD
        break;
      } // switch

      // tratamiento de peticiones aplazadas
      // 
      // 
      // 
      // 
      // 
      // 
      // COMPLETAD
      // 
      // 
      // 
      // 
      // 
      // 
      // 

      // si estamos aqui esque no quedan peticiones 
      // aplazadas que podrian ser atendidas!!!!!!!!!!!!!!!!!!
	    
    } // bucle servicio
  } // run() SERVER
} // class ControlRecicladoCSP

