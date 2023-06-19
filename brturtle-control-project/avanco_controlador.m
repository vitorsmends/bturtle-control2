% wm = 1/(raiz(a)*T)
% phi_m vem do grafico de fase
% Gc(s)=K*(T*s+1)/(aTs+1)

% 1) obtenha K com base nas condicoes de erro/constante de posicao ou velocidade
% 2) plot Gl=G*K e obtenha (MF, Wg) e (MG, Wf)
% 3) psi= MF_requerida - MF_medida
%    phi = psi+8 (somar entre 5 a 9, padrao = 8°)
% 4) alfa = (1-sen(phi))/(1+sen(phi))
% 5) em wn, |G(wn)|=-20*log10(1/raiz(alfa)), entao, dado o modulo calculado, obtenha
%    wn
% 5) T=1/(sqrt(alfa)*wn)
% 6) Gc(s)=k*(T*s+1)/(aTs+1)
% 7) verificar se requisitos foram atingidos

% Ev <= 0.1     Ev =1/(s+s*k*G(s)), s->0
% 1/(k/(0+2)) <=0.1       -> 1/(k/2)<=0.1 -> 2/k<=0.1 -> 20<=k -> k>=20 

%%
close all;
clear all;

s=tf('s')
G=(60.77*s^3 -36.61*s^2 - 2.804*s - 0.04459)/(s^4 + 1.074*s^3 + 0.1726*s^2 + 0.008238*s + 0.0001661)
%k=0.0335/(s-0.673)
k=20/(s-0.673)
Gl=G*k
margin(Gl)
% MF = 7.37   Wf = 7.77 rad/s
% MG = inf.             Wg = inf.

%%
psi=45-(1.65)
phi=(psi)+9
alfa=(1-sind(phi))/(1+sind(phi))
mdGwn=-20*log10(1/sqrt(alfa))
wn=59.9
T=1/(sqrt(alfa)*wn)

Gc=(T*s+1)/(alfa*T*s+1)
margin(Gc*G)

%%
%Gc=(0.9794*s +20)/(0.005691*s^2 +0.9962*s -0.673)
step(feedback(Gl,1))
hold on
step(feedback(Gl*Gc,1))

%% Discretizacao em Z^-1
tfz = c2d(Gc*k, 1/200)
tfz = filt(tfz.Numerator, tfz.Denominator, 1/200)