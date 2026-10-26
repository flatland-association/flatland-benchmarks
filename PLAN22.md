# Angular 22 upgrade: analysis and plan

_Written 2026-10-26._

## Background

Dependabot PR #736 ("bump undici and @angular/build") raised `@angular/build` from 21.2.20
to 22.2.4 to pull in `undici` 7.30.1 (security fixes). `ng test` then failed:

> The current version of "@angular/build" supports Angular versions ^22.0.0, but detected Angular version 21.2.20 instead.

Fix (commit `8b5901b` on `dependabot/npm_and_yarn/multi-39b2da24a5`): keep `@angular/build` at
`^21.2.28` and raise the existing root `overrides["@angular/build"].undici` from `^7.29.0` to `^7.30.1`.
The lockfile now resolves `@angular/build` 21.2.28 and `undici` 7.30.1.
Verified: `ng build` and `ng test` (26/26) pass under Node 22.

## Do we need to upgrade now? No.

Angular supports each major for 24 months: 12 months active, then 12 months LTS
("only critical fixes and security patches"). Source: https://angular.dev/reference/releases

| Version | Released   | Active until | LTS (security fixes) until |
|---------|------------|--------------|----------------------------|
| 21      | 2025-11-19 | 2026-06-03   | **2027-06**                |
| 22      | 2026-06-03 | 2027-06      | 2028-06                    |

21.x patches are still being published (`v21-lts` dist-tag at 21.2.25, `@angular/build` at 21.2.28).
**Deadline: be on 22 (or 23) before June 2027.**

## Current state (ts/frontend)

- 41 TS files, about 3,900 lines of TS and HTML, 20 components, all standalone. No NgModules.
- Zone-based: `provideZoneChangeDetection({ eventCoalescing: true })`, plus `zone.js` polyfills in `angular.json`.
- **No component sets `changeDetection`** (0 of 20).
- 16 spots with `subscribe(` / `setTimeout` / `markForCheck`, all candidates for OnPush staleness.
- TypeScript `~5.9.3`.
- Version mismatch: `@angular/cli` is already on `^22.2.3`, while the rest of Angular is on 21.
- `src/app/features/compat/router-last-successful-navigation-shim.ts` patches `Router.lastSuccessfulNavigation`
  so that `flatland-ui` (built against Angular 20) keeps working on Angular 21.

## Angular 22.0.0 breaking changes vs. this codebase

Source: https://github.com/angular/angular/blob/main/CHANGELOG.md (22.0.0)

### Affects us

| Change | Impact |
|---|---|
| Components without `changeDetection` default to **OnPush** (`ChangeDetectionStrategy.Eager` restores the old behaviour) | All 20 components. Highest runtime risk: views that don't refresh. |
| **TypeScript < 6.0 unsupported** | TS major bump 5.9 → 6.x. Expect new type errors, and typescript-eslint/angular-eslint may need to follow. |
| Router `paramsInheritanceStrategy` defaults to `'always'` (was `'emptyOnly'`) | Check child routes that read params. Set `'emptyOnly'` explicitly via `withRouterConfig` if anything changes. |
| platform-browser removes styles that look unused by their host | Possible visual regressions where styles reach into other DOM (e.g. `flatland-ui` content). |
| New compiler diagnostics `nullishCoalescingNotNullable` / `optionalChainNotNullable` | Probably warnings in templates. Fix them, or disable temporarily in tsconfig. |
| http: `withFetch` deprecated (Fetch becomes the default); upload progress needs `withXhr` | We use `provideHttpClient(withInterceptorsFromDi())`. The backend switches to Fetch. Check interceptors and error handling. |

### Checked, not affected

`ComponentFactoryResolver`/`ComponentFactory`, `createNgModuleRef`, `checkNoChanges`, `provideRoutes`,
Hammer.js, `reportProgress`, string `min`/`max` bindings: none used.
`data-*` input binding change: only `[attr.data-link]` is used, which is a plain attribute binding and is fine.

### Library peer dependencies

| Package | Current | Needed for Angular 22 |
|---|---|---|
| `angular-oauth2-oidc` | ^20.0.2 | 22.x (peer `>=22`) |
| `@fortawesome/angular-fontawesome` | ^4.0.0 | 5.x (peer `^22`) |
| `@cypress/schematic` | ^4.2.0 | 6.x is available (peer `>=21`) |
| `angular-eslint` | 22.6.0 | already OK |
| `zone.js` | ^0.15.1 | OK (`~0.15 \|\| ~0.16`) |
| **`@flatland-association/flatland-ui`** | 2.3.0 | **Peer is still `^20.3`. This is the main risk.** Used in 12 files. Also depends on fontawesome 3.x. |

## Effort and risk

- **Code changes:** small. About 1 day of human time, or roughly 1–2 hours of Claude time
  (mostly waiting on `npm ci` and builds), plus about 1 hour of human review and click-through.
- **Risk:** medium. Problems show up at runtime, not at compile time:
  (a) OnPush views that don't refresh, (b) `flatland-ui` incompatibilities like the `lastSuccessfulNavigation` one.
  The 26 unit tests mostly don't cover rendering.

## Plan

### Now
1. Merge #736, which carries the fix (`@angular/build` ^21.2.28, `undici` override ^7.30.1).
2. Also in #736 (commit `3b5de84`): `.github/dependabot.yml` ignores Angular majors (`@angular/*`,
   `@angular-devkit/*`, `@schematics/angular`, `version-update:semver-major`), so Dependabot doesn't
   propose `@angular/build` 22 again. Remove these ignore rules as part of the upgrade.
3. Optional: align `@angular/cli` back to `^21` (or accept the mismatch until the upgrade).

### Prerequisite (owned by our org)
4. Release `flatland-ui` built against Angular 21/22: peer `^21 || ^22`, fontawesome 5,
   signal-based `router.lastSuccessfulNavigation()`. Then delete
   `router-last-successful-navigation-shim.ts` and its call in `app.config.ts`.

### Upgrade (target: first half of 2027, before June 2027)
5. Branch, then `npx ng update @angular/core@22 @angular/cli@22` and review what the migrations changed.
   Check whether `ng update` added `ChangeDetectionStrategy.Eager` to the components.
6. If it didn't, add `changeDetection: ChangeDetectionStrategy.Eager` to all 20 components,
   so behaviour stays the same.
7. Bump TypeScript to 6.x, plus `angular-oauth2-oidc` 22, `@fortawesome/angular-fontawesome` 5,
   `@cypress/schematic` 6 and the new `flatland-ui`. Fix compile, lint and template-diagnostic errors.
8. Router: decide on `paramsInheritanceStrategy` (set `'emptyOnly'` explicitly if any route depends on it).
9. Verify: `ng build`, `ng test`, Cypress e2e, then a manual click-through of login (OIDC),
   header navigation, tables (row links), suite cards, and error handling.
   Watch for stale views and missing styles.
10. Follow-up (separate PRs): move components to OnPush one at a time, using signals or
    `markForCheck` where needed. Remove `withFetch` if anything added it.
