i1 = imread('./gt/i1.jpg');
o1 = imread('./gt/o1.jpg');
o1 = rgb2gray(o1);

o1 = mat2gray(o1);
imshow(o1);
pause;

i1 = mat2gray(i1);
i1 = double(i1);
imshow(i1);

pause;

c1 = o1.*i1;
imshow(c1);