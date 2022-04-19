--  This is a sample main program client using the "concurrent" printing
--  approach, in which the actual printing is done by a distinct, dedicated
--  task.

with Concurrent_Printer;  use Concurrent_Printer;

procedure Demo_Concurrent_Printer is

   task type Producer is
      entry Completed;
   end Producer;

   task body Producer is
      Witty_Remark : aliased constant String :=
         "I've had a lovely evening. But this wasn't it. (Groucho Marx)";
   begin
      for K in 1 .. 100 loop
         Print (Witty_Remark'Unchecked_Access);
      end loop;
      accept Completed;
   end Producer;

   Producers : array (1 .. 2) of Producer;
   --  The set of tasks concurrently calling Print.  The actual number of tasks
   --  is not important for this demo, as long as there is more than one.

begin
   for K in Producers'Range loop
      Producers (K).Completed;
   end loop;
   Shutdown;
end Demo_Concurrent_Printer;

