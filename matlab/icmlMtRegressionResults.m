% ICMLMTREGRESSIONRESULTS Prepare comparision plots of the IVM vs sub-sampling.

printMe = 0;

fontName = 'times';
fontSize = 32;

load mtRegressionData.mat
load icmlMtRegressionResults.mat

KLMeanSub = repmat(NaN, length(sampsVec), 1);
KLVarSub = repmat(NaN, length(sampsVec), 1);
timeMeanSub = repmat(NaN, length(sampsVec), 1);

% Ignore first sub value
for i = 1:length(sampsVec)
    KLMeanSub(i) = mean(KLSub(i, :));
    KLVarSub(i) = var(KLSub(i, :));
    timeMeanSub(i) = mean(timeSub(i, :));
end
KLMeanIVM = repmat(NaN, length(dVec), 1);
KLVarIVM = repmat(NaN, length(dVec), 1);
timeMeanIVM = repmat(NaN, length(dVec), 1);
% Ignore the first two d values as they have v big errorbars and confuse
% the plot
for i = 4:length(dVec)
    KLMeanIVM(i) = mean(KLIVM(i, :));
    KLVarIVM(i) = var(KLIVM(i, :));
    timeMeanIVM(i) = mean(timeIVM(i, :));
end


numTestTasks = length(testX);
colordef white
clf
linesTime = errorbar([timeMeanSub timeMeanIVM], ([KLMeanSub KLMeanIVM])/numTestTasks, ...
		    sqrt([KLVarSub KLVarIVM]/numTestTasks^2));
set(gca, 'ylim', [0 1.5 ])
set(gca, 'ytick', [0 1])
set(gca, 'xlim', [10 1750])
set(gca, 'xtick', [10 100 1000])
set(linesTime, 'linewidth', 2);
markerSize = 10;
set(linesTime(end/2+1:3*end/4), 'linestyle', '--', 'marker', 'x', 'markersize', ...
		  markerSize)
set(linesTime(3*end/4+1:end), 'linestyle', '-', 'marker', 'o', 'markersize', ...
		  markerSize)

xlab = xlabel('time/s');
set(xlab, 'fontname', fontName, 'fontsize', fontSize)
ylab = ylabel('KL');
set(ylab, 'fontname', fontName, 'fontsize', fontSize)
grid on
set(gca,'fontname', fontName, 'fontsize', fontSize*7/8)
set(gca, 'xscale', 'log')
pos = get(gca, 'position');
pos(2) = pos(2)*2;
pos(4) = 1-pos(2) - 0.05;
set(gca, 'position', pos)
if printMe
  print -deps ../tex/diagrams/KLfullPlot.eps
end
%set(gca, 'xlim', [50 400])
%print -deps ../tex/diagrams/zoomPlot.eps


figure
linesSamps = errorbar([sampsVec'*numTasks dVec'], ([KLMeanSub KLMeanIVM])/numTestTasks, ...
		    sqrt([KLVarSub KLVarIVM]/numTestTasks^2));
set(linesSamps, 'linewidth', 2);
set(linesSamps, 'linewidth', 2);
set(linesSamps(end/2+1:3*end/4), ...
    'linestyle', '--', ...
    'marker', 'x', ...
    'markersize', markerSize)
set(linesSamps(3*end/4+1:end), ...
    'linestyle', '-', ...
    'marker', 'o', ...
    'markersize', markerSize)

xlab = xlabel('data-points');
set(xlab, 'fontname', fontName,  'fontsize', fontSize)
ylab = ylabel('KL');
set(ylab, 'fontname', fontName, 'fontsize', fontSize)
grid on
set(gca,'fontname', fontName, 'fontsize', fontSize*7/8)
set(gca, 'ylim', [0 1.5])
set(gca, 'ytick', [0 1])
pos = get(gca, 'position');
pos(2) = pos(2)*2;
pos(4) = 1-pos(2) - 0.05;
set(gca, 'position', pos)
if printMe
  print -deps ../tex/diagrams/KLeffPlot.eps
end
