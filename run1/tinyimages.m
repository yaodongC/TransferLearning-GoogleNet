% Function to change images into tiny image vectors
function im_vector = tinyimages(imset,imsize)
[row,col] = size(imset); %read the size of images
im_vector = zeros(row,imsize*imsize); %initialise the vector matrix
for k = 1:row
    img = im2double(imread(char(imset(k)))); %read the corresponding image
    tiny_img = imresize(img, [imsize imsize]); %change original image to a fixed size tiny image
    im_vector(k,:) = reshape(tiny_img, 1,imsize*imsize);%change image to a row vector
    %normalise the image vector
    im_vector(k,:) = im_vector(k,:) - mean(im_vector(k,:));
    im_vector(k,:) = im_vector(k,:)./norm(im_vector(k,:));
end
