from collections import deque

def find_starting_position(grid):
    for y, row in enumerate(grid):
        for x, cell in enumerate(row):
            if cell == 'S':
                return x, y

    return None

def count_reachable_plots(grid, steps):
    start_x, start_y = find_starting_position(grid)
    queue = deque([(start_x, start_y, 0)]) # (x, y, step_count)
    visited = set()
    directions = [(0, 1), (0, -1), (1, 0), (-1, 0)] # S, N, E, W

    while queue:
        x, y, step_count = queue.popleft()

        # Stop if the step limit is reached
        if step_count == steps:
            continue

        for dx, dy in directions:
            nx, ny = x + dx, y + dy
            next_step_count = step_count + 1
            element = grid[ny][nx]
            if element == '#':
                continue

            if 0 <= nx < len(grid[0]) and 0 <= ny < len(grid) and element == '.' and (nx, ny) not in visited:
                if next_step_count == steps:
                    print(f'({nx}, {ny})')
                    grid[ny][nx] = 'O'
                    visited.add((nx, ny, next_step_count))
                queue.append((nx, ny, step_count + 1))

    return len(visited)
