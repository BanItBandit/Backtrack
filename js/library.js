const dialog = document.getElementById('game-dialog');

const statusInputs = document.querySelectorAll('.status-control input');
let currentGameId = null;
let changed = false;
const removeButton = document.getElementById('remove-button');
const backToTopButton = document.getElementById('back-to-top');
const csrfToken = document.querySelector('meta[name="csrf-token"]').content;

const scrollThreshold = 200;

window.addEventListener('scroll', () => {
  backToTopButton.classList.toggle('show', window.scrollY > scrollThreshold);
});

backToTopButton.addEventListener('click', () => {
  const reducedMotion = window.matchMedia('(prefers-reduced-motion: reduce)').matches;
  window.scrollTo({
    top: 0,
    behavior: reducedMotion ? 'auto' : 'smooth',
  });
});

async function openGame(id) {
  const res = await fetch('game-details.php?id=' + encodeURIComponent(id));
  if (!res.ok) {
    alert('Could not load that game.');
    return;
  }
  const game = await res.json();

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
  currentGameId = game.game_id;
  for (const input of statusInputs) {
    input.checked = (input.value === game.status);
  }

  const tagList = document.getElementById('dialog-tags');
  tagList.innerHTML = '';
  for (const name of game.tags) {
    const li = document.createElement('li');
    li.textContent = name;
    tagList.appendChild(li);
  }

  dialog.showModal();
}

document.addEventListener('click', (e) => {
  console.log('Clicked on: %o', e.target);
  if (e.target.closest('.dialog-close')) {
    dialog.close();
    return;
  }
  const card = e.target.closest('[data-game-id]');
  if (card) {
    openGame(card.dataset.gameId);
  }
});

for (const input of statusInputs) {
  input.addEventListener('change', async () => {
    const res = await fetch('library-update.php', {
      method: 'POST',
      body: new URLSearchParams({
        game_id: currentGameId,
        status: input.value,
        csrf_token: csrfToken,
      }),
    });
    if (!res.ok) {
      alert('Could not save that change.');
      return;
    }
    changed = true;
  });
}

// When the card closes, refresh the page so the grid, strip, and stats match.
dialog.addEventListener('close', () => {
  if (changed) {
    location.reload();
  }
});

removeButton.addEventListener('click', async () => {
  if (!confirm('Remove this game from your library?')) {
    return;
  }
  const res = await fetch('library-remove.php', {
    method: 'POST',
    body: new URLSearchParams({
      game_id: currentGameId,
      csrf_token: csrfToken,
    }),
  });
  if (!res.ok) {
    alert('Could not remove that game.');
    return;
  }
  location.reload();
});

const libraryForm = document.querySelector('.library-form');
const sortDir = document.getElementById('sort-dir');

// Changing the sort menu re-submits the form right away.
document.querySelector('.sort-dropdown').addEventListener('change', () => {
  libraryForm.requestSubmit();
});

// The arrow flips the hidden direction value, then submits.
document.getElementById('sort-by').addEventListener('click', () => {
  sortDir.value = sortDir.value === 'asc' ? 'desc' : 'asc';
  libraryForm.requestSubmit();
});

for (const box of document.querySelectorAll('.filter-group input')) {
  box.addEventListener('change', () => libraryForm.requestSubmit());
}