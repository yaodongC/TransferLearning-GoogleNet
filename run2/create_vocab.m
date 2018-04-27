
function vocab = create_vocab( imset,K,patch_size,patch_num )
[row,col] = size(imset); 
for k = 1:row
    img =  im2double(imread(char(imset(k)))); %read the corresponding image
    %set the image into fixed size
    img = imresize(img,[patch_size*patch_num patch_size*patch_num]);
    num = 0; % counter of patches
    for i = 1:patch_num % patches per row
        for j = 1:patch_num  % patches per column
            for jj = 1:patch_size % patch's size
            img_patch(jj,:) = img(jj+((i-1)*patch_size),patch_size*(j-1)+1:patch_size*j); % store each patch data row by row
            end
            num = num + 1; %The number of patches processing now
            patch_Data(num,:) = reshape(img_patch,1,patch_size*patch_size);%change patch to vector
            %normalise the patch vector
            patch_Data(num,:) = patch_Data(num,:) - mean(patch_Data(num,:));
            patch_Data(num,:) = patch_Data(num,:)./norm(patch_Data(num,:));
        end
    end
    trData((k-1)*num+1:k*num,:) = patch_Data; %store all patch vectors in a big matrix
end
%vl_kmeans is a kmeans function in VLFeat Toolbox, which is faster than the kmeans function in Matlab
%As for vl_kmeans(X,K), X is dxN matrix data where d is the dimensions of data
%N is the number of data, and K is the number of centers created for clustering
%Use L1 method of calculating distance and approximated nearest neighbours(ANN) algorithm
%Maximum number of sample-to-center comparisons when searching for the closest center.
[centers,a] = vl_kmeans(trData', K, 'distance', 'l1', 'algorithm','ann','MaxNumComparisons', ceil(K / 50));
vocab = centers';
end