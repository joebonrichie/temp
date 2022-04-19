
package Graphics.Rectangle is

   type Object is new Graphics.Object with record
      Height, Width : Natural;
   end record;

   function Label (Rectangle : in Object) return String;

   procedure Draw (Rectangle : in Object);
   --  Must be implemented as part of the Drawable facet

   function Size (Rectangle : in Object) return Natural;
   --  Must be implemented as part of the Sortable facet

end Graphics.Rectangle;
