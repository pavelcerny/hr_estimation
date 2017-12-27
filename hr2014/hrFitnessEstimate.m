function [ fitness, Data, models ,likelyhood] = hrFitnessEstimate( Data )
N_PARAMS = 5;
models.projVector = zeros(3,Data.hrNoPossibleFQ);
models.a0 = zeros(1,Data.hrNoPossibleFQ);
models.a1 = zeros(1,Data.hrNoPossibleFQ);
models.omega = zeros(1,Data.hrNoPossibleFQ);
models.phi = zeros(1,Data.hrNoPossibleFQ);
%models = [ w1 w2 w3 | a0 a1 | omega | cosphi sinphi ]

switch N_PARAMS
    case 5
P = [Data.cachedMeasures(:,1:Data.frameLength)' -ones(Data.frameLength,1) -Data.cachedTimestamps(1,1:Data.frameLength)'];
    case 4
P = [Data.cachedMeasures(:,1:Data.frameLength)' -ones(Data.frameLength,1)];
    case 3
P = [Data.cachedMeasures(:,1:Data.frameLength)'];
    otherwise
        error('unsupported number of params');
end


for hr = Data.hrLowerBound:Data.hrUpperBound
    omega = 2*pi*hr/60; % divided by 60seconds, bcs hr is in bmp units
    omegaTime = omega*Data.cachedTimestamps(1:Data.frameLength);
    Q = [sin(omegaTime)' cos(omegaTime)'];
    QQ = Q'*Q;
    
    
    M = P'*Q;
    H = P'*P;
    iH = pinv(H);
    N = (QQ - M'*iH*M);
    [V,D] = eig(N);
    [leastErr,idx] = min([D(1,1) D(2,2)]);
    
    hr_idx = hr-Data.hrLowerBound+1;
    
    Data.hrFitness(hr_idx)=leastErr;
    
    v=V(:,idx);
    u = iH*P'*Q*v;
    models.projVector(:,hr_idx) = u(1:3);
    models.a0(hr_idx)=u(4);
    models.a1(hr_idx)=u(5);
    models.omega(hr_idx) = omega;
    models.phi(hr_idx) = atan2(v(2),v(1));    
end

fitness = Data.hrFitness / Data.frameLength;
% fitness = Data.hrFitness / sum(Data.hrFitness);
% likelyhood = 1- ( (Data.hrFitness-0.15)/max(Data.hrFitness)*0.5+0.15 ) ;

end

