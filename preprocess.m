function img = preprocess(imgg)
%% this func takes in a location of an rgb char image

% I = rgb2gray(imread('C:\Users\TB\Documents\MATLAB\project\by_class\4c\hsf_0\hsf_0_00423.png'));
 I = rgb2gray(imgg);
T = adaptthresh(I,0.4,'ForegroundPolarity','dark');
% I = medfilt2(I,[3, 3]);
BW = ~imbinarize(I,T);

 c_se = [0 1 0; 1 1 1; 0 1 0];%[0 0 1 0 0; 0 0 1 0 0; 1 1 1 1 1; 0 0 1 0 0; 0 0 1 0 0];


BW = resize(BW,[128 , 128]);
% BW = bwmorph(BW,'thin',3);
BW = imerode(BW, ones(3,3));
%BW = imdilate(BW, c_se);
BW = bwmorph(BW,'thicken',3);
img = imclose(BW,c_se);

% img = bwmorph(img, 'spur', Inf);%[0 1 0; 1 1 1; 0 1 0]);
% figure, imshow(img);
% figure, imshow(I);

% img = bwskel(BW,'MinBranchLength',15);
  



