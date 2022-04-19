with Ada.Text_IO;      use Ada.Text_IO;
with Ada.Command_Line; use Ada.Command_Line;
with Ada.Directories;  use Ada.Directories;

package body HCI is

   procedure Get_Existing_Player_Name
      (Name : out Unbounded_String; Quit : out Boolean);
   --  Interacts with the human player to get the name of a file representing a
   --  MENACE engine to be played. The file must exist, if specified, but the
   --  human can abandon the process, in which case Quit will be True rather
   --  than False.

   procedure Get_New_Player_Name
      (Name : out Unbounded_String; Quit : out Boolean);
   --  Interacts with the human player to get the name of a file representing a
   --  new engine to be created.  A file by the specified name must not already
   --  exist, otherwise the routine will not exit.  However, the user has the
   --  option of abandoning the process, in which case Quit will be True
   --  rather than False.

   ---------------------
   -- Announce_Result --
   ---------------------

   procedure Announce_Result (Contest  : in Menace.Contests.Game;
                              Opponent : in Menace.Machines.Engine)
   is
   begin
      if Contest.Winner = No_Player then
         Put_Line ("The game ends in a draw...");
      elsif Contest.Winner = Opponent.Id then
         Put_Line ("'" & Opponent.Name & "' wins.");
      else
         Put_Line ("Congratulations, you won!");
      end if;
   end Announce_Result;

   ---------------------
   -- Get_Engine_Name --
   ---------------------

   procedure Get_Engine_Name
      (Name : out Unbounded_String;  Quit : out Boolean)
   is
   begin
      Quit := False;
      if Argument_Count = 1 then
         if Exists (Argument (1)) then
            Name := To_Unbounded_String (Argument (1));
         else
            Put_Line ("Player '" & Argument (1) & "' cannot be found.");
            Put_Line ("If you want to create a new player just invoke the");
            Put_Line ("program without any arguments and answer accordingly.");
            Quit := True;
         end if;

      elsif Argument_Count > 1 then
         Put_Line ("Too many arguments. You may specify one file name " &
                   "indicating the computer opponent to play.");
         Quit := True;

      else --  no file name on command line
         if Affirmative ("Do you want to play an existing player (y/n)? ") then
            Get_Existing_Player_Name (Name, Quit);
         elsif Affirmative ("Do you want to create a new player (y/n)? ") then
            Get_New_Player_Name (Name, Quit);
         else --  exit the program
            Quit := True;
         end if;
      end if;
   end Get_Engine_Name;

   -----------------
   -- Affirmative --
   -----------------

   function Affirmative (Question : String) return Boolean is
      Response : Character;
   begin
      Conversation : loop
         Put (Question);
         Get_Immediate (Response);
         Put (Response);
         New_Line;
         exit Conversation when
           (Response = 'y' or Response = 'Y') or
           (Response = 'n' or Response = 'N');
         Put_Line ("Answer y or n");
      end loop Conversation;
      return Response = 'Y' or Response = 'y';
   end Affirmative;

   ------------------------------
   -- Get_Existing_Player_Name --
   ------------------------------

   procedure Get_Existing_Player_Name
      (Name : out Unbounded_String; Quit : out Boolean)
   is
      Response : String (1 .. 1024);
      Last     : Integer range Response'First - 1 .. Response'Last;
   begin
      loop
         Put ("Enter the name of the existing player (Return to quit): ");
         Get_Line (Response, Last);
         if Last = Response'First - 1 then
            Quit := True;
            exit;
         end if;
         if Exists (Response (1..Last)) then
            Name := To_Unbounded_String (Response (1..Last));
            Quit := False;
            exit;
         else
            Put_Line ("A player with that name cannot be found.");
         end if;
      end loop;
   end Get_Existing_Player_Name;

   -------------------------
   -- Get_New_Player_Name --
   -------------------------

   procedure Get_New_Player_Name
      (Name : out Unbounded_String; Quit : out Boolean)
   is
      Response : String (1 .. 1024);
      Last     : Integer range Response'First - 1 .. Response'Last;
   begin
      loop
         Put ("What will be the name of this new player (Return to quit): ");
         Get_Line (Response, Last);
         if Last = Response'First - 1 then
            Quit := True;
            exit;
         end if;
         if Exists (Response (1..Last)) then
            Put_Line ("A player with that name already exists.");
         else
            Name := To_Unbounded_String (Response (1..Last));
            Quit := False;
            exit;
         end if;
      end loop;
   end Get_New_Player_Name;

   ------------------
   -- Explain_Play --
   ------------------

   procedure Explain_Play
      (Contest : in Contests.Game;
       Player  : in Machines.Engine)
   is
   begin
      Put_Line ("You choose moves by number, as shown below:");
      Contest.Display (Show_Numbers => True);
      Put_Line ("'" & Player.Name & "' is X and so goes first.");
   end Explain_Play;

end HCI;
