#   Minimal RPC server
#   Connects REP socket to tcp://*:5555
#   Expects a stucture with 1 int code + list of doubles
#   Replies with a list of doubles floats in return
#   PH May 2017

import time
import zmq
import struct

import ph_rpc as rpc

context = zmq.Context()
socket = context.socket(zmq.REP)

endpoint = "tcp://*:5555"
socket.bind(endpoint)

print("RPC server is listening on {}".format(endpoint))

def square(a):
    return a*a

def substract(a, b):
    return a - b

def fail_fun():
    raise Exception('failing func')

funcs = {
    1: (square, 1, 1),
    2: (substract, 2, 1),
    99: (fail_fun, 0, 0)
}

while True:
    #  Wait for next request from client
    messages = socket.recv_multipart()
    print("Received request: %s" % rpc.hexfmt(*messages))

    # 1) Decode function code
    fcode, nargs_h = rpc.unpack_header(messages[0])

    reply = None
    try:
        f, nargs, nout = funcs[fcode]
        print('  requested function: {} -> {}'.format(fcode, f))
    except KeyError:
        print('  requested function code {} not in funcs table'.format(fcode))
        reply = rpc.pack(-1)

    # 2) Decode function arguments
    if reply is None:
        if nargs != nargs_h:
            print('  wrong number of args: %d received, %d expected' % (nargs, nargs_h))
            reply = rpc.pack(-2)

    if reply is None:
        try:
            if nargs>0:
                args = rpc.unpack_payload(messages[1], nargs)
            else:
                args = []
            print('  decoded args: {}'.format(args))
        except struct.error as e:
            print('  arg decoding error: %s' % e)
            reply = rpc.pack(-3)

    # 3) Call function
    if reply is None:
        print('  calling function...', end=' ')
        try:
            out = f(*args)
            if out is None:
                out = []
            if nout == 1:
                out = [out]
            #  Pretend it takes some time
            #time.sleep(1)
            print('OK.')
            print('  call output: {}'.format(out))
        except Exception as e:
            print('FAILED!')
            print('  function error: %s' % repr(e))
            reply = rpc.pack(-4)

    # 4) Pack the response
    if reply is None:
        reply = rpc.pack(0, out)

    #  Send reply back to client
    print("  Sending reply:  %s" % rpc.hexfmt(*reply))
    socket.send_multipart(reply)

    print('')
