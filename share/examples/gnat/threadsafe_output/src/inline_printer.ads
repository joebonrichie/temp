--  This package provides thread-safe calls to Put_Line for printing String
--  values. As such, any number of concurrent calls to Print may occur but the
--  actual calls to Put_Line will nonetheless occur sequentially. This is
--  possible because we use a protected object to act as a lock providing
--  mutually exclusive access to the standard output file. The calls to Put_Line
--  are made by the individual tasks calling Print, hence the term "inline" in
--  the package name.

package Inline_Printer is

   procedure Print (This : String);
   --  Calls Put_Line in a thread-safe manner by forcing the calling task to
   --  await mutually exclusive access to standard output.

private

   protected Mutex is
      entry Acquire;
      procedure Release;
   private
      Count : Natural := 1;
   end Mutex;
   --  Mutex is a lock used to acquire mutually exclusive access to standard
   --  output so that the Print procedure is thread-safe.

end Inline_Printer;

