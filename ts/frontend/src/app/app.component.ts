import { Component, inject, OnInit } from '@angular/core'
import { RouterOutlet } from '@angular/router'
import { FooterNavLink, HeaderNavLink, LayoutComponent } from '@flatland-association/flatland-ui'
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

  headerNavItems: HeaderNavLink[] = []
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
      {
        path: '/my-submissions',
        label: 'My submissions',
      },
      { path: '/hub', label: 'Hub', icon: faArrowUpRightFromSquare },
    ]
  }
}
