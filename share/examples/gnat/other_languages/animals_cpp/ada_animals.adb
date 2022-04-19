with GNAT.IO; use GNAT.IO;
with Interfaces.C.Strings; use Interfaces.C.Strings;

package body Ada_Animals is

   procedure Init_Dog (This : in out Dog) is
   begin
      Put_Line ("Calling Ada implementation of Init_Dog");
      This.Age := 1;
      This.Tooth_Count := 42;
      This.Owner := New_String ("Bob");
   end Init_Dog;

   procedure Set_Age (This : in out Animal; Age : Natural) is
   begin
      Put_Line ("Calling Ada implementation of Set_Age.");
      This.Age := Age;
   end Set_Age;

   function Age (This : Animal) return Natural is
   begin
      Put_Line ("Calling Ada implementation of Age.");
      return This.Age;
   end Age;

   function Number_Of_Teeth (This : Dog) return Natural is
   begin
      Put_Line ("Calling Ada implementation of Number_Of_Teeth.");
      return This.Tooth_Count;
   end;

   procedure Set_Owner (This : in out Dog; Name : Chars_Ptr) is
   begin
      Put_Line ("Calling Ada implementation of Set_Owner.");
      This.Owner := Name;
   end Set_Owner;

end Ada_Animals;


