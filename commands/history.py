import os
from pprint import pprint

env_vars = os.environ
commands = []

with open(f"{env_vars['HOME']}/.zsh_history") as file:
  for line in file:
    splits = line.split(";")
    if len(splits) == 2:
      command = splits[1].replace("\n", "")
      if command not in commands and "git" not in command:
        commands.append(command)

pprint(commands)
