fs = 48000;  
y = wavee(60,1);
unit_matrix = [62 57 62 57
    1.5 0.5 1.5 0.5];
this_matrix = [];
for mn = 1:34
    this_matrix = [this_matrix unit_matrix];
end
y3 = add_note2(@wavee,this_matrix);
y3 = [y3 zeros(1,fs*2)];
%a choral filter
bs = [0.6 zeros(1,1999) 0.7 zeros(1,1999) 0.8 zeros(1,1999) 0.9 zeros(1,1999) 1.0];
as = [1 zeros(1,length(bs)-1)];
y4 = filter(bs,as,y3);
%a reverb filter
bs2 = [1 zeros(1,3999) 0.7 zeros(1,1999) 0.65 zeros(1,999) 0.6 zeros(1,699) 0.55 zeros(1,499) 0.5 zeros(1,399)];
as2 = [1 zeros(1,length(bs2)-1)];
choral = filter(bs2,as2,y4);
choral = choral/max(choral);
%audiowrite('single_voice_two.wav',y5,fs)
%plot(y3)
soundsc(choral,fs)
%length(y3)
%audiowrite('bass_part.wav',choral,fs)

%a function synthesizing each note
function wave = wavee(midi_number,duration)
    frequency_ratio = 2^((midi_number - 60)/12);
    
    ref_fre = [130.8 261.6 391.3 521.0 650.6 781.5 912.3];
    frequency = frequency_ratio*ref_fre;
    amplitudes = [50.3 51.4 22.2 160.3 225.4 144.1 112.3];
    sum = zeros(1,duration/2*48000);
    %length(sum)
    for i = 1:7
        fs = 48000;   
        beat = duration/2;
        T = 1/fs;                        
        x = [0 0.05 duration-0.05 duration];
        y = amplitudes(i)*[0 1 0.8 0];
        n = 0:beat*fs-1;
        %length(n)
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

