import React, { useState, useEffect } from 'react';
import { View, Text, TouchableOpacity, Alert } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { Play, Pause, Star, SkipForward } from 'lucide-react-native';
import Animated, { 
  useAnimatedStyle, 
  useSharedValue, 
  withTiming,
  withRepeat,
  withSequence,
} from 'react-native-reanimated';
import { LinearGradient } from 'expo-linear-gradient';
import { Audio } from 'expo-av';
import { supabase } from '@/lib/supabase';
import { trackEvent } from '@/lib/analytics';

interface Track {
  id: string;
  title: string;
  artist: string;
  audio_url: string;
  genre: string;
  spotify_streams: number;
  artwork_url?: string;
}

export default function DiscoverScreen() {
  const [currentTrack, setCurrentTrack] = useState<Track | null>(null);
  const [isPlaying, setIsPlaying] = useState(false);
  const [sound, setSound] = useState<Audio.Sound | null>(null);
  const [rating, setRating] = useState(0);
  const [showRating, setShowRating] = useState(false);
  const [trackRevealed, setTrackRevealed] = useState(false);
  const [position, setPosition] = useState(0);
  const [duration, setDuration] = useState(0);

  const pulseAnimation = useSharedValue(1);
  const progressAnimation = useSharedValue(0);

  useEffect(() => {
    loadNextTrack();
    return () => {
      if (sound) {
        sound.unloadAsync();
      }
    };
  }, []);

  useEffect(() => {
    if (isPlaying) {
      pulseAnimation.value = withRepeat(
        withSequence(
          withTiming(1.1, { duration: 800 }),
          withTiming(1, { duration: 800 })
        ),
        -1
      );
    } else {
      pulseAnimation.value = withTiming(1);
    }
  }, [isPlaying]);

  const pulseStyle = useAnimatedStyle(() => ({
    transform: [{ scale: pulseAnimation.value }],
  }));

  const progressStyle = useAnimatedStyle(() => ({
    width: `${(position / duration) * 100}%`,
  }));

  const loadNextTrack = async () => {
    try {
      const { data, error } = await supabase
        .from('tracks')
        .select('*')
        .lt('spotify_streams', 5000)
        .order('random()')
        .limit(1)
        .single();

      if (error) throw error;

      setCurrentTrack(data);
      setRating(0);
      setShowRating(false);
      setTrackRevealed(false);
      trackEvent('track_played', { track_id: data.id });
    } catch (error) {
      console.error('Error loading track:', error);
      Alert.alert('Error', 'Failed to load track');
    }
  };

  const playPauseAudio = async () => {
    try {
      if (sound) {
        const status = await sound.getStatusAsync();
        if (status.isLoaded) {
          if (isPlaying) {
            await sound.pauseAsync();
          } else {
            await sound.playAsync();
          }
        }
      } else if (currentTrack) {
        const { sound: newSound } = await Audio.Sound.createAsync(
          { uri: currentTrack.audio_url },
          { shouldPlay: true }
        );
        setSound(newSound);
        setIsPlaying(true);

        newSound.setOnPlaybackStatusUpdate((status) => {
          if (status.isLoaded) {
            setPosition(status.positionMillis || 0);
            setDuration(status.durationMillis || 0);
            setIsPlaying(status.isPlaying || false);
          }
        });
      }
    } catch (error) {
      console.error('Error playing audio:', error);
    }
  };

  const skipTrack = async () => {
    if (sound) {
      await sound.unloadAsync();
      setSound(null);
    }
    setIsPlaying(false);
    trackEvent('track_skipped', { track_id: currentTrack?.id });
    loadNextTrack();
  };

  const submitRating = async (stars: number) => {
    if (!currentTrack) return;

    setRating(stars);
    
    try {
      const { error } = await supabase
        .from('user_ratings')
        .insert({
          track_id: currentTrack.id,
          rating: stars,
          user_id: 'demo-user', // Replace with actual user ID
        });

      if (error) throw error;

      trackEvent('track_rated', { 
        track_id: currentTrack.id, 
        rating_value: stars 
      });

      if (stars >= 4) {
        setTrackRevealed(true);
        trackEvent('track_revealed', { track_id: currentTrack.id });
      } else {
        trackEvent('track_dismissed', { track_id: currentTrack.id });
        setTimeout(() => {
          skipTrack();
        }, 2000);
      }
    } catch (error) {
      console.error('Error submitting rating:', error);
    }
  };

  return (
    <LinearGradient
      colors={['#1a1a1a', '#2a2a2a', '#1a1a1a']}
      className="flex-1"
    >
      <SafeAreaView className="flex-1 px-6">
        {/* Header */}
        <View className="items-center pt-8 pb-12">
          <Text className="text-white text-2xl font-satoshi-bold">unknown</Text>
          <Text className="text-gray-400 text-sm font-satoshi mt-2">
            Discover underground music
          </Text>
        </View>

        {/* Main Player Area */}
        <View className="flex-1 justify-center items-center">
          {!trackRevealed ? (
            <>
              {/* Mystery Track Visualization */}
              <Animated.View
                style={pulseStyle}
                className="w-64 h-64 rounded-full bg-gradient-to-br from-neon-green/20 to-neon-blue/20 items-center justify-center mb-8"
              >
                <View className="w-48 h-48 rounded-full bg-dark-200 items-center justify-center border border-neon-green/30">
                  <TouchableOpacity
                    onPress={playPauseAudio}
                    className="w-20 h-20 rounded-full bg-neon-green items-center justify-center"
                  >
                    {isPlaying ? (
                      <Pause size={32} color="#000" strokeWidth={2} />
                    ) : (
                      <Play size={32} color="#000" strokeWidth={2} />
                    )}
                  </TouchableOpacity>
                </View>
              </Animated.View>

              {/* Progress Bar */}
              <View className="w-full max-w-sm h-1 bg-dark-300 rounded-full mb-8">
                <Animated.View
                  style={progressStyle}
                  className="h-full bg-neon-green rounded-full"
                />
              </View>

              {/* Question Text */}
              <Text className="text-white text-xl font-satoshi-medium text-center mb-12">
                How does this track make you feel?
              </Text>

              {/* Rating Stars */}
              <View className="flex-row space-x-4 mb-8">
                {[1, 2, 3, 4, 5].map((star) => (
                  <TouchableOpacity
                    key={star}
                    onPress={() => submitRating(star)}
                    className="p-2"
                  >
                    <Star
                      size={32}
                      color={star <= rating ? '#00ff41' : '#5a5a5a'}
                      fill={star <= rating ? '#00ff41' : 'transparent'}
                      strokeWidth={2}
                    />
                  </TouchableOpacity>
                ))}
              </View>

              {/* Skip Button */}
              <TouchableOpacity
                onPress={skipTrack}
                className="flex-row items-center space-x-2 p-4"
              >
                <SkipForward size={20} color="#5a5a5a" strokeWidth={2} />
                <Text className="text-gray-400 font-satoshi">Skip</Text>
              </TouchableOpacity>
            </>
          ) : (
            /* Track Revealed */
            <View className="items-center">
              <View className="w-64 h-64 rounded-2xl bg-dark-200 mb-8 overflow-hidden">
                {currentTrack?.artwork_url ? (
                  <img
                    src={currentTrack.artwork_url}
                    className="w-full h-full object-cover"
                    alt="Track artwork"
                  />
                ) : (
                  <View className="w-full h-full bg-gradient-to-br from-neon-purple/30 to-neon-blue/30 items-center justify-center">
                    <Text className="text-4xl">🎵</Text>
                  </View>
                )}
              </View>

              <Text className="text-white text-2xl font-satoshi-bold text-center mb-2">
                {currentTrack?.title}
              </Text>
              <Text className="text-gray-300 text-lg font-satoshi text-center mb-4">
                {currentTrack?.artist}
              </Text>
              <Text className="text-neon-green text-sm font-satoshi-medium mb-8">
                {currentTrack?.genre}
              </Text>

              <TouchableOpacity
                onPress={loadNextTrack}
                className="bg-neon-green px-8 py-4 rounded-full"
              >
                <Text className="text-black font-satoshi-bold text-lg">
                  Discover Next
                </Text>
              </TouchableOpacity>
            </View>
          )}
        </View>
      </SafeAreaView>
    </LinearGradient>
  );
}