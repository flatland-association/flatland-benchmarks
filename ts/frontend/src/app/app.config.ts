import { provideHttpClient, withInterceptorsFromDi } from '@angular/common/http'
import { ApplicationConfig, ErrorHandler, provideZoneChangeDetection } from '@angular/core'
import { provideRouter } from '@angular/router'
import { routes } from './app.routes'
import { shimRouterLastSuccessfulNavigation } from './features/compat/router-last-successful-navigation-shim'
import { ErrorHandlerService } from './features/error-handler/error-handler.service'

shimRouterLastSuccessfulNavigation()

export const appConfig: ApplicationConfig = {
  providers: [
    provideZoneChangeDetection({ eventCoalescing: true }),
    provideRouter(routes),
    provideHttpClient(withInterceptorsFromDi()),
    { provide: ErrorHandler, useClass: ErrorHandlerService },
  ],
}
