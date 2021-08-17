addpath(genpath('src'));
close all; clear; clc;
%% set number of links
mdl = Model(4);

%% settings
mdl = mdl.set('Phi0',rotx(pi),'Tsim',15);
mdl = mdl.setElements(50);
mdl = mdl.setFrequency(60);
mdl = mdl.setLength(0.065);

mdl = mdl.setControl( @(mdl) Controller(mdl) );

%% simulate with initial conditions
mdl = mdl.simulate;

%% post-processing data
l0 = mdl.get('l0');
l  = mean(l0)*(1+mdl.q(:,1:3:3*mdl.Nlink));
kx = mdl.q(:,2:3:3*mdl.Nlink);
ky = mdl.q(:,3:3:3*mdl.Nlink);
dkx = mdl.dq(:,2:3:3*mdl.Nlink);
dky = mdl.dq(:,2:3:3*mdl.Nlink);

f = figure(101); f.Name = 'Bishop parameters';
subplot(3,1,1); plot(mdl.t,l,'linewidth',2); 
ylabel('$l(t)$','interpreter','latex','fontsize',20);
subplot(3,1,2); plot(mdl.t,kx,'linewidth',2); 
ylabel('$\kappa_x(t)$','interpreter','latex','fontsize',20);
subplot(3,1,3); plot(mdl.t,ky,'linewidth',2); 
ylabel('$\kappa_y(t)$','interpreter','latex','fontsize',20);
xlabel('time $t$ [s]','interpreter','latex','fontsize',20);

%% play animation soft robot
f = figure(103);
Q = mdl.q;

for ii = 1:fps(mdl.t,15):length(mdl.t)
    figure(103); cla;
    mdl.show(Q(ii,:));
    axis equal; axis(0.2*[-1 1 -1 1 -1 0.1]);
    f.Name = [' Time =',num2str(mdl.t(ii),3)];
    drawnow();
end

%% model-based controller
function tau = Controller(mdl)
qd1 = [0;20;10];
qd2 = [0;-20;0];
qd3 = [0;0;30];
qd4 = [0;-40;0];
qd = [qd1;qd2;qd3;qd4];
KK = 1e-4*eye(12);
tau = mdl.G + mdl.K*(mdl.q) - KK*(mdl.q - qd);
end
    
    