% TESTIVM Run the IVM on sampled data.

generateData
d=400;
theta = [10 10 0.1 10];
innerIters = 100;
outerIters = 10;
[theta, activeSet] = ivmRun(X, y, theta, d, innerIters, outerIters)
ll = -neglikelihood(log(theta), testX, testY);
displayTasks(X, y, theta, activeSet);

