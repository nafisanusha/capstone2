# Requirements and next steps

## Confirmed project boundary from the supplied description

Museum Gateway is a proof of concept for The Wolfsonian-FIU. The supplied description records Product Owner Mark Osterman confirming on August 18, 2026 that no real payments or real customer data should be used. The project calls for admission, entry QR codes, exhibition/program information, a building map and at least one thematic pathway, with kiosk usability and accessibility requirements.

This draft is not Product Owner approval. Its examples and acceptance measures must be reviewed with the team and Product Owner.

## Visitor needs traced into requirements

| ID | Visitor need | Requirement / acceptance evidence | Current implementation |
|---|---|---|---|
| MG-01 | Begin a visit independently | From the welcome page, reach admission without a keyboard | Implemented; admission widget test passed in GitHub Actions |
| MG-02 | Admit a party | Choose a category and 1–8 guests; show a correct demo total | Implemented with example categories/prices |
| MG-03 | Understand payment success/failure | Approved sandbox payment produces one ticket; declined payment produces none | Local simulation implemented; provider sandbox still required |
| MG-04 | Receive a unique entry token | Display a scannable QR containing a unique ticket identifier | Demo QR implemented; server issuance/entry validation not implemented |
| MG-05 | Discover exhibitions | Home → Explore → exhibition details is an end-to-end thin slice | Implemented with fictional content |
| MG-06 | Find programs | Display programs and their verified schedule/location | Sample program listings implemented; schedules unconfirmed |
| MG-07 | Navigate the building | Select a level and locate galleries/amenities using a verified floor plan | Illustrative layout implemented; verified floor plan and routing still needed |
| MG-08 | Explore by theme | Follow at least one staff-approved thematic path | Sample Design & ideas route implemented; real stops/directions need approval |
| MG-09 | Read and operate a kiosk | Large touch controls, scalable text, screen-reader labels; validate with device/hardware tests | Phone/tablet large-text widget checks passed; manual accessibility testing pending |
| MG-10 | Begin a fresh session | Explicit reset removes the demo ticket and resets navigation | Implemented; persistence/reset tests passed in GitHub Actions |

## Decisions to confirm with Mark

1. Museum ticket categories, free-admission eligibility, prices, and how eligibility is demonstrated without collecting personal records.
2. Museum-approved exhibition/program content and how staff will update it.
3. Real floor plans, accessible paths, kiosk location, hardware dimensions and orientation.
4. Exact QR entry-validation experience and whether a separate simulated scanner is required.
5. Payment provider for test mode; account ownership and sandbox configuration.
6. Accessibility acceptance criteria and participants for usability testing.
7. Team's end-to-end slice and boundaries with any other teams.

## Remaining work before calling this the semester deliverable

- Replace sample content and map with approved museum data and actionable directions.
- Implement a payment provider's sandbox backend; keep provider secrets on the server.
- Persist tickets in a backend and add demo entry validation with expiry and duplicate-scan handling. Local storage is not an admission authority.
- Add confirmed staff content-management requirements if included in the team slice.
- Maintain the passing test suite; complete phone/tablet visual QA, screen-reader checks, and real kiosk trials.
- Define automatic visitor-session timeout with the Product Owner. Current reset is manual.
- Configure app identifiers, signing, release icons, deployment and any required privacy documentation before store release.

Personalized recommendations, multiple languages, staff analytics and deeper Store/Coffee Bar integration are stretch work, not completed features.

## Suggested five-sprint plan

1. Validate the problem and visitor needs; approve traceability and the Home → Explore → detail thin slice.
2. Implement approved catalog content and admission/payment sandbox flow.
3. Build the ticket service and simulated entry validation; integrate the real building map.
4. Complete thematic routes and kiosk/accessibility testing; refine from observed visitor feedback.
5. Resolve defects, complete end-to-end evidence, documentation, handoff and final demonstration.

Record actual team contributions and Product Owner feedback. Do not submit this draft as evidence that a meeting or runtime test occurred.
