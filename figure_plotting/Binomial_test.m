%Binomial test
%n=tries, k=successes, p=probability of success, a=confidence level (0.05=5%)
n=47;
k=20;
p=0.5;
a=0.05;
%binomial test
P=(factorial(n)/(factorial(k)*factorial(n-k)))*(p^k)*(1-p)^(n-k);
%plot a binomial distribution
x = 0:n;
y = binopdf(x,n,0.5);
figure;
bar(x,y,1);
xlabel('Observation');
ylabel('Probability');
%Mean and Variance
[M,V] = binostat(n,p);
%standard deviation
sigma=sqrt(V);
UpperBound = M+(2*sigma);
LowerBound = M-(2*sigma);
%confidence interval; MLE and confidence bounds (95%). MLE is number of
%success over number of trials. Calculation done using the mean M of the 
%MLEm = MLE (model), MLEs = MLE (sample), ratio of success to tries
[MLEm,CI]=binofit(M,n,a);
[MLEs]=binofit(k,n);
axis square
%xlim([25,63])