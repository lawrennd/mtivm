MTIVM software
Version 0.14		Sunday 20 Nov 2005 at 20:59
Copyright (c) 2005 Neil D. Lawrence

This is the MT-IVM toolbox. 

Unfortunately the software here will not exactly recreate the experiments in the ICML paper as, due to the anonymous submission procedure I failed to freeze the code after submission. My apologies for this.

The original ICML version relied on old IVM code that predates the version on the web. This version relies on the new IVM toolbox which is a lot more modular.

This code relies on the IVM toolbox vs 0.31. You can use your username and password to download this toolbox from http://www.dcs.sheffield.ac.uk/~neil/ivm/downloadFiles/. Additionally you will require the drawing toolbox, available from http://www.dcs.shef.ac.uk/~neil/drawing/downloadFiles/.

Finally you will also need the NETLAB toolbox (http://www.ncrg.aston.ac.uk/netlab/) in your path.

Version 0.14
------------

Thanks to Kevin Murphy for pointing out some bugs, including the failure of icmlClassification.m to run. The bug occured when no points from a particular task were selected (i.e. the task was considered uninformative) and the algorithm tried to measure the likelihood of that task.

MATLAB Files
------------

Matlab files associated with the toolbox are:

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
