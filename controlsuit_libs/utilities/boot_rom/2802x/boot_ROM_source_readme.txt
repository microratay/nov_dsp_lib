TMS320x2802x BOOT ROM Source

This download includes the source of the boot ROM contents
on TMS320x2802x devices. 

For each version of the boot ROM there is one .zip file
included where the version of the release is reflected
in the name of the .zip file.  The boot ROM version
on a particular device is stored in memory location
0x3FFFBA in the boot ROM.

The .zip contains all source including the project file, 
header files and the .out file used to generate the boot
ROM contents. 

=============================================
IMPORTANT NOTE: 

The boot ROM projects are CCSv3.3 projects. To open in CCSv4,
click on Project -> Import Legacy CCSv3.3 Project

The flash API library and IQmath library are NOT included in 
this download.  This was done for revision control reasons. 

For the latest version of these libraries and documentation 
regarding how to access them in the ROM, please install
the latest version through controlSUITE from the TI website.

==============================================

By default, the boot ROM source will be placed in the
C:\TI\controlSUITE\libs\utilities\boot_rom\2802x directory.
