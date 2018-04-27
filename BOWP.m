function label=BOWP(Center,Classf,image)
patch_size = 4; %set 4x4 pixels for each patch
patch_num = 8;%set 8x8 patches for each picture
K = 500; % value of K-means clustering
Testfiles=image;%reading pathfile
PreBag = fullfile('models', 'BOW.mat');  
load(PreBag);
PreCet = fullfile('models', 'Center.mat');  
load(PreCet);
%Cent = Center;% reading center
%classifer = Class;%reading classifier    
%% Use create_histogram() function
%Compute distance of each feature to all centers and generate the histograms
%See details in create_histogram code
[rowC,colC] = size(Cent);
hist = zeros(1,rowC); %initialise the histograms matrix
    img =  im2double(Testfiles); %read the corresponding image
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
                distance(num,ii) = norm(patch_Data(num,:)-Cent(ii,:));
            end
            [mind,posd] = min(distance(num,:)); %find the position of the minimum distance
            hist(1,posd) = hist(1,posd)+ 1; %the corresponding position of histogram plus 1 
        end
    end
%% Use SVM one-vs-all classifier function fitcecoc() to predict testing images' labels
 [pre,score] = predict(classifer,hist) 
 label = string(pre)
end