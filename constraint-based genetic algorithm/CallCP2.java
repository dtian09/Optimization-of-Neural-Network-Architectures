//call an ECLiPSe program to solve constraints and write results to a file
import com.parctechnologies.eclipse.*;
import java.io.*;
import java.util.*;

public class CallCP2
{
  public static void main(String[] args) throws Exception
  {
    //String wsPop=args[0];//wsPop is the weights of the parents in a population e.g. [130,200,1000,800,950,1300]
	//String wdd=args[1];//wdd, weights difference degree (wdd = weights difference/max weights difference)
	//String k=args[2]; //k, the maximum weights difference
	//String outfile=args[3];//output file
	String hidden_layer_architectures=args[0];//a 2-hidden layer network architecture e.g. [[1,0,1,1,1,1],[0,1,1,1,1,1]]
	String min_nodes=args[1];//min nodes of a layer e.g. 5
	String max_nodes=args[2];//max nodes of a layer e.g. 40
	String outfile=args[3];

	// Create some default Eclipse options
    EclipseEngineOptions eclipseEngineOptions = new EclipseEngineOptions();
    // Object representing the Eclipse process
    EclipseEngine eclipse;
    // Connect the Eclipse's standard streams to the JVM's
    eclipseEngineOptions.setUseQueues(false);
    eclipse = EmbeddedEclipse.getInstance(eclipseEngineOptions);
	//File eclipseProgram = new File("P:\\Nuclear Power Plant Safety Monitoring (Leeds Beckett)\\project\\cp_localsearch.ecl");
    File eclipseProgram = new File("P:\\Nuclear Power Plant Safety Monitoring (Leeds Beckett)\\project\\nearest_neighbours.ecl");
    eclipse.compile(eclipseProgram);
    //String goal="cp_localsearch([1360,1400,1500,1250,1300],0.6,6,outfile)";
    //String goal="cp_localsearch("+wsPop+","+wdd+","+k+","+outfile+")";
    String goal="nearest_neighbours("+hidden_layer_architectures+","+min_nodes+","+max_nodes+","+outfile+")";
    CompoundTerm result = eclipse.rpc(goal);
    ((EmbeddedEclipse) eclipse).destroy();
  }
}

