function T = read_hdr_nortek(filename)
%
% read_hdr_nortek                  reads NORTEK ADCP header files
%==========================================================================
%
% USAGE:
%  T = read_hdr_nortek(filename)
%
% DESCRIPTION:
%  This script gets the useful info from a nortek *.hdr text file
%
% EXAMPLE CALL:
%
%  T_hdr = read_hdr_nortek('NYH33b01.hdr')
%
% INPUT:
%  filename  = name of a Nortek *.hdr file
%
% OUTPUT:
%  T  =  a matlab table variable containing the extracted info.
%
% USES:
%  no other functions needed
%
% AUTHOR:
%  Lorraine Heilman (NOAA CO-OPS)
%
% VERSION NUMBER: 0.1
% Version date: 12/03/2020
%
%==========================================================================


% initialize table elements
numinit = nan;
cellinit = "";
tinit = NaT;

Salinity = numinit;    % salinity - Salinity
CoordSys = cellinit;    % coordinate transform - Coordinate System
Blank = numinit;    % blank after transmit - Blanking distance
nBins = numinit;    % # depth cells - Number of cells
AvgInt = numinit;    % pings per ens - Average interval
BinSize = numinit;    % depth cell size - Cell size
PowerLev = cellinit; % power level - Power level
ProfInt = cellinit;  % Profile interval
nBeams = numinit;
DepName = cellinit; % Deployment
FirstMeas = tinit;
LastMeas = tinit;


fid = fopen(filename);

for ii = 1:5
    aa=fgetl(fid);
end

FirstMeas = datetime(aa(39:end),'InputFormat','MM/dd/uuuu hh:mm:ss aa');
aa=fgetl(fid);
LastMeas = datetime(aa(39:end),'InputFormat','MM/dd/uuuu hh:mm:ss aa');
aa=fgetl(fid);
aa=fgetl(fid);
aa=fgetl(fid);

jj=0;
while ~isempty(aa)
    aa=fgetl(fid);
    jj=jj+1;  % counter here only for purposes of error checking
    if length(aa)>=39
        % do a bunch of checks here to fill in all the fields
        field = aa(39:end);
        numb = find(isstrprop(field,'digit'));
        val = str2num(field(min(numb):max(numb)));
        strfield = string(field);
        
        
        if aa(1:16) == 'Profile interval' ProfInt = val;  end
        
        if aa(1:15) == 'Number of cells' nBins = val;  end
        if aa(1:9) == 'Cell size' BinSize = val; end
        if aa(1:16) == 'Average interval' AvgInt = val;  end
        if aa(1:8) == 'Blanking' Blank = val; end
        
        if aa(1:10) == 'Powerlevel' PowerLev = strfield; end
        if aa(1:10) == 'Coordinate' CoordSys = strfield;  end
        if aa(1:11) == 'Sound speed' SoundSpeedType = strfield;  end
        if aa(1:8) == 'Salinity' Salinity = val; end

        if aa(1:15) == 'Number of beams' 
            nBeams = val;  
        end
        if aa(1:15) == 'Deployment name' DepName = strfield; end
        
       
    end
end
fclose(fid);

% make a table of the info and save to a file
T = table(DepName, FirstMeas, LastMeas, ProfInt, AvgInt, nBins, BinSize, Blank, nBeams, CoordSys, Salinity, PowerLev );


end