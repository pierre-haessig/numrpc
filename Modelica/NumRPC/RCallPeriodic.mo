within NumRPC;

block RCallPeriodic "Periodic remote function calls over NumRPC"
  extends Interfaces.RCallBase;
  
  parameter Modelica.SIunits.Time interval(min=0) "calling interval";
  parameter Modelica.SIunits.Time start(min=0)=0 "calling start offset";

equation
  when sample(start, interval) then
    (rcode, y) = Interfaces.rcall(rpc.client, fcode, u, nout);
  end when;
  
annotation(
    Icon(graphics = {Text(origin = {0, -120}, extent = {{-100, 20}, {100, -20}}, textString = "interval=%interval")}));end RCallPeriodic;