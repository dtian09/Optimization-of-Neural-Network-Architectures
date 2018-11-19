//call ECLiPSe to solve constraints and write results to file
import com.parctechnologies.eclipse.*;
import java.io.*;
import java.util.*;

public class CallCP
{
  public static void main(String[] args) throws Exception
  {
    // Create some default Eclipse options
    EclipseEngineOptions eclipseEngineOptions = new EclipseEngineOptions();
    // Object representing the Eclipse process
    EclipseEngine eclipse;

    // Connect the Eclipse's standard streams to the JVM's
    eclipseEngineOptions.setUseQueues(false);

    // Initialise Eclipse
    eclipse = EmbeddedEclipse.getInstance(eclipseEngineOptions);

	String networksinputs=args[0];
	String outfile=args[1];
	//File eclipseProgram = new File("P:\\Nuclear Power Plant Safety Monitoring (Leeds Beckett)\\project\\sendmore.ecl");
    //String goal="sendmore2(D)";
    //LinkedList D = (LinkedList) result.arg(1);
	//CompoundTerm subgoal = (CompoundTerm)result.arg(2);
	//Object D = subgoal.arg(1);
	//LinkedList L = (LinkedList) result.arg(3);
	//System.out.println("Digits="+D);
    File eclipseProgram = new File("P:\\Nuclear Power Plant Safety Monitoring (Leeds Beckett)\\project\\hiddenlayers.ecl");
    eclipse.compile(eclipseProgram);
    String goal="hiddenlayers("+networksinputs+","+outfile+")";
    CompoundTerm result = eclipse.rpc(goal);
	 // Destroy the Eclipse process
    ((EmbeddedEclipse) eclipse).destroy();
  }
}

