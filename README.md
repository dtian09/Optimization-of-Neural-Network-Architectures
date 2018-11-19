Matlab programs to find optimal architectures of neural networks (multilayer perceptrons) for detecting loss of coolant accidents of a nuclear power plant (NPP). The neural networks take 37 inputs and output the size of a break on the inlet header of the primary heat transport of the NPP. The size of a break is defined to be the double cross-sectional area of the inlet header and in the range 0% and 200% where 0% is no break and 200% is the complete rupture of the inlet header. The networks output a value between 0 (i.e. 0%) and 200 (i.e. 200%). The following algorithms are implemented to find optimal neural network architectures:

Exhaustive search,

Random Search,

Genetic algorithm,

Constraint-based random search (CBRS),

Constraint-based genetic algorithm (CBGA),

A methodology to select a minimum training set using Short-time Fourier Transform.

The Matlab Neural Network Toolbox 2017 and the Genetic Algorithm Toolbox of the University Sheffield (http://codem.group.shef.ac.uk/index.php/ga-toolbox) were used to implement the algorithms. To run these algorithms on a computer, these toolboxes must be installed on the computer. CBRS and CBGA were implemented using Matlab, java and ECLiPSe constraint logic programming system (http://eclipseclp.org/). Therefore, java and ECLiPSe must also be installed on the computer. 

References:

D. Tian et al “A Constraint-based Genetic Algorithm for Optimizing Neural Network Architectures for Detection of Loss of Coolant Accidents of Nuclear Power Plants”, Neurocomputing Journal, Elsevier, vol. 322, pages 102-119, 2018

D. Tian et al “A Constraint-based Random Search Algorithm for Optimizing Neural Network Architectures and Ensemble Construction in Detecting Loss of Coolant Accidents in Nuclear Power Plants”, 11th International Conference on Developments in e-Systems Engineering, Cambridge, UK, 2-5 Sept 2018

D. Tian et al “A Neural Networks Design Methodology for Detecting Loss of Coolant Accidents in Nuclear Power Plants”. In: Alani M., Tawfik H., Saeed M., Anya O. (eds) Applications of Big Data Analytics. Springer, 2018

D. Tian et al “Selecting a Minimum Training Set for Neural Networks using Short-Time Fourier Transform in Detecting Loss of Coolant Accidents in Nuclear Power Plants”, The 20th International Conference on Artificial Intelligence (ICAI’18), Las Vegas, USA, 30 Jul-2 Aug 2018

D. Tian et al “Identification of Loss of Coolant Accidents of Nuclear Power Plants using Artificial Neural Networks”, 4th International Conference on Nuclear Power Plant Life Management, Lyon, France 23–27 Oct 2017
