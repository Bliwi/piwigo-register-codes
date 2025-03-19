<?php
if (!defined('PHPWG_ROOT_PATH')) die('Hacking attempt!');

global $template, $prefixeTable;

$template->set_filename('register_codes_register', realpath(REGISTER_CODES_PATH.'register_codes_register.tpl'));
$template->assign('REGISTERCODES', array('parsed_content' => $template->parse('register_codes_register', true)), true);

add_event_handler('loc_end_page_header', 'add_register_codes');
add_event_handler('register_user_check', 'check_code');

function add_register_codes() {
  global $template;
  $template->set_prefilter('register', 'prefilter_register_codes');
}

function prefilter_register_codes($content) {
  $search ="{'Send my connection settings by email'|@translate}"; // bootstrap darkroom, may change if your theme is different
  return str_replace($search, $search.'{$REGISTERCODES.parsed_content}', $content);
}

function check_code($errors) {
  global $prefixeTable, $_POST;
  if(isset($_POST['register_code'])) {
    $register_code = $_POST['register_code'];
    $now = date("Y-m-d H:i:s");
    $check_query = 'select * from ' . $prefixeTable . "register_codes where code='$register_code' and (expiry>='$now' or expiry IS NULL)";
    $check_return = pwg_query($check_query);
    $code_count = pwg_db_num_rows($check_return);
    if ($code_count == 0) {
      $errors[] = l10n('Invalid Registration Code');
    }else{
	$check_used = 'select used,uses from ' . $prefixeTable . "register_codes where code='$register_code' and (expiry>='$now' or expiry IS NULL)";
	list($used,$uses) = pwg_db_fetch_row( pwg_query($check_used) );
	if($used >= $uses ) {
	  if($uses == 0) {
	        $used++;
                $update_used = 'update ' . $prefixeTable . "register_codes set used = $used where code='$register_code' and (expiry>='$now' or expiry IS NULL)";
  	        pwg_query($update_used);

	  }else{
		$errors[] = l10n('Invalid Registration Code');
	  }
	}else{
          $used++;
          $update_used = 'update ' . $prefixeTable . "register_codes set used = $used where code='$register_code' and (expiry>='$now' or expiry IS NULL)";
          pwg_query($update_used);
	}
    }
  }else{
    $errors[] = l10n('Invalid Registration Code');
  }
  return $errors;
}

?>
