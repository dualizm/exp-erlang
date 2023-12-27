'use strict'

/** @type {HTMLElement} */
const $btn = document.getElementById("btn");
const $list = document.getElementById("list");

$btn.addEventListener('click', async () => {
    try{
        const request = await fetch("http://127.0.0.1:8080/", {
            method: "GET",
        });

        if(request.ok) {
            const $listItem = document.createElement('li');
            $listItem.appendChild(document.createTextNode('ok'));
            $list.appendChild($listItem);
        } else {
            throw new Error(request.status);
        }
    } catch (err) {
        alert(`Error: ${err}`);
    }
});