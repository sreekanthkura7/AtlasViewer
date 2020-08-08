function hbconc = getHbConc(hbconc, dirname, pialsurf, probe, group)

if isempty(hbconc)
    return;
end

if iscell(dirname)
    for ii=1:length(dirname)
        hbconc = getHbConc(hbconc, dirname{ii}, pialsurf, probe);
        if ~hbconc.isempty(hbconc)
            return;
        end
    end
    return;
end

if isempty(dirname)
    return;
end

if dirname(end)~='/' && dirname(end)~='\'
    dirname(end+1)='/';
end

hbconc.mesh = pialsurf.mesh;

% Check if there's group acquisition data to load
currElem = LoadCurrElem(group, hbconc.iSubj);
if ~isempty(currElem) && ~currElem.IsEmpty()
    hbconc.HbConcRaw = currElem.GetDcAvg();
    hbconc.tHRF      = currElem.GetTHRF();
end

% If there's subject data 

if ~isempty(hbconc.HbConcRaw)
    if ~isempty(probe.ml) & ~isempty(probe.optpos_reg)
        enableHbConcGen(hbconc, 'on');
        if ishandles(hbconc.handles.HbO) | ishandles(hbconc.handles.HbR)
            enableHbConcDisplay(hbconc, 'on');
        else
            enableHbConcDisplay(hbconc, 'off');
        end
    else
        enableHbConcGen(hbconc, 'off');
        enableHbConcDisplay(hbconc, 'off');
    end
else
    enableHbConcGen(hbconc, 'off');
    enableHbConcDisplay(hbconc, 'off');    
end

if ~hbconc.isempty(hbconc)
    hbconc.pathname = dirname;
end

if length(hbconc.tHRF) >  1
    hbconc.config.tRangeMin = hbconc.tHRF(1);
    hbconc.config.tRangeMax = hbconc.tHRF(end);
end