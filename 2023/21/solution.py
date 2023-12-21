from sys import argv
from colorama import Fore, Style
from helpers import count_reachable_plots

filename = argv[1]
steps = argv[2]
lines = [[*line] for line in open(filename, 'r').read().splitlines()]
if not steps:
    raise ValueError('Please provide a number of steps')

reachable_plots = count_reachable_plots(lines, int(steps))
for line in lines:
    for char in line:
        if char == 'O':
            print(Fore.GREEN + char + Style.RESET_ALL, end=' ')
        else:
            print(char, end=' ')
    print()

print(f'Answer: {reachable_plots}')
