--  This is the main program for interactive play between a human and a MENACE
--  engine.

with Ada.Text_IO;            use Ada.Text_IO;
with Ada.Strings.Unbounded;  use Ada.Strings.Unbounded;
with HCI;                    use HCI;

with Menace.Contests;
with Menace.Machines;
with Menace.Humans;
use  Menace;

procedure Play is
   Game      : Contests.Game;
   Machine   : Machines.Engine;
   Human     : Humans.Player;
   Next_Move : Move_Locations;
   Name      : Unbounded_String;
   Quit      : Boolean;
begin
   Get_Engine_Name (Name, Quit);
   if Quit then
      Put_Line ("OK, goodbye.");
      return;
   end if;

   Machine.Initialize (Player_X, Name);  -- the engine is always Player X
   Human.Initialize   (Player_O);

   All_Games : loop
      New_Line;
      Explain_Play (Game, Machine);

      Single_Game : loop
         Machine.Get_Next_Move (Game, Next_Move);
         Game.Mark (Player => Machine.Id, Move => Next_Move);

         exit when Game.Completed (Next_Player => Human.Id);

         Game.Display;

         Human.Get_Next_Move (Game, Next_Move);
         Game.Mark (Player => Human.Id, Move => Next_Move);

         exit when Game.Completed (Next_Player => Machine.Id);
      end loop Single_Game;

      Game.Display;
      Announce_Result (Game, Machine);

      Machine.Analyze (Game);
      Machine.Save;

      Game.Reset;

      New_Line;
      exit when not Affirmative ("Play again? ");
   end loop All_Games;
end Play;
