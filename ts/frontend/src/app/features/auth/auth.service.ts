import { Injectable, inject } from '@angular/core'
import { Router } from '@angular/router'
import { OAuthService } from 'angular-oauth2-oidc'
import { Observable, ReplaySubject } from 'rxjs'
import { environment } from '../../../environments/environment'

export type AuthState = 'loggedin' | 'loggedout'

@Injectable({
  providedIn: 'root',
})
export class AuthService {
  oauthService = inject(OAuthService)
  private router = inject(Router)

  private _authState = new ReplaySubject<AuthState>(1)

  constructor() {
    // expose service for debugging purposes
    //@ts-expect-error any
    window['authService'] = this
    // silently fail if no config was provided
    if (!environment.authConfig) return
    this.oauthService.configure(environment.authConfig)
    this.oauthService.setupAutomaticSilentRefresh()
    // Try logging user in, don't start login flow if it doesn't work.
    // To start the login flow, call `logIn()`.
    this.oauthService.loadDiscoveryDocumentAndTryLogin()
    // Update auth state when auth service events occur
    this.oauthService.events.subscribe((e) => {
      switch (e.type) {
        // successfully logged in when a token is received
        case 'token_received': {
          this._authState.next('loggedin')
          // if a state was passed, use that for redirect
          const state = decodeURIComponent(this.oauthService.state || '')
          if (state && state !== '/') {
            this.router.navigate([state])
          }
          break
        }
        // logged out on explicit logout and token errors
        case 'logout':
        case 'token_error':
        case 'token_validation_error':
        case 'token_refresh_error': {
          this._authState.next('loggedout')
          break
        }
      }
    })
    // It's also possible that the locally stored token is still valid, treat
    // this as being logged in
    if (this.isLoggedIn()) {
      this._authState.next('loggedin')
    }
  }

  /**
   * Returns the `AuthState` as observable.
   */
  getAuthState() {
    return this._authState as Observable<AuthState>
  }

  /**
   * Returns whether the user is logged in.
   */
  isLoggedIn() {
    // assume user is logged in if in possession of valid token
    return this.oauthService.hasValidAccessToken()
  }

  /**
   * Starts the login flow. This function will redirect the user to the login
   * form.
   * @param state State passed around during login, used as redirect url on success.
   */
  logIn(state?: string) {
    this.oauthService.initLoginFlow(state)
  }

  /**
   * Logs user out and redirects them to home.
   */
  logOut() {
    return this.oauthService.logOut(false)
  }

  /**
   * Returns the UUID of currently logged in user.
   */
  get userUuid(): string | undefined {
    const claims = this.oauthService.getIdentityClaims()
    return claims['sub']
  }

  get claims(): { email: string; name: string; roles: string[] } {
    return this.oauthService.getIdentityClaims() as {
      email: string
      name: string
      roles: string[]
    }
  }

  get scopes(): string[] {
    return this.oauthService.getGrantedScopes() as string[]
  }
}
