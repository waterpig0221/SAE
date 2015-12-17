function [ imOut ] = patchMerge2(patches,row ,col, output_layer_number)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

len = sqrt(output_layer_number);
patchCount = 1;
imOut = zeros(row, col);
for i=1:(row-len+1)
    for j=1:(col-len+1)
        imOut(i:i+len-1,j:j+len-1) = imOut(i:i+len-1,j:j+len-1) + reshape(patches(:,patchCount),len,len);
        patchCount = patchCount + 1;
    end
end

end

