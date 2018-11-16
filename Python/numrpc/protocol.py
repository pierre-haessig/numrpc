#!/usr/bin/python3
# -*- coding: utf-8 -*-
""" NumRPC Protocol constants

Pierre Haessig — November 2018
"""

from enum import IntEnum

# Error codes
ROK = 0

class RE(IntEnum):
    """Return error codes"""
    FNF = -1
    WNA = -2
    DEC = -3
    STI = -4
    SNF = -5
    FCF = -6
    SES = -7

# Reserved ids
ST0 = 0 # no state
