function [ HiPassStruct,  HrEstStruct,inserted_more] = insertVirtualMeasurements( last_measurement,...
    last_timestamp, measurement, timestamp, HiPassStruct,  HrEstStruct, include_up_to,...
    teoretical_fps, inserted_more)

diff = timestamp-last_timestamp;
teoretical_diff = 1/teoretical_fps;

if diff > teoretical_diff
    if inserted_more > 0
        no_included = floor(min(diff/teoretical_diff - 1, include_up_to));
    else
        no_included = floor(min(diff/teoretical_diff, include_up_to));
    end
    i = 0;
    time_step = diff/no_included;
    
    if i < no_included
        inserted_more =  1/(diff-teoretical_diff);
    else
        inserted_more = inserted_more - 1;
    end
    
    
    while i< no_included
        new_ts = last_timestamp + (i+1)*time_step;
        new_measure = (measurement-last_measurement) * (new_ts-last_timestamp) / ( timestamp - last_timestamp) + last_measurement;
        
        [new_hiPassedMeasurement, HiPassStruct] = hiPassFilter( new_measure, HiPassStruct);
        HrEstStruct  = hrFitnessUpdate( new_hiPassedMeasurement, new_ts, HrEstStruct );
        
        i=i+1;
        
    end
else
    return
end

end

