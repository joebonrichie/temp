with Ada.Command_Line;     use Ada.Command_Line;
with Ada.Text_IO;          use Ada.Text_IO;
with Ada.Integer_Text_IO;  use Ada.Integer_Text_IO;
with Ada.Containers;       use Ada.Containers;

with String_Integer_Maps;  use String_Integer_Maps;
with To_Key;

procedure Test_Hash is

   M : Map;
   N : Natural;

begin

   if Argument_Count = 0 then
      N := 2**16;
   else
      declare
         Image : constant String := Argument (1);
      begin
         N := Integer'Value (Image);
      end;
   end if;

   Reserve_Capacity (M, Integer'Pos (N));

   for I in 1 .. N loop

      Insert (M, Key => To_Key (I, Base => 16), New_Item => I);

      if I rem 10000 = 0 then
         Put ("i=");
         Put (I, Width => 0);
         New_Line;
      end if;

   end loop;

--     Print_M:
--     declare
--        procedure Print (K : String; E : Integer) is
--        begin
--           Put (K);
--           Put (":");
--           Put (E, Width => 0);
--           New_Line;
--        end;

--        procedure Print (C : Cursor) is
--        begin
--           Query_Element (C, Print'Access);
--        end;
--     begin
--        Iterate (M, Print'Access);
--        New_Line;
--     end Print_M;

   Put ("map.length=");
   Put (Count_Type'Image (Length (M)));
   New_Line;

   declare
      Count : Integer'Base := 0;
   begin
      for I in reverse 1 .. N loop
         if Contains (M, Key => To_Key (I, Base => 10)) then
            Count := Count + 1;
         end if;
      end loop;

      Put ("map.count=");
      Put (Count, Width => 0);
      New_Line;
   end;

end Test_Hash;
