ReadMe file for the MTIVM toolbox version 0.13 Monday, July 12, 2004 at 19:40:27
Written by Neil D. Lawrence.

License Info
------------

This software is free for academic use. Please contact Neil Lawrence if you are interested in using the software for commercial purposes.

This software must not be distributed or modified without prior permission of the author.


This is the MT-IVM toolbox. 

Unfortunately the software here will not recreate the experiments in the ICML paper as, due to the anonymous submission procedure I failed to freeze the code after submission. My apologies for this.

The original ICML version relied on old IVM code that predates the version on the web. This version relies on the new IVM toolbox which is a lot more modular.

This code relies on the IVM toolbox vs 0.31. You can use your username and password to download this toolbox from http://www.dcs.sheffield.ac.uk/~neil/ivm/downloadFiles/vrs0p31.

File Listing
------------

generateMtRegressionData.m: Tries to load a muti-task regression sampled data set otherwise generates it.
generateVowelData.m: Produces vowel data in matlab format.
gpMtRun.m: Run a multi-task GP.
icmlClassification.m: Run the vowel demos for icml paper.
icmlClassificationResults.m: Plot the classificaiton results for ICML paper.
icmlMtRegression.m: Time the multi-task IVM and simple sub-sampling.
icmlMtRegressionResults.m: Prepare comparision plots of the IVM vs sub-sampling.
icmlMtVowelDemo.m: Recreate ICML experiment of multi-task IVM for classification of vowels.
icmlRegressionResults.m: Prepare comparision plots of the IVM vs sub-sampling.
icmlSampVowelDemo.m: Try sub sampling for the point sets for classification of vowels.
icmlToySine.m: A small demo for icml paper of the multi-task IVM.
icmlVowelDemo.m: Try the IVM for classification of vowels.
mtivm.m: Initialise an multi-task ivm model.
mtivmDisplay.m: Display the mtivm model.
mtivmKernelGradient.m: Gradient on likelihood approximation for multi-task IVM.
mtivmKernelObjective.m: Likelihood approximation for multi-task IVM.
mtivmOptimise.m: Optimise the multi-task IVM.
mtivmOptimiseIVM.m: Does point selection for a point-set IVM model.
mtivmOptimiseKernel.m: Optimise the kernel parameters.
mtivmOptimiseNoise.m: Optimise the noise parameters.
mtivmRun.m: Run multi-task IVM on a data-set.
