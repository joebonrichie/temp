with Chess;
with Console;
with Selected_Console;

package Displayable_Chess is

   type Board is new Chess.Board with private;
   --  This type adds output to the overridden Board operations and extends it
   --  with additional display-oriented operations.

   overriding
   procedure Record_Move
      (This       : in out Board;
       Move       : in Chess.Move'Class;
       Move_Count : in Positive);
   --  Records the value of Move_Count at move M on This board, but then also
   --  displays that value at that location on the console in use.

   overriding
   procedure Erase_Move (This : in out Board; Move : in Chess.Move'Class);
   --  Erases any indication that move M on This board was ever visited, but
   --  then also erases it on the console.

   procedure Clear (This : in out Board);
   --  Clears the entire display of the board.

   procedure Print (This : in Board);
   --  Prints the initial board, with a single dot ('.') at each location.

   procedure Move_To_Neutral_Corner (This : in Board);
   --  Moves the cursor of the display console out of the way, ie off the
   --  displayed board.

private

   type Board is new Chess.Board with
      record
         Display : Console.Any_Device := Selected_Console.Instance;
      end record;

end Displayable_Chess;
