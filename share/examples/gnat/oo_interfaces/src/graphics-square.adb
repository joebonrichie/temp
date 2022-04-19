
with Ada.Text_IO;

package body Graphics.Square is

   use Ada.Text_IO;

   ----------
   -- Draw --
   ----------

   procedure Draw (Square : in Object) is
   begin
      Draw_Line (Square.Side);
      for K in 2 .. Square.Side - 1 loop
         Draw_Side (Square.Side);
      end loop;
      Draw_Line (Square.Side);
   end Draw;

   -----------
   -- Label --
   -----------

   function Label (Square : in Object) return String is
   begin
      return Get_Name (Square) &
        " :" & Natural'Image (Square.Side)
        & " ; Surface = " & Natural'Image (Square.Size);
   end Label;

   ----------
   -- Size --
   ----------

   function Size (Square : in Object) return Natural is
   begin
      return Square.Side ** 2;
   end Size;

end Graphics.Square;
