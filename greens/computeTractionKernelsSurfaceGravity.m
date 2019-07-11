function [K33s, K33d, K33n]=computeTractionKernelsSurfaceGravity(shz,rcv,G,nu)
N=length(shz.L);
M=size(rcv.xc,1);

lambda=G*2*nu/(1-2*nu);

textprogressbar('# surface gravity traction kernels: ');

% initialize stress kernels
Kes=zeros(M,N);
Ked=zeros(M,N);
Ken=zeros(M,N);

for k=1:N
    
    if 0==mod(k-1,2)
        textprogressbar((N+k)/(N)*100);
    end
    
    % stress components
    [s22,s12,s23,s11,s13,s33]=computeStressSurfaceGravity(rcv.xc(:,2),rcv.xc(:,1),-rcv.xc(:,3), ...
        shz.x(k,2),shz.x(k,1),-shz.x(k,3),shz.L(k),shz.T(k),shz.W(k),shz.strike(k), ...
        e(1,j),e(2,j),e(3,j),e(4,j),e(5,j),e(6,j), ...
        G,nu);
    s13=-s13;
    s23=-s23;
    
    % full traction vector on receiver faults
    t=[...
        s11.*rcv.nv(:,1)+s12.*rcv.nv(:,2)+s13.*rcv.nv(:,3), ...
        s12.*rcv.nv(:,1)+s22.*rcv.nv(:,2)+s23.*rcv.nv(:,3), ...
        s13.*rcv.nv(:,1)+s23.*rcv.nv(:,2)+s33.*rcv.nv(:,3)];
    
    % shear stress in strike direction
    Kes(:,k)=sum(t.*rcv.sv,2);
    
    % shear stress in dip direction
    Ked(:,k)=sum(t.*rcv.dv,2);
    
    % stress in normal direction
    Ken(:,k)=sum(t.*rcv.nv,2);
    
end

K33s=Kes;
K33d=Ked;
K33n=Ken;

textprogressbar(100);
textprogressbar('');

end
