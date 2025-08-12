new_scenario_group "file do not fits word size, data is three words" "$wf$wf$wf$wf$wf$wff" "$wd$wd$wd"

new_scenario "data at the begin"
scenario_execute "0"
scenario_test_target "$wd$wd$wd$wf$wf$wff"

new_scenario "data at the end"
scenario_execute "$(( 2 * word_size + 1))"
scenario_test_target "$wf$wf$wff$wd$wd$wd"

new_scenario "data on the second position"
scenario_execute "1"
scenario_test_target "$wff$wd$wd$wd$wffa$wf$wff"

new_scenario "last data byte on before last"
scenario_execute "$(( 2 * word_size))"
scenario_test_target "$wf$wf$wd$wd$wd$wff"
