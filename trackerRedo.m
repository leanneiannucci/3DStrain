function i = trackerRedo(trackMe)

video = trackMe;
FigH = figure('Position', [ 0 0 800 700 ]);
axes1 = axes('Position', [0 0 1 1]);
imshow(video(:,:,:,1), 'Parent', axes1);
uicontrol('style', 'pushbutton', 'string', 'Done', 'CallBack', @buttonPushed);
uicontrol('style', 'text','position', [343 600 100 80], 'String', 'Select what frame you want to start redoing tracking at.')

TextH = uicontrol('style','text',...
    'position',[370 625 40 15]);
SliderH = uicontrol('style','slider','Value', 1, 'position',[25 595 750 20],...
    'min', 1, 'max', size(video,4));

addlistener(SliderH, 'Value', 'PostSet', @callbackfn);
movegui(FigH, 'center')
num2 = size(video,4);


    function callbackfn(source, eventdata)
        num2          = round(get(eventdata.AffectedObject, 'Value'));
        TextH.String = num2str(num2);
        sNew  = video(:,:,:,num2);
        imshow(sNew, 'Parent', axes1);
    end


    function buttonPushed(source, eventdata) 
        i = round(get(SliderH, 'Value'));
        close(FigH);
        return
    end

uiwait





end
      





    