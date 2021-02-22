%Probability3
clear;
clear all;
%%
%ISS state vector
% x_t = -155.308154626131    -4468.84231562975    -5118.58170114094    7.15270950143093    -2.16658148201390    1.67449416556627
% x_r = -155.308154626131    -4468.84231562975    -5118.58170114094    -7.15270950143093    2.16658148201390    -1.67449416556627

State_t = [732.588232789672  6751.01261162200	349.775048211597	-4.69570796668911	0.819521664362943	-5.99041204117603];
State_r = [634.152369195065  6776.35123257810	448.607273488693	-1.06630928227009	-0.273021193206265	7.84806210493506];
%179715 possibly the catID

[Ut Vt Wt] = orc(State_t);
[Ur Vr Wr] = orc(State_r);

%Covariance alreday in uvw
C_t = [3.43277238027061	-105.713201431152	0.000321901674039412;
-105.713201431152	3870.35286308290	0.259190058043855;
0.000321901674039412	0.259190058043855	0.102204931140936];

C_r = [0.00428779626076860	-0.0628791393741612	0.000198327124917972;
-0.0628791393741612	1.50167461537386	-0.00953017236297744;
0.000198327124917972	-0.00953017236297744	0.00198148637104321];

Ruvw_t = [Ut(1) Ut(2) Ut(3); Vt(1) Vt(2) Vt(3); Wt(1) Wt(2) Wt(3)];
Ruvw_r = [Ur(1) Ur(2) Ur(3); Vr(1) Vr(2) Vr(3); Wr(1) Wr(2) Wr(3)];

Cuvw_t = Ruvw_t*C_t*Ruvw_t';
Cuvw_r = Ruvw_r*C_r*Ruvw_r';

dr_tca_uvw = Ruvw_t*State_r(1:3)' - Ruvw_t*State_t(1:3)'; % The X matrx
dv_tca_uvw = Ruvw_t*State_r(4:6)' - Ruvw_t*State_t(4:6)';

dr_uvw = dr_tca_uvw + dv_tca_uvw; %*dt;

dr_tca_xyz = State_r(1:3) - State_t(1:3);

Cuvw = C_t + C_r;

Chat = Cuvw(1:3,1:3); %Replace with Rabs

mu = dr_uvw([1 3])';
sigma = sqrt([Chat(1,1) Chat(3,3)]);
x1 = linspace(mu(1)-10,mu(1)+10,100);
x2 = linspace(mu(2)-10,mu(2)+10,100);
[X1,X2] = meshgrid(x1',x2');
X = [X1(:) X2(:)];
pdf = mvnpdf(X,mu,sigma);
Z = reshape(pdf,100,100);

% Distance between ISS and Debris
Distance = sqrt((State_r(1) - State_t(1))^2 + (State_r(2) - State_t(2))^2 + (State_r(3) - State_t(3))^2);


range = [dr_uvw(1)-10:0.5:dr_uvw(1)+10];

delta_col_prob = [];
delta_debris_tca = [];
necessary_movement = [];
for i = 1:length(range)

    grid = griddata(X1,X2,Z,range(i),dr_uvw(3));
    delta_col_prob = [delta_col_prob; grid];

    if delta_col_prob <1e-6

    ISS_uvw = Ruvw_t*dr_tca_xyz';
    Distance_tca = sqrt((range(i) - ISS_uvw(1))^2 + (dr_tca_uvw(2) - ISS_uvw(2))^2 + (dr_tca_uvw(3) - ISS_uvw(3))^2);
    Distance_to_ISS = sqrt((range(i) - ISS_uvw(1))^2 + (dr_uvw(2) - ISS_uvw(2))^2 + (dr_uvw(3) - ISS_uvw(3))^2);
    delta_debris_tca = [delta_debris_tca; grid Distance_tca Distance_to_ISS];

        if delta_debris_tca(2) < 4.2
            necessary_movement = [necessary_movement; grid Distance_tca Distance_to_ISS];
        end

    end

end

% figure;
% caxis;
% surf(X1, X2, Z); 
% colorbar
% xlabel('U');
% ylabel('W');
% 
% collision = max(pdf);
% hold on
% grid on
% plot3(dr_tca_uvw(1),dr_tca_uvw(3),collision,'.r','MarkerSize',5);

%%
%Probability of collision

Rt = 1;
Rr = 1;

Rc = Rt +Rr;

%B-plane

[X_B Y_B] = Bplane(dr_tca_uvw, dv_tca_uvw);

Rxbyb = [ X_B(1) X_B(2) X_B(3); Y_B(1) Y_B(2) Y_B(3) ];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Chat should be in xyz not uvw

C_B = Rxbyb*Chat*Rxbyb';


%%

% dr_tca_uvw(1) is the relative position, col_radius is the range in which
% relative position is changed to calaculate where the accepted probability
% will be within limits

col_radius = [-100:0.01:+100];

col_probability = [];
results = [];
for i = 1:length(col_radius)

    a = col_radius(i) - 0.5*Rc;
    b = col_radius(i) + 0.5*Rc;

    Pc = (1/sqrt(2*pi))*(1.25331*erf((0.707107*b)/sqrt(C_B(1,1))) - 1.25331*erf((0.707107*a)/sqrt(C_B(1,1))));
    
    Distance_tca2 = sqrt((col_radius(i) - ISS_uvw(1))^2 + (dr_uvw(2) - ISS_uvw(2))^2 + (dr_uvw(3) - ISS_uvw(3))^2);
      
    col_probability = [col_probability; Pc col_radius(i) Distance_tca2];
    
        if (col_probability(i,2)) <= dr_uvw(1)
            true_Pc = Pc;
        end
    
            if Pc < 1e-6 
                results = [results; Pc col_radius(i) Distance_tca2];
            end  
    
end
    
desired_Pc = [max(results(:,1))];

%%
answers = [];
for j = 1:length(results)
    
    if results(j,1) == desired_Pc
        answers = [answers; results(j,1) results(j,2) results(j,3)];
    end
    
end

output = array2table(answers,'VariableNames',{'Probability of Collision','Relative Distance (km)','New Radial Position'});

% figure;
% plot(col_probability(:,2), col_probability(:,1));
