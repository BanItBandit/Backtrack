const covers = [
  "mariokart.jpeg", "rocket.jpeg", "sonic.jpeg", "splatoon.jpeg",
  "stardew.jpeg", "mario.jpeg", "zelda.jpeg", "bayonetta.jpeg",
  "minecraft.jpeg", "undertale.jpeg", "megaman.jpeg", "smash.jpeg",
  "pokemon.jpeg", "finalfantasy.jpeg", "fireemblem.jpeg", "goosegame.jpeg",
  "animalcrossing.jpeg", "xenoblade.jpeg", "bioshock.jpeg", "metroid.jpeg",
  "marioparty.jpeg", "pacman.jpeg", "persona5.jpeg", "doom.jpeg"
];

for (let c = 0; c < 4; c++) {
  const column = document.createElement("div");
  column.className = "column";

  const track = document.createElement("div");
  track.className = "track";

  column.append(track);
  for (let copy = 0; copy < 2; copy++) {
    for (let i = 0; i < 10; i++) {
      const tile = document.createElement("div");
      tile.className = "tile";

      const img = document.createElement("img");
      img.src = "images/covers/" + covers[(i + c * 5) % covers.length];

      tile.append(img);
      track.append(tile);
    }
  }
  document.querySelector(".game-art").append(column);
}