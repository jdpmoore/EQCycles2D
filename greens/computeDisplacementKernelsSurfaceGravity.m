function [L33]=computeDisplacementKernelsSurfaceGravity(shz,nu,x)
% INPUT:
%
% shz     geometry.shearZone object
% nu      Poisson's ratio
% x       coordinates of observation point (east, north, up)
% vecsize number of component for displacement vector
%
%
% DATA LAYOUT:
%
%       /e1               \
%       |n1               |
%       |u1               |
%       |e2               |
%       |n2               |
%       |u2               |
% L33 = | .               |
%       | .               |
%       | .               |
%       | .               |
%       |en               |
%       |nn               |
%       \un               /
%
% James D. P. Moore, 18/06/2019
% Earth Observatory of Singapore
%
D=size(x,1);
textprogressbar('# gravity displacement kernels: ');
    G=zeros(3*D,shz.N);
    for i=1:shz.N
        if 0==mod(i-1,2)
            textprogressbar((i/shz.N)*100);
        end
        [u1,u2,u3]=computeDisplacementSurfaceGravity( ...
            x(:,2),x(:,1),-x(:,3), ...
            shz.x(i,2),shz.x(i,1),-shz.x(i,3), ...
            shz.L(i),shz.T(i),shz.strike(i), ...
            1e-6,1,nu);
          u=[u2,u1,-u3]';       
        G(:,i)=u(:);
    end
L33=G;
textprogressbar(100);
textprogressbar('');
end



