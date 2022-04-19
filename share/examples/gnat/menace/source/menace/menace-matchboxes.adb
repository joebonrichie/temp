package body Menace.Matchboxes is

   ------------
   -- Create --
   ------------

   procedure Create
     (This   : in out Matchbox;
      Layout : in     Menace.Boards.State_Number)
   is
   begin
      This.State_Num := Layout;
      This.Bead_Selector.Reset;
      This.Bead_Selector.Set_Weights (Initial_Weights (Layout));
      This.Opened_In_Play := False;
   end Create;

   -------------------
   -- Get_Next_Move --
   -------------------

   procedure Get_Next_Move
     (This : in out Matchbox;
      Move :    out Move_Locations)
   is
   begin
      if This.Bead_Selector.Total_Weight = 0 then
         --  enable one move by setting its weight to a non-zero value
         This.Bead_Selector.Set_Weights (First_Available (This.State_Num));
      end if;
      This.Selected_Bead := This.Bead_Selector.Random;
      Move := Bead_Colors'Pos (This.Selected_Bead) + 1;
      This.Opened_In_Play := True;
   end Get_Next_Move;

   ---------------------------------
   -- Adjust_Selected_Bead_Weight --
   ---------------------------------

   procedure Adjust_Selected_Bead_Weight
     (This       : in out Matchbox;
      Adjustment : in     Integer)
   is
      Bead_Weight : Natural;
   begin
      --  get the weight of the bead selected during play
      Bead_Weight := This.Bead_Selector.Current_Weights (This.Selected_Bead);
      --  set the weight of that selected bead to the sum of that weight and the
      --  adjustment factor
      This.Bead_Selector.Set_Weight
        (This.Selected_Bead,
         To => Integer'Max (0, Bead_Weight + Adjustment));
   end Adjust_Selected_Bead_Weight;

   -------------------
   -- Reinforce_Win --
   -------------------

   procedure Reinforce_Win (This : in out Matchbox) is
   begin
      This.Adjust_Selected_Bead_Weight (Win_Reinforcement);
   end Reinforce_Win;

   --------------------
   -- Reinforce_Loss --
   --------------------

   procedure Reinforce_Loss (This : in out Matchbox) is
   begin
      This.Adjust_Selected_Bead_Weight (Loss_Reinforcement);
   end Reinforce_Loss;

   --------------------
   -- Reinforce_Draw --
   --------------------

   procedure Reinforce_Draw (This : in out Matchbox) is
   begin
      This.Adjust_Selected_Bead_Weight (Draw_Reinforcement);
   end Reinforce_Draw;

   ----------------
   -- Play_State --
   ----------------

   function Play_State (This : Matchbox) return Menace.Boards.State is
   begin
      return Menace.Boards.State_For (This.State_Num);
   end Play_State;

   ------------
   -- Opened --
   ------------

   function Opened (This : Matchbox) return Boolean is
   begin
      return This.Opened_In_Play;
   end Opened;

   -----------
   -- Close --
   -----------

   procedure Close (This : in out Matchbox) is
   begin
      This.Opened_In_Play := False;
   end Close;

   ----------
   -- Read --
   ----------

   procedure Read
     (Stream : not null access Ada.Streams.Root_Stream_Type'Class;
      This   : out Matchbox)
   is
   begin
      Menace.Boards.State_Number'Read(Stream, This.State_Num);
      Random_Colors.Generator'Read (Stream, This.Bead_Selector);
      This.Opened_In_Play := False;
   end Read;

   -----------
   -- Write --
   -----------

   procedure Write
     (Stream : not null access Ada.Streams.Root_Stream_Type'Class;
      This   : in Matchbox)
   is
   begin
      Menace.Boards.State_Number'Write(Stream, This.State_Num);
      Random_Colors.Generator'Write (Stream, This.Bead_Selector);
   end Write;

   ---------------------
   -- Initial_Weights --
   ---------------------

   function Initial_Weights (Layout : Menace.Boards.State_Number)
      return Random_Colors.Relative_Weights
   is
      use Menace.Boards;

      Current : constant State := State_for (Layout);

      Move_Number : constant Integer range Beads_Per_Move'Range
            := Current.Moves_Made (By => Player_X);

      Result     : Random_Colors.Relative_Weights;
      Next_Color : Bead_Colors;
   begin
      for Next_Move in Move_Locations loop
         Next_Color := Bead_Colors'Val (Next_Move - 1);
         if Current.Player_At (Next_Move) = No_Player then
            Result (Next_Color) := Beads_Per_Move (Move_Number);
         else
            Result (Next_Color) := 0;
         end if;
      end loop;
      return Result;
   end Initial_Weights;

   ---------------------
   -- First_Available --
   ---------------------

   function First_Available (Layout : Menace.Boards.State_Number)
      return Random_Colors.Relative_Weights
   is
      use Menace.Boards;

      Current    : constant State := State_for (Layout);
      Result     : Random_Colors.Relative_Weights := (others => 0);
      Next_Color : Bead_Colors;
   begin
      for Next_Move in Move_Locations loop
         Next_Color := Bead_Colors'Val (Next_Move - 1);
         if Current.Player_At (Next_Move) = No_Player then
            Result (Next_Color) := 1;
            exit;
         end if;
      end loop;
      return Result;
   end First_Available;

end Menace.Matchboxes;
