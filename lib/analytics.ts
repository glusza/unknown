import PostHog from 'posthog-react-native';

// Initialize PostHog
PostHog.setup(process.env.EXPO_PUBLIC_POSTHOG_API_KEY!, {
  host: process.env.EXPO_PUBLIC_POSTHOG_HOST!,
});

// Track event helper
export const trackEvent = (eventName: string, properties?: Record<string, any>) => {
  PostHog.capture(eventName, properties);
};

// User identification
export const identifyUser = (userId: string, traits?: Record<string, any>) => {
  PostHog.identify(userId, traits);
};

// Set user properties
export const setUserProperties = (properties: Record<string, any>) => {
  PostHog.setPersonProperties(properties);
};

// Track screen views
export const trackScreen = (screenName: string, properties?: Record<string, any>) => {
  PostHog.screen(screenName, properties);
};

export default PostHog;