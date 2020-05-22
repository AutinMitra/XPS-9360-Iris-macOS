// Make brightness control and brightness keys work
// Patch: Rename GFX0.BRT6 to BRTX 
// Find: IEJSVDY=
// Replace: IEJSVFg=
// References:
// [1] https://github.com/daliansky/OC-little/tree/master/04-OC-PNLF%E6%B3%A8%E5%85%A5%E6%96%B9%E6%B3%95
// [2] https://github.com/daliansky/OC-little/tree/master/%E4%BF%9D%E7%95%99%E9%A1%B9%E7%9B%AE/X02-%E4%BA%AE%E5%BA%A6%E5%BF%AB%E6%8D%B7%E9%94%AE%E8%A1%A5%E4%B8%81

DefinitionBlock ("", "SSDT", 2, "hack", "BCKM", 0x00000000)
{
    External (_SB_.ACOS, IntObj)
    External (_SB_.ACSE, IntObj)
    External (_SB_.PCI0.GFX0, DeviceObj)
    External (_SB_.PCI0.GFX0.BRTX, MethodObj)
    External (_SB_.PCI0.GFX0.LCD_, DeviceObj)
    External (_SB_.PCI0.LPCB.PS2K, DeviceObj)
    
    // inject PNLF for Skylake to make brightness control work[1]
    Scope (_SB)
    {
        Device (PNLF)
        {
            Name (_ADR, Zero)  // _ADR: Address
            Name (_HID, EisaId ("APP0002"))  // _HID: Hardware ID
            Name (_CID, "backlight")  // _CID: Compatible ID
            Name (_UID, 0x10)  // _UID: Unique ID
            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                If (_OSI ("Darwin"))
                {
                    Return (0x0B)
                }
                Else
                {
                    Return (Zero)
                }
            }
        }
    }
    
    // make BRT6 to be called on Darwin
    // call chain: _Q66 -> NEVT -> SMIE -> SMEE -> EV5 -> BRT6
    // in SMEE, EV5 is called only when OSID >= 0x20, and OSID:
    //     if ACOS == 0: init ACOS based on OS version
    //     return ACOS
    // hence set ACOS >= 0x20 can do the trick, and this trick affects less methods than _OSI renaming patch
    Scope (\)
    {
        If (_OSI ("Darwin"))
        {
            // simulate Windows 2013(Win81)
            \_SB.ACOS = 0x80
            \_SB.ACSE = 0x02
        }
    }

    // notify PS2K when brightness control key was pressed[2]
    Scope (\_SB.PCI0.GFX0)
    {
        Method (BRT6, 2, NotSerialized)
        {
            If (_OSI ("Darwin"))
            {
                If ((Arg0 == One)) 
                {
                    Notify (^LCD, 0x86)    //native code
                    Notify (^^LPCB.PS2K, 0x10)    //ELAN code
                    Notify (^^LPCB.PS2K, 0x0206) // PS2 code
                    Notify (^^LPCB.PS2K, 0x0286) // PS2 code
                }
                
                If ((Arg0 & 0x02))
                {
                    Notify (^LCD, 0x87)    //native code
                    Notify (^^LPCB.PS2K, 0x20)    //ELAN code
                    Notify (^^LPCB.PS2K, 0x0205) // PS2 code
                    Notify (^^LPCB.PS2K, 0x0285) // PS2 code
                }
            }
            Else
            {
                BRTX (Arg0, Arg1)
            }
        }
    }
}

