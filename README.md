# Currents-Conversion
Code needed to convert raw ADCP data collected in NCOP Current Surveys into a format that is compatible for ingestion into the database.

# Scripts:
1. ‘NortekFileConversion.m’
2. [Fortran place holder]

# How to Run (1): 
1. Copy 'Nortek File Conversion.m' into the same folder that has raw Nortek ADCP files, including: .hdr, .a1, .ssl, etc.
2. Modify the code including the number of bins (nbins, line 32), the number of beams (nbeams, line 33), and the file name (filekey, line 35). Note: The number of bins and beams can be found in the .hdr file. The filekey should match the .prf file name, e.g. for SAV2002.prf, filekey = ‘SAV2002’;
3. Run the script

# How to Run (2): 
