function onClickGary()
{
    document.getElementById("NewID").classList.remove("selected");
    document.getElementById("GaryID").classList.add("selected"); 

    document.getElementById("New").classList.remove("visible");
    document.getElementById("Gary").classList.add("visible");
}

function onClickNew()
{
    document.getElementById("GaryID").classList.remove("selected");
    document.getElementById("NewID").classList.add("selected"); 

    document.getElementById("Gary").classList.remove("visible");
    document.getElementById("New").classList.add("visible");   
}

function onClickDelete()
{

}

function onClickCreate()
{
    // Gather Data
    character_data = {};
    $.post("http://osi/create_character", JSON.stringify(character_data));
}

function onClickPlay()
{
    // Gather Data
    character_identifier = {}
    $.post("http://osi/load_character", JSON.stringify({}));
}