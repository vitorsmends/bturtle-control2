% 1) obtenha K com base nas condicoes de erro/constante de posicao ou velocidade
% 2) plot Gl=G*K e obtenha (MF, Wg) e (MG, Wf)
% AVANCO DE FASE
% 3) beta = (1+sen(MF_requerida+8))/(1-sen(MF_requerida+8))
% 4) |G(wm)|= -20log10(sqrt(beta)) e obtenha o wm associado
% 5) T1 = sqrt(beta)/wm
% 6) Gc_AV = (T1*s +1)/((T1/b)*s +1)
% ATRASO DE FASE
% 7) wg' = freq onde a fase eh de -180; a nova freq de cruzamento de ganho
% eh a antiga freq. de cruzamento de fase
% 8) T2 = 10/wg'
% 9) Gc_AT = (T2*s +1)/(b*T2*s +1)
% TOTAL
% 10) Gc = Gc_AV*Gc_AT
% 11) verificar se requisitos foram atingidos Gc*Gl

s=tf('s')
G=exp(-0.33*s) * (58.93*s^2 - 2.318e04*s - 1.575e05)/(s^2 + 400.7*s + 261.8)
k=1;
Gl=k*G;
bode(Gl)
% MF = -208-(-180)=-28      WG=2.41
% MG = -10dB                 WCF=1.42
MF_req=45
b=(1+sind(MF_req+8))/(1-sind(MF_req+8))
mdGwm=-20*log10(sqrt(b))
wm=3.9
T1=sqrt(b)/wm

Gc_AV = (T1*s + 1)/((T1/b)*s + 1)

wg_novo=1.42
T2 = 10/wg_novo
Gc_AT = (T2*s +1)/(b*T2*s +1)

Gc=Gc_AV*Gc_AT
bode(Gc*Gl)