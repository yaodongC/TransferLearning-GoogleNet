%% KNN clasiifier
function label=TinyPredict(factors,image)
   newImage = image;
   K = 15; %KNN value, find the nearest K points to classify the data
   tiny_size = 16; %set the tiny image size
   img = PreprocessImageForTiny(newImage,tiny_size);  %process image for classifier
   factor=factors; % load factor
   pred = predict(factor,img); %make prediction
   label = string(pred) %translate to string
end