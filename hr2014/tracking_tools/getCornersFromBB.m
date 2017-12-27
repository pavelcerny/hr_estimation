function [ corners ] = getCornersFromBB( bb )
%bb in form [topleftX topleftY botRightX botRightY]


corners = [bb(1) bb(3) bb(3) bb(1) ;...
           bb(2) bb(2) bb(4) bb(4) ];

end

