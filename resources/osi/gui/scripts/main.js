var characters = {
    0: {
        id: '03A',
        first: 'George',
        last: 'Williams',
        occupation: 'Taxi Driver',
        sex: 'Male',
        dob: '1990 MAR 20',
        created: '2017 MAR 01',
        expiration: '2037 MAR 01',
        account: '03A',
        age: '27',
        strength: '10',
        dexterity: '12',
        intelligence: '13',
        cash: '1,000',
        bank: '10,000'
    },
    1: {
        id: '0BA',
        first: 'Gary',
        last: 'Busey',
        occupation: 'Law Enforcement Officer',
        sex: 'Male',
        dob: '1991 MAR 21',
        created: '2017 MAR 01',
        expiration: '2037 MAR 01',
        account: '0BA',
        age: '26',
        strength: '15',
        dexterity: '10',
        intelligence: '11',
        cash: '2,400',
        bank: '15,000'
    },
    /*2: {
        id: '001',
        first: 'Christopher',
        last: 'Montana',
        occupation: 'Unemployed',
        sex: 'Male',
        dob: '1980 MAR 20',
        created: '2017 MAR 01',
        expiration: '2037 MAR 01',
        account: '001',
        age: '37',
        strength: '10',
        dexterity: '12',
        intelligence: '13',
        cash: '5,000',
        bank: '14,000'
    }*/
}

var test_menu = {
    menu_title: "Player",
    menu : {
        0: {
            label: "Give Cash",
            category: 1,
            id: 1
        },
        1: {
            label: "HandCuff",
            category: 1,
            id: 2
        },
        2: {
            label: "Rob",
            category: 1,
            id: 3
        },
        3: {
            label: "Kick",
            category: 1,
            id: 4
        }
    }
}

var mouseInfo;

window.addEventListener("load",function(){
    var command = {};

    //COMMANDS
    command.open_selection = function(data) {
        open_selection(data.characters);
    }

    command.open_intro = function(data) {

    }

    command.open_context_menu = function(data) {
        open_context_menu(data.menu_title, data.menu)
        var menu_div = document.getElementById("context_menu");
        if(menu_div !== undefined) {
            menu_div.style.top = mouseInfo.y;
            menu_div.style.left = mouseInfo.x;
        }
    }

    command.get_mouse_pos = function(data) {
        $.post("http://osi/mouse_pos", JSON.stringify(mouseInfo))
    }

    //MESSAGES
    window.addEventListener("message",function(evt){ //lua actions
        if (command[evt.data.cmd] !== undefined) {
            command[evt.data.cmd](evt.data);
        } else {
            $.post("http://osi/error_message", JSON.stringify({ msg: "command.{0}(data) is missing.".format(evt.data.cmd) }));
        }
    });

    track_mouse();
});

function track_mouse()
{
    var body = document.body,
    html = document.documentElement;
    var height = Math.max( body.scrollHeight, body.offsetHeight, 
                           html.clientHeight, html.scrollHeight, html.offsetHeight );
    var width = Math.max( body.scrollWidth, body.offsetWidth, 
                           html.clientWidth, html.scrollWidth, html.offsetWidth );

    document.onmousemove = handleMouseMove;
    document.onmouseup = handleMouseUp;

    function handleMouseMove(event) {
        mouseInfo = {
            x: event.pageX,//(event.pageX + 0.5) / width,
            y: event.pageY,//(event.pageY + 0.5) / height
            w: width,
            h: height 
        };
    }

    function handleMouseUp(event) { 
        if (event.button == 2) {
            $.post("http://osi/mouse_pos", JSON.stringify(mouseInfo))
        }
    }
}
