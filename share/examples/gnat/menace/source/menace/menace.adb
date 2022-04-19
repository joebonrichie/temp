package body Menace is

   --------------
   -- Opponent --
   --------------

   function Opponent (This : Player_Id) return Player_Id is
   begin
      if This = Player_X then
         return Player_O;
      else
         return Player_X;
      end if;
   end Opponent;

end Menace;
