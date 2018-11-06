within NumRPC.Interfaces;

partial block RCallBase "partial block for remote function calls over ZMQ REQ socket"
  extends Modelica.Blocks.Interfaces.MIMO;
  
  parameter Integer cmd "code of the function to call on the server";
  
protected
  outer NumRPC.Connection numrpcConn;

annotation(
    Icon(graphics = {Text(origin = {0, 80}, extent = {{-100, 20}, {100, -20}}, textString = "cmd=%cmd"), Text(origin = {-120, -40}, lineColor = {0, 5, 128}, extent = {{-20, 20}, {20, -20}}, textString = "%nin"), Text(origin = {120, -40}, lineColor = {0, 5, 128}, extent = {{-20, 20}, {20, -20}}, textString = "%nout"), Ellipse( extent = {{-60, 40}, {60, -40}}, endAngle = 360), Ellipse(origin = {-60, 0}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-20, 20}, {20, -20}}, endAngle = 360), Ellipse(origin = {60, 0}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-20, 20}, {20, -20}}, endAngle = 360), Polygon(origin = {53, 19}, rotation = 15, fillPattern = FillPattern.Solid, points = {{0, 0}, {0, 10}, {-8.66, 5}, {0, 0}}), Polygon(origin = {-53, -19}, rotation = 195, fillPattern = FillPattern.Solid, points = {{0, 0}, {0, 10}, {-8.66, 5}, {0, 0}})}, coordinateSystem(initialScale = 0.1)));
end RCallBase;