s={}; fid = fopen('1008982_F3_90.txt');
tline = fgetl(fid); 
while ischar(tline)   
    s=[s;tline];   
    tline = fgetl(fid);
end 

s