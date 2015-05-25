% TIMEMETHODS Time the multi-task IVM and simple sub-sampling.

generateData
numTrials = 10;
initTheta = [10 10 10 10];

% Run the IVM
iters = 50;
dVec = [200 250 300 400 500 600 700 800 900 1000];
for i = 1:length(dVec)
  d = dVec(i);
  fprintf('Size of active set %d\n', d)
  for trials = 1:numTrials
    tic;
    [thetaIVM{i, trials}, activeSet] = ivmRun(X, y, initTheta, d, iters, 5);
    timeIVM(i, trials) = toc;
    llIVM(i, trials) = -neglikelihood(log(thetaIVM{i, trials}), testX, testY);
    fprintf('Trial iteration %d complete\n', trials)
    fprintf('Theta %2.4f \n', thetaIVM{i, trials})
    fprintf('Likelihood %2.4f Time %2.4f\n', llIVM(i, trials), timeIVM(i, trials))
  end
end

% Simply sub-sample
iters = 200;
sampsVec = [150 200 250 300 350 400 450 500 550 600];
for i = 1:length(sampsVec); 
  samps = sampsVec(i);
  fprintf('Number of samples %d\n', samps)
  for trials = 1:numTrials
    for task = 1:numTasks
      indices = randperm(numDataPerTask(task));
      Xsamp{task} = X{task}(indices(1:samps), :);
      ysamp{task} = y{task}(indices(1:samps), :);
    end
    tic;
    thetaSub{i, trials} = gpRun(Xsamp, ysamp, initTheta, iters);
    timeSub(i, trials) = toc;
    llSub(i, trials) = -neglikelihood(log(thetaSub{i, trials}), testX, testY);
    fprintf('Trial iteration %d complete\n', trials)
    fprintf('Theta %2.4f \n', thetaSub{i, trials})
    fprintf('Likelihood %2.4f Time %2.4f\n', llSub(i, trials), timeSub(i, trials))
    %    displayTasks(Xsamp, ysamp, thetaSub);
  end
end


save('timeResults.mat', 'timeIVM', 'timeSub', 'llIVM', 'llSub', 'thetaIVM', ...
     'thetaSub', 'dVec', 'sampsVec')


plotTimeComparisonResults