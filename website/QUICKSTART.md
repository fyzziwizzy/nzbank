# 🌿 Quick Start Guide - Fern Bank

Get Fern Bank running in 30 seconds!

## Option 1: Direct Browser (Simplest)

1. Navigate to the website folder
2. Double-click `index.html`
3. Your browser opens → You're done! 🎉

## Option 2: Local Server (Recommended for Development)

### Windows (Command Prompt or PowerShell)
```bash
# Navigate to website directory
cd C:\WFClawish\WorkingRepos\fyzziwizzy\website

# Start Python server
python -m http.server 8000

# Open browser to: http://localhost:8000
```

### macOS/Linux (Terminal)
```bash
# Navigate to website directory
cd ~/path/to/fyzziwizzy/website

# Start Python server
python3 -m http.server 8000

# Open browser to: http://localhost:8000
```

### Using Node.js
```bash
# Install http-server globally (one time)
npm install -g http-server

# From website directory
http-server

# Opens at http://localhost:8080
```

## 🗂️ What You'll See

### Homepage (index.html)
- 💚 Green Fern Bank branding
- 💰 Balance card with privacy toggle
- 📋 Quick action buttons
- 🏦 Account overview
- 📊 Recent transactions

### Accounts (accounts.html)
- 💵 Multi-currency accounts (USD, EUR, GBP)
- 🏧 Account details (IBAN, balance)
- ⚙️ Account actions

### Send Money (transfer.html)
- 💸 Recipient search with suggestions
- 🎯 Amount and fee calculation
- 👥 Saved recipients
- 📝 Transfer form

### Cards (cards.html)
- 💳 Physical debit card
- 🔐 Virtual card
- 📊 Card statistics
- ⚙️ Card actions

### Settings (settings.html)
- 👤 Profile management
- 🔒 Security settings
- 🔔 Notifications
- 💰 Transaction limits
- 🌍 Preferences
- 💬 Support

## 🎨 Try These Quick Changes

### Change Colors
Edit `css/styles.css` line 6-8:
```css
--primary-color: #FF5722;  /* Change from green to orange */
```

### Change Logo
Edit `index.html` line 16:
```html
<span class="logo-icon">🏦</span>  <!-- Change emoji -->
```

### Add New Transaction
Edit `index.html` search for "Recent Transactions" and add:
```html
<div class="transaction-item">
    <div class="transaction-info">
        <div class="transaction-icon">🎮</div>
        <div class="transaction-details">
            <div class="transaction-name">PlayStation Store</div>
            <div class="transaction-date">Today at 5:30 PM</div>
        </div>
    </div>
    <div class="transaction-amount negative">-$59.99</div>
</div>
```

## 🐛 Common Issues

### Page won't load
- Check the file path is correct
- Ensure you're in the right directory
- Try refreshing (Ctrl+R or Cmd+R)

### Styling looks wrong
- Clear browser cache (Ctrl+Shift+Delete)
- Hard refresh (Ctrl+Shift+R)
- Check browser supports modern CSS (Chrome, Firefox, Safari, Edge)

### Navigation doesn't work
- Make sure all HTML files are in the same directory
- Don't move files around
- Use relative links (e.g., `accounts.html` not `/accounts.html`)

## 📝 Next Steps

1. **Explore the code** - Open HTML, CSS, and JS files in your editor
2. **Read the documentation** - Check `README.md` for details
3. **Make changes** - Follow `EXTENSIONS.md` for customization
4. **Test improvements** - Refresh browser to see changes
5. **Share feedback** - Document what you learned!

## 💡 Pro Tips

- **DevTools** (F12) shows errors and lets you inspect elements
- **Responsive Design Mode** (Ctrl+Shift+M) tests mobile view
- **Live Reload** - Some editors (VS Code) auto-refresh on save
- **GitHub** - All changes are tracked in git commits

## 🎓 Learning Path

1. **Day 1** - Explore the UI, understand structure
2. **Day 2** - Change colors and branding
3. **Day 3** - Modify sample data
4. **Day 4** - Add a new page/feature
5. **Day 5** - Deploy and share!

## 🚀 Ready to Build?

Start with these fun exercises:
- [ ] Change Fern Bank name and colors to your brand
- [ ] Add your company logo
- [ ] Update account balances
- [ ] Add new transaction types
- [ ] Create a custom reports page
- [ ] Add dark mode toggle
- [ ] Connect to a mock API

## 📚 File Reference

| File | Purpose | Size |
|------|---------|------|
| index.html | Dashboard/homepage | 8.7 KB |
| accounts.html | Account management | 7.0 KB |
| transfer.html | Send money interface | 7.1 KB |
| cards.html | Card management | 7.1 KB |
| settings.html | User settings | 16.2 KB |
| css/styles.css | Main design system | 21.2 KB |
| css/responsive.css | Mobile/tablet styles | 4.2 KB |
| js/main.js | Interactivity | 10.9 KB |
| README.md | Full documentation | 7.5 KB |
| EXTENSIONS.md | Extension guide | 11.9 KB |

**Total: ~100 KB (Production ready!)**

## ❓ Questions?

- Check the comments in the code files
- Read `README.md` for technical details
- Read `EXTENSIONS.md` for how-to guides
- Review your browser's Developer Tools for errors

---

**Welcome to Fern Bank! 🌿💚**

*Happy exploring and learning!*
