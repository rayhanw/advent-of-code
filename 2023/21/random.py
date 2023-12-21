ls = [
    ['.', '.', 'O'],
    ['O', '.', '.'],
    ['.', 'O', 'O'],
]

sum = 0
for x in ls:
    sum += x.count('O')

print(f'Sum {sum}')
