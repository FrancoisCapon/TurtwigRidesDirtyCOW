compute_md5() {
    if [ -f "$1" ]
    then
        md5ouput=$(md5sum $1)
    else
        md5ouput=$(echo -n $1 |md5sum)
    fi
    echo ${md5ouput%% *}
}

new_scenario_group() {
    # same target content same data content
    ((scenario_group_id++))
    scenario_id=0
    scenario_group_label=$1
    scenario_group_target_content=$2
    scenario_group_data_content=$3
    echo -e "\nScenario Group: $scenario_group_id : $scenario_group_label"
}

new_scenario() {
    chmod -f u+w $target_file
    #rm -f $target_file
    echo -n "$scenario_group_target_content" > $target_file
    echo -n "$scenario_group_data_content" > $data_file
    chmod -f u-w $target_file
    scenario_label="$1"
    ((scenario_id++))
    test_id=0
    echo -e "\nScenario: $scenario_group_id.$scenario_id : $scenario_label"
    test_error=0
}

scenario_execute() {
    data_offset=$1
    test_start=$(date +%s.%N)
    $trdc $target_file $data_offset < $data_file > /dev/null 2>&1
    scenario_error=$?
    test_end=$(date +%s.%N)
    test_duration=$(awk "BEGIN { print $test_end - $test_start }" )
    printf "Duration: %.3f seconds\n" "$test_duration"
    if ((scenario_error != 0))
    then
        ((scenarios_errors_count++))
    fi
}

scenario_test() {
    ((test_id++))
    echo -n "Test: $scenario_group_id.$scenario_id.$test_id"
    test_expected=$1
    test_obtained=$2
    test_label=$3
    if [[ -n "$test_label" ]]
    then
        echo -n " : $test_label"
    fi
    echo
    if ((scenario_error != 0))
    then
        echo "Result  : ERROR"
    else
        echo "Expected: $test_expected"
        echo "Obtained: $test_obtained"
        echo -n "Result  : "
        if [ "$test_expected" = "$test_obtained" ]; then
            ((tests_successes_count++))
            echo "ok"
        else
            ((tests_failures_count++))
            echo "KO"
        fi
    fi
}

scenario_test_target()  {
    test_obtained="$(cat $target_file)"
    scenario_test $1 $test_obtained "target content"
}

scenario_test_md5()  {
    test_obtained=$(compute_md5 $target_file)
    test_expected=$(compute_md5 $1)
    scenario_test $test_expected $test_obtained "target content"
}


