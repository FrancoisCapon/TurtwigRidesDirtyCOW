new_scenario_group "file do not fits word size, data is three words + one charater => padding" "$wf$wf$wf$wf$wf$wff" "$wd$wd$wd$wdf"

new_scenario "data at the begin, file padding three"
scenario_execute "0"
scenario_test_target "$wd$wd$wd$wdf$wffa$wf$wff"

new_scenario "data at the end, three x0 padding"
scenario_execute "$(( 2 * word_size))"
scenario_test_target "$wf$wf$wd$wd$wd$wdf"

new_scenario "last data byte on before last, one file and two x0 padding"
scenario_execute "$(( 2 * word_size - 1 ))"
scenario_test_target "$wf$wflb$wd$wd$wd$wdf$wff"
