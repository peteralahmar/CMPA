%Peter Al-Ahmar
%100961570

Is = 0.01e-12;
Ib = 0.1e-12;
vb = 1.3;
gp = 0.1;

%creating the V vector
V = linspace(-1.95, 0.7, 200);

%Creating 2 I Vectors
I = zeros(1, 200);
I2 = zeros(1, 200);

I = (Is.*(exp(V.*1.2/0.025)-1)) +(gp.* V)- (Ib.*(exp((-1.2/0.025).*(V + vb))));
I2 = I +((randn(1, 200))) .* 0.2.*I; %20 percent random variation

figure(1);
plot(V,I);
title('Current vs Voltage');

figure(2);
plot(V,I2);
title('20% random Current vs Voltage');

figure(3);
semilogy(V, I);
title('Current vs Voltage-LogScaled');
figure(4);
semilogy(V, I2);
title('20% random Current vs Voltage-LogScaled');

%2 
Poly4 = polyfit(I,V,4); %4th order for current 
Poly8 = polyfit(I,V,8);%8th order for current 
Poly420 = polyfit(I2,V,4);%4th order for current with 20% random variation
Poly820 = polyfit(I2,V,8);%8th order for current with 20% random variation

%3 
fo = fittype('A.*(exp(1.2*x/25e-3)-1) + B.*x - C*(exp(1.2*(-(x+D))/25e-3))');
ff = fit(V',I',fo);
If = ff(V);
figure(5);
plot(V, If);
hold on;

%I think im doing this correct-----

%3A
fo = fittype('A.*(exp(1.2*x/25e-3)-1) + gp.*x - C*(exp(1.2*(-(x+vb))/25e-3))');
ff = fit(V',I',fo);
If = ff(V);
plot(V, If);
hold on;

%3B
D = vb;
fo = fittype('A.*(exp(1.2*x/25e-3)-1) + B.*x - C*(exp(1.2*(-(x+vb))/25e-3))');

ff = fit(V',I',fo);
If = ff(V);
plot(V, If);
hold on;

%3C
fo = fittype('A.*(exp(1.2*x/25e-3)-1) + B.*x - C*(exp(1.2*(-(x+vb))/25e-3)-1)');
ff = fit(V',I',fo);
If = ff(V);
plot(V, If);
hold on;

%4 
inputs = V.';
targets = I.';
hiddenLayerSize = 10;
net = fitnet(hiddenLayerSize);
net.divideParam.trainRatio = 70/100;
net.divideParam.valRatio = 15/100;
net.divideParam.testRatio = 15/100;
[net,tr] = train(net,inputs,targets);
outputs = net(inputs);
errors = gsubtract(outputs,targets);
performance = perform(net,targets,outputs);
view(net);
Inn = outputs;

%5 
figure(6);
plot(V, Inn);