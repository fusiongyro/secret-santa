import pathlib
import sys
import argparse
import clingo
import random
from typing import TypedDict

from clingo import Model

User = TypedDict('User', {'key': str, 'name': str, 'email': str})
UserDict = dict[str, User]
Solution = frozenset[tuple[str, str]]


def unique(solution: Model) -> Solution:
    """
    Eliminate duplicates in the solution using sets and sorting. Return a more usable structure.

    :param solution: solution to eliminate duplicates from
    :return: a Solution
    """
    result = list()
    for match in solution.symbols(atoms=True):
        if match.name == "match":
            result.append((match.arguments[0].name, match.arguments[1].name))
    return frozenset(sorted(result))


def generate_solution() -> Solution:
    """
    Run clingo on the secret-santa input, generate some number of solutions and choose one at random.

    :return: a randomly-chosen solution
    """
    # Create a Clingo control object
    ctl = clingo.Control(["-n1000"])

    # Load the program from the file
    ctl.load("secret-santa.lp")
    ctl.load("my-family.lp")

    # If we have a previous solution, then we should use it; otherwise, ignore it
    if pathlib.Path("previous-solutions.lp").exists():
        ctl.load("previous-solutions.lp")

    # Ground the program
    ctl.ground([("base", [])])

    # Solve the program and get the set of solutions
    solutions = set(unique(model) for model in ctl.solve(yield_=True))

    # choose a random solution
    solution = random.choice(list(solutions))
    return solution


def main(args):
    parser = argparse.ArgumentParser(description='Secret Santa match maker')
    subparsers = parser.add_subparsers(dest='command', help='Available commands')

    # Verify subcommand
    subparsers.add_parser('verify', help='Verify user database')

    # Welcome subcommand
    subparsers.add_parser('welcome', help='Send welcome message')

    # Send-matches subcommand
    subparsers.add_parser('send-matches', help='Send matches to participants', )

    args = parser.parse_args(args[1:])

    if args.command == 'verify':
        print('in verify')
        pass  # Handle verify command
    elif args.command == 'welcome':
        print('in welcome')
        pass  # Handle welcome command
    elif args.command == 'send-matches':
        print(generate_solution())
        pass  # Handle send-matches command
    else:
        parser.print_help()


if __name__ == "__main__":
    main(sys.argv)