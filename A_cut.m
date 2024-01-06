function [tcut ,scut]=A_cut(path,name,PWP,offset,ZoF)
data=csvread([path,name],11);
figure(221)
 plot(data(1:end-0,1),data(1:end-0,2))
t=data(2000:end-500,1);
t = t-min(t);          
s=ZoF*1000*data(2000:end-500,2);
%mean(s)
%s=s-offset;

[fitinit, ~] = PWP.smoothBaseLine(t, s,0.999);
baseline=fitinit(t);
sB=s-baseline+mean(baseline);
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
% for a=1:2
%     dL=0;Width=1.0;
%     while dL==0
%     L=length(sB);
%     [t ,sB]=PWP.cutStEd(t,sB,fix(Width*zqNN),1);
%     dL=L-length(sB);
%     Width=Width+0.1;
%     if(Width>4) break; end
%     end
%     dL=0;Width=0.9;
%     while dL==0
%     L=length(sB);
%     [tf ,sBf]=PWP.cutStEd(flip(t,1),flip(sB,1),fix(Width*zqNN),1);
%     t=flip(tf,1);sB=flip(sBf,1);
%     dL=L-length(sB);
%     Width=Width+0.1;
%     if(Width>4) break; end
%     end
% end

scut=sB;
tcut=t;
%[t ,sB]=PWP.cutStEd(t,sB,fix(0.75*zqNN),10);
figure(2321)
  plot(t,sB,'b');hold off
end
