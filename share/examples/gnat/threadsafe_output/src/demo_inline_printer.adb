--  This is a sample main program client using the "inline" printing approach,
--  in which the printing is done by the calling task, but with mutually
--  exclusive access to the output file.

with Inline_Printer;  use Inline_Printer;

procedure Demo_Inline_Printer is

   task type Producer;

   task body Producer is
      Witty_Remark : constant String :=
         "I've had a lovely evening. But this wasn't it. (Groucho Marx)";
   begin
      for K in 1 .. 100 loop
         Print (Witty_Remark);
      end loop;
   end Producer;

   Producers : array (1 .. 2) of Producer;
   --  The set of tasks concurrently calling Print.  The actual number of tasks
   --  is not important for this demo, as long as there is more than one.

begin
   null;
end Demo_Inline_Printer;

