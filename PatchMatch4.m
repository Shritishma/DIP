function [NNF] = PatchMatch4(inimg, srcimg, psz)
inimg = double(inimg);
srcimg = double(srcimg);
inImg=inimg;
srcImg1=srcimg;
w = (psz-1)/2;
% random initilization
max_iterations = 4;
s_size = [size(srcimg,1),size(srcimg,2)];
i_size = [size(inImg,1),size(inImg,2)];
inimgpad=padarray(inImg,[w,w],nan,'both');
NNF = cat(3,randi([1+w,s_size(1)-w],i_size),randi([1+w,s_size(2)-w],i_size));
im1=zeros(size(inImg));
for i = (1+w):psz:size(inImg,1)
    for j = (1+w):psz:size(inImg,2)
            im1(i-w:i+w,j-w:j+w,1)=srcImg1(NNF(i,j,1)-w:NNF(i,j,1)+w,NNF(i,j,2)-w:NNF(i,j,2)+w,1);
            im1(i-w:i+w,j-w:j+w,2)=srcImg1(NNF(i,j,1)-w:NNF(i,j,1)+w,NNF(i,j,2)-w:NNF(i,j,2)+w,2);
            im1(i-w:i+w,j-w:j+w,3)=srcImg1(NNF(i,j,1)-w:NNF(i,j,1)+w,NNF(i,j,2)-w:NNF(i,j,2)+w,3);
    end
end
%figure;imshow(uint8(im1));
offsets = inf(i_size(1),i_size(2));
for ii = 1:i_size(1)
  for jj = 1:i_size(2)
    temp = inimgpad(w+ii-w:w+ii+w,w+jj-w:w+jj+w,:)- srcimg(NNF(ii,jj,1)-w:NNF(ii,jj,1)+w,NNF(ii,jj,2)-w:NNF(ii,jj,2)+w,:);
    temp = temp(~isnan(temp(:)));
    offsets(ii,jj) = sum(temp.^2)/length(temp);
  end
end
%start of algorithm
for iteration = 1:max_iterations
for ii = 1:i_size(1)
    for jj = 1:i_size(2)
        %--  Propagation
        %[offsets,NNF]=Propagation(offsets,ii,jj,NNF,inimgpad(w+ii-w:w+ii+w,w+jj-w:w+jj+w,:),srcimg(NNF(ii,jj,1)-w:NNF(ii,jj,1)+w,NNF(ii,jj,2)-w:NNF(ii,jj,2)+w,:),s_size,w);
        ofs_prp(1) = offsets(ii,jj);
        ofs_prp(2) = offsets(max(1,ii-1),jj);
        ofs_prp(3) = offsets(ii,max(1,jj-1));
        [~,idx] = min(ofs_prp);
        if(idx==2)
            if NNF(ii-1,jj,1)+1+w<=s_size(1) && NNF(ii-1,jj,2)+w<=s_size(2)
                NNF(ii,jj,:) = NNF(ii-1,jj,:);
                NNF(ii,jj,1) = NNF(ii,jj,1)+1;
                temp = inimgpad(w+ii-w:w+ii+w,w+jj-w:w+jj+w,:)...
                    - srcimg(NNF(ii,jj,1)-w:NNF(ii,jj,1)+w,NNF(ii,jj,2)-w:NNF(ii,jj,2)+w,:);
                temp = temp(~isnan(temp(:)));
                offsets(ii,jj) = sum(temp(:).^2)/length(temp(:));
            end
        elseif(idx==3)
            if NNF(ii,jj-1,1)<=s_size(1) && NNF(ii,jj-1,2)+1+w<=s_size(2)
                NNF(ii,jj,:) = NNF(ii,jj-1,:);
                NNF(ii,jj,2) = NNF(ii,jj,2)+1;
                temp = inimgpad(w+ii-w:w+ii+w,w+jj-w:w+jj+w,:)...
                    - srcimg(NNF(ii,jj,1)-w:NNF(ii,jj,1)+w,NNF(ii,jj,2)-w:NNF(ii,jj,2)+w,:);
                temp = temp(~isnan(temp(:)));
                offsets(ii,jj) = sum(temp(:).^2)/length(temp(:));
            end
        end
        % RandomSearch
        %[offsets,NNF]=RandomSearch(NNF,offsets,Radius,lenRad,ii,jj,w,inimgpad,srcimg,s_size);
        radius = s_size(1)/4;
        alpha = .5;
        Radius = round(radius*alpha.^(0:(-floor(log(radius)/log(alpha)))));
        lenRad = length(Radius);
        iis_min = max(1+w,NNF(ii,jj,1)-Radius(:));
        iis_max = min(NNF(ii,jj,1)+Radius(:),s_size(1)-w);
        jjs_min = max(1+w,NNF(ii,jj,2)-Radius(:));
        jjs_max = min(NNF(ii,jj,2)+Radius(:),s_size(2)-w);
        iis = floor(rand(lenRad,1).*(iis_max(:)-iis_min(:)+1)) + iis_min(:);
        jjs = floor(rand(lenRad,1).*(jjs_max(:)-jjs_min(:)+1)) + jjs_min(:);
        temp1=offsets(ii,jj);
        temp2=NNF(ii,jj,1);
        temp3=NNF(ii,jj,2);
        for itr_rs = 1:lenRad
            tmp1 = inimgpad(w+ii-w:w+ii+w,w+jj-w:w+jj+w,:) - srcimg(iis(itr_rs)-w:iis(itr_rs)+w,jjs(itr_rs)-w:jjs(itr_rs)+w,:);
            tmp2 = tmp1(~isnan(tmp1(:)));
            pic = sum(tmp2.^2)/length(tmp2);
            if(pic<temp1)
                temp1=pic;
                temp2=iis(itr_rs);
                temp3=jjs(itr_rs);
            end
        end
        offsets(ii,jj)=temp1;
        NNF(ii,jj,1) = temp2;
        NNF(ii,jj,2)=temp3;
        
    end % jj
  if((ii==round(i_size(1)/4)||ii==round(i_size(1)*0.75)) && iteration==1)
      im1=zeros(size(inImg));
      for i = (1+w):psz:size(inImg,1)
          for j = (1+w):psz:size(inImg,2)
                  im1(i-w:i+w,j-w:j+w,1)=srcImg1(NNF(i,j,1)-w:NNF(i,j,1)+w,NNF(i,j,2)-w:NNF(i,j,2)+w,1);
                  im1(i-w:i+w,j-w:j+w,2)=srcImg1(NNF(i,j,1)-w:NNF(i,j,1)+w,NNF(i,j,2)-w:NNF(i,j,2)+w,2);
                  im1(i-w:i+w,j-w:j+w,3)=srcImg1(NNF(i,j,1)-w:NNF(i,j,1)+w,NNF(i,j,2)-w:NNF(i,j,2)+w,3);
          end
      end
     %figure;imshow(uint8(im1));
  end
end % ii
im1=zeros(size(inImg));
for i = (1+w):psz:size(inImg,1)
    for j = (1+w):psz:size(inImg,2)
            im1(i-w:i+w,j-w:j+w,1)=srcImg1(NNF(i,j,1)-w:NNF(i,j,1)+w,NNF(i,j,2)-w:NNF(i,j,2)+w,1);
            im1(i-w:i+w,j-w:j+w,2)=srcImg1(NNF(i,j,1)-w:NNF(i,j,1)+w,NNF(i,j,2)-w:NNF(i,j,2)+w,2);
            im1(i-w:i+w,j-w:j+w,3)=srcImg1(NNF(i,j,1)-w:NNF(i,j,1)+w,NNF(i,j,2)-w:NNF(i,j,2)+w,3);
    end
end
end % iteration
%figure;imshow(uint8(im1));
end 