-----------------------------------------
--
--  Copyright (C) 2013, AdaCore
--
-----------------------------------------

generic
   type Component is private;
   type List_Index is range <>;
   type List is array (List_Index range <>) of Component;
package Bounded_Dynamic_Arrays is

   pragma Pure;

   pragma Compile_Time_Error (1 not in List_Index, "List_Index must include the value 1");
   --  We are using a 1-based array representation

   Maximum_Length : constant List_Index := List_Index'Last;
   --  The physical maximum for the upper bound of the wrapped List array
   --  values.  Defined for readability in predicates.

   subtype Index is List_Index range 1 .. Maximum_Length;

   type Sequence (Capacity : Index) is private;
   --  A wrapper for List array values in which Capacity represents the physical
   --  upper bound. Capacity is also the maximum number of Component values
   --  contained by the given Sequence instance.

   subtype Natural_Index is List_Index'Base range 0 .. Maximum_Length;

   function Length (This : Sequence) return Natural_Index with
     Inline;
   --  Returns the logical length of This, i.e., the length of the slice of This
   --  that is currently assigned a value.

   procedure Set_Length (This : in out Sequence;  To : in Natural_Index) with
     Pre  => To <= This.Capacity,
     Post => Length (This) = To,
     Inline;

   Void : constant List (List_Index'First .. List_Index'First - 1) := (others => <>);
   --  The null List array value.

   function Value (This : Sequence) return List with
     Post => (if Empty (This) then Value'Result = Void else Value'Result /= Void),
     Inline;
   --  Returns the content of this sequence. The value returned is the "logical"
   --  value in that only that slice which is currently assigned is returned, as
   --  opposed to the entire physical representation.

   function Value (This : Sequence;  Location : Index) return Component with
     Pre => Location <= Length (This),
     Inline;

   function Empty (This : Sequence) return Boolean with
     Inline;
   --  Returns whether the logical value of the given sequence equals Void.

   procedure Clear (This : out Sequence) with
     Post => Length (This) = 0 and Empty (This),
     Inline;
   --  Sets the given sequence to contain nothing.

   function "=" (Left, Right : Sequence) return Boolean with
     Inline;
   --  Returns whether the (logical) values of the two sequences are identical.

   function Instance (Content : List;  Capacity : Index) return Sequence with
     Pre  => Content'Length <= Capacity,
     Post => Value (Instance'Result) = Content and
             Instance'Result.Capacity = Capacity,
     Inline;
   --  Returns a newly created Sequence object with the given attributes.

   function Instance (C : Component; Capacity : Index) return Sequence with
     Pre  => Capacity > 0,
     Post => Value (Instance'Result) (1) = C and
             Instance'Result.Capacity = Capacity,
     Inline;
   --  Returns a newly created Sequence object with the given attributes.

   function Instance (Content : List) return Sequence with
     Pre  => Content'Length <= Maximum_Length,
     Post => Value (Instance'Result) = Content and
             Instance'Result.Capacity = Content'Length,
     Inline;
   --  Returns a newly created Sequence object with the given attribute.

   function "&" (Left : Sequence; Right : Sequence) return Sequence with
     Pre  => Length (Left) + Length (Right) <= Maximum_Length,
     Post => Value ("&"'Result) = Value (Left) & Value (Right) and
             Length ("&"'Result) = Length (Left) + Length (Right) and
             "&"'Result.Capacity = Length (Left) + Length (Right),
     Inline;

   function "&" (Left : Sequence; Right : List) return Sequence with
     Pre  => Length (Left) + Right'Length <= Maximum_Length,
     Post => Value ("&"'Result) = Value (Left) & Right and
             Length ("&"'Result) = Length (Left) + Right'Length and
             "&"'Result.Capacity = Length (Left) + Right'Length,
     Inline;

   function "&" (Left : List; Right : Sequence) return Sequence with
     Pre  => Left'Length + Length (Right) <= Maximum_Length,
     Post => Value ("&"'Result) = Left & Value (Right) and
             Length ("&"'Result) = Left'Length + Length (Right) and
             "&"'Result.Capacity = Left'Length + Length (Right),
     Inline;

   function "&" (Left : Sequence; Right : Component) return Sequence with
     Pre  => Length (Left) + 1 <= Maximum_Length,
     Post => Value ("&"'Result) = Value (Left) & Right and
             Length ("&"'Result) = Length (Left) + 1 and
             "&"'Result.Capacity = Length (Left) + 1,
     Inline;

   function "&" (Left : Component; Right : Sequence) return Sequence with
     Pre  => 1 + Length (Right) <= Maximum_Length,
     Post => Value ("&"'Result) = Left & Value (Right) and
             Length ("&"'Result) = 1 + Length (Right) and
             "&"'Result.Capacity = 1 + Length (Right),
     Inline;

   procedure Copy (Source : in Sequence; To : out Sequence) with
     Pre  => To.Capacity >= Length (Source),
     Post => Value (To) = Value (Source) and
             Length (To) = Length (Source),
     Inline;
   --  Copies the logical value of Source, the RHS, to the LHS sequence To. The
   --  prior value of To is lost.

   procedure Copy (Source : in List; To : out Sequence) with
     Pre  => To.Capacity >= Source'Length,
     Post => Value (To) = Source and
             Length (To) = Source'Length,
     Inline;
   --  Copies the value of the array Source, the RHS, to the LHS sequence To.
   --  The prior value of To is lost.

   procedure Copy (Source : in Component; To : out Sequence) with
     Pre  => To.Capacity > 0,
     Post => Value (To) (1) = Source and
             Length (To) = 1,
     Inline;
   --  Copies the value of the individual array component Source, the RHS, to
   --  the LHS sequence To. The prior value of To is lost.

   procedure Append (Tail : in Sequence; To : in out Sequence) with
     Pre  => Length (Tail) + Length (To) <= Maximum_Length,
     Post => Value (To) = Value (To)'Old & Value (Tail) and
             Length (To) = Length (To)'Old + Length (Tail),
     Inline;

   procedure Append (Tail : in List;  To : in out Sequence) with
     Pre  => Tail'Length + Length (To) <= Maximum_Length,
     Post => Value (To) = Value (To)'Old & Tail and
             Length (To) = Length (To)'Old + Tail'Length,
     Inline;

   procedure Append (Tail : in Component;  To : in out Sequence) with
     Pre  => 1 + Length (To) <= Maximum_Length,
     Post => Value (To) = Value (To)'Old & Tail and
             Length (To) = Length (To)'Old + 1,
     Inline;

   procedure Ammend (This : in out Sequence; By : in Sequence; Start : in Index) with
     Pre  => Start + Length (By) - 1 <= This.Capacity,
     Post => Value (This) (Start .. Start + Length (By) - 1) = Value (By),
     Inline;
   --  Changes the slice of This, beginning at array index Start, to the current
   --  logical value of sequence By

   procedure Ammend (This : in out Sequence; By : in List; Start : in Index) with
     Pre  => Start + By'Length - 1 <= This.Capacity,
     Post => Value (This) (Start .. Start + By'Length - 1) = By,
     Inline;
   --  Changes the slice of This, beginning at array index Start, to the array
   --  value By

   procedure Ammend (This : in out Sequence; By : in Component; Start : in Index) with
     Pre  => Start <= This.Capacity,
     Post => Value (This) (Start) = By,
     Inline;
   --  Changes the slice of This, beginning at array index Start, to the
   --  component value By

   function Location (Fragment : Sequence;   Within : Sequence) return Natural_Index with
     Inline;
   --  Returns the starting index of the logical value of the sequence Fragment
   --  within the sequence Within, if any. Returns 0 when the fragment is not
   --  found.

   function Location (Fragment : List; Within : Sequence) return Natural_Index with
     Inline;
   --  Returns the starting index of the value of the array Fragment within the
   --  sequence Within, if any. Returns 0 when the fragment is not found.

   function Location (Fragment : Component;  Within : Sequence) return Natural_Index with
     Inline;
   --  Returns the index of the value of the component Fragment within the
   --  sequence Within, if any. Returns 0 when the fragment is not found.

private

   type Sequence (Capacity : Index) is
      record
         Current_Length : Natural_Index := 0;
         Content        : List (1 .. Capacity);
      end record;

end Bounded_Dynamic_Arrays;
