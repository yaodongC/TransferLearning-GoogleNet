%% please note
%This program need MATLAB 2017b, early versions of MATLAB may run into
%certain errors due to the change of MATLAB libraries
%This program relay on Neural Network Toolbox and GoogLeNet Network support package  
%This transfer learning may take up to 15 mins,depending on your GPU
%%
%function net=TransferLearningGoogLeNetWithRotationAndReflection()
%loading paramters
lrate=20;
miniBatchSize = 10;
%loading training set
data_path = '../training/';
images = imageDatastore(data_path,...
    'IncludeSubfolders',true,'FileExtensions','.jpg','LabelSource','foldernames')   
images.ReadFcn = @(filename)readAndPreprocessImageForGoogle(filename); %redefine read function to process images while read

data_path = 'G:\testwithlabel';
images2 = imageDatastore(data_path,...
    'IncludeSubfolders',true,'FileExtensions','.jpg','LabelSource','foldernames')   
images2.ReadFcn = @(filename)readAndPreprocessImageForGoogle(filename); %redefine read function to process images while read
% Divide the data into training and validation data sets. Use 70% for training and 30% for validation. 
[trainImages,valiImages] = splitEachLabel(images2,0.9,'randomized');
%% create more image
augmenter = imageDataAugmenter( ...
    'RandXReflection',true)
imageSize = [224 224 3];
source = augmentedImageSource(imageSize,images,'DataAugmentation',augmenter)
augmenter2 = imageDataAugmenter('RandRotation',[-45 45],...
    'RandXReflection',true)
source2 = augmentedImageSource(imageSize,images,'DataAugmentation',augmenter2)
%%
%load pretrained googLeNet
PreNet = fullfile( 'googlenet.mat');  
load(PreNet);
%%
%read layers of the networks,and remove old output layers
lgraph = layerGraph(net);
lgraph = removeLayers(lgraph, {'loss3-classifier','prob','output'});%discard output layers
%%
%configure the new output layers

numClasses = numel(categories(images.Labels));%Set the fully connected layer to the same size as the number of classes in the new data sat. 
newLayers = [
    fullyConnectedLayer(numClasses,'Name','fc','WeightLearnRateFactor',lrate,'BiasLearnRateFactor', lrate)%set the learning rate of new layers
    softmaxLayer('Name','softmax')
    classificationLayer('Name','classoutput')];
%%
%connect new output layer
lgraph = addLayers(lgraph,newLayers);
lgraph = connectLayers(lgraph,'pool5-drop_7x7_s1','fc'); %add the new output layers to the pretrained CNN

%%
%training options
option = trainingOptions('sgdm',...
    'MiniBatchSize',miniBatchSize,... %set mini batch size
    'MaxEpochs',2,...      %set maxium epochs 
    'InitialLearnRate',1e-4,... %set slower learning rate to old layers
    'VerboseFrequency',1,...
    'ValidationData',valiImages,...% validation data
    'ValidationFrequency',100);%frequency of test data validation
% frequce of validation,stop if it is zero
options = trainingOptions('sgdm',...
    'MiniBatchSize',miniBatchSize,... %set mini batch size
    'MaxEpochs',2,...      %set maxium epochs 
    'InitialLearnRate',1e-4,... %set slower learning rate to old layers
    'VerboseFrequency',1,...
    'ValidationData',valiImages,...% validation data
    'ValidationFrequency',50);%frequency of test data validation
%% Train the network using the training data.
newnet = trainNetwork(source2,lgraph,option);
newlgraph = layerGraph(newnet);
net = trainNetwork(images,newlgraph,options);
%% save new networks

save GoogLeNetMoreNew net
%end