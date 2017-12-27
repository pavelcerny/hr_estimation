function [F, dF, Fi] = fl3d_obj( theta, State  )
% FL3d_OBJ landmark fit criterion with gradient
%  
%
    global Timming;

    % Jacobian of the projection function
    [Jp, x] = Jacobian_theta( theta, State.K, State.L3d );
    
    % compute gradient of the appearance matching function
    nL = numel( State.LandmarkModel );
    Fi = zeros(nL,1);
    Jd = zeros(nL,2);
    for i = 1 : numel( State.LandmarkModel )
        
        [val,gradCol,gradRow,cpuTime] = lf_lbppyrfilter_eval( State.filterHandle{i}, [x(1,i); x(2,i)] );
         
        if isnan(val)
            val = -1000; gradCol = -1000; gradRow = -1000;
        end
        
        Fi(i)   = -val;
        Jd(i,:) = -[gradCol gradRow];
        
        Timming.filter      = Timming.filter + cpuTime;
        Timming.filterCalls = Timming.filterCalls + 1;
    end
  
    % gradient of composed function
    dFi = NaN(size( State.L3d,2), length( theta ) );
    for i = 1 : length( Jp )
        dFi(i,:) = Jd(i,:)*Jp{i};
    end
    dF = sum( dFi );
    
    F  = sum( Fi );
    
return;

