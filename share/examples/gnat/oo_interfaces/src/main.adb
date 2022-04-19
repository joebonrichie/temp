
--  This example illustrate usage of some new Ada 2005 features:
--  * Interfaces
--  * Use of the Object.Method notation
--  * Use of Ada.Containers.Indefinite_Ordered_Multisets

with Ada.Text_IO;
with Ada.Integer_Text_IO;

with Graphics.Square;
with Graphics.Rectangle;
with Graph_Set;
with Drawable;
with Sortable;

procedure Main is

   use Ada;
   use Ada.Text_IO;
   use Ada.Integer_Text_IO;
   use Graphics;

   G_Set  : Graph_Set.Set;
   Cursor : Graph_Set.Cursor;

   procedure Get_Num (Num : out Natural);
   --  Get a number from the keyboard

   -------------
   -- Get_Num --
   -------------

   procedure Get_Num (Num : out Natural) is
   begin
      loop
         begin
            Get (Num);
            exit;
         exception
            when others =>
               Put_Line ("A size must be positive.");
         end;
      end loop;
   end Get_Num;

begin
   --  We create a set of object and insert them into the sorted set

   New_Line;
   Put_Line ("First let's create 3 square...");

   declare
      Square_Size : Natural;
      S           : Square.Object;
   begin
      for K in 1 .. 3 loop
         Put ("Enter size of square" &
              Natural'Image (K) & " (above 3 is better) : ");

         Get_Num (Square_Size);

         S := Square.Object'(Object with Side => Square_Size);
         Set_Name (S, "square" & Natural'Image (K));

         Graph_Set.Insert (G_Set, S);
      end loop;
   end;

   New_Line;
   Put_Line ("Now let's create 3 rectangle...");

   declare
      Rec_Height, Rec_Width : Natural;
      R                     : Rectangle.Object;
   begin
      for K in 1 .. 3 loop
         Put ("Enter height of rectangle" &
              Natural'Image (K) & " (above 3 is better) : ");
         Get_Num (Rec_Height);

         Put ("Enter width of rectangle" &
              Natural'Image (K) & " (above 3 is better)  : ");
         Get_Num (Rec_Width);

         R := Rectangle.Object'(Object with Rec_Height, Rec_Width);
         Set_Name (R, "rectangle" & Natural'Image (K));

         Graph_Set.Insert (G_Set, R);
      end loop;
   end;

   --  Now let's display all objects from the set

   New_Line;
   Put_Line ("Display graphical objects ordered base on the surface...");
   New_Line;

   Cursor := Graph_Set.First (G_Set);

   while Graph_Set.Has_Element (Cursor) loop
      Put_Line (Graph_Set.Element (Cursor).Label);
      Graph_Set.Element (Cursor).Draw;
      Graph_Set.Next (Cursor);
   end loop;
end Main;
