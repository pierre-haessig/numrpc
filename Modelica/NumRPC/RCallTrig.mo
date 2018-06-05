within NumRPC;

block RCallTrig "Externally triggered remote function calls over NumRPC"
  extends Interfaces.RCallBase;
  Modelica.Blocks.Interfaces.BooleanInput trig "trigger for remote call" annotation(
    Placement(visible = true, transformation(extent = {{-140, -20}, {-100, 20}}, rotation = 0), iconTransformation(origin = {0, -120},extent = {{-20, -20}, {20, 20}}, rotation = 90)));

equation
  when trig then
    (rcode, y) = rcall(rpc.client, fcode, u, nout);
  end when;

end RCallTrig;