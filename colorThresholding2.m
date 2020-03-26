%% this code is designed to take in an already split 3d strain video, and
% import the first frame into a color thresholder. the user then thresholds
% the image and the thresholds are saved as variables to do the rest of the
% video. from there the user can select the beads that will be tracked
% through the frames of the video, it will track them, and then they will
% be converted to 3d coordinates based on the settings of the camera.

% created on march 11, 2019
% last edited on march 16, 2019
% leanne iannucci

%%
clc
clearvars

threshMore = 1;

while threshMore == 1

%% ask user if this is going to be a video or an image
        answer = questdlg('What are you inputting?', ...
        'Threshold Me', ...
        'Image','Video','Cancel','Cancel');
        % Handle response
            switch answer
                case 'Image'
                    type = 1;
                case 'Video'
                    type = 0;
                case 'Cancel'
                    error('User ended thresholding');
            end


%% load video

%get path and name of left video
leftVariable = zeros(720,1280,3);

if type == 0
    [leftName, leftPath] = uigetfile('*.AVI');
    cd(leftPath)
    % pull all frames of video into variable
        vidreadLeft = VideoReader(leftName);
            count = 0;
            while hasFrame(vidreadLeft)
                count = count+1;
                leftVariable(:,:,:,count) = readFrame(vidreadLeft);
            end
else
    [leftName, leftPath] = uigetfile('*.jpg');
    cd(leftPath)
    leftVariable = imread(leftName);
end

cd(leftPath);
%%


%% pull first frame from video

leftFirst = leftVariable(:,:,:,300);
%leftYCBCR = rgb2ycbcr(leftFirst);
leftYCBCR = leftFirst; 



%% threshold Y colorspace

tempY = double(leftYCBCR(:,:,1));
upLimY = 255;
downLimY = 0;

userHappy = 0;

while userHappy == 0

    %show current state of image
        imshow(tempY/255)
    %have user threshold it
        prompt = {'Upper Threshold:', 'Lower Threshold:'};
        title = 'Y Thresholding';
        dim = [1 10];
        definput = {num2str(upLimY), num2str(downLimY)};
        strs = inputdlg(prompt,title, dim, definput);
    % convert limits to numbers
        upLimY = str2num(strs{1,1});
        downLimY = str2num(strs{2,1});
    % close imshow
        close all
    % threshold current image
        tempY1 = (tempY > downLimY);
        tempY2 = (tempY < upLimY);
        maskY = tempY1.*tempY2;
    % show thresholded image
        testMeY = (double(maskY).*double(tempY));
        imshow(testMeY/255);
    %ask user if they are happy
        answer = questdlg('Thresholding Okay?', ...
        'Happy Check', ...
        'Yes','No','Cancel','No');
        % Handle response
            switch answer
                case 'Yes'
                    userHappy = 1;
                case 'No'
                    userHappy = 0;
                case 'Cancel'
                    error('User ended thresholding');
            end
    % check for end of while loop
    
end

close all

%% threshold CB colorspace

tempCB = double(leftYCBCR(:,:,2));
upLimCB = 255;
downLimCB = 0;

userHappy = 0;

while userHappy == 0

    %show current state of image
        imshow(tempCB/255)
    %have user threshold it
        prompt = {'Upper Threshold:', 'Lower Threshold:'};
        title = 'Y Thresholding';
        dim = [1 10];
        definput = {num2str(upLimCB), num2str(downLimCB)};
        strs = inputdlg(prompt,title, dim, definput);
    % convert limits to numbers
        upLimCB = str2num(strs{1,1});
        downLimCB = str2num(strs{2,1});
    % close imshow
        close all
    % threshold current image
        tempCB1 = (tempCB > downLimCB);
        tempCB2 = (tempCB < upLimCB);
        maskCB = tempCB1.*tempCB2;
    % show thresholded image
        testMeCB = (double(maskCB).*double(tempCB));
        imshow(testMeCB/255);
    %ask user if they are happy
        answer = questdlg('Thresholding Okay?', ...
        'Happy Check', ...
        'Yes','No','Cancel','No');
        % Handle response
            switch answer
                case 'Yes'
                    userHappy = 1;
                case 'No'
                    userHappy = 0;
                case 'Cancel'
                    error('User ended thresholding');
            end
    % check for end of while loop
    
end

close all
       
%% threshold CR colorspace

tempCR = double(leftYCBCR(:,:,3));
upLimCR = 255;
downLimCR = 0;

userHappy = 0;

while userHappy == 0

    %show current state of image
        imshow(tempCR/255)
    %have user threshold it
        prompt = {'Upper Threshold:', 'Lower Threshold:'};
        title = 'Y Thresholding';
        dim = [1 10];
        definput = {num2str(upLimCR), num2str(downLimCR)};
        strs = inputdlg(prompt,title, dim, definput);
    % convert limits to numbers
        upLimCR = str2num(strs{1,1});
        downLimCR = str2num(strs{2,1});
    % close imshow
        close all
    % threshold current image
        tempCR1 = (tempCR > downLimCR);
        tempCR2 = (tempCR < upLimCR);
        maskCR = tempCR1.*tempCR2;
    % show thresholded image
        testMeCR = (double(maskCR).*double(tempCR));
        imshow(testMeCR/255);
    %ask user if they are happy
        answer = questdlg('Thresholding Okay?', ...
        'Happy Check', ...
        'Yes','No','Cancel','No');
        % Handle response
            switch answer
                case 'Yes'
                    userHappy = 1;
                case 'No'
                    userHappy = 0;
                case 'Cancel'
                    error('User ended thresholding');
            end
    % check for end of while loop
    
end

close all

clear leftYCBCBR maskCB maskCR maskY tempCB tempCB1 tempCB2 tempCR tempCR1 tempCR2 tempY tempY1 tempY2 testMeCB testMeCR testMeY
%% pull out values for thresholding

threshLeft = zeros(size(leftVariable,1), size(leftVariable,2), size(leftVariable,3), size(leftVariable,4), 'uint8');
c = waitbar(0, 'Thresholding All Frames');
for k = 1:size(leftVariable,4)
    for i = 1:size(leftVariable, 1)
        for j = 1:size(leftVariable,2)
            if ((leftVariable(i,j,1,k) >= downLimY) && (leftVariable(i,j,1,k) <= upLimY) && ...
                (leftVariable(i,j,2,k) > downLimCB) && (leftVariable(i,j,2,k) < upLimCB) && ... 
                (leftVariable(i,j,3,k) > downLimCR) && (leftVariable(i,j,3,k) < upLimCR))
                threshLeft(i,j,:,k) = leftVariable(i,j,:,k);
            else
                threshLeft(i,j,:,k) = 1;
            end
        end
    end
    waitbar(k/size(leftVariable,4),c)
end

close all

%% save thresholded video here

if type == 0

    v = VideoWriter(strcat(leftName(1:(length(leftName)-4)), 'thresh.AVI'));
    open(v);

    for i = 1:size(threshLeft,4)
        writeVideo(v,threshLeft(:,:,:,i));
    end

    close(v);
    
else
    imwrite(threshLeft, strcat(leftName(1:(length(leftName)-4)), 'thresh.TIFF'));
end


%% check big while loop

        answer = questdlg('Thresholding anything else?', ...
        'Overall Check', ...
        'Yes','No','Cancel','No');
        % Handle response
            switch answer
                case 'Yes'
                    threshMore = 1;
                case 'No'
                    threshMore = 0;
                case 'Cancel'
                    error('User ended code');
            end

end
