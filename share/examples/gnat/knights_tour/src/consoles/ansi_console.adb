with Ada.Text_IO;  use Ada.Text_IO;

package body ANSI_Console is

   function As_String (Input : Integer) return String;
   --  Converts the Input to a string without the leading space and
   --  with a leading zero if Input is only one digit.  This is
   --  required by the ANSI escape sequences.

   -----------
   -- Clear --
   -----------

   procedure Clear (This : in out Device) is
      pragma Unreferenced (This);
   begin
      Put (ASCII.Esc & "[2J");
   end Clear;

   -----------------
   -- Move_Cursor --
   -----------------

   procedure Move_Cursor (This : in out Device;  To : in Console.Location) is
      pragma Unreferenced (This);
      Buffer : String (1 .. 8) := ASCII.Esc & "[00;00H";
      subtype Row_Slice is Integer range 3 .. 4;
      subtype Col_Slice is Integer range 6 .. 7;
   begin
      Buffer (Row_Slice) := As_String (To.Row);
      Buffer (Col_Slice) := As_String (To.Column);
      Put (Buffer);
   end Move_Cursor;

   ---------------
   -- As_String --
   ---------------

   function As_String (Input : Integer) return String is
      Image  : constant String := Integer'Image (Input);
      Buffer : String (1 .. 2);
   begin
      Buffer := "00";
      if Input > 9 then -- note can only be 2 digits (80 is biggest value); " xx"
         Buffer := Image (2 .. 3);
      else -- single digit " x"
         Buffer (2) := Image (2);
      end if;
      return Buffer;
   end As_String;

end ANSI_Console;


