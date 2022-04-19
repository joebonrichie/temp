with Ada.Containers.Indefinite_Vectors;
pragma Elaborate_All (Ada.Containers.Indefinite_Vectors);

package Anagram_Types is
   pragma Preelaborate;

   type Pair_Type (Length : Positive) is
      record
         Sorted : String (1 .. Length);
         Word   : String (1 .. Length);
      end record;

   package Pair_Vectors is
      new Ada.Containers.Indefinite_Vectors (Positive, Pair_Type);

end Anagram_Types;
