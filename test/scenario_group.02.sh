new_scenario_group "file do not fits word size, data is one word" "$wf$wf$wf$wf$wf$wff" "$wd"

new_scenario "one word at the begin"
scenario_execute "0"
scenario_test_target "$wd$wf$wf$wf$wf$wff"

new_scenario "one word at the end"
scenario_execute "$(( 4 * word_size + 1))"
scenario_test_target "$wf$wf$wf$wf$wff$wd"

new_scenario "one word fit of the third word"
scenario_execute "$(( 2 * word_size ))"
scenario_test_target "$wf$wf$wd$wf$wf$wff"

new_scenario "one word fit of the second word"
scenario_execute "$(( 1 * word_size ))"
scenario_test_target "$wf$wd$wf$wf$wf$wff"

new_scenario "data in first position"
scenario_execute "1"
scenario_test_target "$wff$wd$wffa$wf$wf$wf$wff"

new_scenario "last data byte on before last"
scenario_execute "$(( 4 * word_size - 1 + 1 ))"
scenario_test_target "$wf$wf$wf$wf$wd$wff"
