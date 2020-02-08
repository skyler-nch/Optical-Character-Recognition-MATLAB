function img = resize(bw,s)
%bw is a binary image
%find the first row/col that has a trace of the character
x_range = max(bw,[],1);
y_range = max(bw,[],2);
border = [0,0,0,0];
for i=1:size(x_range,2)
    if x_range(i) == 1
        border(1) = i;
        break;
    end
end

for i=size(x_range,2):-1:1
    if x_range(i) == 1
        border(3) = i;
        break;
    end
end

for i=1:size(y_range,1)
    if y_range(i) == 1
        border(2) = i;
        break;
    end
end

for i=size(y_range,1):-1:1
    if y_range(i) == 1
        border(4) = i;
        break;
    end
end
%calculate width and height
width = abs(border(1) - border(3));
height = abs(border(2) - border(4));
if width < height
   x = int8((height - width)/2);
   if (border(1) - x) > -1
      border(1) = border(1) - x ;
      border(3) = width+x;
      border(4) = height;
   else
       border(1) = 0;
       border(3) = width+x;
       border(4) = height;
   end
elseif width > height
    x = int8((width - height)/2);
    if (border(2) - x) > -1
        border(2) = border(2) - x;
        border(3) = width;
        border(4) = height+x;
    else
        border(2) = 0;
        border(3) = width;
        border(4) = height+x;
    end
    
else
    border(3) = width; border(4) = height;
end
%crop
img= imcrop(bw,border);
% imshow(img);

img = imresize(img,s,'nearest');

