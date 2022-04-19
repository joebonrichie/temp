with Ada.Containers.Indefinite_Hashed_Maps;
pragma Elaborate_All (Ada.Containers.Indefinite_Hashed_Maps);

with Ada.Strings.Equal_Case_Insensitive;
with Ada.Strings.Hash_Case_Insensitive;

package Data_Maps is
   pragma Elaborate_Body;

   type Map (<>) is limited private;

   type Cursor is private;

   No_Element : constant Cursor;

   function Has_Element (Position : Cursor) return Boolean;

   procedure Insert
     (Container : in     Map;
      Name      : in     String;
      New_Item  : in     String;
      Position  :    out Cursor;
      Inserted  :    out Boolean);

   function Find
     (Container : Map;
      Name      : String) return Cursor;

   function Element
     (Container : Map;
      Name      : String) return String;

   procedure Query_Element
     (Position : in Cursor;
      Process  : not null access procedure (K, E : in String));

   function Name (Position : Cursor) return String;  --key
   function Element (Position : Cursor) return String;  --date or place

   function Equivalent_Names (L, R : Cursor) return Boolean;
   function Equivalent_Elements (L : Cursor; R : String) return Boolean;

   function Dates return Map;
   function Places return Map;

private

   package Map_Types is
     new Ada.Containers.Indefinite_Hashed_Maps
      (String,
       String,
       Ada.Strings.Hash_Case_Insensitive,
       Ada.Strings.Equal_Case_Insensitive);

   type Map is access all Map_Types.Map;
   for Map'Storage_Size use 0;

   type Cursor_Rep is new Map_Types.Cursor;
   type Cursor is new Cursor_Rep;

   No_Element : constant Cursor := Cursor (Map_Types.No_Element);

end Data_Maps;
