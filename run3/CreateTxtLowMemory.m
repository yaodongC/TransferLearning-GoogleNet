%% This File can produce txt file contains prediction
%% initialize
file_path =  '../testing/';
img_path_list = dir(strcat(file_path,'*.jpg'));
img_num = length(img_path_list);  
imname = 0; 
PreNet = fullfile( '../models/googLeNet003.mat'); %load network
load(PreNet);
%read image name
%% write file
fid = fopen('NETWORK.txt','w');
for p = 1:img_num
    na = num2str(imname);
    image_name = [na '.jpg'];
%certain images are missing
    if (imname == 1314 || imname == 2938 || imname == 2962)
        imname = imname+1;
        na = num2str(imname);
        image_name = [na '.jpg'];
    end
%read image by image name
    I = imread(strcat(file_path,image_name));  % read file path
        if ismatrix(I)  
            I = cat(3,I,I,I);  
        end  
%resize image for network input
    Iout = imresize(I, [224 224]);    
    pre = classify(net,Iout); %classify image
    fprintf(fid,'%s\t',image_name);% write file
    fprintf(fid,'%s\r\n',pre);% write file
    imname = imname + 1;
end
fclose(fid);