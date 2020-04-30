%mixing all parts together
fs = 48000;
[y1,fs1] = audioread('piano_part.wav');
[y2,fs2] = audioread('solo_theme.wav');
[y3,fs3] = audioread('choral_part.wav');
[y4,fs4] = audioread('solo_part.wav');
[y5,fs5] = audioread('bass_part.wav');
y1 = y1/max(y1);
y2 = y2/max(y2);
y3 = y3/max(y3);
y4 = y4/max(y4);
y5 = y5/max(y5);
m = 2*fs;
n = 1:96000;
dim = 1 - 0.8*n/96000;
env = [ones(1,17*m) dim 0.2*ones(1,17*m)];
y5_temp = y5';
%plot(env)
% 
y_1 = [zeros(1,2*m) y1' zeros(1,25*m)];
y_2 = [zeros(1,10*m) y2' zeros(1,17*m)];
y_3 = [zeros(1,18*m) y3' y3' zeros(1,1*m)];
y_4 = 0.5*[zeros(1,26*m) y4' zeros(1,1*m)];

y_5 = env.*y5_temp;

y_tot = y_1+y_2+y_3+y_4+y_5;
y_tot = y_tot/max(y_tot);
%audiowrite('mixed.wav',y_tot,fs)
%length(y3)/2/fs4
soundsc(y_tot,fs1)