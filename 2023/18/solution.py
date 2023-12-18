from sys import argv
from helpers import calculate_grid_size, create_grid, print_grid, dig, fill_lagoon

filepath = argv[1]
file = open(filepath, 'r')
instructions = []
for line in file:
    line = line.replace('\n', '')
    lines = line.split(' ')
    color = lines[2].replace('(', '').replace(')', '')
    thisdict = {
        "direction": lines[0],
        "distance": int(lines[1]),
        "color": color
    }
    instructions.append(thisdict)

grid_size, starting_position = calculate_grid_size(instructions)
grid = create_grid(*grid_size)

dig(grid, instructions, *starting_position)
fill_lagoon(grid)
print_grid(grid)
sum = 0

drawing = open('drawing.txt', 'a')
for line in grid:
    drawing.write(' '.join(line) + '\n')
    for char in line:
        if char != '.':
            sum += 1

print(f'Answer: {sum}')
