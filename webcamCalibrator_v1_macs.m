% webcamCalibrator_v1_macs

% Leanne Iannucci
% Created: 7/17/2018
% Last Modified: 3/11/20

% Created to take the ouput calibration videos of stereo camera system and 
% use it to get the internal and extrinsic parameters for later triangulation.
% It will accomplish this using the Matlab Computer Vision System toolbox.

% Major Edit Log:

%%
clc
clearvars

videoName  = 'DSCF';
videoNumber = [7343];
folderName = 'Griffin Zoom Calibration 11Mar2020';

local = '/Users/leanneiannucci/Desktop/';
%local = 'Y:\Active\Iannucci\Science\';
thisFolder = strcat(local, '3D Strain/', folderName, '/');
cd(thisFolder)
addpath(genpath(thisFolder));
%%

for grandI = 1:length(videoNumber)
%% input left and right videos
sampleName = strcat(videoName, num2str(videoNumber(grandI)));

leftVid = VideoReader(strcat(sampleName, '_L.AVI'));
count = 0;

newParentFolder = strcat(thisFolder, 'Analysis/', sampleName, '/');
mkdir(newParentFolder)
cd(newParentFolder)

leftFolder = strcat(newParentFolder, 'Left/');
mkdir(leftFolder);

while hasFrame(leftVid)
    count = count+1;
    cd(thisFolder);
    leftFile(:,:,:,count) = readFrame(leftVid);
    cd(leftFolder);
    temp = leftFile(:,:,:,count);
    imwrite(temp, strcat(sampleName, '-Left ', num2str(count), '.png'))
end

rightVid = VideoReader(strcat(sampleName, '_R.AVI'));
count = 0;

rightFolder = strcat(newParentFolder, 'Right/');
mkdir(rightFolder);

while hasFrame(rightVid)
    count = count+1;
    cd(thisFolder);
    rightFile(:,:,:,count) = readFrame(rightVid);
    cd(rightFolder);
    temp = rightFile(:,:,:,count);
    imwrite(temp, strcat(sampleName, '-Right ', num2str(count), '.png'))
end


disp('Done inputting & splitting videos')

%% load stereo calibrator app

    stereoCameraCalibrator(leftFolder, rightFolder, 7)

%% save stereo calibrator session and parameters for camera

wait = 0;

while wait == 0
ButtonName = questdlg('Are you ready to proceed?', 'Question', 'Yes', 'No', 'No');
    switch ButtonName
        case 'Yes'
            cd(strcat(strcat(thisFolder, '/Analysis/', videoName, num2str(videoNumber(grandI)), '/' )))
            cameraParamsLeft = stereoParams.CameraParameters1;
            cameraParamsRight = stereoParams.CameraParameters2;

            save(strcat('CalibrationParams-Griffin', videoName, num2str(videoNumber(grandI)), '.mat'), 'stereoParams','cameraParamsLeft', 'cameraParamsRight', 'estimationErrors')
            wait = 1;
        case 'No'
            % do nothing
    end 
end

end





