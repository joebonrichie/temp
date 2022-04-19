with Knight;

package body Knight_Traversal is

   type Prioritized_Move is
      record
         Candidate    : Chess.Move;
         Number_Exits : Integer;
      end record;

   type Prioritized_Move_List is array (Integer range <>) of Prioritized_Move;

   procedure Sort (The_List : in out Prioritized_Move_List);
   --  Sorts moves by number of subsequent exits.

   procedure Get_Prioritized_Moves
      (Board      : in     Chess.Board'Class;
       Current    : in     Chess.Move;
       Next_Moves :    out Knight.Move_Candidates;
       Num_Moves  :    out Natural);
   --  From the Current move, loads all the moves we can make from there into
   --  Next_Moves.  Next_Moves is in ascending order by number of subsequent
   --  moves possible, so that the one (ones) with the least number of places
   --  to go next is chosen sooner, rather than later.  Effectively we are
   --  looking ahead to take the move that has the least subsequent options.
   --  That will reduce the backtracking and so make the overall program
   --  faster.  The benefit of this prioritization is quite significant.

   procedure Try_Next
      (Board        : in out Chess.Board'Class;
       Move_Count   : in     Positive;
       Current_Move : in     Chess.Move;
       Successful   :    out Boolean);
   --  Recursively traverses the board.  This is the fundamental routine.

   ---------------------------
   -- Get_Prioritized_Moves --
   ---------------------------

   procedure Get_Prioritized_Moves
      (Board      : in     Chess.Board'Class;
       Current    : in     Chess.Move;
       Next_Moves :    out Knight.Move_Candidates;
       Num_Moves  :    out Natural)
   is

      Prioritized_Moves : Prioritized_Move_List (Knight.Possible_Moves'Range);

      procedure Get_Potential_Moves is
         Moves : constant Knight.Move_Candidates :=
            Knight.Candidates (Board, Current);
      begin
         for K in Moves'Range loop
            Prioritized_Moves (K).Candidate := Moves (K);
         end loop;
         Num_Moves := Moves'Length;  --  sets the formal parameter
      end Get_Potential_Moves;

      procedure Count_Exits_Per_Move is
         Next_Choice  : Chess.Move;
      begin
         for K in 1 .. Num_Moves loop
            Next_Choice := Prioritized_Moves (K).Candidate;
            --  Determine number of subsequent moves possible from Next_Choice
            Prioritized_Moves (K).Number_Exits :=
               Knight.Candidates (Board, Next_Choice)'Length;
         end loop;
      end Count_Exits_Per_Move;

   begin
      Get_Potential_Moves;
      Count_Exits_Per_Move;
      Sort (Prioritized_Moves (1 .. Num_Moves));
      for K in 1 .. Num_Moves loop
         Next_Moves (K) := Prioritized_Moves (K).Candidate;
      end loop;
   end Get_Prioritized_Moves;

   --------------
   -- Try_Next --
   --------------

   procedure Try_Next
      (Board        : in out Chess.Board'Class;
       Move_Count   : in     Positive;
       Current_Move : in     Chess.Move;
       Successful   :    out Boolean)
   is
      Candidate        : Chess.Move;
      Successors       : Knight.Move_Candidates (Knight.Possible_Moves'Range);
      Number_Available : Integer;
      Total_Possible   : constant Integer := Board.Side_Size ** 2;
   begin
      Successful := False;
      Get_Prioritized_Moves (Board, Current_Move, Successors, Number_Available);
      for K in 1 .. Number_Available loop
         Candidate := Successors (K);
         Board.Record_Move (Candidate, Move_Count);
         if Move_Count = Total_Possible then
            Successful := True;
         else -- more moves to go
            Try_Next (Board, Move_Count + 1, Candidate, Successful);
            if not Successful then
               Board.Erase_Move (Candidate);
            end if;
         end if;
         exit when Successful;
      end loop;
   end Try_Next;

   ----------
   -- Tour --
   ----------

   procedure Tour
      (Board        : in out Chess.Board'Class;
       Initial_Move : in     Chess.Move;
       Success      :    out Boolean)
   is
   begin
      Board.Record_Move (Initial_Move, Move_Count => 1);
      Knight_Traversal.Try_Next
         (Board,
          Move_Count => 2,
          Current_Move => Initial_Move,
          Successful => Success);
   end Tour;

   ----------
   -- Sort --
   ----------

   procedure Sort (The_List : in out Prioritized_Move_List)
      --  Straight_Insertion is OK for such a small list
   is
      Sentinel : Prioritized_Move;
      Inner    : Integer;
   begin
      for Outer in The_List'First + 1 .. The_List'Last loop
         Sentinel := The_List (Outer);
         Inner := Outer;
         while The_List (Inner - 1).Number_Exits > Sentinel.Number_Exits loop
            The_List (Inner) := The_List (Inner - 1);
            Inner := Inner - 1;
            exit when Inner = The_List'First;
         end loop;
         The_List (Inner) := Sentinel;
      end loop;
   end Sort;

end Knight_Traversal;

