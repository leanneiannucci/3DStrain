function satisfied = uiYesNoButton(message)
 ButtonName3=questdlg(message,'Your Response?','Yes','No','Cancel','Yes');
     switch ButtonName3
        case 'Yes'
            satisfied = true;
        case 'No'
            satisfied = false;
     end
end

