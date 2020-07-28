VibroSim
--------

VibroSim is a simulator for vibrothermography nondestructive evaluation. 
This archive includes all components of VibroSim, many of which you 
are unlikely to need depending on your application. 

Quick Start
-----------
The primary dependencies you will need will be MATLAB and COMSOL 
Multiphysics (with the structural mechanics module, LiveLink for MATLAB, and 
perhaps the CAD import module). VibroSim 1.0.0 has been tested against
MATLAB R2018a-R2020a and COMSOL 5.4-5.5 on Windows and Linux Platforms. 
In addition you will need a Python installation (usually Anaconda) with the 
Numpy/IPython/Matplotlib/Scipy/Pandas stack. Tested on Python 2.7 and 3.6-3.8
(Linux) and Python 3.8 (Windows).

The main package with the examples and instructions for getting started 
is VibroSim_Simulator. It can be installed into a suitable Python 
environment with "python setup.py install" from the VibroSim_Simulator
directory. In order to use it, you will also need VibroSim_COMSOL (either the 
.mltbx installed into MATLAB or the VibroSim_COMSOL/VibroSim_COMSOL/m_files
directory added to your MATLABPATH). You will most likely also need the 
following other packages from this archive installed into your Python 
environment: 
  * angled_friction_model
  * crackclosuresim2 (requires your platform compiler -- see docs)
  * VibroSim_WelderModel
  * limatix

See the README in the VibroSim_Simulator package and the documentation
in the docs/ directory for more detailed information and instructions.
The documentation in the docs/ directory is primarily built copies of
the documentation from the VibroSim_Simulator and VibroSim_COMSOL
packages. 


Complete list of packages
-------------------------

Package name            Function
----------------------  --------------------------------------------
angled_friction_model   Calculate crack heating due to friction
closure_measurements    Evaluate closure state from DIC data
crackclosuresim2        Evaluate closure state and shear stick/slip
crackheat_surrogate2    Accelerate estimation of mu, msqrtR params
tortuosity_tracing      Measure crack tortuosity from microscope imgs
vibro_estparam          Estimate mu, msqrtR from experimental data
VibroSim_COMSOL         MATLAB scripts for COMSOL
VibroSim_Simulator      Main 'glue' tools and examples
VibroSim_WelderModel    Ultrasonic welder contact model
crack_heatflow          Non-COMSOL based heating predictions
limatix                 External data management toolkit (with processtrak)
heatsim2                External finite difference heatflow simulator
VibroSim_Release        Scripts for preparing a VibroSim release.

Please note that limatix and heatsim2 are separate packages, not part 
of VibroSim, but included for convenience purposes. 


Sponsor Acknowledgment
----------------------

This material is based on work supported by the Air Force Research
Laboratory under Contract #FA8650-16-C-5238 and performed at Iowa
State University

This material is based upon work supported by the Department of the
Air Force under Awards No. FD20301933322 and FD20301933313, Air Force
SBIRs to Core Parts, LLC.

Any opinions, findings, and conclusions or recommendations expressed
in this material are those of the author(s) and do not necessarily
reflect views of the Department of the Air Force or Core Parts, LLC.

