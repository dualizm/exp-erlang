'use strict'

/** @type {HTMLElement} */
const $btn = document.getElementById("btn");
const $list = document.getElementById("list");

const responseCount = new Map();

async function addDataToList(data) {
    responseCount.set(data, (responseCount.get(data) || 0) + 1);
    const $newChildrens = [];
    responseCount.forEach((value, key) => {
        const $listItem = document.createElement('li');
        $listItem.appendChild(document.createTextNode(`${key}: ${value}`));
        $newChildrens.push($listItem);
    });

    $list.replaceChildren(...$newChildrens);
}

async function requestToServer() {
    try{
        const request = await fetch("http://127.0.0.1:8080/", {
            method: "GET",
        });

        if(request.ok) {
            const data = await request.text();
            addDataToList(data);
        } else {
            throw new Error(request.status);
        }
    } catch (err) {
        addDataToList(`${err}`);
    }
}

$btn.addEventListener('click', async () => {
    const promises = [];

    for(let i = 0; i < 50; ++i) {
        promises.push(requestToServer());
    }

    await Promise.all(promises);
});