var months = ["JAN", "FEB", "MAR", "APR", "MAY", "JUN", "JUL", "AUG", "SEP", "OCT", "NOV", "DEC"];

function getExpiration(ms) {
  var date = new Date(ms + 86400000);
  date.setFullYear(date.getFullYear() + 20);
  return date.getFullYear() + ' ' + months[date.getMonth()] + ' ' + date.getDate();
}

function formatDate(ms) {
  var date = new Date(ms + 86400000);
  return date.getFullYear() + ' ' + months[date.getMonth()] + ' ' + date.getDate();
}

function getAge(dob) {
  var date = new Date(dob + 86400000);
  var ageMs = new Date(Date.now() - date);
  return Math.abs(ageMs.getUTCFullYear() - 1970);
}

function create_new_id_markup() {
  const new_id_template = `
    <div id="NewID" class = "char_id overlay" onclick="selectNew();">
      <div class = "new_character">+</div>
    </div>
  `;

  return new_id_template;
}

function create_id_markup(character) {
  const id_template = `
  <div char_id="${character.id}" class="char_id overlay" onclick="selectCharacter('${character.id}');" >
    <div class = "given_name">${character.first_name}</div>
    <div class = "surname">${character.last_name.toUpperCase()}</div>
    <div class = "occupation_label">OCCUPATION</div>
    <div class = "occupation">${character.occupation}</div>
    <div class = "sex_label">SEX</div>
    <div class = "sex">${character.sex}</div>
    <div class = "dob_label">DOB</div>
    <div class = "dob">${formatDate(character.dob)}</div>
    <div class = "expiration_label">ISSUE DATE / EXP DATE</div>
    <div class = "expiration">${formatDate(character.created)} / ${getExpiration(character.created)}</div>
    <div class = "bank_desc">BANK SER NO</div>
    <div class = "bank_label">OSI</div>
    <div class = "bank_id">${character.account}</div>
  </div>
  `;

  return id_template;
}

function create_application_markup() { 
  const application_template = `
    <div id="New" class="char_app">
      <form>
        <label for="gname">NAME: </label>
        <input type="text" id="gname" name="gname" placeholder="First">
        <input type="text" id="sname" name="sname" placeholder="Last">
        <br>
        <label for="dob">DATE OF BIRTH: </label>
        <input style="width:25px;" type="number" id="month" name="month" placeholder="MM">
        /
        <input style="width:23px;" type="number" id="day" name="day" placeholder="DD">
        /
        <input style="width:40px;" type="number" id="year" name="year" placeholder="YYYY">
        <br>
        <label for="sex">SEX: </label>
        <label class="container">Male
          <input id="male" type="radio" checked="checked" name="sex" value="male">
          <span class="checkmark"></span>
        </label>
        <label class="container">Female
          <input id="female" type="radio" name="sex" value="female">
          <span class="checkmark"></span>
        </label>
        <br>
        <br>
        <br>
        <label for="car">VEHICLE: </label>
        <select id="car" name="car">
          <option value="Adder">Adder</option>
          <option value="Feltzer">Feltzer</option>
          <option value="Banshee">Banshee</option>
        </select>
        <br>
        <br>
        <br>
        <label>ATTRIBUTE POINTS:</label>
        <label id="available">25</label>
        <br>
        <label>Strength:</label>
        <div style="display:inline;left:165px;">
        <button type="button" onclick="decStr()">-</button>
        <input class="attribute" type="number" name="strength" id="str" value="0" readonly>
        <button type="button" onclick="incStr()">+</button>
        </div>
        <br>
        <label>Dexterity:</label>
        <div style="display:inline;left:159px;">
        <button type="button" onclick="decDex()">-</button>
        <input class="attribute" type="number" name="dexterity" id="dex" value="0" readonly>
        <button type="button" onclick="incDex()">+</button>
        </div>
        <br>
        <label>Intelligence:</label>
        <div style="display:inline;left:145px;">
        <button type="button" onclick="decInt()">-</button>
        <input class="attribute" type="number" name="intelligence" id="int" value="0" readonly>
        <button type="button" onclick="incInt()">+</button>
        </div><br><br><br>
        <i>Strength affects melee damage and resistance</i>
        <br>
        <i>Dexterity affects run speed, stamina and jump height</i>
        <br>
        <i>Intelligence affects completion time of certain jobs and crimes</i>

        <button id="create" style="position:absolute;top:430px;left:115px;" class="confirm_button" onclick="onClickCreate();" >CREATE</button>
      </form>
    </div>
  `;

  return application_template;
}

function create_character_information_markup(character) {
  const information_template = `
  <div char_id="${character.id}" class="char_info">
      <div class="information">
        <div style="left:20px;position:relative;font-size:25px;">${character.first_name}</div>
        <div style="left:20px;position:relative;font-size:25px;">${character.last_name.toUpperCase()}</div>
        <br>
        <br>
        <fieldset>
        <legend>PERSONAL</legend>
        <label>AGE</label>
        <div>${getAge(character.dob)}</div>
        <br>
        <label>SEX</label>
        <div>${character.sex}</div>
        <br>
        <label>OCCUPATION</label>
        <div>${character.occupation}</div>
        </fieldset>
        <br>
        <fieldset>
        <legend>ATTRIBUTES</legend>
        <label>STRENGTH</label>
        <div>${character.strength}</div>
        <br>
        <label>DEXTERITY</label>
        <div>${character.dexterity}</div>
        <br>
        <label>INTELLIGENCE</label>
        <div>${character.intelligence}</div>
        </fieldset>
        <br>
        <fieldset>
        <legend>MONEY</legend>
        <label>ACCOUNT NO</label>
        <div>${character.account}</div>
        <br>
        <label>CASH</label>
        <div>$${character.cash}</div>
        <br>
        <label>BANK BALANCE</label>
        <div>$${character.bank}</div>
        </fieldset>
      </div>
      <button style="position:absolute;top:530px;left:45px;" class="delete_button" onclick="onClickDelete();" >DELETE</button>
      <button style="position:absolute;top:530px;left:295px;" class="confirm_button" onclick="onClickPlay();" >PLAY</button>
    </div>
  `;

  return information_template;
}

function create_context_menu_item_markup(item) {
  const context_menu_item_template = `
    <li><a onclick="context_menu_select(${item.category}, ${item.id}, '${item.label}')">${item.label}</a></li>
  `;
  return context_menu_item_template;
}

function create_context_menu_markup(title, menu_items_markup) {
  const context_menu_template = `
  <div id="context_menu">
      <h3>${title}</h3>
      <ul>
          ${menu_items_markup}
      </ul>
  </div>
  `;
  return context_menu_template;
}