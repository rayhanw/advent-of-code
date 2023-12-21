from collections import deque

directions = [(0, 1), (0, -1), (1, 0), (-1, 0)] # S, N, E, W

def find_starting_position(grid):
    for y, row in enumerate(grid):
        for x, cell in enumerate(row):
            if cell == 'S':
                return x, y

    return None

def count_reachable_plots(grid, steps):
    start_x, start_y = find_starting_position(grid)
    queue = deque([(start_x, start_y, 0)])
    visited = set([(start_x, start_y, 0)])

    while queue:
        x, y, step_count = queue.popleft()

        # Stop if the step limit is reached
        if step_count == steps:
            continue

        for dx, dy in directions:
            grid[y][x] = '.'
            nx, ny = get_new_position(x, y, dx, dy, len(grid[0]), len(grid))
            next_step_count = step_count + 1

            if 0 <= nx < len(grid[0]) and 0 <= ny < len(grid) and grid[ny][nx] == '.' and (nx, ny, next_step_count) not in visited:
                if next_step_count <= steps:
                    grid[ny][nx] = 'O'
                    visited.add((nx, ny, next_step_count))
                    queue.append((nx, ny, next_step_count))

    # Filter visited set to include only positions reached exactly in 'steps'
    return sum(1 for x, y, s in visited if s == steps)

def count_reachable_plots_infinite(grid, steps):
    # Large number to simulate the center of an infinite grid
    center_offset = 1000000

    start_x, start_y = find_starting_position(grid)
    width, height = len(grid[0]), len(grid)
    queue = deque([(start_x, start_y, center_offset, center_offset, 0)])
    visited = set([(center_offset, center_offset, 0)])

    while queue:
        rel_x, rel_y, abs_x, abs_y, step_count = queue.popleft()

        if step_count == steps:
            visited.add((abs_x, abs_y, step_count + 1))
            continue

        for dx, dy in [(0, 1), (1, 0), (0, -1), (-1, 0)]:
            new_rel_x = (rel_x + dx) % width
            new_rel_y = (rel_y + dy) % height
            new_abs_x = abs_x + dx
            new_abs_y = abs_y + dy
            next_step_count = step_count + 1

            if grid[new_rel_y][new_rel_x] != '#' and (new_abs_x, new_abs_y, next_step_count) not in visited:
                visited.add((new_abs_x, new_abs_y, next_step_count))
                queue.append((new_rel_x, new_rel_y, new_abs_x, new_abs_y, next_step_count))

    return sum(1 for _, _, s in visited if s == steps)


def get_new_position(x, y, dx, dy, width, height):
    new_x = (x + dx) % width
    new_y = (y + dy) % height
    return new_x, new_y
