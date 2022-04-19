--  The package defining the concrete subclass of Console.Device for
--  devices supporting ANSI escape sequences.

with Console;

package ANSI_Console is

  type Device is new Console.Device with private;

   procedure Move_Cursor (This : in out Device;  To : in Console.Location);

   procedure Clear (This : in out Device);

private

  type Device is new Console.Device with null record;

end ANSI_Console;
