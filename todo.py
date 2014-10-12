#!/usr/bin/env python3
"""
Usage: todo [--priority | --date] [--reverse]

Options:
  -p --priority  Sort by priority
  -d --date      Sort by date
  -r --reverse   Reverse sort order
  -h --help      Show this screen.
  -v --version   Show version.
"""

from sys import exit
from collections import OrderedDict
from docopt import docopt
import pytoml


def sort_toml(toml_dict, sort_key, rev=False):
    return sorted(
            list(toml_dict.items()),
            key=lambda d: (sort_key not in d[1], d[1].get(sort_key, None)),
            reverse=rev)

def main():
    arguments = docopt(__doc__, version='todo 0.0.1.alpha')
    print(arguments)
    if arguments['--date']:
        sort_key = 'date'
    elif arguments['--priority']:
        sort_key = 'priority'
    else:
        sort_key = 'priority'
    rev = arguments['--reverse']

    with open("/home/kyrias/documents/notes/TODO.toml", "rt") as in_file:
        tasks = in_file.read()

    unsorted = OrderedDict(sorted(pytoml.loads(tasks).items()))
    sorted_toml = OrderedDict(sort_toml(unsorted, sort_key, rev))

    print(sorted_toml)

    for t_id in sorted_toml:
        task = sorted_toml[t_id]
        output = "{}. ".format(t_id)
        if 'priority' in task:
            output += "({}) ".format(task['priority'])
        if 'date' in task:
            output += "{}".format(task['date'])
        if 'description' in task:
            output += "\n    {}".format(task['description'])
        if 'url' in task:
            output += "\n    URL: {}".format(task['url'])
        if 'context' in task:
            output += "\n    Contexts: {}".format(task['context'])

        print(output)

if __name__ == '__main__':
    main()