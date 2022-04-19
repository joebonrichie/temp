--This program was adapted from the example in Chapter 13 of
--   STL Tutorial and Reference Guide, 2nd ed.
--   Musser, Derge, and Saini
--
--The dictionary file for this program can be found at Musser's web site:
--
--  <http://www.cs.rpi.edu/~musser/stl-book/source/>
--
--The file name is "diction" or "diction.txt".
--

with Anagram_Types;  use Anagram_Types;
with Ada.Text_IO;  use Ada.Text_IO;
with Ada.Integer_Text_IO;  use Ada.Integer_Text_IO;
with Ada.Command_Line;  use Ada.Command_Line;
with Ada.Characters.Handling;  use Ada.Characters.Handling;
with Ada.Containers.Generic_Array_Sort;
with Utils.Algorithms.Generic_Adjacent_Find;

with Ada.Strings.Less_Case_Insensitive;
with Ada.Strings.Equal_Case_Insensitive;

procedure Anagram2 is

   V : Anagram_Types.Pair_Vectors.Vector;
   use Pair_Vectors;

   function Less_Case_Insensitive (I, J : Character) return Boolean is
   begin
      return To_Lower (I) < To_Lower (J);
   end;

   procedure Sort is
      new Ada.Containers.Generic_Array_Sort
        (Positive,
         Character,
         String,
         "<" => Less_Case_Insensitive);

   use Utils.Algorithms;
   use Ada.Containers;

begin

   if Argument_Count = 0 then
      Put_Line ("no dictionary specified");
      return;
   end if;

   declare
      File : File_Type;

      Line : String (1 .. 81);
      Last : Natural;
   begin
      Open (File, In_File, Argument (1));

      while not End_Of_File (File) loop

         Get_Line (File, Line, Last);
         pragma Assert (Last > 0);
         pragma Assert (Last < Line'Last);

         declare
            N    : constant Positive := Last - Line'First + 1;
            Pair : Pair_Type (Length => N);
         begin
            Pair.Word := Line (Line'First .. Last);
            Pair.Sorted := Pair.Word;
            Sort (Pair.Sorted);
            Append (V, New_Item => Pair);
         end;

      end loop;

      Close (File);
   end;

   Put ("dictionary has");
   Put (Count_Type'Image (Length (V)));
   Put_Line (" entries");
   New_Line;

   declare
      function "<" (L, R : Pair_Type) return Boolean is
         LS : String renames L.Sorted;
         RS : String renames R.Sorted;
      begin
         return Ada.Strings.Less_Case_Insensitive (LS, RS);
      end;

      package Sorting is
         new Pair_Vectors.Generic_Sorting;
   begin
      Sorting.Sort (V);
   end;

   declare

      function Is_Equal (I, J : Positive) return Boolean is
         Result : Boolean;

         procedure Process_I (IE : in Pair_Type) is
            procedure Process_J (JE : in Pair_Type) is
            begin
               Result := Ada.Strings.Equal_Case_Insensitive (IE.Sorted, JE.Sorted);
            end;
         begin
            Query_Element (V, J, Process_J'Access);
         end;
      begin
         Query_Element (V, I, Process_I'Access);
         return Result;
      end;

      function Find is
         new Utils.Algorithms.Generic_Adjacent_Find
          (Positive,
           Integer'Succ);

      I : Positive := First_Index (V);
      J : constant Positive := Last_Index (V) + 1;
      K : Positive;

      N : Integer'Base := 0;

   begin

      loop

         I := Find (I, J);

         exit when I = J;

         N := N + 1;

         K := I + 1;  -- I + 2?

         while K /= J
           and then Is_Equal (I, K)
         loop
            K := K + 1;
         end loop;

         loop

            declare
               procedure Process (Pair : in Pair_Type) is
               begin
                  Put (Pair.Word);
               end;
            begin
               Query_Element (V, I, Process'Access);
            end;

            I := I + 1;

            exit when I = K;

            Put (' ');

         end loop;

         New_Line;

      end loop;

      New_Line;
      Put ("A total of ");
      Put (N, Width => 0);
      Put_Line (" anagram group(s) were found.");
      New_Line;

   end;


end Anagram2;

