ProcessTrak Steps
==================

The following are ProcessTrak steps that come with various components
of VibroSim.  All parameters listed in these steps must be
explicitly passed from the ``.prx`` file or found in the processed experiment 
log (``.xlp``) file. Parameters in the ``.xlp`` file can either 
come from the unprocessed experiment log (``.xlg``), or have been placed 
in the ``.xlp`` file as a return from one of the prior steps.

.. py:function:: vibrosim_synthetic_spectrum

    This ProcessTrak step will take the output of the modal analysis and
    calculate a spectrum. Each mode in the modal analysis is a peak in the
    spectrum, with the amplitude and bandwidth determined by the complex
    valued eigenfrequency.

    This ProcessTrak step is included in the ``VibroSim_Simulator`` software package.

    :param dc\:modalfreqs: |modalfreqs|
    :return dc\:modal_synthetic_spectrum: Synthetic spectrum figure.


.. py:function:: vibrocomsol_runmodal_comsol

    This ProcessTrak step will open COMSOL, run the modal analysis study, and
    save the results.

    The purpose of the modal analysis is to identify candidate resonant modes
    of the specimen. In vibrothermography testing you want to excite enough
    resonant modes that you will be pretty much guaranteed that any point in
    the specimen will have large strains in at least one of the modes. The
    modal analysis can be used to find these resonances. In experiments, this
    would be performed using a broadband frequency sweep across the entire
    range of possible excitation frequencies. 

    This ProcessTrak step is included in the ``VibroSim_Simulator`` software
    package.

    :param dc\:dest: |dest|
    :param dc\:measident: |measident|
    :param dc\:model_comsol: |model_comsol|

    :return dc\:modalcalc_comsol: |modalcalc_comsol|
    :return dc\:modalfreqs: |modalfreqs|


.. py:function:: vibrocomsol_createdummyoutput

    This ProcessTrak step will create a dummy heating data file. This needs to
    exist to create the COMSOL model. The ProcessTrak step
    :py:func:`vibrocomsol_calc_heating_welder` will populate this file with
    crack heating data. The ProcessTrak step
    :py:func:`vibrocomsol_heatflow_analysis_comsol` will use the data to analyze
    heat flows.

    This ProcessTrak step is included in the ``VibroSim_Simulator`` software package.

    :param dc\:dest: |dest|
    :param dc\:measident: |measident|

    :return dc\:dummy_heatingdata: |dummy_heatingdata|

.. py:function:: vibrocomsol_entersweepfreqs

    This ProcessTrak step will show the results of the modal analysis and ask
    the user to specify the range of frequencies to be run by a later
    ProcessTrak step (:py:func:`vibrocomsol_sweep_analysis_comsol`). If the
    returns of this ProcessTrak step are already defined in the experiment log
    (.xlp) then those predefined values are given as defaults for the user to
    accept. This would occur if this step has been run previously or if they
    are defined in the initial experiment log (.xlg).

    This ProcessTrak step is included in the ``VibroSim_Simulator`` software package.

    :param dc\:modalfreqs: |modalfreqs|
    :param dc\:modalcalc_comsol: |modalcalc_comsol|

    :return dc\:sweep_start_frequency: |sweep_start_frequency|
    :return dc\:sweep_step_frequency: |sweep_step_frequency|
    :return dc\:sweep_end_frequency: |sweep_end_frequency|

.. py:function:: vibrocomsol_setsweepfrequencies_comsol

    This ProcessTrak step will open COMSOL and set the parameters needed for
    the sweep analysis.
    
    This ProcessTrak step is included in the ``VibroSim_Simulator`` software package.

    :param dc\:dest: |dest|
    :param dc\:measident: |measident|
    :param dc\:model_comsol: |model_comsol|
    :param dc\:sweep_start_frequency: |sweep_start_frequency|
    :param dc\:sweep_step_frequency: |sweep_step_frequency|
    :param dc\:sweep_end_frequency: |sweep_end_frequency|

    :return dc\:model_comsol_withsweepfrequencies: |model_comsol_withsweepfrequencies|

.. py:function:: vibrocomsol_sweep_analysis_comsol

    This ProcessTrak step will open COMSOL, run the sweep analysis study, and
    save the results.

    The purpose of the frequency sweep is to do a more precise analysis than
    the modal analysis of specific candidate excitations over a range of
    frequencies. This is analogous to the narrowband sweeps that are performed
    in the vibrothermography process to identify the exact optimal excitation
    frequency for a particular resonant mode. 

    Identify the dominant frequency from the crack strain magnitude and
    vibrometer plots, and make note of this frequency for use in the tone-burst
    analysis. 

    This ProcessTrak step is included in the ``VibroSim_Simulator`` software package.

    :param dc\:dest: |dest|
    :param dc\:measident: |measident|
    :param dc\:model_comsol_withsweepfrequencies: |model_comsol_withsweepfrequencies|

    :return dc\:sweep_spectrum: |sweep_spectrum|

.. py:function:: vibrocomsol_enterburstfreq 

    This ProcessTrak step will show the results of the modal analysis and the
    sweep analysis, and then ask the user to specify the single frequency to be
    run by a later ProcessTrak step
    (:py:func:`vibrocomsol_burst_analysis_comsol`). If the returns of this
    ProcessTrak step are already defined in the experiment log (.xlp) then
    those values are given as defaults for the user to accept. This would occur
    if this step has been run previously or if they are defined in the initial
    experiment log (.xlg).
    
    This ProcessTrak step is included in the ``VibroSim_Simulator`` software package.

    :param dc\:modalfreqs: |modalfreqs|
    :param dc\:modalcalc_comsol: |modalcalc_comsol|
    :param dc\:sweep_spectrum: |sweep_spectrum|

    :return dc\:excitation_frequency: |excitation_frequency|

.. py:function:: vibrocomsol_setburstfrequency_comsol

    This ProcessTrak step will open COMSOL and set the burst frequency to be
    used in the :py:func:`vibrocomsol_burst_analysis_comsol` step.
    
    This ProcessTrak step is included in the ``VibroSim_Simulator`` software package.

    :param dc\:dest: |dest|
    :param dc\:measident: |measident|
    :param dc\:model_comsol: |model_comsol|
    :param dc\:excitation_frequency: |excitation_frequency|

    :return dc\:model_comsol_withburstfrequency: |model_comsol_withburstfrequency|


.. py:function:: vibrocomsol_burst_analysis_comsol

    This ProcessTrak step will open COMSOL, run the burst analysis study, and
    save the results. It will calculate the stress at the crack face, a
    critical component of the heating calculation. The burst frequency must be
    chosen from the results of the sweep analysis and injected into the model
    using the :py:func:`vibrocomsol_enterburstfreq` and
    :py:func:`vibrocomsol_setburstfrequency_comsol` processtrak steps.

    This ProcessTrak step is included in the ``VibroSim_Simulator`` software package.

    :param dc\:dest: |dest|
    :param dc\:measident: |measident|
    :param dc\:model_comsol_withburstfrequency: |model_comsol_withburstfrequency|

    :return dc\:burstcalc_comsol: |burstcalc_comsol|
    :return dc\:harmonicburst_normalstress: |harmonicburst_normalstress|
    :return dc\:harmonicburst_shearstressmajor: |harmonicburst_shearstressmajor|
    :return dc\:harmonicburst_shearstressminor: |harmonicburst_shearstressminor|

.. py:function:: vibrosim_calc_heating_singlefrequency

    This ProcessTrak step will calculate the heat generated by the crack when
    the sample is subjected to the burst excitation. 
    
    This ProcessTrak step is included in the ``VibroSim_Simulator`` software package.

    :param dc\:dest: |dest|
    :param dc\:measident: |measident|
    :param dc\:friction_coefficient: |friction_coefficient|
    :param dc\:msqrtR: |msqrtR|
    :param dc\:staticload: |staticload|
    :param dc\:tortuosity: |tortuosity|
    :param dc\:numdraws: |numdraws|
    :param dc\:YoungsModulus: |YoungsModulus|
    :param dc\:PoissonsRatio: |PoissonsRatio|
    :param dc\:YieldStrength: |YieldStrength|
    :param dc\:Density: |Density|
    :param dc\:crack_model_normal: |crack_model_normal|
    :param dc\:crack_model_shear: |crack_model_shear|
    :param dc\:crack_model_shear_factor: |crack_model_shear_factor|
    :param dc\:exc_t0: |exc_t0|
    :param dc\:exc_t1: |exc_t1|
    :param dc\:exc_t2: |exc_t2|
    :param dc\:exc_t3: |exc_t3|
    :param dc\:exc_t4: |exc_t4|
    :param dc\:excitation_frequency: |excitation_frequency|
    :param dc\:harmonicburst_normalstress: |harmonicburst_normalstress|
    :param dc\:harmonicburst_shearstressmajor: |harmonicburst_shearstressmajor|
    :param dc\:harmonicburst_shearstressminor: |harmonicburst_shearstressminor|
    :param dc\:crack_type_side1: |crack_type_side1|
    :param dc\:crack_type_side2: |crack_type_side2|
    :param dc\:crack_shearstress_axis: |crack_shearstress_axis|
    :param dc\:thickness: |thickness|
    :param dc\:closurestate_side1: |closurestate_side1|
    :param dc\:closurestate_side2: |closurestate_side2|
    :param dc\:a_side1: |a_side1|
    :param dc\:a_side2: |a_side2|

    :return dc\:heatpower: |heatpower|
    :return dc\:heatingdata: |heatingdata|
    :return dc\:heatingtotalpower: |heatingtotalpower|

.. py:function:: vibrocomsol_heatflow_analysis_comsol

    This Processtrak step will take the crack heating power data and project it
    along the crack in the COMSOL model. A heatflow study is performed to
    analyze the flow of heat in the specimen during the excitation time. The
    ``vibro_heating_image`` return is a snapshot of the heating data at the
    very end of the excitation. 

    This ProcessTrak step is included in the ``VibroSim_Simulator`` software package.

    :param dc\:dest: |dest|
    :param dc\:measident: |measident|
    :param dc\:model_comsol: |model_comsol|
    :param dc\:heatingdata: |heatingdata|
    :param dc\:exc_t3: |exc_t3|

    :return dc\:vibro_heating_image: |vibro_heating_image|
    :return dc\:heatflow_comsol: |heatflow_comsol|


.. py:function:: vibrosim_calc_heating_welder

    This processtrak step will call the angled friction model to determine the
    heating in each motion cycle as a function of position within the crack.

    This ProcessTrak step is included in the ``VibroSim_Simulator`` software package.

    :param dc\:dest: |dest|
    :param dc\:measident: |measident|
    :param dc\:friction_coefficient: |friction_coefficient|
    :param dc\:msqrtR: |msqrtR|
    :param dc\:staticload: |staticload|
    :param dc\:tortuosity: |tortuosity|
    :param dc\:numdraws: |numdraws|
    :param dc\:YoungsModulus: |YoungsModulus|
    :param dc\:PoissonsRatio: |PoissonsRatio|
    :param dc\:YieldStrength: |YieldStrength|
    :param dc\:Density: |Density|
    :param dc\:crack_model_normal: |crack_model_normal|
    :param dc\:crack_model_shear: |crack_model_shear|
    :param dc\:crack_model_shear_factor: |crack_model_shear_factor|
    :param dc\:exc_t0: |exc_t0|
    :param dc\:exc_t4: |exc_t4|
    :param dc\:motion: |motion|
    :param dc\:crack_type_side1: |crack_type_side1|
    :param dc\:crack_type_side2: |crack_type_side2|
    :param dc\:crack_shearstress_axis: |crack_shearstress_axis|
    :param dc\:thickness: |thickness|
    :param dc\:closurestate_side1: |closurestate_side1|
    :param dc\:closurestate_side2: |closurestate_side2|
    :param dc\:a_side1: |a_side1|
    :param dc\:a_side2: |a_side2|

    :return dc\:heatingdata: |heatingdata|
    :return dc\:heatingtotalpower: |heatingtotalpower|

.. py:function:: vibrosim_eval_closure_state_from_tip_positions
    
    This ProcessTrak step is used in vibrosim to evaluate crack closure state
    from crack tip positions given in an XML element. It is provided by the
    ``crackclosuresim2`` package.
    
    The crack closure state is given as four arrays interpreted as text
    within XML elements of the experiment log,
    e.g: ::

        <dc:reff_side1 dcv:units="m" dcv:arraystorageorder="C">
          <dcv:arrayshape>9</dcv:arrayshape>
          <dcv:arraydata>
            .5e-3 .7e-3 .9e-3 1.05e-3 1.2e-3 1.33e-3 1.45e-3 1.56e-3 1.66e-3
          </dcv:arraydata>
        </dc:reff_side1>
        <dc:seff_side1 dcv:units="Pa" dcv:arraystorageorder="C">
          <dcv:arrayshape>9</dcv:arrayshape>
          <dcv:arraydata>
            0.0 50e6 100e6 150e6 200e6 250e6 300e6 350e6 400e6
          </dcv:arraydata>
        </dc:seff_side1>
        
        <dc:reff_side2 dcv:units="m" dcv:arraystorageorder="C">
          <dcv:arrayshape>9</dcv:arrayshape>
          <dcv:arraydata>
            .5e-3 .7e-3 .9e-3 1.05e-3 1.2e-3 1.33e-3 1.45e-3 1.56e-3 1.66e-3
          </dcv:arraydata>
        </dc:reff_side2>
        <dc:seff_side2 dcv:units="Pa" dcv:arraystorageorder="C">
          <dcv:arrayshape>9</dcv:arrayshape>
          <dcv:arraydata>
            0.0 50e6 100e6 150e6 200e6 250e6 300e6 350e6 400e6
          </dcv:arraydata>
        </dc:seff_side2>
    
    The ``reff`` (effective tip radius) values are given in meters and the
    ``seff`` (corresponding normal stress) values are given in Pascals.
    The radius values should be listed in increasing order. The last
    radius value on each side (side1 - left or side2 - right) should
    correspond to the length of that side of the crack. 

    :param dc\:dest: |dest|
    :param dc\:measident: |measident|
    :param dc\:YoungsModulus: |YoungsModulus|
    :param dc\:PoissonsRatio: |PoissonsRatio|
    :param dc\:YieldStrength: |YieldStrength|
    :param dc\:reff_side1: |reff_side1|
    :param dc\:seff_side1: |seff_side1|
    :param dc\:reff_side2: |reff_side2|
    :param dc\:seff_side2: |seff_side2|
    :param dc\:crack_model_normal: |crack_model_normal|
    :param dc\:crack_model_shear: |crack_model_shear|

    :return dc\:closureplot_side1: |closureplot_side1| 
    :return dc\:closureplot_side2: |closureplot_side2| 
    :return dc\:closurestate_side1: |closurestate_side1| 
    :return dc\:closurestate_side2: |closurestate_side2| 
    :return dc\:a_side1: |a_side1| 
    :return dc\:a_side2: |a_side2| 
  

.. py:function:: vibrosim_plot_welder_motion
    
    This ProcessTrak step will plot the welder motion.

    Provided by the ``VibroSim_WelderModel`` package.
    
    :param dc\:dest: |dest|
    :param dc\:measident: |measident|
    :param dc\:motion: |motion|
    :param dc\:exc_t0: |exc_t0|

    :return plots: Welder motion plots.

.. py:function:: vibrosim_simulate_welder

    The processtrak step takes the desired weld profile and the pneumatic force
    and dynamic behavior of the welder and specimen and generates a motion
    table. It generates this table through a time based integration simulation
    of the repeated impacts of the welder.
    
    This step can be accelerated through the use of OpenCL. To use the GPU the
    device information needs to be passed to the processtrak step in the
    ``.prx`` file. Look in the ``cantilever_example.prx`` file for an example.

    Provided by the ``VibroSim_WelderModel`` package.

    :param dc\:dest: |dest|
    :param dc\:measident: |measident|
    :param dc\:dynamicmodel: |dynamicmodel|
    :param dc\:exc_t0: |exc_t0|
    :param dc\:exc_t1: |exc_t1|
    :param dc\:exc_t2: |exc_t2|
    :param dc\:exc_t3: |exc_t3|
    :param dc\:exc_t4: |exc_t4|
    :param dc\:mass_of_welder_and_slider: |mass_of_welder_and_slider|
    :param dc\:pneumatic_force: |pneumatic_force|
    :param dc\:welder_elec_ampl: |welder_elec_ampl|
    :param dc\:YoungsModulus: |YoungsModulus|
    :param dc\:PoissonsRatio: |PoissonsRatio|
    :param dc\:welder_spring_constant: |welder_spring_constant|
    :param dc\:R_contact: |R_contact|
    :param dc\:welder_elec_freq: |welder_elec_freq|
    :param dc\:contact_model_timestep: |contact_model_timestep|
    :param dc\:gpu_device_priority_list: |gpu_device_priority_list|
    :param dc\:gpu_precision: |gpu_precision|

    :return dc\:motion: |motion|


.. py:function:: vibrosim_process_multisweep

    This processtrak step will process the freq_band_analysis output to create
    a time-domain waveform. This time domain waveform, generated from the
    multiple sweeps of relevant frequencies to the system, represents the
    impulse response of the system. 

    Provided by the ``VibroSim_WelderModel`` package.

    :param dc\:dest: |dest|
    :param dc\:measident: |measident|
    :param dc\:seg1_xducercontactprobe_displ: |segX_xducercontactprobe_displ|
    :param dc\:seg1_xducercontactprobe_vel: |segX_xducercontactprobe_vel|
    :param dc\:seg1_laser_displ: |segX_laser_displ|
    :param dc\:seg1_laser_vel: |segX_laser_vel|
    :param dc\:seg1_crackcenterstress: |segX_crackcenterstress|
    :param dc\:seg2_xducercontactprobe_displ: |segX_xducercontactprobe_displ|
    :param dc\:seg2_xducercontactprobe_vel: |segX_xducercontactprobe_vel|
    :param dc\:seg2_laser_displ: |segX_laser_displ|
    :param dc\:seg2_laser_vel: |segX_laser_vel|
    :param dc\:seg2_crackcenterstress: |segX_crackcenterstress|
    :param dc\:seg3_xducercontactprobe_displ: |segX_xducercontactprobe_displ|
    :param dc\:seg3_xducercontactprobe_vel: |segX_xducercontactprobe_vel|
    :param dc\:seg3_laser_displ: |segX_laser_displ|
    :param dc\:seg3_laser_vel: |segX_laser_vel|
    :param dc\:seg3_crackcenterstress: |segX_crackcenterstress|
    :param dc\:seg4_xducercontactprobe_displ: |segX_xducercontactprobe_displ|
    :param dc\:seg4_xducercontactprobe_vel: |segX_xducercontactprobe_vel|
    :param dc\:seg4_laser_displ: |segX_laser_displ|
    :param dc\:seg4_laser_vel: |segX_laser_vel|
    :param dc\:seg4_crackcenterstress: |segX_crackcenterstress|
    :param dc\:endcrop: |endcrop|
                                                 
    :return dc\:dynamicmodel: |dynamicmodel|

.. py:function:: vibrocomsol_multisweep_seg_analysis_comsol

    This processtrak step will run one of the multiple sweep analyses
    prescribed by :py:func:`vibrosim_optimize_freqbands`.

    Provided by the ``VibroSim_Simulator`` package.

    :param dc\:dest: |dest|
    :param dc\:measident: |measident|
    :param dc\:model_comsol_withsegboundaries: |model_comsol_withsegboundaries|
    :param segnum_int: |segnum_int|

    :return dc\:segX_xducercontactprobe_displ: |segX_xducercontactprobe_displ|
    :return dc\:segX_xducercontactprobe_vel: |segX_xducercontactprobe_vel|
    :return dc\:segX_laser_displ: |segX_laser_displ|
    :return dc\:segX_laser_vel: |segX_laser_vel|
    :return dc\:segX_crackcenterstress: |segX_crackcenterstress|

.. py:function:: vibrocomsol_set_freqbands_comsol

    This ProcessTrak step opens a COMSOL file and sets the frequency bands for the multisweep study.

    Provided by the ``VibroSim_Simulator`` package.

    :param dc\:dest: |dest|
    :param dc\:measident: |measident|
    :param dc\:model_comsol: |model_comsol|
    :param dc\:freqband_seg1_start: |freqband_segX_start|
    :param dc\:freqband_seg1_step: |freqband_segX_step|
    :param dc\:freqband_seg1_end: |freqband_segX_end|
    :param dc\:freqband_seg2_start: |freqband_segX_start|
    :param dc\:freqband_seg2_step: |freqband_segX_step|
    :param dc\:freqband_seg2_end: |freqband_segX_end|
    :param dc\:freqband_seg3_start: |freqband_segX_start|
    :param dc\:freqband_seg3_step: |freqband_segX_step|
    :param dc\:freqband_seg3_end: |freqband_segX_end|
    :param dc\:freqband_seg4_start: |freqband_segX_start|
    :param dc\:freqband_seg4_step: |freqband_segX_step|
    :param dc\:freqband_seg4_end: |freqband_segX_end|

    :return dc\:model_comsol_withsegboundaries: |model_comsol_withsegboundaries|

.. py:function:: vibrosim_optimize_freqbands

    This ProcessTrak step optimizes the frequency bands for the ProcessTrak
    step :py:func:`vibrocomsol_multisweep_seg_analysis_comsol`. 

    Run this on output of modal analysis to interpret the modal decay
    coefficients and plan a three or four segment frequency domain calculation
    that will be invertable to a time-domain response. 

    This step prepares the model for a frequency sweep taken in multiple parts
    with varying time steps. The frequency bands are chosen to include the
    modes present in the modal analysis, and the frequency step is chosen to
    avoid aliasing. A large frequency step can be used for segments with modes
    that are expected to damp quickly, and small frequency steps can be used
    for segments with modes that damp slowly. Thereby removing the need for a
    small frequency step across the whole spectrum.

    :param dc\:modalfreqs: |modalfreqs|
    :param dc\:temporal_decay_divisor: |temporal_decay_divisor|
    :param dc\:spectral_decay_divisor: |spectral_decay_divisor|

    :return  dc\:freqband_seg1_start: |freqband_segX_start|
    :return  dc\:freqband_seg1_step: |freqband_segX_step|
    :return  dc\:freqband_seg1_end: |freqband_segX_end|
    :return  dc\:freqband_seg2_start: |freqband_segX_start|
    :return  dc\:freqband_seg2_step: |freqband_segX_step|
    :return  dc\:freqband_seg2_end: |freqband_segX_end|
    :return  dc\:freqband_seg3_start: |freqband_segX_start|
    :return  dc\:freqband_seg3_step: |freqband_segX_step|
    :return  dc\:freqband_seg3_end: |freqband_segX_end|
    :return  dc\:freqband_seg4_start: |freqband_segX_start|
    :return  dc\:freqband_seg4_step: |freqband_segX_step|
    :return  dc\:freqband_seg4_end: |freqband_segX_end|

.. |modalfreqs| replace:: Frequencies of the eigenmodes.
.. |modalcalc_comsol| replace:: Save file for the COMSOL model with modal results.
.. |dest| replace:: Results output folder.
.. |measident| replace:: Measurement identifier.
.. |model_comsol| replace:: Save file for the COMSOL model.
.. |dummy_heatingdata| replace:: Output file for heating data. Heating data is
   the heat power of the crack as a function of time and position on crack.

.. |sweep_start_frequency| replace:: Starting frequency for a sweep analysis.
.. |sweep_step_frequency| replace:: Frequency step for a sweep analysis.
.. |sweep_end_frequency| replace:: Ending frequency for a sweep analysis.
.. |model_comsol_withsweepfrequencies| replace:: Save file for the COMSOL model with sweep study results.

.. |sweep_spectrum| replace:: Sweep spectrum image.

.. |excitation_frequency| replace:: The frequency used to excite the specimen.
.. |model_comsol_withburstfrequency| replace:: Save file for the COMSOL model with burst study parameters.

.. |burstcalc_comsol| replace:: Save file for the COMSOL model with burst study results.
.. |harmonicburst_normalstress| replace:: Stress in the model at the crack center, normal to the crack face. (Mode I)
.. |harmonicburst_shearstressmajor| replace:: Shear stress in the model at the crack center, in the crack semi-major direction. (Mode II)
.. |harmonicburst_shearstressminor| replace:: Shear stress in the model at the crack center, in the crack semi-minor direction. (Mode III)

.. |friction_coefficient| replace:: Friction coefficient of the crack surface.
.. |msqrtR| replace:: Crack asperity density.
.. |staticload| replace:: Static bending opening load on crack.
.. |tortuosity| replace:: Crack tortuosity, standard deviation of the crack trajectory.
.. |numdraws| replace:: Crack tortuosity is a statistical distribution, this
   parameter defines how many draws to take at each position along the crack
   for calculating the crack heating.
.. |YoungsModulus| replace:: Youngs modulus of the material.
.. |PoissonsRatio| replace:: Poissons Ratio of the material. 
.. |YieldStrength| replace:: Yield strength of the material. 
.. |Density| replace:: Density of the material.
.. |crack_model_normal| replace:: Which crack closure model to use for normal loading. ``ModeI_throughcrack_CODformula`` or ``Tada_ModeI_CircularCrack_along_midline``.
.. |crack_model_shear| replace:: Which stick/slip model to use for shear loading. ``Fabrikant_ModeII_CircularCrack_along_midline``, ``ModeII_throughcrack_CSDformula``, or ``ModeIII_throughcrack_CSDformula``.
.. |crack_model_shear_factor| replace:: Sensitivity factor for shear vs normal heating.
.. |exc_t0| replace:: Start of excitation envelope ramp-up.
.. |exc_t1| replace:: End of excitation envelope ramp-up.
.. |exc_t2| replace:: Start of excitation envelope ramp-down.
.. |exc_t3| replace:: End of excitation envelope ramp down.
.. |exc_t4| replace:: End of excitation vibration calculation.
.. |crack_type_side1| replace:: Crack type of side1, can be ``halfthrough`` or ``quarterpenny``. 
.. |crack_type_side2| replace:: Crack type of side2, can be ``halfthrough`` or ``quarterpenny``. 
.. |crack_shearstress_axis| replace:: ``major`` (mode II) or ``minor`` (mode III) axis, defines the axis used to calculate shear heating.
.. |thickness| replace:: Thickness of the material at the crack, used only for ``halfthrough`` cracks. 
.. |closurestate_side1| replace:: Closure state, side 1. 
.. |closurestate_side2| replace:: Closure state, side 2. 
.. |a_side1| replace:: Semimajor axis length of side 1.
.. |a_side2| replace:: Semimajor axis length of side 2.

.. |heatpower| replace:: Heat power vs crack location figure.
.. |heatingdata| replace:: A .tsv file where the four columns are time (s), radius (m), side 1 heating (W/m^2), and side 2 heating (W/m^2).
.. |heatingtotalpower| replace:: Total heating power of the crack.

.. |motion| replace:: Table of motion of the tip position, contact force, crack stress, laser sense point, etc., resulting from the welder tip and specimen interaction. Multicolumn csv.
.. |vibro_heating_image| replace:: Snapshot of the heating specimen. 
.. |heatflow_comsol| replace:: Save file for the COMSOL model with heatflow study results.

.. |reff_side1| replace:: Effective tip radius array of crack side 1.
.. |seff_side1| replace:: Normal stress corresponding to tip radius array, side 1.
.. |reff_side2| replace:: Effective tip radius of crack side 2.
.. |seff_side2| replace:: Normal stress corresponding to tip radius array, side 2.
.. |closureplot_side1| replace:: Plot of the closure state, side 1.
.. |closureplot_side2| replace:: Plot of the closure state, side 2.

.. |dynamicmodel| replace:: Time-domain specimen stress and motion at transducer contact, laser, and crack locations 
.. |mass_of_welder_and_slider| replace:: Assumed mass of welder assembly.
.. |pneumatic_force| replace:: Pneumatic force behind the welder.
.. |welder_elec_ampl| replace:: Electrical excitation amplitude going into the welder. Not a calibrated value.
.. |welder_spring_constant| replace:: The springiness of the welder mounts.
.. |R_contact| replace:: Welder tip assumed Hertzian contact radius.
.. |welder_elec_freq| replace:: Frequency of the electrical welder excitation.
.. |contact_model_timestep| replace:: Timestep used in the contact model.
.. |gpu_device_priority_list| replace:: Prioritized list of gpus to use in place of cpu.
.. |gpu_precision| replace:: ``single`` or ``double``. 

.. |segX_xducercontactprobe_displ| replace:: Transducer contact probe displacement.
.. |segX_xducercontactprobe_vel| replace:: Transducer contact probe velocity.
.. |segX_laser_displ| replace:: Displacement at laser vibrometer spot. 
.. |segX_laser_vel| replace:: Velocity at laser vibrometer spot.
.. |segX_crackcenterstress| replace:: Crack center stress.
.. |endcrop| replace:: The amount of time in seconds to crop off the generated time domain waveforms to remove the anticausal portion of the signal.
.. |segnum_int| replace:: Segment number.

.. |freqband_segX_start| replace:: Starting frequency of a frequency band.
.. |freqband_segX_step| replace:: Step frequency of a frequency band.
.. |freqband_segX_end| replace:: End frequency of a frequency band.
.. |model_comsol_withsegboundaries| replace:: Save file for the COMSOL model with segment boundaries.

.. |temporal_decay_divisor| replace:: The factor by which the time domain impulse response should decay within the calculation period. Residual magnitudes past the calculation period implicitly wrap back and overlap with the impulse response, acting as interference.
.. |spectral_decay_divisor| replace:: The factor by which resonances outside a segment under construction must decay to by a segment boundary in order to be ignored when constructing the segment.
