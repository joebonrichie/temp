-----------------------------------------
--
--  Copyright (C) 2013, AdaCore
--
-----------------------------------------

package body Bounded_Dynamic_Arrays is

   ------------
   -- Length --
   ------------

   function Length (This : Sequence) return Natural_Index is
   begin
      return This.Current_Length;
   end Length;

   ----------------
   -- Set_Length --
   ----------------

   procedure Set_Length (This : in out Sequence;  To : in Natural_Index) is
   begin
      This.Current_Length := To;
   end Set_Length;

   -----------
   -- Value --
   -----------

   function Value (This : Sequence) return List is
   begin
      return This.Content (1 .. This.Current_Length);
   end Value;

   -----------
   -- Value --
   -----------

   function Value (This : Sequence;  Location : Index) return Component is
   begin
      return This.Content (Location);
   end Value;

   -----------
   -- Empty --
   -----------

   function Empty (This : Sequence) return Boolean is
   begin
      return This.Current_Length = 0;
   end Empty;

   ---------
   -- "=" --
   ---------

   function "=" (Left, Right : Sequence) return Boolean is
   begin
      return Value (Left) = Value (Right);
   end "=";

   -----------
   -- Clear --
   -----------

   procedure Clear (This : out Sequence) is
   begin
      This.Current_Length := 0;
   end Clear;

   --------------
   -- Instance --
   --------------

   function Instance (Content : List; Capacity : Index) return Sequence is
      Result : Sequence (Capacity);
   begin
      Result.Current_Length := Content'Length;
      Result.Content (1 .. Result.Current_Length) := Content;
      return Result;
   end Instance;

   --------------
   -- Instance --
   --------------

   function Instance (Content : List) return Sequence is
   begin
      return Instance (Content, Capacity => Content'Length);
   end Instance;

   --------------
   -- Instance --
   --------------

   function Instance (C : Component; Capacity : Index) return Sequence is
      Result : Sequence (Capacity);
   begin
      Result.Current_Length := 1;
      Result.Content (1) := C;
      return Result;
   end Instance;

   ---------
   -- "&" --
   ---------

   function "&" (Left : Sequence; Right : Sequence) return Sequence is
      Required : constant Index := Left.Current_Length + Right.Current_Length;
      Result   : Sequence (Capacity => Required);
   begin
      Result.Current_Length := Required;
      Result.Content (1 .. Required) := Value (Left) & Value (Right);
      return Result;
   end "&";

   ---------
   -- "&" --
   ---------

   function "&" (Left : Sequence; Right : List) return Sequence is
      Required : constant Index := Left.Current_Length + Right'Length;
      Result   : Sequence (Capacity => Required);
   begin
      Result.Current_Length := Required;
      Result.Content (1 .. Required) := Value (Left) & Right;
      return Result;
   end "&";

   ---------
   -- "&" --
   ---------

   function "&" (Left : List; Right : Sequence) return Sequence is
      Required : constant Index := Left'Length + Right.Current_Length;
      Result   : Sequence (Capacity => Required);
   begin
      Result.Current_Length := Required;
      Result.Content (1 .. Required) := Left & Value (Right);
      return Result;
   end "&";

   ---------
   -- "&" --
   ---------

   function "&" (Left : Sequence; Right : Component) return Sequence is
      Required : constant Index := Left.Current_Length + 1;
      Result   : Sequence (Capacity => Required);
   begin
      Result.Current_Length := Required;
      Result.Content (1 .. Required) := Value (Left) & Right;
      return Result;
   end "&";

   ---------
   -- "&" --
   ---------

   function "&" (Left : Component; Right : Sequence) return Sequence is
      Required : constant Index := 1 + Right.Current_Length;
      Result   : Sequence (Capacity => Required);
   begin
      Result.Current_Length := Required;
      Result.Content := Left & Value (Right);
      return Result;
   end "&";

   ----------
   -- Copy --
   ----------

   procedure Copy (Source : in Sequence; To : out Sequence) is
      Target : Sequence renames To;
      subtype Current_Range is Index range 1 .. Source.Current_Length;
   begin
      Target.Content (Current_Range) := Source.Content (Current_Range);
      Target.Current_Length := Source.Current_Length;
   end Copy;

   ----------
   -- Copy --
   ----------

   procedure Copy (Source : in List; To : out Sequence) is
      Target : Sequence renames To;
   begin
      Target.Current_Length := Source'Length;
      Target.Content (1 .. Source'Length) := Source;
   end Copy;

   ----------
   -- Copy --
   ----------

   procedure Copy (Source : in Component; To : out Sequence) is
      Target : Sequence renames To;
   begin
      Target.Content (1) := Source;
      Target.Current_Length := 1;
   end Copy;

   ------------
   -- Append --
   ------------

   procedure Append (Tail : in Sequence; To : in out Sequence) is
      New_Length : constant Index := Length (Tail) + To.Current_Length;
   begin
      To.Content (1 .. New_Length) := Value (To) & Value (Tail);
      To.Current_Length := New_Length;
   end Append;

   ------------
   -- Append --
   ------------

   procedure Append (Tail : in List; To : in out Sequence) is
      New_Length : constant Index := Tail'Length + To.Current_Length;
   begin
      To.Content (1 .. New_Length) := Value (To) & Tail;
      To.Current_Length := New_Length;
   end Append;

   ------------
   -- Append --
   ------------

   procedure Append (Tail : in Component; To : in out Sequence) is
      New_Length : constant Index := 1 + To.Current_Length;
   begin
      To.Content (New_Length) := Tail;
      To.Current_Length := New_Length;
   end Append;

   ------------
   -- Ammend --
   ------------

   procedure Ammend (This : in out Sequence;  By : in Sequence;  Start : in Index) is
      New_Last : constant Index := Start + Length (By) - 1;
   begin
      This.Content (Start .. New_Last) := Value (By);
   end Ammend;

   ------------
   -- Ammend --
   ------------

   procedure Ammend (This : in out Sequence;  By : in List;  Start : in Index) is
      New_Last : constant Index := Start + By'Length - 1;
   begin
      This.Content (Start .. New_Last) := By;
   end Ammend;

   ------------
   -- Ammend --
   ------------

   procedure Ammend (This : in out Sequence;  By : in Component;  Start : in Index) is
   begin
      This.Content (Start) := By;
   end Ammend;

   --------------
   -- Location --
   --------------

   function Location (Fragment : Sequence; Within : Sequence) return Natural_Index is
   begin
      return Location (Value (Fragment), Within);
   end Location;

   --------------
   -- Location --
   --------------

   function Location (Fragment : List; Within : Sequence) return Natural_Index is
      Len    : constant Natural_Index := Fragment'Length;
      Result : Natural_Index := 0;
   begin
      --  We have to check for the empty Fragment since that would be found but
      --  we want to return zero in that case. It would be found because, on the
      --  first iteration with K = 1, the condition in the if-statement would be
      --  computing a null string on the LHS of the comparison, and that would
      --  equal the RHS.
      if Len /= 0 then
         for K in 1 .. (Within.Current_Length - Len - 1) loop
            if Within.Content (K .. (K + Len - 1)) = Fragment then
               Result := K;
               exit;
            end if;
         end loop;
      end if;
      return Result;
   end Location;

   --------------
   -- Location --
   --------------

   function Location (Fragment : Component; Within : Sequence) return Natural_Index is
      Result : Natural_Index := 0;
   begin
      for K in 1 .. Within.Current_Length loop
         if Within.Content (K) = Fragment then
            Result := K;
            exit;
         end if;
      end loop;
      return Result;
   end Location;

end Bounded_Dynamic_Arrays;
