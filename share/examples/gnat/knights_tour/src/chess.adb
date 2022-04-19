package body Chess is

   ----------------
   -- Initialize --
   ----------------

   procedure Initialize (This : out Board; Size : Positive) is
   begin
      This.Layout := new Board_Representation'(1..Size => (1..Size => 0));
      This.Side := Size;
   end Initialize;

   -------------
   -- As_Move --
   -------------

   function As_Move (Row, Col : Integer) return Move is
   begin
      return Move'(Row, Col);
   end As_Move;

   ---------
   -- Row --
   ---------

   function Row (This : Move) return Integer is
   begin
      return This.Row;
   end Row;

   ------------
   -- Column --
   ------------

   function Column (This : Move) return Integer is
   begin
      return This.Col;
   end Column;

   -------------------
   -- Within_Bounds --
   -------------------

   function Within_Bounds (This : Board; M : Move'Class) return Boolean is
   begin
      return (M.Row in 1..This.Side) and (M.Col in 1..This.Side);
   end Within_Bounds;

   -----------------
   -- Record_Move --
   -----------------

   procedure Record_Move
      (This : in out Board;  M : in Move'Class;  Move_Count : in Positive)
   is
   begin
      This.Layout (M.Row,M.Col) := Move_Count;
   end Record_Move;

   ----------------
   -- Erase_Move --
   ----------------

   procedure Erase_Move (This : in out Board; M : in Move'Class) is
   begin
      This.Layout (M.Row,M.Col) := 0;
   end Erase_Move;

   --------------
   -- Value_at --
   --------------

   function Value_at (This : Board; M : Move'Class) return Natural is
   begin
      return This.Layout (M.Row, M.Col);
   end Value_at;

   ---------------
   -- Side_Size --
   ---------------

   function Side_Size (This : Board) return Positive is
   begin
      return This.Side;
   end Side_Size;

end Chess;
