with Ada.Command_Line; use Ada.Command_Line;
with Ada.Text_IO;
with Ada.Streams.Stream_IO;
procedure Gen_Sum is
   use H;
   use Ada.Streams;
   use Ada.Streams.Stream_IO;

   F : File_Type;
   C : H.Context;
   Buf : Stream_Element_Array (1 .. 4096);
   Last : Stream_Element_Offset;
begin
   Open (F, In_File, Argument (1));
   loop
      Read (F, Buf, Last);
      Update (C, Buf (Buf'First .. Last));
      exit when Last < Buf'First;
   end loop;
   Ada.Text_IO.Put_Line (Digest (C) & "  " & Argument (1));
end Gen_Sum;
