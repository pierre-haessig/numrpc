within NumRPC;

block ExtState "External state initialization"
  extends Modelica.Blocks.Icons.IntegerBlock;
  
  Modelica.Blocks.Interfaces.IntegerOutput st "state id" annotation (Placement(
        transformation(extent={{100,-10},{120,10}})));
  parameter Integer cmd "code of the function to call on the server";
  
protected
  outer NumRPC.Connection numrpcConn;

initial equation
  st = numrpcConn.state_init(numrpcConn.client, cmd);
equation
  st = pre(st);
  
  annotation(
    Icon(graphics = {Text(origin = {0, 80}, extent = {{-100, 20}, {100, -20}}, textString = "cmd=%cmd"), Text(extent = {{-80, 0}, {80, -80}}, textString = "state\ninit")}));
end ExtState;