/*
  # Sample Underground Tracks for Unknown App
  
  This file seeds the database with sample underground tracks for testing and demo purposes.
  All tracks have <5000 Spotify streams to meet the app's criteria.
*/

INSERT INTO tracks (title, artist, audio_url, artwork_url, genre, mood, duration, spotify_streams, spotify_url) VALUES
-- Electronic/Experimental
('Digital Echoes', 'Pixel Dreams', 'https://example.com/audio/digital-echoes.mp3', 'https://images.pexels.com/photos/1763075/pexels-photo-1763075.jpeg', 'Electronic', 'Mysterious', 245, 1847, 'https://open.spotify.com/track/digital-echoes'),
('Neon Nights', 'Synthwave Collective', 'https://example.com/audio/neon-nights.mp3', 'https://images.pexels.com/photos/1190297/pexels-photo-1190297.jpeg', 'Electronic', 'Energetic', 198, 3421, 'https://open.spotify.com/track/neon-nights'),
('Binary Sunset', 'Code Runner', 'https://example.com/audio/binary-sunset.mp3', 'https://images.pexels.com/photos/1105666/pexels-photo-1105666.jpeg', 'Electronic', 'Melancholic', 267, 892, 'https://open.spotify.com/track/binary-sunset'),

-- Indie Rock/Alternative
('Velvet Underground Vibes', 'The Basement Tapes', 'https://example.com/audio/velvet-underground.mp3', 'https://images.pexels.com/photos/1047442/pexels-photo-1047442.jpeg', 'Indie', 'Nostalgic', 223, 2156, 'https://open.spotify.com/track/velvet-underground'),
('Garage Dreams', 'Static Noise', 'https://example.com/audio/garage-dreams.mp3', 'https://images.pexels.com/photos/1389429/pexels-photo-1389429.jpeg', 'Rock', 'Aggressive', 189, 4231, 'https://open.spotify.com/track/garage-dreams'),
('Coffee Shop Confessions', 'Whisper Lane', 'https://example.com/audio/coffee-shop.mp3', 'https://images.pexels.com/photos/302899/pexels-photo-302899.jpeg', 'Indie', 'Peaceful', 201, 1678, 'https://open.spotify.com/track/coffee-shop'),

-- Hip-Hop/R&B
('Underground Cipher', 'MC Wordsmith', 'https://example.com/audio/underground-cipher.mp3', 'https://images.pexels.com/photos/1749303/pexels-photo-1749303.jpeg', 'Hip-Hop', 'Energetic', 156, 3847, 'https://open.spotify.com/track/underground-cipher'),
('Velvet Soul', 'The Smooth Collective', 'https://example.com/audio/velvet-soul.mp3', 'https://images.pexels.com/photos/167636/pexels-photo-167636.jpeg', 'R&B', 'Romantic', 234, 2934, 'https://open.spotify.com/track/velvet-soul'),

-- Folk/Acoustic
('Mountain Whispers', 'Forest Path', 'https://example.com/audio/mountain-whispers.mp3', 'https://images.pexels.com/photos/1076758/pexels-photo-1076758.jpeg', 'Folk', 'Peaceful', 278, 1234, 'https://open.spotify.com/track/mountain-whispers'),
('Campfire Stories', 'The Wanderers', 'https://example.com/audio/campfire-stories.mp3', 'https://images.pexels.com/photos/1445161/pexels-photo-1445161.jpeg', 'Folk', 'Nostalgic', 196, 2587, 'https://open.spotify.com/track/campfire-stories'),

-- Jazz/Experimental
('Midnight Jazz Cafe', 'The Late Night Trio', 'https://example.com/audio/midnight-jazz.mp3', 'https://images.pexels.com/photos/1407322/pexels-photo-1407322.jpeg', 'Jazz', 'Chill', 312, 1923, 'https://open.spotify.com/track/midnight-jazz'),
('Saxophone Dreams', 'Blue Note Collective', 'https://example.com/audio/sax-dreams.mp3', 'https://images.pexels.com/photos/1644775/pexels-photo-1644775.jpeg', 'Jazz', 'Melancholic', 245, 3456, 'https://open.spotify.com/track/sax-dreams'),

-- Ambient/Experimental
('Ocean Depths', 'Deep Blue', 'https://example.com/audio/ocean-depths.mp3', 'https://images.pexels.com/photos/1001682/pexels-photo-1001682.jpeg', 'Ambient', 'Peaceful', 389, 567, 'https://open.spotify.com/track/ocean-depths'),
('City Rain', 'Urban Soundscape', 'https://example.com/audio/city-rain.mp3', 'https://images.pexels.com/photos/1107717/pexels-photo-1107717.jpeg', 'Ambient', 'Melancholic', 423, 1456, 'https://open.spotify.com/track/city-rain'),

-- Alternative/Experimental
('Frequency Shift', 'The Experimenters', 'https://example.com/audio/frequency-shift.mp3', 'https://images.pexels.com/photos/1190298/pexels-photo-1190298.jpeg', 'Alternative', 'Experimental', 267, 2178, 'https://open.spotify.com/track/frequency-shift'),
('Glass House', 'Fragile Sounds', 'https://example.com/audio/glass-house.mp3', 'https://images.pexels.com/photos/1261728/pexels-photo-1261728.jpeg', 'Alternative', 'Mysterious', 198, 3821, 'https://open.spotify.com/track/glass-house'),

-- Lo-Fi/Chill
('Study Session', 'Lo-Fi Collective', 'https://example.com/audio/study-session.mp3', 'https://images.pexels.com/photos/1181403/pexels-photo-1181403.jpeg', 'Lo-Fi', 'Chill', 156, 4567, 'https://open.spotify.com/track/study-session'),
('Rainy Day Vibes', 'Bedroom Producer', 'https://example.com/audio/rainy-day.mp3', 'https://images.pexels.com/photos/1529659/pexels-photo-1529659.jpeg', 'Lo-Fi', 'Peaceful', 143, 2847, 'https://open.spotify.com/track/rainy-day'),

-- Punk/Hardcore
('Basement Show', 'The Outcasts', 'https://example.com/audio/basement-show.mp3', 'https://images.pexels.com/photos/1190297/pexels-photo-1190297.jpeg', 'Punk', 'Aggressive', 127, 1847, 'https://open.spotify.com/track/basement-show'),
('Rebellion Rising', 'Street Voices', 'https://example.com/audio/rebellion.mp3', 'https://images.pexels.com/photos/1389429/pexels-photo-1389429.jpeg', 'Punk', 'Energetic', 134, 3294, 'https://open.spotify.com/track/rebellion'),

-- Psychedelic/Experimental
('Kaleidoscope Mind', 'Cosmic Travelers', 'https://example.com/audio/kaleidoscope.mp3', 'https://images.pexels.com/photos/1105666/pexels-photo-1105666.jpeg', 'Psychedelic', 'Experimental', 345, 1567, 'https://open.spotify.com/track/kaleidoscope');