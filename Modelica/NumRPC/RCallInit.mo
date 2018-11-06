within NumRPC;

block RCallInit "Remote function calls over NumRPC in initial equation"
  extends Interfaces.RCallBase;
  
initial equation
  y = numrpcConn.call(numrpcConn.client, cmd, u, nout);
equation
  der(y) = zeros(nout);
annotation(
    Icon(graphics = {Text(origin = {0, -70}, extent = {{-100, 30}, {100, -30}}, textString = "init")}));end RCallInit;