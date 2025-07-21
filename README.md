# Ivan Cantarino's Website

A beautiful website built with [Publish](https://github.com/johnsundell/publish) - a static site generator for Swift.

## Features

- 🎨 **Custom Theme**: Inspired by Swiftology.io with refined purple and orange accents
- 🌈 **Syntax Highlighting**: Beautiful Swift code highlighting using Splash
- 🌙 **Dark Mode**: Automatic light/dark theme support
- 📱 **Responsive**: Mobile-friendly design
- ⚡ **Fast**: Static site generation for optimal performance

## Local Development

### Prerequisites

- Swift 5.7 or later
- macOS 12 or later

### Setup

1. Clone the repository
2. Install dependencies:
   ```bash
   swift package update
   ```
3. Generate the site:
   ```bash
   swift run IvanCantarino
   ```
4. Serve locally:
   ```bash
   cd Output && python3 -m http.server 3000
   ```
5. Visit: http://localhost:3000

## Adding Content

### Posts

Create new posts in `Content/posts/` with this format:

```markdown
---
date: 2025-07-21 15:00
description: Your post description
tags: tag1, tag2
---

# Post Title

Your content here...
```

### Pages

Add static pages to `Content/` directory.

## Deployment

The site automatically deploys to GitHub Pages via GitHub Actions when you push to the main branch.

### GitHub Pages Setup

1. Go to your repository Settings → Pages
2. Set Source to "GitHub Actions"
3. Push to main branch to trigger deployment

## Project Structure

- `Content/` - Markdown content files
- `Resources/` - Custom CSS and assets
- `Sources/` - Swift source code
- `Output/` - Generated static site (auto-generated)
- `.github/workflows/` - GitHub Actions deployment

## Theme Customization

The custom theme is defined in `Resources/custom.css` with:

- **Navigation**: Dark purple (`#8b6fb8`)
- **Tags**: Dark orange gradient
- **Headers**: Clean white text
- **Code**: SF Mono/Fira Code fonts
- **Syntax**: Beautiful Swift highlighting

## Built With

- [Publish](https://github.com/johnsundell/publish) - Static site generator
- [Splash](https://github.com/johnsundell/Splash) - Swift syntax highlighter
- GitHub Actions - Automated deployment
- GitHub Pages - Hosting