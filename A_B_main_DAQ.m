% clear
% clc
for num=12
  
    
    
    path='.\data\DAQ\';% real path
    type='daq';  % tri sin pw

    Dname=dir(path);
    name=Dname(num+2).name
    PWP=PulseWavePre;
    Hf_flag=1;Hhz=50; % filter flag
    filterflag=0;
    HZprint_flag=0;

data=csvread([path,name],9);
t=data(1000:end-3000,4);
t = t-min(t);          
s=data(1000:end-3000,3);
%mean(s)
s=s;

[fitinit, ~] = PWP.smoothBaseLine(t, s,0.9);
baseline=fitinit(t);
sB=s-baseline;
L = length(t); 
dT = mean(t(2:L)-t(1:L-1));      

[f,P1]=PWP.FFTP1(t,sB);
%find main HZ ------------------------------------------------------------------------------
[~,w]=max(P1(f<30));
w=f(w);
zqFr=1/w;
zqNN=fix(zqFr/dT);
figure(2321)
  plot(t,sB,'r'); hold on
for a=1:2
    dL=0;Width=0.9;
    while dL==0
    L=length(sB);
    [t ,sB]=PWP.cutStEd(t,sB,fix(Width*zqNN),1);
    dL=L-length(sB);
    Width=Width+0.1;
    if(Width>4) break; end
    end
    dL=0;Width=0.9;
    while dL==0
    L=length(sB);
    [tf ,sBf]=PWP.cutStEd(flip(t,1),flip(sB,1),fix(Width*zqNN),1);
    t=flip(tf,1);sB=flip(sBf,1);
    dL=L-length(sB);
    Width=Width+0.1;
    if(Width>4) break; end
    end
end

s=sB;
t=t;
%[t ,sB]=PWP.cutStEd(t,sB,fix(0.75*zqNN),10);
figure(2321)
  plot(t,sB,'b');hold off
  Offset=mean(s);
B_fft
C_wave
D_errorBar
% 
savepath='.\data\DAQsave\'; %save path
save([savepath,name(1:end-4),'.mat'],'R2Dc_all','DU_vec','Sen_vec','tMean','scqMean','PDmaxR','sMGMean','scqMean2')

% 
% writematrix(R2Dc_all,[savepath,name])
%  clear
end