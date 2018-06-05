within PIControlDemo;

partial block ControlPartial "Abstract structure of the discrete time PI controller"
  import Modelica.SIunits.Time;
  parameter Time Ts(min=100*Modelica.Constants.eps) = 0.1
    "Sample period of component";
  parameter Real k(unit="1")=5 "Proportional gain";
  parameter Time Ti(min=Modelica.Constants.small)=0.7
    "Integrator time constant (T>0 required)";
  Modelica.Blocks.Interfaces.RealInput ym "temperature measurement" annotation(
    Placement(visible = true, transformation(origin = {-120, -40}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, -40}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput ysp "temperature set point" annotation(
    Placement(visible = true, transformation(origin = {-120, 20}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 40}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput u "heating power" annotation(
    Placement(visible = true, transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  annotation(
    Diagram,
    Icon(graphics = {Rectangle(fillColor = {255, 253, 196}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}}), Text(extent = {{-80, 80}, {80, -80}}, textString = "Control"), Text(origin = {0, -70}, lineColor = {85, 87, 83}, extent = {{-90, 30}, {90, -20}}, textString = "Ts=%Ts
k=%k, Ti=%Ti")}, coordinateSystem(initialScale = 0.1)));
end ControlPartial;