% ICMLKLRESULTS Plot the results for the ICML experiment in the form of KL divergences.

load timeResults.mat
KLSub = zeros(size(llSub));
KLIVM = zeros(size(llIVM));
for i = 1:length(testX)
  K1 = kernel(testX{i}, log(thetaConstrain([1 1 100 0])));
  logdet1 = logdet(K1);
  for j = 1:size(thetaIVM, 1)
    for k = 1:size(thetaIVM, 2)
      K2 = kernel(testX{i}, log(thetaConstrain(thetaIVM{j, k})));
      [logdet2, U2] = logdet(K2);
      invK2 = pdinv(K2, U2);

      val = -logdet1 + logdet2 +trace(K1*invK2) - size(K1, 1);
      KLIVM(j, k) = KLIVM(j, k) + val/2;

    
    end
  end
  for j = 1:size(thetaSub)
    for k = 1:size(thetaSub)
      K2 = kernel(testX{i}, log(thetaConstrain(thetaSub{j, k})));
      [logdet2, U2] = logdet(K2);
      invK2 = pdinv(K2, U2);

      val = -logdet1 + logdet2 +trace(K1*invK2) - size(K1, 1);
      KLSub(j, k) = KLSub(j, k) + val/2;
    
    end
  end
end

save klResults KLIVM KLSub
