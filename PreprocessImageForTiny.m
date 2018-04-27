%% process image for classifier
function im_vector = PreprocessImageForTiny(image,imsize)
    im_vector = zeros(imsize*imsize); %new vector
    img = im2double(image); %convert to double
    tiny_img = imresize(img, [imsize imsize]); % resize image
    im_vector = reshape(tiny_img,1,imsize*imsize); %normalize image
    im_vector = im_vector - mean(im_vector);
    im_vector = im_vector./norm(im_vector);
end
