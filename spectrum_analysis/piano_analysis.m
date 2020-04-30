%here I used a sound sample of piano, then plotted its frequency spectrum
%and manually estimated its 3dB bandwidth
[y_, fs] = audioread( 'piano_.wav' );
y = y_(:,1);
% plot (y)
% figure
N = 8192;             % length of FFT 
iStart = 10000;       % starting sample of the FFT
Y = fft(y(iStart:N+iStart-1));

f = (0:N-1)*fs/N;
plot(f, 20*log10(abs(Y)))
xlim([0 15000])
grid
xlabel('Frequency (Hz)')
ylabel('Magnitude (dB)')

Y = abs(Y(1:ceil(N/2))); % throw away redundant half of fft
Xi = [];
threshold = 10^(30/20);  % 30 dB 

for n = 2:length(Y)-2 % search for peak indices
  if Y(n+1) <= Y(n) && Y(n-1) < Y(n) && Y(n) > threshold
    Xi = [Xi, n];
  end
end

% Perform parabolic interpolation of peaks
Yi = zeros( size( Xi ) );
for n = 1:length(Xi)
  alpha = Y(Xi(n)-1);
  beta = Y(Xi(n));
  gamma = Y(Xi(n)+1);
  Xii = 0.5*(alpha-gamma) / (alpha - 2*beta + gamma); % interpolated bin value (-1/2 to +1/2)
  Yi(n) = beta - 0.25 * (alpha-gamma) * Xii; % interpolated peak value
  if Xii > 0
    Xi(n) = f(Xi(n)) + Xii*(f(Xi(n)+1)-f(Xi(n))); % bin value in Hz
  else
    Xi(n) = f(Xi(n)) + Xii*(f(Xi(n))-f(Xi(n)-1)); % bin value in Hz
  end
end

% Choose first K peaks starting from the fundamental frequency(around 256) to resynthesize
K = 6;
Xi = [Xi(7) Xi(8) Xi(9) Xi(10) Xi(11) Xi(12)];

Yi = [Yi(7) Yi(8) Yi(9) Yi(10) Yi(11) Yi(12)];

B = 0.2*[8.1 3.2 1.7 1.7 2.1 1.9]; % manually estimated 3dB bandwidths with fudge factor
r = exp(-pi*B/fs);
b0 = Yi;
a1 = -2*r.*cos(2*pi*Xi/fs);
a2 = r.^2;

% Create impulse response of filter bank
N = length(y)
% here is a strike sound I recorded
strike_ = audioread( 'hu.wav' );
strike = strike_(:,1);
x = [strike; zeros(N-length(strike), 1)];
y2 = filter( b0(1), [1 a1(1) a2(1)], x );
for n = 2:K
  y2 = y2 + filter( b0(n), [1 a1(n) a2(n)], x );
end

useResidual = false;
if useResidual
  % Derive residual of estimate from original
  Y = fft(y);
  Y2 = fft(y2);
  R = Y ./Y2;
  r = 50*real(ifft(R)); % arbitrary scaling to increase level of residual

  % Now use residual to drive filters
  y2 = filter( b0(1), [1 a1(1) a2(1)], r );
  for n = 2:K
    y2 = y2 + filter( b0(n), [1 a1(n) a2(n)], r );
  end
end

y2 = 1.0 * y2 / max(abs(y2));
sound([y; zeros(10000, 1); y2], fs)
