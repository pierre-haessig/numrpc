#!/usr/bin/python3
# -*- coding: utf-8 -*-
""" NumRPC server for the Heating PI Control Demo

Implements the PI Control part of the demo.

NB: this is a *target specification* to guide the implementation of numrpc.
It cannot run yet.

Pierre Haessig — June 2018
"""

import numrpc

def pi_state_init():
    '''generetates a state dict for pi_control'''
    state = dict(Ts=0, k=0, Ti=1, errint=0)
    return state

def pi_control(state, y_sp, y_m):
    # 1. Load state and parameters
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

def pi_set_params(state_init, Ts, k, Ti):
    if(Ts<=0): raise ValueError('Ts should be >0')
    if(Ti==0): raise ValueError('Ti should be nonzero')
    
    state['Ts'] = Ts
    state['k'] = k
    state['Ti'] = Ti

def pi_set_errint(state_init, errint):
    state['errint'] = errint


s = numrpc.Server('tcp://*:5555')

s.register(0, pi_control, 2, 1, state_init=pi_state_init)
s.register(1, pi_set_params, 3, 0, state_init=pi_state_init)
s.register(2, pi_set_int, 1, 0, state_init=pi_state_init)

s.run()
