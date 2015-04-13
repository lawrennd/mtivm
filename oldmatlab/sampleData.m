function [X, y, K] = sampleData(theta, numIn, numTasks, numDataPerTask);

% SAMPLEDATA This function samples a dataset from a given covariance funciton
X = cell(1, numTasks);
K = cell(1, numTasks);
y = cell(1, numTasks);


lntheta = log(theta);

for task = 1:numTasks
  X{task} = zeros(numDataPerTask(task), numIn);
  X{task}(1:floor(numDataPerTask(task)/2), :) = ...
      randn(floor(numDataPerTask(task)/2), numIn)*.25+1;
  X{task}(floor(numDataPerTask(task)/2)+1:end, :) = ...
      randn(ceil(numDataPerTask(task)/2), numIn)*.25-1;
  
  K{task} = kernel(X{task}, lntheta);
  y{task} = gaussSamp(K{task}, 1)';
end
