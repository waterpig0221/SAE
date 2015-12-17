function mask = createMaskRulebased(imgage)
mask = [];
temp_img = conv2(normalize_img(imgage), [ 1; -1], 'same');
keep_conved_img = abs(temp_img-mean(temp_img(:))) < 2*std(temp_img(:));
mask = keep_conved_img;

temp_img = conv2(normalize_img(imgage),ones(5,5),'same');
keep_conved_img = abs(temp_img-mean(temp_img(:))) < 2*std(temp_img(:));
mask = keep_conved_img & mask;

mask = imclose(imopen(mask,strel('disk',4)),strel('disk',1));


function norm_img = normalize_img (img)
img2 = double(img);
total = double(sum(sum(img2.*img2)));
norm_img = double(img)./sqrt(total);
