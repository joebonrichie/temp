with Wordcount_Maps;     use Wordcount_Maps;
with Wordcount_Vectors;  use Wordcount_Vectors;

with Ada.Text_IO;              use Ada.Text_IO;
with Ada.Command_Line;         use Ada.Command_Line;
with Ada.Integer_Text_IO;      use Ada.Integer_Text_IO;
with Ada.Strings.Maps;         use Ada.Strings.Maps;
with Ada.Strings.Fixed;        use Ada.Strings.Fixed;
with Ada.Strings.Less_Case_Insensitive;
with Ada.Characters.Handling;  use Ada.Characters.Handling;
with Ada.Containers;           use Ada.Containers;

procedure Wordcount is

   M : Map;

   procedure Insert (Word : in String) is

      procedure Increment_Count
        (K : in     String;
         N : in out Natural) is

         pragma Warnings (Off, K);
      begin
         N := N + 1;
      end Increment_Count;

      C : Wordcount_Maps.Cursor;
      B : Boolean;

   begin -- Insert

      Insert (M, Word, 0, C, B);

      Update_Element (M, C, Increment_Count'Access);

   end Insert;

   File : File_Type;

   Word_Chars : constant Character_Set :=
     To_Set (Character_Ranges'(('a', 'z'), ('A', 'Z')));

   Line : String (1 .. 2000);

   Line_First : Positive;
   Line_Last : Natural;

   Word_First : Positive;
   Word_Last : Natural;

   procedure Print (C : in Wordcount_Maps.Cursor) is
   begin
      Put (To_Lower (Key (C)));
      Put (' ');
      Put (Element (C), Width => 0);
      New_Line;
   end Print;

--     procedure Print (V : in Vector) is
--     begin
--        for I in First_Index (V) .. Last_Index (V) loop
--           Print (Element (V, I));
--        end loop;
--     end Print;

   V : Vector;

begin -- Wordcount

   if Argument_Count = 0 then
      Put_Line (Command_Name & " <file>");
      return;
   end if;

   if Argument_Count > 1 then
      Put_Line ("too many command-line arguments");
      return;
   end if;

   begin
      Open (File, In_File, Name => Argument (1));
   exception
      when Name_Error =>
         Put_Line ("unable to open file");
         return;
   end;

   while not End_Of_File (File) loop

      Get_Line (File, Line, Line_Last);
      pragma Assert (Line_Last < Line'Last);

      Line_First := Line'First;

      loop

         Find_Token
           (Source => Line (Line_First .. Line_Last),
            Set    => Word_Chars,
            Test   => Ada.Strings.Inside,
            First  => Word_First,
            Last   => Word_Last);

         exit when Word_Last = 0;

         Insert (Word => Line (Word_First .. Word_Last));

         Line_First := Word_Last + 1;

      end loop;

   end loop;

--   New_Line;
--   Put_Line ("map entries (active):");
--   New_Line;
--
--     Print_Map :
--     declare
--        I : Wordcount_Maps.Cursor := First (M);
--     begin
--        while Has_Element (I) loop
--           Print (I);
--           Next (I);
--        end loop;
--     end Print_Map;
--
--     New_Line;
--     Put_Line ("map entries (passive):");
--     New_Line;
--
--     Iterate (M, Print'Access);
--     New_Line;

   Populate_Vector :
   declare
      procedure Append_To_V (C : Wordcount_Maps.Cursor) is
      begin
         Append (V, C);
      end Append_To_V;

      N : constant Count_Type := Length (M);
   begin
      if Capacity (V) < N then
         Reserve_Capacity (V, N);
      end if;

      Iterate (M, Append_To_V'Access);
   end Populate_Vector;

--     New_Line;
--     Put_Line ("before vector sort:");
--     New_Line;
--     Print (V);
--     New_Line;

   Sort_Vector :
   declare
      function "<" (L, R : Wordcount_Maps.Cursor) return Boolean is
         Result : Boolean;

         procedure Query_L (LK : String; LN : Natural) is
            procedure Query_R (RK : String; RN : Natural) is
            begin
               if LN > RN then
                  Result := True;
               elsif LN < RN then
                  Result := False;
               else
                  Result := Ada.Strings.Less_Case_Insensitive (LK, RK);
               end if;
            end Query_R;
         begin
            Query_Element (R, Query_R'Access);
         end;
      begin
         Query_Element (L, Query_L'Access);
         return Result;
      end;

      package Sorting is
         new Wordcount_Vectors.Generic_Sorting;
   begin
      Sorting.Sort (V);
   end Sort_Vector;

--     New_Line;
--     Put_Line ("after vector sort:");
--     New_Line;
--     Print (V);
--     New_Line;
--
--     Put_Line ("top 10 words:");

   for I in First_Index (V) .. Integer'Min (First_Index (V) + 9, Last_Index (V)) loop
      Print (Element (V, I));
   end loop;

end Wordcount;

