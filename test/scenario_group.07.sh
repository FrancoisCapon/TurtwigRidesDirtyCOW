bytes_urandom_target=$(cat /dev/urandom | tr -dc 'A-Za-z0-9' | head -c $(( memory_page_size * 2 + 3 )))
bytes_urandom_target_length=${#bytes_urandom_target}
bytes_urandom_target_first_last=${bytes_urandom_target:1}
bytes_urandom_target_last_before=${bytes_urandom_target:0:$((bytes_urandom_target_length - 1))}

new_scenario_group "file more three memory page size, data one character" "$bytes_urandom_target" "$wdf"

new_scenario "data at the begin"
scenario_execute "0"
scenario_test_md5 "$wdf$bytes_urandom_target_first_last"

new_scenario "data at the end"
echo "$(( bytes_urandom_target_length - 1 ))"
scenario_execute "$(( bytes_urandom_target_length - 1 ))"
scenario_test_md5 "$bytes_urandom_target_last_before$wdf"


