inputTestDir = 'F:\iris_mask\predict_201512161614\IceLeftWithMask\mask\';
inputCorrectDir = 'F:\iris_mask\ICE_Database\IceLeftWithMask\mask\';
D1 = dir(inputTestDir);
D2 = dir(inputCorrectDir);
assert(size(D1,1) == size(D2,1),'error 兩個資料夾圖片量不相等');

correct_rate = zeros(size(D1,1) - 2,1);

for j=3:size(D1,1)
    im = imread([inputTestDir D1(j).name]);
    im2 = imread([inputCorrectDir D2(j).name]);
    [row1, col1] = size(im);
    [row2, col2] = size(im2);
    if row1~=row2 || col1~=col2
        disp('error');
    end
    assert((row1==row2 && col1==col2),'error 兩張圖片大小不相等');
    tmp = ~xor(im,im2);
    correct_rate(j-2) = size(find(tmp),1) / (row1*col1);
end
avg_rate = sum(correct_rate)/size(correct_rate,1);