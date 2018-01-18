/**
 * Copyright (c) 2009-2010, Redcloud Development, Ltd. All rights reserved
 * @author Alex Westphal
 */

function removeFinger() {
    document.getElementById("finger").innerHTML = "";
}

function putFinger() {
    document.getElementById("finger").innerHTML = "<a onclick='removeFinger(); return false;'><img src='/moot/images/finger.png'></a>";
}



