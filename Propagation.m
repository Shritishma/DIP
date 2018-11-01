function [offsets,NNF]=Propagation(offsets,ii,jj,NNF,inimgpad,srcimg,s,w)
        ofs_prp(1) = offsets(ii,jj);
        ofs_prp(2) = offsets(max(1,ii-1),jj);
        ofs_prp(3) = offsets(ii,max(1,jj-1));
        [~,idx] = min(ofs_prp);
        if(idx==2)
            if NNF(ii-1,jj,1)+1+w<=s(1) && NNF(ii-1,jj,2)+w<=s(2)
                NNF(ii,jj,:) = NNF(ii-1,jj,:);
                NNF(ii,jj,1) = NNF(ii,jj,1)+1;
                temp = inimgpad-srcimg;
                temp = temp(~isnan(temp(:)));
                offsets(ii,jj) = sum(temp(:).^2)/length(temp(:));
            end
        elseif(idx==3)
            if NNF(ii,jj-1,1)<=s(1) && NNF(ii,jj-1,2)+1+w<=s(2)
                NNF(ii,jj,:) = NNF(ii,jj-1,:);
                NNF(ii,jj,2) = NNF(ii,jj,2)+1;
                temp = inimgpad-srcimg;
                temp = temp(~isnan(temp(:)));
                offsets(ii,jj) = sum(temp(:).^2)/length(temp(:));
            end
        end
end