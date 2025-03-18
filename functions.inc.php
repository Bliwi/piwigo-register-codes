<?php

//Updates when registration page or admin page is accessed
function verify_log() {
  global $template, $prefixeTable;
  $query = 'SELECT * from ' . $prefixeTable . "register_codes_log where verified = false";
  $result = pwg_query($query);
  while ($row = pwg_db_fetch_assoc($result)) {
        $login = $row['used_by'];
        $code = $row['code'];
        //echo "<br>Verifying $login -- $code</br>";
        $query = 'SELECT * from ' . $prefixeTable . "users where username='$login'";
        if ( pwg_db_num_rows(pwg_query($query))>=1 ) {
                //echo "<br>Verified this use!</br>";
                $update_query = 'update ' . $prefixeTable . "register_codes_log set verified = true where used_by='$login'";
                pwg_query($update_query);

                $query = 'SELECT used from ' . $prefixeTable . "register_codes where code = '$code'";
                list($used) = pwg_db_fetch_row( pwg_query($query) );
                $used++;
                $update_used = 'update ' . $prefixeTable . "register_codes set used = $used where code='$code'";
                pwg_query($update_used);

        }
  }
}

?>
