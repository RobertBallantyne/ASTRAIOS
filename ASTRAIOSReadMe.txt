This is a repository of the required functions for the ASTRAIOS program.

Overview:
ASTRAIOS was produced as a detect and avoid system for the ISS, but can be generalised for use in other satellites.

There are two main components, the detect system (detection.m) and the avoid system (control.m). These are run seperately as the detection system produces a graph showing the danger of potential orbits over 3 days (see report). From this a radial distance can be selected and input into the control system.

Installation:
Running the ASTRAIOS program requires several MATLAB and python packages.

A modern version of MATLAB is required as well as: Ephemeris Data for Aerospace Toolbox, Aerospace Toolbox, Parallel Computing Toolbox (only required if using parfor in the posFilter function).

Python 3.6 or above is required. The numpy, pandas and requests packages are required, as well as their respective pre-requisites.
The active python interpreter must also be set up on the computer's PATH so that MATLAB has access to it.

Running:
The first step is to input one's own login details for Space-Track.org.
Then the program must be let to run until the propagation stage, at this point one must manually remove all satellites that are attached to the ISS such as crew modules and resupplies. These are not removed automatically in the filtering process.
Continue the program until the final plot is produced, showing the probability of collision against change in radial position.

This should be sufficient to run this program, if there are any questions please do not hesitate to contact me.