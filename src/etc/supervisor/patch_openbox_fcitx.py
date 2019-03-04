import sys
import commands

from supervisor.childutils import listener

def write_stdout(s):
    sys.stdout.write(s)
    sys.stdout.flush()

def write_stderr(s):
    sys.stderr.write(s)
    sys.stderr.flush()

def main():
    while True:
        # transition from ACKNOWLEDGED to READY
        write_stdout('READY\n')

        # read header line and print it to stderr
        line = sys.stdin.readline()
        write_stderr(line)

        # read event payload and print it to stderr
        headers = dict([ x.split(':') for x in line.split() ])
        data = sys.stdin.read(int(headers['len']))
        write_stderr(data+'\n')
        body = dict([ x.split(':') for x in data.split() ])

        # headers:    ver:3.0 server:supervisor serial:20 pool:sevent poolserial:20 eventname:PROCESS_STATE_EXITED len:70
        # body:       processname:fcitx groupname:fcitx from_state:RUNNING expected:1 pid:34
        if headers['eventname'] == 'PROCESS_STATE_EXITED':
            if body['processname'] == 'fcitx':
                write_stdout('\n\n fcitx STOPSTOP \n')
                status, output = commands.getstatusoutput('kill -9 $(pgrep openbox)')
                write_stdout('kill -9 $(pgrep openbox) \n')
                status, output = commands.getstatusoutput('fcitx')
                break

        # transition from READY to ACKNOWLEDGED
        write_stdout('RESULT 2\nOK')

if __name__ == '__main__':
    main()

