% 
% % load a training example image
% Itrain = im2double(rgb2gray(imread('test2.jpg')));
% 
% %have the user click on some training examples.  
% % If there is more than 1 example in the training image (e.g. faces), you could set nclicks higher here and average together
% nclick = 1;
% figure(1); clf;
% imshow(Itrain);
% [x,y] = ginput(nclick); %get nclicks from the user
% 
% %compute 8x8 block in which the user clicked
% blockx = round(x/8);
% blocky = round(y/8); 
% 
% %visualize image patch that the user clicked on
% % the patch shown will be the size of our template
% % since the template will be 16x16 blocks and each
% % block is 8 pixels, visualize a 128pixel square 
% % around the click location.
% figure(2); clf;
% for i = 1:nclick
%   patch = Itrain(8*blocky(i)+(-63:64),8*blockx(i)+(-63:64));
%   figure(2); subplot(3,2,i); imshow(patch);
% end
% 
% % compute the hog features
% f = hog(Itrain);
% 
% % compute the average template for the user clicks
% template = zeros(16,16,9);
% for i = 1:nclick
%   template = template + f(blocky(i)+(-7:8),blockx(i)+(-7:8),:); 
% end
% template = template/nclick;
% 
% 
% %
% % load a test image
% %
% Itest= im2double(rgb2gray(imread('test3.jpg')));
% I = Itest;
% 
% ndet = 5;

function [x,y,score] = detection(I,template,ndet)
%
% return top ndet detections found by applying template to the given image.
%   x,y should contain the coordinates of the detections in the image
%   score should contain the scores of the detections
%


% compute the feature map for the image
f = hog(I);

nori = size(f,3);

% cross-correlate template with feature map to get a total response
R = zeros(size(f,1),size(f,2));
for i = 1:nori
  R = R + imfilter(f(:,:,i),template(:,:,i),'symmetric');% EDITTED imfilter(...
end

% now return locations of the top ndet detections

% sort response from high to low
[val,index] = sort(R(:),'descend');

% work down the list of responses, removing overlapping detections as we go
i = 1;
detcount = 1;
feature_map_size = size(f,1);

while ((detcount <= ndet) && (i < length(index)))
  % convert ind(i) back to (i,j) values to get coordinates of the block
  position = index(i)-1;
  xblock = floor(position/feature_map_size) + 1;   %EDITTED
  yblock = mod(position,feature_map_size) + 1;      %EDITTED
  
  assert(val(i)==R(yblock,xblock)); %make sure we did the indexing correctly

  % now convert yblock,xblock to pixel coordinates 
  ypixel = yblock * 8;
  xpixel = xblock * 8;

  % check if this detection overlaps any detections which we've already added to the list
  if(detcount == 1)
      overlap = 0;
  else
      %overlap is the squared error
      dist_formula = (x-xpixel).^2 +(y-ypixel).^2;
      the_sum = 0;
      for each_num = 1:size(dist_formula)
          if(dist_formula(each_num) < (16*8).^2)
              the_sum = the_sum + dist_formula(each_num);
          end
      end
      overlap = the_sum;
  end

  % if not, then add this detection location and score to the list we return
  if (~overlap)
    x(detcount) = xpixel;               %EDITTED
    y(detcount) = ypixel;               %EDITTED
    score(detcount) = R(yblock,xblock); %EDITTED
    detcount = detcount+1;
  end
  i = i + 1;
end


