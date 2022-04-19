package body Menace.Trainers is

   -------------------
   -- Get_Next_Move --
   -------------------

   procedure Get_Next_Move
     (This    : in out Coach;
      Contest : in     Menace.Contests.Game;
      Move    :    out Move_Locations)
   is
      use Menace.Contests;
   begin
      --  look for immediate winning move
      for Next_Move in Move_Locations loop
         if Contest.Player_At (Next_Move) = No_Player then
            if Could_Win (Contest, This.Id, Next_Move) then
               Move := Next_Move;
               return;
            end if;
         end if;
      end loop;

      --  try to prevent them from winning
      for Their_Move in Move_Locations loop
         if Contest.Player_At (Their_Move) = No_Player then
            if Could_Win (Contest, Opponent (This.Id), Their_Move) then
               Move := Their_Move;
               return;
            end if;
         end if;
      end loop;

      --  make a "smart" move that will give us the most ways to win in
      --  subsequent moves
      for Next_Move in Move_Locations loop
         if Contest.Player_At (Next_Move) = No_Player then
            if Subsequent_Winning_Moves (Contest, This.Id, Next_Move) > 1 then
               Move := Next_Move;
               return;
            end if;
         end if;
      end loop;

      --  look for bad situations in the future, in which the opponent might
      --  have multiple ways to win in subsequent moves.  essentially we are
      --  taking away a "smart" move on their part.
      for Their_Move in Move_Locations loop
         if Contest.Player_At (Their_Move) = No_Player then
            if Subsequent_Winning_Moves
                  (Contest, Opponent (This.Id), Their_Move) > 1
            then
               Move := Their_Move;
               return;
            end if;
         end if;
      end loop;

      -- just find one that is open, giving preference to the center and corners
      declare
         Options : constant array (Move_Locations) of Move_Locations :=
            (5,           -- the center position is best
             1, 3, 7, 9,  -- corners are better than middles
             2, 4, 6, 8); -- middles are all that's left...
      begin
         for K in Options'Range loop
            if Contest.Player_At (Options (K)) = No_Player then
               Move := Options (K);
               return;
            end if;
         end loop;
      end;
   end Get_Next_Move;

   ------------------------------
   -- Subsequent_Winning_Moves --
   ------------------------------

   function Subsequent_Winning_Moves
     (Contest : Menace.Contests.Game;
      Id      : Player_Id;
      Move    : Move_Locations)
   return Natural
   is
      use Menace.Contests;

      Temp : Game := Contest;
      Wins : Natural := 0;
   begin
      Temp.Mark (Id, Move);
      for Next_Move in Move_Locations loop
         if Temp.Player_At (Next_Move) = No_Player then
            if Could_Win (Temp, Id, Next_Move) then
               Wins := Wins + 1;
            end if;
         end if;
      end loop;
      return Wins;
   end Subsequent_Winning_Moves;

end Menace.Trainers;
