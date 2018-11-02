#!/usr/bin/python3
# -*- coding: utf-8 -*-
""" Server part of NumRPC

Pierre Haessig — October 2018
"""

import zmq
from . import messaging as msg


class FuncRegister:
    """Register for a function.
    
    Stores the signature (nargs, nout),
    and optional state_init and state_del functions.
    """
    def __init__(self, fun, nargs, nout, state_init=None, state_del=None):
        self.fun = fun
        self.nargs = int(nargs)
        self.nout = int(nout)
        self.state_init = state_init
        self.state_del = state_del

class Server:
    """NumRPC server"""
    def __init__(self, endpoint='tcp://*:5555'):
        """sever listening at `endpoint`"""
        self._endpoint = endpoint
        self.funcs = {}
        self.states = {}
    
    def register(self, fid, fun, nargs, nout, state_init=None, state_del=None):
        """register function `fun` with id `fid`s"""
        assert fid == int(fid), 'fid should be an int'
        assert fid > 0, 'fid should be strictly positive'
        if fid in self.funcs:
            raise ValueError('fid {:d} already used'.format(fid))
        self.funcs[fid] = FuncRegister(fun, nargs, nout, state_init, state_del)
    
    def start(self):
        """start listening for NumRPC requests from clients
        
        """
        self._context = zmq.Context()
        
        socket = self._context.socket(zmq.REP)
        socket.bind(self._endpoint)
        self._socket = socket
        print('RPC server is listening on {}'.format(self._endpoint))
        print('Stop the server with Ctrl+C')
        
        while True:
            #  Wait for next request from client
            messages = socket.recv_multipart()
            print("Received request: %s" % msg.hexfmt(*messages))

            # 1) Decode function code
            cmd, st, nargs_h = msg.unpack_header(messages[0])

            reply = None
            try:
                freg = self.funcs[cmd]
                nargs = freg.nargs
                print('  requested function: {} -> {}'.format(cmd, freg.fun))
            except KeyError:
                print('  requested function code {} not in funcs table'.format(cmd))
                reply = msg.pack(-1)

            # 2) Decode function arguments
            if reply is None:
                if nargs != nargs_h:
                    print('  wrong number of args: %d received, %d expected' % (nargs_h, nargs))
                    reply = msg.pack(-2)

            if reply is None:
                try:
                    if nargs>0:
                        args = msg.unpack_payload(messages[1], nargs)
                    else:
                        args = []
                    print('  decoded args: {}'.format(args))
                except struct.error as e:
                    print('  arg decoding error: %s' % e)
                    reply = msg.pack(-3)

            # 3) Call function
            if reply is None:
                print('  calling function...', end=' ')
                try:
                    out = freg.fun(*args)
                    if out is None:
                        out = []
                    if freg.nout == 1:
                        out = [out]
                    print('OK.')
                    print('  call output: {}'.format(out))
                except Exception as e:
                    print('FAILED!')
                    print('  function error: %s' % repr(e))
                    reply = msg.pack(-4)

            # 4) Pack the response
            if reply is None:
                reply = msg.pack(0, 0, out)

            #  Send reply back to client
            print("  Sending reply:  %s" % msg.hexfmt(*reply))
            socket.send_multipart(reply)

            print('')
