## Author: Kaleb Alfaro Badilla <kaleb.23415@gmail.com>
## Script: pid.m
## Description: 
##		
##		
##		
## Created: May 2015
## Version: 0.1

fid=fopen("output_pwm.txt", "r");

pid_model = zeros(1,21);
i = 1;
while( !feof(fid)) 
	Output = fscanf(fid, "%s\n","C");
	pid_model(i) = bin2dec(Output);
	i=i+1;
end
fclose(fid);




rt=0;
yt = -1:.1:1;
yt = ((yt*0.825+1.65)*(4095/4096)/3.3) - .5;
T = 1:1:length(yt);
et = rt - yt;
yt1 = 0;
ik1 = 0;
pid = zeros(1,length(yt));
for k = 1:length(yt)
	p = -18*yt(k);
	if(p>64)
		p=64;
	else if(p-64)
		p=-64;
		endif	
	endif
	ik = 7*et(k) + ik1;
	if(ik>64)
		ik=64;
	else if(ik<-64)
		ik=-64;
		endif	
	endif
	d = -150*(yt(k)-yt1);
	if(d>64)
		d=64;
	else if(d<-64)
		d=-64;
		endif	
	endif
	parc_sum = p+d;
	if(parc_sum>64)
		parc_sum=64;
	else if(parc_sum<-64)
		parc_sum=-64;
		endif	
	endif
	pid(k) = ik+parc_sum;
	if(pid(k)>64)
		pid(k)=64;
	else if(pid(k)<-64)
		pid(k)=-64;
		endif
	endif
	disp(pid(k));
	pid(k) = pid(k)*2 + 128;
	yt1 = yt(k);
	ik1 = ik;
endfor

plot(T,pid,'LineWidth',2,'r',T,pid_model,'LineWidth',2);
clear;
