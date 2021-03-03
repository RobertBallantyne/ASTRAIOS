%Probability3
clear;
clear all;
%%
%function [output, true_Pc] = CollisionProb(State_ISS, State_Deb)

statevectors.ISSmultiple = [597199    2983.67840401619    -4701.24139050245    3898.17301978456    6.43528268291700    0.685792968286327    -4.09463000674684;
597200    2990.11179168463    -4700.55261394271    3894.07591658998    6.43149129698622    0.691760005686113    -4.09957551404288;
597201    2996.54138388666    -4699.85787078698    3889.97387049188    6.42769175104856    0.697726159131963    -4.10451581271907;
597202    3002.96717246470    -4699.15716192301    3885.86688670201    6.42388404994447    0.703691421050263    -4.10945089651288;
597203    3009.38914926600    -4698.45048824611    3881.75497043839    6.42006819852472    0.709655783868566    -4.11438075916841;
597204    3015.80730614269    -4697.73785065917    3877.63812692528    6.41624420165044    0.715619240015594    -4.11930539443642;
597205    3022.22163495173    -4697.01925007265    3873.51636139318    6.41241206419307    0.721581781921252    -4.12422479607435;
597206    3028.63212755499    -4696.29468740457    3869.38967907885    6.40857179103438    0.727543402016637    -4.12913895784631;
597207    3035.03877581920    -4695.56416358053    3865.25808522527    6.40472338706646    0.733504092734046    -4.13404787352307;
597208    3041.44157161601    -4694.82767953369    3861.12158508164    6.40086685719170    0.739463846506987    -4.13895153688213;
597209    3047.84050682197    -4694.08523620477    3856.98018390338    6.39700220632280    0.745422655770188    -4.14384994170764;
597210    3054.23557331854    -4693.33683454208    3852.83388695215    6.39312943938276    0.751380512959607    -4.14874308179050;
597211    3060.62676299211    -4692.58247550147    3848.68269949577    6.38924856130487    0.757337410512442    -4.15363095092829];

statevectors.Debrismultiple = [597199    3075.31078740379    -4704.62869023747    3871.81803244435    -3.31639858290447    2.96920838329008   6.21784984831296;
597200    3071.99246167847    -4701.65653326075    3878.03345384841    -3.32025217712109    2.97510495368448    6.21299165575455;
597201    3068.67028442828    -4698.67848156023    3884.24401314997    -3.32410163175417    2.98099782953162    6.20812564434417;
597202    3065.34425979525    -4695.69453883418    3890.44970253320    -3.32794694190905    2.98688700337040    6.20325182011190;
597203    3062.01439192629    -4692.70470878835    3896.65051418828    -3.33178810269620    2.99277246774426    6.19837018909786;
597204    3058.68068497322    -4689.70899513592    3902.84644031146    -3.33562510923125    2.99865421520114    6.19348075735223;
597205    3055.34314309273    -4686.70740159754    3909.03747310503    -3.33945795663498    3.00453223829354    6.18858353093521;
597206    3052.00177044638    -4683.69993190128    3915.22360477737    -3.34328664003333    3.01040652957848    6.18367851591705;
597207    3048.65657120063    -4680.68658978268    3921.40482754291    -3.34711115455740    3.01627708161756    6.17876571837800;
597208    3045.30754952676    -4677.66737898469    3927.58113362217    -3.35093149534345    3.02214388697693    6.17384514440836;
597209    3041.95470960095    -4674.64230325771    3933.75251524177    -3.35474765753295    3.02800693822731    6.16891680010842;
597210    3038.59805560423    -4671.61136635957    3939.91896463443    -3.35855963627252    3.03386622794402    6.16398069158848;
597211    3035.23759172246    -4668.57457205550    3946.08047403900    -3.36236742671399    3.03972174870696    6.15903682496881];
 %%
statevectors.multipleDistISStoDebris = [];
for i = 1:length(statevectors.ISSmultiple)
    
    statevectors.DistISStoDebris = [sqrt((statevectors.ISSmultiple(i,2)-statevectors.Debrismultiple(i,2))^2+(statevectors.ISSmultiple(i,3)-statevectors.Debrismultiple(i,3))^2+(statevectors.ISSmultiple(i,4)-statevectors.Debrismultiple(i,4))^2)];
         statevectors.multipleDistISStoDebris = [ statevectors.multipleDistISStoDebris; statevectors.DistISStoDebris];
         
         
end
[statevectors.closestDist,statevectors.idx] = min(statevectors.multipleDistISStoDebris(:));
[statevectors.row] = ind2sub(size(statevectors.multipleDistISStoDebris),statevectors.idx);
statevectors.time_in_days = statevectors.ISSmultiple(statevectors.row,1)/(3600*24);

%%
%used statevectors and covariance matrix

%ISS state vector
statevectors.State_ISS = [ statevectors.ISSmultiple(statevectors.row,2)	statevectors.ISSmultiple(statevectors.row,3)	statevectors.ISSmultiple(statevectors.row,4)	statevectors.ISSmultiple(statevectors.row,5)	statevectors.ISSmultiple(statevectors.row,6) statevectors.ISSmultiple(statevectors.row,7)];

%Debris state vector
statevectors.State_Deb = [ statevectors.Debrismultiple(statevectors.row,2)  statevectors.Debrismultiple(statevectors.row,3)	statevectors.Debrismultiple(statevectors.row,4)	 statevectors.Debrismultiple(statevectors.row,5)	statevectors.Debrismultiple(statevectors.row,6)  statevectors.Debrismultiple(statevectors.row,7)];

%Covariance alreday in uvw 0.0235090175307170
covariance.C_t = [0.0235090175307170    -0.871643441792003    0.0658570137101566;
-0.871643441792003    658.828036964560    3.86478187802098;
0.0658570137101566    3.86478187802098    0.590507632399229];

covariance.C_r = [0.0231258101720259    -0.254362907373553    -0.000464919603287759;
-0.254362907373553    129.088186616960    -0.290686921794232;
-0.000464919603287759    -0.290686921794232    0.00302940493319282];

covariance.Cuvw = covariance.C_t + covariance.C_r;

covariance.Chat = covariance.Cuvw(1:3,1:3);

%%
%Collision cross-section

col_crosssection.R_ISS = 0.06; %0.05545; %ISS radius of sphere of influence
col_crosssection.R_Deb = 0.05; %Debris radius of sphere of influence

col_crosssection.R_col = col_crosssection.R_ISS + col_crosssection.R_Deb; %Radius of collision cross-section

V_col = (4/3)*pi*col_crosssection.R_col^3;
%%
[Ut Vt Wt] = orc(statevectors.State_ISS);

Ruvw_t = [Ut(1) Ut(2) Ut(3); Vt(1) Vt(2) Vt(3); Wt(1) Wt(2) Wt(3)];

dr_tca_uvw = Ruvw_t*statevectors.State_Deb(1:3)' - Ruvw_t*statevectors.State_ISS(1:3)';
dv_tca_uvw = Ruvw_t*statevectors.State_Deb(4:6)' - Ruvw_t*statevectors.State_ISS(4:6)';
%Pc_3D = (1/sqrt(((2*pi)^3)*det(covariance.Chat)))*V_col*exp((-0.5)*dr_tca_uvw'*inv(covariance.Chat)*dr_tca_uvw)
%%
%Probability calculation
[X_B Y_B] = Bplane(dr_tca_uvw, dv_tca_uvw);

Rxbyb = [ X_B(1) X_B(2) X_B(3); Y_B(1) Y_B(2) Y_B(3) ];

C_B = Rxbyb*covariance.Chat*Rxbyb';

dr_tca_B = Rxbyb*statevectors.State_Deb(1:3)' - Rxbyb*statevectors.State_ISS(1:3)';
dv_tca_B = Rxbyb*statevectors.State_Deb(4:6)' - Rxbyb*statevectors.State_ISS(4:6)';

[vec,val] = eig(C_B);

col1 = max(val(:,1));
col2 = max(val(:,2));

a =sqrt(max(col1,col2));
ea = vec(:,1)*a;

b =sqrt(min(col1,col2));
eb = vec(:,2)*b;
xb = ea/norm(ea);
yb = eb/norm(eb);

x = a%xb(1); 
y = b%yb(1);

dist = sqrt(dr_tca_B(1)^2+dr_tca_B(2)^2);
%fun = @(x,y) exp(-0.5.*([x y]'.*inv(C_B).*[x y]));
fun = @(x,y) exp(-0.5*(((x-dr_tca_B(1))/sqrt(C_B(1,1))).^2 + ((y-dr_tca_B(2))/sqrt(C_B(2,2))).^2));
% fun = @(x,y) exp(-0.5*(((x-dr_tca_uvw(1))/sqrt(covariance.Chat(1,1))).^2 + ((y-dr_tca_uvw(3))/sqrt(covariance.Chat(3,3))).^2));

xmin = dist-col_crosssection.R_col;
xmax = dist+col_crosssection.R_col;
ymin = -sqrt((dist-col_crosssection.R_col^2) - x^2);
ymax = sqrt((dist+col_crosssection.R_col^2) - x^2);
% ymin = -sqrt((dr_tca_B+col_crosssection.R_col^2) - xb.^2)
% ymax = sqrt((dr_tca_B+col_crosssection.R_col^2) - xb.^2);
q = integral2(fun,xmin,xmax,ymin,ymax);
PcB = (1/((2*pi)*sqrt(det(C_B))))*q

Pcmax = (dist+col_crosssection.R_col^2)/(exp(1)*sqrt(det(C_B))*dr_tca_B'*inv(C_B)*dr_tca_B)
[Probcol Pcx Pcy Pcz] = colProb(covariance.Chat,dr_tca_uvw,col_crosssection.R_col);
%%
%AR = sqrt(covariance.Chat(1,1))/sqrt(covariance.Chat(3,3))
ARB = sqrt(C_B(1,1))/sqrt(C_B(2,2))
Bminx0 = dist/(sqrt(2)*ARB);
Bminx1 = sqrt(((ARB^2 + 1)*col_crosssection.R_col^2 + 2*dist^2 + sqrt(((ARB^2 + 1)*col_crosssection.R_col^2)^2 + 4*dist^4))/(8*ARB^2));

PB0 = ((col_crosssection.R_col^2)/(2*(ARB*(Bminx0)^2)))*exp((-0.5)*((dist/(ARB*(Bminx0)))^2))
PB1 = ((col_crosssection.R_col^2)/(16*(ARB^3*(Bminx1)^4)))*exp((-0.5)*((dist/(ARB*(Bminx1)))^2))*((-ARB^2 -1)*col_crosssection.R_col^2 + 8*(ARB^2)*(Bminx1^2))

distC = sqrt(dr_tca_uvw(1)^2+dr_tca_uvw(2)^2);
ARC = sqrt(covariance.Chat(1,1))/sqrt(covariance.Chat(3,3))
Cminx0 = dist/(sqrt(2)*ARC);
Cminx1 = sqrt(((ARC^2 + 1)*col_crosssection.R_col^2 + 2*dist^2 + sqrt(((ARC^2 + 1)*col_crosssection.R_col^2)^2 + 4*dist^4))/(8*ARC^2));

PC0 = ((col_crosssection.R_col^2)/(2*(ARC*(Cminx0)^2)))*exp((-0.5)*((dist/(ARC*(Cminx0)))^2))
PC1 = ((col_crosssection.R_col^2)/(16*(ARC^3*(Cminx1)^4)))*exp((-0.5)*((dist/(ARC*(Cminx1)))^2))*((-ARC^2 -1)*col_crosssection.R_col^2 + 8*(ARC^2)*(Cminx1^2))


%%
save =[];
probcalc.drtca_range = [-10:0.01:10];
% for i=1:length(probcalc.drtca_range)
%     rangeall = [probcalc.drtca_range(i); dr_tca_uvw(2); dr_tca_uvw(3)];
%      Pc_3D = (1/sqrt(((2*pi)^3)*det(covariance.Chat)))*V_col*exp((-0.5)*rangeall'*inv(covariance.Chat)*rangeall);
%     save = [save; Pc_3D];
% end

distance =[];
probcalc.col_probability = [];
probcalc.results = [];
val =[];
for j = 1:length(probcalc.drtca_range)
    
    rangeall = [probcalc.drtca_range(j); dr_tca_uvw(2); dr_tca_uvw(3)];
    probcalc.lowlim = rangeall-col_crosssection.R_col;
    probcalc.uplim = rangeall+col_crosssection.R_col;
    
    rangeall = probcalc.drtca_range(j);
    probcalc.lowlim = rangeall-col_crosssection.R_col;
    probcalc.uplim = rangeall+col_crosssection.R_col;
    
    probcalc.Pc = (1/(2*pi*sqrt(det(covariance.Chat(1,1)))))*(sqrt(det(covariance.Chat(1,1))))*(1.25331*erf((0.707107*probcalc.uplim)/sqrt(det(covariance.Chat(1,1)))) - 1.25331*erf((0.707107*probcalc.lowlim)/sqrt(det(covariance.Chat(1,1)))));
    
  probcalc.col_probability = [probcalc.col_probability; probcalc.Pc  probcalc.drtca_range(j) ];
         
%     rangeall = [probcalc.drtca_range(j); dr_tca_uvw(2); dr_tca_uvw(3)]';
%     lowlim = rangeall-col_crosssection.R_col;
%     uplim = rangeall+col_crosssection.R_col;
%     
%         probcalc.Pc = (1/(2*pi*sqrt(det(covariance.Chat))))*(sqrt(det((covariance.Chat))))*(1.25331*erf((0.707107*uplim)/sqrt(det(covariance.Chat))) - 1.25331*erf((0.707107*lowlim)/sqrt(det(covariance.Chat))));
%   
%     probcalc.col_probability = [probcalc.col_probability; probcalc.Pc  rangeall];
    
      
       if probcalc.Pc < 1e-5 
                probcalc.results = [probcalc.results; probcalc.Pc probcalc.drtca_range(j)];   
       end  
         
    if probcalc.col_probability(j,2) < (dr_tca_uvw(1)+col_crosssection.R_col+0.01) && probcalc.col_probability(j,2) > (dr_tca_uvw(1)+col_crosssection.R_col)
       val =  j;
    end
     if probcalc.col_probability(j,2) < (dr_tca_uvw(1)+col_crosssection.R_col+0.01) && probcalc.col_probability(j,2) > (dr_tca_uvw(1)+col_crosssection.R_col)
       val2 =  j;
    end
    if probcalc.col_probability(j,2) > (dr_tca_uvw(1)-col_crosssection.R_col-0.01) && probcalc.col_probability(j,2) < (dr_tca_uvw(1)-col_crosssection.R_col)
       val3 =  j;
    end
end
 
probcalc.desired_Pc = [max(probcalc.results(:,1))];

%%
answers = [];
for k = 1:length(probcalc.results)
    
    if probcalc.results(k,1) == probcalc.desired_Pc
        newDist = probcalc.results(k,2);
        minDist = newDist - dr_tca_uvw(1);
        
        answers = [answers; probcalc.results(k,1) probcalc.results(k,2) minDist statevectors.time_in_days];
    end
    
end

output = array2table(answers,'VariableNames',{'Probability of Collision','Distance (km)','Relative Distance (km)','Time in Days'});

%%
figure;
hold on
plot(probcalc.col_probability(:,2), probcalc.col_probability(:,1));
plot(dr_tca_uvw(1),Probcol(1),'.r');
plot(dr_tca_uvw(1)+col_crosssection.R_col,probcalc.col_probability(val2,1),'.g');
plot(dr_tca_uvw(1)-col_crosssection.R_col,probcalc.col_probability(val3,1),'.g');
plot(newDist,probcalc.desired_Pc,'.c');
hold off

% mu = dr_tca_uvw';
% sigma = sqrt(Chat]);
% x1 = linspace(mu(1)-10,mu(1)+10,100);
% x2 = linspace(mu(2)-10,mu(2)+10,100);
% [X1,X2] = meshgrid(x1',x2');
% X = [X1(:) X2(:)];
% pdf = mvnpdf(X,mu,sigma);
% Z = reshape(pdf,100,100);
% Z = reshape(save,200,200)
% surf(probcalc.drtca_range, dr_tca_uvw(2), Z)









