
with Ada.Text_IO;

package body Graphics.Rectangle is

   use Ada.Text_IO;

   ----------
   -- Draw --
   ----------

   procedure Draw (Rectangle : in Object) is
   begin
      Draw_Line (Rectangle.Width);
      for K in 2 .. Rectangle.Height - 1 loop
         Draw_Side (Rectangle.Width);
      end loop;
      Draw_Line (Rectangle.Width);
   end Draw;

   -----------
   -- Label --
   -----------

   function Label (Rectangle : in Object) return String is
   begin
      return Get_Name (Rectangle) & " :" &
        Natural'Image (Rectangle.Height) &
        " x " & Natural'Image (Rectangle.Width) &
        " ; Size = " & Natural'Image (Rectangle.Size);
   end Label;

   ----------
   -- Size --
   ----------

   function Size (Rectangle : in Object) return Natural is
   begin
      return Rectangle.Height * Rectangle.Width;
   end Size;

end Graphics.Rectangle;
