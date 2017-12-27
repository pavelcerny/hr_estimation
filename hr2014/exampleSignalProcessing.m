%% shows how hiPassFilter and hrFitnessEstimator works
clearvars
if ~exist('signal','var')
    load('/home/noxx/PavelCerny/video/work/signal/cerny_01_cam2.avi.25.face.gauss.signal.mat');
end

length = size(signal,2);
hiPassedSignal = zeros(3,length);

% set constant params
hiPassFrameLength = 15;
hrFitnessFrameLength = 60;
estimateFitnessRate = 15;

% run program
DataStruct = initHiPassFilter(hiPassFrameLength);

for i=1:length
    measurement = signal(:,i);
    
    [hiPassedMeasurement, DataStruct] = hiPassFilter( measurement, DataStruct);
    
    hiPassedSignal(:,i) = hiPassedMeasurement;
end

%show result
  plot(hiPassedSignal');

figure;

%% estimate HR
% requieres hipassed measurement with timestamp

[ DataHR ] = initHrFitnessEstimator(hrFitnessFrameLength);

spectrums = zeros(DataHR.hrUpperBound-DataHR.hrLowerBound+1,floor(length/estimateFitnessRate)) ;
j=1;

for i=1:length
    timestamp = time(i);
    measurement = hiPassedSignal(:,i);
    
    [ DataHR ] = hrFitnessUpdate( measurement, timestamp, DataHR );
    
    if mod(i,estimateFitnessRate) ==  0
        [ fitness, DataHR ] = hrFitnessEstimate( DataHR );
        spectrums(:,j) = fitness';
        j = j+1;
    end
end

%show results
imagesc(spectrums);
colormap jet;
xticklabels = 15:15:length;
xticks = linspace(1, size(spectrums, 2), numel(xticklabels));
set(gca, 'XTick', xticks, 'XTickLabel', xticklabels)

yticklabels = DataHR.hrUpperBound:-20:DataHR.hrLowerBound;
yticks = linspace(1, size(spectrums, 1), numel(yticklabels));
set(gca, 'YTick', yticks, 'YTickLabel', flipud(yticklabels(:)))