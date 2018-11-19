%select data based on time-frequency analysis using spectrogram
load mergeddata.csv;
%time-frequency analysis using spectrogram
%information gain feature selection: 6,29,28,31,24,26
%==take features 6, 29, 28 only as the spectrograms of 31, 24 and 26 are very poor resolution
disp('size 20');
size20 = mergeddata(find(mergeddata(:,38)==20),:);
[s,~,~] = timefreq_of_single_breaksize(size20,6,1,'size 20%');
[sects_start_indices,~] = get_sections_of_a_signal(s);
train_sects20 = [19 20 21 22 23 24 25 26];%sections selected for training by visualizing spectrogram
%train_sects20 = [20 21 22 23 24 25 26];%sections selected for training by visualizing spectrogram
[train20,train20_indx] = select_sects(size20,sects_start_indices,train_sects20);
train20 = [train20 20*ones(size(train20,1),1)];
test20_indx=setdiff(1:size(size20,1),train20_indx);
test20=size20(test20_indx,:);
disp('size 60');
size60 = mergeddata(find(mergeddata(:,38)==60),:);
[s,~,~] = timefreq_of_single_breaksize(size60,6,2,'size 60%');
[sects_start_indices,~] = get_sections_of_a_signal(s);
train_sects60=[1 2 21 22 23 24 25 26 43];%sections selected by visualizing spectrogram
%train_sects60=[2 21 22 23 24 25 26 43];%sections selected by visualizing spectrogram
[train60,train60_indx] = select_sects(size60,sects_start_indices,train_sects60);
train60 = [train60 60*ones(size(train60,1),1)];
test60_indx=setdiff(1:size(size60,1),train60_indx);
test60=size60(test60_indx,:);
%disp('size 100');
size100 = mergeddata(find(mergeddata(:,38)==100),:);
[s,~,~] = timefreq_of_single_breaksize(size100,6,3,'size 100%');
[sects_start_indices,~] = get_sections_of_a_signal(s);
train_sects100=[1 2 10 21 22 23 24 25 26 27 28 35 36 38 40];%sections selected by visualizing spectrogram
train_sects100=[2 10 21 22 23 24 25 26 27 28 35 36 38 40];%sections selected by visualizing spectrogram
[train100,train100_indx] = select_sects(size100,sects_start_indices,train_sects100);
train100 = [train100 100*ones(size(train100,1),1)];
test100_indx=setdiff(1:size(size100,1),train100_indx);
test100=size100(test100_indx,:);
disp('size 120');
size120 = mergeddata(find(mergeddata(:,38)==120),:);
[s,~,~] = timefreq_of_single_breaksize(size120,6,4,'size 120%');
[sects_start_indices,~] = get_sections_of_a_signal(s);
train_sects120=[1 7 8 21 22 23 24 25 26 27 28 33 34 35 36 37 40 41];%sections selected by visualizing spectrogram
%train_sects120=[7 8 21 22 23 24 25 26 27 28 33 34 35 36 37 40 41];%sections selected by visualizing spectrogram
[train120,train120_indx] = select_sects(size120,sects_start_indices,train_sects120);
train120 = [train120 120*ones(size(train120,1),1)];
test120_indx=setdiff(1:size(size120,1),train120_indx);
test120=size120(test120_indx,:);
disp('size 200');
size200 = mergeddata(find(mergeddata(:,38)==200),:);
[s,~,~] = timefreq_of_single_breaksize(size200,6,5,'size 200%');
[sects_start_indices,~] = get_sections_of_a_signal(s);
train_sects200=[1 18 19 21 22 23 24 25 40 41 42 43 44];%sections selected by visualizing spectrogram
%train_sects200=[18 19 21 22 23 24 25 40 41 42 43 44];%sections selected by visualizing spectrogram
[train200,train200_indx] = select_sects(size200,sects_start_indices,train_sects200);
train200 = [train200 200*ones(size(train200,1),1)];
test200_indx=setdiff(1:size(size200,1),train200_indx);
test200=size200(test200_indx,:);
train0 = zeros(size(train20,1),37);%break size 0% for training
label0= zeros(size(train20,1),1);
size0 = mergeddata(find(mergeddata(:,38)==0),:);
for i=1:length(train0)
    train0(i,:) = size0(1,1:37);
end
train0 = [train0 label0];
test0 = zeros(541-size(train20,1),37);%break size 0% for testing
label0= zeros(541-size(train20,1),1);
for i=1:size(test0,1)
    test0(i,:) = size0(1,1:37);
end
test0 = [test0 label0];
minitrain = [train0;train20;train60;train100;train120;train200];
minitest = [test0;test20;test60;test100;test120;test200];
hold off
%figure(6)%power spectra density plots using all data
%[psd20,f20]=plot_psd(size20,6);
%[psd60,f60]=plot_psd(size60,6);
%[psd100,f100]=plot_psd(size100,6);
%[psd120,f120]=plot_psd(size120,6);
%[psd200,f200]=plot_psd(size200,6);
%[psd20,f20]=plot_psd(size20,29);
%[psd60,f60]=plot_psd(size60,29);
%[psd100,f100]=plot_psd(size100,29);
%[psd120,f120]=plot_psd(size120,29);
%[psd200,f200]=plot_psd(size200,29);
%[psd20,f20]=plot_psd(size20,28);
%[psd60,f60]=plot_psd(size60,28);
%[psd100,f100]=plot_psd(size100,28);
%[psd120,f120]=plot_psd(size120,28);
%[psd200,f200]=plot_psd(size200,28);
%figure(7)
%plot(f20,10*log10(psd20)); 
%hold on
%plot(f60,10*log10(psd60),'r'); 
%hold on;
%plot(f100,10*log10(psd100),'k');
%hold on
%plot(f120,10*log10(psd120),'g');
%hold on
%plot(f200,10*log10(psd200),'m');
%title('Power Spectra Density Estimate using Signal 6 on All Size 60% Data');
%title('Power Spectra Density Estimate using Signal 6 on All Size 20% Data');
%title('Power Spectra Density Estimate using Signal 6 on All Data');
%title('Power Spectra Density Estimate using Signal 29 on All Data');
%title('Power Spectra Density Estimate using Signal 28 on All Data');
%legend('size 20%','size 60%','size 100%','size 120%','size 200%','Location','NorthEast');
%xlabel('Frequency (Hz)'); ylabel('Power/frequency (dB/Hz)');
%hold off
%figure(8)%power spectra density plots using minimum data
%[psd20,f20]=plot_psd(train20,6);
%[psd60,f60]=plot_psd(train60,6);
%[psd100,f100]=plot_psd(train100,6);
%[psd120,f120]=plot_psd(train120,6);
%[psd200,f200]=plot_psd(train200,6);
%[psd20,f20]=plot_psd(train20,29);
%[psd60,f60]=plot_psd(train60,29);
%[psd100,f100]=plot_psd(train100,29);
%[psd120,f120]=plot_psd(train120,29);
%[psd200,f200]=plot_psd(train200,29);
%[psd20,f20]=plot_psd(train20,28);
%[psd60,f60]=plot_psd(train60,28);
%[psd100,f100]=plot_psd(train100,28);
%[psd120,f120]=plot_psd(train120,28);
%[psd200,f200]=plot_psd(train200,28);
%figure(9)
%plot(f20,10*log10(psd20)); 
%hold on
%plot(f60,10*log10(psd60),'r'); 
%hold on;
%plot(f100,10*log10(psd100),'k');
%hold on
%plot(f120,10*log10(psd120),'g');
%hold on
%plot(f200,10*log10(psd200),'m');
%title('Power Spectra Density Estimate using Signal 6 on 39.9% of Size 60% Data');
%title('Power Spectra Density Estimate using Signal 6 on 39.9% of Size 20% Data');
%title('Power Spectra Density Estimate using Signal 6 on 34% of All Data');
%title('Power Spectra Density Estimate using Signal 29 on 34% of All Data');
%title('Power Spectra Density Estimate using Signal 28 on 34% of All Data');
%legend('size 20%','size 60%','size 100%','size 120%','size 200%','Location','NorthEast');
%xlabel('Frequency (Hz)'); ylabel('Power/frequency (dB/Hz)');
%hold off

%function testdata2 = remove_common_rows(testdata,traindata)
%remove the rows of testdata found in traindata
%output: testdata with the common rows removed
%k=1;
%for i=1:size(testdata,1)
%    found=0;
%    for j=1:size(traindata,1)
%        if testdata(i,:)==traindata(j,:)
%            found=1;
%            break;
%        end
%    end
%    if found==0
%        testdata2(k,:)=testdata(i,:);
%        k=k+1;
%    end
%end
%end
function [data,indices]=select_sects(breaksizedata,sects_start_indices,sects_selected)
%return: selected data
%        indices of the data in set of all data
start_indices = sects_start_indices(sects_selected);
end_indices = zeros(size(start_indices));
for i=1:length(start_indices)
    end_indices(i) = start_indices(i)+23;%window size: 24
    if end_indices(i) > size(breaksizedata,1)
        end_indices(i) = size(breaksizedata,1);
    end
end
%start_indices
%end_indices
m=length(start_indices);%get no. of sections
%data=zeros(m*24,37);%section length 24, 37 signals
%s=1;
data=[];
indices=[];
for i=1:length(start_indices)
    data = [data;breaksizedata(start_indices(i):end_indices(i),1:37)];
    indices = [indices start_indices(i):end_indices(i)];
end
data=unique(data,'rows');
indices=unique(indices);
end
function [sects_start_indices,sects_nums] = get_sections_of_a_signal(stft)
no_of_sects = size(stft,2);
allsects_start_indices = zeros(1,no_of_sects);%start indices of sections in whole signal
indx=1;
for i=1:no_of_sects
    allsects_start_indices(i)=indx;
    indx = indx+12;%window size: 24; overlap 50%
end
sects_nums=1:no_of_sects;
sects_start_indices=allsects_start_indices(sects_nums);
end
%===compute the magnitudes, dB and dB/frequency of STFT of the sections
%mag = stft.*conj(stft);%magnitude squared
%mag = abs(stft);
%m=sum(sum(mag,1))/numel(stft);
%calculate dB/freq (the colour in spectrogram)
%r=size(stft,1);
%fa=4.5/r;
%fs=541/60;%sample rate
%dbfreq=zeros(size(stft));
%for j=1:size(stft,2)
%    magj = mag(:,j);
    %db = 20*log10(magj./max(magj));
    %db = 20*log10(magj./mean(magj));
    %db = 20*log10(magj./m);
    %db = 20*log10(magj);
    %dbfreq(:,j)=db/fs;
    %for i=1:r
    %    fi=fa*i;
    %    dbfreq(i,j)=db(i)/fi;
    %end    
%end
%dbfreq
%===get the sections which have dB/Hz (decibel per Hz) above the threshold min_dbfr
%min_dbfr = -5;
%i=1;
%sects_nums=[];
%for j=1:no_of_sects
%    dbfr = dbfreq(:,j);
%    if min(dbfr)>=min_dbfr
%        sects_nums(i)=[j];
%        i=i+1;
%    end
%end
%rank the sections according to their minimum dB/Hz
%sects_min_dbfr=zeros(1,no_of_sects);
%for j=1:no_of_sects
%    sects_min_dbfr(j)=min(dbfreq(:,j));
%end
%sects_min_dbfr2 = sort(sects_min_dbfr,'descend');
%sects_nums=zeros(1,no_of_sects);
%for i=1:length(sects_min_dbfr2)
%    sects_nums(i) = find(sects_min_dbfr==sects_min_dbfr2(i));
%end
function [psd,f]=plot_psd(asizedata,sigNum)
sig = asizedata(:,sigNum);
fs=541/60;
%periodogram(sig,[],[],fs);
[psd,f]=periodogram(sig,[],[],fs);
end
function [s,w,t] = timefreq_of_single_breaksize(asizedata,sigNum,plotNum,sizelabel)
sig = asizedata(:,sigNum);
[s,w,t] = plotspectogram(plotNum,sizelabel+string(' Signal ')+sigNum,sig);
end
function [s,w,t] = plotspectogram(fig_no,fig_title,sig)
%spectrogram(x,window,noverlap,nfft,fs,freqloc) 
%x, signal
%window, window size (number of samples in a window)
%noverlap, number of overlapped samples between adjacent segments 
%nfft, segment length (number of samples of a segment)
%fs, sample rate (Hz)
%freqloc, frequency display axis
figure(fig_no);
window = round(numel(sig)/4.5);
window = round(window/5);%window size: ~24
%window = 100;
%window=50;
%window=20;
%window=256;
%window=300;
%noverlap=250;
noverlap=[];% 50% overlap between sections
%noverlap=round(80/100*window);%80% overlap between sections
%nfft=[];
nfft=numel(sig);
%nfft=256;
%nfft=300;
%sampleRate = ( maximumVal - minimumVal ) / numVals - 1;
%fs = (max(sig)-min(sig))/(length(sig)-1);
fs=541/60;%sampling rate
%fs=420/60;
%fs=410/60;
freqloc='yaxis';
%[s,w,t] = spectrogram(sig,hann(window),noverlap,nfft,fs,freqloc);
%spectrogram(sig,hann(window),noverlap,nfft,fs,freqloc);
[s,w,t] = spectrogram(sig,hamming(window),noverlap,nfft,fs,freqloc);
spectrogram(sig,hamming(window),noverlap,nfft,fs,freqloc);
%[s,w,t] = spectrogram(sig,nuttallwin(window),noverlap,nfft,fs,freqloc);
%spectrogram(sig,nuttallwin(window),noverlap,nfft,fs,freqloc);
%[s,w,t] = spectrogram(sig,triang(window),noverlap,nfft,fs,freqloc);
%spectrogram(sig,triang(window),noverlap,nfft,fs,freqloc);
%[s,w,t] = spectrogram(sig,taylorwin(window),noverlap,nfft,fs,freqloc);
%spectrogram(sig,taylorwin(window),noverlap,nfft,fs,freqloc);
%[s,w,t] = spectrogram(sig,tukeywin(window),noverlap,nfft,fs,freqloc);
%spectrogram(sig,tukeywin(window),noverlap,nfft,fs,freqloc);
%[s,w,t] = spectrogram(sig,window,noverlap,nfft,fs,freqloc);
%spectrogram(sig,window,noverlap,nfft,fs,freqloc);
%[s,w,t] = spectrogram(sig,barthannwin(window),noverlap,nfft,fs,freqloc);
%spectrogram(sig,barthannwin(window),noverlap,nfft,fs,freqloc);
%[s,w,t] = spectrogram(sig,rectwin(window),noverlap,nfft,fs,freqloc);
%spectrogram(sig,rectwin(window),noverlap,nfft,fs,freqloc);
%[s,w,t] = spectrogram(sig,gausswin(window),noverlap,nfft,fs,freqloc);
%spectrogram(sig,gausswin(window),noverlap,nfft,fs,freqloc);
%[s,w,t] = spectrogram(sig,kaiser(window),noverlap,nfft,fs,freqloc);
%spectrogram(sig,kaiser(window),noverlap,nfft,fs,freqloc);
%[s,w,t] = spectrogram(sig,parzenwin(window),noverlap,nfft,fs,freqloc);
%spectrogram(sig,parzenwin(window),noverlap,nfft,fs,freqloc);
%[s,w,t] = spectrogram(sig,blackmanharris(window),noverlap,nfft,fs,freqloc);
%spectrogram(sig,blackmanharris(window),noverlap,nfft,fs,freqloc);
%[s,w,t] = spectrogram(sig,chebwin(window),noverlap,nfft,fs,freqloc);
%spectrogram(sig,chebwin(window),noverlap,nfft,fs,freqloc);
%[s,w,t] = spectrogram(sig,enbw(window),noverlap,nfft,fs,freqloc);
%spectrogram(sig,enbw(window),noverlap,nfft,fs,freqloc);
%[s,w,t] = spectrogram(sig,flattopwin(window),noverlap,nfft,fs,freqloc);
%spectrogram(sig,flattopwin(window),noverlap,nfft,fs,freqloc);
%[s,w,t] = spectrogram(sig,bartlett(window),noverlap,nfft,fs,freqloc);
%spectrogram(sig,bartlett(window),noverlap,nfft,fs,freqloc);
xlim([0 60]);
%xlim([20 21]);
%ylim([0,0.5]);
%ps
%[s,w,t]=spectrogram(sig,[],[],[],[],freqloc);
%spectrogram(sig,[],[],[],[],freqloc);
%xlim([0 1]);
title(fig_title);
hold off;
end
%function [max_sects_start_indices, mag_diverse2] = get_max_diverse_freqmag_sections_of_a_signal(stft)
%input: a STFT of a signal (a mxn matrix with m the number of signal
%sections, n the number of frequencies; each column being a DFT of a section)
%output: start indices of the signal sections with the most diverse frequency magnitudes
%no_of_sects = size(stft,2);
%allsects_start_indices = zeros(1,no_of_sects);%start indices of sections in whole signal
%indx=1;
%for i=1:no_of_sects
%    allsects_start_indices(i)=indx;
%    indx = indx+12;%window size: ~24
%end
%compute the magnitudes of STFT of the sections
%mag = abs(stft);
%get the sections which have the most diverse frequency magnitudes
%mag=sort(mag);%sort the magnitudes of each column (DFT) in ascending order
%magstd=std(mag);%compute std of the magnitudes of each column (DFT)
%k=size(stft,1);%no. of frequencies
%mag_diverse = zeros(1,no_of_sects);
%for j=1:no_of_sects
%   dft=mag(:,j);
%   s=0;
%    for indx=1:k-1
%        s=s+(abs(dft(indx+1)-dft(indx)));
%    end
%    diff = s/k;
    %mag_diverse(j) = magstd(j)+diff;%magnitude diversity
%    mag_diverse(j) = diff;
%end
%mag_diverse2=sort(mag_diverse,'descend');
%get the sections of the sorted magnitude diversities
%sects_nums=zeros(1,no_of_sects);%section numbers
%for i=1:length(mag_diverse2)
%    sects_nums(i)=find(mag_diverse==mag_diverse2(i));        
%end
%max_sects_start_indices = allsects_start_indices(sects_nums);
%end