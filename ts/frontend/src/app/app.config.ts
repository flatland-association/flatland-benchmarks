import { provideHttpClient, withInterceptorsFromDi } from '@angular/common/http'
import { ApplicationConfig, ErrorHandler, provideZoneChangeDetection } from '@angular/core'
import { provideRouter } from '@angular/router'
import { routes } from './app.routes'
import { ErrorHandlerService } from './features/error-handler/error-handler.service'

export const appConfig: ApplicationConfig = {
  providers: [
    provideZoneChangeDetection({ eventCoalescing: true }),
    provideRouter(routes),
    provideHttpClient(withInterceptorsFromDi()),
    { provide: ErrorHandler, useClass: ErrorHandlerService },
  ],
}
