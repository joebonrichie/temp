--The spellcheck input files are here:
--http://shootout.alioth.debian.org/download/spellcheck-dict.txt
--http://shootout.alioth.debian.org/download/spellcheck-input.txt

with Hashed_Word_Sets;  use Hashed_Word_Sets;
--with Ordered_Word_Sets;  use Ordered_Word_Sets;
with Ada.Text_IO;  use Ada.Text_IO;

procedure Spellcheck is

   Words : Set;

   Line : String (1 .. 132);
   Last : Natural;

   File : File_Type;

begin

   Reserve_Capacity (Words, 40_000);

   Open (File, In_File, "spellcheck-dict.txt");

   while not End_Of_File (File) loop
      Get_Line (File, Line, Last);
      Insert (Words, New_Item => Line (Line'First .. Last));
   end loop;

   Close (File);

   while not End_Of_File loop
      Get_Line (Line, Last);

      if not Contains (Words, Item => Line (Line'First .. Last)) then
         Put_Line (Line (Line'First .. Last));
      end if;
   end loop;

end Spellcheck;




