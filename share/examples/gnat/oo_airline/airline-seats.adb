with Ada.Text_IO; use Ada.Text_IO;

package body Airline.Seats is

   procedure Print (What : Coach_Seat) is
   begin
      Put_Line ("-------- Seat"  
                & Row_Numbers'Image (What.Which.Row)
                & Seat_Id'Image (What.Which.Seat)
                & "--------");
      Put_Line ("Boarded: " & Boolean'Image (What.Embarked));
      Put_Line ("Bagage: "  & Kgs'Image (What.Baggage));  
   end Print;

   -- Coach Seat --
   ----------------

   procedure Check_In (What : in out Coach_Seat; Weight : Kgs) is
   begin
      What.Baggage  := Weight;
      What.Embarked := True;
   end Check_In;

   function Is_Aboard (What : Coach_Seat) return Boolean is
   begin
      return What.Embarked;
   end Is_Aboard;

   procedure Book (What : in out Coach_Seat;
                   Chair  : Seat_Location) is
   begin
      What.Booked := True;
      What.Which  := Chair;
   end Book;

end Airline.Seats;
