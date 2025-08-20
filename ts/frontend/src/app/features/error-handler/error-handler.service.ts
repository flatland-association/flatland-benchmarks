import { HttpErrorResponse } from '@angular/common/http'
import { ErrorHandler, inject, Injectable } from '@angular/core'
import { AuthService } from '../auth/auth.service'
import { ErrorMessageService } from '../error-message/error-message.service'

@Injectable({
  providedIn: 'root',
})
export class ErrorHandlerService implements ErrorHandler {
  private authService = inject(AuthService)
  private errorMessageService = inject(ErrorMessageService)

  handleError(error: unknown): void {
    // Not using an HttpInterceptor for http error handling to have finer
    // control of when this global handler takes effect. I.e. it will only be
    // invoked if an HttpErrorResponse was not handled by another `.catch`,
    // making it the default behavior, which can be simply overridden by
    // providing a custom handler where the request is being made.
    if (error instanceof HttpErrorResponse) {
      console.warn('Globally handling HttpErrorResponse', error)
      if (error.status === 401) {
        this.authService.logIn()
      } else if (error.status >= 400) {
        this.errorMessageService.errorMessage.set({
          title: `HTTP Error ${error.status} - ${error.statusText}`,
          message: error.message,
        })
      } else {
        console.error(`No global handler for status ${error.status} defined`)
      }
      return
    }
    // the super global error handler prints unhandled exceptions to the console
    throw error
  }
}
