## Author: Kaleb Alfaro Badilla <kaleb.23415@gmail.com>
## Script: pid.m
## Description: genera y prueba una señal rampa estímulo para 
##		una ecuación PID.
## Created: May 2015
## Version: 0.1

rt = 0;
yt = -2:.01:2;
yt = yt*(3.3/4+1.65)*((4095/4096)/3.3 - .5;
T = 1:1:length(yt);
et = rt - yt;
yt1 = 0;
ik1 = 0;
pid = zeros(1,length(yt));
for k = 1:length(yt)
	p = 18*yt(k);
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
	d = 150*(yt(k)-yt1);
	if(d>64)
		d=64;
	else if(d<-64)
		d=-64;
		endif	
	endif
	pid(k) = (ik-p-d);
	if(pid(k)>64)
		pid(k)=64;
	else if(pid(k)<-64)
		pid(k)=-64;
		endif
	endif
endfor

pid = round(pid*2) + 128;

plot(T,pid,'LineWidth',2);
clear;
