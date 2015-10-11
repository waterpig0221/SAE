function [ optRate, optThreshold, allResult ] = findOpt(nn, upThreshold, lowerThreshlod , inc)
%Find optimal mask threshlod
%nn 是已經訓練完的參數
%upThreshold 是搜尋上限
%lowerThreshold 是搜尋下限
%inc 是遞增量

% run test
load TestDataName.mat
threshold = lowerThreshlod:inc:upThreshold;
optRate = 0;
optThreshold = 0;
allResult = zeros(size(threshold,2),2);
for i=1:size(threshold,2)
    threshold(i)
    sum = 0;
    for j=1:size(xName,1)
        j;
        str = strcat(xDir,xName{j});
        str2 = strcat(yDir,yName{j});
        im = imread(str);
        im2 = imread(str2);
        correct = iris_mask_test(nn,im,im2, 16,threshold(i));
        sum = sum + correct;
    end
    avg = sum/size(xName,1);
    allResult(i,1) = threshold(i);
    allResult(i,2) = avg;
    if avg > optRate
        optThreshold = threshold(i);
        optRate = avg;
    end
end
end

