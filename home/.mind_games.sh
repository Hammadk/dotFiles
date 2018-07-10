#!/bin/bash

declare -a tasks=("Technology" "Social" "Active" "Creative")
selectedTask=${tasks[$RANDOM % ${#tasks[@]} ]}

echo ${selectedTask}
