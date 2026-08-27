const transactions = [
  { icon: "A", name: "Amano", detail: "Dining · Today, 12:42 PM", amount: "-NZ$18.40", status: "Completed" },
  { icon: "S", name: "Salary", detail: "Northstar Studio · Today, 8:04 AM", amount: "+NZ$5,420.00", status: "Income", positive: true },
  { icon: "M", name: "Meadowlark Market", detail: "Groceries · Yesterday", amount: "-NZ$84.16", status: "Completed" },
  { icon: "AT", name: "Auckland Transport", detail: "Transport · 25 Aug", amount: "-NZ$22.00", status: "Completed" },
  { icon: "N", name: "Neon", detail: "Entertainment · 24 Aug", amount: "-NZ$19.99", status: "Completed" }
];

const accounts = [
  { currency: "NZD", title: "Everyday", balance: "NZ$18,425.20", detail: "•• 4821 · Main account" },
  { currency: "AUD", title: "Australian dollars", balance: "A$3,842.18", detail: "•• 0974 · Travel" },
  { currency: "USD", title: "US dollars", balance: "US$1,520.44", detail: "•• 3118 · Foreign currency" }
];

const rates = {
  "NZD-AUD": 0.923, "NZD-USD": 0.611,
  "AUD-NZD": 1.083, "AUD-USD": 0.662,
  "USD-NZD": 1.637, "USD-AUD": 1.51
};

const state = {
  activeView: "home",
  balanceVisible: true,
  cardFrozen: false,
  pendingTransfer: null
};

document.addEventListener("DOMContentLoaded", () => {
  renderTransactions();
  renderAccounts();
  bindNavigation();
  bindDashboard();
  bindPayments();
  bindCards();
  bindAccounts();
  bindSettings();
  bindGlobalFeedback();
  navigate((location.hash || "#home").slice(1), false);
});

function renderTransactions() {
  document.getElementById("recentTransactions").innerHTML = transactions.map(item => `
    <article class="transaction-row">
      <div class="transaction-main">
        <span class="activity-icon ${item.positive ? "success" : ""}">${item.icon}</span>
        <div><strong>${item.name}</strong><small>${item.detail}</small></div>
      </div>
      <strong class="transaction-amount ${item.positive ? "positive-copy" : ""}">${item.amount}<small>${item.status}</small></strong>
    </article>
  `).join("");
}

function renderAccounts() {
  document.getElementById("accountGrid").innerHTML = accounts.map(account => `
    <article class="surface account-tile">
      <header>
        <span class="currency-flag">${account.currency}</span>
        <button class="bare-icon" type="button" aria-label="Open ${account.title} account options" data-toast="${account.title} account options opened">•••</button>
      </header>
      <strong>${account.balance}</strong>
      <small>${account.detail}</small>
    </article>
  `).join("");
}

function bindNavigation() {
  document.querySelectorAll("[data-view]").forEach(button => {
    button.addEventListener("click", () => navigate(button.dataset.view));
  });

  document.getElementById("menuToggle").addEventListener("click", () => {
    const sidebar = document.querySelector(".sidebar");
    const isOpen = sidebar.classList.toggle("is-open");
    document.getElementById("menuToggle").setAttribute("aria-expanded", String(isOpen));
  });

  window.addEventListener("hashchange", () => navigate((location.hash || "#home").slice(1), false));
}

function navigate(viewName, updateHash = true) {
  if (!document.getElementById(`view-${viewName}`)) viewName = "home";
  state.activeView = viewName;

  document.querySelectorAll(".view").forEach(view => {
    view.classList.toggle("is-active", view.id === `view-${viewName}`);
  });
  document.querySelectorAll(".nav-item[data-view]").forEach(item => {
    item.classList.toggle("is-active", item.dataset.view === viewName);
  });

  const active = document.getElementById(`view-${viewName}`);
  document.getElementById("pageTitle").textContent = active.dataset.title;
  document.title = `${active.dataset.title} · Fern Bank`;
  document.querySelector(".sidebar").classList.remove("is-open");
  document.getElementById("menuToggle").setAttribute("aria-expanded", "false");
  if (updateHash) history.pushState(null, "", `#${viewName}`);
  window.scrollTo({ top: 0, behavior: "smooth" });
}

function bindDashboard() {
  document.getElementById("balanceToggle").addEventListener("click", () => {
    state.balanceVisible = !state.balanceVisible;
    document.getElementById("balanceValue").textContent = state.balanceVisible ? "NZ$24,680.42" : "NZ$••••••";
    document.getElementById("balanceToggle").setAttribute("aria-label", state.balanceVisible ? "Hide balance" : "Show balance");
  });

  document.getElementById("addMoneyButton").addEventListener("click", () => toast("Add money flow ready for the client to extend"));
  document.getElementById("requestButton").addEventListener("click", () => toast("Payment link copied for this demo"));

  const notificationButton = document.getElementById("notificationButton");
  notificationButton.addEventListener("click", () => {
    const panel = document.getElementById("notificationPanel");
    panel.hidden = !panel.hidden;
    notificationButton.setAttribute("aria-expanded", String(!panel.hidden));
  });

  document.getElementById("markReadButton").addEventListener("click", () => {
    document.querySelector(".notification-dot").hidden = true;
    document.getElementById("notificationPanel").hidden = true;
    notificationButton.setAttribute("aria-expanded", "false");
    toast("Notifications marked as read");
  });

  document.addEventListener("click", event => {
    const panel = document.getElementById("notificationPanel");
    if (!panel.hidden && !panel.contains(event.target) && !notificationButton.contains(event.target)) {
      panel.hidden = true;
      notificationButton.setAttribute("aria-expanded", "false");
    }
  });
}

function bindPayments() {
  document.querySelectorAll("[data-recipient]").forEach(button => {
    button.addEventListener("click", () => {
      document.getElementById("recipient").value = button.dataset.recipient;
      document.getElementById("recipient").focus();
    });
  });

  document.getElementById("clearRecipient").addEventListener("click", () => {
    document.getElementById("recipient").value = "";
    document.getElementById("recipient").focus();
  });

  document.getElementById("transferForm").addEventListener("submit", event => {
    event.preventDefault();
    const recipient = document.getElementById("recipient").value.trim();
    const amount = Number(document.getElementById("transferAmount").value);
    const currency = document.getElementById("transferCurrency").value;
    const reference = document.getElementById("transferReference").value.trim();
    const error = document.getElementById("transferError");

    if (!recipient) {
      error.textContent = "Choose a recipient before continuing.";
      document.getElementById("recipient").focus();
      return;
    }
    if (!Number.isFinite(amount) || amount <= 0) {
      error.textContent = "Enter an amount greater than zero.";
      document.getElementById("transferAmount").focus();
      return;
    }
    if (amount > 18425.2) {
      error.textContent = "This amount is higher than the available account balance.";
      document.getElementById("transferAmount").focus();
      return;
    }

    error.textContent = "";
    state.pendingTransfer = { recipient, amount, currency, reference };
    document.getElementById("reviewRecipient").textContent = recipient;
    document.getElementById("reviewAmount").textContent = `${currency} ${amount.toLocaleString("en-NZ", { minimumFractionDigits: 2, maximumFractionDigits: 2 })}`;
    document.getElementById("reviewReference").textContent = reference || "Not provided";
    toggleReviewSheet(true);
  });

  document.getElementById("closeSheet").addEventListener("click", () => toggleReviewSheet(false));
  document.getElementById("sheetBackdrop").addEventListener("click", () => toggleReviewSheet(false));
  document.getElementById("confirmTransfer").addEventListener("click", () => {
    const transfer = state.pendingTransfer;
    toggleReviewSheet(false);
    document.getElementById("transferForm").reset();
    document.getElementById("recipient").value = "Olivia Lee";
    toast(`${transfer.currency} ${transfer.amount.toFixed(2)} sent to ${transfer.recipient}`);
    state.pendingTransfer = null;
    navigate("home");
  });
}

function toggleReviewSheet(open) {
  document.getElementById("reviewSheet").hidden = !open;
  document.getElementById("sheetBackdrop").hidden = !open;
  document.body.style.overflow = open ? "hidden" : "";
  if (open) document.getElementById("closeSheet").focus();
}

function bindCards() {
  document.getElementById("freezeCard").addEventListener("click", () => {
    state.cardFrozen = !state.cardFrozen;
    document.querySelector(".frozen-overlay").hidden = !state.cardFrozen;
    const status = document.getElementById("cardStatus");
    status.textContent = state.cardFrozen ? "Frozen" : "Active";
    status.classList.toggle("is-frozen", state.cardFrozen);
    const button = document.getElementById("freezeCard");
    button.querySelector("strong").textContent = state.cardFrozen ? "Unfreeze" : "Freeze";
    button.querySelector("small").textContent = state.cardFrozen ? "Restore card use" : "Temporarily lock";
    toast(state.cardFrozen ? "Card frozen. Payments are blocked." : "Card active. Payments are enabled.");
  });

  document.getElementById("addCardButton").addEventListener("click", () => toast("New card application opened"));
}

function bindAccounts() {
  const sellAmount = document.getElementById("sellAmount");
  const sellCurrency = document.getElementById("sellCurrency");
  const receiveCurrency = document.getElementById("receiveCurrency");

  const updateExchange = () => {
    if (sellCurrency.value === receiveCurrency.value) {
      receiveCurrency.value = receiveCurrency.value === "NZD" ? "AUD" : "NZD";
    }
    const rate = rates[`${sellCurrency.value}-${receiveCurrency.value}`] || 1;
    const amount = Number(sellAmount.value) || 0;
    document.getElementById("receiveAmount").textContent = (amount * rate).toLocaleString("en-NZ", { minimumFractionDigits: 2, maximumFractionDigits: 2 });
  };

  [sellAmount, sellCurrency, receiveCurrency].forEach(control => control.addEventListener("input", updateExchange));
  document.getElementById("swapCurrencies").addEventListener("click", () => {
    const originalSell = sellCurrency.value;
    sellCurrency.value = receiveCurrency.value;
    receiveCurrency.value = originalSell;
    updateExchange();
  });
  document.getElementById("exchangeForm").addEventListener("submit", event => {
    event.preventDefault();
    toast(`Exchange preview: ${sellCurrency.value} to ${receiveCurrency.value}`);
  });
  document.getElementById("newAccountButton").addEventListener("click", () => toast("Account catalogue opened"));
}

function bindSettings() {
  document.querySelectorAll("[data-settings-tab]").forEach(button => {
    button.addEventListener("click", () => {
      const tab = button.dataset.settingsTab;
      document.querySelectorAll("[data-settings-tab]").forEach(item => item.classList.toggle("is-active", item === button));
      document.querySelectorAll(".settings-panel").forEach(panel => panel.classList.toggle("is-active", panel.id === `settings-${tab}`));
    });
  });

  document.getElementById("profileForm").addEventListener("submit", event => {
    event.preventDefault();
    toast("Profile changes saved");
  });

  document.getElementById("themeToggle").addEventListener("click", () => {
    const next = document.documentElement.dataset.theme === "dark" ? "light" : "dark";
    document.documentElement.dataset.theme = next;
    toast(`${next[0].toUpperCase()}${next.slice(1)} appearance enabled`);
  });
}

function bindGlobalFeedback() {
  document.addEventListener("click", event => {
    const trigger = event.target.closest("[data-toast]");
    if (trigger) toast(trigger.dataset.toast);
  });

  document.addEventListener("keydown", event => {
    if (event.key !== "Escape") return;
    if (!document.getElementById("reviewSheet").hidden) toggleReviewSheet(false);
    document.getElementById("notificationPanel").hidden = true;
    document.querySelector(".sidebar").classList.remove("is-open");
  });
}

function toast(message) {
  const item = document.createElement("div");
  item.className = "toast";
  item.textContent = message;
  document.getElementById("toastRegion").appendChild(item);
  window.setTimeout(() => item.remove(), 3200);
}
