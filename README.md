Matlab programs to find optimal architectures of neural networks (multilayer perceptrons) for detecting loss of coolant accidents (LOCA) of a nuclear power plant (NPP) by training a number of network architectures on a transient dataset of LOCA. The transient dataset is not available to the public due to security issues. The neural networks take 37 inputs (representing 37 signals e.g. pressure, temperature and flow rates etc. of the primary heat transport of a NPP) and output the size of a break on the inlet header of the primary heat transport of the NPP. The size of a break is defined to be the double cross-sectional area of the inlet header and in the range 0% and 200% where 0% is no break and 200% is the complete rupture of the inlet header. The networks output a value between 0 (i.e. 0%) and 200 (i.e. 200%). The following algorithms are implemented to find optimal neural network architectures:

Exhaustive search (find optimal 2-layer network architectures with 37 inputs and mini_nodes to max_nodes in each layer),

Random Search (find optimal random 2-layer network architectures with < 37 inputs and mini_nodes to max_nodes in each layer),

Genetic algorithm (find optimal 2-layer network architectures with < 37 inputs and mini_nodes to max_nodes in each layer),

Constraint-based random search (CBRS) (find optimal 2-layer and 3-layer network architectures with < 37 inputs and mini_nodes to max_nodes in each layer),

Constraint-based genetic algorithm (CBGA) (find optimal 2-layer network architectures with < 37 inputs and mini_nodes to max_nodes in each layer),

A methodology to select a minimum training set using Short-time Fourier Transform (STFT) (STFT is used to select the most representative training patterns from a training set).

The Matlab Neural Network Toolbox 2017 and the Genetic Algorithm Toolbox of the University Sheffield (http://codem.group.shef.ac.uk/index.php/ga-toolbox) were used to implement the algorithms. To run these algorithms on a computer, these toolboxes must be installed on the computer. CBRS and CBGA were implemented using Matlab, java and ECLiPSe constraint logic programming system (http://eclipseclp.org/). Therefore, java and ECLiPSe must also be installed on the computer. The programs can be modified to tailor to other regression or classification problems.

References:

D. Tian et al “A Constraint-based Genetic Algorithm for Optimizing Neural Network Architectures for Detection of Loss of Coolant Accidents of Nuclear Power Plants”, Neurocomputing, Elsevier, vol. 322, pages 102-119, 2018

D. Tian et al “A Constraint-based Random Search Algorithm for Optimizing Neural Network Architectures and Ensemble Construction in Detecting Loss of Coolant Accidents in Nuclear Power Plants”, 11th International Conference on Developments in e-Systems Engineering, Cambridge, UK, 2-5 Sept 2018

D. Tian et al “A Neural Networks Design Methodology for Detecting Loss of Coolant Accidents in Nuclear Power Plants”. In: Alani M., Tawfik H., Saeed M., Anya O. (eds) Applications of Big Data Analytics. Springer, 2018

D. Tian et al “Selecting a Minimum Training Set for Neural Networks using Short-Time Fourier Transform in Detecting Loss of Coolant Accidents in Nuclear Power Plants”, The 20th International Conference on Artificial Intelligence (ICAI’18), Las Vegas, USA, 30 Jul-2 Aug 2018

D. Tian et al “Identification of Loss of Coolant Accidents of Nuclear Power Plants using Artificial Neural Networks”, 4th International Conference on Nuclear Power Plant Life Management, Lyon, France 23–27 Oct 2017
