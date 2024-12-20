<?php
/*
Version: 1.0
Plugin Name: Register Codes
Plugin URI: // Here comes a link to the Piwigo extension gallery, after
           // publication of your plugin. For auto-updates of the plugin.
Author: swhite-photos
Description: Plugin that requires users to have a registration code to register.
Attributions: foundation-datepicker jss/cs plugin available from https://github.com/najlepsiwebdesigner/foundation-datepicker and also had help by reading the piwigo captcha plugin(s)
*/

// Chech whether we are indeed included by Piwigo.
if (!defined('PHPWG_ROOT_PATH')) die('Hacking attempt!');

// Define the path to our plugin.
define('REGISTER_CODES_PATH', PHPWG_PLUGINS_PATH.basename(dirname(__FILE__)).'/');

// Hook on to an event to show the administration page.
add_event_handler('get_admin_plugin_menu_links', 'register_codes_admin_menu');
add_event_handler('loc_begin_register', 'register_codes_register_init');
add_event_handler('init', 'register_codes_init');

function register_codes_admin_menu($menu) {
 array_push(
   $menu,
   array(
     'NAME'  => 'register_codes',
     'URL'   => get_admin_plugin_menu_link(dirname(__FILE__)).'/admin.php'
   )
 );
 return $menu;
}

function register_codes_init() {

  if (mobile_theme()) {
    return;
  }

  global $template;
  load_language('plugin.lang', REGISTER_CODES_PATH);
  load_language('lang', PHPWG_ROOT_PATH.PWG_LOCAL_DIR, array('no_fallback'=>true, 'local'=>true) );

}

function register_codes_register_init() {
    include(REGISTER_CODES_PATH . '/register_codes_register.php');
}
?>
