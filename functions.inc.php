<?php

//Updates when registration page or admin page is accessed
function verify_log() {
  global $template, $prefixeTable;
  $query = 'SELECT * from ' . $prefixeTable . "register_codes_log where verified = false";
  $result = pwg_query($query);
  while ($row = pwg_db_fetch_assoc($result)) {
        $login = $row['used_by'];
        $code = $row['code'];
	$used_at = $row['used_at'];
	$used_at_plus_2s = date("Y-m-d H:i:s", strtotime($used_at) + 2);

	// Find user ID for login that registered in the users table, then cross join users table with user infos table and compare registration date for that user id
	$query = 'SELECT id from ' . $prefixeTable . "users where username = '$login'";
	list($user_id) = pwg_db_fetch_row( pwg_query($query) );
	$used_query = 'SELECT ' . $prefixeTable . 'users.id, ' . $prefixeTable  . 'user_infos.registration_date, ' . $prefixeTable  . 'user_infos.user_id FROM ' . $prefixeTable . 
'users CROSS JOIN ' . $prefixeTable . 'user_infos WHERE ' . $prefixeTable . 'users.id = "' . $user_id . '" AND ' . $prefixeTable . 'user_infos.user_id = "' . $user_id . '" and (' . $prefixeTable . 
'user_infos.registration_date >= "' . $used_at . '" and ' . $prefixeTable  . 'user_infos.registration_date <= "' . $used_at_plus_2s . '")';

	if ( pwg_db_num_rows(pwg_query($used_query))>=1 ) { // If there was a register activity within 2 seconds of code usage for that user id, it can be considered verified (hopefully)
	        $query = 'SELECT * from ' . $prefixeTable . "users where username='$login'";
	        if ( pwg_db_num_rows(pwg_query($query))>=1 ) {
                	$update_query = 'update ' . $prefixeTable . "register_codes_log set verified = true where used_by='$login' and used_at = '$used_at'";
	                pwg_query($update_query);
        	        $query = 'SELECT used from ' . $prefixeTable . "register_codes where code = '$code'";
                	list($used) = pwg_db_fetch_row( pwg_query($query) );
	                $used++;
        	        $update_used = 'update ' . $prefixeTable . "register_codes set used = $used where code='$code'";
                	pwg_query($update_used);

	        }
	}
  }
}

?>
