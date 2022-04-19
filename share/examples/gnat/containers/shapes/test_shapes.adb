with Screen_Types;       use Screen_Types;
with Shapes;             use Shapes;
with Shapes.Rectangles;  use Shapes.Rectangles;
with Shapes.Lines;       use Shapes.Lines;
--with Shapes.Refresh;
with Faces;              use Faces;
--with Shape_Vectors;      use Shape_Vectors;
--with Ada.Containers.Generic_Array_Sort;
with Ada.Containers.Generic_Anonymous_Array_Sort;

with Ada.Text_IO;          use Ada.Text_IO;
with Ada.Integer_Text_IO;  use Ada.Integer_Text_IO;

procedure Test_Shapes is

   Rect : aliased Rectangle_Type;
   Line : aliased Line_Type;
   Face : aliased Face_Type;

   type Shape_Array is
     array (Positive range <>) of access Shape_Type'Class;

   V : Shape_Array := (Rect'Access,
                       Line'Access,
                       Face'Access);

   procedure Output_West_X is
   begin

      for I in V'Range loop

         Put ("The x-coordinate of the west point of shape ");
         Put (I, Width => 0);
         Put (" is ");

         declare
            S : Shape_Type'Class renames V (I).all;
            W : constant Point_Type := West (S);
         begin
            Put (W.X, Width => 0);
         end;

         Put_Line (".");

      end loop;

   end Output_West_X;

begin

   Initialize (Rect, P0 => (0, 0), P1 => (10, 10));
   Initialize (Line, P0 => (0, 15), Length => 17);
   Initialize (Face, P0 => (15, 10), P1 => (27, 18));

   Shapes.Refresh;

   Move (Face, DX => -10, DY => -10);

   Shapes.Stack (Line, On_Top_Of => Face);
   Shapes.Stack (Rect, On_Top_Of => Line);

   Shapes.Refresh;

   for I in V'Range loop
      Move (V (I).all, DX => 20, DY => 0);
   end loop;

   Shapes.Refresh;

   New_Line;

   Output_West_X;

   Put_Line ("Sorting the shapes according to the " &
             "x-coordinate of their west points.");

   Sort_V:
   declare

      subtype Index_Subtype is Integer range V'Range;

      function Less (I, J : Index_Subtype) return Boolean is
         IW : constant Point_Type := West (V (I).all);
         JW : constant Point_Type := West (V (J).all);
      begin
         return IW.X < JW.X;
      end;

      procedure Swap (I, J : Index_Subtype) is
         E : Shape_Type'Class renames V (I).all;
      begin
         V (I) := V (J);
         V (J) := E'Access;
      end;

--        procedure Sort is
--           new Ada.Containers.Generic_Array_Sort
--            (Positive,
--             access Shape_Type'Class,
--             Shape_Array);

      procedure Sort is
         new Ada.Containers.Generic_Anonymous_Array_Sort (Index_Subtype);
   begin
      Sort (V'First, V'Last);
   end Sort_V;

   Put_Line ("After sorting:");

   Output_West_X;

   New_Line;

end Test_Shapes;



