% run test
load TestDataName.mat
threshold = 0.032;

sum = 0;
for i=1:size(xName,1)
    i
    str = strcat(xDir,xName{i});
    str2 = strcat(yDir,yName{i});
    im = imread(str);
    im2 = imread(str2);
    correct = iris_mask_test(nn,im,im2, 8,threshold);
    sum = sum + correct;
end
avg = sum/size(xName,1);