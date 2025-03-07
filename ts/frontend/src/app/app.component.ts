import { Component } from '@angular/core'
import { RouterOutlet } from '@angular/router'
import { FooterNavLink, HeaderNavLink, LayoutComponent } from '@flatland-association/flatland-ui'
import { faArrowUpRightFromSquare } from '@fortawesome/free-solid-svg-icons'
import { OAuthModule } from 'angular-oauth2-oidc'
import { ApiService } from './features/api/api.service'
import { AuthService } from './features/auth/auth.service'

@Component({
  selector: 'app-root',
  imports: [RouterOutlet, LayoutComponent, OAuthModule],
  templateUrl: './app.component.html',
  styleUrl: './app.component.scss',
})
export class AppComponent {
  headerNavItems: HeaderNavLink[] = [
    {
      path: '/home',
      label: 'Home',
      lead: 'Flatland Benchmarks',
    },
    { path: '/hub', label: 'Hub', icon: faArrowUpRightFromSquare },
  ]
  footerNavItems: FooterNavLink[] = [
    { path: '/impressum', label: 'Impressum' },
    { path: '/privacy', label: 'Privacy' },
  ]

  // this is to prevent tree-shaking ApiService
  constructor(
    private _apiService: ApiService,
    private authService: AuthService,
  ) {}
}
