clc
clear all
close all

%% DEMO OF SOM WORKING
%% ACTUAL RESPONSE FUNCTION (USUALLY NOT KNOWN TO US, JUST FOR DEMO)
% [X1, X2] = meshgrid(linspace(-1, 1, 25), linspace(-1, 1, 25));
[X1, X2, X3] = meshgrid(-5:0.5:5, -5:0.5:5, -5:0.5:5);

f_x = X1 .* X2 + X2 .* X3;
g_x1 = X1.^2 - X2.^2 + X3.^2;
g_x2 = X1.^2 + X2.^2 + X3.^2;


%% DATA GENERATION/UPLOAD DATA
x1 = reshape(X1, [], 1);
x2 = reshape(X2, [], 1);
x3 = reshape(X3, [], 1);
f = reshape(f_x, [], 1);
g1 = reshape(g_x1, [], 1);
g2 = reshape(g_x2, [], 1);

data  = [x1,x2,x3,f,g1,g2];
data1 = [x1,x2,x3,f]; 
data2 = [x1,x2,x3,g1];
data3 = [x1,x2,x3,g2];


%% SOM PART START FROM HERE
sData_F = som_data_struct(data,'comp_names',{'$x_1$','$x_2$','$x_3$','$f$','$g_1$','$g_2$'});
sData_F = som_normalize(sData_F,'range');

sData1 = som_data_struct(data1,'comp_names',{'$x_1$','$x_2$','$x_3$','$f$'});    
sData1 = som_normalize(sData1,'range');

sData2 = som_data_struct(data2,'comp_names',{'$x_1$','$x_2$','$x_3$','$g_1$'}); 
sData2 = som_normalize(sData2,'range');

sData3 = som_data_struct(data3,'comp_names',{'$x_1$','$x_2$','$x_3$','$g_2$'}); 
sData3 = som_normalize(sData3,'range');

%% Initialization
[sMap_F]= som_lininit(sData_F,'lattice','hexa','msize',[20,20]);
[sMap]= modifiedsom_lininit(sData1,'lattice','hexa','msize',[20,20]);
% sMap.codebook(:,6) = sMap.codebook(:,6)*0; % optional, it does not effect the results
[sMap1]= sMap;[sMap2]= sMap;[sMap3]= sMap;
%% Training
[sMap_F,sTrainF] = som_batchtrain(sMap_F,sData_F,'sample_order','ordered','trainlen',100,'rad_init',1.25, 'rad_fin', 0.5);
[sMap1,sTrain1] = modifiedsom_batchtrain(sMap1,sData1,'sample_order','ordered','radius_ini', 1.0, 'radius_fin', 0.75,'trainlen',100);
[sMap2,sTrain2] = modifiedsom_batchtrain(sMap2,sData2,'sample_order','ordered','radius_ini', 1.0, 'radius_fin', 0.75,'trainlen',100);
[sMap3,sTrain3] = modifiedsom_batchtrain(sMap3,sData3,'sample_order','ordered','radius_ini', 1.0, 'radius_fin', 0.75,'trainlen',100);

%% Denormalize the data
sMap_F = som_denormalize(sMap_F,sData_F); 
sData_F = som_denormalize(sData_F,'remove');
sMap1 = som_denormalize(sMap1,sData1);    
sData1=som_denormalize(sData1,'remove');
sMap2 = som_denormalize(sMap2,sData2);    
sData2=som_denormalize(sData2,'remove');
sMap3 = som_denormalize(sMap3,sData3);    
sData3 = som_denormalize(sData3,'remove');

%% Re-arranging the data
sMap_umatrix = sMap_F;
sMap_umatrix.codebook(:,1:4) = sMap1.codebook(:,1:4);
sMap_umatrix.codebook(:,5) = sMap2.codebook(:,4);
sMap_umatrix.codebook(:,6) = sMap3.codebook(:,4);

%% Plotting the original data and SOM trained data
figure(1) 
som_show(sMap_umatrix,'comp','all','bar','horiz');

%% BMU for infeasible region
map_s = [20,20];
h_fes1 = zeros(map_s(1)*map_s(2),1); 
h_fes2 = zeros(map_s(1)*map_s(2),1);

a = 0; b = 0; c = 0;
h_fes1(find(sMap_umatrix.codebook(:,5)>a))=1;
h_fes2(find(sMap_umatrix.codebook(:,6)>b))=1;


constraints = {'x1', 'x2', 'x3', 'f', 'g1', 'g2'};
sliders = [0,0,0,0,1,1];
%% We will look into this part later
figure(2); hold on;
som_show_slider_final1(sMap_umatrix, constraints, 2, sliders, [], 'comp', 'all','bar','horiz');
% som_show_add('hit',h_fes1,'Markersize',1,'MarkerColor','none','EdgeColor','r','Subplot',1:4);
% som_show_add('hit',h_fes2,'Markersize',1,'MarkerColor','none','EdgeColor','m','Subplot',[1,2,3,5]);
% som_show_add('hit',h_fes3,'Markersize',1,'MarkerColor','none','EdgeColor','k','Subplot',[1,2,3,6]);


