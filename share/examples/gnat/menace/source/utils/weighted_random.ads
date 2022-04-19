with Ada.Finalization;
with Ada.Streams;
with Ada.Numerics.Float_Random;

generic
   type Value is (<>);
package Weighted_Random is

   type Generator is tagged limited private;
   --  Unlike the language-defined pseudo-random number generators, this type
   --  returns an unevenly distributed random value, of type Value, based
   --  on relative weights assigned by the user.

   type Relative_Weights is array (Value) of Natural;
   --  Each component is a relative weight for the corresponding index value,
   --  to be used when computing the random result.

   procedure Set_Weights (This : in out Generator;  To : in Relative_Weights);
   --  Sets all the relative weights for This.

   procedure Set_Weight
     (This      : in out Generator;
      For_Value : in     Value;
      To        : in     Natural);
   --  Set a single weight for a single value.

   function Current_Weights (This : Generator) return Relative_Weights;
   --  Returns the current settings for the weights for this generator.

   function Total_Weight (This : Generator) return Natural;
   --  Returns the sum of the weights defined for this generator.

   function Random (This : Generator) return Value;
   --  Returns a randomly determined value of type Value.  The likelihood
   --  of a given value being returned is based on the relative weight assigned
   --  to that value, relative to all the other values possible.
   --  Raises No_Weights if neither Set_Weights nor Set_Weight have been called.

   No_Weights : exception;
   --  raised by Random if Total_Weight (This) = 0

   procedure Reset (This : in out Generator);
   --  Resets the internal mechanism for generating random values.
   --  Weights are not changed.

   procedure Read
      (Stream : not null access Ada.Streams.Root_Stream_Type'Class;
       This   : out Generator);

   procedure Write
      (Stream : not null access Ada.Streams.Root_Stream_Type'Class;
       This   : in Generator);

   for Generator'Read  use Read;
   for Generator'Write use Write;

private

   type Representation is
      record
         FRG          : Ada.Numerics.Float_Random.Generator;
         Weights      : Relative_Weights;
         Total_Weight : Natural := 0;
      end record;
   --  An internal type used to represent the generator, purely for the sake of
   --  having the function Random change its parameter.

   type Generator is new Ada.Finalization.Limited_Controlled with
      record
         State : Representation;
      end record;

   overriding
   procedure Initialize (This : in out Generator) renames Reset;

   function Sum (This : Relative_Weights) return Natural;
   --  Computes the sum of the weights.

   procedure Get_Value (This : in Representation;  Result : out Value);
   --  Does the actual computation to compute the next random value,
   --  based on the relative weights.

   procedure Read_Representation
      (Stream : not null access Ada.Streams.Root_Stream_Type'Class;
       This   : out Representation);

   procedure Write_Representation
      (Stream : not null access Ada.Streams.Root_Stream_Type'Class;
       This   : in Representation);

   for Representation'Read  use Read_Representation;
   for Representation'Write use Write_Representation;

end Weighted_Random;
