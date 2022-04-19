-------------------------------------------------------------------------------
--  Simple UDP client
--  Usage: client <host> <port> <message>
--  Sends the given message as the payload of an UDP datagram to <host>:<port>.

with Ada.Command_Line; use Ada.Command_Line;
with Ada.Streams;      use Ada.Streams;
with Ada.Text_IO;      use Ada.Text_IO;

with GNAT.Sockets;     use GNAT.Sockets;

procedure UDP_Client is
   Dest_Addr : Sock_Addr_Type;
   Sock      : Socket_Type;

begin
   if Argument_Count /= 3 then
      Put_Line ("Usage: udp_client <host> <port> <message>");
      return;
   end if;

   --  Create UDP socket

   Create_Socket (Sock, Family_Inet, Socket_Datagram);

   --  Prepare destination address

   Dest_Addr.Addr := Addresses (Get_Host_By_Name (Argument (1)), 1);
   Dest_Addr.Port := Port_Type'Value (Argument (2));

   --  Send message

   declare
      --  Message as a string

      Str : constant String := Argument (3);

      --  Convert to stream element array by overlaying

      Buf : Stream_Element_Array (1 .. Str'Length);
      for Buf'Address use Str'Address;

      --  The pragma Import below is not used to alter any representation
      --  convention but has the vital side effect of suppressing default
      --  initialization.
      pragma Import (Ada, Buf);

      Last : Stream_Element_Offset;
   begin
      Send_Socket (Sock, Buf, Last, Dest_Addr);
   end;

   --  Cleanup

   Close_Socket (Sock);
end UDP_Client;
