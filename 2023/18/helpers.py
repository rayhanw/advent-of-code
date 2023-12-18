def create_grid(width, height):
    return [['.' for _ in range(width)] for _ in range(height)]

def print_grid(grid):
    for line in grid:
        for char in line:
            print(char, end=' ')
        print()

def calculate_grid_size(instructions):
    max_u, max_d, max_l, max_r = 0, 0, 0, 0
    x, y = 0, 0 # Origin point

    for ins in instructions:
        if ins["direction"] == "U":
            y -= ins["distance"]
            max_u = min(max_u, y)
        elif ins["direction"] == "D":
            y += ins["distance"]
            max_d = max(max_d, y)
        elif ins["direction"] == "L":
            x -= ins["distance"]
            max_l = min(max_l, x)
        elif ins["direction"] == "R":
            x += ins["distance"]
            max_r = max(max_r, x)

    width = max_r - max_l
    height = max_d - max_u
    start_x = -max_l
    start_y = -max_u
    buffer = 1
    return (width + buffer, height + buffer), (start_x, start_y)

def dig(grid: list, instructions: list, start_x: int, start_y: int):
    x, y = start_x, start_y

    for ins in instructions:
        # print(f'Digging {ins["direction"]} for {ins["distance"]}m')
        if ins["direction"] == "R":
            for _ in range(ins["distance"]):
                x += 1
                grid[y][x] = "#"
        if ins["direction"] == "D":
            for _ in range(ins["distance"]):
                y += 1
                grid[y][x] = "#"
        if ins["direction"] == "L":
            for _ in range(ins["distance"]):
                x -= 1
                grid[y][x] = "#"
        if ins["direction"] == "U":
            for _ in range(ins["distance"]):
                y -= 1
                grid[y][x] = "#"

    return grid

def flood_fill_iterative(grid, start_x, start_y, target, replacement):
    stack = [(start_x, start_y)]

    while stack:
        x, y = stack.pop()
        if x < 0 or x >= len(grid[0]) or y < 0 or y >= len(grid):
            continue
        if grid[y][x] != target:
            continue

        grid[y][x] = replacement
        stack.append((x + 1, y))
        stack.append((x - 1, y))
        stack.append((x, y + 1))
        stack.append((x, y - 1))

def fill_lagoon(grid):
    # Apply flood fill to the border cells of the grid
    for x in range(len(grid[0])):
        flood_fill_iterative(grid, x, 0, '.', 'o')  # Top row
        flood_fill_iterative(grid, x, len(grid) - 1, '.', 'o')  # Bottom row
    for y in range(len(grid)):
        flood_fill_iterative(grid, 0, y, '.', 'o')  # Left column
        flood_fill_iterative(grid, len(grid[0]) - 1, y, '.', 'o')  # Right column

    # Fill the interior spaces
    for y in range(len(grid)):
        for x in range(len(grid[0])):
            if grid[y][x] == '.':
                grid[y][x] = '#'

    # Optionally revert the 'o' markers back to '.'
    for y in range(len(grid)):
        for x in range(len(grid[0])):
            if grid[y][x] == 'o':
                grid[y][x] = '.'
