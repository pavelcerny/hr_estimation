
%plot fit of model to signal
figure;
plot(timestamps_ordered,curve,'Color',[0 0 1]); hold on;
plot(timestamps_ordered,sinusoid,'Color','r', 'LineWidth',1.5);
legend('signal','model');
xlabel('t');


break; 

%plot fitness function with peak
plot(HrEstStruct.hrLowerBound:HrEstStruct.hrUpperBound,fitness);
  xlabel('HR');
  ylabel('\epsilon^2(t)');
  hold on
  
[hr,idx] = findHrFromFitness(HrEstStruct,fitness)
h = plot(hr,fitness(idx),'o');
set(h,'Color','r','LineWidth',2);


 
