%Compute distance of each feature to all centers and generate the histograms
function hist = create_histogram(imset,center,patch_size,patch_num)
[row,col] = size(imset); 
[rowC,colC] = size(center);
hist = zeros(row,rowC); %initialise the histograms matrix
for k = 1:row
    img =  im2double(imread(char(imset(k)))); %read the corresponding image
    %set the image into fixed size
    img = imresize(img,[patch_size*patch_num patch_size*patch_num]);
    num = 0;%counter of patches
    for i = 1:patch_num %  patches per row
        for j = 1:patch_num  % patches per column
            for jj = 1:patch_size% patch's size
            img_patch(jj,:) = img(jj+((i-1)*patch_size),patch_size*(j-1)+1:patch_size*j);% store each patch data row by row
            end
            num = num + 1; %The number of patches processing now
            patch_Data(num,:) = reshape(img_patch,1,patch_size*patch_size);%change patch to vector
            %normalise the patch vector
            patch_Data(num,:) = patch_Data(num,:) - mean(patch_Data(num,:));
            patch_Data(num,:) = patch_Data(num,:)./norm(patch_Data(num,:));
            %compute the distance to all K centers
            for ii = 1:rowC
                distance(num,ii) = norm(patch_Data(num,:)-center(ii,:));
            end
            [mind,posd] = min(distance(num,:)); %find the position of the minimum distance
            hist(k,posd) = hist(k,posd)+ 1; %the corresponding position of histogram plus 1 
        end
    end
end
end