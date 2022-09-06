function [fa,fb,fc,dup1,dup2,CDTrain] = processFERETData()

    load(fullfile('image','FERET_crop_database.mat'));
    
    fa.data=To0255(fa_150X90);
    fa.label = fa_label;

    fb.data=To0255(fb_150X90);
    fb.label = fb_label;
    
    fc.data=To0255(fc_150X90);
    fc.label = fc_label;
    
    dup1.data=To0255(dup1_150X90);
    dup1.label = dup1_label;
    
    dup2.data=To0255(dup2_150X90);
    dup2.label = dup2_label;
    
    CDTrain.data=To0255(CDTrain_150X90); 
