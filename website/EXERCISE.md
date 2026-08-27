# Fern Bank client exercise

## Scenario

You have joined the Fern Bank product team. The team has a credible frontend prototype, but it is not production-ready. Your assignment is to review the implementation, identify risk and extend one customer journey without reducing accessibility or responsiveness.

Timebox: 90 to 150 minutes.

## Part 1: Review

Review `index.html`, `css/styles.css`, `css/responsive.css` and `js/main.js`.

Submit a short review containing:

1. The three highest-priority issues you would address before connecting this frontend to a banking API.
2. One accessibility improvement.
3. One maintainability improvement.
4. One test strategy for the transfer journey.
5. Any assumptions you made.

Prioritise customer harm, security boundaries and correctness over visual preferences.

## Part 2: Extend

Choose one track.

### Track A: Transaction search and filtering

Add an activity view that lets a customer:

- Search merchant and transaction text.
- Filter by income or spending.
- Filter by category.
- See an intentional empty state when nothing matches.
- Clear all filters in one action.

Acceptance criteria:

- Filtering is case-insensitive.
- The original transaction array remains the source of truth.
- Controls are keyboard accessible.
- The layout works at 360px and 1280px widths.

### Track B: Scheduled payment

Extend the transfer journey so a customer can:

- Choose now, a future date or a recurring monthly payment.
- Review the schedule before confirmation.
- Receive a clear validation error for a date in the past.
- Cancel the review without losing entered data.

Acceptance criteria:

- Existing immediate transfers still work.
- Dates are displayed in a locale-aware format.
- Schedule state is represented explicitly, not inferred from button text.
- Validation does not use `alert()`.

### Track C: Savings goal

Turn the Queenstown savings card into a working goal:

- Open a detailed goal view.
- Add money to the goal.
- Prevent contributions above the available NZD balance.
- Update the amount and completion percentage.
- Show a completed state at 100%.

Acceptance criteria:

- The dashboard and goal detail stay consistent.
- Currency calculations avoid floating-point display errors.
- Progress remains understandable without relying on colour alone.
- Confirmation appears inline or as a toast.

## Part 3: Explain

Be ready to explain:

- How you separated state, rendering and event handling.
- What belongs in a future backend.
- Which edge cases you covered.
- What you would test next.

## Review rubric

| Area | Weight | What good looks like |
|---|---:|---|
| Product reasoning | 25% | Finds meaningful customer and banking risks |
| Correctness | 25% | Handles validation, state and edge cases clearly |
| Code quality | 20% | Small functions, clear naming and little duplication |
| Accessibility | 15% | Keyboard, labels, focus and non-colour cues considered |
| Responsive UX | 10% | Works on narrow and wide screens |
| Communication | 5% | Assumptions and trade-offs are concise |

## Guardrails

- Do not use real customer or account data.
- Do not copy source code, text or visual assets from a commercial bank.
- Do not add a framework solely to complete the exercise.
- Keep all functionality local to this folder.
- Treat all client-side validation as user experience only. A real backend must validate again.
