import { Component, inject, OnInit } from '@angular/core'
import { Router, RouterOutlet } from '@angular/router'
import { FooterNavLink, HeaderNavLink, HeaderUserMenu, LayoutComponent } from '@flatland-association/flatland-ui'
import { faArrowUpRightFromSquare } from '@fortawesome/free-solid-svg-icons'
import { OAuthModule } from 'angular-oauth2-oidc'
import { ApiService } from './features/api/api.service'
import { AuthService } from './features/auth/auth.service'
import { CustomizationService } from './features/customization/customization.service'

@Component({
  selector: 'app-root',
  imports: [RouterOutlet, LayoutComponent, OAuthModule],
  templateUrl: './app.component.html',
  styleUrl: './app.component.scss',
})
export class AppComponent implements OnInit {
  private _apiService = inject(ApiService)
  private authService = inject(AuthService)
  private customizationService = inject(CustomizationService)
  private router = inject(Router)

  headerNavItems: HeaderNavLink[] = []
  headerUserMenu?: HeaderUserMenu
  footerNavItems: FooterNavLink[] = [
    { path: '/impressum', label: 'Impressum' },
    { path: '/privacy', label: 'Privacy' },
  ]

  async ngOnInit() {
    this.headerNavItems = [
      {
        path: '/home',
        label: 'Home',
        lead: (await this.customizationService.getCustomization()).content.title,
      },
      { path: '/hub', label: 'Hub', icon: faArrowUpRightFromSquare },
    ]

    // initially show the user menu without active user
    this.showLoggedOutUserMenu()
    // update user menu when auth state changes
    this.authService.getAuthState().subscribe((state) => {
      if (state === 'loggedin') {
        this.showLoggedInUserMenu()
      } else {
        this.showLoggedOutUserMenu()
      }
    })
  }

  // sets the user menu to be shown when a user is logged in
  showLoggedInUserMenu() {
    this.headerUserMenu = {
      username: this.authService.claims.name,
      items: [
        {
          path: '/my-submissions',
          label: 'My submissions',
        },
      ],
      onLogoutClick: () => {
        this.authService.logOut()
      },
    }
  }

  // sets the user menu to be shown when no user is logged in
  showLoggedOutUserMenu() {
    this.headerUserMenu = {
      onLoginClick: () => {
        // pass the current url as state (to navigate back after login) for
        // seamless login experience
        this.authService.logIn(this.router.routerState.snapshot.url)
      },
    }
  }
}
