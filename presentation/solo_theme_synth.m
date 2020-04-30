fs = 48000;  
y = wavee(60,1);
this_matrix = [62 62 65 64 62 61 62 64 62 64 62 64 65 65 65 64 62 61 59 61 62 62 65 64 62 61 62 64 62 67 65 64 62 64
1 1 0.5 0.5 1 0.5 0.5 1 1.5 0.5 0.5 0.5 1 1 1 0.5 0.5 2 0.5 0.5 1 1 0.5 0.5 1 0.5 0.5 1 2 1 1 1 1 4];
%this_matrix(1,:) = 12 + this_matrix(1,:);
y3 = add_note2(@wavee,this_matrix);

soundsc(y3,fs)
y3 = y3/max(y3);
%length(y3)/fs
%audiowrite('solo_theme.wav',y3,fs)

%a function generating notes
function wave = wavee(midi_number,duration)
    frequency_ratio = 2^((midi_number - 60)/12);
    
    ref_fre = [130.8 261.6 391.3 521.0 650.6 781.5 912.3];
    frequency = frequency_ratio*ref_fre;
    amplitudes = [50.3 51.4 22.2 160.3 225.4 144.1 112.3];
    sum = zeros(1,floor(duration/2*48000));
    %length(sum)
    for i = 1:7
        fs = 48000;   
        beat = duration/2;
        dur = beat;
        T = 1/fs;
        t = 0:T:dur-T; 
        x = [0 0.05 duration-0.05 duration];
        y = amplitudes(i)*[0 1 0.8 0];
        n = 0:beat*fs-1;
        %length(n)
        env = interp1(x,y,n*T*2);
        %fm synthesis
        fc = frequency(i);      % center freq
        fm = 10;
        Imin = -0.005*fc;
        Imax = -Imin;
        I = t.*(Imax - Imin)/dur + Imin;
        fm = sin(2*pi*fc*t + I.*sin(2*pi*fm*t));

        wave_ = env.*fm;
        sum = sum + wave_;
    end
    wave = sum;
end

%a function adding notes together
function this_add_note = add_note2(noteFunction,matrix)
    L = length(matrix);
    sum = [];
    for i = 1:L
        to_add = noteFunction(matrix(1,i),matrix(2,i));
        sum = [sum to_add];
    end
this_add_note = sum;

end

