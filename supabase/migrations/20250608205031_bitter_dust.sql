/*
  # Complete Database Schema for Unknown Music Discovery App

  1. New Tables
    - `tracks` - Store track metadata and streaming info
    - `user_ratings` - Store user ratings for tracks
    - `user_preferences` - Store user genre/mood preferences
    - `user_badges` - Track user achievements
    - `user_stats` - Store user statistics and streaks

  2. Security
    - Enable RLS on all tables
    - Add policies for authenticated users to manage their own data
    - Public read access for tracks table

  3. Sample Data
    - 20 underground tracks with <5K Spotify streams
    - Diverse genres and moods for testing
*/

-- Create tracks table
CREATE TABLE IF NOT EXISTS tracks (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  title text NOT NULL,
  artist text NOT NULL,
  audio_url text NOT NULL,
  artwork_url text,
  genre text NOT NULL,
  mood text NOT NULL,
  duration integer NOT NULL, -- in seconds
  spotify_streams integer DEFAULT 0,
  spotify_url text,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Create user_ratings table
CREATE TABLE IF NOT EXISTS user_ratings (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id text NOT NULL,
  track_id uuid NOT NULL REFERENCES tracks(id) ON DELETE CASCADE,
  rating integer NOT NULL CHECK (rating >= 1 AND rating <= 5),
  review_text text,
  created_at timestamptz DEFAULT now(),
  UNIQUE(user_id, track_id)
);

-- Create user_preferences table
CREATE TABLE IF NOT EXISTS user_preferences (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id text NOT NULL UNIQUE,
  preferred_genres text[] DEFAULT '{}',
  preferred_moods text[] DEFAULT '{}',
  min_duration integer DEFAULT 60,
  max_duration integer DEFAULT 300,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Create user_badges table
CREATE TABLE IF NOT EXISTS user_badges (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id text NOT NULL,
  badge_id text NOT NULL,
  unlocked_at timestamptz DEFAULT now(),
  UNIQUE(user_id, badge_id)
);

-- Create user_stats table
CREATE TABLE IF NOT EXISTS user_stats (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id text NOT NULL UNIQUE,
  total_tracks_rated integer DEFAULT 0,
  current_streak_days integer DEFAULT 0,
  longest_streak_days integer DEFAULT 0,
  total_points integer DEFAULT 0,
  last_activity_date date DEFAULT CURRENT_DATE,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Enable Row Level Security
ALTER TABLE tracks ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_ratings ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_preferences ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_badges ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_stats ENABLE ROW LEVEL SECURITY;

-- Create policies for tracks (public read access)
CREATE POLICY "Anyone can read tracks"
  ON tracks
  FOR SELECT
  TO public
  USING (true);

-- Create policies for user_ratings
CREATE POLICY "Users can read own ratings"
  ON user_ratings
  FOR SELECT
  TO authenticated
  USING (auth.uid()::text = user_id);

CREATE POLICY "Users can insert own ratings"
  ON user_ratings
  FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid()::text = user_id);

CREATE POLICY "Users can update own ratings"
  ON user_ratings
  FOR UPDATE
  TO authenticated
  USING (auth.uid()::text = user_id)
  WITH CHECK (auth.uid()::text = user_id);

-- Create policies for user_preferences
CREATE POLICY "Users can read own preferences"
  ON user_preferences
  FOR SELECT
  TO authenticated
  USING (auth.uid()::text = user_id);

CREATE POLICY "Users can insert own preferences"
  ON user_preferences
  FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid()::text = user_id);

CREATE POLICY "Users can update own preferences"
  ON user_preferences
  FOR UPDATE
  TO authenticated
  USING (auth.uid()::text = user_id)
  WITH CHECK (auth.uid()::text = user_id);

-- Create policies for user_badges
CREATE POLICY "Users can read own badges"
  ON user_badges
  FOR SELECT
  TO authenticated
  USING (auth.uid()::text = user_id);

CREATE POLICY "Users can insert own badges"
  ON user_badges
  FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid()::text = user_id);

-- Create policies for user_stats
CREATE POLICY "Users can read own stats"
  ON user_stats
  FOR SELECT
  TO authenticated
  USING (auth.uid()::text = user_id);

CREATE POLICY "Users can insert own stats"
  ON user_stats
  FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid()::text = user_id);

CREATE POLICY "Users can update own stats"
  ON user_stats
  FOR UPDATE
  TO authenticated
  USING (auth.uid()::text = user_id)
  WITH CHECK (auth.uid()::text = user_id);

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_tracks_genre ON tracks(genre);
CREATE INDEX IF NOT EXISTS idx_tracks_mood ON tracks(mood);
CREATE INDEX IF NOT EXISTS idx_tracks_streams ON tracks(spotify_streams);
CREATE INDEX IF NOT EXISTS idx_user_ratings_user_id ON user_ratings(user_id);
CREATE INDEX IF NOT EXISTS idx_user_ratings_track_id ON user_ratings(track_id);
CREATE INDEX IF NOT EXISTS idx_user_ratings_rating ON user_ratings(rating);

-- Insert sample tracks data
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