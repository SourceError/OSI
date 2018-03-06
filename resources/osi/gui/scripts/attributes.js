var statPoints = 25;
var str = 0;
var dex = 0;
var int = 0;

function incStr() {
    if (statPoints > 0) {
        statPoints--;
        str++;
        document.getElementById("str").value = str;
        document.getElementById("available").innerHTML = statPoints;
    }
}

function decStr() {
    if (str > 0) {
        statPoints++;
        str--;
        document.getElementById("str").value = str;
        document.getElementById("available").innerHTML = statPoints;
    }
}

function incDex() {
    if (statPoints > 0) {
        statPoints--;
        dex++;
        document.getElementById("dex").value = dex;
        document.getElementById("available").innerHTML = statPoints;
    }
}

function decDex() {
    if (dex > 0) {
        statPoints++;
        dex--;
        document.getElementById("dex").value = dex;
        document.getElementById("available").innerHTML = statPoints;
    }
}

function incInt() {
    if (statPoints > 0) {
        statPoints--;
        int++;
        document.getElementById("int").value = int;
        document.getElementById("available").innerHTML = statPoints;
    }
}

function decInt() {
    if (int > 0) {
        statPoints++;
        int--;
        document.getElementById("int").value = int;
        document.getElementById("available").innerHTML = statPoints;
    }
}