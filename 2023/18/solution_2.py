from sys import argv
from helpers import MAPPING, calculate_grid_size, record_turns, shoelace

ANSWERS = [
    52_240_110_406_730, # 1. Too low
]

filepath = argv[1]
file = open(filepath, 'r')
instructions = []
max_x = 0
max_y = 0
for line in file:
    line = line.replace('\n', '')
    lines = line.split(' ')
    ins = lines[2].replace('(', '').replace(')', '')
    digits = int(f'0x{ins[1:-1]}', 0)
    direction = MAPPING[ins[-1]]
    thisdict = {
        "direction": direction,
        "distance": digits
    }
    if direction == "L":
        max_y = max(max_y, digits)
    elif direction == "U":
        max_x = max(max_x, digits)
    instructions.append(thisdict)

grid_size, start_pos = calculate_grid_size(instructions)
# instructions = [
#     {"direction": "R", "distance": 3},
#     {"direction": "D", "distance": 2},
#     {"direction": "L", "distance": 3},
#     {"direction": "U", "distance": 2},
# ]

for ins in instructions:
    print(ins)

turns = record_turns(instructions)
area = shoelace(turns)
print(f'\nArea: {area}')
