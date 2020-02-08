%% getting the image and using median filter on it
clear all;
I = rgb2gray(imread('samples/test1.jpg'));
charcnn = load('charcnn.mat','net');
[m , n] = size(I); m = double(uint8(m*0.1)); n = double(uint8(n*0.1));
I = medfilt2(I,uint8(([m n]*0.08)));

figure, imshow(I);
%% converting the image to binary having the foreground = 1
T = adaptthresh(I,0.4,'ForegroundPolarity','dark');
BWs = ~imbinarize(I,T);
%% finding edge and using hough to fix rotation
Is = imresize(BWs,[128,128], 'nearest');
Is = imclose(Is, strel('square',20));
figure, imshow(Is);
edges = edge(Is,'canny'); %canny edge detector
[H,theta,rho] = hough(edges);% imshow(H,[]); %hough trans
peak = houghpeaks(H); %getting the peaks
% Find the angle of the handwriting
angle =theta(peak(2))-90; % this only works with test1 angle
%  J = imrotate(I,angle,'bilinear','crop');
%  figure(),imshow(J);
%% using the angle to fix the original img then close
I = imrotate(I,angle,'bilinear','crop');
figure, imshow(I);
%turning black borders to white so they dont interfere
Mrot = ~imrotate(true(size(I)),angle,'bilinear','crop');
I((Mrot&~imclearborder(Mrot))) = 255;
I = medfilt2(I,uint8(([m n]*0.1))); %to remove minor border traces
BW = ~imbinarize(I,T);
BW = imresize(BW,[500, NaN],'nearest');
BW = bwmorph(BW,'thicken',3);
  figure, imshow(BW);
BW = imclose(BW, [0 1 0; 1 1 1; 0 1 0]);%keeps corners better than square se
  figure, imshow(BW);
%% Segmentation time
stats = regionprops(BW);
for index=1:length(stats)
    if stats(index).Area > 1000 && stats(index).BoundingBox(3)*stats(index).BoundingBox(4) < 60000
    x = ceil(stats(index).BoundingBox(1));
    y = ceil(stats(index).BoundingBox(2));
    widthX = floor(stats(index).BoundingBox(3)-1);
    widthY = floor(stats(index).BoundingBox(4)-1);
    img = imresize(BW(y:y+widthY,x:x+widthX,:),[128, 128],'nearest');
    figure, imshow(img);
%     img = bwskel(img,'MinBranchLength',15);
%     figure, imshow(img);
    probs = predict(charcnn.net,uint8(img));
    [val, idx] = max(probs);
%     display(idx)
    label = charcnn.net.Layers(15,1).Classes(idx);
    label = char(hex2dec(char(label)));
    disp(label);
    end
end
