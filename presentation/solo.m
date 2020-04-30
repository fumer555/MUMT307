%this code is just used for demo but not used in the final mixture
%it has no vibrato effect
fs = 48000;  
y = wavee(60,1);
this_matrix = [65 62 64 61 62 65 64 61 62 64 62 64 66 67 66 67 66 67 65 64 65 64 63 64 62 61 62 63 64
2 2 2 2 2 2 2 2 2 0.5 0.5 0.5 0.5 3 1 0.34 0.34 0.32 0.34 0.34 0.32 0.34 0.34 0.32 0.34 0.34 0.32 1 1];
%this_matrix(1,:) = 12 + this_matrix(1,:);
y3 = add_note2(@wavee,this_matrix);
y3 = [y3 zeros(1,fs*1)];

soundsc(y3,fs)
%length(y3)/fs

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
        T = 1/fs;
        x = [0 0.05 duration-0.05 duration];
        y = amplitudes(i)*[0 1 0.8 0];
        n = 0:beat*fs-1;
        length(n);
        env = interp1(x,y,n*T*2);
        wave_ = env.*sin(2*pi*frequency(i)/fs*n);
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

