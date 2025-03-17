<?php
// Chech whether we are indeed included by Piwigo.
if (!defined('PHPWG_ROOT_PATH')) die('Hacking attempt!');

//Check If Administrator
check_status(ACCESS_ADMINISTRATOR);

// Fetch the template.
global $template, $prefixeTable;
include_once(PHPWG_ROOT_PATH . 'admin/include/tabsheet.class.php');

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
  global $prefixeTable, $template;
  $query = 'SELECT * from ' . $prefixeTable . 'register_codes;';
  $mysql_data = query2array($query);
  foreach($mysql_data as $data) {
    echo "<form method='post'>";
    echo "<tr>";
    echo "<td>";
    echo '<input style="border:0" name="id" value="' . $data['id']. '" id="id" readonly/>';
    echo "</td>";
    echo "<td>";
    echo '<input style="border:0" name="code" value="' . $data['code']. '" id="code" readonly/>';
    echo "</td>";
    echo "<td>";
    echo '<textarea style="border: 0" class="span2" name="comment" id="comment">' . $data['comment'] . '</textarea>';
    echo "</td>";
    echo "<td>";
    echo '<input style="border:0" name="uses" value="' . $data['uses']. '" id="uses" readonly/>';
    echo "</td>";
    echo "<td>";
    echo '<input style="border:0" name="used" value="' . $data['used']. '" id="used" readonly/>';
    echo "</td>";
    echo "<td>";
    echo '<input style="border:0" name="expiry" value="' . $data['expiry']. '" id="expiry" readonly/>';
    echo "</td>";
    echo "<td>";
    echo '<input style="border:0" name="created_at" value="' . $data['created_at']. '" id="created_at" readonly/>';
    echo "</td>";
    echo "<td>";
    echo '<button type="submit">Delete</button>';
    echo "</td>";
    echo "</tr>";
    echo "</form>";
  }
}

?>
