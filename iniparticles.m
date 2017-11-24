%% This routine initializes the particles. It is only called when seeding
% particles. It creates the variables, and assigns all intrinsec particles
% characteristics: the DOY, ID, and the vertical sinking velocity assigned
% to the particle. The time-dependant variables at the particles' location
% are assigned in another routine: "getpartivar.m".

disp('SEEDING PARTICLES...')

if tt == particle.initime
    % If first seed, create the structure for particle data
    parti.doy = [];
    parti.id = [];
    parti.x = [];
    parti.y = [];
    parti.z = [];
    parti.u = [];
    parti.v = [];
    parti.w = [];
    parti.wsink = [];
    parti.wtotal = [];
    parti.s = [];
    parti.t = [];
    parti.rho = [];
end

% Number of particle to seed
nprtoseed = (particle.irange/particle.irez)*(particle.jrange/particle.jrez)*(particle.krange/particle.krez)*particle.numofclasses;
disp(['Seeding ',num2str(nprtoseed),' particles'])

% particle day of year
parti.doy = cat(1,parti.doy,tt*ones(nprtoseed,1));

% Particle ID
blop = ((tt-particle.initime)/particle.inifreq*nprtoseed+1:(tt-particle.initime)/particle.inifreq*nprtoseed+nprtoseed);
parti.id = cat(1,parti.id,blop'); clear blop

for theclass = 1:particle.numofclasses
    % Partcle seeding location
    parti.x = cat(1,parti.x,repmat(particle.istart:particle.irez:particle.istart + ...
        particle.irange-particle.irez,...
        [1 particle.jrange/particle.jrez])');
    blop = repmat(particle.jstart:particle.jrez:particle.jstart + ...
        particle.jrange-particle.jrez,...
        [particle.irange/particle.irez 1]);
    blop = blop(:);
    parti.y = cat(1,parti.y,blop); clear blop
    parti.z = cat(1,parti.z,repmat(particle.kstart:particle.krez:particle.kstart + ...
        particle.krange-particle.krez,...
        [1 particle.jrange/particle.jrez*particle.irange/particle.irez])');
    
%     % check that particles are released in domain
%     if isempty(find(parti.x<min(model.x) | parti.x>max(model.x)))==0
%         error([num2str(length(find(parti.x<min(model.x) | parti.x>max(model.x)))), 'particles are seeded out of the domain'])
%     end
%     if isempty(find(parti.y<min(model.y) | parti.y>max(model.y)))==0
%         error([num2str(length(find(parti.y<min(model.y) | parti.y>max(model.y)))), 'particles are seeded out of the domain'])
%     end
%     if isempty(find(parti.z<min(model.z) | parti.z>max(model.z)))==0
%         error([num2str(length(find(parti.z<min(model.z) | parti.z>max(model.z)))), 'particles are seeded out of the domain'])
%     end
    
    % Prescribe sinking velocity (in m/s)
    if theclass == 1
        parti.wsink = cat(1,parti.wsink,zeros(nprtoseed/particle.numofclasses,1));
    elseif theclass == 2
        parti.wsink = cat(1,parti.wsink,-1/86400*ones(nprtoseed/particle.numofclasses,1));
    elseif theclass == 3
        parti.wsink = cat(1,parti.wsink,-10/86400*ones(nprtoseed/particle.numofclasses,1));
    elseif theclass == 4
        parti.wsink = cat(1,parti.wsink,-50/86400*ones(nprtoseed/particle.numofclasses,1));
    else
        error('blop')
    end
end; clear theclass

% Particle velocity at timestep
% Must be zero when seeded
parti.u = cat(1,parti.u,zeros(nprtoseed,1));
parti.v = cat(1,parti.v,zeros(nprtoseed,1));
parti.w = cat(1,parti.w,zeros(nprtoseed,1));
parti.wtotal = cat(1,parti.wtotal,parti.w+parti.wsink);

% Get particle characteristics
% Must be zero when seeded
parti.t = cat(1,parti.t,zeros(nprtoseed,1));
parti.s = cat(1,parti.s,zeros(nprtoseed,1));
parti.rho = cat(1,parti.rho,zeros(nprtoseed,1));
clear nprtoseed 

disp('DONE')
disp('%%%%%%%%%%%%%%%%%')
disp(' ')