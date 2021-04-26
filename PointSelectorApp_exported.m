classdef PointSelectorApp_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure           matlab.ui.Figure
        ImageAxes          matlab.ui.control.UIAxes
        Point1Label        matlab.ui.control.Label
        Point2Label        matlab.ui.control.Label
        DropDown_2         matlab.ui.control.DropDown
        ImageAxes_2        matlab.ui.control.UIAxes
        LeftTrackerLabel   matlab.ui.control.Label
        RightTrackerLabel  matlab.ui.control.Label
        DropDown           matlab.ui.control.DropDown
        LoadButton         matlab.ui.control.Button
    end

    
    methods (Access = private)
        
        function updateimage(app,imagefile)
            
            % For corn.tif, read the second image in the file
            if strcmp(imagefile,'corn.tif')
                im = imread('corn.tif', 2);
            else
                try
                    im = imread(imagefile);
                catch ME
                    % If problem reading image, display error message
                    uialert(app.UIFigure, ME.message, 'Image Error');
                    return;
                end            
            end 
            
            % Create histograms based on number of color channels
            switch size(im,3)
                case 1
                    % Display the grayscale image
                    imagesc(app.ImageAxes,im);
                    
                    % Plot all histograms with the same data for grayscale
                    histr = histogram(app.RedAxes, im, 'FaceColor',[1 0 0],'EdgeColor', 'none');
                    histg = histogram(app.GreenAxes, im, 'FaceColor',[0 1 0],'EdgeColor', 'none');
                    histb = histogram(app.BlueAxes, im, 'FaceColor',[0 0 1],'EdgeColor', 'none');
                    
                case 3
                    % Display the truecolor image
                    imagesc(app.ImageAxes,im);
                    
                    % Plot the histograms
                    histr = histogram(app.RedAxes, im(:,:,1), 'FaceColor', [1 0 0], 'EdgeColor', 'none');
                    histg = histogram(app.GreenAxes, im(:,:,2), 'FaceColor', [0 1 0], 'EdgeColor', 'none');
                    histb = histogram(app.BlueAxes, im(:,:,3), 'FaceColor', [0 0 1], 'EdgeColor', 'none');
                    
                otherwise
                    % Error when image is not grayscale or truecolor
                    uialert(app.UIFigure, 'Image must be grayscale or truecolor.', 'Image Error');
                    return;
            end
                % Get largest bin count
                maxr = max(histr.BinCounts);
                maxg = max(histg.BinCounts);
                maxb = max(histb.BinCounts);
                maxcount = max([maxr maxg maxb]);
                
                % Set y axes limits based on largest bin count
                app.RedAxes.YLim = [0 maxcount];
                app.RedAxes.YTick = round([0 maxcount/2 maxcount], 2, 'significant');
                app.GreenAxes.YLim = [0 maxcount];
                app.GreenAxes.YTick = round([0 maxcount/2 maxcount], 2, 'significant');
                app.BlueAxes.YLim = [0 maxcount];
                app.BlueAxes.YTick = round([0 maxcount/2 maxcount], 2, 'significant');
         
        end
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)
            % Configure image axes
            app.ImageAxes.Visible = 'off';
            app.ImageAxes.Colormap = gray(256);
            axis(app.ImageAxes, 'image');
            
            % Update the image and histograms
            updateimage(app, 'peppers.png');
        end

        % Value changed function: DropDown
        function DropDownValueChanged(app, event)
            
            % Update the image and histograms
            updateimage(app, app.DropDown.Value);
        end

        % Button pushed function: LoadButton
        function LoadButtonPushed(app, event)
               
            % Display uigetfile dialog
            filterspec = {'*.jpg;*.tif;*.png;*.gif','All Image Files'};
            [f, p] = uigetfile(filterspec);
            
            % Make sure user didn't cancel uigetfile dialog
            if (ischar(p))
               fname = [p f];
               updateimage(app, fname);
            end
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.AutoResizeChildren = 'off';
            app.UIFigure.Position = [100 100 702 528];
            app.UIFigure.Name = 'Image Histograms';
            app.UIFigure.Resize = 'off';

            % Create ImageAxes
            app.ImageAxes = uiaxes(app.UIFigure);
            app.ImageAxes.XTick = [];
            app.ImageAxes.XTickLabel = {'[ ]'};
            app.ImageAxes.YTick = [];
            app.ImageAxes.Position = [13 185 332 281];

            % Create Point1Label
            app.Point1Label = uilabel(app.UIFigure);
            app.Point1Label.HorizontalAlignment = 'right';
            app.Point1Label.Position = [271 118 43 22];
            app.Point1Label.Text = 'Point 1';

            % Create DropDown
            app.DropDown = uidropdown(app.UIFigure);
            app.DropDown.Items = {};
            app.DropDown.ValueChangedFcn = createCallbackFcn(app, @DropDownValueChanged, true);
            app.DropDown.Position = [323 118 110 22];
            app.DropDown.Value = {};

            % Create LoadButton
            app.LoadButton = uibutton(app.UIFigure, 'push');
            app.LoadButton.ButtonPushedFcn = createCallbackFcn(app, @LoadButtonPushed, true);
            app.LoadButton.Position = [239 52 225 22];
            app.LoadButton.Text = 'Done!';

            % Create Point2Label
            app.Point2Label = uilabel(app.UIFigure);
            app.Point2Label.HorizontalAlignment = 'right';
            app.Point2Label.Position = [271 85 43 22];
            app.Point2Label.Text = 'Point 2';

            % Create DropDown_2
            app.DropDown_2 = uidropdown(app.UIFigure);
            app.DropDown_2.Items = {};
            app.DropDown_2.Position = [323 85 110 22];
            app.DropDown_2.Value = {};

            % Create ImageAxes_2
            app.ImageAxes_2 = uiaxes(app.UIFigure);
            app.ImageAxes_2.XTick = [];
            app.ImageAxes_2.XTickLabel = {'[ ]'};
            app.ImageAxes_2.YTick = [];
            app.ImageAxes_2.Position = [354 185 334 281];

            % Create LeftTrackerLabel
            app.LeftTrackerLabel = uilabel(app.UIFigure);
            app.LeftTrackerLabel.HorizontalAlignment = 'right';
            app.LeftTrackerLabel.Position = [144 475 69 22];
            app.LeftTrackerLabel.Text = 'Left Tracker';

            % Create RightTrackerLabel
            app.RightTrackerLabel = uilabel(app.UIFigure);
            app.RightTrackerLabel.HorizontalAlignment = 'right';
            app.RightTrackerLabel.Position = [482 475 77 22];
            app.RightTrackerLabel.Text = 'Right Tracker';

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = PointSelectorApp_exported

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            % Execute the startup function
            runStartupFcn(app, @startupFcn)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end