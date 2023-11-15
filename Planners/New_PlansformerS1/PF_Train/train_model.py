#!/usr/bin/env python

# Example of execution: python3 train_model.py datasets/trainingDataset.csv 1000 0
# Where:
# - datasets/training_file_name.csv is the name of the file that contains the training data
# - 1000 is the size of the training
# - 1/0 to abiliate (or not) continual training


import sys

import continual_train as continual_training

#-----------------------------------------------
# MAIN
#-----------------------------------------------
if __name__ == '__main__':

    training_file = sys.argv[1]
    training_size = int(sys.argv[2])

    continual_training.existing_plansformer_continual(training_file,training_size)
    