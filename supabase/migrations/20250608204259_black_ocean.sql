/*
  # Unknown App Database Schema

  1. New Tables
    - `tracks`
      - `id` (uuid, primary key)
      - `title` (text)
      - `artist` (text)
      - `audio_url` (text)
      - `artwork_url` (text, optional)
      - `genre` (text)
      - `mood` (text, optional)
      - `duration` (integer, seconds)
      - `spotify_streams` (integer)
      - `spotify_url` (text, optional)
      - `created_at` (timestamp)
    
    - `user_ratings`
      - `id` (uuid, primary key)
      - `user_id` (uuid, references auth.users)
      - `track_id` (uuid, references tracks)
      - `rating` (integer, 1-5)
      - `review_text` (text, optional)
      - `created_at` (timestamp)
    
    - `user_preferences`
      - `id` (uuid, primary key)
      - `user_id` (uuid, references auth.users)
      - `preferred_genres` (text array)
      - `preferred_moods` (text array)
      - `min_duration` (integer, seconds)
      - `max_duration` (integer, seconds)
      - `updated_at` (timestamp)
    
    - `user_badges`
      - `id` (uuid, primary key)
      - `user_id` (uuid, references auth.users)
      - `badge_id` (text)
      - `unlocked_at` (timestamp)
    
    - `user_stats`
      - `id` (uuid, primary key)
      - `user_id` (uuid, references auth.users)
      - `total_tracks_rated` (integer)
      - `current_streak_days` (integer)
      - `longest_streak_days` (integer)
      - `total_points` (integer)
      - `last_activity` (timestamp)
      - `updated_at` (timestamp)

  2. Security
    - Enable RLS on all tables
    - Add policies for authenticated users to manage their own data
    - Public read access for tracks table
*/

-- Create tracks table
CREATE TABLE IF NOT EXISTS tracks (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  title text NOT NULL,
  artist text NOT NULL,
  audio_url text NOT NULL,
  artwork_url text,
  genre text NOT NULL,
  mood text,
  duration integer NOT NULL DEFAULT 180,
  spotify_streams integer NOT NULL DEFAULT 0,
  spotify_url text,
  created_at timestamptz DEFAULT now()
);

-- Create user_ratings table
CREATE TABLE IF NOT EXISTS user_ratings (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL,
  track_id uuid NOT NULL REFERENCES tracks(id) ON DELETE CASCADE,
  rating integer NOT NULL CHECK (rating >= 1 AND rating <= 5),
  review_text text,
  created_at timestamptz DEFAULT now(),
  UNIQUE(user_id, track_id)
);

-- Create user_preferences table
CREATE TABLE IF NOT EXISTS user_preferences (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL UNIQUE,
  preferred_genres text[] DEFAULT '{}',
  preferred_moods text[] DEFAULT '{}',
  min_duration integer DEFAULT 60,
  max_duration integer DEFAULT 300,
  updated_at timestamptz DEFAULT now()
);

-- Create user_badges table
CREATE TABLE IF NOT EXISTS user_badges (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL,
  badge_id text NOT NULL,
  unlocked_at timestamptz DEFAULT now(),
  UNIQUE(user_id, badge_id)
);

-- Create user_stats table
CREATE TABLE IF NOT EXISTS user_stats (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL UNIQUE,
  total_tracks_rated integer DEFAULT 0,
  current_streak_days integer DEFAULT 0,
  longest_streak_days integer DEFAULT 0,
  total_points integer DEFAULT 0,
  last_activity timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Enable Row Level Security
ALTER TABLE tracks ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_ratings ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_preferences ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_badges ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_stats ENABLE ROW LEVEL SECURITY;

-- Create policies for tracks (public read)
CREATE POLICY "Tracks are publicly readable"
  ON tracks
  FOR SELECT
  TO anon, authenticated
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
CREATE POLICY "Users can manage own preferences"
  ON user_preferences
  FOR ALL
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
CREATE POLICY "Users can manage own stats"
  ON user_stats
  FOR ALL
  TO authenticated
  USING (auth.uid()::text = user_id)
  WITH CHECK (auth.uid()::text = user_id);

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_tracks_spotify_streams ON tracks(spotify_streams);
CREATE INDEX IF NOT EXISTS idx_tracks_genre ON tracks(genre);
CREATE INDEX IF NOT EXISTS idx_user_ratings_user_id ON user_ratings(user_id);
CREATE INDEX IF NOT EXISTS idx_user_ratings_track_id ON user_ratings(track_id);
CREATE INDEX IF NOT EXISTS idx_user_ratings_rating ON user_ratings(rating);
CREATE INDEX IF NOT EXISTS idx_user_ratings_created_at ON user_ratings(created_at);