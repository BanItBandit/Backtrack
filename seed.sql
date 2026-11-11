-- =========================================================
-- Backtrack seed data (run AFTER schema.sql)
-- Contents: test user, platforms, tags, games, game-tag links,
--           and a sample library + wishlist for the test user.
-- Run once on an empty database. To start over, drop the backtrack
-- database and import schema.sql again.
-- Ids are written out explicitly so every teammate gets the same ids.
-- =========================================================

SET NAMES utf8mb4;
USE backtrack;


-- ---------------------------------------------------------
-- Test user (id 1). The stub login uses this id.
-- INSERT IGNORE: harmless if the row was already added by hand.
-- ---------------------------------------------------------
INSERT IGNORE INTO Users (user_id, username, display_name, email, password_hash, is_admin)
VALUES (1, 'testuser', 'Test User', 'test@example.com', 'not-a-real-hash', TRUE);


-- ---------------------------------------------------------
-- Platforms
-- ---------------------------------------------------------
INSERT INTO Platforms (platform_id, platform_name) VALUES
  (1, 'NES'),
  (2, 'SNES'),
  (3, 'Nintendo 64'),
  (4, 'GameCube'),
  (5, 'Wii'),
  (6, 'Wii U'),
  (7, 'Nintendo Switch'),
  (8, 'Nintendo Switch 2'),
  (9, 'Game Boy'),
  (10, 'Game Boy Color'),
  (11, 'Game Boy Advance'),
  (12, 'Nintendo DS'),
  (13, 'Nintendo DSi'),
  (14, 'Nintendo 3DS'),
  (15, 'PlayStation'),
  (16, 'PlayStation 2'),
  (17, 'PlayStation 3'),
  (18, 'PlayStation 4'),
  (19, 'PlayStation 5'),
  (20, 'PSP'),
  (21, 'PlayStation Vita'),
  (22, 'Xbox'),
  (23, 'Xbox 360'),
  (24, 'Xbox One'),
  (25, 'Xbox Series X|S'),
  (26, 'PC'),
  (27, 'Arcade'),
  (28, 'Mobile'),
  (29, 'Genesis'),
  (30, 'Saturn'),
  (31, 'Dreamcast'),
  (32, 'Game Gear'),
  (33, 'Atari 2600'),
  (34, 'Atari 7800'),
  (35, 'Atari Jaguar');

-- ---------------------------------------------------------
-- Tags (grouped by category)
-- ---------------------------------------------------------
INSERT INTO Tags (tag_id, tag_name, category) VALUES
  (1, 'Action', 'Genre'),
  (2, 'Adventure', 'Genre'),
  (3, 'RPG', 'Genre'),
  (4, 'Platformer', 'Genre'),
  (5, 'Shooter', 'Genre'),
  (6, 'Fighting', 'Genre'),
  (7, 'Racing', 'Genre'),
  (8, 'Sports', 'Genre'),
  (9, 'Strategy', 'Genre'),
  (10, 'Simulation', 'Genre'),
  (11, 'Puzzle', 'Genre'),
  (12, 'Horror', 'Genre'),
  (13, 'Survival', 'Genre'),
  (14, 'Rhythm', 'Genre'),
  (15, 'Party', 'Genre'),
  (16, 'Visual Novel', 'Genre'),
  (17, 'Co-op', 'Play Style'),
  (18, 'Competitive', 'Play Style'),
  (19, 'Asymmetric Multiplayer', 'Play Style'),
  (20, 'Alternating Play', 'Play Style'),
  (21, 'Supplementary Multiplayer', 'Play Style'),
  (22, 'Relaxing', 'Mood'),
  (23, 'Cozy', 'Mood'),
  (24, 'Atmospheric', 'Mood'),
  (25, 'Tense', 'Mood'),
  (26, 'Dark', 'Mood'),
  (27, 'Whimsical', 'Mood'),
  (28, 'Comedic', 'Mood'),
  (29, 'Emotional', 'Mood'),
  (30, 'Mysterious', 'Mood'),
  (31, 'Melancholic', 'Mood'),
  (32, 'Fantasy', 'Theme'),
  (33, 'Sci-fi', 'Theme'),
  (34, 'Historical', 'Theme'),
  (35, 'Modern', 'Theme'),
  (36, 'Post-apocalyptic', 'Theme'),
  (37, 'Supernatural', 'Theme'),
  (38, 'Western', 'Theme'),
  (39, 'Mythological', 'Theme'),
  (40, 'Story-driven', 'Narrative'),
  (41, 'Choice-driven', 'Narrative'),
  (42, 'Branching Narrative', 'Narrative'),
  (43, 'Environmental Storytelling', 'Narrative'),
  (44, 'Lore-rich', 'Narrative');

-- ---------------------------------------------------------
-- Games. Player counts: NULL = mode not supported.
-- cover_image NULL = no cover yet (the UI has to handle this).
-- ---------------------------------------------------------
INSERT INTO Games (game_id, game_name, platform_id, game_description, cover_image,
                   number_players_local_min, number_players_local_max,
                   number_players_online_min, number_players_online_max, is_active) VALUES
  (1, 'Mario Kart 8 Deluxe', 7, 'Kart racing with anti-gravity tracks and a big Nintendo character roster.', 'mariokart.jpeg', 1, 4, 1, 12, TRUE),  -- Nintendo Switch
  (2, 'Rocket League', 26, 'Soccer played with rocket-powered cars.', 'rocket.jpeg', 1, 4, 1, 8, TRUE),  -- PC
  (3, 'Sonic Mania', 7, 'A classic-style 2D Sonic platformer with remixed zones.', 'sonic.jpeg', 1, 2, NULL, NULL, TRUE),  -- Nintendo Switch
  (4, 'Splatoon 2', 7, 'Team-based ink shooter with online turf wars, a campaign, and co-op Salmon Run.', 'splatoon.jpeg', 1, 8, 1, 8, TRUE),  -- Nintendo Switch
  (5, 'Stardew Valley', 26, 'Restore a run-down farm, mine, fish, and befriend the townspeople.', 'stardew.jpeg', 1, 4, 1, 4, TRUE),  -- PC
  (6, 'Super Mario Odyssey', 7, '3D platformer where Mario and Cappy travel across kingdoms collecting Power Moons.', 'mario.jpeg', 1, 2, NULL, NULL, TRUE),  -- Nintendo Switch
  (7, 'The Legend of Zelda: Breath of the Wild', 7, 'Open-world adventure across a ruined Hyrule.', 'zelda.jpeg', NULL, NULL, NULL, NULL, TRUE),  -- Nintendo Switch
  (8, 'Bayonetta', 7, 'Fast, stylish action starring a witch who fights angels.', 'bayonetta.jpeg', NULL, NULL, NULL, NULL, TRUE),  -- Nintendo Switch
  (9, 'Minecraft', 26, 'Sandbox game about building, exploring, and surviving in a blocky world.', 'minecraft.jpeg', NULL, NULL, 1, 8, TRUE),  -- PC
  (10, 'Undertale', 26, 'A quirky RPG where every fight can be won or avoided without violence.', 'undertale.jpeg', NULL, NULL, NULL, NULL, TRUE),  -- PC
  (11, 'Mega Man 11', 7, 'Classic Mega Man platforming with a new gear system.', 'megaman.jpeg', NULL, NULL, NULL, NULL, TRUE),  -- Nintendo Switch
  (12, 'Super Smash Bros. Ultimate', 7, 'Platform fighter featuring characters from across gaming history.', 'smash.jpeg', 1, 8, 1, 8, TRUE),  -- Nintendo Switch
  (13, 'Pokémon: Let''s Go, Pikachu!', 7, 'A streamlined Kanto adventure with a second player who can join in co-op.', 'pokemon.jpeg', 1, 2, NULL, NULL, TRUE),  -- Nintendo Switch
  (14, 'Final Fantasy VII', 26, 'A classic RPG about a mercenary joining a resistance group in a sprawling sci-fi world.', 'finalfantasy.jpeg', NULL, NULL, NULL, NULL, TRUE),  -- PC
  (15, 'Fire Emblem: Three Houses', 7, 'Tactical RPG set at a military academy where you choose which house to lead.', 'fireemblem.jpeg', NULL, NULL, NULL, NULL, TRUE),  -- Nintendo Switch
  (16, 'Untitled Goose Game', 26, 'Puzzle game where you play a troublemaking goose in a quiet village.', 'goosegame.jpeg', 1, 2, NULL, NULL, TRUE),  -- PC
  (17, 'Animal Crossing: New Horizons', 7, 'Build a life and a community on a deserted island at a relaxed pace.', 'animalcrossing.jpeg', 1, 4, 1, 8, TRUE),  -- Nintendo Switch
  (18, 'Xenoblade Chronicles: Definitive Edition', 7, 'Large-scale RPG set on the bodies of two giant, frozen titans.', 'xenoblade.jpeg', NULL, NULL, NULL, NULL, TRUE),  -- Nintendo Switch
  (19, 'BioShock Infinite: The Complete Edition', 26, 'First-person shooter set in the floating city of Columbia.', 'bioshock.jpeg', NULL, NULL, NULL, NULL, TRUE),  -- PC
  (20, 'Metroid Dread', 7, 'Samus is hunted by robotic EMMI on a hostile alien planet.', 'metroid.jpeg', NULL, NULL, NULL, NULL, TRUE),  -- Nintendo Switch
  (21, 'Mario Party Superstars', 7, 'Board game party with minigames, remade from classic Mario Party boards.', 'marioparty.jpeg', 1, 4, 1, 4, TRUE),  -- Nintendo Switch
  (22, 'Pac-Man Museum+', 7, 'A collection of Pac-Man arcade games and spin-offs.', 'pacman.jpeg', 1, 2, NULL, NULL, TRUE),  -- Nintendo Switch
  (23, 'Persona 5 Royal', 18, 'Teenage phantom thieves change hearts while balancing school life.', 'persona5.jpeg', NULL, NULL, NULL, NULL, TRUE),  -- PlayStation 4
  (24, 'DOOM', 26, 'Fast first-person shooter about slaughtering demons on Mars.', 'doom.jpeg', NULL, NULL, 1, 12, TRUE),  -- PC
  (25, 'DOOM', 7, 'Fast first-person shooter about slaughtering demons on Mars.', 'doom.jpeg', NULL, NULL, 1, 12, TRUE),  -- Nintendo Switch
  (26, 'Minecraft', 7, 'Sandbox game about building, exploring, and surviving in a blocky world.', 'minecraft.jpeg', 1, 4, 1, 8, TRUE),  -- Nintendo Switch
  (27, 'Stardew Valley', 7, 'Restore a run-down farm, mine, fish, and befriend the townspeople.', 'stardew.jpeg', 1, 4, 1, 4, TRUE),  -- Nintendo Switch
  (28, 'Rocket League', 7, 'Soccer played with rocket-powered cars.', 'rocket.jpeg', 1, 4, 1, 8, TRUE),  -- Nintendo Switch
  (29, 'Undertale', 7, 'A quirky RPG where every fight can be won or avoided without violence.', 'undertale.jpeg', NULL, NULL, NULL, NULL, TRUE),  -- Nintendo Switch
  (30, 'Persona 5 Royal', 19, 'Teenage phantom thieves change hearts while balancing school life.', 'persona5.jpeg', NULL, NULL, NULL, NULL, TRUE),  -- PlayStation 5
  (31, 'Super Mario Bros.', 1, 'The original side-scrolling Mario platformer.', NULL, 1, 2, NULL, NULL, TRUE),  -- NES
  (32, 'Super Metroid', 2, 'Samus explores the planet Zebes in a landmark side-scrolling adventure.', NULL, NULL, NULL, NULL, NULL, TRUE),  -- SNES
  (33, 'The Legend of Zelda: Ocarina of Time', 3, 'Link travels through time to stop Ganondorf.', NULL, NULL, NULL, NULL, NULL, TRUE),  -- Nintendo 64
  (34, 'Metroid Prime', 4, 'Samus explores Tallon IV in a first-person adventure.', NULL, NULL, NULL, NULL, NULL, TRUE),  -- GameCube
  (35, 'Wii Sports', 5, 'Motion-controlled tennis, bowling, golf, baseball, and boxing.', NULL, 1, 4, NULL, NULL, TRUE),  -- Wii
  (36, 'Super Mario 3D World', 6, 'Four-player 3D platforming with cat suits and clear pipes.', NULL, 1, 4, NULL, NULL, TRUE),  -- Wii U
  (37, 'Mario Kart World', 8, 'Open-world kart racing with a large online field.', NULL, 1, 4, 1, 24, TRUE),  -- Nintendo Switch 2
  (38, 'Tetris', 9, 'The block-stacking puzzle classic, with a two-player link mode.', NULL, 1, 2, NULL, NULL, TRUE),  -- Game Boy
  (39, 'Pokémon Gold', 10, 'Return to Johto and take on the Pokémon League.', NULL, 1, 2, NULL, NULL, TRUE),  -- Game Boy Color
  (40, 'Advance Wars', 11, 'Turn-based military strategy with a lighthearted tone.', NULL, 1, 4, NULL, NULL, TRUE),  -- Game Boy Advance
  (41, 'Professor Layton and the Curious Village', 12, 'Puzzle adventure about a village mystery.', NULL, NULL, NULL, NULL, NULL, TRUE),  -- Nintendo DS
  (42, 'Phoenix Wright: Ace Attorney', 12, 'Defend clients in court by finding contradictions in testimony.', NULL, NULL, NULL, NULL, NULL, TRUE),  -- Nintendo DS
  (43, 'Shantae: Risky''s Revenge', 13, 'A half-genie hero battles pirates in a platforming adventure.', NULL, NULL, NULL, NULL, NULL, TRUE),  -- Nintendo DSi
  (44, 'Fire Emblem Awakening', 14, 'Tactical RPG with relationships and permanent character loss.', NULL, NULL, NULL, NULL, NULL, TRUE),  -- Nintendo 3DS
  (45, 'Castlevania: Symphony of the Night', 15, 'Explore Dracula''s castle in a gothic action RPG.', NULL, NULL, NULL, NULL, NULL, TRUE),  -- PlayStation
  (46, 'Shadow of the Colossus', 16, 'A lone wanderer hunts giant colossi in a quiet, empty land.', NULL, NULL, NULL, NULL, NULL, TRUE),  -- PlayStation 2
  (47, 'God of War', 16, 'Kratos fights the gods of Greek mythology in a brutal action series.', NULL, NULL, NULL, NULL, NULL, TRUE),  -- PlayStation 2
  (48, 'The Last of Us', 17, 'Two survivors cross a collapsed America.', NULL, NULL, NULL, 1, 8, TRUE),  -- PlayStation 3
  (49, 'Red Dead Redemption', 17, 'An outlaw hunts his old gang across the dying American frontier.', NULL, NULL, NULL, 1, 16, TRUE),  -- PlayStation 3
  (50, 'Bloodborne', 18, 'Gothic action RPG set in a cursed city.', NULL, NULL, NULL, 1, 2, TRUE),  -- PlayStation 4
  (51, 'Astro Bot', 19, 'Colorful 3D platformer that celebrates PlayStation history.', NULL, NULL, NULL, NULL, NULL, TRUE),  -- PlayStation 5
  (52, 'Patapon', 20, 'Lead a tribe into battle by drumming out rhythm commands.', NULL, NULL, NULL, NULL, NULL, TRUE),  -- PSP
  (53, 'Persona 4 Golden', 21, 'Solve murders in a rural town by entering a world inside TVs.', NULL, NULL, NULL, NULL, NULL, TRUE),  -- PlayStation Vita
  (54, 'Halo: Combat Evolved', 22, 'Master Chief fights the Covenant on a mysterious ring world.', NULL, 1, 2, NULL, NULL, TRUE),  -- Xbox
  (55, 'Gears of War', 23, 'Cover-based third-person shooter with a gritty, militaristic tone.', NULL, 1, 2, 1, 8, TRUE),  -- Xbox 360
  (56, 'Forza Horizon 4', 24, 'Open-world racing across a changing British countryside.', NULL, NULL, NULL, 1, 72, TRUE),  -- Xbox One
  (57, 'Forza Horizon 5', 25, 'Open-world racing set in Mexico.', NULL, NULL, NULL, 1, 72, TRUE),  -- Xbox Series X|S
  (58, 'Portal 2', 26, 'Puzzle game built around portals, with a co-op campaign.', NULL, 1, 2, 1, 2, TRUE),  -- PC
  (59, 'Disco Elysium', 26, 'A detective RPG driven by dialogue and skill checks.', NULL, NULL, NULL, NULL, NULL, TRUE),  -- PC
  (60, 'Dead by Daylight', 26, 'Four survivors try to escape one killer in a 4v1 horror game.', NULL, NULL, NULL, 1, 5, TRUE),  -- PC
  (61, 'Street Fighter II', 27, 'The arcade fighting game that set the template for the genre.', NULL, 1, 2, NULL, NULL, TRUE),  -- Arcade
  (62, 'Monument Valley', 28, 'Guide a silent princess through impossible architecture.', NULL, NULL, NULL, NULL, NULL, TRUE),  -- Mobile
  (63, 'Sonic the Hedgehog 2', 29, 'Sonic and Tails race through Dr. Robotnik''s zones.', NULL, 1, 2, NULL, NULL, TRUE),  -- Genesis
  (64, 'Streets of Rage 2', 29, 'Side-scrolling brawler with a famous soundtrack.', NULL, 1, 2, NULL, NULL, TRUE),  -- Genesis
  (65, 'NiGHTS into Dreams', 30, 'Fly through surreal dreamscapes in an arcade-style adventure.', NULL, NULL, NULL, NULL, NULL, TRUE),  -- Saturn
  (66, 'Jet Set Radio', 31, 'Rollerblading graffiti artists take on a rival-ridden Tokyo.', NULL, NULL, NULL, NULL, NULL, TRUE),  -- Dreamcast
  (67, 'Sonic the Hedgehog', 32, 'Sonic''s first handheld adventure.', NULL, NULL, NULL, NULL, NULL, TRUE),  -- Game Gear
  (68, 'Pitfall!', 33, 'Swing across jungle hazards in a treasure hunt.', NULL, 1, 2, NULL, NULL, TRUE),  -- Atari 2600
  (69, 'Ms. Pac-Man', 34, 'Maze chase game with new mazes and moving fruit.', NULL, 1, 2, NULL, NULL, TRUE),  -- Atari 7800
  (70, 'Tempest 2000', 35, 'Fast tube-shooter with a techno soundtrack.', NULL, NULL, NULL, NULL, NULL, TRUE);  -- Atari Jaguar

-- ---------------------------------------------------------
-- Game-tag links
-- ---------------------------------------------------------
INSERT INTO GameTagAssignments (game_id, tag_id) VALUES
  (1, 7), (1, 18), (1, 15), (1, 27),  -- Mario Kart 8 Deluxe (Nintendo Switch)
  (2, 8), (2, 7), (2, 18),  -- Rocket League (PC)
  (3, 4), (3, 1), (3, 27), (3, 21),  -- Sonic Mania (Nintendo Switch)
  (4, 5), (4, 18), (4, 17), (4, 27),  -- Splatoon 2 (Nintendo Switch)
  (5, 10), (5, 3), (5, 22), (5, 23), (5, 17),  -- Stardew Valley (PC)
  (6, 4), (6, 2), (6, 27),  -- Super Mario Odyssey (Nintendo Switch)
  (7, 2), (7, 1), (7, 32), (7, 24), (7, 43), (7, 44),  -- The Legend of Zelda: Breath of the Wild (Nintendo Switch)
  (8, 1), (8, 37), (8, 28),  -- Bayonetta (Nintendo Switch)
  (9, 13), (9, 2), (9, 10), (9, 22), (9, 17),  -- Minecraft (PC)
  (10, 3), (10, 28), (10, 29), (10, 41), (10, 42),  -- Undertale (PC)
  (11, 4), (11, 1), (11, 33),  -- Mega Man 11 (Nintendo Switch)
  (12, 6), (12, 18), (12, 15), (12, 27),  -- Super Smash Bros. Ultimate (Nintendo Switch)
  (13, 3), (13, 2), (13, 27), (13, 17), (13, 32),  -- Pokémon: Let's Go, Pikachu! (Nintendo Switch)
  (14, 3), (14, 33), (14, 40), (14, 29),  -- Final Fantasy VII (PC)
  (15, 9), (15, 3), (15, 32), (15, 40), (15, 41), (15, 42),  -- Fire Emblem: Three Houses (Nintendo Switch)
  (16, 11), (16, 28), (16, 27), (16, 17), (16, 35),  -- Untitled Goose Game (PC)
  (17, 10), (17, 23), (17, 22), (17, 27), (17, 17),  -- Animal Crossing: New Horizons (Nintendo Switch)
  (18, 3), (18, 32), (18, 33), (18, 40), (18, 29),  -- Xenoblade Chronicles: Definitive Edition (Nintendo Switch)
  (19, 5), (19, 33), (19, 24), (19, 30), (19, 40),  -- BioShock Infinite: The Complete Edition (PC)
  (20, 1), (20, 2), (20, 33), (20, 25), (20, 24),  -- Metroid Dread (Nintendo Switch)
  (21, 15), (21, 18), (21, 27),  -- Mario Party Superstars (Nintendo Switch)
  (22, 1), (22, 27),  -- Pac-Man Museum+ (Nintendo Switch)
  (23, 3), (23, 37), (23, 35), (23, 40), (23, 30),  -- Persona 5 Royal (PlayStation 4)
  (24, 5), (24, 1), (24, 33), (24, 37), (24, 18), (24, 21),  -- DOOM (PC)
  (25, 5), (25, 1), (25, 33), (25, 37), (25, 18), (25, 21),  -- DOOM (Nintendo Switch)
  (26, 13), (26, 2), (26, 10), (26, 22), (26, 17),  -- Minecraft (Nintendo Switch)
  (27, 10), (27, 3), (27, 22), (27, 23), (27, 17),  -- Stardew Valley (Nintendo Switch)
  (28, 8), (28, 7), (28, 18),  -- Rocket League (Nintendo Switch)
  (29, 3), (29, 28), (29, 29), (29, 41), (29, 42),  -- Undertale (Nintendo Switch)
  (30, 3), (30, 37), (30, 35), (30, 40), (30, 30),  -- Persona 5 Royal (PlayStation 5)
  (31, 4), (31, 27), (31, 32), (31, 20),  -- Super Mario Bros. (NES)
  (32, 1), (32, 2), (32, 33), (32, 24), (32, 43),  -- Super Metroid (SNES)
  (33, 2), (33, 32), (33, 40), (33, 44),  -- The Legend of Zelda: Ocarina of Time (Nintendo 64)
  (34, 2), (34, 5), (34, 33), (34, 24), (34, 43),  -- Metroid Prime (GameCube)
  (35, 8), (35, 15), (35, 18),  -- Wii Sports (Wii)
  (36, 4), (36, 17), (36, 27),  -- Super Mario 3D World (Wii U)
  (37, 7), (37, 18), (37, 15), (37, 27),  -- Mario Kart World (Nintendo Switch 2)
  (38, 11), (38, 18),  -- Tetris (Game Boy)
  (39, 3), (39, 2), (39, 27), (39, 32),  -- Pokémon Gold (Game Boy Color)
  (40, 9), (40, 20),  -- Advance Wars (Game Boy Advance)
  (41, 11), (41, 2), (41, 30), (41, 40), (41, 27),  -- Professor Layton and the Curious Village (Nintendo DS)
  (42, 16), (42, 28), (42, 40), (42, 30), (42, 35),  -- Phoenix Wright: Ace Attorney (Nintendo DS)
  (43, 4), (43, 1), (43, 32), (43, 28),  -- Shantae: Risky's Revenge (Nintendo DSi)
  (44, 9), (44, 3), (44, 32), (44, 40),  -- Fire Emblem Awakening (Nintendo 3DS)
  (45, 1), (45, 2), (45, 26), (45, 37), (45, 24),  -- Castlevania: Symphony of the Night (PlayStation)
  (46, 2), (46, 1), (46, 24), (46, 31), (46, 30), (46, 29),  -- Shadow of the Colossus (PlayStation 2)
  (47, 1), (47, 39), (47, 26), (47, 40),  -- God of War (PlayStation 2)
  (48, 1), (48, 13), (48, 36), (48, 29), (48, 40), (48, 25), (48, 21),  -- The Last of Us (PlayStation 3)
  (49, 1), (49, 2), (49, 38), (49, 34), (49, 40), (49, 21),  -- Red Dead Redemption (PlayStation 3)
  (50, 1), (50, 3), (50, 12), (50, 26), (50, 24), (50, 44), (50, 37),  -- Bloodborne (PlayStation 4)
  (51, 4), (51, 27),  -- Astro Bot (PlayStation 5)
  (52, 14), (52, 9), (52, 27), (52, 32),  -- Patapon (PSP)
  (53, 3), (53, 37), (53, 35), (53, 40), (53, 30),  -- Persona 4 Golden (PlayStation Vita)
  (54, 5), (54, 33), (54, 17),  -- Halo: Combat Evolved (Xbox)
  (55, 5), (55, 1), (55, 33), (55, 17), (55, 26),  -- Gears of War (Xbox 360)
  (56, 7), (56, 35), (56, 22),  -- Forza Horizon 4 (Xbox One)
  (57, 7), (57, 35), (57, 22),  -- Forza Horizon 5 (Xbox Series X|S)
  (58, 11), (58, 33), (58, 28), (58, 17), (58, 40),  -- Portal 2 (PC)
  (59, 3), (59, 41), (59, 42), (59, 26), (59, 31), (59, 40),  -- Disco Elysium (PC)
  (60, 12), (60, 19), (60, 13), (60, 26), (60, 25), (60, 37),  -- Dead by Daylight (PC)
  (61, 6), (61, 18),  -- Street Fighter II (Arcade)
  (62, 11), (62, 22), (62, 24), (62, 30), (62, 43),  -- Monument Valley (Mobile)
  (63, 4), (63, 1), (63, 27), (63, 21),  -- Sonic the Hedgehog 2 (Genesis)
  (64, 1), (64, 17), (64, 35),  -- Streets of Rage 2 (Genesis)
  (65, 1), (65, 27), (65, 24), (65, 32),  -- NiGHTS into Dreams (Saturn)
  (66, 1), (66, 8), (66, 27), (66, 35),  -- Jet Set Radio (Dreamcast)
  (67, 4), (67, 1), (67, 27),  -- Sonic the Hedgehog (Game Gear)
  (68, 4), (68, 2), (68, 20),  -- Pitfall! (Atari 2600)
  (69, 1), (69, 27), (69, 20),  -- Ms. Pac-Man (Atari 7800)
  (70, 5), (70, 1), (70, 33);  -- Tempest 2000 (Atari Jaguar)

-- ---------------------------------------------------------
-- Test user's library (user 1)
-- ---------------------------------------------------------
INSERT INTO UserLibraryEntries (user_id, game_id, status) VALUES
  (1, 1, 'Playing'),  -- Mario Kart 8 Deluxe
  (1, 2, 'Playing'),  -- Rocket League
  (1, 3, 'Completed'),  -- Sonic Mania
  (1, 4, 'On Hold'),  -- Splatoon 2
  (1, 5, 'Playing'),  -- Stardew Valley
  (1, 6, 'Completed'),  -- Super Mario Odyssey
  (1, 7, 'On Hold'),  -- The Legend of Zelda: Breath of the Wild
  (1, 8, 'Backlog'),  -- Bayonetta
  (1, 9, 'On Hold'),  -- Minecraft
  (1, 10, 'Completed'),  -- Undertale
  (1, 11, 'Backlog'),  -- Mega Man 11
  (1, 12, 'Completed'),  -- Super Smash Bros. Ultimate
  (1, 13, 'Backlog'),  -- Pokémon: Let's Go, Pikachu!
  (1, 14, 'Backlog'),  -- Final Fantasy VII
  (1, 15, 'Playing'),  -- Fire Emblem: Three Houses
  (1, 16, 'Completed'),  -- Untitled Goose Game
  (1, 17, 'On Hold'),  -- Animal Crossing: New Horizons
  (1, 18, 'Backlog'),  -- Xenoblade Chronicles: Definitive Edition
  (1, 19, 'Completed'),  -- BioShock Infinite: The Complete Edition
  (1, 20, 'Backlog'),  -- Metroid Dread
  (1, 21, 'Backlog'),  -- Mario Party Superstars
  (1, 22, 'Backlog'),  -- Pac-Man Museum+
  (1, 23, 'Backlog'),  -- Persona 5 Royal
  (1, 24, 'Completed');  -- DOOM

-- ---------------------------------------------------------
-- Test user's wishlist (user 1)
-- ---------------------------------------------------------
INSERT INTO WishlistEntries (user_id, game_id) VALUES
  (1, 32),  -- Super Metroid
  (1, 33),  -- The Legend of Zelda: Ocarina of Time
  (1, 34),  -- Metroid Prime
  (1, 51),  -- Astro Bot
  (1, 37);  -- Mario Kart World
