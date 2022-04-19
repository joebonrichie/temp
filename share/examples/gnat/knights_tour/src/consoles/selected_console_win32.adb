with WIN32_Console;

package body Selected_Console is

   The_Selection : Console.Any_Device;

   --------------
   -- Instance --
   --------------
                       
   function Instance return Console.Any_Device is
      use type Console.Any_Device;
   begin
      if The_Selection = null then
         The_Selection := new WIN32_Console.Device;
      end if;
      return The_Selection;
   end Instance;

end Selected_Console;


