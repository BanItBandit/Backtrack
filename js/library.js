const statusInputs = document.querySelectorAll('.status-control input');
let changed = false;
const removeButton = document.getElementById('remove-button');
const backToTopButton = document.getElementById('back-to-top');

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

// When a game loads, tick the radio that matches its status.
dialog.addEventListener('gameloaded', (e) => {
  for (const input of statusInputs) {
    input.checked = (input.value === e.detail.status);
  }
});

for (const input of statusInputs) {
  input.addEventListener('change', async () => {
    const ok = await postAction('library-update.php', {
      game_id: currentGameId,
      status: input.value,
    });
    if (!ok) {
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
  const ok = await postAction('library-remove.php', { game_id: currentGameId });
  if (!ok) {
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