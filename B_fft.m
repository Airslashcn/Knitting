
L = length(t); 
dT = mean(t(2:L)-t(1:L-1));        
%compute baseline------------------------------------------------------------------------------
[fitinit, gofinit] = PWP.smoothBaseLine(t, s,0.999);
baseline=fitinit(t);
sB=s-baseline;
max(baseline)-min(baseline);
%FFT------------------------------------------------------------------------------
[f,P1]=PWP.FFTP1(t,sB);
%find main HZ ------------------------------------------------------------------------------
[A,iw]=max(P1(f<30));
[Anoise,omeganoise]=max(P1(f>45));
w=f(iw);
zqFr=1/w;
zqN=fix(zqFr/dT);
%filter------------------------------------------------------------------------------
if(filterflag)
sf=PWP.FilterBandStop(t,10,sB);
sfH=PWP.FilterHigh(t,Hhz,sB);
else
    sf=sB;
    sfH=sB;
end
% for hz=6:1:78
% sf=PWP.FilterBandStop(t,hz,sf);
% end
[f,Pf1]=PWP.FFTP1(t,sf);
[f,Pf1H]=PWP.FFTP1(t,sfH);
%find true HZ ------------------------------------------------------------------------------
if(HZprint_flag)
fprintf('w %f xl %f  Amp %f NoiseR %f\n',w,60*w,A,Anoise/A)
end
%plot%------------------------------------------------------------------------------%plot%
    figure(11)
    subplot(3,2,1);plot(t,s,'b');hold on
    plot(t,baseline,'r-','linewidth',3);hold on
    subplot(3,2,2);plot(t,sB,'r');hold on
    % subplot(3,2,3);plot(t,fitNew(t),'b','linewidth',2);hold on
    subplot(3,2,3);plot(t,sf,'r');hold on
    subplot(3,2,4);plot(f,P1) 
    subplot(3,2,5);plot(t,sfH,'b');hold on
    % subplot(3,2,5);plot(t,fitNewf(t),'b','linewidth',2);hold on
    subplot(3,2,6);plot(f,Pf1H,'b');hold on
    figure(11)
    hold off