window.addEventListener("load",function(){
    var command = {};

    //COMMANDS
    command.open_selection = function(data) {

    }

    command.open_intro = function(data) {

    }

    //MESSAGES
    window.addEventListener("message",function(evt){ //lua actions
        if (command[evt.data.cmd] !== undefined) {
            command[evt.data.cmd](evt.data);
        } else {
            $.post("http://osi/error_message", JSON.stringify({ msg: "command.{0}(data) is missing.".format(evt.data.cmd) }));
        }
    });

});