pragma C_Pass_By_Copy (128);

with Interfaces;
with Ada.Exceptions;  use Ada.Exceptions;

package body WIN32_Console is

   procedure Move_Cursor (To : in Console.Location);
   --  Moves the cursor using Windows API.
   --  Is not a primitive operation for Device.

   type Colors is (Black, Blue, Green, Cyan, Red, Magenta, Brown, Gray,
                   Light_Blue, Light_Green, Light_Cyan, Light_Red,
                   Light_Magenta, Yellow, White);

   -----------------
   -- Move_Cursor --
   -----------------

   procedure Move_Cursor (This : in out Device; To : in Console.Location) is
      pragma Unreferenced (This);
   begin
      Move_Cursor (To);
   end Move_Cursor;


   use Interfaces;

   subtype SHORT  is Integer_16;
   subtype DWORD  is Unsigned_32;
   subtype HANDLE is Unsigned_32;

   type LPDWORD is access all DWORD;
   for LPDWORD'Storage_Size use 0;

   pragma Convention (C, LPDWORD);

   type Unsigned_4 is mod 2 ** 4;

   type Attribute is
      record
         Foreground : Unsigned_4;
         Background : Unsigned_4;
         Reserved   : Unsigned_8 := 0;
      end record;

   for Attribute use
      record
         Foreground at 0 range 0 .. 3;
         Background at 0 range 4 .. 7;
         Reserved   at 1 range 0 .. 7;
      end record;

   for Attribute'Alignment use 1;

   pragma Convention (C, Attribute);

   type COORD is
      record
         X : SHORT;
         Y : SHORT;
      end record;

   pragma Convention (C, COORD);

   type SMALL_RECT is
      record
         Left   : SHORT;
         Top    : SHORT;
         Right  : SHORT;
         Bottom : SHORT;
      end record;

   pragma Convention (C, SMALL_RECT);

   type CONSOLE_SCREEN_BUFFER_INFO is
      record
         Size       : COORD;
         Cursor_Pos : COORD;
         Attrib     : Attribute;
         Window     : SMALL_RECT;
         Max_Size   : COORD;
      end record;

   pragma Convention (C, CONSOLE_SCREEN_BUFFER_INFO);

   type PCONSOLE_SCREEN_BUFFER_INFO is access all CONSOLE_SCREEN_BUFFER_INFO;
   for PCONSOLE_SCREEN_BUFFER_INFO'Storage_Size use 0;

   pragma Convention (C, PCONSOLE_SCREEN_BUFFER_INFO);


   WIN32_ERROR          : constant DWORD  := 0;
   INVALID_HANDLE_VALUE : constant HANDLE := -1;
   STD_OUTPUT_DEVICE    : constant DWORD  := -11;

   As_Number : constant array (Colors) of Unsigned_4 :=
      (0, 1, 2, 3, 4, 5, 6, 7, 9, 10, 11, 12, 13, 14, 15);
   -- note the missing value 8


   Std_Output : HANDLE;
   -- we can safely share the standard output device handle


   function GetStdHandle (Value : DWORD) return HANDLE;
   pragma Import (StdCall, GetStdHandle, "GetStdHandle");

   function SetConsoleCursorPosition
      (Buffer : HANDLE;
       Pos    : COORD)
      return DWORD;
   pragma Import (StdCall, SetConsoleCursorPosition, "SetConsoleCursorPosition");

   function SetConsoleTextAttribute
      (Buffer : HANDLE;
       Attr   : Attribute)
      return DWORD;
   pragma Import (StdCall, SetConsoleTextAttribute, "SetConsoleTextAttribute");

   function GetConsoleScreenBufferInfo
      (Buffer : HANDLE;
       Info   : PCONSOLE_SCREEN_BUFFER_INFO)
      return DWORD;
   pragma Import (StdCall, GetConsoleScreenBufferInfo, "GetConsoleScreenBufferInfo");

   function FillConsoleOutputCharacter
      (Console : HANDLE;
       Char    : Character;
       Length  : DWORD;
       Start   : COORD;
       Written : LPDWORD)
      return DWORD;
   pragma Import (Stdcall, FillConsoleOutputCharacter, "FillConsoleOutputCharacterA");

   function FillConsoleOutputAttribute
      (Console : Handle;
       Attr    : Attribute;
       Length  : DWORD;
       Start   : COORD;
       Written : LPDWORD)
      return DWORD;
   pragma Import (Stdcall, FillConsoleOutputAttribute, "FillConsoleOutputAttribute");

   -----------
   -- Clear --
   -----------

   procedure Clear (This : in out Device) is
      pragma Unreferenced (This);
      Attr          : Attribute;
      Origin        : constant COORD := (0, 0);
      Length        : constant DWORD := DWORD ((SHORT'Last + 1) * (SHORT'Last + 1));
      -- ie, maximum possible screen buffer width * max height
      Num_Bytes     : aliased DWORD;
      Num_Bytes_Ref : constant LPDWORD := Num_Bytes'Unchecked_Access;
      Screen_Buffer : aliased CONSOLE_SCREEN_BUFFER_INFO;
      Buffer_Info   : constant PCONSOLE_SCREEN_BUFFER_INFO := Screen_Buffer'Unchecked_Access;
   begin
      -- read the window's screen buffer settings
      if GetConsoleScreenBufferInfo (Std_Output, Buffer_Info) = WIN32_ERROR
      then
         Raise_Exception (Win32_Subsystem_Error'Identity,
                          "error getting screen buffer settings in Clear");
      end if;
      -- set the attributes for any characters written after this call
      Attr.Background := As_Number (Black);
      Attr.Foreground := Screen_Buffer.Attrib.Foreground;
      if SetConsoleTextAttribute (Std_Output, Attr) = WIN32_ERROR then
         Raise_Exception (Win32_Subsystem_Error'Identity,
                          "error setting character attributes in Clear");
      end if;
      -- Set the character attributes for all the characters in the buffer,
      -- beginning at the origin. Num_Bytes is how many were actually written,
      -- but we ignore that and just check for the overall error. We are
      -- specifying more characters to set than are present in the buffer, but
      -- the routine only writes up to the end of the screen buffer so no
      -- overwrite is occurring.  The characters themselves are not changed.
      if FillConsoleOutputAttribute
         (Std_Output, Attr, Length, Origin, Num_Bytes_Ref) = WIN32_ERROR
      then
         Raise_Exception (Win32_Subsystem_Error'Identity,
                          "error applying character attributes in Clear");
      end if;
      -- Write a blank character to the console screen buffer to every
      -- possible screen buffer location (since Length is the max width * max
      -- height) beginning at the origin. Stops writing at the end of the
      -- screen buffer so there is no overrun problem. We ignore how many were
      -- actually written.
      if FillConsoleOutputCharacter
         (Std_Output, ' ', Length, Origin, Num_Bytes_Ref) = WIN32_ERROR
      then
         Raise_Exception (Win32_Subsystem_Error'Identity,
                          "error writing filler characters in Clear");
      end if;
   end Clear;

   -----------------
   -- Move_Cursor --
   -----------------

   procedure Move_Cursor (To : in Console.Location) is
      Target        : COORD := (SHORT (To.Column) - 1, SHORT (To.Row) - 1);
      -- note that we must reverse the order of rows and columns when going
      -- from console.location to windows X and Y, and also subtract 1 since
      -- windows coordinates start at zero
      Screen_Buffer : aliased CONSOLE_SCREEN_BUFFER_INFO;
      Buffer_Info   : constant PCONSOLE_SCREEN_BUFFER_INFO := Screen_Buffer'Unchecked_Access;
   begin
      if GetConsoleScreenBufferInfo (Std_Output, Buffer_Info) = WIN32_ERROR
      then
         Raise_Exception (Win32_Subsystem_Error'Identity,
                          "GetConsoleScreenBufferInfo error");
      end if;
      -- bracket the requested position to the dimensions of the screen buffer
      Target.X := SHORT'Min (Target.X, Screen_Buffer.Size.X);
      Target.Y := SHORT'Min (Target.Y, Screen_Buffer.Size.Y);
      -- move the console cursor to Target
      if SetConsoleCursorPosition (Std_Output, Target) = WIN32_ERROR then
         Raise_Exception (Win32_Subsystem_Error'Identity,
                          "Cursor position error attempting (X,Y) (" &
                          Target.X'Img & ", " & Target.Y'Img & ')' );
      end if;
   end Move_Cursor;


begin
   -- get a handle to the standard output device for the window
   Std_Output := GetStdHandle (STD_OUTPUT_DEVICE);
   if Std_Output = INVALID_HANDLE_VALUE then
      Raise_Exception (Win32_Subsystem_Error'Identity,
                       "Invalid standard output handle obtained");
   end if;
end WIN32_Console;


