/*******************/
/* cpp_animals.hpp */
/*******************/

using namespace std;

#include <iostream>

// Pure virtual base class.
class Carnivore {
public:
  virtual int Number_Of_Teeth () = 0;
};

// Pure virtual base class.
class Domestic {
public:
  virtual void Set_Owner (char* Name) = 0;
};

// Imported virtual base class. The primitive Age() is defined abstract
// to ensure that no object of this class is built in the C++ side since
// in this example the constructor of Animal is not exported from Ada.
class Animal {
public:
  int Age_Count;
  virtual void Set_Age (int New_Age);
  virtual int Age () = 0;
};

// Concrete class derived from virtual base class. Note that the is no
// C++ implementation of this class, it is in fact a class-level
// binding to an object defined in Ada.
class Dog : public Animal, Carnivore, Domestic {
public:
  int  Tooth_Count;
  char *Owner;
  
  virtual int  Number_Of_Teeth ();
  virtual void Set_Owner (char* Name);
  virtual int  Age ();
  Dog (); // Constructor
};
