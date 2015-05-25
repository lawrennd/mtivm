% TESTCODE Quick test of the code.

d = 100;
numIn = 1;
numTasks = 4;
numDataPerTask = 100*ones(1, 4);%[100 200 300 400];
% Theta is of the form [rbfInverseWidth, rbfMultiplier, noiseVariance, biasVariance]
theta = [1 1 0.01 0];
[X, y] = sampleDataClass(theta, numIn, numTasks, numDataPerTask);
theta = [10 10 10 10];
for i = 1:10
  [activeSet, Kstore, M] = ivmSelect(X, theta, d);
  theta = optimiseTheta(X, y, activeSet, M, theta, 10, 1);
  disp(theta)
end

lntheta = log(theta);
for task = 1:numTasks
  if isempty(activeSet{task})
    continue
  end
  
  A{task} = Kstore{task}(activeSet{task}, :) - M{task}(:, activeSet{task})'*M{task}(:, activeSet{task});
  
  invK = pdinv(Kstore{task}(activeSet{task}, :));
  fbar{task} = kernel(X{task}(activeSet{task}, :), lntheta, X{task}(activeSet{task}, :))*invK*y{task}(activeSet{task});
  figure, plot(X{task}(activeSet{task}), y{task}(activeSet{task}), 'rx');
  hold on
  errorbar(X{task}(activeSet{task}), fbar{task}, sqrt(diag(A{task})), 'bo');

end
