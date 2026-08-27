# 🌿 Fern Bank - Modern Banking Website

A contemporary digital banking application inspired by Revolut's personal banking interface. This is a fully functional, responsive web application designed as an exercise for reviewing and extending banking website features.

## 🎯 Purpose

**Fern Bank** is a client training exercise that demonstrates:
- Modern banking UI/UX patterns
- Responsive design for desktop, tablet, and mobile
- JavaScript interactivity for financial applications
- Clean, maintainable code structure
- Professional banking workflows

Perfect for learning web development, practicing code reviews, and extending banking features.

## 📁 Project Structure

```
website/
├── index.html           # Dashboard - main entry point
├── accounts.html        # Account management with multi-currency support
├── transfer.html        # Send money interface with fee calculation
├── cards.html          # Card management (physical & virtual)
├── settings.html       # User settings with comprehensive options
├── css/
│   ├── styles.css      # Main stylesheet with design system
│   └── responsive.css  # Mobile/tablet breakpoints
└── js/
    └── main.js         # JavaScript functionality and interactivity
```

## 🚀 Quick Start

1. **Open in browser:**
   ```bash
   # Simply open index.html in your browser
   open website/index.html
   # or on Windows
   start website/index.html
   ```

2. **Local development server (optional):**
   ```bash
   # Using Python 3
   cd website
   python -m http.server 8000
   
   # Then visit: http://localhost:8000
   ```

## 🎨 Design System

### Color Palette (Fern Bank Green Theme)
- **Primary:** `#1B5E20` (Fern Green)
- **Primary Light:** `#43A047` (Light Green)
- **Primary Dark:** `#0D3817` (Deep Forest)
- **Secondary:** `#FFC107` (Gold Accent)
- **Text Primary:** `#212121` (Dark Gray)
- **Text Secondary:** `#757575` (Medium Gray)
- **Background:** `#F5F5F5` (Light Gray)
- **Surface:** `#FFFFFF` (White)

### Typography
- Font Family: System fonts (Segoe UI, Roboto, SF Pro Display)
- Responsive scaling: 48px (h1) down to 12px (labels)

### Component System
- Cards with shadow elevation system
- Gradient backgrounds for primary sections
- Smooth transitions (300ms ease)
- Rounded corners (8px-16px)

## 📄 Pages Overview

### Dashboard (index.html)
- **Total Balance** card with eye toggle for privacy
- **Quick Actions** grid (Send Money, Cards, Accounts, Settings)
- **Your Accounts** overview (USD, EUR, GBP)
- **Recent Transactions** list with merchants and amounts

**Key Features:**
- Balance toggle for privacy
- Multi-account display
- Transaction history with icons
- Action shortcuts

### Accounts (accounts.html)
- Manage multiple currency accounts
- View account details (IBAN, balance, status)
- Quick actions (View Details, Transaction History)

**Key Features:**
- Multi-currency support (USD, EUR, GBP)
- Account status indicators
- IBAN display
- Account balance tracking

### Send Money (transfer.html)
- Recipient search with suggestions
- Amount and currency selection
- Real-time fee calculation
- Recipient history for quick transfers

**Key Features:**
- Recipient autocomplete
- Free transfers ≤$100
- Tiered fee structure
- Saved recipients grid
- Fee breakdown display

### Cards (cards.html)
- Physical and virtual card management
- Card display with masked numbers
- Card statistics (status, limits, spending)
- Quick actions (Settings, Lock, Transactions)

**Key Features:**
- Realistic card designs (gradients)
- Card number masking
- Multiple card types
- Card actions and settings

### Settings (settings.html)
- **Profile** - Personal information and avatar
- **Security** - Password, 2FA, device management
- **Notifications** - Transaction alerts, email preferences
- **Limits** - Daily/transfer limits configuration
- **Preferences** - Language, currency, appearance
- **Support** - Help center, contact options

**Key Features:**
- Sidebar navigation menu
- Toggle switches for preferences
- Session management
- Support resources

## 💻 Technology Stack

- **HTML5** - Semantic markup
- **CSS3** - Grid, Flexbox, CSS Variables, Gradients
- **Vanilla JavaScript** - No frameworks (great for learning!)
- **Responsive Design** - Mobile-first approach

## 🔧 How to Extend

### Add a New Feature

1. **New Page:** Create `feature.html` and add to navigation
2. **Styling:** Add styles to `css/styles.css` (or new file)
3. **Functionality:** Add to `js/main.js` with event handlers
4. **Responsive:** Update `css/responsive.css` for mobile

### Example: Add Notifications Page

```html
<!-- notifications.html -->
<div data-page-content="notifications">
    <h1>Notifications</h1>
    <!-- Your content here -->
</div>
```

```javascript
// js/main.js - Add to initializePages()
function initializeNotifications() {
    // Your JavaScript here
}
```

### Styling Best Practices

- Use CSS variables for colors: `var(--primary-color)`
- Follow the shadow system: `var(--shadow-sm|md|lg)`
- Mobile-first breakpoints (768px, 1024px)
- Maintain spacing scale (8px base unit)

## 🧪 Exercise Ideas

### For Beginners
1. Change the Fern Bank branding (colors, logo, name)
2. Update the sample account data
3. Add more transaction examples
4. Customize card designs

### For Intermediate
1. Add form validation for transfers
2. Implement a notification bell with dropdown
3. Create a transaction filter/search
4. Add account balance charts

### For Advanced
1. Connect to a mock API (JSON data)
2. Implement local storage for persistent data
3. Add dark mode toggle
4. Create a transaction export feature
5. Build an analytics dashboard

## 📋 Code Review Checklist

When reviewing Fern Bank code, consider:
- [ ] Semantic HTML structure
- [ ] CSS class naming (BEM or similar)
- [ ] JavaScript code organization
- [ ] Responsive design compatibility
- [ ] Accessibility (alt text, ARIA labels)
- [ ] Performance (CSS animations, JavaScript efficiency)
- [ ] Security (input validation, XSS prevention)
- [ ] Browser compatibility
- [ ] Mobile usability
- [ ] Code duplication and DRY principles

## 🎓 Learning Outcomes

After working with Fern Bank, you'll understand:
- ✅ Modern web application structure
- ✅ Responsive design principles
- ✅ CSS design systems and theming
- ✅ DOM manipulation with vanilla JavaScript
- ✅ Financial application UI patterns
- ✅ Code organization and maintainability
- ✅ User experience best practices

## 🔐 Security Notes

This is a **frontend-only exercise** with sample data. In production:
- Never expose real financial data in frontend
- Implement proper authentication
- Use HTTPS for all communications
- Validate all inputs on the server
- Implement rate limiting and fraud detection
- Comply with financial regulations (PCI-DSS, etc.)

## 📞 Support

For questions or improvements, refer to:
- HTML files have detailed comments
- CSS uses self-documenting variable names
- JavaScript functions have docstrings
- Responsive breakpoints are clearly marked

## 📝 License

This is an educational project. Feel free to use it for learning and training purposes.

---

**Happy Banking! 🌿💚**
