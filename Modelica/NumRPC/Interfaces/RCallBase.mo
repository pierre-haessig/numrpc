within NumRPC.Interfaces;

partial block RCallBase "partial block for remote function calls over ZMQ REQ socket"
  extends Modelica.Blocks.Interfaces.MIMO;
  
  parameter Integer fcode "code of the function to call on the server";
  parameter Real y0[nout]=zeros(nout) "initial output before first call";

protected
  outer NumRPC rpc;
  input Boolean call "trigger for remote call";
  output Integer rcode "return code (should be 0)";

initial equation
  y = y0;
  rcode = 0;

equation
  when call then
    (rcode, y) = rpc.rcall(rpc.client, fcode, u, nout);
    assert(rcode==0, "Remote call sent back an unsuccessful return code");
  end when;

annotation(
    Icon(graphics = {Text(origin = {0, 80}, extent = {{-100, 20}, {100, -20}}, textString = "fcode=%fcode"), Text(origin = {-120, -40}, lineColor = {0, 5, 128}, extent = {{-20, 20}, {20, -20}}, textString = "%nin"), Text(origin = {120, -40}, lineColor = {0, 5, 128}, extent = {{-20, 20}, {20, -20}}, textString = "%nout"), Ellipse( extent = {{-60, 40}, {60, -40}}, endAngle = 360), Ellipse(origin = {-60, 0}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-20, 20}, {20, -20}}, endAngle = 360), Ellipse(origin = {60, 0}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-20, 20}, {20, -20}}, endAngle = 360), Polygon(origin = {53, 19}, rotation = 15, fillPattern = FillPattern.Solid, points = {{0, 0}, {0, 10}, {-8.66, 5}, {0, 0}}), Polygon(origin = {-53, -19}, rotation = 195, fillPattern = FillPattern.Solid, points = {{0, 0}, {0, 10}, {-8.66, 5}, {0, 0}})}, coordinateSystem(initialScale = 0.1)));
end RCallBase;