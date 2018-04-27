%% Predict image with AlexNet
function label=AlexPredict(network,image)
   newImage = image;% load image
   img = PreprocessImageForAlex(newImage); % preprocess image to resize
   net=network;%load network
   pred = classify(net,img); %classify image
   label = string(pred) %translate to string form
end