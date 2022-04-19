--  Prints the state of the matchboxes within an engine.

with GNAT.IO;  use GNAT.IO;
with Menace.Matchboxes.Display;

procedure Menace.Machines.Display (This : in Engine) is
begin
   for K in This.Boxes'Range loop
      Put_Line ("*********************************************");
      Menace.Matchboxes.Display (This.Boxes (K));
   end loop;
   New_Line;
end Menace.Machines.Display;
