# ADR-0002: Cloud-rendered avatar over on-device 3D rendering

| Field | Value |
|---|---|
| **Status** | Accepted |
| **Date** | 18 June 2026 |
| **Decision makers** | Chief Architect, Head of Mobile Engineering, Head of Customer Experience |
| **Contested** | Yes. Mobile engineering argued strongly for on-device. |
| **Reversibility** | **Moderate.** One to two quarters, contained to the Orchestrator and client. |
| **Related risks** | KORU-R-07 latency |

---

## Context

An avatar can be produced two ways.

**Cloud-rendered.** The service synthesises audio and video server side and streams a composed video track to the client over WebRTC. The client is a video player.

**On-device.** The client ships a 3D model and a rendering engine. The service streams audio plus viseme and expression timing data, and the device animates the model locally.

The choice affects latency, cost, device reach, accessibility and how much of the experience we can change without an app release.

## Decision

**We will use cloud-rendered avatar synthesis streamed over WebRTC, with a mandatory non-video fallback path.**

The client receives a composed audio and video track. The client is deliberately thin: it handles media transport, capture, captions, controls and the accompanying on-screen information panel, and holds no avatar assets.

## Consequences

### Positive

- **Device reach.** Works on low-end Android devices, older iPhones and desktop browsers without a GPU budget. This matters because our accessibility thesis targets older and less digitally confident customers, who statistically hold older devices.
- **No app release to change the experience.** Appearance, expression, voice and presentation can be updated server side. This is a control benefit as well as a product one: if we must change the avatar's behaviour in response to an incident, we do it in minutes, not in an app store review cycle.
- **No avatar assets on the device.** A 3D likeness shipped in an app binary is extractable, and an extracted bank-branded avatar is a phishing asset. Cloud rendering keeps the likeness server side.
- **Consistent rendering.** One appearance everywhere, which simplifies brand governance and accessibility testing.
- **Simpler client attack surface.** The client has no model loading, no shader pipeline and no asset integrity problem.

### Negative

- **Higher and more variable latency.** Synthesis and encode add to the turn budget. Our allocation is 380ms for first video frame within the 1.2 second p95 to first audible word.
- **Bandwidth.** A video stream is roughly 0.8 to 1.5 Mbps against roughly 40 kbps for audio plus timing data. This is a real cost to customers on metered mobile plans, which is one reason the audio-only mode is a first class citizen and not a degraded afterthought.
- **Higher run cost.** Server-side synthesis is metered per minute of generated video. This is the single largest variable cost line in the Phase 1 cloud budget.
- **Network sensitivity.** Poor connectivity degrades video before it degrades audio, so the degradation path must be designed rather than left to chance.

### Neutral

- Both options require the same speech recognition, reasoning and grounding stack. This decision does not affect the Assurance, Reasoning or Knowledge planes at all.

## Alternatives considered

| Option | Assessment |
|---|---|
| **On-device 3D rendering** | Rejected for Phase 1. Lower marginal cost and lower latency once loaded, but excludes low-end devices, ships an extractable brand asset, requires an app release to change behaviour, and creates per-platform rendering inconsistency that makes accessibility conformance harder to evidence. Retained as a Phase 3 cost optimisation for high-volume devices. |
| **Static image plus voice** | Rejected as the primary experience, adopted as a fallback rung. Cheapest and most robust, but user research indicated the presence effect that drives comprehension gains for our target cohorts is largely lost. |
| **Pre-rendered video segments** | Rejected. Cannot support open-ended generated responses. Would force a scripted experience, which defeats the purpose. |

## Compliance and accessibility implications

- **WCAG 2.2.** Cloud rendering makes conformance easier to evidence because captions, audio description and contrast are produced once, server side, rather than per device. See FB-KORU-103.
- **Motion sensitivity.** Server-side control lets us honour a reduced-motion preference by lowering expression amplitude without an app change.
- **Bandwidth equity.** A video-first experience disadvantages customers on constrained or metered connections. The audio-only and text-only paths are mandatory, not optional. This is stated as a design law in FB-KORU-103.
- **Data residency.** Synthesis occurs in-jurisdiction. Audio and video are not persisted as media. Only the transcript and metadata are written to the Ledger. See ADR-0013.

## Degradation path

The client and Orchestrator negotiate down automatically on measured conditions:

| Rung | Condition | Experience |
|---|---|---|
| 1 | Healthy | Avatar video and audio |
| 2 | Sustained packet loss above 5 percent, or customer preference | Audio only with a static presence indicator |
| 3 | Media session cannot be established | Grounded text conversation |
| 4 | Reasoning unavailable | Scripted responses and channel redirection |

Rungs 2 and 3 are also directly selectable by the customer at any time, permanently, from a single control.

## Reversibility

Moderate. The Orchestrator's media abstraction isolates synthesis behind an interface. Moving to on-device rendering requires a new client capability and an app release cycle, but no change to the Assurance, Reasoning or Knowledge planes. Estimated 1 to 2 quarters.

---

## Related documents

- [Solution architecture](../solution-architecture.md) (FB-KORU-200)
- [Accessibility and inclusion](../../01-experience/accessibility-and-inclusion.md) (FB-KORU-103)
- [Service levels](../../05-operations/service-levels.md) (FB-KORU-500)
- [Cost model](../../06-delivery/cost-model.md) (FB-KORU-601)
