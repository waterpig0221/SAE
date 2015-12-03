function [ imOut ] = patchMergePos(patches,output_layer_number,Pos)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

len = sqrt(output_layer_number);
patchCount = 1;
imOut = zeros(30,180);
for i=1:(30-len+1)
    for j=1:(180-len+1)
        imOut(i:i+len-1,j:j+len-1) = imOut(i:i+len-1,j:j+len-1) + reshape(patches(:,patchCount),len,len);
        patchCount = patchCount + 1;
    end
end

end