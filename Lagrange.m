clear all
close all

%% DEMO OF SOM WORKING
%% ACTUAL RESPONSE FUNCTION (USUALLY NOT KNOWN TO US, JUST FOR DEMO)
% [X1, X2] = meshgrid(linspace(-1, 1, 25), linspace(-1, 1, 25));
[X1, X2] = meshgrid(-5:0.1:5, -5:0.1:5);

g_x = -6 + (X1.^2 + X2.^2);                                             % Constraint function 1                                                           % Constraint function 2
f_x = X1.^2 + X2.^2 - 3.*X1.*X2;  


%% DATA GENERATION/UPLOAD DATA
x1 = reshape(X1, [], 1);
x2 = reshape(X2, [], 1);
f = reshape(f_x, [], 1);
g = reshape(g_x, [], 1);

data  = [x1,x2,f,g];
data1 = [x1,x2,f]; 
data2 = [x1,x2,g];



%% SOM PART START FROM HERE
sData_F = som_data_struct(data,'comp_names',{'$x_1$','$x_2$','$f$','$g$'});
sData_F = som_normalize(sData_F,'range');

sData1 = som_data_struct(data1,'comp_names',{'$x_1$','$x_2$','$f$'});    
sData1 = som_normalize(sData1,'range');

sData2 = som_data_struct(data2,'comp_names',{'$x_1$','$x_2$','$g$'}); 
sData2 = som_normalize(sData2,'range');

%% Initialization
[sMap_F]= som_lininit(sData_F,'lattice','hexa','msize',[30,30]);
[sMap]= modifiedsom_lininit(sData1,'lattice','hexa','msize',[30,30]);
% sMap.codebook(:,6) = sMap.codebook(:,6)*0; % optional, it does not effect the results
[sMap1]= sMap;[sMap2]= sMap;
%% Training
[sMap_F,sTrainF] = som_batchtrain(sMap_F,sData_F,'sample_order','ordered','trainlen',100,'rad_init',1.25, 'rad_fin', 0.5);
[sMap1,sTrain1] = modifiedsom_batchtrain(sMap1,sData1,'sample_order','ordered','radius_ini', 1.0, 'radius_fin', 0.75,'trainlen',100);
[sMap2,sTrain2] = modifiedsom_batchtrain(sMap2,sData2,'sample_order','ordered','radius_ini', 1.0, 'radius_fin', 0.75,'trainlen',100);

%% Denormalize the data
sMap_F = som_denormalize(sMap_F,sData_F); 
sData_F = som_denormalize(sData_F,'remove');
sMap1 = som_denormalize(sMap1,sData1);    
sData1=som_denormalize(sData1,'remove');
sMap2 = som_denormalize(sMap2,sData2);    
sData2=som_denormalize(sData2,'remove');

%% Re-arranging the data
sMap_umatrix = sMap_F;
sMap_umatrix.codebook(:,1:3) = sMap1.codebook(:,1:3);
sMap_umatrix.codebook(:,4) = sMap2.codebook(:,3);

%% Plotting the original data and SOM trained data
figure(1) 
som_show(sMap_umatrix,'comp','all','bar','horiz');

%% BMU for infeasible region
map_s = [30,30];
h_fes1 = zeros(map_s(1)*map_s(2),1); 


a = 0; b = 0; c = 0;
h_fes1(find(sMap_umatrix.codebook(:,4)>a))=1;

constraints = {'x1', 'x2', 'f', 'g'};
sliders = [0,0,0,1];
%% We will look into this part later
figure(2); hold on;
som_show_slider_final(sMap_umatrix, constraints, 2, sliders, [], [], [], 'comp', 'all','bar','horiz');
% som_show_add('hit',h_fes1,'Markersize',1,'MarkerColor','none','EdgeColor','r','Subplot',1:4);
% som_show_add('hit',h_fes2,'Markersize',1,'MarkerColor','none','EdgeColor','m','Subplot',[1,2,3,5]);
% som_show_add('hit',h_fes3,'Markersize',1,'MarkerColor','none','EdgeColor','k','Subplot',[1,2,3,6]);


