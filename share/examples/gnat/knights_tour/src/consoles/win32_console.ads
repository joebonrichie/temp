--  The package defining the concrete subclass of Console.Device for
--  MS Windows console applications.

with Console;

package WIN32_Console is

   pragma Elaborate_Body;

   type Device is new Console.Device with private;

   procedure Move_Cursor (This : in out Device;  To : in Console.Location);

   procedure Clear (This : in out Device);

   Win32_Subsystem_Error : exception;

private

   type Device is new Console.Device with null record;

end WIN32_Console;
