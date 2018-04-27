%% please note
%This program need MATLAB 2017b, early versions of MATLAB may run into
%certain errors due to the change of MATLAB libraries
%This program relay on Neural Network Toolbox and AlexNet Network support package  
%This transfer learning may take up to 15 mins,depending on your GPU
%% begins
function netTransfer=TransferLearningAlexNet()
%loading paramters
lrate=20;
miniBatchSize = 10;
%loading training set
data_path = '../training/';
images = imageDatastore(data_path,...
    'IncludeSubfolders',true,'FileExtensions','.jpg','LabelSource','foldernames')   
images.ReadFcn = @(filename)PreprocessImageForAlex(filename); %redefine read function to process images while read
% Divide the data into training and validation data sets. Use 70% for training and 30% for validation. 
[trainImages,valiImages] = splitEachLabel(images,0.7,'randomized');
%% load pretrained googLeNet
PreNet = fullfile( '../models/AlexNet002.mat');  
load(PreNet);
%% Transfer Layers to New Network
layersTransfer = net.Layers(1:end-3);
%% create new networks
numberOfClasses = numel(categories(trainImages.Labels))%Set the fully connected layer to the same size as the number of classes in the new data sat. 
layers = [
    layersTransfer
    fullyConnectedLayer(numberOfClasses,'WeightLearnRateFactor',lrate,'BiasLearnRateFactor',lrate)%set the learning rate of new layers
    softmaxLayer
    classificationLayer];

%% Train Network
IterationsPerEpoch = floor(numel(trainImages.Labels)/miniBatchSize);%frequency of test data validation
options = trainingOptions('sgdm',...
    'MiniBatchSize',miniBatchSize,...%set mini batch size
    'MaxEpochs',4,...%set maxium epochs 
    'InitialLearnRate',1e-4,...%set slower learning rate to old layers
    'Verbose',false,...% frequce of validation,stop if it is zero
    'Plots','training-progress',...% plot training process
    'ValidationData',valiImages,...% validation data
    'ValidationFrequency',IterationsPerEpoch);%frequency of test data validation

%%
% Train the network using the training data.
netTransfer = trainNetwork(trainImages,layers,options);
%%
%save new networks
save AlexNetNew netTransfer
end