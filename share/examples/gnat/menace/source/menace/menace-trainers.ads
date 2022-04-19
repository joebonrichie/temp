with Menace.Contestants;
with Menace.Contests;

package Menace.Trainers is

   type Coach is new Menace.Contestants.Player with private;
   --  An automated player used to train MENACE engines. These players are not
   --  MENACE engines themselves and do not learn from playing games, but
   --  rather, know a few things about playing well and thus teach their pupils
   --  how to play against an accomplished opponent.  In theory, the smarter
   --  the opponent the quicker the engine should learn to play well.

   overriding
   procedure Get_Next_Move
     (This    : in out Coach;
      Contest : in     Menace.Contests.Game;
      Move    :    out Move_Locations);
   --  Makes as "smart" a move as possible, from which the Engine being trained
   --  will learn (the hard way).

private

   type Coach is new Menace.Contestants.Player with null record;

   function Subsequent_Winning_Moves
     (Contest : Menace.Contests.Game;
      Id      : Player_Id;
      Move    : Move_Locations)
   return Natural;
   --  If player Id played at Move, how many ways could that player win Contest
   --  from there, in a subsequent move? For example, assume the board layout
   --  for Contest is as follows, and that player X is choosing a move:
   --
   --     X | O | X
   --    ---+---+---
   --     O | 5 | 6
   --    ---+---+---
   --     7 | 8 | 9
   --
   --  If X plays at position 5, X then has two ways to win. Player O will
   --  choose to block one of them, say by playing at 7, but player X can then
   --  play at 9 to win.

end Menace.Trainers;
