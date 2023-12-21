from sys import argv
from time import perf_counter
from colorama import Fore, Style
from helpers import count_reachable_plots, count_reachable_plots_infinite

filename = argv[1]
steps = argv[2]
p_one_lines = [[*line] for line in open(filename, 'r').read().splitlines()]
p_two_lines = [[*line] for line in open(filename, 'r').read().splitlines()]
if not steps:
    raise ValueError('Please provide a number of steps')

def part_one(grid):
    print(f'Running for {steps} steps')
    reachable_plots = count_reachable_plots(grid, int(steps))
    for line in grid:
        for char in line:
            if char == 'O':
                print(Fore.GREEN + char + Style.RESET_ALL, end=' ')
            else:
                print(char, end=' ')
        print()

    return reachable_plots

def part_two(grid):
    print(f'Running for {steps} steps')
    reachable_plots = count_reachable_plots_infinite(grid, int(steps))
    for line in grid:
        for char in line:
            if char == 'O':
                print(Fore.GREEN + char + Style.RESET_ALL, end=' ')
            else:
                print(char, end=' ')
        print()

    return reachable_plots

# print(Fore.CYAN + f'Part one: {part_one(p_one_lines)}' + Style.RESET_ALL)
# print('---------------------')
start_time = perf_counter()
p2 = part_two(p_two_lines)
end_time = perf_counter()
duration = end_time - start_time
print(Fore.CYAN + f'Part two: {p2}' + Style.RESET_ALL)
print(f'Elapsed time: {duration:.2f}s')
