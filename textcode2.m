close all;
clear all;
InputImageName = 'app2.png';
im=imread(InputImageName);
imshow(InputImageName);
h_rect = imrect();
pos_rectin = h_rect.getPosition();
pos_rectin = round(pos_rectin);
inImg1 = im(pos_rectin(2) + (0:pos_rectin(4)), pos_rectin(1) + (0:pos_rectin(3)),:);


SourceImageName = 'app1.png';
img=imread(SourceImageName);
imshow(SourceImageName);
h_rect = imrect();
pos_rect = h_rect.getPosition();
pos_rect = round(pos_rect);
srcImg1 = img(pos_rect(2) + (0:pos_rect(4)), pos_rect(1) + (0:pos_rect(3)),:);

psz = 41;
w = (psz-1)/2;
disp('PatchMatch Start!');
tic
[NNF] =PatchMatch4(inImg1, srcImg1, psz);
toc
disp('PatchMatch Done!');
fprintf('Reconstructing Output Image... ');
reconstImg = zeros(size(inImg1));
for ii = (1+w):psz:size(inImg1,1)
    for jj = (1+w):psz:size(inImg1,2)
            im1(ii-w:ii+w,jj-w:jj+w,1)=srcImg1(NNF(ii,jj,1)-w:NNF(ii,jj,1)+w,NNF(ii,jj,2)-w:NNF(ii,jj,2)+w,1);
            im1(ii-w:ii+w,jj-w:jj+w,2)=srcImg1(NNF(ii,jj,1)-w:NNF(ii,jj,1)+w,NNF(ii,jj,2)-w:NNF(ii,jj,2)+w,2);
            im1(ii-w:ii+w,jj-w:jj+w,3)=srcImg1(NNF(ii,jj,1)-w:NNF(ii,jj,1)+w,NNF(ii,jj,2)-w:NNF(ii,jj,2)+w,3);
    end
end
re_size=size(im1);
fprintf('Done!\n');
im(pos_rectin(2) + (1:re_size(1)), pos_rectin(1) + (1:re_size(2)),:)=im1;
figure,imshow(uint8(im));