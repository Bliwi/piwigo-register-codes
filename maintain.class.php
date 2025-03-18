<?php
defined('PHPWG_ROOT_PATH') or die('Hacking attempt!');

class piwigo_register_codes_maintain extends PluginMaintain {

  function activate($plugin_version, &$errors=array()) {
    global $prefixeTable;

    // create table
    $query = 'CREATE TABLE IF NOT EXISTS ' . $prefixeTable . 'register_codes (
id INT AUTO_INCREMENT PRIMARY KEY,
code VARCHAR(255) NOT NULL,
comment VARCHAR(255) NULL,
uses int not null default 0,
used int not null default 0,
expiry TIMESTAMP NULL,
created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1;';
    pwg_query($query);

    $query = 'CREATE TABLE IF NOT EXISTS ' . $prefixeTable . 'register_codes_log (
id INT AUTO_INCREMENT PRIMARY KEY,
code VARCHAR(255) NOT NULL,
used_by VARCHAR(255) NOT NULL,
used_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
verified boolean not null default 0
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1;';
    pwg_query($query);

  }

  function deactivate() {
    global $prefixeTable;
    pwg_query('DROP TABLE IF EXISTS ' . $prefixeTable . 'register_codes;');
    pwg_query('DROP TABLE IF EXISTS ' . $prefixeTable . 'register_codes_log;');
  }

  // Can move stuff here to prevent from removing codes and log on deactivation, and instead do it on uninstall.. currently I prefer quick wipe capability.
  function uninstall() {
  }

}

?>
