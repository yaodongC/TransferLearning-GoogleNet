% ���� ImageDatastore �Ķ�����  
%imds.ReadFcn = @(filename)readAndPreprocessImage(filename);  
  
%%  
    function Iout = readAndPreprocessImageForGoogle(filename)  
                  
        I = imread(filename);  
          
        % �ԻҶ�ͼ�񣬽�ͼ���ظ� 3 �����γ� RGB ͼ��   
        if ismatrix(I)  
            I = cat(3,I,I,I);  
        end  
           
        Iout = imresize(I, [224 224]);    
          
        % ע�⣺�˴���Resizeʱû�б���ͼ��Ŀ�߱�   
        % ������Ϊ�� Caltech101 ���ݼ��У�Ŀ�궼����ͼ���������ռ����󲿷�  
        % �������ݼ�����Ҫ���ǿ�߱�  
    end  