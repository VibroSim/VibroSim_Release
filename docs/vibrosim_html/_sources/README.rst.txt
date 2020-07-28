VibroSim Simulator
==================

VibroSim Simulator is a set of tools to organize and facilitate
simulating Vibrothermography testing using VibroSim.

PLEASE NOTE THAT VIBROSIM MAY NOT HAVE BEEN ADEQUATELY 
VALIDATED, THE NUMBERS BUILT INTO IT ALMOST CERTAINLY 
DO NOT APPLY TO YOUR VIBROTHERMOGRAPHY PROCESS. ITS OUTPUT 
CANNOT BE TRUSTED AND IS NOT SUITABLE FOR ENGINEERING 
REQUIREMENTS WITHOUT APPLICATION- AND PROCESS-SPECIFIC 
VALIDATION. 

VibroSim Simulator relies directly on the following packages:
  * VibroSim_COMSOL
  * angled_friction_model
  * crackclosuresim2
  * VibroSim_WelderModel (if ultrasonic welder-base excitation
    is to be simulated)
  * Limatix

As such, it requires MATLAB, COMSOL, and Python. The COMSOL
Structural Mechanics Module and COMSOL LiveLink for MATLAB
are also necessary. The Python version must be at least 2.7 
(preferably 3.6 or newer) 
and should include the full IPython, Matplotlib, Numpy, Scipy 
stack as well as Pandas v0.17.1 or later. To build 
crackclosuresim2 you will also need the platform compiler 
for your Python version (see the crackclosuresim2 documentation 
for more information).

The Git version control system and the GitPython bindings
are strongly recommended as the best way to manage or contribute
updates.

While the current implementation uses COMSOL for vibration
calculation and for heat flow evaluation, because of the
modular nature of VibroSim it would be reasonably
straightforward to re-implement those steps using other
tools. The crack_heatflow package will perform COMSOL-free
heat flow evaluation. 


Installation
------------

Make sure you have the commercial prerequisites (MATLAB; COMSOL with 
Structural Mechanics Module and LiveLink for MATLAB) installed
and a scientific Python distribution (usually `Anaconda
https://www.anaconda.com <https://www.anaconda.com>`_) installed. See also the Windows Installation
notes, below, if applicable. 

Like most the other VibroSim components, VibroSim_Simulator is 
a Python package. Use the usual Python process

    ``python setup.py build``
    
    ``python setup.py install``

commands to install it. (If running Anaconda on Windows all these
commands are from an Anaconda prompt)

After installing VibroSim_Simulator using the above process, 
repeat the same process on the ``angled_friction_model``,
``limatix``, and ``VibroSim_WelderModel`` packages. 

Prior to installing the final package (``crackclosuresim2``) 
you need to make sure you have your "platform compiler" 
installed. Typically this is GCC on Linux (installed via your OS),
XCode on Macintosh, and Visual C++ on Windows. 

The exact compiler versions on Windows are listed at 
`https://wiki.python.org/moin/WindowsCompilers <https://wiki.python.org/moin/WindowsCompilers>`_
The correct Windows compiler for Python 3.5-3.8 is Visual C++ 14.X
and can be freely downloaded as "Build Tools for Visual Studio 2019"
from 
`https://visualstudio.microsoft.com/downloads/#build-tools-for-visual-studio-2019 <https://visualstudio.microsoft.com/downloads/#build-tools-for-visual-studio-2019>`_
When running the installer, be sure to install "C++ build tools" and 
ensure the latest versions of "MSVCv142 - VS 2019 C++ x64/x86 build tools"
and "Windows 10 SDK" are checked. 

Once you have your platform compiler installed you can perform 
the usual ``setup.py`` steps on the crackclosuresim2 package. 

The final installation step is to make the MATLAB scripts in the 
VibroSim_COMSOL package accessible. If a VibroSim_COMSOL .mltbx 
was included in your archive you can install it using MATLAB's
package manager. Otherwise you can set the ``MATLABPATH`` environment
variable to point at the ``VibroSim_COMSOL/m_files`` subdirectory of 
the VibroSim_COMSOL archive. 

Once all the installation steps are complete, you can test VibroSim
by running one of the examples. For example, in a terminal or 
Anaconda prompt from the examples/ folder of VibroSim_Simulator
you could run the vibrosim_demo3 example by typing: 
``processtrak vibrosim_demo3.prx -a`` 

See the documentation below for more information on processtrak. 


Windows Installation
--------------------

Additional steps must be followed for this package to work on 
Windows.
If COMSOL is to be used, the command line executables for COMSOL 
need to be added to the path. For COMSOL 5.4 these executables 
were installed to the following directory:

	 ``C:\Program Files\COMSOL\COMSOL54\Multiphysics\bin\win64``

This directory needs to be added to the end of the ``path`` 
environment variable. Searching "environment variables" in the
start menu is a good way to find where to make this edit. Path
entries on Windows are usually separated with semicolons (;)
but Windows 10 now has a convenient editor you can use to add
additional entries without having to worry about separators.

VibroSim Simulator Workflow
---------------------------

The VibroSim simulator workflow splits the process of performing a
VibroSim simulation into a sequence of steps. Each step can be run
manually, but as the manual steps can be rather complicated we
recommend the use of the ProcessTrak tool from the Limatix
package to automate the execution of the steps.

The conceptual steps involved in a VibroSim simulation are:
  1. Creation of a geometric model
  2. Vibrational analysis
  3. Modeling of the vibrothermography excitation 
  4. Prediction of heating power
  5. Modeling of the heat from the crack conducting through the
     material


ProcessTrak
-----------

ProcessTrak is a commandline tool from the Limatix package that is
used to keep track of what has been performed in a multistep
process. It is executed by typing ``processtrak`` at the command line.
ProcessTrak is configured by an XML listing of input file steps in a
``.prx`` file.  Usually ProcessTrak is run referencing that ``.prx`` file
followed by additional instructions for what is desired. For example

     ``processtrak vibrosim_demo3.prx --status``

will list out the status of each step in the process for each input
file.

ProcessTrak is designed to process input data into output results. The
input data is specified in the form of an XML "experiment log" (``.xlg``
file). The experiment log specifies or references the various inputs.
The first ProcessTrak step is always an implicit ``copyinput`` step
which copies the input ``.xlg`` to an output "processed experiment log"
(``.xlp``) file.  The processed experiment log is annotated with
Provenance information, log output from the various processing steps,
and the result data from each processing step. For example,

     ``processtrak vibrosim_demo3.prx -s copyinput``

will run the implicit ``copyinput`` step on the input files listed in
``vibrosim_demo3.prx``, generating an output ``.xlp`` file (the input ``.xlg``
is never touched).


Git and Limatix-Git
--------------------

Having confidence in simulation output requires confidence that you
executed the code you intended and confidence that you have a
repeatable process. We recommend the use of Git and Limatix-Git
to perform version management both on the scripts and parameters
of the simulation and on the generated output from the simulation.
This process will require having Git and GitPython installed. 
Limatix-Git is included in the Limatix installation. 

To start using the Limatix-Git process, entering

     ``git init``

in your simulation directory will create a new Git repository there. 

We recommend managing your simulation process with two branches:
"master" which contains the scripts and instructions but no output,
and "master_processed" which also includes processed output.
(These two branches can of course themselves be branched as desired).

The ``limatix-git`` program exists to help automate the process of
committing changed scripts and simulation output to the proper
branches. It is based on the assumption that the name of any
branch intended to contain processed output ends with ``_processed``.
It operates on the principle that scripts, input data, etc. should
be committed to the master branch, and processed output should be
cross-referenced in the ``.xlp`` files.

To add files to the unprocessed branch, check out that branch,
run ``limatix-git add -a`` to stage files for commit, ``git status``
to verify only input files have been staged, and ``git commit``
to perform the commit. 

To add files to the processed branch, check out that branch, run
``limatix-git add-processed -a`` to stage files for commit, ``git status``
to verify only processed output has been staged, and ``git commit`` to
perform the commit.


COMSOL-based VibroSim Workflow
------------------------------

The COMSOL-based VibroSim workflow follows roughly the conceptual
steps listed above, but the model creation is nominally all done
up-front (in reality the first few steps will be iterated to get
the model where it needs to be). 

The steps involved in a COMSOL-based VibroSim simulation are:
  1. Scripting COMSOL to create a geometric and physics model,
     including mounting, excitation position/couplant,
     vibration monitoring, and a healed internal boundary
     representing the crack, 
  2. Vibration analysis of sample including:

    a. Modal analysis
    b. Spectrum verification
    c. Frequency response calculation
    d. Generation of time-domain response. 

  3. Modeling of the vibrothermography excitation to evaluate
     response at the crack
  4. Prediction of heating power from response at the crack.
  5. Modeling of the heat from the crack conducting through the
     material to the surface. 

Troubleshooting
---------------
ProcessTrak error: FileNotFoundError in procstepmatlab_execfunc: 
   * The comsol binaries are not in the system path. Please add them to 
     the command path.
Warning from MATLAB about dataguzzler-lib/matlab or dc_unitsparam:
   * These are expected and nothing to worry about
Error from Matlab: Undefined function or variable 'InitializeVibroSimScript'.
   * This means VibroSim_COMSOL is not accessible from MATLAB. One way to 
     make it accessible is to install the VibroSim_COMSOL.mltbx as a MATLAB
     add-on. Another way is to set the MATLABPATH environment variable to 
     the VibroSim_COMSOL m_files subfolder. 
Error from processtrak: pkg_resources.DistributionNotFound
   * This usually means that the processtrak script was installed by a 
     different version of Python than the version of Python that is
     executing. Reinstall Limatix using your desired Python version.


Building the VibroSim_Simulator Documentation
----------------------------------------------

A rendered form of the VibroSim documentation is usually included 
in distributed VibroSim release archives. It can also be built using `Sphinx
<https://www.sphinx-doc.org/en/master/>`_. Documentation source code can be
found in the ``docs`` folder. Instructions for how to install Sphinx can be
found at their website.  Once Sphinx is installed an html version of the
documentation can be built using the makefile in the ``docs`` folder:

``make html``

Sphinx can also be used to create .pdf documentation using Latex:

``make latexpdf``

