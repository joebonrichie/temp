--This program was adapted from the example in Chapter 12 of
--   STL Tutorial and Reference Guide, 2nd ed.
--   Musser, Derge, and Saini
--
--The dictionary file for this program can be found at Musser's web site:
--
--  <http://www.cs.rpi.edu/~musser/stl-book/source/>
--
--The file name is "diction" or "diction.txt".
--

with String_Vectors;  use String_Vectors;
with Ada.Text_IO;  use Ada.Text_IO;
with Ada.Command_Line;  use Ada.Command_Line;
with Utils.Algorithms.Generic_Binary_Search;
with Ada.Strings.Less_Case_Insensitive;
with Utils.Algorithms.Generic_Reverse_Random_Access;
with Ada.Characters.Handling;  use Ada.Characters.Handling;
with Utils.Algorithms.Generic_Next_Permutation;
--with Ada.Integer_Text_IO;  use Ada.Integer_Text_IO;
with Ada.Containers.Generic_Array_Sort;

procedure Anagram is

   V : Vector;

   Line : String (1 .. 81);
   Last : Natural;

   --N : Integer;

   function Less_Case_Insensitive (I, J : Character) return Boolean is
   begin
      return To_Lower (I) < To_Lower (J);
   end;

   use Utils.Algorithms;
   use Ada.Containers;

begin

   if Argument_Count = 0 then
      Put_Line ("no dictionary specified");
      return;
   end if;

   declare
      File : File_Type;
   begin
      Open (File, In_File, Argument (1));

      while not End_Of_File (File) loop

         Get_Line (File, Line, Last);
         pragma Assert (Last > 0);
         pragma Assert (Last < Line'Last);

         --Put_Line (Line (Line'First .. Last));

         Append (V, Line (Line'First .. Last));

      end loop;

      Close (File);
   end;

   Put ("dictionary has");
   --Put (Length (V), Width => 0);
   Put (Count_Type'Image (Length (V)));
   Put_Line (" entries");
   New_Line;

<<Get_Input>>

   Put ("ready: ");

   Get_Line (Line, Last);

   if Last < Line'First then
      return;
   end if;

   if Last = Line'Last then
      Skip_Line;
      Put_Line ("Input too long; please try again with a shorter word.");
      New_Line;
      goto Get_Input;
   end if;

   declare
      procedure Sort is
         new Ada.Containers.Generic_Array_Sort
           (Positive,
            Character,
            String,
            "<" => Less_Case_Insensitive);

      Word : String renames Line (Line'First .. Last);
   begin
      Put ("searching dictionary for permutations of """);
      Put (Word);
      Put_Line ("""");

      Sort (Word);

--        Put ("first sequence in lexicographical order is """);
--        Put (Word);
--        Put_Line ("""");
   end;

   --N := 0;

<<Get_Permutations>>

   Search_For_Word :
   declare

      function Is_Less (C : Cursor; S : String)
        return Boolean is
      begin
         return Ada.Strings.Less_Case_Insensitive (Element (C), S);
      end;

      function Is_Greater (C : Cursor; S : String)
        return Boolean is
      begin
         return Ada.Strings.Less_Case_Insensitive (S, Element (C));
      end;

      function "+" (C : Cursor; I : Integer'Base) return Cursor is
         Index : constant Integer'Base := To_Index (C) + I;
      begin
         if Index > Last_Index (V) then
            return No_Element;
         end if;

         return To_Cursor (V, Index);
      end;

      function "-" (L, R : Cursor) return Integer'Base is
         LI, RI : Integer'Base;
      begin
         if L = No_Element then
            LI := Last_Index (V) + 1;
         else
            LI := To_Index (L);
         end if;

         if R = No_Element then
            RI := Last_Index (V) + 1;
         else
            RI := To_Index (R);
         end if;

         return LI - RI;
      end;

      function Search is
         new Generic_Binary_Search
          (Iterator_Type => Cursor,
           Offset_Type   => Integer,
           Element_Type  => String);

      Word : String renames Line (Line'First .. Last);

      C : constant Cursor := Search (First (V), No_Element, Item => Word);

   begin

--        N := N + 1;
--        Put (N, Width => 0);
--        Put (": searching for """);
--        Put (Word);
--        Put_Line ("""");

      if Has_Element (C) then

         Put ("found match for """);
         Put (Word);
         Put_Line ("""");

      end if;

   end Search_For_Word;

   Permutate_Word :
   declare

      Word : String renames Line (Line'First .. Last);

      procedure Swap (I, J : in Positive) is
         CI : constant Character := Word (I);
      begin
         Word (I) := Word (J);
         Word (J) := CI;
      end;

      procedure Reverse_Sequence is
         new Generic_Reverse_Random_Access
           (Positive,
            Integer'Succ,
            Integer'Pred);

      function Is_Less (I, J : Positive) return Boolean is
         CI : constant Character := Word (I);
         CJ : constant Character := Word (J);
      begin
         return Less_Case_Insensitive (CI, CJ);
      end;

      function Next_Permutation is
         new Generic_Next_Permutation
          (Positive,
           Integer'Succ,
           Integer'Pred);

      Found : constant Boolean :=
        Next_Permutation (Word'First, Word'First + Word'Length);

   begin

      if Found then
         goto Get_Permutations;
      end if;

--        Put ("last permutation is """);
--        Put (Word);
--        Put_Line ("""");

      New_Line;

      goto Get_Input;

   end Permutate_Word;

end Anagram;

