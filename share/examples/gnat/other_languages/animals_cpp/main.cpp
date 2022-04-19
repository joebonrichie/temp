/*******************/
/* cpp_animals.cpp */
/*******************/

using namespace std;

#include <iostream>
#include "cpp_animals.hpp"

extern "C" {
  void adainit ();
  void adafinal ();
}

int main () 
{
  // Initialize the Ada environment.
  adainit ();

  // Initialize a dog using the default constructor.
  Dog dog;

  // Print the dog to show the default constructer has been called. 
  cout << dog.Owner << "'s dog is " << dog.Age () << " years old and has "
       << dog.Number_Of_Teeth () << " teeth." << endl;

  // Call some methods defined in Ada.
  dog.Set_Age (3);
  dog.Age ();
  dog.Number_Of_Teeth ();

  // Finalize the Ada environment.
  adafinal ();

  return 0;
}
