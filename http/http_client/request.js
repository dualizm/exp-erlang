'use strict'

/** @type {HTMLElement} */
const $btn = document.getElementById("btn");
const $list = document.getElementById("list");

async function requestToServer() {
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
        const $listItem = document.createElement('li');
        $listItem.appendChild(document.createTextNode(`${err}`));
        $list.appendChild($listItem);
    }
}

$btn.addEventListener('click', async () => {
    const promises = [];

    for(let i = 0; i < 1000; ++i) {
        promises.push(requestToServer());
    }

    await Promise.all(promises);
});