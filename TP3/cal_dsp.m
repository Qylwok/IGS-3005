function Sxx = cal_dsp(x,Fe);

N= length(x);
X = (1/N)*fft(x);
Sxx = abs(X).^2;