function [compType, slashDir] = uiComputerType
 ButtonName3=questdlg('What type of computer are you using?','Your Response?','Mac','PC','Cancel','Mac');
    switch ButtonName3
        case 'Mac'
            compType = 'Mac';
            slashDir = '/';
        case 'PC'
            compType = 'PC';
            slashDir = '\';
     end
end

