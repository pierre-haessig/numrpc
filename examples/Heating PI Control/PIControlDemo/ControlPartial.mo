within PIControlDemo;

partial block ControlPartial "Abstract structure of the PI controller"
  parameter Real k(unit="1")=5 "Proportional Gain";
  parameter Modelica.SIunits.Time T(min=Modelica.Constants.small)=0.7
    "Integrator Time Constant (T>0 required)";
  Modelica.Blocks.Interfaces.RealInput ym "temperature measurement" annotation(
    Placement(visible = true, transformation(origin = {-120, -40}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, -40}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput ysp "temperature set point" annotation(
    Placement(visible = true, transformation(origin = {-120, 20}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 40}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput u "heating power" annotation(
    Placement(visible = true, transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  annotation(
    Diagram,
    Icon(graphics = {Rectangle(fillColor = {255, 253, 196}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}}), Text(extent = {{-80, 80}, {80, -80}}, textString = "Control"), Text(origin = {0, -70}, lineColor = {85, 87, 83}, extent = {{-90, 20}, {90, -20}}, textString = "k=%k, T=%T")}, coordinateSystem(initialScale = 0.1)));
end ControlPartial;