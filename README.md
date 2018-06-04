# NumRPC

NumRPC is a lightweight Remote procedure call (RPC) mechanism for exchanging
numbers between different processes.

A typical use case is the numerical simulation of physical systems which
include some advanced control logic. The languages of choice for the simulation
of physical systems are different from the ones well suited for advanced control
(ex. Modelica for physical simulation vs. Python, Julia or Matlab for control).
The RPC mechanism provides a bridge between the two languages to run
a closed loop simulation of the physical system with its control.

In this context, the RPC mechanism is used in the following way:

* the RPC client (Modelica) is the numerical simulation of a physical system which
  needs some control (e.g. heating system of a building).
* the RPC server (Python, Julia or Matlab) provides the control logic for the physical system

Consequently, the Modelica simulation periodically sends a request to the server
which carries the inputs for the control algorithm.
The server runs the control algorithm and sends back the outputs.

## Protocol description

NumRPC protocol is based on a request-response mechanism.
The client sends to the server a request for a function to be executed on the server.
The request message carries the function id plus a list of arguments for that function.
The server answers back the list of outputs of that function.

In NumRPC, all arguments and outputs are *floats*
(double precison floating-point numbers, i.e. `double` in C, `Real` in Modelica)

