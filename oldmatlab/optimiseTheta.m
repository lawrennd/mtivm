function theta = optimiseTheta(X, y, sitePrecision, activeSet, M, L, theta, iters, em)

% OPTIMISETHETA Optimise the kernel parameters

if nargin < 9
  em = 0;
end
prior = 1;
lntheta = log(theta);
numTasks = length(X);
if em
  for task = 1:numTasks
    if isempty(activeSet{task})
      continue
    end
    K = kernel(X{task}(activeSet{task}, :), lntheta);
%    K2 = kernel(X{task}(activeSet{task}, :), lntheta, X{task}(activeSet{task}, :));
%    invK = pdinv(K2);
    % A is the covariance of the posterior
%    A{task} = pdinv(invK + theta(3)*eye(size(X{task}(activeSet{task}, :), 1)));
    A{task} = K - M{task}(:, activeSet{task})'*M{task}(:, activeSet{task}); 
    beta = eye(size(L{task},1))/L{task}*sqrt(theta(3))*y{task}(activeSet{task});
    fbar{task} = beta'*M{task}(:, activeSet{task});
%    fbar{task} = kernel(X{task}(activeSet{task}, :), lntheta, X{task}(activeSet{task}, :))*A{task}*theta(3)*y{task}(activeSet{task});
    %fbar{task} = y{task}(activeSet{task});
    
  end
end
options = foptions;
options(9) = 1;
options(1) = 1;
options(14) = iters;
if ~em
  lntheta = scg('neglikelihood', lntheta, options, 'neggradient', X, y, activeSet, prior);
else
  lntheta = scg('neglikelihoodEM', lntheta, options, 'neggradientEM', X, A, fbar, ...
		activeSet, prior);
end
theta = exp(lntheta);