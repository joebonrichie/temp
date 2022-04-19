with InDash;

package Speedometer is

   subtype Speed is Float range 0.0 .. 200.0; -- mph

   type Digital_Speedometer is new InDash.Instrument with private;

   type Digital_Speedometer_Reference is access all Digital_Speedometer;

   procedure Display (This : access Digital_Speedometer);

   procedure Update  (This : access Digital_Speedometer;  Millisec : Integer);

private

   type Digital_Speedometer is new InDash.Instrument with record
      Value : Speed;
   end record;

end Speedometer;
