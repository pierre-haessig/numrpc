#!/usr/bin/python3
# -*- coding: utf-8 -*-
""" Server part of NumRPC

Pierre Haessig — October 2018
"""

import zmq
from . import messaging as msg
from .protocol import ROK, RE, ST0


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
    
    def process_state_init(self, cmd):
        """Initialize a new state dict for function `cmd`
        """
        new_stid = max(self.states.keys(), default=0) + 1
        state = dict()
        self.states[new_stid] = state
        # TODO: manage error if cmd not found
        freg = self.funcs[cmd]
        # TODO: manage error if state_init is None or fails -> RE.STI
        freg.state_init(state)
        print('Initialized new state for cmd {:d} ({}): {}'.format(
            cmd, freg.fun, state))
            
        reply = msg.pack(0, new_stid)
        return reply
    
    def process_call(self, cmd, st, nargs_h, messages):
        '''Process normal requests'''
        # 1) Find the requested function
        try:
            freg = self.funcs[cmd]
            nargs = freg.nargs
            if st==ST0:
                print('  requested function: {} -> {}'.format(cmd, freg.fun))
            else:
                print('  requested function: {} -> {} with state id {:d}'.format(cmd, freg.fun, st))
        except KeyError:
            print('  requested function code {} not in funcs table'.format(cmd))
            reply = msg.pack(RE.FNF)
            return reply

        # 2a) Decode function arguments
        if nargs != nargs_h:
            print('  wrong number of args: %d received, %d expected' % (nargs_h, nargs))
            reply = msg.pack(RE.WNA)
            return reply

        try:
            if nargs>0:
                args = msg.unpack_payload(messages[1], nargs)
            else:
                args = []
            print('  decoded args: {}'.format(args))
        except struct.error as e:
            print('  arg decoding error: %s' % e)
            reply = msg.pack(RE.DEC)
            return reply
        
        # 2b) Find the state dict
        if st == ST0:
            state = None
        else:
            try:
                state = self.states[st]
            except KeyError:
                print('  state dict with id {:d} not found'.format(st))
                reply = msg.pack(RE.SNF)
                return reply
        
        # 3) Call the function
        print('  calling function...', end=' ')
        try:
            if state is None:
                out = freg.fun(*args)
            else:
                out = freg.fun(state, *args)
            print('OK.')
            print('  call output: {}'.format(out))
        except Exception as e:
            print('FAILED!')
            print('  function error: %s' % repr(e))
            reply = msg.pack(RE.FCF)
            return reply

        # 4) Pack the response
        # Make output a list if it's not already the case
        if out is None:
            out = []
        if freg.nout == 1:
            out = [out]
        reply = msg.pack(0, 0, out)
        return reply
    
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
            
            # Special requests
            STI = -3
            if cmd == STI:
                assert nargs_h == 0, "State init request should come with no arguments"
                reply =  self.process_state_init(cmd=st)
            
            # Normal requests
            if cmd >0:
                reply = self.process_call(cmd, st, nargs_h, messages)

            #  Send reply back to client
            print("  Sending reply:  %s" % msg.hexfmt(*reply))
            socket.send_multipart(reply)

            print('')
