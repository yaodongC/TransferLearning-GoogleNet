% 设置 ImageDatastore 的读函数  
%imds.ReadFcn = @(filename)readAndPreprocessImage(filename);  
  
%%  
    function Iout = readAndPreprocessImageForGoogle(filename)  
                  
        I = imread(filename);  
          
        % 对灰度图像，将图像重复 3 次以形成 RGB 图像   
        if ismatrix(I)  
            I = cat(3,I,I,I);  
        end  
           
        Iout = imresize(I, [224 224]);    
          
        % 注意：此处在Resize时没有保留图像的宽高比   
        % 这是因为在 Caltech101 数据集中，目标都是在图像的中心且占据其大部分  
        % 其他数据集则需要考虑宽高比  
    end  