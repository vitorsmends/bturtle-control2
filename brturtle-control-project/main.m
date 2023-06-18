clear variables

raw_data = csvread("output.csv");
velocity = raw_data(1:end,1);
angle = raw_data(1:end,2);
angle = (angle-mean(angle));
% define o tempo de amostragem (time sample)
Ts = 0.005;

% transform data to a the standard format of system identification toolbox
data=iddata(angle, velocity, Ts);
%plot(data)

% calculo de correlacao cruzada para estimacao do atraso entrada -> saida
%[y, lag]=xcorr(velocity,angle,'coeff'); 
%plot(lag, y)

% conjunto de dados de estimação
datae=data(1:50000);

% validation data-set
datav=data(50001:end);

% ARX model
opt = armaxOptions('Focus', 'Simulation')
% identify parameters for arx model
% modelos atuais
M1 = arx(datae, [1 2 67], opt)
%M1 = armax(datae, [1 2 1 67], opt)

% modelos anteriores
%M1 = arx(datae, [4 4 1], opt)
%M1 = armax(datae, [6 6 4 1], opt)

% print the model founded as TF
tf(M1);

% compare with the validation data
compare(M1, datav);
