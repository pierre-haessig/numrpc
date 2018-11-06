#!/usr/bin/python3
# -*- coding: utf-8 -*-
""" NumRPC server for the Heating PI Control Demo

Implements the PI Control part of the demo.

This is a proof of concept version which emulates state management
without the corresponding state support in NumRPC.

Pierre Haessig — November 2018
"""

import numrpc

# Global collection of states, that should be held by the NumRPC Server
states = {}


def pi_state_init():
    '''generetates a state dict for pi_control'''
    global states
    new_stid = max(states.keys(), default=0) + 1
    state = dict(Ts=0, k=0, Ti=1, errint=0)
    states[new_stid] = state
    return new_stid


def pi_set_params(stid, Ts, k, Ti):
    '''set the parameters of the PI control'''
    state = states[stid]
    if(Ts<=0): raise ValueError('Ts should be >0')
    if(Ti==0): raise ValueError('Ti should be nonzero')
    
    state['Ts'] = Ts
    state['k'] = k
    state['Ti'] = Ti
    # Return a dummy output. Indeed, as of now,
    # if the function has no outputs, it does not get called
    # in the corresponding RCallInit Modelica block
    return 1


def pi_set_errint(stid, errint):
    '''set the value of the integral of the control error'''
    state = states[stid]
    state['errint'] = errint
    return 1 # dummy output


def pi_control(stid, y_sp, y_m):
    '''PI transfer function'''
    # 1. Load state and parameters
    state = states[stid]
    Ts = state['Ts']
    k = state['k']
    Ti = state['Ti']
    errint = state['errint']
    
    # 2. Compute (discrete PI)
    eps = y_sp - y_m
    u = k*(eps + errint)
    errint += Ts/Ti*eps
    
    # 3. Save state and return
    state['errint'] = errint
    return u


# Create the Server and start serving
s = numrpc.Server('tcp://*:5555')

s.register(1, pi_state_init, 0, 1)
s.register(2, pi_set_params, 1+3, 1) # dummy output
s.register(3, pi_set_errint, 1+1, 1) # dummy output
s.register(4, pi_control, 1+2, 1)

s.start()
