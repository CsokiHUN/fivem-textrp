let messages = [];
const main = document.querySelector('#main');
const messagesElement = document.querySelector('.messages');
const inputElement = document.querySelector('#msgInput');

const inputBox = document.querySelector('.inputBox');
inputBox.style.display = 'none';

function buildMessages() {
  messagesElement.innerHTML = '';

  if (messages.length > 20) {
    messages.pop(0, 1);
  }

  let content = '';

  messages.forEach((msg) => {
    content += `<div>${msg}</div>`;
  });

  messagesElement.innerHTML = content;
  messagesElement.scrollTop = messagesElement.scrollHeight;
}

window.addEventListener('message', ({ data }) => {
  if (data.inputState != undefined) {
    inputBox.style.display = (data.inputState && 'flex') || 'none';

    if (data.inputState) {
      inputElement.focus();
    }
  }

  if (data.message != undefined) {
    messages.push(data.message);
    buildMessages();
  }

  if (data.visible != undefined) {
    main.style.display = (data.visible && 'block') || 'none';
  }

  if (data.clear != undefined) {
    messages = [];
    buildMessages();
  }
});

window.addEventListener('keydown', (event) => {
  if (event.key == 'Escape') {
    fetch(`https://${GetParentResourceName()}/cancelOOC`);
    hideInput();
  }

  if (event.key == 'Enter') {
    fetch(`https://${GetParentResourceName()}/sendMessage`, {
      method: 'POST',
      body: JSON.stringify({
        message: inputElement.value,
      }),
    });
    hideInput();
  }
});

function hideInput() {
  inputElement.value = '';
  inputBox.style.display = 'none';
}
