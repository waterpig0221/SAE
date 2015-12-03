function [imOut] = splitPos(imIn, pos, option)
% split by posistion
% pos : UL 1, UR 2, DL 3, DR 4
% option : 1 6*6 no overlap split
%          2 8*8 overlap split
switch pos
    case 1
        imOut = imIn(1:30,1:180);
    case 2
        imOut = imIn(1:30,181:360);
    case 3
        imOut = imIn(31:60,1:180);
    case 4
        imOut = imIn(31:60,181:360);
end
patchCount = 1;
switch option
    case 1
        tmp = zeros(36,150);
        for i=1:6:30
            for j=1:6:180
                t = imOut(i:i+5,j:j+5);
                tmp(:,patchCount) = t(:);
                patchCount = patchCount + 1;
            end
        end
    case 2
        tmp = zeros(64,3979);
        for i=1:23
            for j=1:173
                t = imOut(i:i+7,j:j+7);
                tmp(:,patchCount) = t(:);
                patchCount = patchCount + 1;
            end
        end
end
imOut = tmp';
end

