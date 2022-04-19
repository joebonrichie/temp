--  This package provides the basic types and operations for representing
--  chess boards and moves (by any piece) on those boards.

package Chess is

   type Move is tagged private;
   --  A position ("location") on a chess board

   function As_Move (Row, Col : Integer) return Move;
   --  Create a move, given a row/column pair

   function Row (This : Move) return Integer;
   --  A selector returning the row of a given move

   function Column (This : Move) return Integer;
   --  A selector returning the column of a given move


   type Board is tagged private;
   --  A square chess board of user-defined size

   procedure Initialize (This : out Board; Size : Positive);
   --  Creates a square chess board of the size specified

   function Within_Bounds (This : Board; M : Move'Class) return Boolean;
   --  Returns whether move M is physically on This board

   procedure Record_Move (This       : in out Board;
                          M          : in     Move'Class;
                          Move_Count : in     Positive);
   --  Records that move M on This board has been taken by writing
   --  the value of Move_Count at that location, thereby indicating
   --  the relative order that position was visited.

   procedure Erase_Move (This : in out Board; M : in Move'Class);
   --  Erases any indication that move M on This board was ever visited.

   function Value_at (This : Board; M : Move'Class) return Natural;
   --  Returns the numeric value at move M on This board.  If M was
   --  never visited, returns zero.

   function Side_Size (This : Board) return Positive;
   --  Boards are square, with lengths defined by users.  This funtion
   --  returns the length of the side of This board.

private

   type Move is tagged
      record
         Row, Col : Integer;
      end record;

   type Board_Representation is
      array (Positive range <>, Positive range <>) of Natural;
   --  The primary representation artifact for type Board, containing the
   --  visitiation order numbers.  Values are intended to be square.

   type Board_Reference is access Board_Representation;
   --  We dynamically allocate the array since the user specifies the size
   --  at run-time.

   type Board is tagged
      record
         Layout : Board_Reference;
         --  The square representation of the board's visitation order.
         Side   : Natural;
         --  The length of the side of the square board.  We could get this
         --  from Layout'Length, but an explicit component was a little more
         --  clear in the code.
      end record;

end Chess;
