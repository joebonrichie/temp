with Airline.Seats; use Airline.Seats;
with Airline.Meals; use Airline.Meals;

package body Airline.Tickets is

   procedure Eat (What : in out Ticket) is
   begin
      Eat (What.Food.all);
   end Eat;
   
   procedure Menu (What : Ticket) is
   begin
      Menu (What.Food.all);
   end Menu;

   function  Eaten (What : Ticket) return Boolean is
   begin
      return Eaten (What.Food.all);
   end Eaten;

   procedure Set_Menu (What   : in out Ticket;
                       First  : Starters;
                       Second : Main_Courses;
                       Third  : Sweets) is
   begin
      Set_Menu (What.Food.all, First, Second, Third);
   end Set_Menu;

   procedure Print (What : Ticket) is
   begin
      Print (What.Chair.all);
      Menu  (What.Food.all);
   end Print;

   procedure Check_In (What : in out Ticket; Weight : Kgs) is
   begin
      Check_In (What.Chair.all, Weight);
   end Check_In;

   function Is_Aboard (What : Ticket) return Boolean is
   begin
      return Is_Aboard (What.Chair.all);
   end Is_Aboard;

   procedure Book  (What  : in out Ticket;
                    Chair : Seat_Location) is
   begin
      Book (What.Chair.all, Chair);
   end Book;

end Airline.Tickets;
