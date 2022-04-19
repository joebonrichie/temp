with Ada.Text_IO;     use Ada.Text_IO;
with GNAT.Awk;        use GNAT;
with Airline.Tickets; use Airline.Tickets;
with Airline.Seats;   use Airline.Seats;
with Airline.Meals;   use Airline.Meals;

procedure Broker is
   Width            : constant := Seat_Id'Pos (Seat_Id'Last)
                                  - Seat_Id'Pos (Seat_Id'First) + 1;
   Passengers       : array (1 .. Natural (Row_Numbers'Last * Width)) of Ticket;
   Nb_Of_Passengers : Natural := 0;
   --  This contains all the tickets

   procedure Read_File (File : String);
   --  This procedure reads the order file and file the ticket information.
   --  The order file is split into fields using the GNAT.AWK package.
   --  Object-wise, no dispatching is involved as the type of ticket is
   --  precisely known.

   procedure Read_File (File : String) is
      Session : AWK.Session_Type;
      --  This variable contains session information for GNAT.AWK

   begin
      AWK.Set_Current (Session);     -- Tell GNAT.AWK which session to use
      AWK.Open (Separators => " ",   -- Open the order file
                Filename   => File);
      while not AWK.End_Of_File loop
         AWK.Get_Line;               -- Get a new line
         declare
            Row    : Row_Numbers  := Row_Numbers'Value  (AWK.Field (1));
            Seat   : Seat_Id      := Seat_Id'Value      (AWK.Field (2));
            First  : Starters     := Starters'Value     (AWK.Field (3));    
            Second : Main_Courses := Main_Courses'Value (AWK.Field (4));
            Third  : Sweets       := Sweets'Value       (AWK.Field (5));
            Weight : Kgs          := Kgs'Value          (AWK.Field (6));
         begin
            Nb_Of_Passengers := Nb_Of_Passengers + 1;

            --  According to the position, one can know whether this
            --  will be a First, Business of Coach ticket.
            if Row in First_Row_Numbers then
               Passengers (Nb_Of_Passengers).Chair := new First_Seat;
               Passengers (Nb_Of_Passengers).Food  := new First_Meal;
            elsif Row in Business_Row_Numbers then
               Passengers (Nb_Of_Passengers).Chair := new Business_Seat;
               Passengers (Nb_Of_Passengers).Food  := new Business_Meal;
            else
               Passengers (Nb_Of_Passengers).Chair := new Coach_Seat;
               Passengers (Nb_Of_Passengers).Food  := new Coach_Meal;
            end if;
            --  Once the type is known, one can fill in the information
            Book     (Passengers (Nb_Of_Passengers), (Row, Seat));
            Set_Menu (Passengers (Nb_Of_Passengers), First, Second, Third);
            Check_In (Passengers (Nb_Of_Passengers), Weight);
         end;
      end loop;
      AWK.Close (Session);
   end Read_File;
 
begin
   Read_File ("orders.txt"); 

   for I in 1 .. Nb_Of_Passengers loop
      if Is_Aboard (Passengers (I)) then

         Print (Passengers (I));
         --  This cal indirectly dispatches to the Seat hierarchy as
         --  the Print () procedure does not know the type of Seat'Class
         --  in advance

         Eat (Passengers (I));
         --  This call indirectly dispatches to the Meal hierarchy as
         --  the Eat () procedure does not know the type in Meal'Class
         --  in advance

         if not Eaten (Passengers (I)) then
            Put_Line ("Passenger" & Integer'Image (I) & " is sick.");
         end if;
      end if;
   end loop;
end Broker;
