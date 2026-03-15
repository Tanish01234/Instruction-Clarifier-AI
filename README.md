# Instruction Clarifier AI

**"AI that fixes how humans talk to machines"**

> *"We didn't make AI smarter. We made human instructions clearer."*

## 🎯 Problem Statement

Humans give vague, ambiguous, low-quality instructions:
- "Make it more professional"
- "Simple but impactful"  
- "AI should behave smartly"
- "Startup-type design chahiye"

Current AI systems either guess the intent, ask too many questions, or produce incorrect output.

**The Core Problem:** AI fails not because it's dumb, but because human instructions are unclear.

## 💡 Solution

Instruction Clarifier AI converts vague instructions into clear, executable ones through:

1. **Ambiguity Detection** - Highlights vague words and missing constraints
2. **Smart Clarification** - Asks minimal MCQ-style questions
3. **Final Output** - Produces structured, AI-ready instructions

This AI understands first, then executes.

## ✨ Features

### 🔍 Ambiguity Detection Engine
- Detects vague words ("professional", "modern", "simple", etc.)
- Calculates ambiguity score (0-100)
- Identifies missing constraints
- Animated ambiguity meter with color coding

### 🎯 Smart Clarification
- MCQ-style clarification questions
- 2-3 meaningful, distinct options per ambiguity
- One-tap selection
- No open-ended confusion

### 📋 Final Instruction Generator
- Before/After comparison view
- Structured breakdown (Goal, Style, Constraints, Outcome)
- Copy to clipboard
- Share functionality

### 🎨 Premium UI/UX
- Clean, minimal, tech-forward design
- Dark & light mode support
- Smooth animations throughout
- Responsive layouts
- Soft shadows and rounded corners

### 🎮 Demo Mode
- Toggle for offline hackathon judging
- Pre-cached responses (no API required)
- Quick examples for instant demonstration
- Guaranteed to work without internet

## 🚀 Quick Start

### Prerequisites
- Flutter SDK (3.0.0 or higher)
- Dart SDK
- Google Gemini API key (for live mode)

### Installation

1. Clone the repository:
```bash
cd "Instruction Clarifier AI"
```

2. Install dependencies:
```bash
flutter pub get
```

3. (Optional) Set up Gemini API key for live mode:

Create a `.env` file or pass it as an environment variable:
```bash
--dart-define=GEMINI_API_KEY=your_api_key_here
```

4. Run the app:
```bash
# For demo mode (no API required)
flutter run

# For live mode with Gemini API
flutter run --dart-define=GEMINI_API_KEY=your_api_key_here
```

## 📱 Usage

### Demo Mode (Recommended for Hackathons)
1. Toggle "Demo" switch ON in the top-right
2. Tap a quick example or type your own vague instruction
3. Watch the magic happen instantly (offline)

### Live Mode
1. Toggle "Demo" switch OFF
2. Enter any vague instruction
3. AI analyzes in real-time using Gemini
4. Get clarified, structured instructions

## 🎪 Hackathon Demo Script

**30-Second Demo Flow:**

1. **Start** - Show tagline and problem statement (5s)
2. **Input** - Type "Make it more professional" (5s)
3. **Analysis** - Watch ambiguity meter animate to 85/High (7s)
4. **Clarification** - Select "Modern Startup-style" (5s)
5. **Result** - Show before/after comparison + copy button (8s)

**Judge Impact:** Instant "aha!" moment showing clear value.

## 🏗️ Architecture

```
lib/
├── core/
│   ├── theme/          # Colors, typography, themes
│   └── utils/          # AI prompts
├── models/             # Data models
├── services/           # AI & demo services
├── providers/          # Riverpod state management
├── screens/            # 4 main screens
├── widgets/            # Reusable components
└── main.dart           # App entry point
```

### Tech Stack
- **Framework:** Flutter
- **State Management:** Riverpod
- **AI:** Google Gemini (gemini-1.5-flash)
- **Animations:** flutter_animate
- **UI:** Material Design 3

## 🎨 Design System

### Colors
- **Primary:** #4A90E2 (Blue)
- **Secondary:** #6C63FF (Purple)
- **Success:** #4CAF50 (Green)
- **Warning:** #FF9800 (Orange)
- **Error:** #E53935 (Red)

### Typography
- **Font:** Inter
- **Headings:** Bold, 32-24-20px
- **Body:** Regular, 16-14-12px

### Components
- Rounded corners (12-16px)
- Soft shadows
- Smooth animations (300-1500ms)
- Card-based layouts

## 🧪 Testing

```bash
# Run all tests
flutter test

# Run specific test
flutter test test/services/ai_service_test.dart

# Run integration tests
flutter test integration_test/
```

## 📦 Build

```bash
# Android APK
flutter build apk --release

# iOS
flutter build ios --release

# Web
flutter build web --release
```

## 🌟 Future Extensions

1. **AI Tool Plugins**
   - ChatGPT plugin
   - Midjourney optimizer
   - Code instruction formatter

2. **Enterprise Features**
   - Team collaboration
   - Instruction templates
   - Analytics dashboard

3. **Multi-language Support**
   - Hindi, Spanish, Mandarin
   - Localized clarification options

4. **Design & Dev Handoff**
   - Client briefing assistant
   - Auto-generate PRDs

## 🤝 Contributing

This is a hackathon project. Feel free to fork and extend!

## 📄 License

MIT License - feel free to use this project for learning and building.

## 👥 Team

Built for hackathons by developers who believe in better human↔AI communication.

---

**Remember:** "We didn't make AI smarter. We made human instructions clearer." 🚀
