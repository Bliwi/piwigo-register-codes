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
{/html_style}
<fieldset>
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
    <td><button type="button" onclick="generateCode()">Generate Code</button><p><input style="border:0" type="textarea" class="span2" name="register_code" placeholder="Example Code" id="register_code"></p></td>
    <td><p><textarea style="border: 0" class="span2" name="register_comment" placeholder="Optional Comment" id="register_comment"></textarea></p></td>
    <td><p><center><input type="number" id="uses" name="uses" value="1" min="0"></center></p></td>
    <td><p><input style="border:0" type="text" class="span2" name="register_expiry" value="{date("Y-m-d H:i:00", strtotime("+1 week", strtotime("now")))}" id="register_expiry"></p></td>
    <td><button type="submit">Add</button></td>
  </tr>
</form>
</table>

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
      <tr>
        <td>
          <input name="id" value="{$data.id}" id="id" readonly/>
        </td>
        <td>
          <button type="button" onclick="copyCode('{$data.code}')">Copy Code</button><input name="code" value="{$data.code}" id="code" readonly/>
        </td>
        <td>
          <textarea class="span2" name="comment" id="comment">{$data.comment}</textarea>
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
          <button type="submit">Delete</button>
        </td>
      </tr>
    </form>
  {/foreach}

</table>
</div>
</fieldset>

