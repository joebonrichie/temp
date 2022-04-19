
with Ada.Finalization;    use Ada.Finalization;
with Ada.Text_IO;         use Ada.Text_IO;
with Dash_Board;

package body Clock is

   use InDash;

   Cl, Ac, Ch : Any_Instrument;

   type Life_Controller is new Limited_Controlled with null record;
   overriding procedure Initialize (LC : in out Life_Controller);
   overriding procedure Finalize (LC : in out Life_Controller);

   ----------------
   -- Make_Clock --
   ----------------

   function Make_Clock
     (Name : String;
      Hours, Minutes, Seconds : Integer) return Any_Instrument
   is
      Result : Clock_Reference;
   begin
      Result := new Clock;
      Result.Set_Name (Name);
      Result.Hours   := Hours;
      Result.Minutes := Minutes;
      Result.Seconds := Seconds;
      return Any_Instrument (Result);
   end Make_Clock;

   ----------------------
   -- Make_Chronometer --
   ----------------------

   function Make_Chronometer
     (Name : String;
      Hours, Minutes, Seconds : Integer) return Any_Instrument
   is
      Result : Chronometer_Reference;
   begin
      Result := new Chronometer;
      Result.Set_Name (Name);
      Result.Hours   := Hours;
      Result.Minutes := Minutes;
      Result.Seconds := Seconds;
      return Any_Instrument (Result);
   end Make_Chronometer;

   -------------------------
   -- Make_Accurate_Clock --
   -------------------------

   function Make_Accurate_Clock
     (Name : String;
      Hours, Minutes, Seconds, Millisec : Integer) return Any_Instrument
   is
      Result : Accurate_Clock_Reference;
   begin
      Result := new Accurate_Clock;
      Result.Set_Name (Name);
      Result.Hours   := Hours;
      Result.Minutes := Minutes;
      Result.Seconds := Seconds;
      Result.Millisec := Millisec;
      return Any_Instrument (Result);
   end Make_Accurate_Clock;

   ----------------
   -- Initialize --
   ----------------

   overriding procedure Initialize (LC : in out Life_Controller) is
   begin
      Cl := Make_Clock ("New York", 12, 15, 0);
      Dash_Board.Register (Cl);

      Ch := Make_Chronometer ("Stopwatch", 0,  0, 0 );
      Dash_Board.Register (Ch);

      --  Ac := Make_Accurate_Clock ("Paris", 6, 15, 0, 0);
      --  Dash_Board.Register (Ac);
   end Initialize;

   --------------
   -- Finalize --
   --------------

   overriding procedure Finalize (LC : in out Life_Controller) is
   begin
      Put_Line ("Unregister Clock");
      Dash_Board.Unregister (Cl);
      Dash_Board.Unregister (Ch);
      --  Dash_Board.Unregister (Ac);
   end Finalize;

   -------------
   -- Display --
   -------------

   procedure Display (C : access Clock) is
   begin
      InDash.Instrument_Reference (C).Display;
      Put (Character'Val (Character'Pos ('0') + C.Hours / 10));
      Put (Character'Val (Character'Pos ('0') + C.Hours mod 10));
      Put (":");
      Put (Character'Val (Character'Pos ('0') + C.Minutes / 10));
      Put (Character'Val (Character'Pos ('0') + C.Minutes mod 10));
      Put (":");
      Put (Character'Val (Character'Pos ('0') + C.Seconds / 10));
      Put (Character'Val (Character'Pos ('0') + C.Seconds mod 10));
   end Display;

   ------------
   -- Update --
   ------------

   procedure Update (C : access Clock; Millisec : Integer) is
      nInc : Integer := Millisec / 1000;
   begin
      C.Seconds := (C.Seconds + nInc) mod 60;
      nInc := (C.Seconds + nInc) / 60;
      C.Minutes := (C.Minutes + nInc) mod 60;
      nInc := (C.Minutes + nInc) / 60;
      C.Hours := (C.Hours + nInc) mod 24;
   end Update;

   -------------
   -- Display --
   -------------

   procedure Display (C : access Chronometer) is
     V : Integer;
   begin
      InDash.Instrument_Reference (C).Display;

      V :=  C.Seconds + C.Minutes * 60 + C.Hours * 3600;

      Put ("<<");
      Put (Character'Val (Character'Pos ('0') + (V / 1000) mod 10));
      Put (Character'Val (Character'Pos ('0') + (V / 100) mod 10));
      Put (Character'Val (Character'Pos ('0') + (V / 10) mod 10));
      Put (Character'Val (Character'Pos ('0') + V mod 10));
      Put (">>");
   end Display;

   -------------
   -- Display --
   -------------

   procedure Display (C : access Accurate_Clock) is
   begin
      Clock_Reference (C).Display;
      Put (":");
      Put (Character'Val (Character'Pos ('0') + (C.MilliSec / 100) mod 10));
      Put (Character'Val (Character'Pos ('0') + (C.MilliSec / 10) mod 10));
      Put (Character'Val (Character'Pos ('0') + C.MilliSec mod 10));
   end Display;

   ------------
   -- Update --
   ------------

   procedure Update (C : access Accurate_Clock; Millisec : Integer) is
   begin
      Clock_Reference (C).Update (Millisec + C.Millisec);
      C.MilliSec := (C.MilliSec + Millisec) mod 1000;
   end Update;

   --  Declared at the end to ensure all routines are elaborated before
   --  calling them.

   LC : Life_Controller;

end Clock;
