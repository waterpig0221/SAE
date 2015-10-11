inputDir = dir('F:\iris_mask\ICE_Database\IceRightWithMask\polar\');
for j=3:size(inputDir,1)
    testImage = imread(['F:\iris_mask\ICE_Database\IceRightWithMask\polar\' inputDir(j,1).name]);
    testImage = double(testImage)/255;
    x = split(testImage,nn.size(1,1));
    [x, mu, sigma] = zscore(x);
    % groundtruth = normalize(groundtruth, mu, sigma);
    n = nn.n;
    m = size(x, 1);
    x = [ones(m,1) x];
    nn.a{1} = x;
    
    for i = 2 : n-1
        % Calculate the unit's outputs (including the bias term)
        nn.a{i} = sigm(nn.a{i - 1} * nn.W{i - 1}');
        %dropout
        if(nn.dropoutFraction > 0)
            if(nn.testing)
                nn.a{i} = nn.a{i}.*(1 - nn.dropoutFraction);
            else
                nn.dropOutMask{i} = (rand(size(nn.a{i}))>nn.dropoutFraction);
                nn.a{i} = nn.a{i}.*nn.dropOutMask{i};
            end
        end
        %calculate running exponential activations for use with sparsity
        if(nn.nonSparsityPenalty>0)
            nn.p{i} = 0.99 * nn.p{i} + 0.01 * mean(nn.a{i}, 1);
        end
        %Add the bias term
        nn.a{i} = [ones(m,1) nn.a{i}];
        nn.a{n} = sigm(nn.a{n - 1} * nn.W{n - 1}');
    end
%     if countOpt == 8
%         load countMatrix\count8
%     elseif countOpt == 16
        load countMatrix\count16
%     elseif countOpt ==32
%         load countMatrix\count32
%     end
    hypothese = patchMerge(nn.a{1,5}',nn.size(1,1));
    hypothese2 = hypothese./countMatrix;
    test = hypothese2 > threshold;
    str1 = 'F:\iris_mask\output\';
    d = dir(str1);
    str2 = size(d,1)-1;
    str3 = '.bmp';
    imwrite(~test,[str1 inputDir(j,1).name str3],'bmp');
end