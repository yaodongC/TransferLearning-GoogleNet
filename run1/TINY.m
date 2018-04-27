%% Comments
%This program need MATLAB 2017b, early versions of MATLAB may run into certain errors due to new functions are used
%This program relay on natsortfiles() function based on natsorfiles.m
%This program may take up to 15 secs,depending on your CPU
%% begins
clear all;
%count elapsed time
tic
%Global variables
K = 15; %KNN value, find the nearest K points to classify the data
tiny_size = 16; %set the tiny image size
%% read training and testing folder
%store training folder's labels and file path
%store testing folder's file path only
data_path = '../training/';
Trset = imageDatastore(data_path,...
    'IncludeSubfolders',true,'FileExtensions','.jpg','LabelSource','foldernames')   
Tsset = imageDatastore('../testing','IncludeSubfolders',true,'FileExtensions','.jpg') ;
%% read testing file names
file_path =  '../testing/';
img_path_list = dir(strcat(file_path,'*.jpg'));
name = {img_path_list.name}';
%read all file pathes and labels
Trainfiles = Trset.Files;
trLabel = Trset.Labels;
%% Use natsortfiles() function
%Matlab reads files in the order of ASCII codes. natsortfiles() is a function download 
%from MathWorks, which can sort the files in natural-order
%Since the testing files will be stored as 0,1,10,100..., this function is
%used to sort its file names and corresponding images in natural-order
Testfiles = natsortfiles(Tsset.Files);
im_name = natsortfiles(name);
%% Use tinyimages() function
%See function code tinyimages which changes images to tiny image vectors
trData = tinyimages(Trainfiles,tiny_size);
tsData = tinyimages(Testfiles,tiny_size);
%% Use KNN classifier function in Matlab to predict the testing images' labels
Factor = ClassificationKNN.fit(trData, trLabel, 'NumNeighbors', K);
[predict_label] = predict(Factor, tsData);
%% Process of store predictions in a txt file.
[row col] = size(im_name);
fid = fopen('Run1.txt','w');%open or create a txt file and wipe all data
for i = 1: row
    fprintf(fid,'%s\t',char(im_name(i))); %write the image name
	fprintf(fid,'%s\r\n',predict_label(i)); %write the predicted label
end
fclose(fid); %close the file
toc