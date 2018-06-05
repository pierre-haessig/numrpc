within;
package NumRPC "NumRPC client library for Modelica"
  extends Modelica.Icons.Package;
  annotation(
    uses(Modelica(version = "3.2.2")),
    Icon(graphics = {
      Ellipse( extent = {{-60, 40}, {60, -40}}, endAngle = 360),
      Ellipse(origin = {-60, 0}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-20, 20}, {20, -20}}, endAngle = 360),
      Ellipse(origin = {60, 0}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-20, 20}, {20, -20}}, endAngle = 360),
      Polygon(origin = {53, 19}, rotation = 15, fillPattern = FillPattern.Solid, points = {{0, 0}, {0, 10}, {-8.66, 5}, {0, 0}}),
      Polygon(origin = {-53, -19}, rotation = 195, fillPattern = FillPattern.Solid, points = {{0, 0}, {0, 10}, {-8.66, 5}, {0, 0}})}, coordinateSystem(initialScale = 0.1)));
end NumRPC;