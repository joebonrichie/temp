with Airline.Seats; use Airline.Seats;
with Airline.Meals; use Airline.Meals;

package Airline.Tickets is

   type Ticket is new Seat and Meal with record
      Chair : Seat_Ptr := null;
      Food  : Meal_Ptr := null;
   end record;
   
   --  Methods inherited from Meal --
   procedure Eat   (What : in out Ticket);
   procedure Menu  (What : Ticket);
   function  Eaten (What : Ticket) return Boolean;
   procedure Set_Menu (What   : in out Ticket;
                       First  : Starters;
                       Second : Main_Courses;
                       Third  : Sweets);

   --  Methods inherited from Seat --
   procedure Print     (What : Ticket);
   procedure Check_In  (What : in out Ticket; Weight : Kgs);
   function  Is_Aboard (What : Ticket) return Boolean;
   procedure Book      (What : in out Ticket;
                        Chair  : Seat_Location);

end Airline.Tickets;
