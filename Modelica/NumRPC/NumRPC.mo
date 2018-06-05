within NumRPC;

block NumRPC "NumRPC block which holds the client connection"
  parameter String endpoint="tcp://localhost:5555" "connection endpoint of the ZMQ socket";
  output Interfaces.ZmqReqClient client = Interfaces.ZmqReqClient(endpoint);
  annotation(
      defaultComponentName = "rpc",
      defaultComponentPrefixes="inner",
  Icon(graphics = {Rectangle(fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-150, 100}, {150, -100}}), Text(origin = {0, 70}, extent = {{-100, 20}, {100, -20}}, textString = "NumRPC"), Text(origin = {0, -80}, lineColor = {0, 50, 127}, extent = {{-150, 20}, {150, -20}}, textString = "%endpoint"), Ellipse(origin = {-60, 0}, extent = {{-20, 20}, {20, -20}}, endAngle = 360), Ellipse(origin = {60, 0}, extent = {{-20, 20}, {20, -20}}, endAngle = 360), Line(points = {{-40, 0}, {40, 0}}, color = {0, 50, 127}, pattern = LinePattern.Dot, thickness = 0.5)}, coordinateSystem(extent = {{-150, -100}, {150, 100}})),
  __OpenModelica_commandLineOptions = "");
end NumRPC;