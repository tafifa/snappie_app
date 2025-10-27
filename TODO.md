# 📱 Snappie Mobile App - TODO List

> **Status**: 🚧 Development Phase  
> **Last Updated**: 2025-01-15  
> **Priority**: 🔴 Critical | 🟡 High | 🟢 Medium | ⚪ Low

---

## 🔴 CRITICAL - Core Features Implementation

### 1. Social Media Features
- [ ] **Like Post Functionality**
  - [ ] Implement like/unlike API integration
  - [ ] Add optimistic UI update
  - [ ] Handle offline like queue
  - [ ] Update like count in real-time
  - [ ] Location: `home_controller.dart`, `post_repository.dart`

- [ ] **Comment System**
  - [ ] Implement create comment API
  - [ ] Implement get comments API
  - [ ] Build comment UI with replies
  - [ ] Add comment validation
  - [ ] Implement delete comment (author only)
  - [ ] Location: `home_controller.dart`, `post_repository.dart`

- [ ] **Share Functionality**
  - [ ] Implement native share dialog
  - [ ] Add deep linking support
  - [ ] Create shareable content format
  - [ ] Track share analytics
  - [ ] Location: `home_controller.dart`

- [ ] **Follow/Unfollow System**
  - [ ] Implement follow/unfollow API
  - [ ] Update follower/following counts
  - [ ] Add follow status indicator
  - [ ] Handle mutual follow logic
  - [ ] Location: `profile_controller.dart`, `user_repository.dart`

### 2. Check-in & Location Features
- [ ] **GPS Validation for Check-in**
  - [ ] Implement location services integration
  - [ ] Validate GPS accuracy (< 50m)
  - [ ] Add distance check to place location
  - [ ] Handle location permissions gracefully
  - [ ] Show map preview before check-in
  - [ ] Location: `explore_controller.dart`, `checkin_repository.dart`

- [ ] **Nearby Places Filter**
  - [ ] Implement location-based place filtering
  - [ ] Calculate distance to places
  - [ ] Sort by nearest first
  - [ ] Add radius filter (1km, 5km, 10km)
  - [ ] Cache nearby places
  - [ ] Location: `explore_controller.dart`, `place_repository.dart`

- [ ] **Check-in History**
  - [ ] Implement check-in history API
  - [ ] Display check-in timeline
  - [ ] Add map view of check-ins
  - [ ] Filter by date/place
  - [ ] Show check-in statistics
  - [ ] Location: New controller for history

### 3. Profile Management
- [ ] **Edit Profile Functionality**
  - [ ] Implement update profile API
  - [ ] Build edit profile UI
  - [ ] Add image upload functionality
  - [ ] Implement validation for username/email uniqueness
  - [ ] Add profile preview before save
  - [ ] Location: `profile_controller.dart`, new `edit_profile_view.dart`

- [ ] **Settings Page**
  - [ ] Create dedicated settings view
  - [ ] Implement notification settings
  - [ ] Add privacy settings
  - [ ] Implement language selection
  - [ ] Add theme toggle (light/dark)
  - [ ] Location: New `settings_view.dart`

- [ ] **Achievement System**
  - [ ] Implement achievement display
  - [ ] Add achievement progress tracking
  - [ ] Create achievement detail page
  - [ ] Add achievement notification
  - [ ] Location: New `achievement_view.dart`

- [ ] **Activity History**
  - [ ] Implement activity timeline API
  - [ ] Display user activities (check-ins, reviews, posts)
  - [ ] Add filtering options
  - [ ] Implement pagination
  - [ ] Location: New `history_view.dart`

---

## 🟡 HIGH PRIORITY - Bug Fixes & Stability

### 1. Authentication Issues
- [ ] **Google Sign-in Reliability**
  - [ ] Remove timeout workaround
  - [ ] Implement proper retry logic
  - [ ] Add exponential backoff
  - [ ] Handle network errors gracefully
  - [ ] Add connection timeout detection
  - [ ] Location: `auth_service.dart`

- [ ] **Token Management**
  - [ ] Implement token refresh logic
  - [ ] Add secure storage for tokens (flutter_secure_storage)
  - [ ] Handle token expiration gracefully
  - [ ] Implement auto-logout on 401
  - [ ] Location: `auth_service.dart`, `dio_client.dart`

- [ ] **Race Condition Prevention**
  - [ ] Add loading guards to prevent duplicate requests
  - [ ] Implement request debouncing
  - [ ] Add request cancellation support
  - [ ] Location: All controllers

### 2. Memory Management
- [ ] **Controller Disposal**
  - [ ] Remove `isClosed = false` override in AuthController
  - [ ] Implement proper controller lifecycle
  - [ ] Add dispose methods for listeners
  - [ ] Fix memory leaks in controllers
  - [ ] Location: All controllers

- [ ] **Image Memory Optimization**
  - [ ] Implement image caching
  - [ ] Add image compression before upload
  - [ ] Use cached_network_image for network images
  - [ ] Implement image lazy loading
  - [ ] Location: Image widgets

### 3. Error Handling
- [ ] **Comprehensive Error Handling**
  - [ ] Add try-catch to all async operations
  - [ ] Implement error boundaries
  - [ ] Add user-friendly error messages
  - [ ] Create error recovery mechanisms
  - [ ] Location: All controllers and services

- [ ] **Network Error Recovery**
  - [ ] Implement retry logic with exponential backoff
  - [ ] Add offline queue for failed requests
  - [ ] Show connectivity status indicator
  - [ ] Implement request timeout handling
  - [ ] Location: Dio interceptors, repositories

---

## 🟢 MEDIUM PRIORITY - Performance & UX

### 1. Performance Optimization
- [ ] **API Optimization**
  - [ ] Implement pagination for all lists
  - [ ] Add request field selection (only fetch needed data)
  - [ ] Implement API response caching
  - [ ] Add request deduplication
  - [ ] Location: All repositories

- [ ] **Lazy Loading Implementation**
  - [ ] Implement infinite scroll for feeds
  - [ ] Add skeleton loaders
  - [ ] Implement progressive image loading
  - [ ] Add pagination indicators
  - [ ] Location: List views and controllers

- [ ] **Image Optimization**
  - [ ] Implement image resizing before upload
  - [ ] Add progressive JPEG loading
  - [ ] Optimize image caching strategy
  - [ ] Implement WebP support
  - [ ] Location: Image upload components

### 2. Offline Capabilities
- [ ] **Offline-First Approach**
  - [ ] Implement offline data queue
  - [ ] Add sync status indicator
  - [ ] Implement conflict resolution
  - [ ] Add offline notification
  - [ ] Location: Services and repositories

- [ ] **Cache Management**
  - [ ] Implement intelligent cache invalidation
  - [ ] Add cache expiration logic
  - [ ] Implement cache size limits
  - [ ] Add cache cleanup on app start
  - [ ] Location: Repositories, local datasources

### 3. User Experience
- [ ] **Loading States**
  - [ ] Add skeleton loaders everywhere
  - [ ] Implement shimmer effects
  - [ ] Add progressive loading
  - [ ] Improve empty state designs
  - [ ] Location: All views

- [ ] **Pull to Refresh**
  - [ ] Implement for all feed pages
  - [ ] Add refresh indicators
  - [ ] Handle refresh conflicts
  - [ ] Location: Feed views

- [ ] **Search Functionality**
  - [ ] Implement real-time search
  - [ ] Add search suggestions
  - [ ] Implement search history
  - [ ] Add search filters
  - [ ] Location: Search components

---

## ⚪ LOW PRIORITY - Polish & Nice to Have

### 1. UI/UX Enhancements
- [ ] **Dark Theme**
  - [ ] Implement dark mode
  - [ ] Add theme toggle in settings
  - [ ] Support system theme preference
  - [ ] Ensure all screens support dark mode
  - [ ] Location: `app_theme.dart`

- [ ] **Animations**
  - [ ] Add page transition animations
  - [ ] Implement micro-interactions
  - [ ] Add loading animations
  - [ ] Implement skeleton animations
  - [ ] Location: All views

- [ ] **Accessibility**
  - [ ] Add semantic labels
  - [ ] Implement screen reader support
  - [ ] Add high contrast mode
  - [ ] Implement text scaling
  - [ ] Location: All widgets

### 2. Additional Features
- [ ] **Notification System**
  - [ ] Implement push notifications
  - [ ] Add notification preferences
  - [ ] Create notification center
  - [ ] Add badge counts
  - [ ] Location: New notification service

- [ ] **Analytics**
  - [ ] Integrate Firebase Analytics
  - [ ] Track user engagement
  - [ ] Monitor app performance
  - [ ] Add crash reporting
  - [ ] Location: Analytics service

- [ ] **Sharing & Invitations**
  - [ ] Implement referral system
  - [ ] Add social sharing
  - [ ] Create deep links
  - [ ] Implement invite rewards
  - [ ] Location: Sharing service

### 3. Code Quality
- [ ] **Testing**
  - [ ] Write unit tests for services
  - [ ] Add widget tests for critical UI
  - [ ] Implement integration tests
  - [ ] Add test coverage reporting
  - [ ] Location: test/ directory

- [ ] **Documentation**
  - [ ] Add code documentation
  - [ ] Create API documentation
  - [ ] Write user guides
  - [ ] Document architecture decisions
  - [ ] Location: docs/ directory

- [ ] **Code Cleanup**
  - [ ] Remove testing routes from production
  - [ ] Clean up TODO comments
  - [ ] Remove dead code
  - [ ] Standardize code style
  - [ ] Location: All files

---

## 🔧 INFRASTRUCTURE & DEVOPS

### 1. CI/CD Pipeline
- [ ] **Build Automation**
  - [ ] Set up GitHub Actions
  - [ ] Implement automated testing
  - [ ] Add code quality checks
  - [ ] Implement automated deployment
  - [ ] Location: `.github/workflows/`

### 2. Monitoring & Logging
- [ ] **Error Tracking**
  - [ ] Integrate Crashlytics
  - [ ] Implement error logging
  - [ ] Add performance monitoring
  - [ ] Create error dashboard
  - [ ] Location: Firebase integration

### 3. Security
- [ ] **Security Hardening**
  - [ ] Implement certificate pinning
  - [ ] Add code obfuscation
  - [ ] Implement app integrity checks
  - [ ] Add API rate limiting on client
  - [ ] Location: Security service

---

## 📋 NOTES

### Dependencies to Add
```yaml
dependencies:
  flutter_secure_storage: ^9.0.0
  cached_network_image: ^3.3.0
  geolocator: ^10.1.0
  permission_handler: ^11.0.0
  flutter_local_notifications: ^16.0.0
  firebase_analytics: ^10.7.0
  firebase_crashlytics: ^4.0.0
  firebase_performance: ^0.9.0
  webp: ^0.0.0
  shimmer: ^3.0.0
```

### Breaking Changes Needed
1. Remove testing routes from `app_pages.dart`
2. Fix initial route from `/loginTest` to `/login`
3. Remove timeout workaround in Google auth
4. Fix memory leaks in controllers
5. Implement proper error handling everywhere

### Estimated Timeline
- **Critical Issues**: 4-6 weeks
- **High Priority**: 2-3 weeks
- **Medium Priority**: 3-4 weeks
- **Low Priority**: Ongoing

---

## 📊 Progress Tracking

### Completed ✅
- [x] Article card widget implementation (matching screenshot design)
  - [x] Created reusable `ArticleCardWidget` for vertical list items
  - [x] Simplified ArticlesView to show only vertical list (removed horizontal featured section)
  - [x] Added URL field to ArticlesModel for external links
  - [x] Implemented external URL opening with url_launcher package
  - [x] Applied proper styling and layout matching screenshot
  - [x] Implemented date formatting with relative time
  - [x] Added proper error handling for images
  - [x] Used NetworkImageWidget for consistent image loading
  - [x] Shows article image, title, description, category, date, and publisher
- [x] Article API integration
  - [x] Integrated ArticlesRepository into ArticlesController
  - [x] Implemented loadArticles() method to fetch data from API
  - [x] Added ArticlesRepository dependency injection in ArticlesBinding
  - [x] Added error handling for API calls
  - [x] Added loading state management
- [x] Fixed API data type mismatch
  - [x] Changed likes_count and comments_count from String to int in ArticlesModel
  - [x] Updated all references to use proper int type
  - [x] Regenerated JSON serialization code with build_runner

### In Progress 🚧
- [ ] (Add current work here)

### Blocked ⛔
- [ ] (Add blocked items here)

---

**Last Review**: 2025-01-15  
**Next Review**: Weekly
