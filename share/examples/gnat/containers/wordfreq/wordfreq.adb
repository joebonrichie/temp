-- This program is based on the word-frequency problem described here:
--  <http://shootout.alioth.debian.org/benchmark.php?test=wordfreq&lang=all&sort=fullcpu>
--
-- The input file is:
--  <http://shootout.alioth.debian.org/download/wordfreq-input.txt>
--
-- The output should look like:
--  <http://shootout.alioth.debian.org/download/wordfreq-output.txt>

with Ada.Text_IO;              use Ada.Text_IO;
with Ada.Characters.Handling;  use Ada.Characters.Handling;
with Ada.Integer_Text_IO;      use Ada.Integer_Text_IO;
with Ada.Command_Line;         use Ada.Command_Line;
with Ada.Containers.Generic_Array_Sort;  use Ada.Containers;

with String_Integer_Maps;  use String_Integer_Maps;

procedure Wordfreq is

   Line : String (1 .. 256);
   Last : Natural;

   I, J : Positive;
   Word : String (1 .. Line'Length);

   M : Map;

   procedure Insert is
      procedure Increment (K : String; E : in out Integer) is
         pragma Unreferenced (K);
      begin
         E := E + 1;
      end;

      C : Cursor;
      B : Boolean;
   begin
      M.Insert (Word (1 .. J), 0, C, B);
      Update_Element (M, C, Increment'Access);
   end Insert;

   type Cursor_Array is
     array (Count_Type range <>) of String_Integer_Maps.Cursor;

   function "<" (L, R : String_Integer_Maps.Cursor) return Boolean is
      LE : constant Integer := Element (L);
      RE : constant Integer := Element (R);
   begin
      if LE < RE then
         return False;
      elsif LE > RE then
         return True;
      else
         return Key (L) > Key (R);
      end if;
   end "<";

   procedure Sort is new Ada.Containers.Generic_Array_Sort
     (Count_Type,
      String_Integer_Maps.Cursor,
      Cursor_Array);

   File : File_Type;

begin

   -- Either use a pipe to execute this:
   --   cat file.txt | wordfreq
   -- (from a win shell use "type" instead of "cat");
   -- or, you can just name the input file on the command line.

   if Argument_Count > 0 then
      Open (File, In_File, Name => Argument (1));
      Set_Input (File);
   end if;

   <<Scan_Line>> null;

   if End_Of_File then
      goto Sort_Words;
   end if;

   Get_Line (Line, Last);
   pragma Assert (Last < Line'Last);

   I := Line'First;

   <<Find_Word>> null;

   loop
      if I > Last then
         goto Scan_Line;
      end if;

      exit when Is_Letter (Line (I));

      I := I + 1;
   end loop;

   J := 1;

   <<Scan_Word>> null;

   Word (J) := To_Lower (Line (I));
   I := I + 1;

   if I > Last then
      Insert;
      goto Scan_Line;
   end if;

   if Is_Letter (Line (I)) then
      J := J + 1;
      goto Scan_Word;
   end if;

   Insert;
   I := I + 1;

   goto Find_Word;

   <<Sort_Words>> null;

   declare
      A : Cursor_Array (1 .. Length (M));
      K : Count_Type := A'First;

      procedure Process (C : String_Integer_Maps.Cursor) is
      begin
         A (K) := C;
         K := K + 1;
      end;
   begin
      M.Iterate (Process'Access);
      Sort (A);

      for Index in A'Range loop
         Put (Element (A (Index)), Width => 7);
         Put (' ');
         Put (Key (A (Index)));
         New_Line;
      end loop;
   end;

end Wordfreq;
