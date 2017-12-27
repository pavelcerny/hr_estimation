function y = p2e(x)
%P2E  Projective to euclidean coordinates.
%   Y = P2E( X ) returns euclidean coordinates of points in vector X in 
%   projective coordinates.
%
%   See also E2P, P2P1.

% (c) 2000-08-24, Martin Matousek
% Last change: $Date:: 2008-08-11 18:26:29 +0200 #$
%              $Revision: 19 $

s = size( x, 1 );

y = x( 1:end-1, : ) ./ x( ones( s-1,1) * s, : );
