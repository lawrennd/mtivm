function models = mtivmRun(XTrain, yTrain, kernelType, noiseType, ...
			selectionCriterion, dVal, prior, display, innerIters, ...
			   outerIters)

% MTIVMRUN Run multi-task IVM on a data-set.

% MTIVM

% Intitalise IVM
models = mtivm(XTrain, yTrain, kernelType, noiseType, selectionCriterion, dVal);
models = mtivmOptimise(models, prior, display, innerIters, outerIters);
