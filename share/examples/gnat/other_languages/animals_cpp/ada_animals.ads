with Interfaces.C.Strings; use Interfaces.C.Strings;
package Ada_Animals is

   type Carnivore is limited interface;
   function Number_Of_Teeth (This : Carnivore) return Natural is abstract;
   pragma Convention (CPP, Number_Of_Teeth); --  Required by AI-430

   type Domestic is limited interface;
   procedure Set_Owner (This : in out Domestic; Name : Chars_Ptr) is abstract;
   pragma Convention (CPP, Set_Owner);

   type Animal is tagged limited record
      Age : Natural;
   end record;
   pragma CPP_Class (Animal);

   procedure Set_Age (This : in out Animal; Age : Natural);
   pragma Export (CPP, Set_Age, "_ZN6Animal7Set_AgeEi");

   function Age (This : Animal) return Natural;
   pragma Export (CPP, Age, "_ZN3Dog3AgeEv");

   type Dog is new Animal and Carnivore and Domestic with record
      Tooth_Count : Natural;
      Owner       : chars_ptr;
   end record;
   pragma CPP_Class (Dog);

   function Number_Of_Teeth (This : Dog) return Natural;
   pragma Export (CPP, Number_Of_Teeth, "_ZN3Dog15Number_Of_TeethEv");

   procedure Set_Owner (This : in out Dog; Name : Chars_Ptr);
   pragma Export (CPP, Set_Owner, "_ZN3Dog9Set_OwnerEPc");

   --  Define a default constructor for this type, to be called by the
   --  C++ runtime.
   procedure Init_Dog (This : in out Dog);
   pragma Export (CPP, Init_Dog, "_ZN3DogC1Ev");

end Ada_Animals;
