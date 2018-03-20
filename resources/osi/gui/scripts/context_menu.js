function open_context_menu(x, y, title, menu) {
    document.body.innerHTML = '';
    var num = 0;
    var items_markup = "";
    while(menu[num] !== undefined) {
        items_markup = items_markup + create_context_menu_item_markup(menu[num]);
        num = num + 1
    }
    document.body.innerHTML = create_context_menu_markup(x, y, title, items_markup);
}

function context_menu_select(category, id, label) {
    var selection = { category: category, id: id, label: label };
    $.post("http://osi/menu_action", JSON.stringify(selection));
    document.body.innerHTML = '';
}