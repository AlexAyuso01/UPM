package cc.controlReciclado;
import org.jcsp.lang.CSProcess;
import org.jcsp.lang.ProcessManager;

public class ControlRecicladoCSP implements ControlReciclado, CSProcess {
  private enum Estado { LISTO, SUSTITUIBLE, SUSTITUYENDO }

  private final int MAX_P_CONTENEDOR;
  private final int MAX_P_GRUA;


  public ControlRecicladoCSP (int max_p_contenedor,
                              int max_p_grua) {
    MAX_P_CONTENEDOR = max_p_contenedor;
    MAX_P_GRUA = max_p_grua;
    new ProcessManager(this).start();
  }

  public void notificarPeso(int p) {
  }

  public void incrementarPeso(int p) {
  }

  public void notificarSoltar() {
  }

  public void prepararSustitucion() {
  }

  public void notificarSustitucion() {
  }

  public void run() {
  }
}
