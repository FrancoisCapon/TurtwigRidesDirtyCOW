new_scenario_group "file do not fits word size, data is one charater => padding" "$wf$wf$wf$wf$wf$wff" "$wdf"

new_scenario "data at the begin, file padding three"
scenario_execute "0"
scenario_test_target "$wdf$wffa$wf$wf$wf$wf$wff"

new_scenario "data at the end, three x0 padding"
scenario_execute "$(( 5 * word_size))"
scenario_test_target "$wf$wf$wf$wf$wf$wdf"

new_scenario "last data byte on before last, one file and two x0 padding"
scenario_execute "$(( 5 * word_size - 1 ))"
scenario_test_target "$wf$wf$wf$wf$wflb$wdf$wff"

new_scenario "last data byte on before last, two file and one x0 padding"
scenario_execute "$(( 5 * word_size - 2 ))"
scenario_test_target "$wf$wf$wf$wf$wflb2$wdf$wfl$wff"
