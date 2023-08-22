#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import sys
import os
import openai
import platform
from distro import name as distro_name
from openai_config import config

for key, value in config.items():
    setattr(openai, key, value)

operating_systems = {
    "Linux": "Linux/" + distro_name(pretty=True),
    "Windows": "Windows " + platform.release(),
    "Darwin": "Darwin/MacOS " + platform.mac_ver()[0],
}
current_platform = platform.system()
os_name = operating_systems.get(current_platform, current_platform)

SHELL_PROMPT = """###
Provide only {shell} commands for {os} without any description.
If there is a lack of details, provide most logical solution.
Ensure the output is a valid shell command.
If multiple steps required try to combine them together.
YOU NEED TO PROVIDE A VALID SHELL COMMAND ONLY, NO DESCRIPTIONS.
If you cannot provide a valid shell command, add [X] to the end of your message.
###
Command:""".format(shell="zsh", os=os_name)
# Prompt: {prompt}


def get_response(user_input):
    # get the response from the API
    response = openai.ChatCompletion.create(
        engine="gpt-35-turbo",
        messages=[{"role": "system", "content": SHELL_PROMPT}, {
            "role": "user", "content": user_input}
        ],
        temperature=0.7,
        max_tokens=800,
        top_p=0.95,
        frequency_penalty=0,
        presence_penalty=0,
        stop=None)
    # return the response
    if "choices" not in response:
        return ""
    choice = response["choices"][0]  # type: ignore
    if "message" not in choice:
        return ""
    message = choice["message"]
    if "content" in message and "role" in message and message["role"] == "assistant":
        return message["content"]
    return ""


if __name__ == "__main__":
    # turn the args into a single string
    args = " ".join(sys.argv[1:])
    # get the response from the API
    response = get_response(args)
    # print the response
    print(response)
    command_valid = "[X]" not in response
    if not command_valid:
        exit()
    # ask the user if they want to execute the command, default is yes
    execute = input("Execute? [Y/n] ").lower()
    # if the user wants to execute the command
    if execute == "" or execute == "y" or execute == "yes":
        # execute the command
        os.system(response)