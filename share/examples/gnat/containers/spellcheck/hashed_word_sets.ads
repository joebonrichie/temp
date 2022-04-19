--with Ada.Strings.Hash;
with Hash_Word;

with Ada.Containers.Indefinite_Hashed_Sets;
pragma Elaborate_All (Ada.Containers.Indefinite_Hashed_Sets);

package Hashed_Word_Sets is new Ada.Containers.Indefinite_Hashed_Sets
  (Element_Type        => String,
   Hash                => Hash_Word, --Ada.Strings.Hash,
   Equivalent_Elements => "=");

pragma Preelaborate (Hashed_Word_Sets);

