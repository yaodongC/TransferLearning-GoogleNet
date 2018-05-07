%% main file for run 3
%% 
%This program need MATLAB 2017b, early versions of MATLAB may run into
%certain errors due to the change of MATLAB libraries
%This program relay on Neural Network Toolbox and support packages  
%This transfer learning process may take up to 10 mins,depending on your
%GPU and chosen parameters
%% This requires test data with labels.
path = fullfile('G:','ComputerVisionCoursework3');
path2 = fullfile('G:','ComputerVisionCoursework3','testing');
data_path = '../training/';
%% if you want test model recover sentence below
%images = imageDatastore(data_path,...
 %   'IncludeSubfolders',true,'FileExtensions','.jpg','LabelSource','foldernames')   
%% fine-tune GoogLeNet (may take up to 10 mins)
 flag1=exist('GoogLeNetNew.mat')
if flag1==2
   load('GoogLeNetNew.mat');
   tranNet2 = net;
  % FilePrediction;
   %if no memory
   %CreateTxtLowMemory;
   %% if you want test model recover sentence below
   %accuracy1=TestModel(tranNet2,path2) 
else
   tranNet1 = TransferLearningGoogLeNet
end  
% produce .txt file
FilePrediction
%% fine-tune AlexNet (may take up to 5 mins)
 flag1=exist('AlexNetNew.mat')
if flag1==2
   load('AlexNetNew.mat');
   tranNet2 = netTransfer;
   %% if you want test model recover sentence below
   accuracy2=TestModel(tranNet2,path) 
else
   tranNet2 = TransferLearningAlexNet
end  
%%