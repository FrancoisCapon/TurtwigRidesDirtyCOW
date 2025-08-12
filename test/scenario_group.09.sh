target_size=$(( memory_page_size * 5 + 3 )) # 20483
data_size=$(( memory_page_size + 1 )) # 4097
bytes_urandom_target=$(cat /dev/urandom | tr -dc 'A-Za-z0-9' | head -c $target_size)
bytes_urandom_data=$(cat /dev/urandom | tr -dc 'A-Za-z0-9' | head -c $(( memory_page_size + 1 )))

new_scenario_group "file more five memory page size, date more on page size, may take minute(s)" "$bytes_urandom_target" "$bytes_urandom_data"

new_scenario "data at the begin"
scenario_execute "0"
scenario_test_md5 "$bytes_urandom_data$(echo -n $bytes_urandom_target | dd bs=1 skip=$data_size 2>/dev/null)"

new_scenario "data at the end"
scenario_execute "$(( target_size - data_size ))"
scenario_test_md5 "$(echo -n $bytes_urandom_target | dd bs=1 count=$(( target_size - data_size )) 2>/dev/null)$bytes_urandom_data"

new_scenario "data at the middle and non aligned of pages size"
data_offset=$(( data_size + 14 )) # 4111
target_tail_offset=$(( data_offset + data_size ))
scenario_execute "$data_offset"
bytes_target_head=$(echo -n $bytes_urandom_target | dd bs=1 count=$data_offset 2>/dev/null)
bytes_target_tail=$(echo -n $bytes_urandom_target | dd bs=1 skip=$target_tail_offset 2>/dev/null)
scenario_test_md5 "$bytes_target_head$bytes_urandom_data$bytes_target_tail"

