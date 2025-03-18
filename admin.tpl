<div class="titlePage">
 <h2>{'Register Codes Plugin'|@translate}</h2>
</div>
<link rel="stylesheet" href="/plugins/piwigo-register-codes/css/foundation-datepicker.css">
<script src="/plugins/piwigo-register-codes/js/foundation-datepicker.js"></script>
<script>
$(function(){
  $('#register_expiry').fdatepicker({
              format: 'yyyy-mm-dd hh:ii:ss',
              disableDblClickSelection: true,
              language: 'vi',
              pickTime: true
      });

  // Add dark theme detection and styling
  function isDarkTheme() {
    const bodyBg = window.getComputedStyle(document.body).backgroundColor;
    return bodyBg === 'rgb(68, 68, 68)'; // #444
  }

  function applyThemeStyles() {
    if (isDarkTheme()) {
      document.documentElement.style.setProperty('--table-header-bg', '#2c662f');
      document.documentElement.style.setProperty('--table-header-color', '#ffffff');
      document.documentElement.style.setProperty('--row-odd-bg', '#333333');
      document.documentElement.style.setProperty('--row-even-bg', '#3d3d3d');
      document.documentElement.style.setProperty('--border-color', '#666');
      document.documentElement.style.setProperty('--hover-color', '#4a3c2e');
      document.documentElement.style.setProperty('--text-color', '#ffffff');
      document.documentElement.style.setProperty('--btn-bg', '#444444');
      document.documentElement.style.setProperty('--btn-color', '#ffffff');
    }
  }

  applyThemeStyles();
});

function generateCode() {
  var code = Math.random().toString(36).substring(2, 15) + Math.random().toString(36).substring(2, 15);
  $('#register_code').val(code);
}
function copyCode(code) {
  if (navigator.clipboard && navigator.clipboard.writeText) {
    // Use the modern Clipboard API if available
    navigator.clipboard.writeText(code).then(
      () => {
        console.log("Code copied to clipboard!");
      },
      (err) => {
        console.error("Failed to copy code: ", err);
      }
    );
  } else {
    // Fallback for older browsers
    const textarea = document.createElement("textarea");
    textarea.value = code;
    document.body.appendChild(textarea);
    textarea.select();
    try {
      document.execCommand("copy");
      console.log("Code copied to clipboard!");
    } catch (err) {
      console.error("Fallback: Failed to copy code: ", err);
    }
    document.body.removeChild(textarea);
  }
}
</script>

{html_style}
:root {
  --table-header-bg: #4CAF50;
  --table-header-color: white;
  --row-odd-bg: #f9f9f9;
  --row-even-bg: #f1f1f1;
  --border-color: #ddd;
  --hover-color: #ffedde;
  --text-color: #000000;
  --btn-bg: #dddddd;
  --btn-color: #000000;
}

#previous_codes input, #previous_codes textarea {
  border: 0 !important;
  color: var(--text-color);
}

table {
  border-collapse: collapse;
}

/* Table header styling */
thead {
  background-color: var(--table-header-bg);
  color: var(--table-header-color);
}

th, td {
  padding: 10px;
  border: 1px solid var(--border-color); /* Adds a border to cells */
}

/* Zebra striping for rows */
tbody tr:nth-child(odd) {
  background-color: var(--row-odd-bg);
}

tbody tr:nth-child(even):not(.row1):not(.row2) {
  background-color: var(--row-even-bg);
}

/* Hover effect for rows */
tbody tr:hover {
  background-color: var(--hover-color) !important;
}
#previous_codes INPUT {
  background-color: transparent !important;
  text-align: center;
}
#previous_codes textarea {  
  background-color: transparent !important;
}
#previous_codes .row-one {
  background-color: var(--row-odd-bg);
}
#previous_codes .row-two {
  background-color: var(--row-even-bg);
}
.btn {
  font-weight: normal;
  border: none;
  border-radius: 5px;
  padding: 5px 10px;
}
.btn-bg {
  background-color: var(--btn-bg);
  color: var(--btn-color);
}
.btn-copy {
  margin-right: 10px;
}
.btn-red {
  color: white;
  background-color: #f44336;
}
#new-code INPUT {
  padding: 5px;
  border-radius: 5px;
}
#new-code textarea {
  padding: 5px;
  border-radius: 5px;
}
{/html_style}
<fieldset>
<div id="new-code">
<legend>{'Register Codes Description'|@translate}</legend>
<table border=1>
<form method="post">
  <tr>
    <th colspan="5">{'Add New Code'|@translate}</th>
  </tr>
  <tr>
    <th>{'Code'|@translate}</th>
    <th>{'Comment'|@translate}</th>
    <th>{'Number Of Uses'|@translate}<br>({'0 for unlimited'|@translate})</th>
    <th>{'Expires At'|@translate}</th>
    <th></th>
  </tr>
  <tr>
    <!-- <td><p><textarea style="border: none;" class="span2" name="register_code" placeholder="Example Code" id="register_code"></textarea></p></td> -->
    <td><button type="button" class="btn btn-bg" onclick="generateCode()">Generate Code</button><p><input style="border:0" type="textarea" class="span2" name="register_code" placeholder="Example Code" id="register_code"></p></td>
    <td><p><textarea style="border: 0" class="span2" name="register_comment" placeholder="Optional Comment" id="register_comment"></textarea></p></td>
    <td><p><center><input type="number" id="uses" name="uses" value="{if isset($reg_codes_uses_default) && $reg_codes_uses_default != ''}{$reg_codes_uses_default}{else}1{/if}" min="0"></center></p></td>
    <td><p><input style="border:0" type="text" class="span2" name="register_expiry" value="{date("Y-m-d H:i:00", strtotime("+1 week", strtotime("now")))}" id="register_expiry"></p></td>
    <td><button type="submit" class="btn btn-bg">Add</button></td>
  </tr>
</form>
</table>
</div>
<br><br>
<div id="previous_codes">
<table border=1>
  <tr>
    <th colspan="8">{'Existing Codes'|@translate}</th>
  </tr>
  <tr>
    <th>{'ID'|@translate}</th>
    <th>{'Code'|@translate}</th>
    <th>{'Comment'|@translate}</th>
    <th>{'Number Of Uses'|@translate}</th>
    <th>{'Times Used'|@translate}</th>
    <th>{'Expires At'|@translate}</th>
    <th>{'Created At'|@translate}</th>
    <th></th>
  </tr>

  {foreach from=$register_codes item=data}
    <form method='post'>
      <tr class="{cycle values='row-one,row-two'}">
        <td>
          <input name="id" value="{$data.id}" id="id" readonly/>
        </td>
        <td>
          <button type="button" class="btn pluginActionLevel1 btn-copy" onclick="copyCode('{$data.code}')">Copy Code</button><input name="code" value="{$data.code}" id="code" readonly/>
        </td>
        <td>
          {if !empty($data.comment)}<textarea class="span2" name="comment" id="comment">{$data.comment}</textarea>{else}-{/if}
        </td>
        <td>
          <input name="uses" value="{if $data.uses == '0'}{'Unlimited'|@translate}{else}{$data.uses}{/if}" id="uses" readonly/>
        </td>
        <td>
          <input name="used" value="{$data.used}" id="used" readonly/>
        </td>
        <td>
          <input name="expiry" value="{if isset($data.expiry)}{$data.expiry}{else}-{/if}" id="expiry" readonly/>
        </td>
        <td>
          <input name="created_at" value="{$data.created_at}" id="created_at" readonly/>
        </td>
        <td>
          <button class="btn btn-red" type="submit">Delete</button>
        </td>
      </tr>
    </form>
  {/foreach}

</table>
{*
<div id="expired_codes">
<table border=1>
  <tr>
    <th colspan="8">{'Expired Codes'|@translate}</th>
  </tr>
  <tr>
    <th>{'ID'|@translate}</th>
    <th>{'Code'|@translate}</th>
    <th>{'Comment'|@translate}</th>
    <th>{'Number Of Uses'|@translate}</th>
    <th>{'Times Used'|@translate}</th>
    <th>{'Expires At'|@translate}</th>
    <th>{'Created At'|@translate}</th>
    <th></th>
  </tr>

  {foreach from=$register_expired_codes item=data}
    <form method='post'>
      <tr class="{cycle values='row-one,row-two'}">
        <td>
          <input name="id" value="{$data.id}" id="id" readonly/>
        </td>
        <td>
          <button type="button" class="btn pluginActionLevel1 btn-copy" onclick="copyCode('{$data.code}')">Copy Code</button><input name="code" value="{$data.code}" id="code" readonly/>
        </td>
        <td>
          {if !empty($data.comment)}<textarea class="span2" name="comment" id="comment">{$data.comment}</textarea>{else}-{/if}
        </td>
        <td>
          <input name="uses" value="{if $data.uses == '0'}{'Unlimited'|@translate}{else}{$data.uses}{/if}" id="uses" readonly/>
        </td>
        <td>
          <input name="used" value="{$data.used}" id="used" readonly/>
        </td>
        <td>
          <input name="expiry" value="{$data.expiry}" id="expiry" readonly/>
        </td>
        <td>
          <input name="created_at" value="{$data.created_at}" id="created_at" readonly/>
        </td>
        <td>
          <button class="btn btn-red" type="submit">Delete</button>
        </td>
      </tr>
    </form>
  {/foreach}

</table>
*}
</div>
</fieldset>

