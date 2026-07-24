import { Router } from '@angular/router'

// @angular/router 21 changed `Router.lastSuccessfulNavigation` from a plain
// `Navigation | null` getter to `Signal<Navigation | null>`. Consumer code
// still compiled against Angular 20 (e.g. @flatland-association/flatland-ui@2.3.0's
// HeaderComponent) reads it the old way, e.g. `router.lastSuccessfulNavigation?.finalUrl`,
// which now reads `.finalUrl` off the signal function itself instead of calling
// it first - always `undefined`. This wraps the signal in a Proxy that also
// exposes the underlying Navigation's properties directly, so old-style
// property access keeps working. Remove once flatland-ui ships an Angular
// 21-compatible build.
export function shimRouterLastSuccessfulNavigation() {
  const descriptor = Object.getOwnPropertyDescriptor(Router.prototype, 'lastSuccessfulNavigation')
  const originalGetter = descriptor?.get
  if (!originalGetter) return

  Object.defineProperty(Router.prototype, 'lastSuccessfulNavigation', {
    ...descriptor,
    get(this: Router) {
      const signalFn = originalGetter.call(this)
      return new Proxy(signalFn, {
        get(target, prop, receiver) {
          if (prop in target) return Reflect.get(target, prop, receiver)
          const navigation = target()
          return navigation ? Reflect.get(navigation, prop) : undefined
        },
      })
    },
  })
}
