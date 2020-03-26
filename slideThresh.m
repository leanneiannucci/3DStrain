function [x, y] = slideThresh(photo)

sThresh = photo;
FigH = figure('Position', [ 0 0 800 700 ]);
axes1 = axes('Position', [.2 .05 .6 .6]);
imshow(sThresh, 'Parent', axes1);
uicontrol('style', 'pushbutton', 'string', 'Done', 'CallBack', @buttonPushed);
uicontrol('style', 'text','position', [343 600 100 80], 'String', 'Upper Threshold')
uicontrol('style', 'text','position', [343 500 100 80], 'String', 'Lower Threshold')
TextH = uicontrol('style','text',...
    'position',[370 625 40 15]);
SliderH = uicontrol('style','slider','Value', 255, 'position',[25 595 750 20],...
    'min', 0, 'max', 255);
TextD = uicontrol('style','text',...
    'position',[370 525 40 15]);
SliderD = uicontrol('style','slider','Value', 0, 'position',[25 495 750 20],...
    'min', 0, 'max', 255);
addlistener(SliderH, 'Value', 'PostSet', @callbackfn);
addlistener(SliderD, 'Value', 'PostSet', @callbackfn1);
movegui(FigH, 'center')
num1 = 255;
num2 = 0;


    function callbackfn(source, eventdata)
        num1          = get(eventdata.AffectedObject, 'Value');
        TextH.String = num2str(num1);
        sNew  = ((sThresh <= num1) & (sThresh >= num2));
        imshow(sNew, 'Parent', axes1);
    end

    function callbackfn1(source,eventdata)
        num2          = get(eventdata.AffectedObject, 'Value');
        TextD.String = num2str(num2);
        sNew  = ((sThresh <= num1) & (sThresh >= num2));
        imshow(sNew, 'Parent', axes1);
    end

    function buttonPushed(source, eventdata) 
        x = get(SliderH, 'Value');
        y = get(SliderD, 'Value');
        close(FigH);
        return
    end

uiwait





end
      





    