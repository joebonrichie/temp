------------------------------------------------------------------------------
--
--  Copyright (C) 2008-2012, AdaCore
--
------------------------------------------------------------------------------

with Ada.Directories;
with Ada.Text_IO;  use Ada.Text_IO;

package body Menace.Boards is

   ---------
   -- "=" --
   ---------

   function "=" (Left, Right : State) return Boolean is
   begin
      return Left.Representation = Right.Representation;
   end "=";

   ---------------
   -- State_For --
   ---------------

   function State_For (Id : State_Number) return State is
   begin
      return State'(Representation => Player_X_States.Element (Id));
   end State_For;

   -------------------
   -- Current_State --
   -------------------

   function Current_State (G : Game) return State is
      Result : State;
   begin
      for K in Move_Locations loop
         Result.Representation (K) := As_Player_Image (G.Player_At (K));
      end loop;
      return Result;
   end Current_State;

   ----------------
   -- Moves_Made --
   ----------------

   function Moves_Made (This : State;  By : Player_Id) return Natural is
      Result : Natural := 0;
   begin
      for K in This.Representation'Range loop
         if This.Representation (K) = As_Player_Image (By) then
            Result := Result + 1;
         end if;
      end loop;
      return Result;
   end Moves_Made;

   ---------------
   -- Player_At --
   ---------------

   function Player_At (This : State;  Move : Move_Locations)
      return Player_Id
   is
   begin
      if This.Representation (Move) = As_Player_Image (Player_X) then
         return Player_X;
      elsif This.Representation (Move) = As_Player_Image (Player_O) then
         return Player_O;
      else
         return No_Player;
      end if;
   end Player_At;

   -----------
   -- Image --
   -----------

   function Image (This : State) return State_Image is
   begin
      return This.Representation;
   end Image;

   --------------------------
   -- Conditionally_Insert --
   --------------------------

   procedure Conditionally_Insert
      (New_Board : Game; Into : in out Board_States.Vector)
   is
      use Board_States;

      Current : constant State := Current_State (New_Board);
   begin
      --  ignore boards already present in the vector
      if Into.Find_Index (Current.Image) /= No_Index then
         return;
      end if;

      Into.Append (Current.Image);
   end Conditionally_Insert;

   --------------
   -- Generate --
   --------------

   procedure Generate
     (States   : in out Board_States.Vector;
      Contest  :        Game;
      Previous :        Player_Id)
   is
      Next_Player : Player_Id;
      New_Game    : Game;
   begin
      Next_Player := Opponent (Previous);
      for Next_Move in Move_Locations loop
         if Contest.Player_At (Next_Move) = No_Player then
            New_Game := Contest;
            New_Game.Mark (Next_Player, Next_Move);
            --  we can ignore layouts that match a game already won
            if New_Game.Winner = No_Player then
               if Previous = Player_X then
                  Conditionally_Insert (New_Game, Into => States);
               end if;
               Generate (States, New_Game, Next_Player);
            end if;
         end if;
      end loop;
   end Generate;

   -----------------------------
   -- Load_Precomputed_States --
   -----------------------------

   procedure Load_Precomputed_States is
      File   : File_Type;
      Loaded : Boolean := False;
      Str    : State_Image;
   begin
      if Ada.Directories.Exists (Precomputed_States_Name) then
         begin
            Open (File, In_File, Precomputed_States_Name);
            while not End_of_File (File) loop
               Get (File, Str);
               Player_X_States.Append (Str);
            end loop;
            Close (File);
            Loaded := True;
         exception
            when others =>
               null;
         end;
      end if;

      if not Loaded then
         Put_Line ("Generating board states file (once). Please wait...");

         Player_X_States.Clear;  -- in case it was partially loaded above
         declare
            New_Game : Game;
         begin
            Player_X_States.Append (Current_State (New_Game).Image);
            Generate (Player_X_States, New_Game, Previous => Player_O);
         end;

         Create (File, Out_File, Precomputed_States_Name);
         for K in 1 .. Player_X_States.Length loop
            Put_Line (File, Player_X_States.Element (State_Number (K)));
         end loop;
         Close (File);
      end if;
   end Load_Precomputed_States;

begin
   Load_Precomputed_States;
end Menace.Boards;
