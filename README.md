# Currents-Conversion
Code needed to convert raw ADCP data into a format that is compatible for ingestion into the database.

# Scripts:
1. ‘NortekFileConversion.m’
         * This needs to be in the same folder that has the raw ADCP files, including .hdr, .a1, .ssl, etc.
         * Modify the code including:
               - the number of bins (nbins, line 32)
               - the number of beams (nbeams, line 33)
               - the file name (filekey, line 35). The filekey should match the .prf file name, e.g. for SAV2002.prf, filekey = ‘SAV2002’.
         * Note: The number of bins and beams can be found in the .hdr file.  
         * Run the script

3. [Fortran place holder]
