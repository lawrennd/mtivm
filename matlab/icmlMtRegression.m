% ICMLMTREGRESSION Time the point-set IVM and simple sub-sampling.

% MTIVM


%/~
importTool('ivm');
%~/

generateMtRegressionData
numTrials = 10;
initParam = [10 10 10 10];
kernelType = 'rbf';
noiseType = 'gaussian';
selectionCriterion = 'entropy';
display = 0;
prior = 0;
seed = 1e3;

% Run the Point set IVM on the data.
innerIters = 50;
outerIters = 5;
dVec = [200 250 300 400 500 600 700 800 900 1000]; 
for dnum = 1:length(dVec)
  randn('seed', seed)
  rand('seed', seed)
  d = dVec(dnum);
  fprintf('Size of active set %d\n', d)
  for trials = 1:numTrials
    initTime = cputime;
    models = mtivm(X, y, kernelType, noiseType, selectionCriterion, d);
    models.task(1).kern = kernExpandParam(log(initParam), models.task(1).kern);
    models = mtivmOptimise(models, prior, display, innerIters, outerIters);
    paramIVM{dnum, trials} = kernExtractParam(models.task(1).kern);
    timeIVM(dnum, trials) = cputime - initTime;

    testModels = mtivm(testX, testY, kernelType, noiseType, 'none', []);
    testModels.lnparam = models.lnparam;
    testModels = mtivmInit(testModels);
    llIVM(dnum, trials) = -mtkernelObjective(log(paramIVM{dnum, trials}), testModels, prior); %testX, ...
%					  testY, 0);
    fprintf('Trial iteration %d complete\n', trials)
    fprintf('Param %2.4f \n', paramIVM{dnum, trials})
    fprintf('Likelihood %2.4f Time %2.4f\n', llIVM(dnum, trials), timeIVM(dnum, trials))
  end
end

% Simply sub-sample the data and fit a point set Gaussian Process.
iters = 200;
sampsVec = [150 200 250 300 350 400 450 500 550 600];
numTasks = length(X);
for sampNum = 1:length(sampsVec); 
  randn('seed', seed)
  rand('seed', seed)
  samps = sampsVec(sampNum);
  fprintf('Number of samples %d\n', samps)
  for trials = 1:numTrials
    for task = 1:numTasks
      indices = randperm(size(X{task}, 1));
      Xsamp{task} = X{task}(indices(1:samps), :);
      ysamp{task} = y{task}(indices(1:samps), :);
    end
    initTime = cputime;
    models =  gpMtRun(Xsamp, ysamp, kernelType, noiseType, ...
					initParam, prior, display, iters);
    paramSub{sampNum, trials} = exp(models.lnparam);
    testModels = mtivm(testX, testY, kernelType, noiseType, 'none', []);
    testModels.lnparam = models.lnparam;
    testModels = mtivmInit(testModels);
    llSub(sampNum, trials) = -mtkernelObjective(log(paramSub{sampNum, trials}), testModels, prior); %testX, ...

    timeSub(sampNum, trials) = cputime - initTime;
    llSub(sampNum, trials) = -mtkernelObjective(log(paramSub{sampNum, ...
		    trials}), testModels);
    fprintf('Trial iteration %d complete\n', trials)
    fprintf('Param %2.4f \n', paramSub{sampNum, trials})
    fprintf('Likelihood %2.4f Time %2.4f\n', llSub(sampNum, trials), timeSub(sampNum, trials))
    %    displayTasks(Xsamp, ysamp, paramSub);
  end
end


save('icmlMtRegressionResults.mat', 'timeIVM', 'timeSub', 'llIVM', 'llSub', 'paramIVM', ...
     'paramSub', 'dVec', 'sampsVec')


icmlRegressionResults