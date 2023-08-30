
import os, sys, time, pickle


from actions import *
from problems import *

def cleanup():
    os.system('rm -f pdkb-domain.pddl')
    os.system('rm -f pdkb-problem.pddl')
    os.system('rm -f pdkb-plan.txt')
    os.system('rm -f pdkb-plan.out')
    os.system('rm -f pdkb-plan.out.err')
    os.system('rm -f execution.details')


def solve(pdkbddl_file, old_planner=False):

    print()

    if not os.path.isdir('.problem-cache'):
        os.mkdir('.problem-cache')

    t_start = time.time()

    #@MOD: modified output print
    #print("Parsing problem...", end=' ')
    sys.stdout.flush()
    problem = parse_pdkbddl(pdkbddl_file)
    #@MOD: modified output print
    #print("done!")

    #@MOD: modified output print
    #print("Preprocessing problem...", end=' ')
    sys.stdout.flush()
    prob_hash = hash(pickle.dumps(problem))
    fname = ".problem-cache/%s" % str(prob_hash)
    if os.path.isfile(fname) and not os.path.isfile('.nocache'):
        problem = pickle.load(open(fname, 'r'))
        #@MOD: modified output print
       # print("done! (from cache)")
    else:
        problem.preprocess()
        with open(fname, 'wb') as f:
            pickle.dump(problem, f, 2)
       # print("done!")

     #@MOD: modified output print
   # print("Solving problem...", end=' ')
    sys.stdout.flush()
    problem.solve(old_planner)
    #@MOD: modified output print
    #print("done!")

    print("\nPDKB completed the search in: %f" % (time.time() - t_start))

    problem.output_solution()

    print()


if __name__ == '__main__':
    if len(sys.argv) < 2:
        print("\nUsage: python planner.py <pdkbddl file> [--keep-files] [--old-planner]\n")
        sys.exit(1)

    solve(sys.argv[1], old_planner=('--old-planner' in sys.argv))

    if len(sys.argv) < 3 or '--keep-files' != sys.argv[2]:
        cleanup()
