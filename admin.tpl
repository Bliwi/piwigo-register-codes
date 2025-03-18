<div class="titlePage">
  <h2>{'Register Codes Plugin'|@translate}</h2>
</div>
<link rel="stylesheet" href="/plugins/piwigo-register-codes/css/foundation-datepicker.css">
<script src="/plugins/piwigo-register-codes/js/foundation-datepicker.js"></script>
<script>
  $(function() {
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

  function copyCodesWithSameComment() {
    const searchComment = document.querySelector('#batch-code textarea#batch_code_copy').value.trim();
    if (!searchComment) {
      alert("{'Please enter a comment to search for'|@translate}");
      return;
    }
    
    const codeTable = document.getElementById('previous_codes');
    const commentTextareas = codeTable.querySelectorAll('textarea[name="comment"]');
    
    let matchingCodes = [];
    
    commentTextareas.forEach(textarea => {
      if (textarea.value.trim() === searchComment) {
        // Find the parent row and extract the code
        const row = textarea.closest('tr');
        const codeInput = row.querySelector('input[name="code"]');
        if (codeInput && codeInput.value) {
          matchingCodes.push(codeInput.value);
        }
      }
    });
    
    if (matchingCodes.length === 0) {
      alert("{'No codes found with the matching comment'|@translate}");
      return;
    }
    
    // Copy all codes to clipboard
    const codesText = matchingCodes.join('\n');
    
    if (navigator.clipboard && navigator.clipboard.writeText) {
      navigator.clipboard.writeText(codesText).then(
        () => {
            alert(`Copied ` + matchingCodes.length + ` codes to clipboard!`);
        },
        (err) => {
          console.error("{'Failed to copy codes'|@translate}: ", err);
          alert("{'Failed to copy codes to clipboard'|@translate}");
        }
      );
    } else {
      // Fallback for older browsers
      const textarea = document.createElement("textarea");
      textarea.value = codesText;
      document.body.appendChild(textarea);
      textarea.select();
      try {
        document.execCommand("copy");
        alert(`Copied ` + matchingCodes.length + ` codes to clipboard!`);
      } catch (err) {
        console.error("{'Failed to copy codes'|@translate}: ", err);
        alert("{'Failed to copy codes to clipboard'|@translate}");
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
#expired_codes {
margin-top: 20px;
margin-bottom: 200px;
}
.table-margin {
margin-top: 10px;
margin-bottom: 10px;
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
          <td><button type="button" class="btn btn-bg" onclick="generateCode()">Generate Code</button>
            <p><input style="border:0" type="textarea" class="span2" name="register_code" placeholder="Example Code"
                id="register_code"></p>
          </td>
          <td>
            <p><textarea style="border: 0" class="span2" name="register_comment" placeholder="Optional Comment"
                id="register_comment"></textarea></p>
          </td>
          <td>
            <p>
              <center><input type="number" id="uses" name="uses"
                  value="{if isset($reg_codes_uses_default) && $reg_codes_uses_default != ''}{$reg_codes_uses_default}{else}1{/if}"
                  min="0"></center>
            </p>
          </td>
          <td>
            <p><input style="border:0" type="text" class="span2" name="register_expiry"
                value="{date("Y-m-d H:i:00", strtotime("+1 week", strtotime("now")))}" id="register_expiry"></p>
          </td>
          <td><button type="submit" class="btn btn-bg">Add</button></td>
        </tr>
      </form>
    </table>
  </div>
  <div id="batch-code">
    <details>
      <summary class="h2">{'Batch Code Generator'|@translate}</summary>
      <form method="post">
        <table border=1 class="table-margin">
          <tr>
          <th>{'Number of Codes'|@translate}</th>
          <th>{'Comment'|@translate}</th>
          <th>{'Number Of Uses'|@translate}<br>({'0 for unlimited'|@translate})</th>
          <th>{'Expires At'|@translate}</th>
          <th></th>
        </tr>
        <tr>
          <td>
            <input type="number" name="batch_count" id="batch_count" value="10" min="1" max="100">
          </td>
          <td>
            <textarea style="border: 0" class="span2" name="batch_comment" placeholder="Optional Comment" id="batch_comment"></textarea>
          </td>
          <td>
            <center><input type="number" id="batch_uses" name="batch_uses" 
                   value="{if isset($reg_codes_uses_default) && $reg_codes_uses_default != ''}{$reg_codes_uses_default}{else}1{/if}" 
                   min="0"></center>
          </td>
          <td>
            <input style="border:0" type="text" class="span2" name="batch_expiry" 
                   value="{date("Y-m-d H:i:00", strtotime("+1 week", strtotime("now")))}" id="batch_expiry">
          </td>
          <td>
            <button type="submit" class="btn btn-bg">Generate</button>
          </td>
        </tr>
        </table>
      </form>
      <form method="post">
        <table>
          <tr>
          <th colspan="5">{'Copy codes with the same comment'|@translate}</th>
      </tr>
      
      <tr>
        <td>
          <textarea style="border: 0" class="span2" id="batch_code_copy" placeholder="{'Comment to query for copy'|@translate}"></textarea>
        </td>
        <td><button type="button" class="btn btn-bg" onclick="copyCodesWithSameComment()">{'Copy'|@translate}</button></td>
      </tr>
    </table>
    </details>
  </div>
  
  <div id="previous_codes" class="table-margin">
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
              <input name="id" value="{$data.id}" id="id" readonly />
            </td>
            <td>
              <button type="button" class="btn pluginActionLevel1 btn-copy" onclick="copyCode('{$data.code}')">{'Copy'|@translate}
                Code</button><input name="code" value="{$data.code}" id="code" readonly />
            </td>
            <td>
              {if !empty($data.comment)}<textarea class="span2" name="comment"
                id="comment">{$data.comment}</textarea>{else}-
                {/if}
            </td>
            <td>
              <input name="uses" value="{if $data.uses == '0'}{'Unlimited'|@translate}{else}{$data.uses}{/if}" id="uses"
                readonly />
            </td>
            <td>
              <input name="used" value="{$data.used}" id="used" readonly />
            </td>
            <td>
              <input name="expiry" value="{if isset($data.expiry)}{$data.expiry}{else}-{/if}" id="expiry" readonly />
            </td>
            <td>
              <input name="created_at" value="{$data.created_at}" id="created_at" readonly />
            </td>
            <td>
              <button class="btn btn-red" type="submit">{'Delete'|@translate}</button>
            </td>
          </tr>
        </form>
      {/foreach}

    </table>

    {if $expired_codes != null}
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

          {foreach from=$expired_codes item=data}
            <form method='post'>
              <tr class="{cycle values='row-one,row-two'}">
                <td>
                  <input name="id" value="{$data.id}" id="id" readonly />
                </td>
                <td>
                  <input name="code" value="{$data.code}" id="code" readonly />
                </td>
                <td>
                  {if !empty($data.comment)}<textarea class="span2" name="comment"
                    id="comment">{$data.comment}</textarea>{else}-
                    {/if}
                </td>
                <td>
                  <input name="uses" value="{if $data.uses == '0'}{'Unlimited'|@translate}{else}{$data.uses}{/if}" id="uses"
                    readonly />
                </td>
                <td>
                  <input name="used" value="{$data.used}" id="used" readonly />
                </td>
                <td>
                  <input name="expiry" value="{$data.expiry}" id="expiry" readonly />
                </td>
                <td>
                  <input name="created_at" value="{$data.created_at}" id="created_at" readonly />
                </td>
                <td>
                  <button class="btn btn-red" type="submit">Delete</button>
                </td>
              </tr>
            </form>
          {/foreach}
        </table>
      </div>
    {/if}
</fieldset>