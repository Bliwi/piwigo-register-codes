<?php
// Chech whether we are indeed included by Piwigo.
if (!defined('PHPWG_ROOT_PATH')) die('Hacking attempt!');

//Check If Administrator
check_status(ACCESS_ADMINISTRATOR);

// Fetch the template.
global $template, $prefixeTable;
include_once(PHPWG_ROOT_PATH . 'admin/include/tabsheet.class.php');
get_register_codes();
// Add our template to the global template
$template->set_filenames(
 array(
    'plugin_admin_content' => dirname(__FILE__) . '/admin.tpl',
 )
);

// Assign the template contents to ADMIN_CONTENT
$template->assign_var_from_handle('ADMIN_CONTENT', 'plugin_admin_content');

if (isset($_POST["register_code"])) {

  $register_code = $_POST["register_code"];
  $register_comment = $_POST["register_comment"];
  $uses = $_POST["uses"];
  $register_expiry = $_POST["register_expiry"];
  $_SESSION['reg_codes_uses_default'] = $uses;
  $check_query = 'select * from ' . $prefixeTable . "register_codes where code='$register_code'";
  $code_count = pwg_db_num_rows(pwg_query($check_query));

  if ($code_count >= 1) {
    echo "<font color='red'>Duplicate Code Entry Not Allowed.</font>";
  }else{
    if($register_code == "") {
        echo "<font color='red'>Registration Code Required.</font>";
    }else{
      if($register_expiry == "") {
        $query = 'insert into ' . $prefixeTable . "register_codes (code,comment,uses,expiry) values ('$register_code','$register_comment','$uses',NULL)";
      }else{
        $query = 'insert into ' . $prefixeTable . "register_codes (code,comment,uses,expiry) values ('$register_code','$register_comment','$uses','$register_expiry')";
      }
      pwg_query($query);
      $self_url = $_SERVER['PHP_SELF'].'?'.$_SERVER['QUERY_STRING'];
      redirect($self_url);
    }
  }
}

if (isset($_POST["id"],$_POST["code"])) {
  $query = 'delete from ' . $prefixeTable . 'register_codes where id="' . $_POST["id"] . '" and code="' . $_POST["code"] . '"';
  pwg_query($query);
  $self_url = $_SERVER['PHP_SELF'].'?'.$_SERVER['QUERY_STRING'];
  redirect($self_url);
}

function get_register_codes() {
  global $template, $prefixeTable;
  
  $query = 'SELECT * FROM ' . $prefixeTable . 'register_codes ORDER BY id DESC';
  $result = pwg_query($query);
  
  $codes = array();
  $expired_codes = array();
  
  while ($row = pwg_db_fetch_assoc($result)) {
    // Check if code is expired by usage count or date
    if (($row['used'] >= $row['uses'] && $row['uses'] != 0) || 
        ($row['expiry'] !== NULL && strtotime($row['expiry']) < time())) {
      $expired_codes[] = $row;
    } else {
      $codes[] = $row;
    }
  }
  
  if(isset($_SESSION['reg_codes_uses_default'])){
    $template->assign('reg_codes_uses_default', $_SESSION['reg_codes_uses_default']);
  }else{
    $template->assign('reg_codes_uses_default', 0);
  }
  
  $template->assign('register_codes', $codes);
  $template->assign('expired_codes', $expired_codes);
  
  // Pass any generated batch codes to the template
  if (isset($_SESSION['generated_batch_codes'])) {
    $template->assign('generated_batch_codes', $_SESSION['generated_batch_codes']);
    $template->assign('batch_success_count', $_SESSION['batch_success_count']);
    
    // Clear the session values after they've been displayed once
    if (!isset($_POST["batch_count"])) {
      unset($_SESSION['generated_batch_codes']);
      unset($_SESSION['batch_success_count']);
    }
  }
}

// Batch code generator function
if (isset($_POST["batch_count"])) {
  $batch_count = intval($_POST["batch_count"]);
  $batch_comment = isset($_POST["batch_comment"]) ? $_POST["batch_comment"] : '';
  $batch_uses = isset($_POST["batch_uses"]) ? $_POST["batch_uses"] : 1;
  $batch_expiry = isset($_POST["batch_expiry"]) ? $_POST["batch_expiry"] : '';
  $_SESSION['reg_codes_uses_default'] = $batch_uses;
  
  $generated_codes = array();
  $success_count = 0;
  
  // Generate requested number of codes
  for ($i = 0; $i < $batch_count; $i++) {
    // Generate a unique code
    $unique = false;
    $code = '';
    
    while (!$unique) {
      // Generate random code (combination of two random strings for better uniqueness)
      $code = substr(str_shuffle(str_repeat('0123456789abcdefghijklmnopqrstuvwxyz', 5)), 0, 22);
      
      // Check if code already exists
      $check_query = 'SELECT COUNT(*) FROM ' . $prefixeTable . "register_codes WHERE code='$code'";
      $result = pwg_query($check_query);
      list($count) = pwg_db_fetch_row($result);
      
      if ($count == 0) {
        $unique = true;
      }
    }
    
    // Insert the code
    if ($batch_expiry == "") {
      $query = 'INSERT INTO ' . $prefixeTable . "register_codes (code, comment, uses, expiry) VALUES ('$code', '$batch_comment', '$batch_uses', NULL)";
    } else {
      $query = 'INSERT INTO ' . $prefixeTable . "register_codes (code, comment, uses, expiry) VALUES ('$code', '$batch_comment', '$batch_uses', '$batch_expiry')";
    }
    
    if (pwg_query($query)) {
      $success_count++;
      $generated_codes[] = $code;
    }
  }
  
  // Store generated codes in session for display
  $_SESSION['generated_batch_codes'] = $generated_codes;
  $_SESSION['batch_success_count'] = $success_count;
  
  $self_url = $_SERVER['PHP_SELF'].'?'.$_SERVER['QUERY_STRING'];
  redirect($self_url);
}

// Call this function to make sure the data is available for the template


?>
