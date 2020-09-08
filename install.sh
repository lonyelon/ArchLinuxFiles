#!/bin/bash

[ "$EUID" -ne 0 ] && echo "Please, run this as root: sudo $0" || mv scripts/* /bin/
