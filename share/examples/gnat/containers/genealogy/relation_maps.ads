with Ada.Containers.Ordered_Maps;
pragma Elaborate_All (Ada.Containers.Ordered_Maps);

with Ada.Containers.Indefinite_Ordered_Maps;
pragma Elaborate_All (Ada.Containers.Indefinite_Ordered_Maps);

with Ada.Containers.Indefinite_Vectors;
pragma Elaborate_All (Ada.Containers.Indefinite_Vectors);

with Ada.Strings.Equal_Case_Insensitive;
with Ada.Strings.Less_Case_Insensitive;

package Relation_Maps is
   pragma Elaborate_Body;

   type Map (<>) is limited private;
   type Set (<>) is limited private;

   type Set_Cursor is private;

   procedure Insert
     (Container : Map;
      Key       : String);  --make empty set for key

   function Insert
     (Container : Map;
      Key       : String) return Set;

   function Element
     (Container : Map;
      Key       : String) return Set;

   procedure Iterate
     (Container : in Map;
      Process   : not null access procedure (Key : in String; Elements : in Set));

   procedure Iterate
     (Container : Map;
      Key       : String;
      Process   : not null access procedure (Name : in String));




   procedure Insert       --map[key].insert(new_name)
     (Container : Map;
      Key       : String;
      New_Name  : String);

   procedure Insert
     (Container : Map;
      Cursor    : Set;
      New_Name  : String);

   function Contains
     (Container : Set;
      Name      : String) return Boolean;

   function First (Container : Set) return Set_Cursor;

   function First_Element (Container : Set) return String;

   procedure Next (Position : in out Set_Cursor);

   function Has_Element (Position : Set_Cursor) return Boolean;

   function Element (Position : Set_Cursor) return String;

   function Length (Container : Set) return Ada.Containers.Count_Type;

   procedure Iterate
     (Container : in Set;
      Process   : not null access procedure (Name : in String));


   function Students return Map;
   function Advisors return Map;

private

   package String_Case_Insensitive_Vectors is
      new Ada.Containers.Indefinite_Vectors
       (Positive,
        String,
        Ada.Strings.Equal_Case_Insensitive);

   use String_Case_Insensitive_Vectors;

   package Map_Types is
     new Ada.Containers.Indefinite_Ordered_Maps
       (String,
        String_Case_Insensitive_Vectors.Vector,
        Ada.Strings.Less_Case_Insensitive);

   type Map is access all Map_Types.Map;
   for Map'Storage_Size use 0;

   type Set is new Map_Types.Cursor;

   type Set_Cursor is new String_Case_Insensitive_Vectors.Cursor;

end Relation_Maps;

