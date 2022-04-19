with Interfaces.C;

package Plugins is

   type Plugin is tagged private;

   function Load (Path : String) return Plugin;
      --  Attempts to load the plugin located at Path.
      --  Raises Not_Found with Path as the message if no plugin is
      --  located at Path.

   procedure Call (P : Plugin; Unit_Name : String);
      --  Attempts to call the function named Unit_Name within the plugin P.
      --  Raises Not_Found with the Unit_Name as the message if no such unit
      --  is present.

   function Call (P : Plugin; Unit_Name : String) return Interfaces.C.int;
      --  Attempts to call the function named Unit_Name within the plugin P
      --  and returns the result returned by that function.
      --  Raises Not_Found with the Unit_Name as the message if no such unit
      --  is present.

   Not_Found : exception;

   procedure Unload (P : in out Plugin);
      --  Remove the plugin from service.  Note the actual effect is
      --  operating-system dependent.

   function Autoinitialized return Boolean;
      --  Returns True if, under this implementation, initialization
      --  of plug-ins is automatic.  Otherwise returns False, in which case
      --  the user is required to manually initialize the plug-in.  Manual
      --  initialization is accomplished by calling (using one of the "Call"
      --  routines below), a function whose name is formed by the catenation
      --  of the plug-in name and "init".  For example, given a plug-in named
      -- "foo", the initialization function is named "fooinit".

private

   type Implementation;

   type Reference is access Implementation;

   type Plugin is tagged record
      Ref : Reference;
   end record;

end Plugins;
