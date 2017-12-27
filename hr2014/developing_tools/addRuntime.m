function [ time ] = addRuntime(time, t0)
time = time + cputime -t0;
end

