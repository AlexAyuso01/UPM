JFLAGS= -cp ../lib/*:. 
JC= javac
JVM= java
.SUFFIXES: .java .class

.java.class:
	$(JC) $(JFLAGS) *.java

MAIN_I= Inmueble
MAIN_E= EquipoGestor
MAIN_D= Delegaciones

default: .java.class

run: run_e run_d run_i

run_i: $(MAIN_I).class
	$(JVM) $(JFLAGS) $(MAIN_I)

run_e: $(MAIN_E).class
	$(JVM) $(JFLAGS) $(MAIN_E)

run_d: $(MAIN_D).class
	$(JVM) $(JFLAGS) $(MAIN_D)

clean:
	$(RM) *.class