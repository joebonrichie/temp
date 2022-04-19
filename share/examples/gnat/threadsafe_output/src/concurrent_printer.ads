--  This package provides thread-safe calls to Put_Line for printing String
--  values. As such, any number of concurrent calls to Print may occur but the
--  actual calls to Put_Line will nonetheless occur sequentially. In addition,
--  the actual calls to Put_Line occur concurrently with the tasks producing the
--  strings, thereby decoupling their rates. This is possible because we use a
--  dedicated task to do the printing, with a circular bounded buffer to hold
--  the values to be printed.

with GNAT.Bounded_Buffers;
with Ada.Characters.Latin_1;

package Concurrent_Printer is

   procedure Print (This : access constant String);
   --  Prints the designated string in a thread-safe manner. Printing is not
   --  done immediately, during the call, because the effect is to place the
   --  access value into a buffer. Note that this buffered approach requires the
   --  use of an access type designating String values, so we use an access
   --  parameter for Print.

   procedure Shutdown;
   --  Causes the internal printing task to complete and terminate.

private

   --  All these declarations are here, rather than in the package body, for the
   --  sake of future child packages, if any.

   type String_Pointer is access constant String;
   --  We cannot directly hold indefinite types in our buffer so use a level of
   --  indirection. We never mean to change the values while holding them, and
   --  we want to be able to print constant strings too, so we use a general
   --  access-to-constant access type.

   package Strings is
      new GNAT.Bounded_Buffers (String_Pointer);
   --  The package instance for circular bounded buffers containing string
   --  pointers.

   Pending : Strings.Bounded_Buffer
      (Capacity => 1_000,
       Ceiling  => Strings.Default_Ceiling);
   --  The circular bounded buffer containing the string pointers awaiting
   --  printing. The Capacity value is arbitrary.

   task Printer;
   --  The task that takes string pointers from the Pending buffer and prints
   --  them. It runs until shut down by a call to Shutdown.

   Shutdown_Sequence : aliased constant String
      := (1 .. 1 => Ada.Characters.Latin_1.ETX);
   --  The shutdown procedure inserts an access value designating this string
   --  into the buffer. The Printer task recognizes it and completes.

end Concurrent_Printer;


