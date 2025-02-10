import { Injectable } from '@angular/core'
import { Router } from '@angular/router'
import { OAuthService } from 'angular-oauth2-oidc'
import { first } from 'rxjs/operators'
import { environment } from '../../../environments/environment'

@Injectable({
  providedIn: 'root',
})
export class AuthService {
  // Promise that resolves once the login has been successful.
  // This only works for forceful logins.
  readonly initialized?: Promise<unknown>

  constructor(
    public oauthService: OAuthService,
    private router: Router,
  ) {
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
    // As soon as a token is received, redirect to the passed state.
    this.oauthService.events.pipe(first((e) => e.type === 'token_received')).subscribe(() => {
      const state = decodeURIComponent(this.oauthService.state || '')
      if (state && state !== '/') {
        this.router.navigate([state])
      }
    })
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
  logIn(state: string) {
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

  async hasRole(role: string) {
    // Await the successful login of the user.
    await this.initialized
    // Using indexOf for IE11 compatibility.
    return this.claims && Array.isArray(this.claims.roles) && this.claims.roles.indexOf(role) >= 0
  }
}
