import os


def run_with_confirm(command, confirm_message):
    print(confirm_message)
    confirm = input("Y/n: ")
    if confirm == "" or confirm == "y" or confirm == "Y":
        os.system(command)
    else:
        print("Canceled")