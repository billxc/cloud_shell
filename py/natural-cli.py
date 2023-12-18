#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import sys
import os
import openai
import platform
from distro import name as distro_name
from config import get_config

operating_systems = {
    "Linux": "Linux/" + distro_name(pretty=True),
    "Windows": "Windows " + platform.release(),
    "Darwin": "Darwin/MacOS " + platform.mac_ver()[0],
}
current_platform = platform.system()
os_name = operating_systems.get(current_platform, current_platform)

current_shell = os.environ.get("SHELL", "")

CONFIG_FILE = "openai_config.yml"

SHELL_PROMPT = """###
Provide only {shell} commands for {os} without any description.
If there is a lack of details, provide most logical solution.
Ensure the output is a valid shell command.
If multiple steps required try to combine them together.
YOU NEED TO PROVIDE A VALID SHELL COMMAND ONLY, NO DESCRIPTIONS.
If you cannot provide a valid shell command, add [X] to the end of your message.
###
Command:""".format(
    shell=current_shell, os=os_name
)
# Prompt: {prompt}


def get_response(user_input):
    global config
    # get the response from the API
    global client
    response = client.chat.completions.create(
        model=config["api_model"],
        messages=[
            {"role": "system", "content": SHELL_PROMPT},
            {"role": "user", "content": user_input},
        ],
        temperature=0.7,
        max_tokens=800,
        top_p=0.95,
        frequency_penalty=0,
        presence_penalty=0,
        stop=None,
    )
    return response.choices[0].message.content

def init_config_and_client():
    global config
    global client
    config = get_config(CONFIG_FILE)
    # print(config)
    if config is None:
        print("Error: No config found.")
        exit()

    for key, value in config.items():
        setattr(openai, key, value)

    # init openai client
    if "api_type" in config and config["api_type"] == "azure":
        client = openai.AzureOpenAI(
            api_key=config["api_key"],
            azure_endpoint=config["api_base"],
            api_version=config["api_version"],
        )
    else:
        client = openai.OpenAI(
            api_key=config["api_key"],
            api_base=config["api_base"],
        )

def main():
    if "-4" in sys.argv:
        sys.argv.remove("-4")
        global CONFIG_FILE
        CONFIG_FILE = "openai_config-gpt4.yml"
    init_config_and_client()
    # turn the args into a single string
    args = " ".join(sys.argv[1:])
    # get the response from the API
    response = get_response(args)
    command_valid = "[X]" not in response
    if not command_valid:
        print("Invalid command, please try again.")
        exit()
    # print the response
    print(response)


if __name__ == "__main__":
    main()
