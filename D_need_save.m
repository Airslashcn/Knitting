%save XL
tper=tPer-t(1);
XLtper;
 nameTitle=name;
 csvwrite(['.\心率\',nameTitle],[ tper,XLtper' ])
%save Voltage high
for i=1:length(sW)-1
    Swave=sW{i+1};
    Vh(i)=max(Swave);
    Vl(i)=min(Swave(1:fix(end/2)));
end
Vc=Vh-Vl;
csvwrite(['.\电压最大（毫伏）\',nameTitle],[ Vh' ])
csvwrite(['.\电压变化（毫伏）\',nameTitle],[ Vc' ])
%save every wave
filename = ['./bobo/',nameTitle];sheet = 1;
for i=1:length(sW)-1
    try
    Sxls = sW{i+1};Txls = tW{i+1};
    xlRange = sprintf('A%d',i*2-1);
    xlswrite(filename,Txls/Fs,sheet,xlRange)
    xlRange = sprintf('A%d',i*2);
    xlswrite(filename,Sxls',sheet,xlRange)
    end
end
