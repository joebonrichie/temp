
package Graphics.Square is

   type Object is new Graphics.Object with record
      Side : Natural;
   end record;

   function Label (Square : in Object) return String;

   procedure Draw (Square : in Object);
   --  Must be implemented as part of the Drawable facet

   function Size (Square : in Object) return Natural;
   --  Must be implemented as part of the Sortable facet

end Graphics.Square;
