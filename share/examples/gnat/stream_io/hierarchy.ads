package Hierarchy is

   --  The following tagged types are used to illustrate the use of the
   --  class-wide stream attributes 'Class'Input and 'Class'Output.

   type Base is tagged record
      Priority : Natural;
   end record;

   procedure Print (This : Base);

   type Child is new Base with record
      Value : Character;
   end record;

   procedure Print (This : Child);

end Hierarchy;
