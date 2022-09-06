
function output = To0255(input)
    output = zeros(size(input,1),size(input,2));
    for ii = 1:size(input,2)
        im = input(:,ii);
        output(:,ii) = (im-min(im(:)))/(max(im(:)) - min(im(:)))*255;
    end
end
