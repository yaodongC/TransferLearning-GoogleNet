%% process image for network
function Iout = PreprocessImageForGoogle(image)                   
        I = image; % load image   
        if ismatrix(I)  % If gray scale, repeat 3 times to form RGB image  
            I = cat(3,I,I,I);  
        end            
        Iout = imresize(I, [224 224]); %resize image for network   
    end  