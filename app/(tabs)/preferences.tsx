import React, { useState, useEffect } from 'react';
import { View, Text, TouchableOpacity, ScrollView } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { LinearGradient } from 'expo-linear-gradient';
import { Check } from 'lucide-react-native';
import { supabase } from '@/lib/supabase';
import { trackEvent } from '@/lib/analytics';

const GENRES = [
  'Rock', 'Pop', 'Hip-Hop', 'Electronic', 'Jazz', 'Classical',
  'Folk', 'R&B', 'Country', 'Reggae', 'Blues', 'Punk',
  'Metal', 'Indie', 'Alternative', 'Funk', 'Soul', 'Gospel'
];

const MOODS = [
  'Energetic', 'Chill', 'Melancholic', 'Uplifting', 'Aggressive',
  'Romantic', 'Mysterious', 'Nostalgic', 'Experimental', 'Peaceful'
];

export default function PreferencesScreen() {
  const [selectedGenres, setSelectedGenres] = useState<string[]>([]);
  const [selectedMoods, setSelectedMoods] = useState<string[]>([]);
  const [minDuration, setMinDuration] = useState(60); // seconds
  const [maxDuration, setMaxDuration] = useState(300); // seconds
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    loadPreferences();
  }, []);

  const loadPreferences = async () => {
    try {
      const { data, error } = await supabase
        .from('user_preferences')
        .select('*')
        .eq('user_id', 'demo-user') // Replace with actual user ID
        .single();

      if (data) {
        setSelectedGenres(data.preferred_genres || []);
        setSelectedMoods(data.preferred_moods || []);
        setMinDuration(data.min_duration || 60);
        setMaxDuration(data.max_duration || 300);
      }
    } catch (error) {
      console.error('Error loading preferences:', error);
    } finally {
      setLoading(false);
    }
  };

  const savePreferences = async () => {
    try {
      const { error } = await supabase
        .from('user_preferences')
        .upsert({
          user_id: 'demo-user', // Replace with actual user ID
          preferred_genres: selectedGenres,
          preferred_moods: selectedMoods,
          min_duration: minDuration,
          max_duration: maxDuration,
        });

      if (error) throw error;

      trackEvent('preference_updated', {
        genres_count: selectedGenres.length,
        moods_count: selectedMoods.length,
        duration_range: `${minDuration}-${maxDuration}s`
      });

      // Show success feedback
    } catch (error) {
      console.error('Error saving preferences:', error);
    }
  };

  const toggleGenre = (genre: string) => {
    setSelectedGenres(prev => 
      prev.includes(genre) 
        ? prev.filter(g => g !== genre)
        : [...prev, genre]
    );
  };

  const toggleMood = (mood: string) => {
    setSelectedMoods(prev => 
      prev.includes(mood) 
        ? prev.filter(m => m !== mood)
        : [...prev, mood]
    );
  };

  if (loading) {
    return (
      <LinearGradient colors={['#1a1a1a', '#2a2a2a']} className="flex-1">
        <SafeAreaView className="flex-1 justify-center items-center">
          <Text className="text-white font-satoshi">Loading preferences...</Text>
        </SafeAreaView>
      </LinearGradient>
    );
  }

  return (
    <LinearGradient colors={['#1a1a1a', '#2a2a2a']} className="flex-1">
      <SafeAreaView className="flex-1">
        {/* Header */}
        <View className="px-6 pt-8 pb-6">
          <Text className="text-white text-2xl font-satoshi-bold mb-2">Preferences</Text>
          <Text className="text-gray-400 font-satoshi">
            Customize your discovery experience
          </Text>
        </View>

        <ScrollView className="flex-1 px-6" showsVerticalScrollIndicator={false}>
          {/* Genres Section */}
          <View className="mb-8">
            <Text className="text-white text-xl font-satoshi-bold mb-4">
              Which genres do you prefer?
            </Text>
            <Text className="text-gray-400 font-satoshi mb-6">
              Choose your favorite genres for more personalized music
            </Text>
            
            <View className="flex-row flex-wrap">
              {GENRES.map((genre) => (
                <TouchableOpacity
                  key={genre}
                  onPress={() => toggleGenre(genre)}
                  className={`mr-3 mb-3 px-4 py-3 rounded-2xl border-2 ${
                    selectedGenres.includes(genre)
                      ? 'bg-neon-green/10 border-neon-green'
                      : 'bg-dark-200 border-dark-300'
                  }`}
                >
                  <View className="flex-row items-center space-x-2">
                    <Text className={`font-satoshi-medium ${
                      selectedGenres.includes(genre) ? 'text-neon-green' : 'text-gray-300'
                    }`}>
                      {genre}
                    </Text>
                    {selectedGenres.includes(genre) && (
                      <Check size={16} color="#00ff41" strokeWidth={2} />
                    )}
                  </View>
                </TouchableOpacity>
              ))}
            </View>
          </View>

          {/* Moods Section */}
          <View className="mb-8">
            <Text className="text-white text-xl font-satoshi-bold mb-4">
              What moods do you enjoy?
            </Text>
            <Text className="text-gray-400 font-satoshi mb-6">
              Select moods that match your listening preferences
            </Text>
            
            <View className="flex-row flex-wrap">
              {MOODS.map((mood) => (
                <TouchableOpacity
                  key={mood}
                  onPress={() => toggleMood(mood)}
                  className={`mr-3 mb-3 px-4 py-3 rounded-2xl border-2 ${
                    selectedMoods.includes(mood)
                      ? 'bg-neon-blue/10 border-neon-blue'
                      : 'bg-dark-200 border-dark-300'
                  }`}
                >
                  <View className="flex-row items-center space-x-2">
                    <Text className={`font-satoshi-medium ${
                      selectedMoods.includes(mood) ? 'text-neon-blue' : 'text-gray-300'
                    }`}>
                      {mood}
                    </Text>
                    {selectedMoods.includes(mood) && (
                      <Check size={16} color="#0099ff" strokeWidth={2} />
                    )}
                  </View>
                </TouchableOpacity>
              ))}
            </View>
          </View>

          {/* Duration Section */}
          <View className="mb-8">
            <Text className="text-white text-xl font-satoshi-bold mb-4">
              Track Duration
            </Text>
            <Text className="text-gray-400 font-satoshi mb-6">
              Set your preferred track length range
            </Text>
            
            <View className="bg-dark-200 rounded-2xl p-6 border border-dark-300">
              <View className="flex-row justify-between items-center mb-4">
                <Text className="text-gray-300 font-satoshi">
                  {Math.floor(minDuration / 60)}:{(minDuration % 60).toString().padStart(2, '0')}
                </Text>
                <Text className="text-gray-300 font-satoshi">to</Text>
                <Text className="text-gray-300 font-satoshi">
                  {Math.floor(maxDuration / 60)}:{(maxDuration % 60).toString().padStart(2, '0')}
                </Text>
              </View>
              
              {/* Duration sliders would go here - simplified for demo */}
              <View className="flex-row space-x-4">
                <TouchableOpacity
                  onPress={() => setMinDuration(Math.max(30, minDuration - 30))}
                  className="bg-dark-300 px-4 py-2 rounded-xl"
                >
                  <Text className="text-gray-300 font-satoshi">-</Text>
                </TouchableOpacity>
                <TouchableOpacity
                  onPress={() => setMinDuration(minDuration + 30)}
                  className="bg-dark-300 px-4 py-2 rounded-xl"
                >
                  <Text className="text-gray-300 font-satoshi">+</Text>
                </TouchableOpacity>
              </View>
            </View>
          </View>

          {/* Save Button */}
          <TouchableOpacity
            onPress={savePreferences}
            className="bg-neon-green rounded-2xl py-4 mb-8"
          >
            <Text className="text-black text-lg font-satoshi-bold text-center">
              Save Preferences
            </Text>
          </TouchableOpacity>
        </ScrollView>
      </SafeAreaView>
    </LinearGradient>
  );
}