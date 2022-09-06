    
function beta = soPooling(feamap,pymd,height,width,params)
    %%%%%%%%%%%%%%%%%%%%%%%%
    %%% the code is modified from the source codes of the following papers:
    %%% [1] J. Carreira, R.Caseiro, J. Batista, et al. Free-Form Region Description with Second-Order Pooling. TPAMI 2015
    %%% [2] F. Shen, C. Shen, X. Zhou, et al. Face image classification by pooling raw features. PR 2016
    %%%%%%%%%%%%%%%%%%%%%%%%

    Pyramid=[pymd(:),pymd(:)];     
    feamap = reshape(feamap',height,width,size(feamap,1));    
    [prows,pcols]=size(feamap(:,:,1));
    
    beta = [];
    for lev = 1:size(Pyramid,1)
        nRow = Pyramid(lev,1);% num of pooling grid along the row dimension
        nCol = Pyramid(lev,2);% num of pooling grid along the column dimension
        r_bin = round(prows/nRow);% num of pathes in each bin along the row dimension
        if r_bin*nRow >= prows, 
            r_bin = floor(prows/nRow);
        end
        c_bin = round(pcols/nCol);% num of pathes in each bin along the column dimension
        if c_bin*nCol >= pcols,
            c_bin = floor(pcols/nCol);
        end
        for ix_bin_r = 1:nRow
            for ix_bin_c = 1:nCol
                r_bound = ix_bin_r*r_bin; 
                if ix_bin_r == nRow, 
                    r_bound = prows;
                end
                c_bound = ix_bin_c*c_bin; 
                if ix_bin_c == nCol, 
                    c_bound = pcols;
                end
                
                sq1 = ((ix_bin_r-1)*r_bin+1):r_bound;
                sq2 = ((ix_bin_c-1)*c_bin+1):c_bound;
                theregion =feamap(sq1,sq2,:);
             
                %%% second order pooling
                [hhh,www,ddd]=size(theregion);
                localfeamap = (reshape(theregion,hhh*www,ddd))';
                in_triu = triu(true(size(localfeamap,1)));    
                covpool = (localfeamap*localfeamap')./(size(localfeamap,2));                 
                covpool = real(logm(covpool + params.offvalue*eye(size(localfeamap,1))));
                tempfeat =  covpool(in_triu);

                beta = [beta, tempfeat(:)'];
            end
        end
    end

    beta = beta(:);

            





