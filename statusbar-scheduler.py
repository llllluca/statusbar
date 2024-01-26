#!/bin/python3

import sys
import time 
import os
import errno
import getopt

home = os.getenv("HOME")
if home == None:
    raise Exception("HOME environment variable is unset.")

FIFO = os.path.join(home, ".statusbar-fifo")



def main():

    nm_event = None
    seconds = None

    try: 
        optlist, args = getopt.getopt(sys.argv[1:], "", [ "secs=", "nm=" ])
        for opt, val in optlist:
            if opt == "--secs":
                seconds=float(val)
            elif opt == "--nm":
                nm_event=val
    except Exception as e:
        print(f"Error: {e}", file=sys.stderr)
        sys.exit(1)

    if len(args) == 0:
        sys.exit(0)

    requests = args[0]

    try:
        os.mkfifo(FIFO)
    except OSError as oe:
        if oe.errno != errno.EEXIST:
            raise

    if seconds == None and nm_event == None:
        with open(FIFO, "w") as fifo:
            fifo.write(f"{requests},")
        sys.exit()

    if seconds != None:
        while True:
            with open(FIFO, "w") as fifo:
                fifo.write(f"{requests},")
            time.sleep(seconds)

    
if __name__ == "__main__":
    main()

