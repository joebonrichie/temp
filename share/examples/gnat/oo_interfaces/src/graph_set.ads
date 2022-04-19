
with Ada.Containers.Indefinite_Ordered_Multisets;

with Graphics; use Graphics;
with Sortable; use Sortable;

package Graph_Set is
  new Ada.Containers.Indefinite_Ordered_Multisets (Graphics.Object'Class);
