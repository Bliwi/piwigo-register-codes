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
#previous_codes input, #previous_codes textarea {
  border: 0 !important;
}
table {
  border-collapse: collapse;
}

/* Table header styling */
thead {
  background-color: #4CAF50;
  color: white;
}

th, td {
  padding: 10px;
  border: 1px solid #ddd; /* Adds a border to cells */
}

/* Zebra striping for rows */
tbody tr:nth-child(odd) {
  background-color: #f9f9f9;
}

tbody tr:nth-child(even):not(.row1):not(.row2) {
  background-color: #f1f1f1;
}

/* Hover effect for rows */
tbody tr:hover {
  background-color: #ffedde !important;
}
#previous_codes INPUT {
  background-color: transparent !important;
  text-align: center;
}
#previous_codes textarea {  
  background-color: transparent !important;
}
#previous_codes .row-one {
  background-color: #f9f9f9;
}
#previous_codes .row-two {
  background-color: #f1f1f1;
}
.btn {
  font-weight: normal;
  border: none;
  border-radius: 5px;
  padding: 5px 10px;
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
    <th>{'Number Of Uses'|@translate}</th>
    <th>{'Expires At'|@translate}</th>
    <th></th>
  </tr>
  <tr>
    <!-- <td><p><textarea style="border: none;" class="span2" name="register_code" placeholder="Example Code" id="register_code"></textarea></p></td> -->
    <td><button type="button" class="btn" onclick="generateCode()">Generate Code</button><p><input style="border:0" type="textarea" class="span2" name="register_code" placeholder="Example Code" id="register_code"></p></td>
    <td><p><textarea style="border: 0" class="span2" name="register_comment" placeholder="Optional Comment" id="register_comment"></textarea></p></td>
    <td><p><center><input type="number" id="uses" name="uses" value="1" min="0"></center></p></td>
    <td><p><input style="border:0" type="text" class="span2" name="register_expiry" value="{date("Y-m-d H:i:00", strtotime("+1 week", strtotime("now")))}" id="register_expiry"></p></td>
    <td><button type="submit" class="btn">Add</button></td>
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
          <input name="uses" value="{$data.uses}" id="uses" readonly/>
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
</div>
</fieldset>

