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
</script>

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

{get_register_codes()}

</table>
</fieldset>

