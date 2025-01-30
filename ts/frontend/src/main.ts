import { bootstrapApplication } from '@angular/platform-browser'
import { provideOAuthClient } from 'angular-oauth2-oidc'
import { AppComponent } from './app/app.component'
import { appConfig } from './app/app.config'

appConfig.providers.push(provideOAuthClient())

bootstrapApplication(AppComponent, appConfig).catch((err) => console.error(err))
