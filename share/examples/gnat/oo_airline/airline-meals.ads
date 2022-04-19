package Airline.Meals is 

   type Starters is     (Empty, Cracker, Salad, Salmon, Foie_Gras, Caviar);
   type Main_Courses is (Empty, Poultry, Fish, Beef, Ostrich);
   type Sweets is       (Empty, Cookies, Ice_Creams, Feuillete);

   ----------
   -- Meal --
   ----------

   --  Abstract Meal --
   --------------------

   type Meal is interface;
   type Meal_Ptr is access Meal'Class;

   procedure Eat   (Tray : in out Meal) is abstract;
   procedure Menu  (Tray : Meal) is abstract;
   procedure Set_Menu (Tray   : in out Meal;
                       First  : Starters;
                       Second : Main_Courses;
                       Third  : Sweets) is abstract; 
   function  Eaten (Tray : Meal) return Boolean is abstract;

   -- Coach Meal --
   ----------------

   type Coach_Meal is new Meal with record
      Starter : Starters     := Empty;
   end record;

   procedure Eat   (Tray : in out Coach_Meal);
   procedure Menu  (Tray : Coach_Meal);
   procedure Set_Menu (Tray   : in out Coach_Meal;
                       First  : Starters;
                       Second : Main_Courses;
                       Third  : Sweets);
   function  Eaten (Tray : Coach_Meal) return Boolean;

   -- Business Meal --
   -------------------

   type Business_Meal is new Coach_Meal with record
      Main    : Main_Courses := Empty;
   end record;

   procedure Eat   (Tray : in out Business_Meal);
   procedure Menu  (Tray : Business_Meal);
   procedure Set_Menu (Tray   : in out Business_Meal;
                       First  : Starters;
                       Second : Main_Courses;
                       Third  : Sweets);
   function  Eaten (Tray : Business_Meal) return Boolean;

   -- First Meal --
   -------------------

   type First_Meal is new Business_Meal with record
      Dessert : Sweets       := Empty;
   end record;

   procedure Eat   (Tray : in out First_Meal);
   procedure Menu  (Tray : First_Meal);
   procedure Set_Menu (Tray   : in out First_Meal;
                       First  : Starters;
                       Second : Main_Courses;
                       Third  : Sweets);
   function  Eaten (Tray : First_Meal) return Boolean;

end Airline.Meals;
