with Ada.Containers.Indefinite_Vectors;
pragma Elaborate_All (Ada.Containers.Indefinite_Vectors);

with Ada.Strings.Equal_Case_Insensitive;

package String_Case_Insensitive_Vectors is
  new Ada.Containers.Indefinite_Vectors
    (Positive,
     String,
     Ada.Strings.Equal_Case_Insensitive);

pragma Preelaborate (String_Case_Insensitive_Vectors);
