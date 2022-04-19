with Ada.Containers.Vectors;
pragma Elaborate_All (Ada.Containers.Vectors);

with Wordcount_Maps;  use Wordcount_Maps;

package Wordcount_Vectors is
   new Ada.Containers.Vectors
    (Index_Type   => Positive,
     Element_Type => Cursor);

pragma Preelaborate (Wordcount_Vectors);
