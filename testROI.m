% close all
% im是原始虹膜影像
% im2是遮罩groundtruth
% im3是rule-based產生的遮罩
% inputDir是要預測虹膜影像資料夾路徑
% outputDir是要預測的遮罩儲存資料夾路徑
inputDir = 'F:\iris_mask\ICE_Database\IceRightWithMask\polar\';
outputDir = 'F:\iris_mask\predict\IceRightWithMask\mask\';

D = dir(inputDir);
for j = 3:size(D,1)
    im = imread([inputDir D(j).name]);
    im3 = createMaskRulebased(im);
    finalMask = ~im3;
    ROI =  findROI(im3);
    treshold = 0.88;
    for i=1:size(ROI,2)
        a = ROI(i).position(1);
        b = ROI(i).position(2);
        c = ROI(i).length;
        d = ROI(i).width;
        predictRegion = im(a:a+c-1,b:b+d-1);
%             predictRegion2 = im2(a:a+c-1,b:b+d-1);
        predictRegion3 = ~im3(a:a+c-1,b:b+d-1);
        partialMask = predictMask(nn,predictRegion);
%             figure,subplot(6,1,1),imshow(predictRegion);
%             subplot(6,1,2),imshow(predictRegion2);
%             subplot(6,1,3),imshow(predictRegion3);
%             subplot(6,1,4),imshow(partialMask,[]);
%             subplot(6,1,5),imshow(partialMask>treshold);
%             subplot(6,1,6),imshow((partialMask>treshold)|(predictRegion3));
        finalMask(a:a+c-1,b:b+d-1) = (partialMask>treshold)|(predictRegion3);
    end
    imwrite(finalMask,[outputDir 'oc' D(j).name(2:end)], 'bmp');
    % figure,imshow(finalMask);
end
