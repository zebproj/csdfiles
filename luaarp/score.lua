require("arp")

function c(x)
    local tmp = Constant:create() tmp:set(x)
    return tmp 
end

sco = io.open("arp.sco", "w")

sco:write("t 0 135\n")

dur = Sequence:create() dur:set({0.25, 0.25})
amp = Sequence:create() amp:set({0.4, 0.1, 0.2, 0.1})
dist = Ramp:create() dist:set(0, 7, 110)



filt = Sequence:create() filt:set({1000, 2000, 4000})

oct = Sequence:create() 
oct:set({1, 0, 0, 1, -1, 0, 1, 0, 0, 2, 0, -1, 0, 0, 1, 0 })

seq_A = Sequence:create() seq_A:set({60, 58, 62, 63})
seq_B = Sequence:create() seq_B:set({60, 62, 63, 68})
seq_C = Sequence:create() seq_C:set({74, 75})
seq_D = Sequence:create() seq_D:set({75, 77, 79})



res = Ramp:create() res:set(0, 0.8, 90)

metaGate= Blinker:create() metaGate:set(0, 1, 3)
metaseq_A = MetaSeq:create() metaseq_A:set(seq_A, seq_C, metaGate)
metaseq_B = MetaSeq:create() metaseq_B:set(seq_B, seq_D, metaGate)

t = 0
for i = 1, 4, 1 do
    if(i > 2) then
        setA = metaseq_A
        setB = metaseq_B
    else
        setA = seq_A
        setB = seq_B
    end
    t = arp(sco, "synth", t, dur, 32, {setA, amp, filt, res, oct, dist})
    t = arp(sco, "synth", t, dur, 32, {setB, amp, filt, res, oct, dist})

end

sco:write(string.format("i\"reverb\" 0 %g\n", t))
sco:close()
