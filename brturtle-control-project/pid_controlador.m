%%
close all;
clear all;

s=tf('s')
G=(60.77*s^3 -36.61*s^2 - 2.804*s - 0.04459)/(s^4 + 1.074*s^3 + 0.1726*s^2 + 0.008238*s + 0.0001661)
Gc=tf(pid(0.019211, 0.00056694, 0.013406, 1/200))


%% Discretizacao em Z^-1
tfz = c2d(Gc, 1/200)
tfz = filt(tfz.Numerator, tfz.Denominator, 1/200)