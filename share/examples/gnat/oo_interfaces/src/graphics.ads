
with Ada.Finalization;

with Drawable;
with Sortable;

package Graphics is

   type Object is abstract new Ada.Finalization.Controlled
     and Drawable.Facet
     and Sortable.Facet with private;

   function Label (O : in Object) return String is abstract;

   procedure Set_Name (O : in out Object'Class; Name : in String);

   function Get_Name (O : in Object'Class) return String;

   function "<" (O1, O2 : in Object'Class) return Boolean;
   --  We can implement this function as all SD_Object are implementing the
   --  Sortable interface. It means that the size of every object can be
   --  computed.

private

   type String_Access is access String;

   type Object is abstract new Ada.Finalization.Controlled
     and Drawable.Facet
     and Sortable.Facet
   with record
      Name : String_Access;
   end record;

   procedure Finalize (O : in out Object);
   procedure Adjust (O : in out Object);

   --  Helper routines used by children

   procedure Draw_Line (Size : in Natural);

   procedure Draw_Side (Size : in Natural);

end Graphics;
