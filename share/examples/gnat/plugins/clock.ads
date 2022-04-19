with InDash;

package Clock is

   subtype Sixty       is Integer range 0 .. 60;
   subtype Twenty_Four is Integer range 0 .. 24;
   subtype Thousand    is Integer range 0 .. 1000;

   type Clock is new InDash.Instrument with private;

   type Clock_Reference is access all Clock;

   procedure Display (C : access Clock);
   procedure Update  (C : access Clock; Millisec : Integer);

   type Chronometer is new Clock with private;

   type Chronometer_Reference is access all Chronometer;

   procedure Display (C : access Chronometer);

   type Accurate_Clock is new Clock with private;

   type Accurate_Clock_Reference is access all Accurate_Clock;

   procedure Display (C : access Accurate_Clock);
   procedure Update  (C : access Accurate_Clock; Millisec : Integer);

private

   type Clock is new InDash.Instrument with record
      Seconds : Sixty := 0;
      Minutes : Sixty := 0;
      Hours   : Twenty_Four := 0;
   end record;

   type Chronometer is new Clock with null record;

   type Accurate_Clock is new Clock with record
      MilliSec : Thousand := 0;
   end record;

end Clock;
