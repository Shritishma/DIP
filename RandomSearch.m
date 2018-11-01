function [offsets,NNF]=RandomSearch(NNF,offsets,Radius,lenRad,ii,jj,w,inimgpad,srcimg,s)
      
        iis_min = max(1+w,NNF(ii,jj,1)-Radius(:));
        iis_max = min(NNF(ii,jj,1)+Radius(:),s(1)-w);
        jjs_min = max(1+w,NNF(ii,jj,2)-Radius(:));
        jjs_max = min(NNF(ii,jj,2)+Radius(:),s(2)-w);
        
        iis = floor(rand(lenRad,1).*(iis_max(:)-iis_min(:)+1)) + iis_min(:);
        jjs = floor(rand(lenRad,1).*(jjs_max(:)-jjs_min(:)+1)) + jjs_min(:);
        temp1=offsets(ii,jj);
        temp2=NNF(ii,jj,1);
        temp3=NNF(ii,jj,2);
        for itr_rs = 1:lenRad
            tmp1 = inimgpad(w+ii-w:w+ii+w,w+jj-w:w+jj+w,:) - srcimg(iis(itr_rs)-w:iis(itr_rs)+w,jjs(itr_rs)-w:jjs(itr_rs)+w,:);
            tmp2 = tmp1(~isnan(tmp1(:)));
            pichi = sum(tmp2.^2)/length(tmp2);
            if(pichi<temp1)
                temp1=pichi;
                temp2=iis(itr_rs);
                temp3=jjs(itr_rs);
            end
        end
        offsets(ii,jj)=temp1;
        NNF(ii,jj,1) = temp2;
        NNF(ii,jj,2)=temp3;
        end