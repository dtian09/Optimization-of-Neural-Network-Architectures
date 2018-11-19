function bin2 = dec2bin(dec_nr,len)
%Convert a decimal integer to a binary number
%inputs: dec_nr, the integer
%        len, the specified length of the binary representation
%output: the binary representation with the specified length
i = 1;
q = floor(dec_nr/2);
r = rem(dec_nr, 2);
bin(i) = r(i);
while 2 <= q
    dec_nr = q;
    i = i + 1;
    q = floor(dec_nr/2);
    r = rem(dec_nr, 2);
    bin(i) = r;
end
bin(i+1) = q;
bin = fliplr(bin);
bin2 = zeros(1,len);
if length(bin) < len
    indx0 = len-length(bin)+1;    
else%length of binary representation >= specified length
    len = length(bin);
    indx0 = 1;
end
bin2(1,indx0:len) = bin;
end
