Constant = {}
Constant_mt = {__index = Constant}

function Constant:create(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o;
end

function Constant:n()
    return self.value
end

function Constant:set(x)
    self.value = x
end

Sequence = Constant:create()
Sequence.place = -1
Sequence.value = {0};


function Sequence:n()
    if(type(self.value) == "number") then 
        local size = 1 
        return self.value
    else 
        local size = #self.value 
        self.place = (self.place + 1) % #self.value 
        return self.value[self.place + 1]
    end
end

Blinker = Constant:create()

function Blinker:set(val1, val2, steps)
    self.val1 = val1
    self.val2 = val2
    self.steps = steps
    self.cstep = -1
end

function Blinker:n()
    self.cstep = (self.cstep + 1 )% self.steps
    if(self.cstep == 0) then
        return self.val1
    else
        return self.val2
    end
end

Ramp = Constant:create()

function Ramp:set(val1, val2, steps)
    self.val1 = val1
    self.val2 = val2
    self.steps = steps
    self.cstep = -1
end

function Ramp:n()
    if(self.cstep == self.steps - 1) then
        return self.val2
    else
        self.cstep = self.cstep + 1
        return self.val1 + self.cstep * ((self.val2 - self.val1) / (self.steps - 1))
    end
end

MetaSeq = Sequence:create()

function MetaSeq:set(seq1, seq2, switch)
    self.seq1 = seq1
    self.seq2 = seq2
    self.seq = seq1
    self.switch = switch
end

function MetaSeq:n()
   local state = self.switch:n()
   if(state == 1) then
       return self.seq1:n()
   elseif(state == 0) then
       return self.seq2:n()
   else
       return self.seq1:n()
   end
end

function arp(out, instr, start, dur, its, vals, gate)
    local time = start
    if(type(instr) == "string") then instr = "\""..instr.."\"" end
    for n = 1, its, 1 do
        local d = dur:n()
        out:write(string.format("i%s %s %s ", instr, time, d))
        for i, v in pairs(vals) do
            out:write(string.format("%s ", v:n()))
        end
        out:write("\n")
    time = time + d
    end
    return time
end
