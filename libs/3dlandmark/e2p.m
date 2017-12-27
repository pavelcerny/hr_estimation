function y = e2p( x )
%E2P  Euclidean to projective coordinates.
%   Y = E2P( X ) returns projective coordinates of points in vector X.
%   (adds to X the last row of ones).
%
%   See also P2E, P2P1.

% (c) 2000-08-24, Martin Matousek
% Last change: $Date:: 2008-08-11 18:26:29 +0200 #$
%              $Revision: 19 $

y = [ x; ones( 1, size( x, 2 ) ) ];
