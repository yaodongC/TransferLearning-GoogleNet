%% Comments
%This program need MATLAB 2017b, early versions of MATLAB may run into certain errors due to new functions are used
%This program relay on natsortfiles() function based on natsorfiles.m
%This program may take up to 15 mins,depending on your CPU
%% if not working due to lack of memory try CreateTxtLowMemory.m
%% begins
%function FilePrediction(network)
%% read testing file names
PreNet = fullfile('../models', 'googLeNet003.mat');  %load pretrained CNN 
load(PreNet);
Tsset = imageDatastore('../testing','IncludeSubfolders',true,'FileExtensions','.jpg') ;%load test set
file_path =  '../testing/';%test file path
img_path_list = dir(strcat(file_path,'*.jpg'));
name = {img_path_list.name}';
Tsset.ReadFcn = @(filename)readAndPreprocessImageForGoogle(filename); %redefine read function to process images while read
%% Use natsortfiles() function
%Matlab reads files in the order of ASCII codes. natsortfiles() is a function download 
%from MathWorks, which can sort the files in natural-order
%Since the testing files will be stored as 0,1,10,100..., this function is
%used to sort its file names and corresponding images in natural-order
Testfiles = natsortfiles(Tsset.Files);
im_name = natsortfiles(name);
%% Use tinyimages() function
predict_label = classify(net,Tsset');
%% Process of store predictions in a txt file.
[row col] = size(im_name);
fid = fopen('Run3.txt','w');%open or create a txt file and wipe all data
for i = 1: row
    fprintf(fid,'%s\t',char(im_name(i))); %write the image name
	fprintf(fid,'%s\r\n',predict_label(i)); %write the predicted label
end
fclose(fid); %close the file
toc