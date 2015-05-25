function KL = gpKL(model1, model2, X)

% GPKL Evaluate the KL divergence between to GPs evaluated at X

K1 = kernel(X, model1.lntheta);
K2 = kernel(X, model2.lntheta);

cholSigma1invSimga2 = chol(K1)/chol(K2)

[logdet1, U1] = logdet(K1);
[logdet2, U2] = logdet(K2);
invK2 = pdinv(K2, U2);

KL = -logdet1 + logdet2 +trace(K1*invK2) - N;
KL = KL/2;
