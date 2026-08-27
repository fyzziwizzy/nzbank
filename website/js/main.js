/* ============================================
   FERN BANK - MAIN JAVASCRIPT
   ============================================ */

// Navigation
document.addEventListener('DOMContentLoaded', function() {
    initializeNavigation();
    initializePages();
});

function initializeNavigation() {
    const navLinks = document.querySelectorAll('.nav-links a');
    navLinks.forEach(link => {
        link.addEventListener('click', function(e) {
            e.preventDefault();
            const page = this.getAttribute('data-page');
            if (page) {
                showPage(page);
                updateActiveNav(this);
            }
        });
    });

    // Set dashboard as active by default
    const dashboardLink = document.querySelector('[data-page="dashboard"]');
    if (dashboardLink) {
        updateActiveNav(dashboardLink);
    }
}

function updateActiveNav(element) {
    document.querySelectorAll('.nav-links a').forEach(link => {
        link.classList.remove('active');
    });
    element.classList.add('active');
}

function showPage(page) {
    const pages = document.querySelectorAll('[data-page-content]');
    pages.forEach(p => {
        p.style.display = p.getAttribute('data-page-content') === page ? 'block' : 'none';
    });
    window.scrollTo(0, 0);
}

function initializePages() {
    initializeDashboard();
    initializeTransfer();
    initializeCards();
    initializeSettings();
}

/* ============================================
   DASHBOARD PAGE
   ============================================ */

function initializeDashboard() {
    const balanceToggle = document.querySelector('.balance-toggle');
    if (balanceToggle) {
        balanceToggle.addEventListener('click', toggleBalance);
    }

    const actionButtons = document.querySelectorAll('.action-btn');
    actionButtons.forEach(btn => {
        btn.addEventListener('click', handleActionClick);
    });
}

function toggleBalance() {
    const balanceAmount = document.querySelector('.balance-amount h3');
    if (balanceAmount.textContent.includes('***')) {
        balanceAmount.textContent = '$2,547.89';
    } else {
        balanceAmount.textContent = '***';
    }
}

function handleActionClick(e) {
    e.preventDefault();
    const action = e.currentTarget.getAttribute('data-action');
    const navLink = document.querySelector(`[data-page="${action}"]`);
    if (navLink) {
        navLink.click();
    }
}

/* ============================================
   TRANSFER PAGE
   ============================================ */

function initializeTransfer() {
    const recipientInput = document.getElementById('recipient');
    if (recipientInput) {
        recipientInput.addEventListener('input', filterSuggestions);
        recipientInput.addEventListener('focus', showSuggestions);
    }

    const amountInput = document.getElementById('amount');
    if (amountInput) {
        amountInput.addEventListener('change', calculateFee);
    }

    const transferForm = document.getElementById('transferForm');
    if (transferForm) {
        transferForm.addEventListener('submit', handleTransferSubmit);
    }

    const recipientCards = document.querySelectorAll('.recipient-card');
    recipientCards.forEach(card => {
        card.addEventListener('click', selectRecipient);
    });
}

function filterSuggestions() {
    const input = document.getElementById('recipient');
    const suggestions = document.querySelector('.suggestions');
    const query = input.value.toLowerCase();

    if (!suggestions) return;

    const items = suggestions.querySelectorAll('.suggestion-item');
    items.forEach(item => {
        const name = item.querySelector('.suggestion-name').textContent.toLowerCase();
        const email = item.querySelector('.suggestion-email').textContent.toLowerCase();
        item.style.display = name.includes(query) || email.includes(query) ? 'flex' : 'none';
    });

    suggestions.style.display = query.length > 0 ? 'block' : 'none';
}

function showSuggestions() {
    const suggestions = document.querySelector('.suggestions');
    if (suggestions && document.getElementById('recipient').value) {
        suggestions.style.display = 'block';
    }
}

function selectRecipient(e) {
    e.preventDefault();
    const name = e.currentTarget.querySelector('.suggestion-name').textContent;
    const email = e.currentTarget.querySelector('.suggestion-email').textContent;
    document.getElementById('recipient').value = name;
    document.querySelector('.suggestions').style.display = 'none';
}

function calculateFee() {
    const amount = parseFloat(document.getElementById('amount').value) || 0;
    const feeElement = document.querySelector('.fee-row:nth-child(2) .fee-value');
    const totalElement = document.querySelector('.fee-row.total .fee-value');

    if (amount <= 100) {
        const fee = 0;
        feeElement.textContent = `$${fee.toFixed(2)}`;
        feeElement.className = 'fee-value fee-free';
    } else if (amount <= 1000) {
        const fee = (amount * 0.01).toFixed(2);
        feeElement.textContent = `$${fee}`;
        feeElement.className = 'fee-value';
    } else {
        const fee = (amount * 0.015).toFixed(2);
        feeElement.textContent = `$${fee}`;
        feeElement.className = 'fee-value';
    }

    const fee = parseFloat(feeElement.textContent.replace('$', ''));
    const total = amount + fee;
    totalElement.textContent = `$${total.toFixed(2)}`;
}

function handleTransferSubmit(e) {
    e.preventDefault();
    const recipient = document.getElementById('recipient').value;
    const amount = document.getElementById('amount').value;
    const fromAccount = document.getElementById('fromAccount').value;

    if (!recipient || !amount) {
        alert('Please fill in all required fields');
        return;
    }

    alert(`Transfer of $${amount} to ${recipient} initiated!\n\nFrom: ${fromAccount}\n\nPlease review and confirm the transaction on your device.`);
    e.target.reset();
}

/* ============================================
   CARDS PAGE
   ============================================ */

function initializeCards() {
    const cardMenus = document.querySelectorAll('.card-menu');
    cardMenus.forEach(menu => {
        menu.addEventListener('click', showCardMenu);
    });

    const cardActions = document.querySelectorAll('.card-actions .btn');
    cardActions.forEach(btn => {
        btn.addEventListener('click', handleCardAction);
    });
}

function showCardMenu(e) {
    e.stopPropagation();
    const cardType = e.currentTarget.closest('.card-display').querySelector('.card').classList.contains('physical-card') ? 'physical' : 'virtual';
    const actions = ['View PIN', 'Lock Card', 'Settings', 'Report Lost'];
    const action = prompt(`Card Actions (${cardType}):\n\n${actions.join('\n')}\n\nEnter action number (1-4):`, '1');

    if (action) {
        const actionNames = ['View PIN', 'Lock Card', 'Settings', 'Report Lost'];
        alert(`"${actionNames[parseInt(action) - 1] || 'Invalid'}" action initiated`);
    }
}

function handleCardAction(e) {
    e.preventDefault();
    const actionText = e.currentTarget.textContent;
    alert(`${actionText} initiated`);
}

/* ============================================
   SETTINGS PAGE
   ============================================ */

function initializeSettings() {
    const menuItems = document.querySelectorAll('.settings-menu .menu-item');
    menuItems.forEach(item => {
        item.addEventListener('click', switchSettingsPanel);
    });

    const toggleSwitches = document.querySelectorAll('.toggle-switch input');
    toggleSwitches.forEach(toggle => {
        toggle.addEventListener('change', handleToggleChange);
    });

    const settingsForm = document.getElementById('profileForm');
    if (settingsForm) {
        settingsForm.addEventListener('submit', handleSettingsSave);
    }

    const passwordForm = document.getElementById('passwordForm');
    if (passwordForm) {
        passwordForm.addEventListener('submit', handlePasswordChange);
    }

    const logoutBtn = document.querySelector('[data-action="logout"]');
    if (logoutBtn) {
        logoutBtn.addEventListener('click', handleLogout);
    }
}

function switchSettingsPanel(e) {
    e.preventDefault();
    const panelId = e.currentTarget.getAttribute('data-panel');

    // Update menu items
    document.querySelectorAll('.settings-menu .menu-item').forEach(item => {
        item.classList.remove('active');
    });
    e.currentTarget.classList.add('active');

    // Update panels
    document.querySelectorAll('.settings-panel').forEach(panel => {
        panel.style.display = panel.id === panelId ? 'block' : 'none';
    });
}

function handleToggleChange(e) {
    const label = e.currentTarget.closest('.toggle-item').querySelector('.toggle-info p:first-child').textContent;
    const state = e.currentTarget.checked ? 'enabled' : 'disabled';
    console.log(`${label} ${state}`);
}

function handleSettingsSave(e) {
    e.preventDefault();
    const formData = new FormData(e.target);
    alert('Profile updated successfully!');
}

function handlePasswordChange(e) {
    e.preventDefault();
    const currentPassword = document.getElementById('currentPassword').value;
    const newPassword = document.getElementById('newPassword').value;
    const confirmPassword = document.getElementById('confirmPassword').value;

    if (!currentPassword || !newPassword || !confirmPassword) {
        alert('Please fill in all password fields');
        return;
    }

    if (newPassword !== confirmPassword) {
        alert('New passwords do not match');
        return;
    }

    if (newPassword.length < 8) {
        alert('Password must be at least 8 characters long');
        return;
    }

    alert('Password changed successfully!');
    e.target.reset();
}

function handleLogout(e) {
    e.preventDefault();
    if (confirm('Are you sure you want to log out?')) {
        alert('Logged out successfully');
        // In a real app, this would redirect to login page
    }
}

/* ============================================
   UTILITY FUNCTIONS
   ============================================ */

function formatCurrency(amount, currency = 'USD') {
    return new Intl.NumberFormat('en-US', {
        style: 'currency',
        currency: currency,
        minimumFractionDigits: 2,
    }).format(amount);
}

function formatDate(date) {
    return new Intl.DateTimeFormat('en-US', {
        month: 'short',
        day: 'numeric',
        hour: '2-digit',
        minute: '2-digit',
    }).format(new Date(date));
}
