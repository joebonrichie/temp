--
--            Copyright (C) 2008-2013, AdaCore
--

package body Pool_Manager is

   -----------------
   -- Next_Member --
   -----------------

   function Next_Member (Wait : Boolean := True) return Reference is
      Result : Reference;  --  initially null
   begin
      if Wait then
         Manager.Get (Result);
      else -- now or never ...
         select
            Manager.Get (Result);
         else
            null;
         end select;
      end if;
      return Result;
   end Next_Member;

   -------------------
   -- Return_Member --
   -------------------

   procedure Return_Member (This : in out Reference) is
   begin
      Manager.Put (This);
      This := null;
   end Return_Member;

   ----------
   -- Load --
   ----------

   procedure Load (These : Initial_Values) is
   begin
      Manager.Load (These);
   end Load;

   -------------
   -- Manager --
   -------------

   protected body Manager is

      entry Get (R : out Reference) when Number_Remaining > 0 is
      begin
         R := Pool (Number_Remaining);
         Number_Remaining := Number_Remaining - 1;
      end Get;

      procedure Put (R : Reference) is
      begin
         if Number_Remaining = Pool_Size then
            raise Overflow;
         end if;
         Number_Remaining := Number_Remaining + 1;
         Pool (Number_Remaining) := R;
      end Put;

      procedure Load (These : Initial_Values) is
      begin
         for K in These'Range loop
            Number_Remaining := Number_Remaining + 1;
            Pool (Number_Remaining) := These (K);
         end loop;
      end Load;

      entry Await_Quiescence when Number_Remaining = Pool_Size is
      begin
         null;
      end Await_Quiescence;

   end Manager;

   ----------------------
   -- Await_Quiescence --
   ----------------------

   procedure Await_Quiescence is
   begin
      Manager.Await_Quiescence;
   end Await_Quiescence;

end Pool_Manager;
