with Ada.Containers.Ordered_Sets;
pragma Elaborate_All (Ada.Containers.Ordered_Sets);

with System; use type System.Address;

with Screen;

with Ada.Text_IO;  use Ada.Text_IO;

package body Shapes is

   use Ada.Containers;

   function "<" (L, R : Shape_Class_Access) return Boolean is
      pragma Inline ("<");
   begin
      return L.all'Address < R.all'Address;
   end;

   package Shape_Sets is
      new Ada.Containers.Ordered_Sets (Shape_Class_Access);

   Shape_Set : Shape_Sets.Set;

   use Shape_Sets;


   procedure Initialize (Control : in out Control_Type) is

      E : constant Shape_Class_Access :=
        Control.Shape.all'Unchecked_Access;
   begin
      Put ("shapes.set.length=");
      Put (Count_Type'Image (Length (Shape_Set)));
      Put_Line (" (before)");

      Insert (Shape_Set, E);
      pragma Assert (Contains (Shape_Set, E));

      Put ("shapes.set.length=");
      Put (Count_Type'Image (Length (Shape_Set)));
      Put_Line (" (after)");

      New_Line;
   end;


   procedure Finalize (Control : in out Control_Type) is

      E : constant Shape_Class_Access :=
        Control.Shape.all'Unchecked_Access;
   begin
      Put ("shapes.set.length=");
      Put (Count_Type'Image (Length (Shape_Set)));
      Put_Line (" (before)");

      Delete (Shape_Set, E);
      pragma Assert (not Contains (Shape_Set, E));

      Put ("shapes.set.length=");
      Put (Count_Type'Image (Length (Shape_Set)));
      Put_Line (" (after)");

      New_Line;
   end;


   procedure Stack
     (Shape     : in out Shape_Type'Class;
      On_Top_Of : in     Shape_Type'Class) is

      N : constant Point_Type := North (On_Top_Of);
      S : constant Point_Type := South (Shape);
   begin
      Move (Shape, DX => N.X - S.X, DY => N.Y - S.Y + 1);
   end;


   procedure Refresh is
      procedure Process (C : Cursor) is
         Shape : Shape_Type'Class renames Element (C).all;
      begin
         Draw (Shape);
      end;
   begin
      Screen.Clear;
      Iterate (Shape_Set, Process'Access);
      Screen.Refresh;
   end;


end Shapes;

