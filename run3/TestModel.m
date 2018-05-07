%% This function will you¡¯re your fine-tuned models and calculate its accuracy. 
%% It requires test data with labels.
function accuracy=TestModel(network,filepath)
   net=network;
   FilePath=filepath;
   valImages = imageDatastore(FilePath,...
    'IncludeSubfolders',true,'FileExtensions','.jpg','LabelSource','foldernames')   
   valImages.ReadFcn =  @(filename)readAndPreprocessImageForGoogle(filename);
   predictedLabels = classify(net,valImages);
   accuracy = mean(predictedLabels == valImages.Labels)
end