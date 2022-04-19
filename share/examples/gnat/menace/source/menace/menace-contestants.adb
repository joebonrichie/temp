package body Menace.Contestants is

   ----------------
   -- Initialize --
   ----------------

   procedure Initialize
     (This : in out Player;
      Id   : in     Player_Id;
      Name : in     Unbounded_String := Null_Unbounded_String)
   is
   begin
      This.My_Id := Id;
      This.Player_Name := Name;
   end Initialize;

   --------
   -- Id --
   --------

   function Id (This : Player) return Player_Id is
   begin
      return This.My_Id;
   end Id;

   ----------
   -- Name --
   ----------

   function Name (This : Player) return String is
   begin
      return To_String (This.Player_Name);
   end Name;

end Menace.Contestants;
