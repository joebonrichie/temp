with GNAT.IO;

package body Concurrent_Printer is

   -----------
   -- Print --
   -----------

   procedure Print (This : access constant String) is
   begin
      Pending.Insert (String_Pointer (This));
   end Print;

   ---------------
   --  Shutdown --
   ---------------

   procedure Shutdown is
   begin
      Pending.Insert (Shutdown_Sequence'Access);
   end Shutdown;

   -------------
   -- Printer --
   -------------

   task body Printer is
      Next  : String_Pointer;
   begin
      loop
         Pending.Remove (Next);
         exit when Next.all = Shutdown_Sequence;
         GNAT.IO.Put_Line (Next.all);
      end loop;
   end Printer;

end Concurrent_Printer;

