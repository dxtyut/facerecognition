function savename = getFilterSaveName(dataset,params)

    dicmethod = params.dicmethod;
    rfSize = params.rfSize;
    numFilter= params.numFilter;
                    
    savename =fullfile('filtersaved',dataset,...
                        sprintf('dic(%s)_rf(%s)_K(%s).mat',dicmethod,multiCombine(rfSize),multiCombine(numFilter)));
    
    if ~isfolder(fullfile('filtersaved',dataset))
        mkdir(fullfile('filtersaved',dataset));
    end
end





function aaaa = multiCombine(in)
    if length(in)==7
        aaaa = sprintf('%d-%d-%d-%d-%d-%d-%d',in(1),in(2),in(3),in(4),in(5),in(6),in(7));
    end
    if length(in)==6
        aaaa = sprintf('%d-%d-%d-%d-%d-%d',in(1),in(2),in(3),in(4),in(5),in(6));
    end
    if length(in)==5
        aaaa = sprintf('%d-%d-%d-%d-%d',in(1),in(2),in(3),in(4),in(5));
    end
    if length(in)==4
        aaaa = sprintf('%d-%d-%d-%d',in(1),in(2),in(3),in(4));
    end
    if length(in)==3
        aaaa = sprintf('%d-%d-%d',in(1),in(2),in(3));
    end
    if length(in)==2
        aaaa = sprintf('%d-%d',in(1),in(2));
    end
    if length(in)==1
        aaaa = sprintf('%d',in(1));
    end
end


    
    