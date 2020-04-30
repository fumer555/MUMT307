# MUMT307
The final project of MUMT 307 in Winter 2020

Final project
Rachmaninoff goes to Cage
Zi Hang Yin

The objective of my final project is to generate a short music sample by using several synthetic techniques learned from the class MUMT 307. A large component of this project is about audio processing. There is also a little music control and interaction components. 

The only hardware needed is a laptop. Other than Matlab, audacity and MuseSore are used to record and obtain several audio samples. The only sound file that is used as an input to generate the sound used in the music sample is the recorded strike sound. Other recorded audio files are not directly used as an input sound sample but as reference sound samples that give me the parameters used in audio synthesis. 

A concept borrowed from John Cage is the concept of prepared piano. Cage places some objects somewhere in the piano, usually on top the strings, so that when the keyboard is pushed, the timbre is affected by the object placed. I used modal synthesis to synthesize a prepared piano sound. The idea is to get an audio sample of a piano, then by plotting its fast furrier transform. The resonance frequencies could be estimated from this spectrum analysis. A model that requires an excitation sound is then created. I used a striking sound to excite this physical modal. This striking sound is recorded when I knock a glass with a pencil. Therefore, the final resulting sound is a mixture of piano timbre and knocking glass, which somehow resembles to prepared sounds.

Time varying additive synthesis is used to synthesize the vocal sounds. Using audacity, I recorded the sound of myself by pronouncing the vowel ‘a’. I used fft to find the amplitudes and frequencies of each significant peaks. After that, I generated some sinusoids multiplied to some envelopes and I added all frequency components together to synthesize the vocal sound. 

In order to make those sounds into a sequences of pitches, I a 2 to n matrix to represent the midi numbers and the durations. I scaled all samples of sound to the pitch of middle C. To change the pitch, all what I have to do is to change the values of the frequency components by multiplying it to a exponential ratio of base 2. After synthesizing all pitches with different lengths, I used string additions to put those sounds into sequences. For piano, I made the theme of Rachmaninoff’s Piano Concerto no. 2. For voices, I made the theme for a solo and a choral part, a contrapuntal variation for solo and a bass part that repeats. 

For the choral parts, I passed the sequence of sound to a chorus effect filter, in which I delayed the signal to a specific length, so that a choral effect is simulated. After a chorus effect is performed, I passed the output as the input of a reverb filter so that I simulate a choral singing in a hall.

For solo parts, since a solo part needs to stand out among the choral part, I have decided to do a frequency modulation to all frequency components of the solo part, because a voice with vibrato always is always easy to recognize. 

After all, I added all parts together using vector addition, like when we are adding serial tracks together in a DAW but I am using Matlab this time. I also created an envelope for the bass part when I noticed that the bass sounds too loud somewhere in the mixture. 

The biggest challenge in this work is about writing functions, I have to make some functions so that I can use those them multiple times. I also have to figure out how to use the pointer so that I can use a function as a parameter of another function. Another challenge is about debugging, there are sometimes distortions in the audio output, and I have to figure out what the problem is. After all, designing filters is also a challenge, I tried many times with the parameters so that I could make the sound as realistic as I could.


