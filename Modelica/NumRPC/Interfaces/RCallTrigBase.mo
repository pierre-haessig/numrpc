within NumRPC.Interfaces;

partial block RCallTrigBase "partial block for remote function call triggered during the simulation"
  extends RCallBase;
  
  parameter Real y0[nout] = zeros(nout) "initial output before first call";
  parameter StateUsage state_use = StateUsage.none;
  
  Modelica.Blocks.Interfaces.IntegerInput st_ext if state_use == StateUsage.ext
    "externally defined state id, if state_use == StateUsage.ext"
    annotation(
    Placement(visible = true, transformation(origin = {-120, -80}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, -80}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

protected
  type StateUsage = enumeration(none "no state needed", int "internally managed state id", ext "external state id signal");
  input Boolean call "trigger for remote call";
  Integer st "state id";
  Integer st_res "state id response";

initial equation
  y = y0;
  st_res = ST0;
  if state_use == StateUsage.int then
    st = ST0;
// TODO: call STI command
  elseif state_use == StateUsage.ext then
    st = st_ext;
  else
// state_use == StateUsage.none
    st = ST0;
  end if;

equation
  st = pre(st);
  when call then
    (y, st_res) = numrpcConn.scall(numrpcConn.client, cmd, st, u, nout);
  end when;
end RCallTrigBase;