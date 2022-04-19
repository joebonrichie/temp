package body Knight is

   type Offset is
      record
         R, C : Integer range -2 .. 2;
      end record;

   type Offset_Candidates is array (Possible_Moves'Range) of Offset;

   --  The following are used to compute the positions that can be
   --  visited using the knight's moves.
   Offsets : constant Offset_Candidates :=
      (1 => (2, 1),
       2 => (1, 2),
       3 => (-1, 2),
       4 => (-2, 1),
       5 => (-2, -1),
       6 => (-1, -2),
       7 => (1, -2),
       8 => (2, -1) );

   ---------
   -- "+" --
   ---------

   function "+" (M : Chess.Move; O : Offset) return Chess.Move is
      use Chess;
   begin
      return As_Move (Row(M) + O.R, Column(M) + O.C);
   end "+";

   ----------------
   -- Acceptable --
   ----------------

   function Acceptable
      (Board : Chess.Board'Class; Next : Chess.Move)
       return Boolean
   is
   begin
      return Board.Within_Bounds (Next) and then Board.Value_At (Next) = 0;
   end Acceptable;

   ----------------
   -- Candidates --
   ----------------

   function Candidates
      (Board : Chess.Board'Class;  Current : Chess.Move)
       return Move_Candidates
   is
      Result : Move_Candidates (Possible_Moves'Range);
      Next   : Chess.Move;
      Count  : Natural := 0;
   begin
      for K in Possible_Moves'Range loop
         Next := Current + Offsets (K);
         if Acceptable (Board, Next) then
            Count := Count + 1;
            Result (Count) := Next;
         end if;
      end loop;
      return Result (1 .. Count);
   end Candidates;

end Knight;

