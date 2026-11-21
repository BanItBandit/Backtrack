// Shared by every page that has the game dialog.
const dialog = document.getElementById('game-dialog');
const csrfToken = document.querySelector('meta[name="csrf-token"]').content;
let currentGameId = null;

// POST to an endpoint with the CSRF token added. Returns true if it worked.
async function postAction(url, data) {
  const res = await fetch(url, {
    method: 'POST',
    body: new URLSearchParams({ ...data, csrf_token: csrfToken }),
  });
  return res.ok;
}

async function openGame(id) {
  const res = await fetch('game-details.php?id=' + encodeURIComponent(id));
  if (!res.ok) {
    alert('Could not load that game.');
    return;
  }
  const game = await res.json();
  currentGameId = game.game_id;

  const cover = document.getElementById('dialog-cover');
  if (game.cover_image) {
    cover.src = '../images/covers/' + game.cover_image;
    cover.alt = game.game_name + ' cover';
    cover.hidden = false;
  } else {
    cover.hidden = true;
  }

  document.getElementById('dialog-title').textContent = game.game_name;
  document.getElementById('dialog-platform').textContent = game.platform_name;
  document.getElementById('dialog-description').textContent = game.game_description;

  const tagList = document.getElementById('dialog-tags');
  tagList.innerHTML = '';
  for (const name of game.tags) {
    const li = document.createElement('li');
    li.textContent = name;
    tagList.appendChild(li);
  }

  // Let the page fill in its own controls (status, buttons, ...).
  dialog.dispatchEvent(new CustomEvent('gameloaded', { detail: game }));

  dialog.showModal();
}

document.addEventListener('click', (e) => {
  if (e.target.closest('.dialog-close')) {
    dialog.close();
    return;
  }
  const card = e.target.closest('[data-game-id]');
  if (card) {
    openGame(card.dataset.gameId);
  }
});