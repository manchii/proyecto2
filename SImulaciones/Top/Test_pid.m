## Author: Kaleb Alfaro Badilla <kaleb.23415@gmail.com>
## Script: Test_pid.m
yt = -1:.1:1;
yt = round((yt*3.3/4+1.65)*(4095)/3.3);


%Generación del vector de estímulos en un archivo .txt
fid= fopen('test.txt', 'w');

for  i=1:length(yt)
	fprintf (fid, '%s%s\n',"0000",dec2bin(yt(i),12));
endfor

fclose(fid);
