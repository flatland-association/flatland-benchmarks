import { TestBed } from '@angular/core/testing'

import { provideHttpClient } from '@angular/common/http'
import { Router } from '@angular/router'
import { OAuthEvent, OAuthService, OAuthSuccessEvent } from 'angular-oauth2-oidc'
import { firstValueFrom, Subject } from 'rxjs'
import { AuthService } from './auth.service'

interface Context {
  service: AuthService
  oauthServiceStub: Partial<OAuthService>
  oauthServiceEvents: Subject<OAuthEvent>
  routerSpy: jasmine.SpyObj<Router>
}

function setupTestBed(options?: { initialAccessToken?: boolean }): Context {
  // stub OAuthService
  const oauthServiceEvents = new Subject<OAuthEvent>()
  const oauthServiceStub = {
    configure: () => undefined,
    setupAutomaticSilentRefresh: () => undefined,
    loadDiscoveryDocumentAndTryLogin: async () => true,
    hasValidAccessToken: () => options?.initialAccessToken ?? false,
    initImplicitFlowInPopup: async (..._args: unknown[]) => true,
    state: undefined,
    events: oauthServiceEvents,
  }
  // spy on router
  const routerSpy = jasmine.createSpyObj('Router', ['navigate'])
  routerSpy.navigate.and.resolveTo(true)

  TestBed.configureTestingModule({
    providers: [
      provideHttpClient(),
      { provide: OAuthService, useValue: oauthServiceStub },
      { provide: Router, useValue: routerSpy },
    ],
  })
  const service = TestBed.inject(AuthService)

  return {
    service,
    oauthServiceStub,
    oauthServiceEvents,
    routerSpy,
  }
}

describe('AuthService', () => {
  describe('OAuth integration', () => {
    let context: Context

    beforeEach(() => {
      context = setupTestBed()
    })

    it('should be created', () => {
      expect(context.service).toBeTruthy()
    })

    it('should update auth state on login/logout', async () => {
      context.oauthServiceEvents.next(new OAuthSuccessEvent('token_received'))
      expect(await firstValueFrom(context.service.getAuthState())).toBe('loggedin')
      context.oauthServiceEvents.next(new OAuthSuccessEvent('logout'))
      expect(await firstValueFrom(context.service.getAuthState())).toBe('loggedout')
    })

    it('should redirect on login only when a state was passed', async () => {
      // try once with state
      context.oauthServiceStub.state = '/some-route'
      context.oauthServiceEvents.next(new OAuthSuccessEvent('token_received'))
      // This little trick is used to make the engine hand over to the task queue,
      // where observable callbacks are called:
      await Promise.resolve()
      expect(context.routerSpy.navigate).toHaveBeenCalledTimes(1)
      expect(context.routerSpy.navigate).toHaveBeenCalledWith(jasmine.stringMatching('/some-route'))
      //... once without
      context.oauthServiceStub.state = undefined
      context.oauthServiceEvents.next(new OAuthSuccessEvent('token_received'))
      await Promise.resolve()
      expect(context.routerSpy.navigate).toHaveBeenCalledTimes(1)
      //... and again once with
      context.oauthServiceStub.state = '/some-other-route'
      context.oauthServiceEvents.next(new OAuthSuccessEvent('token_received'))
      await Promise.resolve()
      expect(context.routerSpy.navigate).toHaveBeenCalledTimes(2)
      expect(context.routerSpy.navigate).toHaveBeenCalledWith(jasmine.stringMatching('/some-other-route'))
    })
  })

  describe('OAuth integration with automatic refresh', () => {
    let context: Context

    beforeEach(() => {
      context = setupTestBed({ initialAccessToken: true })
    })

    it('should have loggedin state after creation', async () => {
      expect(await firstValueFrom(context.service.getAuthState())).toBe('loggedin')
    })
  })

  describe('redirect after login', () => {
    let context: Context

    beforeEach(() => {
      context = setupTestBed()
    })

    it('should navigate after login', async () => {
      spyOn(window, 'open').and.returnValue(null)
      await context.service.logIn('/test-route')
      expect(context.routerSpy.navigate).toHaveBeenCalledWith(['/test-route'])
    })
  })
})
