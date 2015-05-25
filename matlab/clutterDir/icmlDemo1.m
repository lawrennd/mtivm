% ICMLDEMO1 Sample from single task GP for ICML talk.

rand('seed', 1e6)
randn('seed', 1e6)
X = rand(200, 1)*2 - 1;
X = sort(X);
kern = kernel(X, {'rbf', 'white'});
kern.comp{1}.inverseWidth = 10;
kern.comp{2}.variance = 1e-6;
kern.whiteVariance = kern.comp{2}.variance;
figure, hold on
%for i = 1:4
  X = rand(200, 1)*2 - 1;
  X = sort(X);
  K = kernCompute(kern, X);
  
  y = gaussSamp(K,  4);

  plot(X, y, '-', 'linewidth', 3);
%end
set(gca, 'fontname', 'arial')
set(gca, 'fontsize', 20)
zeroAxes(gca, 0.02, 20, 'arial');
  