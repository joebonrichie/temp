
with GNAT.Sockets; use GNAT;

with Client;
with Server;

procedure OO_Sockets is
begin
   Sockets.Initialize;   --  Initialize socket runtime
   Server.Worker.Start;  --  Start server
   Server.Worker.Done;   --  wait until it is ready to accept connections
   Client.Worker.Start;  --  let the client start now
end OO_Sockets;
