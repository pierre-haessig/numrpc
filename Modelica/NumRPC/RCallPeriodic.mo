within NumRPC;

block RCallPeriodic "Periodic remote function calls over NumRPC"
  extends Interfaces.RCallTrigBase;
  
  parameter Modelica.SIunits.Time period(min=100*Modelica.Constants.eps) "calling period";
  parameter Modelica.SIunits.Time start(min=0)=0 "first calling instant";

equation
  call = sample(start, period);

annotation(
    Icon(graphics = {Text(origin = {0, -120}, extent = {{-100, 20}, {100, -20}}, textString = "period=%period")}));end RCallPeriodic;