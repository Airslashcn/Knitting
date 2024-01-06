R2Uc_all=zeros(pers,10);
R2Dc_all=zeros(pers,10);

for j=1:pers
    sMGU_part=sMGUs(1+j*Nsamp-Nsamp:Nsamp*j);
    sMGD_part=sMGDs(1+j*Nsamp-Nsamp:Nsamp*j);
    scqU_part=scqUs(1+j*Nsamp-Nsamp:Nsamp*j);
    scqD_part=scqDs(1+j*Nsamp-Nsamp:Nsamp*j);
    for i=1:10
        hfrgU=sMGU_part>(i-1)/20;hfrgD=sMGD_part>(i-1)/20;
        R2Uc_all(j,i)=PWP.ComputeR2(scqU_part(hfrgU),sMGU_part(hfrgU));
        R2Dc_all(j,i)=PWP.ComputeR2(scqD_part(hfrgD),sMGD_part(hfrgD));
    end  
end

VarR2U=var(R2Uc_all);
VarR2D=var(R2Dc_all);
MeanR2d=mean(R2Dc_all);



tMean=linspace(0,1,Nsamp);
[sMGMean,~]=PWP.PeriAve(sMGDs,Nsamp,pers,0);
[scqMean,scqO]=PWP.PeriAve(scqDs,Nsamp,pers,1);
[HpkcqM,pkScq]=findpeaks(PWP.FilterHigh(tMean,10,scqMean));
[HpkMG,pkSMG]=findpeaks(sMGMean);

tO=[];
for i=1:pers
tO=[tO,tMean];
end



[~,LocMaxScq]=max(scqMean);
[~,LocMaxSmg]=max(sMGMean);



scqMean=circshift(scqMean,-pkScq(1)+pkSMG(1)-0);
scqO=circshift(scqO,-pkScq(1)+pkSMG(1)-0);
figure(23)
subplot(2,2,2)
plot(tO,scqO,'yo','linewidth',3);hold on
plot(tMean,scqMean,'b-','linewidth',3);hold on

[~,LocMinscq]=min(scqMean);
scqMean2=circshift(scqMean,-LocMinscq);
scqO2=circshift(scqO,-LocMinscq);

scqDs2=circshift(scqDs,-LocMinscq);
% scqMean2=PWP.PeriAve(scqDs2,Nsamp,pers,1);

figure(23)
subplot(2,2,1)
plot(tO,scqO2,'yo','linewidth',3);hold on
plot(tMean,scqMean2,'b-','linewidth',3);hold on
 
%plot loop
    [~,PDmax]=max(sMGMean);
    figure(23)
    subplot(2,2,3)
    plot(sMGMean(1:PDmax),scqMean2(1:PDmax),'r*');hold on
    plot(sMGMean(PDmax+1:end),scqMean2(PDmax+1:end),'b*');hold on
    xlabel('IN','fontsize',15)
    ylabel('OUT','fontsize',15)
    title([name],'fontsize',15)
    hold off
Rgcut=tMean>Lcut & tMean<Rcut;
tMeanCut=tMean(Rgcut);
sMGMeanCut=sMGMean(Rgcut);
scqMeanCut=scqMean(Rgcut);
R2_1=PWP.ComputeR2(sMGMeanCut,scqMeanCut);
for j=1:pers
    Rg1per=1+j*Nsamp-Nsamp:j*Nsamp;
    scq1per=scqDs(Rg1per);
    
    R2_v(j)=PWP.ComputeR2(sMGMeanCut,scq1per(Rgcut));
end


figure(23)
subplot(2,2,4)
plot(tMean,sMGMean,'linewidth',3) ;hold on

plot(tMeanCut(1:1:end),scqMeanCut(1:1:end),'o','linewidth',3,'markersize',15) ;hold on
plot(tMean(1:1:end),scqMean(1:1:end),'--','linewidth',2,'markersize',10) ;hold on
plot(tMean(1:1:end),scqMean2(1:1:end),'*','linewidth',2,'markersize',10) ;

title([nameTitle,' R2:',num2str(R2_1),' R2bar:',num2str(var(R2_v)^0.5)],'fontsize',15)
fprintf('R2 %f,R2bar %f\n',R2_1,var(R2_v)^0.5)
hold off
