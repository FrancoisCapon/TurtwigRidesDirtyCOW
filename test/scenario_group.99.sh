new_scenario_group "check ok,KO and ERROR" "$wf$wf$wf$wf$wf" "$wd"

# ok
new_scenario "check ok"
scenario_execute "0"
scenario_test_target "$wd$wf$wf$wf$wf"
#KO
new_scenario "check KO"
scenario_execute "0"
scenario_test_target "$wf$wf$wf$wf$wd"
#ERROR
new_scenario "check ERROR"
scenario_execute "1000"
scenario_test  "$wf$wf$wf$wf$wd" "$wf$wf$wf$wf$wd" "must be ERROR"
scenario_test  "$wf$wf$wf$wf$wd" "$wf$wf$wf$wf$wd" "must be ERROR and count once only"


