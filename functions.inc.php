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
	$used_query = 'SELECT * from ' . $prefixeTable . "activity where action='add' and (occured_on >= '$used_at' and occured_on <= '$used_at_plus_2s')";
	if ( pwg_db_num_rows(pwg_query($used_query))>=1 ) { // If there was a register activity within 2 seconds of code usage, it can be considered verified (hopefully)
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
