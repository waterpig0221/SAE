function correct_rate = iris_mask_testPos(nn, testImage, groundtruth,threshold)
testImage = double(testImage)/255;
groundtruth = double(groundtruth)./255;
A = zeros(60,360);
for Pos=1:4
    nn_part = nn{Pos,1}{Pos,1};
    x = splitPos(testImage,Pos);
    % [x, mu, sigma] = zscore(x);
    % groundtruth = normalize(groundtruth, mu, sigma);
    
    n = nn_part.n;
    m = size(x, 1);
    x = [ones(m,1) x];
    nn_part.a{1} = x;
    
    for i = 2 : n-1
        
        % Calculate the unit's outputs (including the bias term)
        nn_part.a{i} = sigm(nn_part.a{i - 1} * nn_part.W{i - 1}');
        %dropout
        if(nn_part.dropoutFraction > 0)
            if(nn_part.testing)
                nn_part.a{i} = nn_part.a{i}.*(1 - nn_part.dropoutFraction);
            else
                nn_part.dropOutMask{i} = (rand(size(nn_part.a{i}))>nn_part.dropoutFraction);
                nn_part.a{i} = nn_part.a{i}.*nn_part.dropOutMask{i};
            end
        end
        
        %calculate running exponential activations for use with sparsity
        if(nn_part.nonSparsityPenalty>0)
            nn_part.p{i} = 0.99 * nn_part.p{i} + 0.01 * mean(nn_part.a{i}, 1);
        end
        %Add the bias term
        nn_part.a{i} = [ones(m,1) nn_part.a{i}];
        nn_part.a{n} = sigm(nn_part.a{n - 1} * nn_part.W{n - 1}');
        
    end
    
    % hypothese = patchMerge(nn.a{1,5}',nn.size(1,1));
    % test = hypothese > threshold;
    % test = ~(xor(test,(groundtruth(1:60,1:360)./255)));
    % correct_rate = size(find(test),1) / (60*360);
    
    hypothese = nn_part.a{1,n}';
    % hypothese2 = hypothese./countMatrix;
    hypothese = reshape(hypothese,[30 180]);
    test = hypothese > threshold;
    switch Pos
        case 1
            A(1:30,1:180) = hypothese;
            test = ~(xor(test,groundtruth(1:30,1:180)));
        case 2
            A(1:30,181:360) = hypothese;
            test = ~(xor(test,groundtruth(1:30,181:360)));
        case 3
            A(31:60,1:180) = hypothese;
            test = ~(xor(test,groundtruth(31:60,1:180)));
        case 4
            A(31:60,181:360) = hypothese;
            test = ~(xor(test,groundtruth(31:60,181:360)));
    end
    correct_rate = size(find(test),1) / (30*180);
end

subplot(4,1,1),imshow(groundtruth,[]);
subplot(4,1,2),imshow(testImage);
subplot(4,1,3),imshow(A,[]);
subplot(4,1,4),imshow(A>threshold);
end