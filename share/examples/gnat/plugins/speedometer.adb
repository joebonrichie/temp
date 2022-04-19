
with Ada.Finalization;    use Ada.Finalization;
with Ada.Text_IO;         use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;

with Dash_Board;

package body Speedometer is

   use InDash;

   S : Any_Instrument;

   type Life_Controller is new Limited_Controlled with null record;
   overriding procedure Initialize (LC : in out Life_Controller);
   overriding procedure Finalize (LC : in out Life_Controller);

   ------------------------------
   -- Make_Digital_Speedometer --
   ------------------------------

   function Make_Digital_Speedometer
     (Name : String; Value : Speed) return Any_Instrument
   is
      Result : Digital_Speedometer_Reference;
   begin
      Result := new Digital_Speedometer;
      Result.Set_Name (Name);
      Result.Value := Value;
      return Any_Instrument (Result);
   end Make_Digital_Speedometer;

   -------------
   -- Display --
   -------------

   procedure Display (This : access Digital_Speedometer) is
   begin
      InDash.Instrument_Reference (This).Display;
      Put (Integer (This.Value), 3);
      Put (" Miles per Hour");
   end Display;

   ----------------
   -- Initialize --
   ----------------

   overriding procedure Initialize (LC : in out Life_Controller) is
   begin
      S := Make_Digital_Speedometer ("Speed", 45.0);
      Dash_Board.Register (S);
   end Initialize;

   --------------
   -- Finalize --
   --------------

   overriding procedure Finalize (LC : in out Life_Controller) is
   begin
      Put_Line ("Unregister Speedometer");
      Dash_Board.Unregister (S);
   end Finalize;

   ------------
   -- Update --
   ------------

   procedure Update (This : access Digital_Speedometer; Millisec : Integer) is
   begin
      --  Speed grows at 2mph per 15 seconds
      This.Value := This.Value + 2.0 * (Float(Millisec) / 1000.0 / 15.0);
   end Update;

   --  Declared at the end to ensure all routines are elaborated before
   --  calling them.

   LC : Life_Controller;

end Speedometer;
