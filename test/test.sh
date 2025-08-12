#!/usr/bin/env bash

memory_page_size=4096

source 'test-functions.sh'

printf "\nTests: Turtwig rides DirtyCow"

trdc=$1
printf "\nKernel: %s" "$(uname -r)"
printf "\nProgram: %s" "$trdc"
printf "\nMd5: %s" "$(compute_md5 $trdc)"
architecture=$(file $trdc | grep -o '[63][42]-bit')
printf "\nArchitecture: %s" "$architecture"
architecture_bit=${architecture%%-*}
word_size=$((architecture_bit / 8))
printf "\nPokedata word size: %s" "$word_size"
echo

scenario_group_id=0
scenario_group_label="scenario_group label"
scenario_group_target_content=''
scenario_group_file_content=''

scenario_id=0
scenario_label="scenario label"
scenario_error=0
scenarios_errors_count=0

tests_successes_count=0
tests_failures_count=0
test_id=0
test_label="test label"
test_expected="expected"
test_obtained="obtained"
test_start=0
test_end=0

test_label="Hello test!"

case "$word_size" in
    8)
    word_file="<ooOOoo>"
    word_data="01234567"
    ;;
    4)
    word_file="<oo>"
    word_data="0123"
    ;;
    *)
    echo "Error: unknown word size $word_size"
    exit 1
    ;;
esac

target_file='file_target'
data_file='file_data'
data_offset=0

wf=$word_file
wff=${word_file:0:1} # first character
wffa=${word_file:1} # first character after
wfl=${word_file: -1} # last character
wflb=${word_file:0:$((word_size - 1))} # last character before
wflb2=${word_file:0:$((word_size - 2))} # last character before before

wd=$word_data
wdf=${word_data:0:1} # first character

source "scenario_group.01.sh"
source "scenario_group.02.sh"
source "scenario_group.03.sh"
source "scenario_group.04.sh"
source "scenario_group.05.sh"
source "scenario_group.06.sh"
source "scenario_group.07.sh"
source "scenario_group.08.sh"
source "scenario_group.09.sh"

#source "scenario_group.99.sh"

echo

echo -e "Scenarios errors: $scenarios_errors_count"
echo -e "Tests successes:  $tests_successes_count"
echo -e "Tests failures :  $tests_failures_count"

echo

# Scenarios errors: 0
# Tests successes:  33
# Tests failures :  0