f = open("day_15.txt", "r")
lines = f.read().splitlines()


def numbers(line):
    return [int(char) for char in line]


numbers_mapped = map(numbers, lines)


def minPathSum(grid):
    rows = len(grid)
    cols = len(grid[0])

    # first row
    for i in range(1, cols):
        grid[0][i] += grid[0][i - 1]

    # first col
    for i in range(1, rows):
        grid[i][0] += grid[i - 1][0]
    # inner cells
    for i in range(1, rows):
        for j in range(1, cols):
            grid[i][j] += min(grid[i - 1][j], grid[i][j - 1])

    return grid[-1][-1]


grid = list(numbers_mapped)

# minPathSum(grid)
print(minPathSum(grid) - grid[0][0])
