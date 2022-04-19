package Airline.Seats is

   --------------------
   -- Seat Locations --
   --------------------

   type Row_Numbers is new Natural range 1 .. 100;

   subtype First_Row_Numbers is Row_Numbers
      range Row_Numbers'First .. Row_Numbers'First + 5;
   
   subtype Business_Row_Numbers is Row_Numbers
      range Row_Numbers'First + 6 .. Row_Numbers'First + 20;

   subtype Coach_Row_Numbers is Row_Numbers
      range Row_Numbers'First + 21 .. Row_Numbers'Last;

   type Kgs is new Natural range 0 .. 100;

   type Seat_Id is (A, B, C, D);

   type Seat_Location is record
      Row    : Row_Numbers := Row_Numbers'Last;
      Seat   : Seat_Id     := Seat_Id'First;
   end record;

   -----------
   -- Seats --
   -----------

   -- Abstract seat --
   -------------------

   type Seat is interface;
   type Seat_Ptr is access Seat'Class;

   procedure Print     (What : Seat) is abstract;
   procedure Check_In  (What : in out Seat; Weight : Kgs) is abstract;
   function  Is_Aboard (What : Seat) return Boolean is abstract;
   procedure Book      (What : in out Seat;
                        Chair  : Seat_Location) is abstract;

   -- Coach Seat --
   ----------------

   type Coach_Seat is new Seat with record
      Booked   : Boolean    := False;
      Embarked : Boolean    := False;
      Baggage  : Kgs        := 0;
      Which    : Seat_Location;
   end record;

   procedure Print     (What : Coach_Seat);
   procedure Check_In  (What : in out Coach_Seat; Weight : Kgs);
   function  Is_Aboard (What : Coach_Seat) return Boolean;
   procedure Book      (What : in out Coach_Seat;
                        Chair  : Seat_Location);

   -- Business Seat --
   -------------------

   type Business_Seat is new Coach_Seat with null record;

   -- First Seat --
   ----------------

   type First_Seat is new Business_Seat with null record;
   
end Airline.Seats;
