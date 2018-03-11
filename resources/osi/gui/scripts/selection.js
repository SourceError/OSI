function open_selection(characters) {
    document.body.innerHTML = '';

    var num = 0;
    while(characters[num] !== undefined) {
        document.body.innerHTML += create_id_markup(characters[num]);
        num += 1;
    }

    if (num < 3) {
        document.body.innerHTML += create_new_id_markup();
    }

    num = 0;
    while(characters[num] !== undefined) {
        document.body.innerHTML += create_character_information_markup(characters[num]);
        num += 1;
    }

    if (num < 3) {
        document.body.innerHTML += create_application_markup();
    }

    document.body.innerHTML += JSON.stringify(characters);

    var submit = document.getElementById("create");
    if (submit) {

    }
}

function selectCharacter(id) {
    var element_new = document.getElementById("New");
    if (element_new) {
        element_new.classList.remove("visible");
    }

    var matches = document.querySelectorAll(".char_id");
    matches.forEach(function(item) {
        if (item.getAttribute('char_id') == id) {
            item.classList.add("selected");
        } else {
            item.classList.remove("selected");
        }
    });

    matches = document.querySelectorAll(".char_info");
    matches.forEach(function(item) {
        if (item.getAttribute('char_id') == id) {
            item.classList.add("visible");
        } else {
            item.classList.remove("visible");
        }
    });   
}

function selectNew() {
    var matches = document.querySelectorAll(".char_id");
    matches.forEach(function(item) {
        item.classList.remove("selected");
    });

    matches = document.querySelectorAll(".char_info");
    matches.forEach(function(item) {
        item.classList.remove("visible");
    });

    document.getElementById("NewID").classList.add("selected"); 
    document.getElementById("New").classList.add("visible");   
}

function onClickDelete()
{

}

function onClickCreate()
{
    var sex = "";
    if (document.getElementById("male").checked) sex = "Male";
    if (document.getElementById("female").checked) sex = "Female";
    // Gather Data
    character_data = {
        first: document.getElementById("gname").value,
        last: document.getElementById("sname").value,
        str: Number(document.getElementById("str").value),
        dex: Number(document.getElementById("dex").value),
        int: Number(document.getElementById("int").value),
        car: document.getElementById("car").value,
        sex: sex,
        month: document.getElementById("month").value,
        day: document.getElementById("day").value,
        year: document.getElementById("year").value
    };
    $.post("http://osi/create_character", JSON.stringify(character_data));
}

function onClickPlay()
{
    // Gather Data
    var id = document.querySelector(".char_info.visible").getAttribute("char_id")

    character_identifier = { id: id };
    $.post("http://osi/select_character", JSON.stringify(character_identifier));
}