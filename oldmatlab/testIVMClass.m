% TESTIVMCLASS Run the Classification IVM on sampled data.

generateDataClass
for task = 1:numTasks
  figure(task)
  clf, plot(X{task}(find(y{task}==1), 1), X{task}(find(y{task}==1), 2), 'rx');
  hold on, plot(X{task}(find(y{task}==-1), 1), X{task}(find(y{task}==-1), 2), 'bx')
end

d=400;
theta = [10 10 10 10];
innerIters = 100;
outerIters = 10;

for task = 1:numTasks
  bias{task} = invCummGaussian(sum(y{task}==1)/length(y{task}));
end
[theta, activeSet] = ivmRunClass(X, y, bias, ...
				 theta, d, innerIters, ...
				 outerIters)
%ll = -neglikelihood(log(theta), testX, testY);

for task = 1:numTasks
  figure(task)
  hold on, plot(X{task}(activeSet{task}, 1), X{task}(activeSet{task}, 2), 'o')
end