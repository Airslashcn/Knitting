d2pkO=zeros(1,pers);
% PKHratio=zeros(1,pers);
Pk1=zeros(1,pers);
pk2=zeros(1,pers);
for i=1:pers
    lpk=1;ct=1;
    while lpk<2
    [HpkO,pkSO]=findpeaks(PWP.FilterHigh(tMean,10+ct,scqO(1+i*Nsamp-Nsamp:i*Nsamp)));
    lpk=length(pkSO);
    ct=ct+1;
    end
    d2pkO(i)=(2*pi/w)*(pkSO(2)-pkSO(1))/Nsamp;
%     PKHratio(i)=HpkO(2)/HpkO(1);
Pk1(i)=HpkO(1);
Pk2(i)=HpkO(2);
end
[d2pkOut,d2pkOutE]=PWP.MeanAndErrorBar(d2pkO);
% [PKHr,PKHrE]=PWP.MeanAndErrorBar(PKHratio);
[Pk1M,Pk1E]=PWP.MeanAndErrorBar(Pk1);
[Pk2M,Pk2E]=PWP.MeanAndErrorBar(Pk2/Pk1M);
[Pk1M,Pk1E]=PWP.MeanAndErrorBar(Pk1/Pk1M);



d2pkIn=(2*pi/w)*(pkSMG(2)-pkSMG(1))/Nsamp;

fprintf('d2peak :%f (%f) %f\n',d2pkOut,d2pkIn,d2pkOutE)
fprintf('pk1 :%f (%f) %f\n',Pk1M,HpkMG(1),Pk1E)
fprintf('pk2 :%f (%f) %f\n',Pk2M,HpkMG(2),Pk2E)