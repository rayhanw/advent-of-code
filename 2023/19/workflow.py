import re

PATTERN = '(?P<name>\w+){(?P<rules>.+)}'
workflow_regex = re.compile(PATTERN)

class Rule:
    def __init__(self, data: str):
        self.label = None
        self.operator = None
        self.value = None
        self.next_workflow = None
        self.build(data)

    def build(self, data: str):
        if data.__contains__('<') or data.__contains__('>'):
            pattern = re.compile('(?P<label>\w)(?P<operator>(<|>))(?P<value>\d+):(?P<next_workflow>\w+)')
            matches = pattern.match(data)
            dict = matches.groupdict()
            self.label = dict['label']
            self.operator = dict['operator']
            self.value = int(dict['value'])
            self.next_workflow = dict['next_workflow']
        else:
            self.next_workflow = data

    def run(self, other: any):
        pass

class Workflow:
    def __init__(self, information: dict):
        self.name = information['name']
        self.rules = self.build_rules(information['rules'])

    def build_rules(self, rules: str):
        ary = rules.split(',')

        return list(map(lambda x: Rule(x), ary))

def parse_workflow(workflow: str):
    return workflow_regex.match(workflow).groupdict()

tc = 'px{a<2006:qkq,m>2090:A,rfg}'
data = parse_workflow(tc)
w = Workflow(data)
for rule in w.rules:
    print(rule.label)
