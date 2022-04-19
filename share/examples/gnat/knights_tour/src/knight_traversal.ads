with Chess;

package Knight_Traversal is

   procedure Tour (Board        : in out Chess.Board'Class;
                   Initial_Move : in     Chess.Move;
                   Success      :    out Boolean);
   --  Uses a backtracking approach to visit each position on the chess
   --  board Board (of user-specified size), starting at Initial_Move, and
   --  only visiting each move once, using the legal knight's moves.

end Knight_Traversal;
