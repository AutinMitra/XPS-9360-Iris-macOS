# 9360-macOS
macOS Catalina (10.15) for the ThinkPad X1 Carbon 6th Gen

Big thanks to @tylernguyen

# Specs
|    CPU   |   GPU    |  RAM  | STORAGE |    DISPLAY    |
|:--------:|:--------:|:-----:|:-------:|:-------------:|
| i7-7560u | IRIS 640 | 16 GB |  512 GB |   3200x1800   |

# Summary
| Working                          | Not Working                   | Not Sure                    |
|----------------------------------|-------------------------------|-----------------------------|
| USB A, C, Sleep, Graphics        | Fingerpint                    | Thunderbolt 3 Functionality |
| Audio*                           |                               |                             |
| Touch                            |                               |                             |
| USB-C to Displayport             |                               |                             |

\*Install @the-darkvoid's combojack for better headphone quality & support

The provided wifi card is not compatible with macOS, so I would recommend the DW1560

# BIOS Configuration
- Disable VTD
- Disable "Enable Legacy Boot"
- Change from RAID to AHCI
- Make boot mode to UEFI
- Disable Fingerprint + SD Card reader

# Installation
Copy the folders to your EFI, and things should work for the most part.

# Troubleshooting
Some issues may occur due to hardware differences
- Make sure you are using a 7560u - the GPU is different from the 8550u and 7500u, which will cause compatability issues
- To improve CPU PM, try generating CPUFriend kexts with one-key-cpufriend
- If your opencore is freezing, did you configure the BIOS as said before (disabling enable legacy boot fixes this for some)

## Power Management
Even though you may or may not have the same CPU, their configuration/profiles may be different, so generate new CPUFriend kexts for better PM.

# Credits
I did very little work, mostly updating kexts and tinkering with configs for trackpad (now no annoying typing delay)
Credits go to @the-darkvoid, @hoanx for their fantastic configurations
