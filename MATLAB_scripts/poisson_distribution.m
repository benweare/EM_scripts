%Poisson Distribution
%Use cdf for indiscreet variables (probability between 0 - 1 like rolls of
%a die), pdf for discreet variables (like counts of head or tails in coin
%flips)
x=0:15;
y=poisspdf(x,4);
alpha = 0.05; %0.05 for 95% confidence interval
[M,V] = poisstat(y);
[lambdahat,lambdaci] = poissfit(y,alpha); 
display(lambdahat);
display(lambdaci);
%display(M); %mean
%display(V); %variance
figure
hold on;
plot(x,y,'x');
xlabel('Observation')
ylabel('Probability')
fh = plot(y);
hold off;
%lambdahat is maximum likelihood estimate (MLE)
%lambdaci is the confidence intervals defined by alpha
