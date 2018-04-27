%% Comments
%This program need MATLAB 2017b, early versions of MATLAB may run into
%certain errors due to the change of MATLAB libraries
%This program relay on VLFeat library in vlfeat folder and natsortfiles() function based on natsorfiles.m
%This program may take up to 105 secs,depending on your CPU
%% Begins
clear all
%count elapsed time
tic
%setup VLFeat toolbox
run('../vlfeat/toolbox/vl_setup');
%Global variables
patch_size = 4; %set 4x4 pixels for each patch
patch_num = 8;%set 8x8 patches for each picture
K = 500; % value of K-means clustering
%% Read training and testing folder
%store training folder's labels and file path
%store testing folder's file path only
Trset = imageDatastore('../training','IncludeSubfolders',true,...
'FileExtensions','.jpg','LabelSource','foldernames') ;
Tsset = imageDatastore('../testing','IncludeSubfolders',true,'FileExtensions','.jpg') ;
%% Read testing file names
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
%% Use create_vocab() function 
%to catch Dense features and return the centers of K-clustering 
%See create_vocab code for details
Cent = create_vocab(Trainfiles,K,patch_size,patch_num);
%% Use create_histogram() function
%Compute distance of each feature to all centers and generate the histograms
%See details in create_histogram code
Hist_tr = create_histogram(Trainfiles,Cent,patch_size,patch_num);
Hist_ts = create_histogram(Testfiles,Cent,patch_size,patch_num);
%% Use SVM one-vs-all classifier function fitcecoc() to predict testing images' labels
 classifer = fitcecoc(Hist_tr,trLabel);    
 [pre,score] = predict(classifer,Hist_ts);    
%% Process of store predictions in a txt file.
[row col] = size(im_name);
fid = fopen('Run2.txt','w');%open or create a txt file and wipe all data
for i = 1: row
    fprintf(fid,'%s\t',char(im_name(i))); %write the image name
	fprintf(fid,'%s\r\n',pre(i)); %write the predicted label
end
fclose(fid); %close the file
toc