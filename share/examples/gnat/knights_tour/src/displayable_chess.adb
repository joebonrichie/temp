with Ada.Text_IO;
with Integer_IO;

package body Displayable_Chess is

   --------------------
   -- Move_to_Square --
   --------------------

   procedure Move_to_Square (This : Board; R, C : in Integer) is
   begin
      if This.Side_Size < 10 then
         This.Display.Move_Cursor (To => Console.Location'(R * 2, C * 3));
      elsif This.Side_Size < 32 then
         --  32**2 => 1024 moves, whereas 31**2 => 961
         This.Display.Move_Cursor (To => Console.Location'(R, C * 4));
      else
         This.Display.Move_Cursor (To => Console.Location'(R, C * 5));
         -- any board bigger than this can handle is silly anyway
      end if;
   end Move_to_Square;

   -----------
   -- Print --
   -----------

   procedure Print (This : Board) is
   begin
      This.Display.Clear;
      for X in 1 .. This.Side_Size loop
         for Y in 1 .. This.Side_Size loop
            Move_to_Square (This, X, Y);
            Ada.Text_IO.Put (".");
         end loop;
      end loop;
   end Print;

   -----------------
   -- Record_Move --
   -----------------

   procedure Record_Move
      (This       : in out Board;
       Move       : in     Chess.Move'Class;
       Move_Count : in     Positive)
   is
   begin
      --  call parent version
      Chess.Record_Move (Chess.Board (This), Move, Move_Count);
      Move_to_Square (This, Move.Row, Move.Column);
      if This.Side_Size < 10 then
         Integer_IO.Put (Move_Count, 2);
      elsif This.Side_Size < 32 then
         Integer_IO.Put (Move_Count, 3);
      else
         Integer_IO.Put (Move_Count, 4);
      end if;
   end Record_Move;

   ----------------
   -- Erase_Move --
   ----------------

   procedure Erase_Move (This : in out Board; Move : in Chess.Move'Class) is
   begin
      Chess.Erase_Move (Chess.Board (This), Move); -- call parent version
      Move_to_Square (This, Move.Row, Move.Column);
      if This.Side_Size < 10 then
         Ada.Text_IO.Put ("  ");
      elsif This.Side_Size < 32 then
         Ada.Text_IO.Put ("   ");
      else
         Ada.Text_IO.Put ("    ");
         -- any board bigger than this can handle is silly anyway
      end if;
   end Erase_Move;

   ----------------------------
   -- Move_To_Neutral_Corner --
   ----------------------------

   procedure Move_To_Neutral_Corner (This : Board) is
   begin
      if This.Side_Size < 10 then
         This.Display.Move_Cursor (To => (This.Side_Size + 10, 1));
      else
         This.Display.Move_Cursor (To => (This.Side_Size + 5, 1));
      end if;
   end Move_To_Neutral_Corner;

   -----------
   -- Clear --
   -----------

   procedure Clear (This : in out Board) is
   begin
      This.Display.Clear;
   end Clear;

end Displayable_Chess;
