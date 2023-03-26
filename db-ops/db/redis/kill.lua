local n = tonumber(ARGV[1])
if not n  or n == 0 then
    return 0       
end                
local vals = redis.call("HMGET", KEYS[1], "Total", "Booked");
local total = tonumber(vals[1])
local blocked = tonumber(vals[2])
if not total or not blocked then
    return 0       
end                
if blocked + n <= total then
    redis.call("HINCRBY", KEYS[1], "Booked", n)                                   
    return n;   
end                
return 0