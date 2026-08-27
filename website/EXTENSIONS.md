# 🚀 Fern Bank - Extension Guide for Clients

Welcome to the Fern Bank banking website! This guide will help you extend and customize the platform for your needs.

## 📚 Table of Contents

1. [Project Setup](#project-setup)
2. [Code Structure](#code-structure)
3. [Common Customizations](#common-customizations)
4. [Adding Features](#adding-features)
5. [Testing Your Changes](#testing-your-changes)
6. [Best Practices](#best-practices)

## 🛠️ Project Setup

### Prerequisites
- A text editor (VS Code, Sublime, etc.)
- A modern web browser (Chrome, Firefox, Safari, Edge)
- Basic knowledge of HTML, CSS, and JavaScript

### Getting Started

1. **Clone or download the repository**
   ```bash
   git clone <repository-url>
   cd fyzziwizzy/website
   ```

2. **Open in your editor**
   ```bash
   code .
   ```

3. **Run a local server** (optional but recommended)
   ```bash
   # Python 3
   python -m http.server 8000
   
   # Python 2
   python -m SimpleHTTPServer 8000
   
   # Node.js (npx)
   npx http-server
   ```

4. **Open in browser**
   - Navigate to `http://localhost:8000` (or open `index.html` directly)

## 📁 Code Structure

### File Organization

```
website/
├── index.html              # Dashboard - main page
├── accounts.html           # Account management page
├── transfer.html           # Money transfer page
├── cards.html              # Card management page
├── settings.html           # User settings page
├── README.md              # Main documentation
├── EXTENSIONS.md          # This file
├── css/
│   ├── styles.css         # Main stylesheet (1200+ lines)
│   └── responsive.css     # Mobile/tablet styles
└── js/
    └── main.js            # JavaScript functionality
```

### How Pages Connect

1. **Navigation Links** (in navbar)
   - All pages link to each other via `<a>` tags
   - Each page has a `data-page` attribute
   - JavaScript updates the active state

2. **Data Attributes**
   - `data-page`: Page identifier (dashboard, accounts, transfer, cards, settings)
   - `data-action`: Quick action buttons (send, cards, accounts, settings)
   - `data-panel`: Settings sidebar panels (profile, security, notifications, limits, preferences, support)

3. **CSS Classes**
   - `.navbar` - Navigation bar
   - `.balance-card` - Main balance display
   - `.account-card` - Account cards
   - `.transaction-item` - Transaction list items
   - `.btn` - Buttons (`.btn-primary`, `.btn-secondary`)

## 🎨 Common Customizations

### 1. Change Brand Colors

**File:** `css/styles.css` (lines 1-20)

```css
:root {
    --primary-color: #1B5E20;      /* Change Fern Green */
    --primary-light: #43A047;
    --primary-dark: #0D3817;
    --secondary-color: #FFC107;    /* Change Gold */
    /* ... more colors ... */
}
```

**Example: Change to Blue Theme**
```css
:root {
    --primary-color: #1565C0;      /* Navy Blue */
    --primary-light: #1976D2;
    --primary-dark: #0D47A1;
    /* Keep other colors the same */
}
```

### 2. Change Logo and Branding

**File:** `index.html` (line 14-18)

```html
<a href="#" class="logo">
    <span class="logo-icon">🌿</span>  <!-- Change emoji or use <img> -->
    <span class="logo-text">Fern Bank</span>  <!-- Change name -->
</a>
```

**Example: Use an image logo**
```html
<a href="#" class="logo">
    <img src="logo.png" alt="Your Bank" class="logo-img">
    <span class="logo-text">Your Bank</span>
</a>
```

### 3. Update Sample Data

**File:** `index.html` (search for specific values)

```html
<!-- Balance -->
<h3>$2,547.89</h3>  <!-- Change balance amount -->

<!-- User Info -->
<div class="user-avatar">FB</div>  <!-- Change initials -->

<!-- Accounts -->
<h3>USD Account</h3>  <!-- Change account names -->

<!-- Transactions -->
<div class="transaction-name">Pizza Hut</div>  <!-- Update merchants -->
```

### 4. Add Custom Fonts

**File:** `css/styles.css` (add at the top)

```css
@import url('https://fonts.googleapis.com/css2?family=Poppins:wght@400;600;700&display=swap');

body {
    font-family: 'Poppins', sans-serif;  /* Changed from system fonts */
}
```

### 5. Modify Layout

**File:** `css/styles.css` (find the component class)

```css
/* Example: Change card layout from 3 columns to 2 */
.accounts-list {
    grid-template-columns: repeat(auto-fit, minmax(350px, 1fr));  /* Was 300px */
}
```

## ✨ Adding Features

### Add a New Page

1. **Create HTML file**
   ```html
   <!-- reports.html -->
   <!DOCTYPE html>
   <html lang="en">
   <head>
       <meta charset="UTF-8">
       <meta name="viewport" content="width=device-width, initial-scale=1.0">
       <title>Reports - Fern Bank</title>
       <link rel="stylesheet" href="css/styles.css">
       <link rel="stylesheet" href="css/responsive.css">
   </head>
   <body>
       <nav class="navbar">
           <div class="navbar-container">
               <div class="logo">
                   <span class="logo-icon">🌿</span>
                   <span class="logo-text">Fern Bank</span>
               </div>
               <ul class="nav-links">
                   <li><a href="index.html">Dashboard</a></li>
                   <li><a href="accounts.html">Accounts</a></li>
                   <li><a href="transfer.html">Send Money</a></li>
                   <li><a href="cards.html">Cards</a></li>
                   <li><a href="reports.html" class="active">Reports</a></li>  <!-- New -->
                   <li><a href="settings.html">Settings</a></li>
               </ul>
           </div>
       </nav>
       
       <main class="main-content">
           <div class="container">
               <h1>Financial Reports</h1>
               <!-- Your content -->
           </div>
       </main>
       
       <footer class="footer">
           <p>&copy; 2024 Fern Bank</p>
       </footer>
       
       <script src="js/main.js"></script>
   </body>
   </html>
   ```

2. **Add JavaScript (if needed)**
   ```javascript
   // In js/main.js, add to initializePages():
   function initializeReports() {
       // Your code here
   }
   ```

3. **Add navigation link to all pages**
   - Add the same `<li>` with `<a href="reports.html">Reports</a>` to each navbar

### Add a Modal/Popup

```html
<!-- HTML -->
<div class="modal" id="confirmTransfer">
    <div class="modal-content">
        <h2>Confirm Transfer</h2>
        <p>Are you sure?</p>
        <button class="btn btn-primary">Confirm</button>
        <button class="btn btn-secondary">Cancel</button>
    </div>
</div>
```

```css
/* CSS */
.modal {
    display: none;
    position: fixed;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background: rgba(0, 0, 0, 0.5);
    z-index: 1000;
}

.modal.open {
    display: flex;
    align-items: center;
    justify-content: center;
}

.modal-content {
    background: white;
    border-radius: 12px;
    padding: 30px;
    max-width: 400px;
}
```

```javascript
// JavaScript
document.getElementById('transferForm').addEventListener('submit', function(e) {
    e.preventDefault();
    document.getElementById('confirmTransfer').classList.add('open');
});

document.querySelector('.modal .btn-primary').addEventListener('click', function() {
    // Submit transfer
    document.getElementById('confirmTransfer').classList.remove('open');
});
```

### Add Form Validation

```javascript
function validateTransferForm(e) {
    e.preventDefault();
    
    const recipient = document.getElementById('recipient').value.trim();
    const amount = parseFloat(document.getElementById('amount').value);
    
    if (!recipient) {
        alert('Please enter a recipient');
        return;
    }
    
    if (!amount || amount <= 0) {
        alert('Please enter a valid amount');
        return;
    }
    
    if (amount > 10000) {
        alert('Daily limit is $10,000');
        return;
    }
    
    // Form is valid - proceed
    submitTransfer();
}
```

### Add Data Persistence with LocalStorage

```javascript
// Save user preference
function saveDarkMode(enabled) {
    localStorage.setItem('darkMode', enabled);
    applyDarkMode(enabled);
}

// Load on page load
window.addEventListener('DOMContentLoaded', function() {
    const darkMode = localStorage.getItem('darkMode') === 'true';
    applyDarkMode(darkMode);
});

function applyDarkMode(enabled) {
    if (enabled) {
        document.body.classList.add('dark-mode');
    } else {
        document.body.classList.remove('dark-mode');
    }
}
```

## 🧪 Testing Your Changes

### Browser DevTools
1. **Right-click → Inspect** to open Developer Tools
2. **Elements tab** - Check HTML structure
3. **Console tab** - See JavaScript errors
4. **Network tab** - Check CSS/JS loading
5. **Responsive Design Mode** (Ctrl+Shift+M) - Test mobile

### Testing Checklist
- [ ] All links work
- [ ] Forms submit without errors
- [ ] Styling looks correct
- [ ] Mobile view is responsive
- [ ] No console errors
- [ ] Images load properly
- [ ] Navigation is clear

### Test Responsiveness
```bash
# Test at different breakpoints:
# Mobile: 480px
# Tablet: 768px
# Desktop: 1024px+
```

## 📋 Best Practices

### 1. Keep It Organized
```
Group related code:
- HTML: Keep similar components together
- CSS: Use comments to section components
- JavaScript: Separate concerns into functions
```

### 2. Use Consistent Naming
```javascript
// Good
const userBalance = 2547.89;
function calculateTransferFee() { }

// Avoid
const ub = 2547.89;
function calc() { }
```

### 3. Comment Your Code
```html
<!-- Login form with email and password fields -->
<form class="login-form">
    <input type="email" placeholder="Email">
    <input type="password" placeholder="Password">
</form>
```

### 4. Test Before Committing
```bash
git diff  # Review changes
# Test in browser
git add .
git commit -m "Add feature: Description"
```

### 5. Use CSS Variables for Consistency
```css
/* Good */
color: var(--primary-color);
padding: var(--spacing-md);

/* Avoid */
color: #1B5E20;
padding: 20px;
```

### 6. Make Mobile-First Updates
```css
/* Start with mobile */
.card {
    grid-template-columns: 1fr;  /* Mobile: single column */
}

/* Then add tablet/desktop */
@media (min-width: 768px) {
    .card {
        grid-template-columns: repeat(2, 1fr);  /* Tablet: 2 columns */
    }
}
```

## 🐛 Troubleshooting

### CSS Not Updating?
- Clear browser cache (Ctrl+Shift+Delete)
- Hard refresh (Ctrl+Shift+R or Cmd+Shift+R)
- Check file path in `<link>` tag

### JavaScript Not Working?
- Check DevTools Console for errors (F12)
- Verify script is loaded (Network tab)
- Check file path in `<script>` tag
- Ensure elements exist before manipulating them

### Styling Looks Off?
- Check responsive breakpoints
- Verify CSS selector specificity
- Use browser DevTools to inspect elements
- Test in different browsers

## 📚 Additional Resources

- [MDN Web Docs](https://developer.mozilla.org/)
- [CSS Tricks](https://css-tricks.com/)
- [JavaScript.info](https://javascript.info/)
- [Web Accessibility](https://www.w3.org/WAI/)

## ✅ Checklist Before Launch

- [ ] All pages working
- [ ] Mobile responsive
- [ ] No console errors
- [ ] Consistent branding
- [ ] All links functional
- [ ] Forms validating
- [ ] Code commented
- [ ] Performance optimized
- [ ] Accessibility checked
- [ ] Browser compatibility tested

---

**Ready to extend Fern Bank? Let's go! 🚀**

Questions? Check the main README.md or review the commented code in each file.
