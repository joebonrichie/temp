procedure STB is

   procedure P1 is
   begin
      raise Constraint_Error;
   end P1;

   procedure P2 is
   begin
      P1;
   end P2;

begin
   P2;
end STB;
