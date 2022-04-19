
with Ada.Text_IO;  use Ada.Text_IO;
with GNAT.Sockets; use GNAT.Sockets;

with Hierarchy;    use Hierarchy;
with Common;

package body Client is

   task body Worker is
      Address  : Sock_Addr_Type;
      Socket   : Socket_Type;
      Channel  : Stream_Access;

   begin
      accept Start;

      --  Connect to the server

      Address.Addr := Addresses (Get_Host_By_Name (Host_Name), 1);
      Address.Port := Common.Port;
      Create_Socket (Socket);

      Connect_Socket (Socket, Address);

      --  Connected, use a stream connected to the socket

      Channel := Stream (Socket);

      declare
         O1 : Base  := (Priority => 5);
         O2 : Child := (9, 'z');
      begin
         Put_Line ("(client) O1 size " & Integer'Image (O1'Size));
         Base'Class'Output (Channel, O1);  -- class wide streaming

         New_Line;
         Put_Line ("(client) O2 size " & Integer'Image (O2'Size));
         Child'Class'Output (Channel, O2); -- class wide streaming
      end;
   end Worker;

end Client;
