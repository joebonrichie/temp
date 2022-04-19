package body Data_Maps is

   procedure Insert
     (Container : in     Map;
      Name      : in     String;
      New_Item  : in     String;
      Position  :    out Cursor;
      Inserted  :    out Boolean) is
   begin
      Map_Types.Insert 
        (Container => Container.all,
         Key       => Name,
         New_Item  => New_Item,
         Position  => Map_Types.Cursor (Position),
         Inserted  => Inserted);
   end;


   function Find
     (Container : Map;
      Name      : String) return Cursor is
      
      Result : constant Map_Types.Cursor := 
        Map_Types.Find (Container.all, Name);
   begin
      return Cursor (Result);
   end;
      


   procedure Query_Element
     (Position : in Cursor;
      Process  : not null access procedure (K, E : in String)) is
   begin
      Query_Element (Cursor_Rep (Position), Process);
   end;



   function Equivalent_Names (L, R : Cursor) return Boolean is
   begin
      return Equivalent_Keys (Cursor_Rep (L), Cursor_Rep (R));
   end;


   function Equivalent_Elements (L : Cursor; R : String) return Boolean is
      Result : Boolean;
      
      procedure Process_L (LK, LE : String) is
      begin
         Result := Ada.Strings.Equal_Case_Insensitive (LE, R);
      end;
   begin
      Query_Element (L, Process_L'Access);
      return Result;
   end;
   


   function Name (Position : Cursor) return String is
   begin
      return Key (Cursor_Rep (Position));
   end;


   function Element (Position : Cursor) return String is
   begin
      return Element (Cursor_Rep (Position));
   end;


   function Has_Element (Position : Cursor) return Boolean is
   begin
      return Position /= No_Element;
   end;


   function Element
     (Container : Map;
      Name      : String) return String is
   begin
      return Map_Types.Element (Container.all, Name);
   end;


   Dates_Map  : aliased Map_Types.Map;
   Places_Map : aliased Map_Types.Map;

   function Dates return Map is
   begin
      return Dates_Map'Access;
   end;
   
   function Places return Map is
   begin
      return Places_Map'Access;
   end;
   
end Data_Maps;
