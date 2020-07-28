Tutorial
==================

Lets look in depth at ``vibrosim_demo3`` in the examples folder. This example
has three files associated with it, ``vibrosim_demo3.prx`` (processing steps),
``vibrosim_demo3.xlg`` (parameter storage), and ``vibrosim_demo3_comsol.m``
(matlab file for creating the COMSOL model).  

The ``.prx`` file contains the processing steps to be performed with the model.
It is managed by the software tool called ``processtrak``, a part of
``Limatix``.

Use the tool in the following way:

``processtrak <args> vibrosim_demo3.prx``

The following are possible arguments.

1. ``-s <steps>`` : Run only listed steps (multiple OK) 
2. ``-a`` : Run all steps
3. ``-i`` : Use ipython interactive mode to execute script
4. ``--needed`` : Filter down steps and input files according to what "needs"
    to be run -- i.e. missing or out-of-order steps, etc. DOES NOT PERFORM
    PROVENANCE VERIFICATION

Running this command: 

``processtrak --status vibrosim_demo3.prx``

produces the following output::

    Input file: vibrosim_demo3.xlg
    ---------------------------
               copyinput NOT_EXECUTED NEEDED
             dummyoutput NOT_EXECUTED NEEDED
              buildmodel NOT_EXECUTED NEEDED
                runmodal NOT_EXECUTED NEEDED
      synthetic_spectrum NOT_EXECUTED NEEDED
         entersweepfreqs NOT_EXECUTED NEEDED
     setsweepfrequencies NOT_EXECUTED NEEDED
          sweep_analysis NOT_EXECUTED NEEDED
          enterburstfreq NOT_EXECUTED NEEDED
       setburstfrequency NOT_EXECUTED NEEDED
          burst_analysis NOT_EXECUTED NEEDED
    eval_closure_state_from_tip_positions NOT_EXECUTED NEEDED
    calc_heating_singlefrequency NOT_EXECUTED NEEDED
       heatflow_analysis NOT_EXECUTED NEEDED

None of the steps have been run yet, so they all have the same ``NOT_EXECUTED``
and ``NEEDED`` tags. 

Now we can run the first step with the following command:

``processtrak vibrosim_demo3.prx -s copyinput``::

    Processing step copyinput on vibrosim_demo3.xlg->vibrosim_demo3.xlp

``processtrak --status vibrosim_demo3.prx``::

	Input file: vibrosim_demo3.xlg
	---------------------------
	           copyinput     2020-06-18T13:48:49.707642-05:00 
	         dummyoutput NOT_EXECUTED NEEDED
	          buildmodel NOT_EXECUTED NEEDED
	            runmodal NOT_EXECUTED NEEDED
	  synthetic_spectrum NOT_EXECUTED NEEDED
	     entersweepfreqs NOT_EXECUTED NEEDED
	 setsweepfrequencies NOT_EXECUTED NEEDED
	      sweep_analysis NOT_EXECUTED NEEDED
	      enterburstfreq NOT_EXECUTED NEEDED
	   setburstfrequency NOT_EXECUTED NEEDED
	      burst_analysis NOT_EXECUTED NEEDED
	eval_closure_state_from_tip_positions NOT_EXECUTED NEEDED
	calc_heating_singlefrequency NOT_EXECUTED NEEDED
	   heatflow_analysis NOT_EXECUTED NEEDED

Now that the ``copyinput`` step has been executed, it is no longer ``needed``
and the timestamp of the step has been recorded. This data is kept in the
``.xlp`` file.

The ``copyinput`` step is always present and represents a near verbatim copy of
the unprocessed ``.xlg`` experiment log to a "processed" ``.xlp`` experiment log. The only initial difference is the addition of provenance (step execution) information to the ``.xlp``.  Subsequent steps will operate on the ``.xlp`` adding processed results and hyperlinks to generated output files. If you make minor changes to the ``.xlg`` and want to merge those changes into the ``.xlp`` without wiping all of the generated output you can run the ``mergeinput`` step instead of ``copyinput``. 

The steps (except for ``copyinput`` / ``mergeinput``) are specified in the ``.prx`` file. When you run a step, it uses parameters explicitly specified in the ``.prx`` step definition as well as implicitly identifying the remaining paramters from the ``.xlp`` experiment log. The step then returns values which are added to the experiment log. The parameters and returns are documented in the "ProcessTrak Steps" chapter below. 

The next step is the ``dummyoutput`` step. The heat flow portion of the COMSOL model requires a heat distribution input in order to successfully build the model. The ``dummyoutput`` step creates a heat distribution that is zero to satisfy COMSOL. You can run this step with: 

``processtrak vibrosim_demo3.prx -s dummyoutput``

The ``dummyoutput`` step in the ``.prx`` file is specifed as: 

``<prx:script name="vibrocomsol_createdummyoutput.py"/>``

The ``name=`` attribute means to search for this script in the processtrak
search path (if you wanted to provide an explicit path you would use
``xlink:href=`` instead). This particular script is installed by the
``VibroSim_Simulator`` package and its source is in the ``VibroSim_Simulator/pt_steps`` subdirectory. As documented below, it takes two parameters from the experiment log: ``dc:dest`` -- the results output location -- and ``dc:measident`` the identifier of the particular simulation run. It then returns (adds to the processed experiment log) ``dc:dummy_heatingdata``, which is a hyperlink 
(following the `XLink standard <https://www.w3.org/TR/xlink11/>`_) to the 
generated dummy heating input file for COMSOL. If you view the ``.xlp`` file
in a text or XML editor after running this step you should be able to find the new
``dc:dummy_heatingdata`` element. The ``dc:dummy_heatingdata`` element will be used as a parameter by the ``buildmodel`` step indicating where the initial heating data is stored.

Steps can be written in Python ``.py``, MATLAB ``.m``, or MATLAB/COMSOL ``_comsol.m``. The next step is ``buildmodel``, which is a custom MATLAB/COMSOL script (referenced explicitly by ``xlink:href=`` instead of being found in the search path). The ``_comsol`` portion of the filename is important because it tells ProcessTrak to run the MATLAB script in the COMSOL environment. 

NOTE: When running a COMSOL step for the first time it is common for it to ask for a username and password. These are just for communication between the COMSOL server and client on your own computer and they are remembered automatically so they do not really matter, but they might be worth writing down. Do not re-use an important password for the COMSOL server. 

Parameters expected by a MATLAB or MATLAB/COMSOL step are listed in the commented first line of the file, similar to how they would be defined for a MATLAB function. For example::

  % function ret = vibrosim_demo3_comsol(dc_dest_href,dc_measident_str,dc_dummy_heatingdata_href,dc_amplitude_float,dc_staticload_mount_float,dc_spcmaterial_str,dc_YoungsModulus_float, dc_YieldStrength_float, dc_PoissonsRatio_float, dc_Density_float,dc_spcThermalConductivity_float, dc_spcSpecificHeatCapacity_float,dc_spcrayleighdamping_alpha_float,dc_spcrayleighdamping_beta_float, dc_exc_t0_float, dc_exc_t4_float, dc_simulationcameranetd_float,dc_cracksemimajoraxislen_float,dc_cracksemiminoraxislen_float,dc_crack_type_side1_str,dc_crack_type_side2_str)

The third parameter ``dc_dummy_heatingdata_href`` instructs ProcessTrak to find a entry ``dc:dummy_heatingdata`` in the processed experiment log (``.xlp``), to interpret it as a hypertext reference (``xlink:href``) and store the value in the MATLAB variable ``dc_dummy_heatingdata_href``. Parameters to Python steps work similarly and are defined by the parameters to the ``run()`` function within the step. 

Steps can be run in interactive mode with the ``-i`` option to ``processtrak``. 
``processtrak vibrosim_demo3.prx -s buildmodel -i``

This will cause the step to execute up to any errors or completion 
and leave an interactive environment. You can then evaluate 
variables, copy/paste code, etc. In MATLAB you can rerun the script 
just by typing its name. For COMSOL/MATLAB steps you can also externally 
run ``comsol mphclient`` and use the "Connect to Server" option to interact
graphically with the COMSOL model. When you are done, type ``eval(retcommand)`` (MATLAB) or press Ctrl-D (Python) to store the step output and move on. 

The generated output from a COMSOL/MATLAB step will usually be saved in the ``_output`` subdirectory. You can load generated ``.mph`` files directly into the COMSOL GUI. In some cases temporary output ``.mph`` files are left under the system temporary directory (usually ``/tmp`` or ``c:\temp``) with only reprocessed output stored in the ``_output`` subdirectory. 

Steps can be run out of order, as long as the ``.xlp`` has everything that is needed for the step. If needed inputs are not present, the step will fail. Obviously running steps out of order can cause inconsistencies in the final results if you are not careful. 

``processtrak vibrosim_demo3.prx -s entersweepfreqs``

``processtrak --status vibrosim_demo3.prx``::

	Input file: vibrosim_demo3.xlg
	---------------------------
	           copyinput     2020-06-18T13:48:49.707642-05:00 
	         dummyoutput NOT_EXECUTED NEEDED
	          buildmodel NOT_EXECUTED NEEDED
	            runmodal NOT_EXECUTED NEEDED
	  synthetic_spectrum NOT_EXECUTED NEEDED
         entersweepfreqs     2020-06-18T13:53:03.368990-05:00  FAILURE NEEDED
	 setsweepfrequencies NOT_EXECUTED NEEDED
	      sweep_analysis NOT_EXECUTED NEEDED
	      enterburstfreq NOT_EXECUTED NEEDED
	   setburstfrequency NOT_EXECUTED NEEDED
	      burst_analysis NOT_EXECUTED NEEDED
	eval_closure_state_from_tip_positions NOT_EXECUTED NEEDED
	calc_heating_singlefrequency NOT_EXECUTED NEEDED
	   heatflow_analysis NOT_EXECUTED NEEDED

All steps will be run from scratch if the following command is run:

``processtrak vibrosim_demo3.prx -a``

All steps with the ``NEEDED`` flag will be run with the following command:

``processtrak vibrosim_demo3.prx -a --needed``

Once all of the steps have been run, you can see the final output 
(hyperlinked in vibrosim_demo3.xlp) by loading the heatflow 
COMSOL model ``vibrosim_demo3_output/meas1_heating.mph``, opening
the ``Results`` tree and looking at the ``vibro_heating_plot``. You 
can drag the model around, select different times to view the heating, 
etc. There is also a snapshot of this plot that should be saved 
in ``vibrosim_demo3_output/meas1_heating.png``. 

In general VibroSim saves output after each step. In many cases these
are plots, .csv's, etc.  All output is written in standard or text
based formats where possible (sometimes compressed by default
e.g. with bzip2) In addition, temporary COMSOL models are sometimes
written to the system temporary directory (profile/AppData/Local/Temp
on Windows) -- these can occasionally be useful when troubleshooting.
See the reference manual for more detailed information on individual 
step outputs. 


Summary of vibrosim_demo3 files
===============================

``vibrosim_demo3.prx``
----------------------
Lists the set of steps to be run and lists the experiment logs (``.xlg``) on
which those steps should be run. 

``vibrosim_demo3.xlg``
----------------------

A ``.xlg`` contains the unprocessed experiment log. ``processtrak`` is
primarily a tool for processing data collected in an experiment, after all. It
contains all the parameters necessary to start the simulation. The first step
in a simulation is to copy the ``.xlg`` into a processed experiment log
``.xlp`` file. This new ``.xlp`` file contains all the parameters in the
``.xlg``, all parameters and results of ``processtrak`` steps, and tracking
information about when each step was run and if it completed properly.

``.xlg`` files are ``xml`` based, meaning they are hierarchical in nature. It
is a single ``experiment`` tag with multiple ``measurement`` tags. Parameters
that are consistent for a number of simulations can be stored under the
``experiment`` tag, thus making them global. These parameters can be
overwritten  in the ``measurement`` tags, allowing the user to run multiple
simulations with slightly varying input parameters. For example::

    <dc:experiment xmlns:dc="http://limatix.org/datacollect" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:dcv="http://limatix.org/dcvalue" xmlns:prx="http://limatix.org/processtrak/processinginstructions">
        <dc:measident>meas1</dc:measident> <!-- measident is used as a filename prefix for the various output files generated -->
        <dc:measurement>
            <dc:measident>meas1_direct_singlefreq</dc:measident>
            <dc:heatcalctype>singlefrequency</dc:heatcalctype>
            ...
        </dc:measurement>
        <dc:measurement>
            <dc:measident>meas1_via_weldercalc</dc:measident>
            <dc:heatcalctype>welder</dc:heatcalctype>
            ...
        </dc:measurement>
    </dc:experiment>  

``vibrosim_demo3_comsol.m``
---------------------------

This file contains all instructions necessary to build the COMSOL model for use
in VibroSim_Simulator. There are examples of this in the examples folder. In
depth information about how these files work can be found in the documentation
of the sister software package ``VibroSim_COMSOL``.


Listing of Examples
===================

vibrosim_demo3.prx
------------------
This basic demonstration uses as an example a simple surface crack in a 
bar-shaped test specimen. It is programmed for broadband (sweep and tuned 
toneburst) excitation.

vibrosim_demo3_crosscheck.prx
-----------------------------
This example, otherwise similar to ``vibrosim_demo3.prx``, demonstrates cross checking the ``calc_heating_singlefrequency`` step against the combined ``calc_singlefrequency_motion`` and ``calc_heating_welder`` steps that together have the same effect. To perform the cross-checking, it demonstrates the use of sub-measurements and multiple ``<prx:elementmatch>`` criteria to operate different steps on different sub-measurements. 


vibrosim_demo4.prx
------------------
This basic demonstration illustrates testing a simple edge crack in a bar. It is programmed
for broadband (sweep and toneburst) excitation.

cantilever_example.prx
----------------------
This basic demonstration tests a cantilever with one fixed end and a surface crack, excited with
an ultrasonic welder. 

cantilever_example_viscousdamping.prx
-------------------------------------
This example extends ``cantilever_example.prx`` with a more physically meaningful but more complicated damping model, including
prediction of radiative vibration losses into the cantilever mount. 

complex_model_demo.prx
----------------------
This example demonstrates simulating a cracked gear. It demonstrates the use of the COMSOL CAD import module to load in a CAD 
cross-section profile to COMSOL that is revolved, mirrored, etc. and then meshed. The example uses ultrasonic welder excitation.

