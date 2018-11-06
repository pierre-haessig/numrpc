within NumRPC.Interfaces;

partial block RCallTrigBase "partial block for remote function call triggered during the simulation"
  extends RCallBase;
  
  parameter Real y0[nout]=zeros(nout) "initial output before first call";
  
protected
  input Boolean call "trigger for remote call";
  
initial equation
  y = y0;

equation
  when call then
    y = numrpcConn.call(numrpcConn.client, cmd, u, nout);
  end when;
end RCallTrigBase;