% ICMLTOYSINE A small demo for icml paper of the multi-task IVM.

% MTIVM

seed = 1e4;
display = 0;
innerIters = 100; % Number of scg iterations
outerIters = 4;

kernelType = 'rbf';
noiseType = 'gaussian';
selectionCriterion = 'entropy';

d = 15; 

X{1} = [randn(15, 1)*0.03 - 1; randn(15, 1)*0.03+1]*10;
X{2} = randn(30, 1)*2;
X{3} = (rand(30, 1)-.5)*30;
noiseLevel = 0.1;
y{1} = cos(pi/2*X{1}/10) + randn(30, 1)*noiseLevel;
y{2} = sin(pi/2*X{2}/10) + randn(30, 1)*noiseLevel;
y{3} = -sin(pi/2*X{3}/10) + randn(30, 1)*noiseLevel;

models = mtivm(X, y, kernelType, noiseType, selectionCriterion, d);
models = mtivmOptimiseIVM(models, 1);


offset = 0.015*30;
fontName = 'times';
fontSize = 28;

figure(1)
  clf
[xvals, yvals] = fplot('cos(pi/2*x/10)', [-15 15]);
a = plot(xvals, yvals, 'linewidth', 1, 'color', [0 1 0]);
set(a, 'linewidth', 2)
hold on
figure(2)
  clf
[xvals, yvals] = fplot('sin(pi/2*x/10)', [-15 15]);
a = plot(xvals, yvals, 'linewidth', 1, 'color', [0 1 0]);
set(a, 'linewidth', 2)
hold on
figure(3)
  clf
[xvals, yvals] = fplot('-sin(pi/2*x/10)', [-15 15]);
a = plot(xvals, yvals, 'linewidth', 1, 'color', [0 1 0]);
set(a, 'linewidth', 2)
hold on
for taskNo = 1:3
  figure(taskNo)
  cros = plot(X{taskNo}, y{taskNo}, 'rx');
  set(cros, 'linewidth', 3);
  set(cros, 'markersize', 10);
  
  set(gca, 'ylim', [-1.2 1.2], ...
	   'fontSize', fontSize, ...
	   'fontname', fontName, ...
	   'xtick', [-15  -5 0 5 15], ...
	   'ytick', [-1 0 1]);
  
  zeroAxes(gca, 0.025, 18, 'arial')
  pos = get(gca, 'position')
  pos(4) = pos(4)/2;
  set(gca, 'position', pos)
  print('-depsc', ['../tex/diagrams/demToySine' num2str(taskNo)])
end
taskCount = zeros(3, 1);
for i = 1:length(models.taskOrder)
  taskNo = models.taskOrder(i);
  figure(taskNo);
  taskCount(taskNo) = taskCount(taskNo) + 1;
  x = X{taskNo}(models.task(taskNo).I(taskCount(taskNo)));
  yval = y{taskNo}(models.task(taskNo).I(taskCount(taskNo)));
  a = plot(x, yval, 'o');
  set(a, 'markersize', 15, 'linewidth', 2)
  set(a, 'erasemode', 'xor')
  %    b = text(x+offset, yval, num2str(kVals(i)));
  %    set(b, 'fontName', fontName, 'fontSize', fontSize);
  pause
  fileName = [num2str(taskNo) '_' num2str(i)];
  print('-depsc', ['../tex/diagrams' fileName])
end
for i = 1:3
  figure(i)
     % make smaller for PNG plot.
   pos = get(gcf, 'paperposition')
   origpos = pos;
   pos(3) = pos(3)/2;
   pos(4) = pos(4)/2;
   set(gcf, 'paperposition', pos);
   fontsize = get(gca, 'fontsize');
   set(gca, 'fontsize', fontsize/2);
   lineWidth = get(gca, 'lineWidth');
   set(gca, 'lineWidth', lineWidth*2);
   fileName = ['demSine' num2str(i)];
   print('-dpng', ['../html/' fileName])
   set(gcf, 'paperposition', origpos);
   set(gca, 'fontsize', fontsize);
   set(gca, 'lineWidth', lineWidth);
end