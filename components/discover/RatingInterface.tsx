import React, { useEffect, useState } from 'react';
import { View, StyleSheet, ScrollView } from 'react-native';
import Animated, {
  useAnimatedStyle,
  useSharedValue,
  withTiming,
  interpolate,
  Extrapolate,
  Extrapolation,
} from 'react-native-reanimated';
import { Heading } from '@/components/typography/Heading';
import { Text } from '@/components/typography/Text';
import { TextInput } from '@/components/inputs/TextInput';
import { Button } from '@/components/buttons/Button';
import { StarRating } from '@/components/rating/StarRating';
import { spacing, borderRadius } from '@/utils/spacing';
import { colors } from '@/utils/colors';

interface RatingInterfaceProps {
  rating: number;
  onStarPress: (stars: number) => void;
  showReviewInput: boolean;
  review: string;
  onReviewChange: (text: string) => void;
  onSubmitWithReview: () => void;
  isReviewFocused?: boolean;
  setIsReviewFocused?: (focused: boolean) => void;
  reviewInputRef?: React.RefObject<any>;
  onSkip: () => void;
}

export function RatingInterface({
  rating,
  onStarPress,
  showReviewInput,
  review,
  onReviewChange,
  onSubmitWithReview,
  isReviewFocused,
  setIsReviewFocused,
  reviewInputRef,
  onSkip,
}: RatingInterfaceProps) {
  // Animation values
  const containerOpacity = useSharedValue(0);
  const containerScale = useSharedValue(0.8);
  const reviewInputAnimation = useSharedValue(0);
  const reviewInputHeight = useSharedValue(0);

  React.useEffect(() => {
    // Animate container appearance
    containerOpacity.value = withTiming(1, { duration: 250 });
    containerScale.value = withTiming(1, { duration: 250 });
  }, []);

  React.useEffect(() => {
    if (showReviewInput) {
      reviewInputAnimation.value = withTiming(1, { duration: 250 });
      reviewInputHeight.value = withTiming(1, { duration: 250 });
    }
  }, [showReviewInput]);

  const containerStyle = useAnimatedStyle(() => ({
    opacity: containerOpacity.value,
    transform: [{ scale: containerScale.value }],
  }));

  const reviewInputStyle = useAnimatedStyle(() => ({
    opacity: reviewInputAnimation.value,
    transform: [
      {
        translateY: interpolate(
          reviewInputAnimation.value,
          [0, 1],
          [30, 0],
          Extrapolation.CLAMP,
        ),
      },
    ],
  }));

  const reviewInputContainerStyle = useAnimatedStyle(() => ({
    maxHeight: interpolate(
      reviewInputHeight.value,
      [0, 1],
      [0, 440],
      Extrapolation.CLAMP,
    ),
  }));

  return (
    <Animated.View style={[containerStyle, styles.container]}>
      <ScrollView
        contentContainerStyle={styles.scrollContainer}
        showsVerticalScrollIndicator={false}
        keyboardShouldPersistTaps="handled"
      >
        <Heading
          variant="h4"
          color="primary"
          align="center"
          style={styles.title}
        >
          How does this track make you feel?
        </Heading>

        {/* Star Rating */}
        <View style={styles.ratingContainer}>
          <StarRating
            rating={rating}
            onRatingChange={onStarPress}
            size="large"
            style={styles.starRating}
            readonly={!!showReviewInput}
          />
        </View>

        {/* Review Input for High Ratings */}
        {showReviewInput && (
          <Animated.View
            style={[reviewInputContainerStyle, styles.reviewInputContainer]}
          >
            <Animated.View style={[reviewInputStyle, styles.reviewInput]}>
              <Text variant="body" color="primary" style={styles.reviewLabel}>
                Share your thoughts (optional)
              </Text>
              <TextInput
                ref={reviewInputRef}
                placeholder="What did you love about this track?"
                value={review}
                onChangeText={onReviewChange}
                onFocus={() => setIsReviewFocused?.(true)}
                onBlur={() => setIsReviewFocused?.(false)}
                multiline
                numberOfLines={3}
                style={styles.textInput}
              />

              <Button
                variant="primary"
                size="large"
                onPress={onSubmitWithReview}
              >
                Submit Rating
              </Button>

              {showReviewInput && (
                <Button
                  variant="secondary"
                  size="medium"
                  onPress={onSkip}
                  style={styles.editRatingButton}
                >
                  <View style={styles.editRatingButtonContent}>
                    <Text variant="button">Discover something else</Text>
                    <Text variant="caption" style={styles.cancelTheReviewText}>
                      Cancel the review
                    </Text>
                  </View>
                </Button>
              )}
            </Animated.View>
          </Animated.View>
        )}
      </ScrollView>
    </Animated.View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    width: '100%',
  },
  scrollContainer: {
    flexGrow: 1,
    justifyContent: 'center',
    alignItems: 'center',
  },
  title: {
    fontSize: 18,
    marginBottom: spacing.lg,
  },
  ratingContainer: {
    alignItems: 'center',
    marginBottom: spacing.lg,
  },
  starRating: {
    justifyContent: 'space-between',
  },
  reviewInputContainer: {
    width: '100%',
    overflow: 'hidden',
  },
  reviewInput: {
    width: '100%',
    marginBottom: spacing.lg,
  },
  reviewLabel: {
    fontSize: 16,
    marginBottom: spacing.sm,
  },
  textInput: {
    marginBottom: spacing.sm,
  },
  editRatingButton: {
    width: '100%',
    marginTop: spacing.md,
  },
  editRatingButtonContent: {
    flexDirection: 'column',
    justifyContent: 'space-between',
    alignItems: 'center',
  },
  cancelTheReviewText: {
    marginTop: spacing.xs,
    color: colors.text.secondary,
  },
});
