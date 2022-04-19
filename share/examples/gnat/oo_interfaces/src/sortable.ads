
package Sortable is

   type Facet is interface;

   function Size (Object : in Facet) return Natural is abstract;

end Sortable;
