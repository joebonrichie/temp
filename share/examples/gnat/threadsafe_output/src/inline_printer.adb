with GNAT.IO;

package body Inline_Printer is

   -----------
   -- Print --
   -----------

   procedure Print (This : String) is
   begin
      Mutex.Acquire;
      GNAT.IO.Put_Line (This);
      Mutex.Release;
   end Print;

   -----------
   -- Mutex --
   -----------

   protected body Mutex is

      entry Acquire when Count > 0 is
      begin
         Count := Count - 1;
      end Acquire;

      procedure Release is
      begin
         Count := Count + 1;
      end Release;

   end Mutex;

end Inline_Printer;

