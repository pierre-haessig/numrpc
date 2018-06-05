within NumRPC;

block RCallTrig "Externally triggered remote function calls over NumRPC"
  extends Interfaces.RCallBase;
  Modelica.Blocks.Interfaces.BooleanInput trigger "trigger for remote call" annotation(
    Placement(visible = true, transformation(extent = {{-140, -20}, {-100, 20}}, rotation = 0), iconTransformation(origin = {0, -120},extent = {{-20, -20}, {20, 20}}, rotation = 90)));

equation
  call = trigger;

end RCallTrig;