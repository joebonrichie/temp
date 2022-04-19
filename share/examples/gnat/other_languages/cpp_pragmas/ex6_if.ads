package ex6_if is

   package A_Class is
      --
      --   Translation of C++ class A
      --

      type A is tagged limited
         record
            O_Value : Integer;
            A_Value : Integer;
         end record;

      pragma Import (C_Plus_Plus, A);

      --   Member Functions

      procedure Non_Virtual (This : in A'Class);
      pragma Import (C_Plus_Plus, Non_Virtual, "_ZN1A11non_virtualEv");

      procedure Overridden (This : in A);
      pragma Import (C_Plus_Plus, Overridden);
      --  We have not added the mangled name to the pragma import because
      --  all the calls to *Overriden* issued in this example are dispatching
      --  calls; if this example is modified to issue direct calls the mangled
      --  named is required.

      procedure Not_Overridden (This : in A);
      pragma Import (C_Plus_Plus, Not_Overridden);

      function Constructor return A'Class;
      pragma CPP_Constructor (Constructor);
      pragma Import (C_Plus_Plus, Constructor, "_ZN1AC2Ev");

   end A_Class;

   package B_Class is

      type B is new A_Class.A with
         record
            B_Value : Integer;
         end record;

      pragma Import (C_Plus_Plus, B);

      function Constructor return B'Class;
      pragma CPP_Constructor (Constructor);
      pragma Import (C_Plus_Plus, Constructor, "_ZN1BC2Ev");

      procedure Overridden (This : in B);
      pragma Import (C_Plus_Plus, Overridden);

   end B_Class;

   package Ada_Extension is

      type C is new B_Class.B with
         record
            C_Value : Integer := 3030;
         end record;

      --  C has not been imported from the C++ side; it is a regular
      --  Ada tagged type

      procedure Overridden (This : in C);
   end Ada_Extension;
end Ex6_If;
