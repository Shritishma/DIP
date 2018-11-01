close all;
clear all;
InputImageName = 'a.png';
SourceImageName = 'b.png';
inImg1=imread((InputImageName));
srcImg1=imread(SourceImageName);
im1=size(imread(InputImageName));
psz = 1;
w = (psz-1)/2;
disp('PatchMatch Start!');
tic
[NNF] =PatchMatch3(inImg1, srcImg1, psz);
toc
disp('PatchMatch Done!');
fprintf('Reconstructing Output Image... ');
reconstImg = zeros(size(inImg1));
for ii = (1+w):psz:size(inImg1,1)-w
    for jj = (1+w):psz:size(inImg1,2)-w
        im1(ii-w:ii+w,jj-w:jj+w,1)=srcImg1(NNF(ii,jj,1)-w:NNF(ii,jj,1)+w,NNF(ii,jj,2)-w:NNF(ii,jj,2)+w,1);
        im1(ii-w:ii+w,jj-w:jj+w,2)=srcImg1(NNF(ii,jj,1)-w:NNF(ii,jj,1)+w,NNF(ii,jj,2)-w:NNF(ii,jj,2)+w,2);
        im1(ii-w:ii+w,jj-w:jj+w,3)=srcImg1(NNF(ii,jj,1)-w:NNF(ii,jj,1)+w,NNF(ii,jj,2)-w:NNF(ii,jj,2)+w,3);
    end
end
fprintf('Done!\n');
imshow(uint8(im1));

