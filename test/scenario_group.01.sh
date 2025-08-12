new_scenario_group "file fits word size, data is one word" "$wf$wf$wf$wf$wf" "$wd"

new_scenario "one word at the begin"
scenario_execute "0" # target offset
scenario_test_target "$wd$wf$wf$wf$wf"

new_scenario "one word at the end" 
scenario_execute "$(( 4 * word_size ))"
scenario_test_target "$wf$wf$wf$wf$wd"

new_scenario "one word fit of the third word"
scenario_execute "$(( 2 * word_size ))"
scenario_test_target "$wf$wf$wd$wf$wf"

new_scenario "one word fit of the second word"
scenario_execute "$(( 1 * word_size ))"
scenario_test_target "$wf$wd$wf$wf$wf"

new_scenario "offset 1"
scenario_execute "1"
scenario_test_target "$wff$wd$wffa$wf$wf$wf"

new_scenario "offset before last "
scenario_execute "$(( 4 * word_size - 1))"
scenario_test_target "$wf$wf$wf$wflb$wd$wfl"

new_scenario "offset word size + 1" "$wf$wf$wf$wf$wf" "$wd"
scenario_execute "$(($word_size + 1))"
scenario_test_target "$wf$wff$wd$wffa$wf$wf"
