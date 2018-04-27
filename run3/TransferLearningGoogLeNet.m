%% please note
%This program need MATLAB 2017b, early versions of MATLAB may run into
%certain errors due to the change of MATLAB libraries
%This program relay on Neural Network Toolbox and GoogLeNet Network support package  
%This transfer learning may take up to 15 mins,depending on your GPU
%%
function net=TransferLearningGoogLeNet()
%loading paramters
lrate=20;
miniBatchSize = 10;
%loading training set
data_path = '../training/';
images = imageDatastore(data_path,...
    'IncludeSubfolders',true,'FileExtensions','.jpg','LabelSource','foldernames')   
images.ReadFcn = @(filename)readAndPreprocessImageForGoogle(filename); %redefine read function to process images while read

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
options = trainingOptions('sgdm',...
    'MiniBatchSize',miniBatchSize,... %set mini batch size
    'MaxEpochs',3,...      %set maxium epochs 
    'InitialLearnRate',1e-4,... %set slower learning rate to old layers
    'VerboseFrequency',1);% frequce of validation,stop if it is zero
%% Train the network using the training data.

net = trainNetwork(images,lgraph,options);
%% save new networks

save GoogLeNetNew net
end

