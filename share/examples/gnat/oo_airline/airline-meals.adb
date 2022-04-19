with Ada.Text_IO; use Ada.Text_IO;

package body Airline.Meals is 

   -- Coach Meal --
   ----------------

   procedure Eat (Tray : in out Coach_Meal) is
   begin
      Tray.Starter := Empty;
   end Eat;

   function  Eaten (Tray : Coach_Meal) return Boolean is
   begin
      return Tray.Starter = Empty;
   end Eaten;

   procedure Menu (Tray : Coach_Meal) is
   begin
      Put_Line ("Starter: " & Starters'Image (Tray.Starter));
   end Menu;

   procedure Set_Menu (Tray   : in out Coach_Meal;
                       First  : Starters;
                       Second : Main_Courses;
                       Third  : Sweets) is
   begin
      Tray.Starter := First;
   end Set_Menu;

   -- Business Meal --
   -------------------

   procedure Eat (Tray : in out Business_Meal) is
   begin
      Eat (Coach_Meal (Tray));
      Tray.Main := Empty;
   end Eat;

   function  Eaten (Tray : Business_Meal) return Boolean is
   begin
      return Eaten (Coach_Meal (Tray)) 
             and Tray.Main = Empty;
   end Eaten;

   procedure Menu (Tray : Business_Meal) is
   begin
      Menu (Coach_Meal (Tray));
      Put_Line ("Main:    " & Main_Courses'Image (Tray.Main));
   end Menu;

   procedure Set_Menu (Tray   : in out Business_Meal;
                       First  : Starters;
                       Second : Main_Courses;
                       Third  : Sweets) is
   begin
      Tray.Main := Second;
      Set_Menu (Coach_Meal (Tray), First, Second, Third);
   end Set_Menu;
      

   -- First_Meal --
   ----------------

   procedure Eat (Tray : in out First_Meal) is
   begin
      Eat (Business_Meal (Tray));
      Tray.Dessert := Empty;
   end Eat;

   function  Eaten (Tray : First_Meal) return Boolean is
   begin
      return Eaten (Business_Meal (Tray)) 
             and Tray.Dessert = Empty;
   end Eaten;

   procedure Menu (Tray : First_Meal) is
   begin
      Menu (Business_Meal (Tray));
      Put_Line ("Dessert: " & Sweets'Image (Tray.Dessert));
   end Menu;

   procedure Set_Menu (Tray   : in out First_Meal;
                       First  : Starters;
                       Second : Main_Courses;
                       Third  : Sweets) is
   begin
      Tray.Dessert := Third;
      Set_Menu (Business_Meal (Tray), First, Second, Third);
   end Set_Menu;

end Airline.Meals;
