L = length(t);                
dt = mean(t(2:L)-t(1:L-1));           
Fs = 1/dt; 
%%%%%%小波分解
wavename='amor';
[w, Ft]=cwt(sfH,wavename,Fs);
wabs=abs(w);
%%%%%%求每个时刻的频率
for i=1:L
    [maxw,xl(i)]=max(wabs(40:end,i));
end
xl=xl+39;
% figure(2)
% contour(t,Ft(40:end),wabs(40:end,:))
% hold on
% plot(t,Ft(xl))
%%%%%%频率 周期  心率
XLt=60.*Ft(xl);
mean(XLt)
ZQt=1./Ft(xl);
ZQtN=fix(Fs*ZQt);
ZQNN=fix(mean(ZQtN));
Nper=fix(length(ZQtN)/ZQNN);
ZQtN(1:ZQNN*Nper);
ZQtNper = mean(reshape(ZQtN(1:ZQNN*Nper),ZQNN,Nper));
XLtper=60*Fs./ZQtNper;
tPer=t(fix(ZQNN/2):ZQNN:1+ZQNN*Nper);
%%%%%%寻找波谷
figure(3);
subplot(3,1,1);plot(sfH);
axis([0 5000 -inf inf]);hold on
subplot(3,1,2);plot(tPer/dt-t(1)/dt,XLtper,'d-','markersize',15,'linewidth',3);
axis([0 5000 -inf inf]);hold on

LocMin(1)=1;
for i=2:Nper-1
    st=LocMin(i-1)+fix(ZQtNper(i-1)/2);
    if(i==Nper)
        ed=st+fix(ZQtNper(i-1));
    end
    if(i<Nper)
        ed=st+fix(ZQtNper(i-1)/2+ZQtNper(i)/2.5);
    end
    ed=min([ed,L]);
    if(st>=ed)
        break
    end
    sfHpart=sfH(st:ed);
    [MinS(i),LocMin(i)]=min(sfHpart);
    LocMin(i)=LocMin(i)+st-1;

    sW{i-1}=sfH(LocMin(i-1):LocMin(i));
    tW{i-1}=LocMin(i-1):LocMin(i);
    figure(3)
%     subplot(3,1,1);
%     plot([LocMin(i) LocMin(i)]*1,[min(sfH) 0],'linewidth',1);
%     axis([0 5000 -inf inf]);hold on
    subplot(3,1,3);
    plot(tW{i-1},sW{i-1},'linewidth',1);
    axis([0 5000 -inf inf]);hold on

end


