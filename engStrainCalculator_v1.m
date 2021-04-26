%% engStrainCalculator_v1
% process strain (2D and 3D) for processed videos
% Created by Leanne Iannucci
% dependent functions:
% uiYesNoButton
% uiComputerType
clc; clearvars;
[compType, slash] = uiComputerType;

%% pre1. start big while loop
bigSatisfied = 0;
while ~bigSatisfied
    %% 1. have user select what files are going to be processed
    % this has to be done one at a time 

    disp('Please select the .mat file that contains the tracked points');
    [file, path] = uigetfile('MultiSelect', 'off');
    addpath(path);
    cd(path);
    load(file);

    %% 2. check to see if 3d points exist
    dimension = 2;
    if exist('totalPoints', 'var')
       dimension = 3;
    end

    %% 3. have the user pull up the left and right images if they want

    message = 'Would you like to view the tracked images?';
    result = uiYesNoButton(message); % result = 1 is YES

    if result
        if dimension == 3
            leftPath = strcat(path, 'Left Tracking', slash);
            rightPath = strcat(path, 'Right Tracking', slash);
            cd(leftPath);
            leftTrackImg = imread('tracker_ 1.png');
            cd(rightPath);
            rightTrackImg = imread('tracker_ 1.png');
            cd(path)
            s = figure;
            set(s, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
            subplot(1,2,1);
            imshow(leftTrackImg, 'InitialMagnification',200);
            hold on;
            subplot(1,2,2);
            imshow(rightTrackImg, 'InitialMagnification',200);
        else
            leftPath = strcat(path, 'Tracking', slash);
            cd(leftPath);
            leftTrackImg = imread('tracker_ 1.png');
            cd(path)
            s = figure;
            imshow(leftTrackImg, 'InitialMagnification',200);
        end
    end

    %% pre4. start while loop
    satisfied = 0;
    while ~satisfied
        %% 4. ask the user what two points they want strain calculated between

        prompt = {'First Point:','Second Point:'};
        dlgtitle = 'Calculate Strain Between:';
        dims = [1 35];
        answer = inputdlg(prompt,dlgtitle,dims);

        %% 5. calculate 2d strain between those for all frames
        if dimension == 2
            % fill in another time if you need this application
        else
            distR = zeros(size(rightTracker,1),1);
            distL = zeros(size(rightTracker,1),1);
            strR = zeros(size(rightTracker,1),1);
            strL = zeros(size(rightTracker,1),1);
            for i = 1:size(rightTracker, 1)
                x2r = rightTracker(i,1,str2double(answer{1,1}));
                x1r = rightTracker(i,1,str2double(answer{2,1}));
                y2r = rightTracker(i,2,str2double(answer{1,1}));
                y1r = rightTracker(i,2,str2double(answer{2,1}));
                x2l = leftTracker(i,1,str2double(answer{1,1}));
                x1l = leftTracker(i,1,str2double(answer{2,1}));
                y2l = leftTracker(i,2,str2double(answer{1,1}));
                y1l = leftTracker(i,2,str2double(answer{2,1}));
                distR(i) = sqrt((x2r-x1r)^2+(y2r-y1r)^2);
                distL(i) = sqrt((x2l-x1l)^2+(y2l-y1l)^2);
                if i > 1
                    strL(i) = abs(distL(i)-distL(1))/distL(1);
                    strR(i) = abs(distR(i)-distR(1))/distR(1);
                end
                clear x2r x1r y2r y1r x2l x1l y2l y1l
            end
        end

        %% 6. calculate 3d strain between those for all frames IF 3D

        if dimension == 3
            dist3 = zeros(size(rightTracker,1),1);
            str3 = zeros(size(rightTracker,1),1);

           for i = 1:size(rightTracker, 1)
                x2 = totalPoints{(str2double(answer{1,1})),i}(1);
                x1 = totalPoints{(str2double(answer{2,1})),i}(1);
                y2 = totalPoints{(str2double(answer{1,1})),i}(2);
                y1 = totalPoints{(str2double(answer{2,1})),i}(2);
                z2 = totalPoints{(str2double(answer{1,1})),i}(3);
                z1 = totalPoints{(str2double(answer{2,1})),i}(3);

                dist3(i) = sqrt((x2-x1)^2+(y2-y1)^2+(z2-z1)^2);
                if i > 1
                    str3(i) = abs(dist3(i)-dist3(1))/dist3(1);
                end
                clear x2 x1 y2 y1 z2 z1
            end


        end

        %% 7. store in structure

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%Distances%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % left
        calculatedDistancesLeftNew(1,1) = str2double(answer{1,1});
        calculatedDistancesLeftNew(2,1) = str2double(answer{2,1});
        calculatedDistancesLeftNew = vertcat(calculatedDistancesLeftNew, distL);

        if exist('calculatedDistancesLeft', 'var')
            calculatedDistancesLeft = horzcat(calculatedDistancesLeft, calculatedDistancesLeftNew);
        else
            calculatedDistancesLeft = calculatedDistancesLeftNew;
        end

        clear calculatedDistancesLeftNew

        %right
        calculatedDistancesRightNew(1,1) = str2double(answer{1,1});
        calculatedDistancesRightNew(2,1) = str2double(answer{2,1});
        calculatedDistancesRightNew = vertcat(calculatedDistancesRightNew, distR);

        if exist('calculatedDistancesRight', 'var')
            calculatedDistancesRight = horzcat(calculatedDistancesRight, calculatedDistancesRightNew);
        else
            calculatedDistancesRight = calculatedDistancesRightNew;
        end

        clear calculatedDistancesRightNew

        %3d
        calculatedDistances3DNew(1,1) = str2double(answer{1,1});
        calculatedDistances3DNew(2,1) = str2double(answer{2,1});
        calculatedDistances3DNew = vertcat(calculatedDistances3DNew, dist3);

        if exist('calculatedDistances3D', 'var')
            calculatedDistances3D = horzcat(calculatedDistances3D, calculatedDistances3DNew);
        else
            calculatedDistances3D = calculatedDistances3DNew;
        end

        clear calculatedDistances3DNew

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Strain%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        % left
        calculatedStrainsLeftNew(1,1) = str2double(answer{1,1});
        calculatedStrainsLeftNew(2,1) = str2double(answer{2,1});
        calculatedStrainsLeftNew = vertcat(calculatedStrainsLeftNew, strL);

        if exist('calculatedStrainsLeft', 'var')
            calculatedStrainsLeft = horzcat(calculatedStrainsLeft, calculatedStrainsLeftNew);
        else
            calculatedStrainsLeft = calculatedStrainsLeftNew;
        end

        clear calculatedStrainsLeftNew

        %right
        calculatedStrainsRightNew(1,1) = str2double(answer{1,1});
        calculatedStrainsRightNew(2,1) = str2double(answer{2,1});
        calculatedStrainsRightNew = vertcat(calculatedStrainsRightNew, strR);

        if exist('calculatedStrainsRight', 'var')
            calculatedStrainsRight = horzcat(calculatedStrainsRight, calculatedStrainsRightNew);
        else
            calculatedStrainsRight = calculatedStrainsRightNew;
        end

        clear calculatedStrainsRightNew

        %3d
        calculatedStrains3DNew(1,1) = str2double(answer{1,1});
        calculatedStrains3DNew(2,1) = str2double(answer{2,1});
        calculatedStrains3DNew = vertcat(calculatedStrains3DNew, str3);

        if exist('calculatedStrains3D', 'var')
            calculatedStrains3D = horzcat(calculatedStrains3D, calculatedStrains3DNew);
        else
            calculatedStrains3D = calculatedStrains3DNew;
        end

        clear calculatedStrains3DNew

    %% 8. check to see if user has any more point pairs to analyze between
    message = 'Do you have more pairs you want to analyze for this file?';
    morePairs = uiYesNoButton(message); % result = 1 is YES
    satisfied = ~morePairs;

    end
%% 8. append distance and strain matrices to data file 
close all
save(strcat(erase(file, '.mat'), '-strainTracked.mat'), 'leftTracker', 'rightTracker', 'totalPoints', 'calculatedStrains3D',  'calculatedStrainsRight',  'calculatedStrainsLeft',  'calculatedDistances3D',  'calculatedDistancesRight',  'calculatedDistancesLeft');

%% 9. ask user if they want to save data in an excel sheet
    message = 'Do you want to save data into excel sheets?';
    resultCSV = uiYesNoButton(message); % result = 1 is YES
    if resultCSV 
        writematrix([calculatedStrainsLeft], strcat(erase(file, '.mat'), '-calculatedStrains-L-R-3D', '.xlsx'), 'Sheet', 'Left');
        writematrix([calculatedStrainsRight], strcat(erase(file, '.mat'), '-calculatedStrains-L-R-3D', '.xlsx'), 'Sheet', 'Right');
        writematrix([calculatedStrains3D], strcat(erase(file, '.mat'), '-calculatedStrains-L-R-3D', '.xlsx'), 'Sheet', '3D');

        writematrix([calculatedDistancesLeft], strcat(erase(file, '.mat'), '-calculatedDistances-L-R-3D', '.xlsx'), 'Sheet', 'Left');
        writematrix([calculatedDistancesRight], strcat(erase(file, '.mat'), '-calculatedDistances-L-R-3D', '.xlsx'), 'Sheet', 'Right');
        writematrix([calculatedDistances3D], strcat(erase(file, '.mat'), '-calculatedDistances-L-R-3D', '.xlsx'), 'Sheet', '3D');

    end
%% 10. check to see if user has more files

message = 'Do you have any more files to analyze?';
moreFiles = uiYesNoButton(message); % result = 1 is YES
bigSatisfied = ~moreFiles;

clearvars -except bigSatisfied compType slash

end
