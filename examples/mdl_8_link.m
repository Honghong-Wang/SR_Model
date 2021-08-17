addpath(genpath('src'));
close all; clear; clc;
%% set number of links
mdl = Model(8,'MaxItr',1);

%% settings
mdl = mdl.set('Tsim',10);
mdl = mdl.setElements(50);
mdl = mdl.setFrequency(50);
mdl = mdl.setLength(0.03);
mdl = mdl.setMass(0.1);

mdl.tau = @(mdl) Controller(mdl);
%% simulate with initial conditions
mdl.q0(2:3:end) = 5;
mdl = mdl.simulate;

%% post-processing data
l0 = mdl.get('l0');
l  = mean(l0)*(1+mdl.q(:,1:3:3*mdl.Nlink));
kx = mdl.q(:,2:3:3*mdl.Nlink);
ky = mdl.q(:,3:3:3*mdl.Nlink);

figure(101);
subplot(3,1,1); plot(mdl.t,l,'linewidth',2);
subplot(3,1,2); plot(mdl.t,kx,'linewidth',2);
subplot(3,1,3); plot(mdl.t,ky,'linewidth',2);

%% animate soft robot
figure(102);
Q = mdl.q;

for ii = 1:fps(mdl.t,30):length(mdl.t)
    
    figure(102); cla;
    
    mdl.show(Q(ii,:),col(1));
    axis equal;
    axis(0.25*[-0.4 1.25 -1 1 -1 1]);
    view(0,0);

    
    title('\color{blue} Soft robot manipulator (N=8)',...
        'interpreter','tex','fontsize',18);
    
    drawnow(); grid on; box on; 
    background('w');
    set(gca,'linewidth',2.5);
    
    if ii == 1, gif('mdl_8_link.gif','frame',gcf,'nodither');
    else, gif;
    end
    
end

function tau = Controller(mdl)
qd = mdl.q0;
qd(11) = 15;

tau = mdl.G*0;
end
    
    