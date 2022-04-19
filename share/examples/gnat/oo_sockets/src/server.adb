
with Ada.Text_IO;  use Ada.Text_IO;
with GNAT.Sockets; use GNAT.Sockets;

with Hierarchy;    use Hierarchy;
with Common;

package body Server is

   task body Worker is
      Address : Sock_Addr_Type;
      Socket  : Socket_Type;
      Server  : Socket_Type;
      Channel : Stream_Access;

   begin
      accept Start;
      --  Create socket and listen input from client

      Address.Addr := Addresses (Get_Host_By_Name (Host_Name), 1);
      Address.Port := Common.Port;

      Create_Socket (Server);

      Bind_Socket (Server, Address);

      Listen_Socket (Server);

      accept Done;

      Accept_Socket (Server, Socket, Address);

      --  A client has been accepted, get the stream connected to the socket

      Channel := Stream (Socket);

      for K in 1 .. 2 loop
         declare
            O : Base'Class := Base'Class'Input (Channel);
            --  Read class wide object from socket
         begin
            O.Print; -- call the dispatching display method
         end;
      end loop;

   end Worker;

end Server;
