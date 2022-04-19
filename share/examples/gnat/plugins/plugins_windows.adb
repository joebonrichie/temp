with System;          use System;
with Ada.Exceptions;  use Ada.Exceptions;
with Interfaces.C;
with Ada.Unchecked_Conversion;
with Ada.Unchecked_Deallocation;

package body Plugins is

   --  The following declarations provide the necesary Windows facilities
   --  without requiring the user to have installed the Win32 Ada binding.

   subtype HINSTANCE is System.Address; --  windef.h :199, winnt.h :144

   type LPCSTR is access constant Interfaces.C.char;  --  winnt.h
   pragma Convention (C, LPCSTR);

   function LoadLibrary (lpLibFileName : LPCSTR) return HINSTANCE;
   pragma Import (Stdcall, LoadLibrary, "LoadLibraryA");
   --  winbase.h :3619

   type PROC is access function return Interfaces.C.int;  --  windef.h :175
   pragma Convention (Stdcall, PROC);
   subtype FARPROC is PROC;  --  windef.h :173

   function GetProcAddress (hModule : HINSTANCE; lpProcName : LPCSTR)
      return FARPROC;  --  winbase.h :997
   pragma Import (Stdcall, GetProcAddress, "GetProcAddress");
   --  winbase.h :997

   --  end of Windows-specific facilities.

   type Implementation is new HINSTANCE;

   function As_LPCSTR is
      new Ada.Unchecked_Conversion (Source => System.Address,
                                    Target => LPCSTR);

   procedure Free is
      new Ada.Unchecked_Deallocation (Object => Implementation,
                                      Name   => Reference );

   ----------
   -- Load --
   ----------

   function Load (Path : String) return Plugin is
      Result     : Plugin;
      Local_Path : aliased constant String := Path & ASCII.Nul;
   begin
      Result.Ref := new Implementation;
      Result.Ref.all := Implementation (LoadLibrary
                                          (As_LPCSTR (Local_Path'Address)));
      if Result.Ref.all = Implementation (Null_Address) then
         Free (Result.Ref);
         Raise_Exception (Not_Found'Identity, Path);
      end if;
      return Result;
   end Load;

   ----------
   -- Call --
   ----------

   procedure Call (P : Plugin; Unit_Name : String) is
      Ignored : Interfaces.C.int;
      pragma Unreferenced (Ignored);
   begin
      Ignored := Call (P, Unit_Name);
   end Call;

   ----------
   -- Call --
   ----------

   function Call (P : Plugin; Unit_Name : String) return Interfaces.C.int is
      Name   : aliased constant String := Unit_Name & ASCII.Nul;
      F      : FARPROC;
      Result : Interfaces.C.int;
      use type FARPROC;
   begin
      --  get a pointer to the function within the plugin
      F := GetProcAddress (HINSTANCE (P.Ref.all), As_LPCSTR (Name'Address));
      if F = null then
         raise Not_Found with Unit_Name;
      end if;
      --  now we call the function via the pointer and capture the result
      Result := F.all;
      return Result;
   end Call;

   ------------
   -- Unload --
   ------------

   procedure Unload (P : in out Plugin) is
   begin
      Free (P.Ref);
      --  we could try to use the OS to truely unload the DLL at
      --  some point, if that is possible.
   end Unload;

   ---------------------
   -- Autoinitialized --
   ---------------------

   function Autoinitialized return Boolean is
   begin
      return False;
   end Autoinitialized;

end Plugins;
