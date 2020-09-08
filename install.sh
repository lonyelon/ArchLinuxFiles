#!/bin/bash

[ "$EUID" -ne 0 ] && echo "Por favor, ejecuta esto con root con: sudo $0" || mv scripts/* /bin/
