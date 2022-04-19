package body Weighted_Random is

   use Ada.Numerics.Float_Random;

   -----------
   -- Reset --
   -----------

   procedure Reset (This : in out Generator) is
   begin
      Reset (This.State.FRG);
   end Reset;

   -----------------
   -- Set_Weights --
   -----------------

   procedure Set_Weights (This : in out Generator;  To : in Relative_Weights) is
   begin
      This.State.Weights := To;
      This.State.Total_Weight := Sum (This.State.Weights);
   end Set_Weights;

   ----------------
   -- Set_Weight --
   ----------------

   procedure Set_Weight
     (This      : in out Generator;
      For_Value : in     Value;
      To        : in     Natural)
   is
   begin
      This.State.Weights (For_Value) := To;
      This.State.Total_Weight := Sum (This.State.Weights);
   end Set_Weight;

   ---------------------
   -- Current_Weights --
   ---------------------

   function Current_Weights (This : Generator) return Relative_Weights is
   begin
      return This.State.Weights;
   end Current_Weights;

   ------------------
   -- Total_Weight --
   ------------------

   function Total_Weight (This : Generator) return Natural is
   begin
      return This.State.Total_Weight;
   end Total_Weight;

   ---------------
   -- Get_Value --
   ---------------

   procedure Get_Value (This : in Representation;  Result : out Value) is
      subtype Indexes is Integer range 0 .. This.Total_Weight - 1;
      --  we use a zero-based array index because 0.0 is a possible value
      --  for the random number generator and we are using that to compute
      --  index values.

      Weighted_Values : array (Indexes) of Value;

      Index : Integer range Weighted_Values'First .. Weighted_Values'Last + 1;

      Random_Number : Float;
   begin
      Index := Weighted_Values'First;
      for V in Value loop
         for K in 1 .. This.Weights (V) loop
            Weighted_Values (Index) := V;
            Index := Index + 1;
         end loop;
      end loop;
      Random_Number := Random (This.FRG) * Float (This.Total_Weight);
      Index := Integer (Float'Floor (Random_Number));
      Result := Weighted_Values (Index);
   end Get_Value;

   ------------
   -- Random --
   ------------

   function Random (This : Generator) return Value is
      Result : Value;
      type Pointer is access all Representation;
      This_State : constant Pointer := This.State'Unrestricted_Access;
   begin
      if This_State.Total_Weight = 0 then
         raise No_Weights;
      end if;
      Get_Value (This_State.all, Result);
      return Result;
   end Random;

   ---------
   -- Sum --
   ---------

   function Sum (This : Relative_Weights) return Natural is
      Result : Natural := 0;
   begin
      for K in This'Range loop
         Result := Result + This (K);
      end loop;
      return Result;
   end Sum;

   ----------
   -- Read --
   ----------

   procedure Read
      (Stream : not null access Ada.Streams.Root_Stream_Type'Class;
       This   : out Generator)
   is
   begin
      Representation'Read (Stream, This.State);
      Reset (This.State.FRG);
   end Read;

   -----------
   -- Write --
   -----------

   procedure Write
      (Stream : not null access Ada.Streams.Root_Stream_Type'Class;
       This   : in Generator)
   is
   begin
      Representation'Write (Stream, This.State);
   end Write;

   -------------------------
   -- Read_Representation --
   -------------------------

   procedure Read_Representation
      (Stream : not null access Ada.Streams.Root_Stream_Type'Class;
       This   : out Representation)
   is
   begin
      Relative_Weights'Read (Stream, This.Weights);
      This.Total_Weight := Sum (This.Weights);
   end Read_Representation;

   --------------------------
   -- Write_Representation --
   --------------------------

   procedure Write_Representation
      (Stream : not null access Ada.Streams.Root_Stream_Type'Class;
       This   : in Representation)
   is
   begin
      Relative_Weights'Write (Stream, This.Weights);
   end Write_Representation;

end Weighted_Random;

