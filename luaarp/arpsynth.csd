<CsoundSynthesizer>
<CsOptions>
-d -odac:system:playback_ -+rtaudio="jack" 
;-oarp.wav -d
-B 4096
</CsOptions>
<CsInstruments>

sr	=	96000
ksmps	=	10
nchnls	=	2
0dbfs	=	1
alwayson "Mixer"
gaL, gaR init 0
gaSC init 0
gaMasterL, gaMasterR init 0

instr synth
iglidetime = 0.1
iamp = p5
ioct = p8
ifilt = p6
ires = p7
idist = p9
kcps = cpsmidinn(p4 + 12 * ioct) * 0.25
a1 vco2 iamp, kcps
a1 lpf18 a1, ifilt, ires, idist
aenv linsegr 0, 0.01, 1, 0.1, 0, 0.01, 0
a1 = a1 * aenv
a1 clip a1, 0, 0.8
gaMasterL = gaMasterL + a1
gaMasterR = gaMasterR + a1
if(ioct == 2) then
    gaL = gaL + a1 
    gaR = gaR + a1 
elseif(ioct == 1) then
    gaL = gaL + a1 * 0.5
    gaR = gaR + a1 * 0.5
endif
endin

instr reverb
aL, aR reverbsc gaL, gaR, 0.98, 10000
aL buthp aL, 1000
aR buthp aR, 1000
agate linsegr 1, 8, 0
aL = aL * 0.3 * agate
aR = aR * 0.3 * agate
gaMasterL = gaMasterL + aL
gaMasterR = gaMasterR + aR
gaL = 0
gaR = 0
endin

instr Mixer
aL clip gaMasterL, 2, 1
aR clip gaMasterR, 2, 1
agate linsegr 1, 8, 0
outs aL, aR
clear gaMasterL, gaMasterR
endin

</CsInstruments>
<CsScore>
#include "arp.sco"
</CsScore>
</CsoundSynthesizer>

