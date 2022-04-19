with Menace.Contestants;
with Menace.Contests;

package Menace.Humans is

   type Player is new Menace.Contestants.Player with private;
   --  The abstract data type representing a human player.  Human players are
   --  those that specify their moves via the keyboard while playing one of the
   --  MENACE engines.

   overriding
   procedure Get_Next_Move
     (This    : in out Player;
      Contest : in     Menace.Contests.Game;
      Move    :    out Move_Locations);
   --  Gets the next move interactively. The user enters a single digit in the
   --  range 1 though 9, representing the move location selected. If that move
   --  location is already taken by another player, the user is required to make
   --  a different selection.

private

   type Player is new Menace.Contestants.Player with null record;

end Menace.Humans;
