%% Predict image with GoogLeNet
function label=GoogLePredict(network,image)
   newImage = image;% load image
   img = PreprocessImageForGoogle(newImage); % preprocess image to resize
   net=network;%load network
   pred = classify(net,img); %classify image
   label = string(pred) %translate to string form
end