
function rfZCADIC = zcaDictLearn(params,dataset,CDTrainData,DIM)

addpath(genpath('utils'));

rfZCADIC = cell(1, length(params.rfSize));

for ix_rf = 1:length(params.rfSize)
    rfSize = params.rfSize(ix_rf);
    numFilter = params.numFilter(ix_rf);
    fprintf('\t********************* Processing rfsize %d *********************\n',rfSize);

    fprintf('\t\tStart get patches\n');

    %%%%%% get image patches
    NUM = 200000;
    patches = zeros(NUM, rfSize*rfSize);
    for i=1:NUM 
      r = random('unid', DIM(1) - rfSize + 1);
      c = random('unid', DIM(2) - rfSize + 1);
      patch = reshape(CDTrainData(random('unid', size(CDTrainData,1)),:), DIM);
      patch = patch(r:r+rfSize-1,c:c+rfSize-1,:);
      patches(i,:) = patch(:)';
    end

    fprintf('\t\tStart mean std and ZCA\n');
    %%%%%% normalize for contrast
    patches = bsxfun(@rdivide, bsxfun(@minus, patches, mean(patches,2)), sqrt(var(patches,[],2)+10));

    %%%%%% ZCA whitening (with low-pass)
    C = cov(patches);
    M = mean(patches);
    [V,D] = eig(C);
    P = V * diag(sqrt(1./(diag(D) + 0.1))) * V';
    patches = bsxfun(@minus, patches, M) * P;

    %%%%%% run filter learning
    fprintf('\t\tStart learn dictionary\n');
    switch params.dicmethod
        case 'pca'
            Rx = patches'*patches/(size(patches,1)-1);
            [E,D] = eig(Rx);
            [~, ind] = sort(diag(D),'descend');
            dictionary = (E(:,ind(1:numFilter)))';  
    end

    rfZCADIC{ix_rf}.M = M;
    rfZCADIC{ix_rf}.P = P;
    rfZCADIC{ix_rf}.dictionary = dictionary;
end

%%% save filter
% save(getFilterSaveName(dataset,params),'rfZCADIC');

    
    
    
    
    
    