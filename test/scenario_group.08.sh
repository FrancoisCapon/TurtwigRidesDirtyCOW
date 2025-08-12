bytes_urandom_target=$(cat /dev/urandom | tr -dc 'A-Za-z0-9' | head -c $(( memory_page_size + 3 )))
bytes_urandom_data=$(cat /dev/urandom | tr -dc 'A-Za-z0-9' | head -c $(( memory_page_size + 3 )))

new_scenario_group "file more one memory page size, replace all bytes, may take minute(s)" "$bytes_urandom_target" "$bytes_urandom_data"

new_scenario "data bytes replace all file bytes"
scenario_execute "0"
scenario_test_md5 "$bytes_urandom_data"

