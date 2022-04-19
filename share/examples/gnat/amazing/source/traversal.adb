-----------------------------------------
--
--  Copyright (C) 2008-2013, AdaCore
--
-----------------------------------------

with Console;

package body Traversal is

   use Positions;

   ----------
   -- Mark --
   ----------

   procedure Mark
      (Point  :        Maze.Position;
       Past   : in out Trail;
       Within :        Maze.Reference;
       Next   :    out Maze.Positions;
       Last   :    out Maze.Moves)
   is
      Candidates : constant Maze.Positions := Maze.Next (Within, Point);
      Count      : Maze.Moves := 0;

      use type Maze.Moves;
   begin
      if Length (Past.Solutions) /= 0 then -- we've visited some locations
         --  take only candidates that we've not already visited
         for K in Candidates'Range loop
            if not Previously_Visited (Candidates (K), Past) then
               Count := Count + 1;
               Next (Count) := Candidates (K);
            end if;
         end loop;
         Last := Count;
      else -- none visited as yet so take all candidate positions
         Next (Candidates'Range) := Candidates;
         Last := Candidates'Last;
      end if;

      Append (Point, To => Past.Solutions);

      if Last > 1 then -- Point is an intersection
         Append (Point, To => Past.Intersections);
      end if;
   end Mark;

   ------------------------
   -- Previously_Visited --
   ------------------------

   function Previously_Visited (This : Maze.Position; Past : Trail)
      return Boolean
   is
      Last_Index  : constant Natural := Length (Past.Solutions);
      Predecessor : constant Maze.Position := Value (Past.Solutions, Last_Index);
      --  the position we just came from
      --  calling this only makes sense when Past.Solutions is not empty
      use type Maze.Position;
   begin
      return This = Predecessor or else Is_Member (This, Past.Intersections);
   end Previously_Visited;

   ---------------
   -- Is_Member --
   ---------------

   function Is_Member (This : Maze.Position;  Within : Positions.Sequence) return Boolean is
   begin
      return Location (This, Within) /= 0;
   end Is_Member;

   ----------
   -- Plot --
   ----------

   procedure Plot (This : Trail) is
      use Maze;
   begin
      for K in 1 .. Length (This.Solutions) loop
         declare
            Point : Position renames Value (This.Solutions, K);
         begin
            Console.Instance.Plot_Solution_Point ((Row (Point), Column (Point)));
         end;
      end loop;
   end Plot;

   ----------
   -- Copy --
   ----------

   procedure Copy (Source : in Trail; To : out Trail) is
   begin
      Copy (Source.Intersections, To => To.Intersections);
      Copy (Source.Solutions,     To => To.Solutions);
   end Copy;

end Traversal;
