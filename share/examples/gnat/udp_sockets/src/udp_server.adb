-------------------------------------------------------------------------------
--  Simple UDP server
--  Usage: server <port>
--  This server receives UDP datagrams and displays them. It exits when the
--  received payload is "quit".

with Ada.Command_Line; use Ada.Command_Line;
with Ada.Streams;      use Ada.Streams;
with Ada.Text_IO;      use Ada.Text_IO;

with GNAT.Sockets;     use GNAT.Sockets;

procedure UDP_Server is
   Addr  : Sock_Addr_Type;
   Sock  : Socket_Type;
   Sel   : Selector_Type;
   Req   : Request_Type;
   R_Set : Socket_Set_Type;
   W_Set : Socket_Set_Type;

   Poll_Interval : constant Duration := 5.0;
   Status        : Selector_Status;
begin
   if Argument_Count /= 1 then
      Put_Line ("Usage: server <port>");
      return;
   end if;

   --  Create UDP socket

   Create_Socket (Sock, Family_Inet, Socket_Datagram);

   --  Set socket to non-blocking mode

   Req := (Name => Non_Blocking_IO, Enabled => True);
   Control_Socket (Sock, Req);

   --  Bind socket, i.e. set the address and port it is listening on

   Addr.Addr := Any_Inet_Addr;
   Addr.Port := Port_Type'Value (Argument (1));
   Bind_Socket (Sock, Addr);

   --  Create selector object

   Create_Selector (Sel);

   --  Loop on Check_Selector, blocking up to Poll_Interval seconds at each
   --  iteration.

   Server_Loop : loop
      --  Start with empty sets

      Empty (R_Set);
      Empty (W_Set);

      --  Include Sock in Read set

      Set (R_Set, Sock);

      --  Wait for read events

      Put_Line ("About to Check_Selector");
      Check_Selector (Sel, R_Set, W_Set, Status, Poll_Interval);
      Put_Line ("Check_Selector returned with status " & Status'Img);

      --  Check return status

      case Status is
         when Completed =>
            --  Expected event received: data is available for reading on
            --  Sock, the following call is guaranteed to return data without
            --  blocking.

            declare
               Buffer : Stream_Element_Array (1 .. 1024);
               Last   : Stream_Element_Offset;
            begin
               Receive_Socket (Sock, Buffer, Last);

               --  Convert Buffer to String

               declare
                  Str : String (1 .. Integer (Last));
                  for Str'Address use Buffer'Address;

                  --  The pragma Import below is not used to alter any
                  --  representation convention but has the vital side
                  --  effect of suppressing default initialization.
                  pragma Import (Ada, Str);

               begin
                  Put_Line ("Received string: <<" & Str & ">>");
                  exit Server_Loop when Str = "quit";
               end;
            end;

         when Expired =>
            --  Time out: no event occurred during poll interval

            null;

         when Aborted =>
            --  Another task called Abort_Selector (cannot happen in this
            --  simple demo without tasking).

            null;
      end case;
   end loop Server_Loop;

   --  Cleanup

   Close_Socket (Sock);
   Close_Selector (Sel);
end UDP_Server;
