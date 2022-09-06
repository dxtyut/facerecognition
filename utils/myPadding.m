function outimage = myPadding(InImg,PatchSize)
    %%%% zeropadding
    mag = (PatchSize-1)/2;
    
    [ImgX, ImgY, NumChls] = size(InImg);
    outimage = zeros(ImgX+PatchSize-1,ImgY+PatchSize-1, NumChls);
    outimage((mag+1):end-mag,(mag+1):end-mag,:) = InImg;  