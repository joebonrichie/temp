with Ada.Containers.Indefinite_Ordered_Sets;
pragma Elaborate_All (Ada.Containers.Indefinite_Ordered_Sets);

package Ordered_Word_Sets is
   new Ada.Containers.Indefinite_Ordered_Sets (String);

pragma Preelaborate (Ordered_Word_Sets);
