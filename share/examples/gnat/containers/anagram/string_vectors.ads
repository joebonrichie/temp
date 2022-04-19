with Ada.Containers.Indefinite_Vectors;
pragma Elaborate_All (Ada.Containers.Indefinite_Vectors);

package String_Vectors is
   new Ada.Containers.Indefinite_Vectors (Positive, String);

pragma Preelaborate (String_Vectors);
