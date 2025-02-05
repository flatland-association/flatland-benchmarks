import { Injectable } from '@angular/core'
import { ActivatedRouteSnapshot, CanActivate, GuardResult, RouterStateSnapshot } from '@angular/router'
import { AuthService } from '../features/auth/auth.service'

@Injectable({
  providedIn: 'root',
})
/**
 * Class providing guard functions to be used in routes.
 */
export class AuthGuard implements CanActivate {
  constructor(private authService: AuthService) {}

  /**
   * The default `CanActivateFn`, checks if current user is logged in. If the
   * user is not logged in, a login flow is started, redirecting the user to
   * the login form.
   */
  async canActivate(route: ActivatedRouteSnapshot, state: RouterStateSnapshot): Promise<GuardResult> {
    if (this.authService.isLoggedIn()) return true
    this.authService.logIn(state.url)
    // result doesn't matter - initLoginFlow redirects to login page
    return false
  }
}
