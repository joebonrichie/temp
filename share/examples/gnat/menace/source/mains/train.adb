--  This is the main program for automatically training an engine. You specify
--  the name of the engine and the number of games to be played, on the command
--  line. If the engine does not currently exist it will be created; otherwise
--  it will be loaded from the corresponding file. You may also optionally
--  specify the first move that the engine should make, which is useful for
--  starting at what you consider the "best" position to start a game (eg, the
--  center position).

with Ada.Text_IO;            use Ada.Text_IO;
with Ada.Command_Line;       use Ada.Command_Line;
with Ada.Strings.Unbounded;  use Ada.Strings.Unbounded;

with Menace.Contests;
with Menace.Trainers;
with Menace.Machines.Training;
use  Menace;

procedure Train is
   Game      : Contests.Game;
   Machine   : Machines.Engine;
   Trainer   : Trainers.Coach;
   Next_Move : Move_Locations;

   Games_To_Play : Integer;
   Move_From_Command_Line  : Integer;

   Wins      : Natural := 0;
   Losses    : Natural := 0;
   Draws     : Natural := 0;

   Should_Get_Move : Boolean;

   procedure Help is
   begin
      Put_Line ("You must first specify the name of the player to train and " &
                "then the number of games to play.");
      Put_Line ("You can optionally specify the starting move as the 3rd " &
                "argument.");
      Put_Line ("The player will be created if it does not already exist.");
   end Help;

begin
   if Argument_Count not in 2 .. 3 then
      Help;
      return;
   end if;

   begin
      Games_To_Play := Integer'Value (Argument (2));
      if Games_To_Play < 1 then
         Put_Line ("You must specify a number of games to play > 0");
         return;
      end if;
   exception
      when others =>
         Put_Line ("Argument #2 ('" & Argument (2) & "') is not a legal " &
                   "integer value.");
         Help;
         return;
   end;

   if Argument_Count = 3 then
      begin
         Move_From_Command_Line := Integer'Value (Argument (3));
         if Move_From_Command_Line not in Move_Locations then
            Put_Line ("Argument #3, when given, must be in the range 1 .. 9.");
            return;
         end if;
      exception
         when others =>
            Put_Line ("Argument #3 ('" & Argument (3) & "') is not a legal " &
                      "integer value.");
            Help;
            return;
      end;
   end if;

   Machine.Initialize (Player_X, Name => To_Unbounded_String (Argument (1)));
   Trainer.Initialize (Player_O, Name => Null_Unbounded_String);
      -- the "master with no name" ...

   All_Games : for Iteration in 1 .. Games_To_Play loop
      if Argument_Count = 3 then
         Next_Move := Move_From_Command_Line;
         Menace.Machines.Training.Set_Next_Move (Machine, Game, Next_Move);
         Should_Get_Move := False;
      else
         Should_Get_Move := True;
      end if;

      Single_Game : loop
         if Should_Get_Move then
            Machine.Get_Next_Move (Game, Next_Move);
         end if;
         Game.Mark (Player => Machine.Id, Move => Next_Move);

         exit Single_Game when Game.Completed (Next_Player => Trainer.Id);

         Trainer.Get_Next_Move (Game, Next_Move);
         Game.Mark (Player => Trainer.Id, Move => Next_Move);

         exit Single_Game when Game.Completed (Next_Player => Machine.Id);

         Should_Get_Move := True;
      end loop Single_Game;

      Machine.Analyze (Game);

      if Game.Winner = No_Player then
         Draws := Draws + 1;
      elsif Game.Winner = Machine.Id then
         Wins := Wins + 1;
      else
         Losses := Losses + 1;
      end if;

      Game.Reset;
   end loop All_Games;

   Machine.Save;

   Put_Line ("'" & Machine.Name & "' won" & Wins'Img & " times");
   Put_Line ("'" & Machine.Name & "' lost" & Losses'Img & " times");
   Put_Line ("There were" & Draws'Img & " draws");
end Train;

