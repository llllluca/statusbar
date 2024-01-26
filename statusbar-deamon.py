#!/bin/python3

import os
import errno
import subprocess

cache = {
    "datetime": "",
    "battery": "",
    "volume": "",
    "brightness": "",
    "wifi": "",
}

cmds = {
    "datetime": ["statusbar-datetime"],
    "battery": ["statusbar-battery"],
    "volume": ["statusbar-volume" ],
    "brightness": ["statusbar-brightness"],
    "wifi": ["statusbar-wifi"],
}

home = os.getenv("HOME")
if home == None:
    raise Exception("HOME environment variable is unset.")

FIFO = os.path.join(home, ".statusbar-fifo")

def statusbar_string():

    statusbar = (f" {cache['datetime']} |"
                 f" {cache['battery']} |"
                 f" {cache['volume']} |"
                 f" {cache['brightness']} ")

    if cache['wifi'] != "":
        statusbar += f"| {cache['wifi']} "

    return statusbar

def init():
    for section, _ in cmds.items():
        p = subprocess.run(
                cmds[section], 
                text=True, 
                capture_output=True)
        cache[section] = p.stdout.strip(" \t\n")
    subprocess.run(["xsetroot", "-name", statusbar_string()])


def main():

    init()

    try:
        os.mkfifo(FIFO)
    except OSError as oe:
        if oe.errno != errno.EEXIST:
            raise


    while True:
        with open(FIFO, "r") as fifo:
            data = fifo.read()
            requests = data.split(",")
            for r in requests:
                if (r not in cmds or 
                    r not in cache):
                    continue
                p = subprocess.run(
                        cmds[r], 
                        text=True, 
                        capture_output=True)
                cache[r] = p.stdout.strip(" \t\n")
            subprocess.run(["xsetroot", "-name", statusbar_string()])


if __name__ == "__main__":
    main()

                



