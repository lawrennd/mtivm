% ICMLMTREGRESSION Time the multi-task IVM and simple sub-sampling.


%/~
importTool('ivm');
%~/

generateMtRegressionData
numTrials = 10;
kernelType = 'sqexp';
noiseType = 'gaussian';
selectionCriterion = 'entropy';
display = 0;
prior = 0;
seed = 1e3;

% Run the multi-task IVM on the data.
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
    models.task(1).kern.inverseWidth = 10;
    models.task(1).kern.rbfVariance = 10;
    models.task(1).kern.whiteVariance = eps; 
    models.task(1).kern.biasVariance = 10;
    
    models = mtivmOptimise(models, prior, display, innerIters, outerIters);
    paramIVM{dnum, trials} = kernExtractParam(models.task(1).kern);
    timeIVM(dnum, trials) = cputime - initTime;
    KLIVM(dnum, trials) = 0;
    for i = 1:length(testX)
      K1 = kernCompute(trueKern, testX{i});
      [logdet1] = logdet(K1);
      ivmKern = kernExpandParam(trueKern, paramIVM{dnum, trials});
      K2 = kernCompute(ivmKern, testX{i});
      [logdet2, U2] = logdet(K2);
      invK2 = pdinv(K2, U2);
      
      val = -logdet1 + logdet2 +trace(K1*invK2) - size(K1, 1);
      KLIVM(dnum, trials) = KLIVM(dnum, trials) +  val/2;
    end
    fprintf('Trial iteration %d complete\n', trials)
    kernDisplay(ivmKern);
    fprintf('KL %2.4f Time %2.4f\n', KLIVM(dnum, trials), timeIVM(dnum, trials))
  end
  save('icmlMtRegressionResults.mat', 'timeIVM', 'paramIVM', 'dVec', 'KLIVM')
end

% Simply sub-sample the data and fit a multi-task Gaussian Process.
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
    paramSub{sampNum, trials} = kernExtractParam(models.task(1).kern);
    timeSub(sampNum, trials) = cputime - initTime;
    KLSub(dnum, trials) = 0;
    for i = 1:length(testX)
      K1 = kernCompute(trueKern, testX{i});
      [logdet1] = logdet(K1);
      subKern = kernExpandParam(trueKern, paramSub{dnum, trials});
      K2 = kernCompute(subKern, testX{i});
      [logdet2, U2] = logdet(K2);
      invK2 = pdinv(K2, U2);
      
      val = -logdet1 + logdet2 +trace(K1*invK2) - size(K1, 1);
      KLSub(dnum, trials) = KLSub(dnum, trials) + val/2;
    
    end
    fprintf('Trial iteration %d complete\n', trials)
    kernDisplay(ivmKern);
    fprintf('KL %2.4f Time %2.4f\n', KLSub(sampNum, trials), timeSub(sampNum, trials))
  end
  save('icmlMtRegressionResults.mat', 'timeIVM', 'timeSub', 'paramIVM', ...
       'paramSub', 'dVec', 'sampsVec', 'KLIVM', 'KLSub')
end

% COmpute KL divergences





icmlMtRegressionResults