function [ coord ] = strain_autoCentroid_lei(video, isColorThresh)
% most recent edit 18Mar2020 to allow for user to specify if they want to
% go back to a particular frame in the redo

% added in code to mark the points as they are being clicked with ginput 

% adding in code to allow for fixing individual points

%% enter thresholding loop
    if (isColorThresh == 0)
        for i = 1:size(video,4)
            tmpvideo(:,:,i) = rgb2gray(video(:,:,:,i));
        end
    else
        for i = 1:size(video,4)
            tmpvideo(:,:,i) = video(:,:,:,i);
        end
    end
    clear video
    video = tmpvideo;
    clear tmpvideo
       [threshUp, threshDown] =  slideThresh(video(:,:,1));

%% setup variables for while loop
       satisfied = 0;  
       redo = 0;
       num = 1;
       rethresh = 0;
%% start big tracking while loop
while satisfied == 0 
    
    for i = num:size(video,3)
       
       if ((i == 1) || (redo == 1))
           
           if (redo == 1)
                   ButtonName3=questdlg('Do you want to re-threshold?','Proceed?','Yes','No','Cancel','Yes');
                switch ButtonName3
                    case 'Yes'
                        rethresh = 1;
                    case 'No'
                        rethresh = 0;
                    case 'Cancel'
                        return
                end
                
                if (rethresh == 1)
                    [threshUp, threshDown] =  slideThresh(video(:,:,i));
                end
           end
       
       
       tmp = (video(:,:,i)<=threshUp) & (video(:,:,i)>=threshDown);
       
       imshow(tmp);
       hold on;
       
       numb_markers = str2double(inputdlg('How many markers?', 'Number of Markers', [1 35]));
        M = zeros(numb_markers,2);
          
       uiwait(msgbox('Click one time on each marker you want to track','Marker Selection','modal'));
           for q = 1:numb_markers

               if q == 1
                    [Mx, My] = myginput(1, 'arrow');
                    M(q, 1) = Mx;
                    M(q, 2) = My;
                    close all;
               else 
                   imshow(tmp);
                   hold on;
                   for qq = 1:(q-1)
                        plot(M(qq,1),M(qq,2),'ro')
                        hold on;
                        labelpoints(M(qq,1),M(qq,2), num2str(qq), 'SE',0.2,1, 'FontWeight', 'bold', 'Color', 'r');
                        hold on;
                   end
                   [Mx, My] = myginput(1, 'arrow');
                   M(q, 1) = Mx;
                   M(q, 2) = My;
                   close all;

               end

           end
       
       end

     
        orgimage = video(:,:,i);
        tmp = (video(:,:,i)<=threshUp) & (video(:,:,i)>=threshDown);
        skel = tmp;
        
        %skel_fill = imfill(skel,'holes');
        %Ilabel = bwlabel(skel_fill);
        
        Ilabel = bwlabel(skel);
        clear Csize
        stat = regionprops(Ilabel,'centroid');
        CC = bwconncomp(skel);
        
        
        for k=1:numel(stat)
            
            Csize(k) = max(size(CC.PixelIdxList{k}));
            
        end
        
        
        

        imshow(orgimage,[0 max(orgimage(:))])
        title(strcat(num2str(i),' of  ',num2str(size(video,3))))
        hold on
        
        
        [S,I] = sort(Csize,2,'descend');
        
        
        for j = 1:numb_markers

            clear indx distnce
            
            if ((i == 1) || (redo == 1))
             
                for m = 1:max(size(stat))
                    
                    distnce(m) = sqrt((M(j,1)-stat(m).Centroid(1))^2 + (M(j,2)-stat(m).Centroid(2))^2);
                    
                end
                    [min_dist, indx] = min(distnce);
                    coord(i,1,j)=stat(indx).Centroid(1);
                    coord(i,2,j)=stat(indx).Centroid(2);
                    plot(coord(i,1,j),coord(i,2,j),'ro')
                    hold on;
                    labelpoints(coord(i,1,j),coord(i,2,j), num2str(j), 'SE',0.2,1, 'FontWeight', 'bold', 'Color', 'r')
                
                
            else
                
                for m = 1:max(size(stat))
                    
                    distnce(m) = sqrt((stat(m).Centroid(1)-coord(i-1,1,j))^2 + (stat(m).Centroid(2)-coord(i-1,2,j))^2);
                    
                end
                
                [min_dist, indx] = min(distnce);
                coord(i,1,j)=stat(indx).Centroid(1);
                coord(i,2,j)=stat(indx).Centroid(2);
                plot(coord(i,1,j),coord(i,2,j),'ro')
                hold on;
                labelpoints(coord(i,1,j),coord(i,2,j), num2str(j), 'SE',0.2,1, 'FontWeight', 'bold', 'Color', 'r')
                
            end
            
            
        end
        
        
            
        hold off
        set(gcf,'PaperUnits','inches','PaperPosition',[0 0 12 8]);
        save_frame_name = sprintf(strcat('tracker','_%2.i.png'),i);
        print('-dpng',save_frame_name);
        f = frame2im(getframe(gcf));
        trackMe(:,:,:,i) = f;
        clear f
        
        
        close all
        
        redo = 0;
     end
     
    ButtonName3=questdlg('Are you satisfied with tracking?','Proceed?','Yes','No, I want to adjust','Cancel','Yes');
    switch ButtonName3
        case 'Yes'
            satisfied = 1;
            
        case 'No, I want to adjust'
            satisfied = 0;
            
            % add in here a way to go back to a particular frame of
            % interest.
            
            frame = trackerRedo(trackMe);
            num = frame;
            redo = 1;
            
            
            
        case 'Cancel'
            return
    end
    
    
end

close all


