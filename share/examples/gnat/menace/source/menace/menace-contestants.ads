with Menace.Contests;
with Ada.Strings.Unbounded;  use Ada.Strings.Unbounded;

package Menace.Contestants is

   type Player is abstract tagged limited private;
   --  The abstract base type for all players, including engines and humans.

   type Any_Player is access all Player'Class;

   procedure Initialize
     (This : in out Player;
      Id   : in     Player_Id;
      Name : in     Unbounded_String := Null_Unbounded_String);
   --  Sets the name and Id (Player_X or Player_O) for this player.

   function Id (This : Player) return Player_Id;

   function Name (This : Player) return String;
   --  the name on the file system

   procedure Get_Next_Move
     (This    : in out Player;
      Contest : in     Menace.Contests.Game;
      Move    :    out Move_Locations)
      is abstract;

   procedure Save (This : in Player) is null;

   procedure Analyze (This : in out Player; Contest : in Menace.Contests.Game)
      is null;

private

   type Player is abstract tagged limited
      record
         My_Id       : Player_Id;
         Player_Name : Unbounded_String;
      end record;

end Menace.Contestants;
