function ohist = hog(I)
%
% compute orientation histograms over 8x8 blocks of pixels
% orientations are binned into 9 possible bins
%
% I : grayscale image of dimension HxW
% ohist : orinetation histograms for each block. ohist is of dimension (H/8)x(W/8)x9
%

% I = im2double(imread('rock_wall.jpg'));
% I = rgb2gray(I);

[h,w] = size(I); %size of the input
h2 = ceil(h/8); %the size of the output
w2 = ceil(w/8);
nori = 9;       %number of orientation bins

% disp(h);
% disp(w);
% disp(h2);
% disp(w2);

[mag,ori] = mygradient(I);
thresh = 0.1*max(mag(:));  %threshold for edges %EDITTED

% disp(mag); %mag = edge strength
% disp(ori); %ori = gradient representation

% separate out pixels into orientation channels
ohist = zeros(h2,w2,nori); %25 x 25 x 9
for i = 1:nori
  % create a binary image containing 1's for the pixels that are edges at this orientation
  max_ori = i*2*pi/nori - pi;           %EDITTED
  min_ori =(i-1)*2*pi/nori - pi;        %EDITTED
  
%   disp(max_ori);
%   disp(min_ori);
  B = (ori >= min_ori & ori <= max_ori & mag > thresh); %add 1's to the edges of B %EDITTED

  % sum up the values over 8x8 pixel blocks.
  chblock = im2col(B,[8 8],'distinct');  %useful function for grabbing blocks
                                         %sum over each block and store result in ohist
   ohist(:,:,i) = reshape(sum(chblock), h2, w2); %EDITTED                    
end

% normalize the histogram so that sum over orientation bins is 1 for each block
%   NOTE: Don't divide by 0! If there are no edges in a block (ie. this counts sums to 0 for the block) then just leave all the values 0. 

%add by the 3rd degree
ohist_sum = sum(ohist,3);
% get rid of all ones
ohist_sum(ohist_sum == 0) = 1;

%{
for each item in the bin
divide the array of the ohist by the corresponding array of ohist_sum
ohist = ohist ./ohist_norm
%}
for i = 1:nori
    ohist(:,:,i) = ohist(:,:,i)./ohist_sum;
end

end

