from sys import argv

filepath = argv[1]
file = open(filepath, 'r')
lines = [x.strip() for x in file.readlines()]
ratings = []
workflows = []

for line in lines:
    if len(line) <= 0:
        continue

    if line[0] == '{':
        ratings.append(line)
    else:
        workflows.append(line)

print('Workflows:')
for workflow in workflows:
    print(workflow)

print()

print('Ratings:')
for rating in ratings:
    print(rating)
