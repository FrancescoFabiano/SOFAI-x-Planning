import random
import sys


if __name__ == '__main__':

    filename = sys.argv[1]

    lines = open(filename).readlines()
    random.shuffle(lines)
    open(filename, 'w').writelines(lines)