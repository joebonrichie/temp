
with Ada.Text_IO;
with Ada.Unchecked_Deallocation;

package body Graphics is

   use Ada.Text_IO;

   ---------
   -- "<" --
   ---------

   function "<" (O1, O2 : in Object'Class) return Boolean is
   begin
      return O1.Size < O2.Size;
   end "<";

   ------------
   -- Adjust --
   ------------

   procedure Adjust (O : in out Object) is
   begin
      if O.Name /= null then
         O.Name := new String'(O.Name.all);
      end if;
   end Adjust;

   ---------------
   -- Draw_Line --
   ---------------

   procedure Draw_Line (Size : in Natural) is
   begin
      for K in 1 .. Size loop
         Put ('-');
      end loop;
      New_Line;
   end Draw_Line;

   ---------------
   -- Draw_Side --
   ---------------

   procedure Draw_Side (Size : in Natural) is
   begin
      Put ('|');
      for K in 2 .. Size - 1 loop
         Put (' ');
      end loop;
      Put ('|');
      New_Line;
   end Draw_Side;

   --------------
   -- Finalize --
   --------------

   procedure Finalize (O : in out Object) is
      procedure Unchecked_Free is
        new Ada.Unchecked_Deallocation (String, String_Access);
   begin
      Unchecked_Free (O.Name);
   end Finalize;

   --------------
   -- Get_Name --
   --------------

   function Get_Name (O : in Object'Class) return String is
   begin
      return O.Name.all;
   end Get_Name;

   --------------
   -- Set_Name --
   --------------

   procedure Set_Name (O : in out Object'Class; Name : in String) is
   begin
      O.Name := new String'(Name);
   end Set_Name;

end Graphics;
