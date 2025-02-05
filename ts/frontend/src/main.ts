import { bootstrapApplication } from '@angular/platform-browser'
import { provideOAuthClient } from 'angular-oauth2-oidc'
import { AppComponent } from './app/app.component'
import { appConfig } from './app/app.config'
import { environment } from './environments/environment'

appConfig.providers.push(
  provideOAuthClient({
    resourceServer: {
      allowedUrls: [environment.apiBase],
      sendAccessToken: true,
    },
  }),
)

bootstrapApplication(AppComponent, appConfig).catch((err) => console.error(err))
