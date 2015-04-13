function f = neglikelihoodEM(lntheta, X, A, fbar, activeSet, prior)

% NEGLIKELIHOODEM The negative objective function for the M-step.

lntheta = log(thetaConstrain(exp(lntheta)));
numTasks = length(X);
f = 0;
for task = 1:numTasks
  if isempty(activeSet{task})
    continue
  end
  K{task} = kernel(X{task}(activeSet{task}, :), lntheta);
  [invK, U] = pdinv(K{task});
  
  f = f -.5*logdet(K{task}, U) - .5*trace(invK*(fbar{task}*fbar{task}'+A{task}))+0.5*size(fbar{task}, 1);
end
if prior
  f = f - sum(lntheta);
end

% To maximise likelihood we minimise -ve likelihood
f = -f;
