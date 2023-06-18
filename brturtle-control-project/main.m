raw_data = csvread("output.csv");
velocity = raw_data(1:end,1);
angle = raw_data(1:end,2);
%
% define the time sample
Ts = 0.001;

% transform data to a the standard format of system identification toolbox
data=iddata(angle, velocity, 0.05);

% conjunto de dados de estimação
datae=data(1:40000);

% validation data-set
datav=data(40000:end);

% ARX model
opt = armaxOptions('Focus', 'Simulation')
% identify parameters for arx model
%M1 = arx(datae, [4 4 1], opt)
M1 = armax(datae, [6 6 4 1], opt)
% print the model founded as TF
tf(M1);

% compare with the validation data
compare(M1, datav);
