function ROI = findROI(img)
se = strel('disk',5);
img = ~img;
img = imdilate(img,se);
% for l=1:2
    img = bwlabel(img,4);
    [row, col] = size(img);
    ROInumber = max(max(img));
    clear ROI;
    ROI(ROInumber) = struct('position',[],'width',[],'length',[]);
    for k=1:ROInumber
        rowMin = Inf;
        rowMax = 0;
        colMin = Inf;
        colMax = 0;
        for i=1:row
            for j=1:col
                if img(i,j) == k
                    if i > rowMax
                        rowMax = i;
                    end
                    if j > colMax
                        colMax = j;
                    end
                    if i < rowMin
                        rowMin = i;
                    end
                    if j < colMin
                        colMin = j;
                    end
                end
            end
        end
        ROI(k).position = [rowMin,colMin];
        ROI(k).width = colMax - colMin;
        ROI(k).length = rowMax - rowMin;
    end
    
    
    A = [];
    for i=1:ROInumber
        if ROI(i).width<=7 || ROI(i).length<=7
            img(ROI(i).position(1):ROI(i).position(1)+ROI(i).length,ROI(i).position(2):ROI(i).position(2)+ROI(i).width) = 0;
        end
        if ROI(i).position(1) > 10
            A = [A,i];
        end
    end
    ROI(A) = [];
    ROInumber = size(ROI,2);
    
    for i=1:ROInumber
        img(ROI(i).position(1):ROI(i).position(1)+ROI(i).length,ROI(i).position(2):ROI(i).position(2)+ROI(i).width) = 255;
    end
    %% show the ROI
%     if l==2
%         figure,imshow(img);
%     end
    
% end

end