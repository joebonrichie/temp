with Ada.Containers.Indefinite_Hashed_Maps;
pragma Elaborate_All (Ada.Containers.Indefinite_Hashed_Maps);

with Ada.Strings.Hash;

package String_Integer_Maps is
   new Ada.Containers.Indefinite_Hashed_Maps
    (String,
     Integer,
     Ada.Strings.Hash,
     "=");

pragma Preelaborate (String_Integer_Maps);





