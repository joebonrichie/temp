with Ada.Directories;
with Ada.Streams.Stream_IO;  use Ada.Streams;
with GNAT.IO;                use GNAT.IO;

package body Menace.Machines is

   use Menace, Menace.Matchboxes;

   ----------------
   -- Initialize --
   ----------------

   procedure Initialize
     (This : in out Engine;
      Id : in Player_Id;
      Name : in Unbounded_String := Null_Unbounded_String)
   is
      File        : Stream_IO.File_Type;
      File_Stream : Stream_IO.Stream_Access;
      Loaded      : Boolean := False;
   begin
      --  call the parent version
      Contestants.Initialize (Contestants.Player (This), Id, Name);

      if Ada.Directories.Exists (To_String (Name)) then
         begin
            Stream_IO.Open (File, Stream_IO.In_File, To_String (Name));
            File_Stream := Stream_IO.Stream (File);
            --  restore the state of the matchboxes
            for K in This.Boxes'Range loop
               Matchbox'Read (File_Stream, This.Boxes (K));
            end loop;
            Stream_IO.Close (File);
            Loaded := True;
         exception
            when others =>
               Put_Line ("Failure loading player named '" &
                         To_String (Name) & "'");
         end;
      end if;

      if not Loaded then
         Put_Line ("Creating a player named '" & To_String (Name) & "'");
         for K in This.Boxes'Range loop
            This.Boxes (K).Create (Layout => K);
         end loop;
      end if;
   end Initialize;

   -------------------
   -- Get_Next_Move --
   -------------------

   procedure Get_Next_Move
     (This    : in out Engine;
      Contest : in     Menace.Contests.Game;
      Move    :    out Move_Locations)
   is
      use Menace.Boards;

      Index : State_Number;
      Found : Boolean := False;

      Current_Game : constant State := Current_State (Contest);
   begin
      --  find matchbox matching current game state
      for K in This.Boxes'Range loop
         if This.Boxes (K).Play_State = Current_Game then
            Index := K;
            Found := True;
            exit;
         end if;
      end loop;
      if not Found then
         raise Program_Error with "Could not find matchbox with state '" &
            Current_Game.Image & "'";
      end if;
      --  get next move from matchbox
      This.Boxes (Index).Get_Next_Move (Move);
   end Get_Next_Move;

   ----------
   -- Save --
   ----------

   procedure Save (This : in Engine) is
      File        : Stream_IO.File_Type;
      File_Stream : Stream_IO.Stream_Access;
   begin
      Stream_IO.Create (File, Stream_IO.Out_File, This.Name);
      File_Stream := Stream_IO.Stream (File);
      for K in This.Boxes'Range loop
         Matchbox'Write (File_Stream, This.Boxes (K));
      end loop;
      Stream_IO.Close (File);
   end Save;

   -------------
   -- Analyze --
   -------------

   procedure Analyze
     (This    : in out Engine;
      Contest : in Menace.Contests.Game)
   is
      Winner : constant Player_Id := Contest.Winner;
   begin
      for K in This.Boxes'Range loop
         if This.Boxes (K).Opened then
            if This.Id = Winner then
               This.Boxes (K).Reinforce_Win;
            elsif Winner = No_Player then
               This.Boxes (K).Reinforce_Draw;
            else
               This.Boxes (K).Reinforce_Loss;
            end if;

            This.Boxes (K).Close;
         end if;
      end loop;
   end Analyze;

end Menace.Machines;
