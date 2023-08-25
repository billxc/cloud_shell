# convert a path to the OS's path format
# e.g.: on *nix: C:\Users\me\foo -> /c/Users/me/foo
#       on Windows: /c/Users/me/foo -> C:\Users\me\foo
#       on Windows: Users/me/foo -> Users\me\foo

import os
import re
import sys
import pyperclip

def ospath(path):
    if os.name == 'nt':
        # convert to windows path
        path = re.sub(r'/', r'\\', path)
    else:
        # convert to *nix path
        if re.match(r'^/[a-zA-Z]', path):
            # absolute path
            path = re.sub(r'^/([a-zA-Z])', r'\1:', path)
            path = path.replace('\\', '/')
        else:
            # relative path
            path = path.replace('\\', '/')
    return path

if __name__ == '__main__':
    
    # try read path from args, or from clipboard
    if len(sys.argv) > 1:
        path = sys.argv[1]
    else:
        path = pyperclip.paste()

    # convert path
    path = ospath(path)
    # write path to clipboard
    pyperclip.copy(path)
    # print success message, and the path
    print('Path converted to OS format:\n' + path)