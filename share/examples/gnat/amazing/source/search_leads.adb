-----------------------------------------
--
--  Copyright (C) 2013, AdaCore
--
-----------------------------------------

package body Search_Leads is

   use Searches;

   ----------
   -- Save --
   ----------

   procedure Save (Into : in out Repository;
                   Pos  : Maze.Position;
                   Path : Traversal.Trail)
   is
      New_Entry : Search_Info;
   begin
      New_Entry.Pos := Pos;
      Traversal.Copy (Path, To => New_Entry.Path);
      Searches.Append (New_Entry, To => Into.Content);
   end Save;

   -------------
   -- Restore --
   -------------

   procedure Restore (From : in out Repository;
                      Pos  :    out Maze.Position;
                      Path :    out Traversal.Trail)
   is
      Next : Search_Info;
      Last : constant Index := Length (From.Content);
   begin
      Next := Value (From.Content, Last);
      Pos := Next.Pos;
      Traversal.Copy (Next.Path, To => Path);
      Set_Length (From.Content, Last - 1);
   end Restore;

   -----------
   -- Empty --
   -----------

   function Empty (This : Repository) return Boolean is
   begin
      return Searches.Empty (This.Content);
   end Empty;

end Search_Leads;
