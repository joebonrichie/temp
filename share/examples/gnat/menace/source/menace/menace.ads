--  This is a simulation of the Matchbox Educable Naughts and Crosses Engine
--  (MENACE) machine built by Donald Michie. "Naughts and Crosses" is the UK
--  name for the game known as "Tic Tac Toe" in the US. Michie used 300
--  matchboxes and beads of nine different colors to build his game. We use a
--  computer but the design of the software reflects his approach.

package Menace is

   type Player_Id is (Player_X, Player_O, No_Player);

   function Opponent (This : Player_Id) return Player_Id;

   subtype Player_Image is Character;

   As_Player_Image : constant array (Player_Id) of Player_Image := ('X', 'O', '-');

   subtype Move_Locations is Integer range 1 .. 9;

      --     1 | 2 | 3
      --    ---+---+---
      --     4 | 5 | 6
      --    ---+---+---
      --     7 | 8 | 9

end Menace;
