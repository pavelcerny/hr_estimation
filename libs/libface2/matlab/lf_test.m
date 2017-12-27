addpath ./tests;
addpath ../testimg;

filelist = dir('tests');

fprintf('Testing:\n');
for i=1:numel(filelist)
    
    if ~filelist(i).isdir & strcmp(filelist(i).name(end-6:end),'_test.m')  
        
        funName =  filelist(i).name(1:end-2);
        fprintf('\n%s\n', funName);       
        
        if feval( funName )
            fprintf('Test passed.\n'); 
        else
            fprintf('Test FAILED!!! booo.\n'); 
        end
    end
end