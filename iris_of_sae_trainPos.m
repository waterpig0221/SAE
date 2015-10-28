function nn = iris_of_sae_trainPos(N, trainNum, Pos)
%% load Data
load DataName;
if size(xName,1) ~= trainNum
    xName = xName(1:trainNum,:);
    yName = yName(1:trainNum,:);
end


%%  Setup and train a stacked denoising autoencoder (SDAE)
rand('state',0)
for j=1:trainNum
    sae{Pos,1} = saesetup(N(1,1:end-1));
    if j==1
        for i=1:size(N,2)-2
            sae{Pos,1}.ae{i}.activation_function       = 'sigm';
            sae{Pos,1}.ae{i}.learningRate              = 0.01;
            sae{Pos,1}.ae{i}.inputZeroMaskedFraction   = 0.5;
            opts.numepochs =   50;
            %opts.batchsize = 353;           % if input patch size is 64
            %             opts.batchsize = 345;           % if input patch size is 256
            opts.batchsize = 1;           % if input patch size is 1024
        end
    end
    train_x = double(imread([xDir xName{j,:}]))/255;
    train_x = splitPos(train_x,Pos);
    train_y = double(imread([yDir yName{j,:}]))/255;
    train_y = splitPos(train_y,Pos);
    % normalize
    [train_x, mu, sigma] = zscore(train_x);
    sae{Pos,1} = saetrain(sae{Pos,1}, train_x, opts);
end
% for i=1:size(N,2)-2  %視覺化選項
%     figure,visualize(sae.ae{i}.W{i}(:,2:end)');
% end

% Use the SDAE to initialize a FFNN
disp('NN fine-tune');

%% NN fine-tune


nn{Pos,1} = nnsetup(N);
nn{Pos,1}.activation_function              = 'sigm';
nn{Pos,1}.learningRate                     = 0.01;
for i=1:size(N,2)-2
    nn{Pos,1}.W{i} = sae{Pos,1}.ae{i}.W{1};
end

% Train the FFNN
opts.numepochs =   50;
%opts.batchsize = 353;           % if input patch size is 64
% opts.batchsize = 345;           % if input patch size is 256
opts.batchsize = 1;           % if input patch size is 1024

for j = 1:trainNum
    train_x = double(imread([xDir xName{j,:}]))/255;
    train_x = splitPos(train_x,Pos);
    train_y = double(imread([yDir yName{j,:}]))/255;
    train_y = splitPos(train_y,Pos);
    % normalize
    [train_x, mu, sigma] = zscore(train_x);
    nn{Pos,1} = nntrain(nn{Pos,1}, train_x, train_y, opts);
end
% [er, bad] = nntest(nn, test_x, test_y);
% assert(er < 0.16, 'Too big error');
