--  This is the main procedure for a utility program that displays the contents
--  of an engine.  You specify the file name for the engine on the command line.

with GNAT.IO;                use GNAT.IO;
with Ada.Command_Line;       use Ada.Command_Line;
with Ada.Strings.Unbounded;  use Ada.Strings.Unbounded;

with Menace.Machines;
with Menace.Machines.Display;

use Menace;

procedure Display is
   Machine : Machines.Engine;
begin
   if Argument_Count /= 1 then
      Put_Line ("You must specify the file name of the machine to display.");
      return;
   end if;

   Machine.Initialize (Id   => Player_X,
                       Name => To_Unbounded_String (Argument (1)));
   Menace.Machines.Display (Machine);
end Display;

