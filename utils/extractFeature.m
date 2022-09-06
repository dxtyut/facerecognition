function [FEAFEA] = extractFeature(X, rfZCADIC, DIM, params)
    %%%%%%% X: nxd
    
    pyramid = params.pyramid;    
    FEAFEA = zeros(sum([1:sum(params.numFilter)])*sum(pyramid.^2),size(X,1));

    for i=1:size(X,1)
        patchesALL = [];
        for ix_rf = 1:length(params.rfSize)
            rfSize = params.rfSize(ix_rf);
            M = rfZCADIC{ix_rf}.M;
            P = rfZCADIC{ix_rf}.P;
            D = rfZCADIC{ix_rf}.dictionary;

            %%%%%% extract overlapping sub-patches into rows of 'patches'
            III= reshape(X(i,:),DIM(1:2));
            III= myPadding(III,rfSize);
            patches = [im2col(III, [rfSize rfSize])]';
       
            %%%%%% do preprocessing for each patch        
            %%%%%% normalize for contrast
            patches = bsxfun(@rdivide, bsxfun(@minus, patches, mean(patches,2)), sqrt(var(patches,[],2)+10));

            %%%%%% whiten
            patches = bsxfun(@minus, patches, M) * P;

            %%%%%% compute activation
            switch (params.activation)
                case 'tanh'
                   patches = tanh(patches * D');
                otherwise
                    error('Unknown encoder type.');
            end
            %%%%%% patches is now the data matrix of activations for each patch
                        
            patchesALL = [patchesALL;patches'];clear patches;
        end
        FEAFEA(:,i) = soPooling(patchesALL,pyramid,DIM(1),DIM(2),params);
        clear patchesALL;
    end    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    