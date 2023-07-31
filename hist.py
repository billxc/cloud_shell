import datetime
import os
import sys

# if os_win
if os.name == "nt":
    relative_history_path = r"~\AppData\Roaming\Microsoft\Windows\PowerShell\PSReadLine\ConsoleHost_history.txt"
    absolute_history_path = os.path.expanduser(relative_history_path)

# if os_linux
elif os.name == "posix":
    relative_history_path = r"~/.bash_history"
    absolute_history_path = os.path.expanduser(relative_history_path)

# if os_mac
elif os.name == "mac":
    relative_history_path = r"~/.bash_history"
    absolute_history_path = os.path.expanduser(relative_history_path)


def read_history():
    history_lines = []
    with open(absolute_history_path, "r") as f:
        history_lines = f.readlines()
    # trim \n
    history_lines = [line.strip() for line in history_lines]

    # get only first 10 lines
    # history_lines = history_lines[:10]

    return history_lines


sys.stdout.reconfigure(encoding="utf-8")


def save_tmp_history(history_lines):
    # create a tmp file at the tmp dir
    time_suffix = datetime.datetime.now().strftime("%Y%m%d%H%M%S")
  
    tmp_history_path = os.path.join(os.environ["TMP"], "history" + time_suffix + ".txt")
    print(tmp_history_path)
    # append "\n" to each line
    history_lines = [line + "\n" for line in history_lines]
    with open(tmp_history_path, "w") as f:
        f.writelines(history_lines)


def main():
    history_lines = read_history()
    for line in history_lines:
        print(line)
    # save_tmp_history(history_lines)



if __name__ == "__main__":
    main()
