import re

PATTERN = '(?P<name>\w+){(?P<rules>.+)}'
workflow_regex = re.compile(PATTERN)

class Workflow:
    def __init__(self, information: dict):
        print(f'{information}')
        self.name = information['name']
        self.rules = self.build_rules(information['rules'])

    def build_rules(self, rules: str):
        ary = rules.split(',')
        # map(lambda x: , ary)

def parse_workflow(workflow: str):
    return workflow_regex.match(workflow).groupdict()
