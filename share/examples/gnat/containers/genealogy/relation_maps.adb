with Data_Maps;    use Data_Maps;
with Ada.Text_IO;  use Ada.Text_IO;

package body Relation_Maps is

   function Compare_Dates (L, R : Data_Maps.Cursor) return Boolean is
      Result : Boolean;

      procedure Process_L (L_Name : in String; L_Date : in String) is
         procedure Process_R (R_Name : in String; R_Date : in String) is
         begin
            Result := L_Date < R_Date;
         end;
      begin
         Query_Element (R, Process_R'Access);
      end;
   begin
      Query_Element (L, Process_L'Access);
      return Result;
   end;

   function Compare_Dates (L_Name, R_Name : String) return Boolean is
      --pragma Debug (Put_Line ("compare_dates: l=" & L_Name & " r=" & R_Name));

      --NOTE:
      --This is weird if this is a set of advisors.  The names are
      --ordered by date, but an advisor doesn't necessarily appear in the
      --Dates map.  We can either automatically insert the advisor name
      --into the Dates map with a null date string (as is done in the
      --Musser example), or just treat "not in map" as having a lesser
      --value than "in map" for purposes of comparison.
      --ENDNOTE.

      LC : constant Data_Maps.Cursor := Find (Dates, L_Name);
      RC : constant Data_Maps.Cursor := Find (Dates, R_Name);
   begin
      if Has_Element (LC) then
         if Has_Element (RC) then
            return Compare_Dates (LC, RC);
         end if;

         return False;
      end if;

      if Has_Element (RC) then
         return True;
      end if;

      return False;
   end Compare_Dates;


   package Sorting is
      new String_Case_Insensitive_Vectors.Generic_Sorting (Compare_Dates);


   function Length (Container : Set) return Ada.Containers.Count_Type is
      Result : Ada.Containers.Count_Type;

      procedure Process (S : String; V : String_Case_Insensitive_Vectors.Vector) is
      begin
         Result := String_Case_Insensitive_Vectors.Length (V);
      end;
   begin
      Map_Types.Query_Element (Map_Types.Cursor (Container), Process'Access);
      return Result;
   end;



   procedure Insert
     (Container : Map;
      Key       : String) is

      C : Map_Types.Cursor;
      B : Boolean;
   begin
      Map_Types.Insert
        (Container => Container.all,
         Key       => Key,
         New_Item  => String_Case_Insensitive_Vectors.Empty_Vector,
         Position  => C,
         Inserted  => B);
   end;


   function Insert
     (Container : Map;
      Key       : String) return Set is

      C : Map_Types.Cursor;
      B : Boolean;
   begin
      Map_Types.Insert
        (Container => Container.all,
         Key       => Key,
         New_Item  => String_Case_Insensitive_Vectors.Empty_Vector,
         Position  => C,
         Inserted  => B);

      return Set (C);
   end;


--     function Element
--       (Container : Map;
--        Name      : String) return Set is

--        C : Map_Types.Cursor;
--        B : Boolean;
--     begin
--        Map_Types.Insert
--          (Container => Container.all,
--           Key       => Name,
--           New_Item  => String_Case_Insensitive_Vectors.Empty_Vector,
--           Position  => C,
--           Inserted  => B);

--        return Set (C);
--     end Element;


   function Element
     (Container : Map;
      Key       : String) return Set is

      C : constant Map_Types.Cursor :=
        Map_Types.Find (Container.all, Key);

      pragma Assert (Map_Types.Has_Element (C));
   begin
      return Set (C);
   end Element;


   procedure Iterate
     (Container : Map;
      Key       : String;
      Process   : not null access procedure (Name : in String)) is

      procedure Vector_Iterate_Process (C : String_Case_Insensitive_Vectors.Cursor) is
      begin
         String_Case_Insensitive_Vectors.Query_Element (C, Process);
      end;

      procedure Map_Query_Process (K : String; V : String_Case_Insensitive_Vectors.Vector) is
      begin
         String_Case_Insensitive_Vectors.Iterate (V, Vector_Iterate_Process'Access);
      end;

      C : constant Map_Types.Cursor := Map_Types.Find (Container.all, Key);

   begin

      if Map_Types.Has_Element (C) then
         Map_Types.Query_Element (C, Map_Query_Process'Access);
      end if;

   end Iterate;



   procedure Insert
     (Container : Map;
      Key       : String;
      New_Name  : String) is

      procedure Process
        (K : in     String;
         V : in out String_Case_Insensitive_Vectors.Vector) is
      begin
         Append (V, New_Name);
         Sorting.Sort (V);
         --NOTE:
         --Sort for a vector isn't stable, so this sort may change
         --the relative order of strings that were already in the vector.
         --If this is an issue, then we can use the list, whose sort is
         --stable.
         --
         --Of course, using a vector (or list) this way is simply a
         --way to work around the lack of a multiset.  However, even if
         --the library provided a multiset, a vector may still be
         --attractive since it has a lower storage overhead.  An
         --indefinite vector is even more attractive, since sorting just
         --swaps pointers; it doesn't actually copy elements.  (Indeed,
         --if your generic actual element type is definite, you might
         --still prefer an indefinite vector for that reason.)
         --ENDNOTE.
      end;

      C : Map_Types.Cursor;
      B : Boolean;

   begin

      Map_Types.Insert
        (Container => Container.all,
         Key       => Key,
         New_Item  => String_Case_Insensitive_Vectors.Empty_Vector,
         Position  => C,
         Inserted  => B);

      Map_Types.Update_Element (Container.all, C, Process'Access);

   end Insert;


   procedure Insert
     (Container : Map;
      Cursor    : Set;
      New_Name  : String) is

      procedure Process
        (K : in     String;
         V : in out String_Case_Insensitive_Vectors.Vector) is
      begin
         Append (V, New_Name);
         Sorting.Sort (V);  --NOTE: see note above.
      end;

      C : constant Map_Types.Cursor := Map_Types.Cursor (Cursor);

   begin

      Map_Types.Update_Element (Container.all, C, Process'Access);

   end Insert;


   procedure Iterate
     (Container : in Map;
      Process   : not null access procedure (Key : in String; Elements : in Set)) is

      procedure Iterate_Process (C : Map_Types.Cursor) is
         procedure Query_Process (S : String; V : String_Case_Insensitive_Vectors.Vector) is
            pragma Warnings (Off, V);
         begin
            Process (S, Set (C));
         end;
      begin
         --Process (Name => Map_Types.Key (C), Elements => Set (C));
         Map_Types.Query_Element (C, Query_Process'Access);
      end;
   begin
      Map_Types.Iterate (Container.all, Iterate_Process'Access);
   end;


   procedure Iterate
     (Container : in Set;
      Process   : not null access procedure (Name : in String)) is

      procedure Iterate_Process (C : String_Case_Insensitive_Vectors.Cursor) is
      begin
         Query_Element (C, Process);
      end;

      procedure Query_Process (S : in String; V : String_Case_Insensitive_Vectors.Vector) is
      begin
         String_Case_Insensitive_Vectors.Iterate (V, Iterate_Process'Access);
      end;
   begin
      Map_Types.Query_Element (Map_Types.Cursor (Container), Query_Process'Access);
   end;


   function First (Container : Set) return Set_Cursor is
      Result : String_Case_Insensitive_Vectors.Cursor;

      procedure Process (S : String; V : String_Case_Insensitive_Vectors.Vector) is
      begin
         Result := First (V);
      end;
   begin
      Map_Types.Query_Element (Map_Types.Cursor (Container), Process'Access);
      return Set_Cursor (Result);
   end;


   function First_Element (Container : Set) return String is
      Result : String_Case_Insensitive_Vectors.Cursor;

      procedure Process (S : String; V : String_Case_Insensitive_Vectors.Vector) is
      begin
         Result := First (V);
      end;
   begin
      Map_Types.Query_Element (Map_Types.Cursor (Container), Process'Access);
      return String_Case_Insensitive_Vectors.Element (Result);
   end;


   procedure Next (Position : in out Set_Cursor) is
   begin
      String_Case_Insensitive_Vectors.Next (String_Case_Insensitive_Vectors.Cursor (Position));
   end;


   function Has_Element (Position : Set_Cursor) return Boolean is
      C : constant String_Case_Insensitive_Vectors.Cursor := String_Case_Insensitive_Vectors.Cursor (Position);
   begin
      return String_Case_Insensitive_Vectors.Has_Element (C);
   end;


   function Element (Position : Set_Cursor) return String is
      C : constant String_Case_Insensitive_Vectors.Cursor := String_Case_Insensitive_Vectors.Cursor (Position);
   begin
      return String_Case_Insensitive_Vectors.Element (C);
   end;


   function Contains
     (Container : Set;
      Name      : String) return Boolean is

      Result : Boolean;

      procedure Process (S : String; V : String_Case_Insensitive_Vectors.Vector) is
      begin
         Result := String_Case_Insensitive_Vectors.Contains (V, Name);
         --TODO: V is sorted, so use a binary search.
      end;
   begin
      Map_Types.Query_Element (Map_Types.Cursor (Container), Process'Access);
      return Result;
   end;


   Students_Map : aliased Map_Types.Map;
   Advisors_Map : aliased Map_Types.Map;

   function Students return Map is
   begin
      return Students_Map'Access;
   end;

   function Advisors return Map is
   begin
      return Advisors_Map'Access;
   end;


end Relation_Maps;

