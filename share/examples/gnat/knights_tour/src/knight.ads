with Chess;

package Knight is

   subtype Possible_Moves is Integer range 1 .. 8;

   type Move_Candidates is array (Possible_Moves range <>) of Chess.Move;

   function Candidates (Board : Chess.Board'Class; Current : Chess.Move)
      return Move_Candidates;
   --  Returns the list of all moves that are possible on chess board Board,
   --  from position Current, using the legal knight's moves.  Moves are only
   --  possible if they are on the board and not yet visited.

end Knight;
