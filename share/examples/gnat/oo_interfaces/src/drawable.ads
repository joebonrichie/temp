
package Drawable is

   type Facet is interface;

   procedure Draw (Object : in Facet) is abstract;
   --  Draw an object

end Drawable;
