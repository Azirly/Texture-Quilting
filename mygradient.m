function [mag,ori] = mygradient(I)
%
% compute image gradient magnitude and orientation at each pixel
%

% I = im2double(rgb2gray(imread('test2.jpg')));

%use a filter that is smooth and simulates the slides
%prewitt or sobel? sobel, prewiit more sensitive to noise

horizontal_filter = fspecial('sobel');
trans_hori_filter = transpose(horizontal_filter);
dx = imfilter(I, horizontal_filter, 'replicate');
dy = imfilter(I, trans_hori_filter, 'replicate');

%mag represents the edge strength
mag = sqrt(dx.^2 + dy.^2);

%ori represents the gradient representation
ori = atan2(dy, dx);

% figure;
% imagesc(mag);
% title('Gradient Magnitude of test2.jpg')
% colorbar;
% colormap jet;
% figure;
% imagesc(ori);
% title('Gradient Orientation of test2.jpg')
% colorbar;
% colormap jet;

%test1.jpg
%colorbar
%colormap jet

%imagesc
%title
