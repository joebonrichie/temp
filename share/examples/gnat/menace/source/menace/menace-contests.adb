with Ada.Text_IO;

package body Menace.Contests is

   ----------
   -- Mark --
   ----------

   procedure Mark
     (This   : in out Game;
      Player : in     Player_Id;
      Move   : in     Move_Locations)
   is
   begin
      if This.Board (Move) = No_Player then
         This.Board (Move) := Player;
      else
         raise Illegal_Move with "Player " & As_Player_Image (Player) &
               " attempting to move to " & Move'Img;
      end if;
   end Mark;


   type Winning_Combinations is range 1 .. 8; -- 8 ways to win
   type Required_Positions   is range 1 .. 3; -- need 3 places to win

   Winning : constant array (Winning_Combinations, Required_Positions)
      of Move_Locations :=
         ((1,2,3),  -- rows
          (4,5,6),
          (7,8,9),
          (1,4,7), -- columns
          (2,5,8),
          (3,6,9),
          (1,5,9), -- diagonals
          (3,5,7));

   ------------
   -- Winner --
   ------------

   function Winner (This : Game) return Player_Id is
   begin
      for K in Winning_Combinations loop
         if This.Board (Winning(K,1)) /= No_Player and then
            (This.Board (Winning(K,1)) = This.Board (Winning(K,2)) and
             This.Board (Winning(K,2)) = This.Board (Winning(K,3)))
         then
            return This.Board (Winning(K,1));
         end if;
      end loop;
      return No_Player;
   end Winner;

   ---------------------
   -- Moves_Remaining --
   ---------------------

   function Moves_Remaining (This : Game) return Natural is
      Result : Natural := 0;
   begin
      for Next_Move in Move_Locations loop
         if This.Board (Next_Move) = No_Player then
            Result := Result + 1;
         end if;
      end loop;
      return Result;
   end Moves_Remaining;

   --------------------
   -- Remaining_Move --
   --------------------

   function Remaining_Move (This : Game) return Move_Locations is
   begin
      for Next_Move in Move_Locations loop
         if This.Board (Next_Move) = No_Player then
            return Next_Move;
         end if;
      end loop;
      raise Program_Error;
   end Remaining_Move;

   ---------------
   -- Could_Win --
   ---------------

   function Could_Win
     (This        : Game;
      Next_Player : Player_Id;
      Move        : Move_Locations)
      return Boolean
   is
      Temp : Game := This;
   begin
      Temp.Board (Move) := Next_Player;
      return Temp.Winner = Next_Player;
   end Could_Win;

   ---------------
   -- Completed --
   ---------------

   function Completed (This : Game;  Next_Player : Player_Id) return Boolean is
   begin
      return Winner (This) /= No_Player
             or else
             (Moves_Remaining (This) = 1 and then
             -- the player whose turn is next would not win if they went there
             not Could_Win (This, Next_Player, Remaining_Move (This)));
   end Completed;

   -------------
   -- Display --
   -------------

   procedure Display (This : in Game; Show_Numbers : in Boolean := False) is

      function Image (Location : Move_Locations) return Character is
      begin
         case This.Board(Location) is
            when No_Player =>
               if Show_Numbers then
                  return Move_Locations'Image(Location)(2);
               else
                  return ' ';
               end if;
            when others =>
               return As_Player_Image (This.Board (Location));
         end case;
      end Image;

      use Ada.Text_IO;
   begin
      New_Line;
      Put_Line (' ' & Image(1) & '|' & Image(2) & '|' & Image(3));
      Put_Line (" -+-+-");
      Put_Line (' ' & Image(4) & '|' & Image(5) & '|' & Image(6));
      Put_Line (" -+-+-");
      Put_Line (' ' & Image(7) & '|' & Image(8) & '|' & Image(9));
      New_Line;
   end Display;

   -----------
   -- Reset --
   -----------

   procedure Reset (This : in out Game) is
   begin
      This.Board := (others => No_Player);
   end Reset;

   ---------------
   -- Player_At --
   ---------------

   function Player_At (This : Game; Move : Move_Locations) return Player_Id is
   begin
      return This.Board (Move);
   end Player_At;

end Menace.Contests;
