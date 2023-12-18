from sys import argv
from helpers import MAPPING, sparse_dig, calculate_grid_size

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

for ins in instructions:
    print(ins)

cells_dug = sparse_dig(instructions, *start_pos)
grouped_keys = {}
for k in cells_dug.keys():
    x = k[0]
    y = k[1]
    if y in grouped_keys:
        grouped_keys[y]["min"] = min(x, grouped_keys[y]["min"])
        grouped_keys[y]["max"] = max(x, grouped_keys[y]["max"])
    else:
        grouped_keys[y] = { "min": x, "max": x }

sum = 0
for k in grouped_keys.keys():
    total = grouped_keys[k]["max"] - grouped_keys[k]["min"] + 1
    sum += total
    print(f'depth={k} min={grouped_keys[k]["min"]}, max={grouped_keys[k]["max"]} | total={total}')

print(f'Total: {sum}')
