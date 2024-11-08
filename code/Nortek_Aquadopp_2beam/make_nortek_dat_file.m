% how to use hew Nortek2Recent function
% need read_hdr_nortek.m and Nortek2Recent in same folder
%
% put all ascii Nortek data files in same directory.  If multiple
% deployments, this is fine as long as they don't have the same prefix

% keep track of all the prefixes

% this one had only 1 file so it does not need a list

% if the instrument is a sidelooker, the call to Nortk2Recent has an
% additional input variable - set it to 1 as below

fileprefixlist = {'..\1 - Conversion\STX16B01'};
outprefix = 'STX22newtest';

[sen, echo, vel] = Nortek2Recent(fileprefixlist,outprefix,1);

% if you want to save the data into a matlab workspace to check things,
% uncomment the below:
% save('stx1822.mat' ,'echo', 'sen','vel');
