% PLOTTIMECOMPARISIONRESULTS Prepare comparision plots of the IVM vs sub-sampling.

fontName = 'times';
fontSize = 32;

load sampledDataStore.mat 
load timeResults.mat
llMeanSub = repmat(NaN, length(sampsVec), 1);
llVarSub = repmat(NaN, length(sampsVec), 1);
timeMeanSub = repmat(NaN, length(sampsVec), 1);
for i = 1:length(sampsVec)
    llMeanSub(i) = mean(llSub(i, :));
    llVarSub(i) = var(llSub(i, :));
    timeMeanSub(i) = mean(timeSub(i, :));
end
llMeanIVM = repmat(NaN, length(dVec), 1);
llVarIVM = repmat(NaN, length(dVec), 1);
timeMeanIVM = repmat(NaN, length(dVec), 1);
% Ignore the first two d values as they have v big errorbars and confuse
% the plot
for i = 3:length(dVec)
    llMeanIVM(i) = mean(llIVM(i, :));
    llVarIVM(i) = var(llIVM(i, :));
    timeMeanIVM(i) = mean(timeIVM(i, :));
end

bestLl = -neglikelihood(log(thetaConstrain([1 1 100 0])), testX, testY);
numTestTasks = length(testX);
colordef white
clf
linesTime = errorbar([timeMeanSub timeMeanIVM], (bestLl-[llMeanSub llMeanIVM])/numTestTasks, ...
		    sqrt([llVarSub llVarIVM]/numTestTasks^2));
set(gca, 'ylim', [-.5 5])
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

print -deps ../tex/diagrams/fullPlot.eps
%set(gca, 'xlim', [50 400])
%print -deps ../tex/diagrams/zoomPlot.eps


figure
linesSamps = errorbar([sampsVec'*numTasks dVec'], (bestLl-[llMeanSub llMeanIVM])/numTestTasks, ...
		    sqrt([llVarSub llVarIVM]/numTestTasks^2));
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
set(gca, 'ylim', [-.5 5])
pos = get(gca, 'position');
pos(2) = pos(2)*2;
pos(4) = 1-pos(2) - 0.05;
set(gca, 'position', pos)
print -deps ../tex/diagrams/effPlot.eps
