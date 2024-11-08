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


%% File IDs and User Input
%
%User Input - File Key

nbins = 20;
nbeams = 3;

filekey = 'SAV0701'
%filekey=input('What is the file prefix used for all the files? ','s');

%Initialize Preliminary File Read Variables
FIDhdr=strcat(filekey,'.hdr');
FIDsen=strcat(filekey,'.sen');
FIDssl=strcat(filekey,'.ssl');
FIDdat=strcat(filekey,'.dat');

%Stuff that should be automated from the .hdr file eventually - 
%User Input - Number of beams, Number of bins
%

%nbeams=input('How many beams does the instrument have? ');
%nbins=input('Number of bins? ');
% Setup dependent Files

%Echo Intensity File Names

    %Make Empty String Arrays and Transpose
    FIDecho=strings(1,nbeams);
    FIDecho=FIDecho';

    %Create the a1, a2, a3, etc file names to reference later
    for i=1:1:nbeams
        FIDecho(i)=sprintf('%s.%s%d',filekey,'a',i);
    end


%Velocity File Names
   %Make Empty String Arrays and Transpose
    FIDvel=strings(1,nbeams);
    FIDvel=FIDvel';
    
   %Create the v1, v2, v3 file names to reference later
    for i=1:1:nbeams
        FIDvel(i)=sprintf('%s.%s%d',filekey,'v',i);
    end


%% Read Files and Store Data

%
                %FscanF method - not needed
                   % fid=fopen(FIDsen, 'r')
                   % if fid == -1
                    %    disp('Error, check file name')
                   % else
                   % end
                   %  fscanf - works but not needed
                   %  SEN=fscanf(fileID, '%f', [17 inf])
                   %  SEN=SEN'
                   %fclose(fid)
                   %
                   %for i=1:1:nbeams;
                   %

%Data Load
%Use load - works easily for delimited files
    %SEN file
    SEN=load(FIDsen);

%Initialize Variables (echo intensities and velocities)
%Currently this works for 1-3 beams. Adjust the script with for
%loops or add additional if statements as necessary

if nbeams==1
    a1=[nbins length(SEN)]
    v1=[nbins length(SEN)];
elseif nbeams==2
    a1=[nbins length(SEN)];
    a2=[nbins length(SEN)];
    v1=[nbins length(SEN)];
    v2=[nbins length(SEN)];
elseif nbeams==3
    a1=[nbins length(SEN)];
    a2=[nbins length(SEN)];
    a3=[nbins length(SEN)];
    v1=[nbins length(SEN)];
    v2=[nbins length(SEN)];
    v3=[nbins length(SEN)];
                %elseif nbeams==4
                   % a1=[nbins length(SEN)];
                   % a2=[nbins length(SEN)];
                    %a3=[nbins length(SEN)];
                    %a4=[nbins length(SEN)];
                    %v1=[nbins length(SEN)];
                    %v2=[nbins length(SEN)];
                    %v3=[nbins length(SEN)];
                    %v4=[nbins length(SEN)];
                %elseif nbeams==5
                   % a1=[nbins length(SEN)];
                    %a2=[nbins length(SEN)];
                   % a3=[nbins length(SEN)];
                    %a4=[nbins length(SEN)];
                    %a5=[nbins length(SEN)]
                   % v1=[nbins length(SEN)];
                    %v2=[nbins length(SEN)];
                    %v3=[nbins length(SEN)];
                    %v4=[nbins length(SEN)];
                    %v5=[nbins length(SEN)];
else
    disp('Invalid number of beams used. Adjust the number of beams or script to account for the beams')
end

%Echo Intensity (data load into variables)
if nbeams==1
    a1=load(FIDecho1)
elseif nbeams==2
    a1=load(FIDecho(1));
    a2=load(FIDecho(2));
elseif nbeams==3
    a1=load(FIDecho(1));
    a2=load(FIDecho(2));
    a3=load(FIDecho(3));
                %elseif nbeams==4
                   % a1=load(FIDecho(1));
                   % a2=load(FIDecho(2));
                  %  a3=load(FIDecho(3));
                   % a4=load(FIDecho(4));
                %elseif nbeams==5
                  %  a1=load(FIDecho(1));
                  %  a2=load(FIDecho(2));
                   % a3=load(FIDecho(3));
                   % a4=load(FIDecho(4));
                  %  a5=load(FIDecho(5));
else
    disp('Invalid number of beams used. Adjust the number of beams or script to account for the beams')
end

%Velocity (data load into variables)
if nbeams==1
    v1=load(FIDvel1);
elseif   nbeams==2
    v1=load(FIDvel(1));
    v2=load(FIDvel(2));
elseif nbeams==3
    v1=load(FIDvel(1));
    v2=load(FIDvel(2));
    v3=load(FIDvel(3));
                %elseif nbeams==4 
                   % v1=load(FIDvel(1));
                   % v2=load(FIDvel(2));
                    %v3=load(FIDvel(3));
                   % v4=load(FIDvel(4));
                %elseif nbeams==5
                   % v1=load(FIDvel(1));
                   % v2=load(FIDvel(2));
                   % v3=load(FIDvel(3));
                   % v4=load(FIDvel(4));
                   % v5=load(FIDvel(5));
else
    disp('Invalid number of beams used. Adjust the number of beams or script to account for the beams')
end

%Close all - if open
fclose('all');

%% Creating a .dat file for load
%Note: This will always overwrite the same file and will follow the
%name format established by the existing files covered by the filekey
%variable. The output file will be a text file FileName.dat that
%adds all stored data files into one file.

% Open FileID with write permissions
fid=fopen(FIDdat, 'w+');

%File Open check
if fid == -1
disp('Error, check file name')
else
end


%Write the data file - Data file writen as filekey.dat derived from user
%input earlier

for i=1:1:length(SEN)
    
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
    
   %Lines 1&2 - Recent.Dat and Header Info
   fprintf(fid,'Recent.Dat\n%02d %02d %04d %02d %02d %02d %08d %08d  %2.1f %04.1f %03.1f  %02.1f  %01.1f   %02.3f  %02.2f     %01d     %01d\n', SEN(i,1),SEN(i,2),SEN(i,3),SEN(i,4),SEN(i,5), SEN(i,6), SEN(i,7), SEN(i,8),SEN(i,9), SEN(i,10), SEN(i,11), SEN(i,12),SEN(i,13), SEN(i,14), SEN(i,15), SEN(i,16), SEN(i,17));
   
   %Lines 3 to nbins - 
   % Note: This is an inefficient way to do this. It should likely be done 
   % with for/while loops, so you don't have to have nest 
   % if/else statements to cover every number of beams case. It works for 
   % the time being. 
        if nbeams==1
            for j=1:1:nbins
                if j<nbins
                    fprintf(fid,'  %7.3f %5.1f\n',v1(i,j),a1(i,j));
                elseif j==nbins
                    fprintf(fid,'  %7.3f %5.1f\n\n',v1(i,j),a1(i,j));
                else
                    disp('Error - Bin Number exceeded the max bins')
                end
            end 
        elseif nbeams==2
            for j=1:1:nbins
                if j<nbins
                    fprintf(fid,'  %7.3f  %7.3f %5.1f %5.1f\n',v1(i,j),v2(i,j),a1(i,j),a2(i,j));
                elseif j==nbins
                    fprintf(fid,'  %7.3f  %7.3f %5.1f %5.1f\n\n',v1(i,j),v2(i,j),a1(i,j),a2(i,j));
                else
                    disp('Error - Bin Number exceeded the max bins')
                end
            end
        elseif nbeams==3
             for j=1:1:nbins
                if j<nbins
                    fprintf(fid,' %7.3f %7.3f %7.3f %5.1f %5.1f %5.1f\n',v1(i,j),v2(i,j),v3(i,j),a1(i,j),a2(i,j),a3(i,j));
                elseif j==nbins
                    fprintf(fid,' %7.3f %7.3f %7.3f %5.1f %5.1f %5.1f\n\n',v1(i,j),v2(i,j),v3(i,j), a1(i,j),a2(i,j),a3(i,j));
                else
                    disp('Error - Bin Number exceeded the max bins')
                end
             end
        else 
            disp('Error - Invalid beams during the data write')
        end
end
 
            
fclose all;

fprintf('\nConversion complete. %s created. Check the file prior to data ingestion.', FIDdat)
           
                  
   

    
