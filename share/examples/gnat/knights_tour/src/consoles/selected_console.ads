--  This package defines a factory function providing the concrete console
--  device to be used, via the access type designating the class-wide type.
--  Different bodies of the package will return different subclasses of the
--  abstract type.

with Console;

package Selected_Console is

   function Instance return Console.Any_Device;

end Selected_Console;
