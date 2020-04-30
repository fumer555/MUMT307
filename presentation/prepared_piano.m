fs = 48000;
strike_ = audioread( 'strike_sound.wav' );
strike = strike_(:,1);
%plot(strike)



this_matrix = [62 62 65 64 62 61 62 64 62 64 62 64 65 65 65 64 62 61 59 61 62 62 65 64 62 61 62 64 62 67 65 64 62 64
1 1 0.5 0.5 1 0.5 0.5 1 1.5 0.5 0.5 0.5 1 1 1 0.5 0.5 2 0.5 0.5 1 1 0.5 0.5 1 0.5 0.5 1 2 1 1 1 1 4];
matrix_2 = [this_matrix(1,:)-12
    this_matrix(2,:)];
length(this_matrix);
y1 = add_note(fs,@noteFunction,strike,this_matrix);
y2 = add_note(fs,@noteFunction,strike,matrix_2);
y3 = y1+y2;
numb = length(y3)/fs;
sound(y3, fs)
%audiowrite('piano_part.wav',y3,fs)
% this_add_note = noteFunction(fs,strike,this_matrix(1,1),this_matrix(2,1));
% sound(this_add_note, fs)

%a function generating notes
function this_note = noteFunction(fs,attack,midi_number,duration)
    K = 6;
    Xi = 10^3*[0.2614 0.5225 0.7858 1.0496 1.3134 1.5774];
    Yi = [669.5989 231.9390 98.0483 471.0216 318.1124 247.1455];
    N = floor(duration*24000);
    B = 0.2*[8.1 3.2 1.7 1.7 2.1 1.9]; % manually estimated 3dB bandwidths with fudge factor
    r = exp(-pi*B/fs);
    Xi = 2^((midi_number-60)/12)*Xi;
    b0 = Yi;
    a1 = -2*r.*cos(2*pi*Xi/fs);
    a2 = r.^2;
    strike = attack;
    x = [strike; zeros(N-length(strike), 1)];
    y2 = filter( b0(1), [1 a1(1) a2(1)], x );
    for n = 2:K
      y2 = y2 + filter( b0(n), [1 a1(n) a2(n)], x );
    end


    y2 = 1.0 * y2 / max(abs(y2));
    this_note = y2;
end

%a functon adding notes together
function this_add_note = add_note(fs,noteFunction,attack,matrix)
    L = length(matrix);
    sum = [];
    for i = 1:L
        to_add = noteFunction(fs,attack,matrix(1,i),matrix(2,i));
        sum = [sum to_add'];
    end
this_add_note = sum;

end

