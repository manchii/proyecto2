## Author: Kaleb Alfaro Badilla <kaleb.23415@gmail.com>
## Script: pid.m
## Description: 
##		
##		
##		
## Created: May 2015
## Version: 0.1

res = 3.3/(2**12 - 1);

fid=fopen("output.txt", "r");

pid_model = zeros(1,51);
i = 1;

while( !feof(fid)) 
	Output = fscanf(fid, "%s\n","C");
	pid_model(i) = (-2**(length(Output)-1)*bin2dec(Output(1)) + bin2dec(Output(2:end)))*res/128;
	i = i + 1;
end
fclose(fid);

T=(0:5e-3:50*5e-3);%Muestreo a 1/44.1kHz
yt=3*T;
rt = 0;
et = rt-yt;
yt1 = 0;
ik1 = 0;
pid = zeros(1,length(T));
for k = 1:length(T)
	p = 18*yt(k);
	ik = 7*et(k) + ik1;
	d = 150*(yt(k)-yt1);
	pid(k) = (ik-p-d)/128;
	ik1 = ik;
	yt1 = yt(k);
endfor

plot(T,yt,'LineWidth',2,T,pid,'LineWidth',2,T,pid_model,'LineWidth',2);
clear;
