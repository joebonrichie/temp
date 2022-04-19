--This genealogy program is based on the example in Chapter 18 of:
--  STL Tutorial and Reference Guide, 2nd ed.
--  Musser, Derge, and Saini
--
--The genealogy file for this program can be found at Musser's web site:
--
--  <http://www.cs.rpi.edu/~musser/stl-book/source/>
--
--The file name is TCS-genealogy.txt .
--


with Ada.Command_Line;  use Ada.Command_Line;
with Ada.Text_IO;       use Ada.Text_IO;
with Ada.Containers;    use Ada.Containers;

with Read_File;
with Print_Advisors;
with Print_Students;
with Find_Roots;
with Print_Roots;

procedure Genealogy is
begin

   if Ada.Command_Line.Argument_Count = 0 then
      Put_Line ("no genealogy file specified");
      return;
   end if;

   Read_File (Ada.Command_Line.Argument (1));
   New_Line (2);

   --Print_Advisors;
   --Print_Students;
   Find_Roots;
   Print_Roots;

end Genealogy;

