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

For additional information, contact: Katie Kirk NOAA Center for Operational Oceanographic Products and Services, katie.kirk@noaa.gov

#NOAA Open Source Disclaimer
This repository is a scientific product and is not official communication of the National Oceanic and Atmospheric Administration, or the United States Department of Commerce. All NOAA GitHub project code is provided on an ?as is? basis and the user assumes responsibility for its use. Any claims against the Department of Commerce or Department of Commerce bureaus stemming from the use of this GitHub project will be governed by all applicable Federal law. Any reference to specific commercial products, processes, or services by service mark, trademark, manufacturer, or otherwise, does not constitute or imply their endorsement, recommendation or favoring by the Department of Commerce. The Department of Commerce seal and logo, or the seal and logo of a DOC bureau, shall not be used in any manner to imply endorsement of any commercial product or activity by DOC or the United States Government.

#License
Software code created by U.S. Government employees is not subject to copyright in the United States (17 U.S.C. �105). The United States/Department of Commerce reserve all rights to seek and obtain copyright protection in countries other than the United States for Software authored in its entirety by the Department of Commerce. To this end, the Department of Commerce hereby grants to Recipient a royalty-free, nonexclusive license to use, copy, and create derivative works of the Software outside of the United States.
