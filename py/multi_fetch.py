import os
import sys

def run_cmd_with_fail_retry(cmd):
    print("start to run: " + cmd)
    result_code = os.system(cmd)
    if result_code != 0:
        print("Failed to run cmd: " + cmd)
        run_cmd_with_fail_retry(cmd)

def main():
    # first parameter is a file contains the commit hashes, from old to new
    input_file = sys.argv[1]
    print(input_file)
    # print current dir
    print(os.getcwd())
    # read the file
    with open(input_file, "r") as f:
        lines = f.readlines()
        # filter the lines start with # or empty
        lines = [line.strip() for line in lines if not line.startswith("#") and line.strip() != ""]
    print(lines)
    
    # fetch each commit
    for line in lines:
        cmd = "git fetch origin " + line
        run_cmd_with_fail_retry(cmd)


if __name__ == "__main__":
    main()
