--  This is the main program for the knight's tour example of backtracking. When
--  run, the user is first prompted for the length of the side of a square chess
--  board. The side size is entirely up to the user, as long as it is greater
--  than zero. A 31-by-31 board can be displayed properly, for example. However,
--  the ability to display the board in the window is a practical limitation. On
--  MS Windows, changing the properties of the window, specifically the "Screen
--  Buffer Size" width and height, can enable quite large boards to be
--  displayed.
--
--  The user is next prompted for the initial move, specified by entering the
--  row and column values separated by a space. For example, to start at move
--  (Row => 2, Column => 1), the user would enter the following (without
--  quotes): "2 1".
--
--  The program will then attempt to use the legal knight piece moves to visit
--  all the positions on the board, exactly once, starting at the initial move
--  specified. A recursive backtracking algorithm is used for this purpose.
--  Specifically, if a given order of visitation gets to a "dead end", in which
--  no other legal knight's moves are possible before all positions have been
--  visited, the program will "back up" one level and try a different order. If
--  that order fails, the program will continue to backtrack until either it
--  finds a successful order or gets all the way back to the initial move and
--  has no other moves possible. Only the first successful order found is
--  displayed; other orders may also be possible for a given board and starting
--  position.
--
--  The current order in which each position is visited is displayed as the
--  program proceeds. If backtracking is required, the current move number is
--  erased from candidate positions and replaced by numbers representing the new
--  attempted visitation order. Backtracking can thus be observed during
--  execution (depending on the amount of backtracking required).  The board
--  will be completely erased and "No Solution" will be displayed if no
--  solution is possible for the given size and starting position.
--
--  A useful example requiring extensive backtracking is a board with a side
--  size of 5 (for a 5-by-5 chess board), starting at position (2,1). No
--  solution is possible in this configuration so you can see the program
--  attempting a large number of traversal orders.

with Knight_Traversal;
with Ada.Text_IO;
with Chess;
with Displayable_Chess;  use Displayable_Chess;
with Integer_IO;

procedure Knights_Tour is

   Board      : Displayable_Chess.Board;
   Successful : Boolean;
   Size       : Positive;

   procedure Get_Board_Size (Prompt : in String;  Size : out Positive);
   --  Gets the length of the side of the square board to be created.

   procedure Get_Initial_Move (Prompt : in String;  The_Move : out Chess.Move);
   --  Gets the initial move by the user.

   procedure Attempt_Tour (Success : out Boolean);
   --  Tries to make the knight's tour, given the initial move, indicating
   --  whether that is possible.

   --------------------
   -- Get_Board_Size --
   --------------------

   procedure Get_Board_Size (Prompt : in String;  Size : out Positive) is
      Requested_Size : Integer;
   begin
      loop
         Ada.Text_IO.Put(Prompt);
         Integer_IO.Get (Requested_Size);
         exit when Requested_Size in Positive;
         Ada.Text_IO.Put_Line ("Size must be greater than zero.");
      end loop;
      Size := Requested_Size;
   end Get_Board_Size;

   ----------------------
   -- Get_Initial_Move --
   ----------------------

   procedure Get_Initial_Move (Prompt : in String; The_Move : out Chess.Move) is
      The_Row    : Integer;
      The_Column : Integer;
   begin
      loop
         Ada.Text_IO.Put (Prompt);
         Integer_IO.Get (The_Row);
         Integer_IO.Get (The_Column);
         The_Move := Chess.As_Move (The_Row,The_Column);
         exit when Board.Within_Bounds (The_Move);
         Ada.Text_IO.Put_Line ("One or both are out of bounds...");
      end loop;
   end Get_Initial_Move;

   ------------------
   -- Attempt_Tour --
   ------------------

   procedure Attempt_Tour (Success : out Boolean) is
      Initial_Move : Chess.Move;
   begin
      Get_Initial_Move ("Enter initial move <row column> : ", Initial_Move);
      Board.Print;
      Knight_Traversal.Tour (Board, Initial_Move, Success);
      if not Success then
         Board.Erase_Move (Initial_Move);
      end if;
      Displayable_Chess.Move_To_Neutral_Corner (Board);
   end Attempt_Tour;


begin
   Get_Board_Size ("Enter size (1 side) of square chess board: ", Size);
   Board.Initialize (Size);
   Attempt_Tour (Successful);
   if not Successful then
      Ada.Text_IO.Put_Line ("No solution");
   end if;
end Knights_Tour;
