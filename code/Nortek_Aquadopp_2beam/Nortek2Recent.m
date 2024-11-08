function [SENall, echoall, vall] = Nortek2Recent(fileprefixes, outfileprefix, SL)

%%              Nortek File Conversion Script

%This script is used to convert Nortek ASCII/txt files to a loadable
%format(recent.dat) file. This will allow data to be loaded into CO-OPS
%database. After loading this file, that file is converted to PUFFF format
%and later ingested into CO-OPS database.

%The existing Nortek ASCII files consist of the following:
%  - .a1, .a2 - Echo Intensities up to the number of beams of the instrument
%  - .v1, .v2 - Current velocities measured per beam of the instrument
%  - .hdr - Header information regarding instrument/deployment metadata
%  - .ssl - File that lists the initial/final deployments
%  - .sen - Lists measurement header metadata (eg. times of measurement
%   per data ensemble)

%Prior to use, the initial data files need to be run through Nortek
%software to be converted into the raw ASCII data files. Initial data files
%are typically in  a format with an extension similar to .wpr, .prf, etc.
%This script simply loads data from those files and reformats them into a
%file that can be loaded into the database.

%NOTE: This script must be placed in the directory where all ASCII files
%for a specific station are located. The data files must all have an
%identical preceding extension. The output data file from this script will
%have the same prefix as the other files (filekey.dat).
%% User Input
%
% User Input - File Key if not supplied in the finction call
if isempty(fileprefixes)
    fileprefixes=input('What is the file prefix used for all the files? ','s');
    fileprefixes = {fileprefixes};
elseif ischar(fileprefixes)
    fileprefixes = {fileprefixes};
end

if nargin == 1
    outfileprefix = input('What is the file prefix to use for the output *.dat file? ','s');
end

for fcount = 1:length(fileprefixes)
    filekey = fileprefixes{fcount};
    fprintf('\nWorking on files: %s', filekey)
    %% File IDs
    %Initialize Preliminary File Read Variables
    FIDhdr=strcat(filekey,'.hdr');
    FIDsen=strcat(filekey,'.sen');
    FIDssl=strcat(filekey,'.ssl');
    
    FIDdat=strcat(outfileprefix,'.dat');
    
    % read from the header file to get number of bins and number of beams
    % note that for 2 beam nortek aquadopps, there are still 3 beams/vel files\
    
    HDRinfo = read_hdr_nortek(FIDhdr);
    
    nbeams = HDRinfo.nBeams;
    nbins = HDRinfo.nBins;
    
    
    %% Read Files and Store Data
    
    % SEN file contains header info for each ensemble
    SEN=load(FIDsen);
    SENsize = size(SEN);
    
    clear a v FIDecho FIDvel
    
    for  ii = 1:nbeams
        % create names for echo and velocity files
        
        FIDecho(ii,:) = [filekey '.a' num2str(ii)];
        FIDvel(ii,:) = [filekey '.v' num2str(ii)];
        
        % read in the files and add to variables
        tmpecho = load(FIDecho(ii,:));
        tmpvel = load(FIDvel(ii,:));
        a(:,:,ii) = tmpecho;
        v(:,:,ii) = tmpvel;
        
    end
    
    
    % have to add fake beams here for 2 beam instruments - this can be
    % removed when skrl is updated
    if nbeams == 2
        a(:,:,3) = tmpecho .*0 -999;
        v(:,:,3) = tmpvel .*0 -999;

    end

    if nbeams ==2 | SL 
        % THIS IS A CRAZYTOWN FIX HERE and should be addressed somewhere else
        % sometime later. X and Y order is swapped in the nortek text files and
        % needs to be switched back in order to use the skrl code.  The -90
        % degrees also needs to be adjusted in the heading angle.  i.e. heading
        % angle should be the direction across the current, not along it.
        % Lorraine Heilman 12/15/2020
        
        tmpv = v;
        tmpa = a;
        
        tmpa(:,:,1) = a(:,:,2);
        tmpa(:,:,2) = a(:,:,1);

        tmpv(:,:,1) = v(:,:,2);
        tmpv(:,:,2) = v(:,:,1);

        v = tmpv;
        a = tmpa;
      
    end
    
    %    create data arrays to pass back with the function
    
    if ~exist('SENall')
        SENall = SEN;
        echoall = a;
        vall = v;
    else
        SENall = [SENall;SEN];
        echoall = [echoall; a];
        vall = [vall ; v];
    end
    
    %% Creating a .dat file for load
    %Note: This will always overwrite the same file and will follow the
    %name format established by the existing files covered by the filekey
    %variable. The output file will be a text file FileName.dat that
    %adds all stored data files into one file.
    
    % Open FileID with write permissions
    if fcount == 1
        fid = fopen(FIDdat, 'w+');  %opens and overwrites existing info
    else
        fid = fopen(FIDdat, 'a+');  %opens and appends
    end
    
    %File Open check
    if fid == -1
        disp(['Error, cannot open file ' FIDdat 'for writing'])
    else
    end
    
    %% Write the data file - Data file writen as filekey.dat
    
    % see section below for comments on file format
    
    % create format statements
    fmtv = ' ';
    fmta = '';
    for ii = 1:3  %  this should be nbeams, but hardcoding for now to avoid insanity
        fmtv = [fmtv ' %7.3f'];
        fmta = [fmta ' %5.1f'];
    end
    fmtbin = [fmtv fmta '\n'];
    fmtbinend = [fmtbin '\n'];  % for last bin adds a second newline to make a space in the file
    
    for ii = 1:1:SENsize(1)
        
        % Lines 1&2 - Recent.Dat and Header Info
        fprintf(fid,'Recent.Dat\n%02d %02d %04d %02d %02d %02d %08d %08d  %2.1f %04.1f %03.1f  %02.1f  %01.1f   %02.3f  %02.2f     %01d     %01d\n',...
            SEN(ii,1:17));
        % Lines 3 to nbins - lines for each bin data for this time step
        for jj = 1:nbins
            if jj<nbins
                fprintf(fid,fmtbin,squeeze(v(ii,jj,:)),squeeze(a(ii,jj,:)));
            elseif jj==nbins
                fprintf(fid,fmtbinend,squeeze(v(ii,jj,:)),squeeze(a(ii,jj,:)));
            else
                disp('Error - Bin Number exceeded the max bins')
            end
        end
        
    end
    
    
    fclose('all');
    fprintf('\nCompleted files: %s', filekey)
end

fprintf('\nConversion complete. %s created. Check the file prior to data ingestion.', FIDdat)


%% File format info.
% Note that this may need to be changed with the change from DCS Toolkit to
% OpenDCS in FY2021
% Questions? Lorraine Heilman (lorraine.heilman@noaa.gov)

%This is the format for the Nortek data file. If there are errors with the
%ingestion file spacing, it is likely to be tied to the following lines.

%SAMPLE BELOW CORRECT SPACING FOR COMPARISON TO IDENTIFY ISSUES
%Line 1
%Recent.dat
%Line 2 - Header line:
%05 10 2016 19 39 00 00000000 10110001  12.6 1528.8 114.5  -0.2  -2.9   2.839  22.72     0     0
%Line 3 to nbins (Bin Data)
%    V1       V2      V3    A1    A2    A3
%   0.245   0.325   0.000 138.0 153.0  14.0
%   0.195   0.242   0.000 122.0 157.0  14.0
%   0.100   0.092   0.000 117.0 133.0  13.0
%   0.013  -0.065   0.000 112.0 120.0  14.0
%  -0.011  -0.164   0.000 108.0 115.0  14.0
%  -0.019  -0.270   0.000 104.0 114.0  14.0
%   0.024  -0.333   0.000  98.0 111.0  14.0
%   0.000   0.000   0.000   0.0   0.0   0.0
%   0.000   0.000   0.000   0.0   0.0   0.0
%   0.000   0.000   0.000   0.0   0.0   0.0

%Uninterrupted example - Ignore the 0 data for the additional bins

%  Recent.Dat
%12 01 2018 00 03 00 00000000 00110000  11.3 1524.8 230.6  20.0  -6.2   0.000  21.23     0     0
%   0.072  -0.141  -0.270  19.0  18.0  19.0
%  -0.098  -0.206  -0.268  19.0  18.0  19.0
%  -0.550   0.503  -0.092  19.0  18.0  19.0
%  -0.498   0.046  -0.077  19.0  18.0  19.0
%   0.124   0.047  -0.440  19.0  18.0  19.0
%   0.250   0.275  -0.192  19.0  18.0  19.0
%   0.245  -0.247  -0.345  19.0  18.0  18.0
%   0.000   0.000   0.000   0.0   0.0   0.0
%   0.000   0.000   0.000   0.0   0.0   0.0
%   0.000   0.000   0.000   0.0   0.0   0.0
%   0.000   0.000   0.000   0.0   0.0   0.0
%   0.000   0.000   0.000   0.0   0.0   0.0
%   0.000   0.000   0.000   0.0   0.0   0.0
%   0.000   0.000   0.000   0.0   0.0   0.0
%   0.000   0.000   0.000   0.0   0.0   0.0
%   0.000   0.000   0.000   0.0   0.0   0.0
%   0.000   0.000   0.000   0.0   0.0   0.0
%   0.000   0.000   0.000   0.0   0.0   0.0
%   0.000   0.000   0.000   0.0   0.0   0.0
%   0.000   0.000   0.000   0.0   0.0   0.0

%Recent.Dat
%12 01 2018 00 09 00 00000000 00110000  11.3 1524.8 230.7  20.0  -6.1   0.000  21.24     0     0
%  -0.294   0.656  -0.080  19.0  18.0  19.0
%  -0.004   0.226  -0.384  19.0  18.0  19.0
%   0.225   0.102  -0.536  19.0  18.0  19.0
%  -0.211  -0.048  -0.184  19.0  18.0  19.0
%   0.577  -0.073  -0.416  19.0  18.0  19.0
%  -0.609   0.093  -0.209  19.0  18.0  19.0
%   0.555   0.032  -0.402  19.0  18.0  19.0
%   0.000   0.000   0.000   0.0   0.0   0.0
%   0.000   0.000   0.000   0.0   0.0   0.0
%   0.000   0.000   0.000   0.0   0.0   0.0
%   0.000   0.000   0.000   0.0   0.0   0.0
%   0.000   0.000   0.000   0.0   0.0   0.0
%   0.000   0.000   0.000   0.0   0.0   0.0
%   0.000   0.000   0.000   0.0   0.0   0.0
%   0.000   0.000   0.000   0.0   0.0   0.0
%   0.000   0.000   0.000   0.0   0.0   0.0
%   0.000   0.000   0.000   0.0   0.0   0.0
%   0.000   0.000   0.000   0.0   0.0   0.0
%   0.000   0.000   0.000   0.0   0.0   0.0
%   0.000   0.000   0.000   0.0   0.0   0.0
