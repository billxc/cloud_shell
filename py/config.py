import os
import yaml

DEBUG = False

def is_debug():
    global DEBUG
    return DEBUG

def set_debug():
    global DEBUG
    DEBUG = True

def get_config(filename: str):
    """Loop through the config file folder, and then load the config file by name."""

    config_dirs = []

    # Current file dir
    current_file = os.path.dirname(os.path.realpath(__file__))
    cloud_shell_root = os.path.dirname(current_file)
    config_dirs.append(cloud_shell_root)

    # Default OneDrive Dirs
    config_dirs.append(os.path.expanduser("~/OneDrive/cloud_shell"))

    # Other o365 OneDrive Dirs(all folders under ~/, and starts with "OneDrive - ")
    for dir in os.listdir(os.path.expanduser("~/")):
        if dir.startswith("OneDrive - "):
            config_dirs.append(os.path.expanduser(f"~/{dir}/cloud_shell"))

    # Loop through the config dirs
    for config_dir in config_dirs:
        config_file = os.path.join(config_dir, filename)

        if os.path.isfile(config_file):
            dlog(f"Checking config file: {config_file}")
            return yaml.safe_load(open(config_file))

def dlog(*messages):
    if DEBUG:
        print(*messages)