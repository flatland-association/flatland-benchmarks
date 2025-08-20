import { Injectable, signal } from '@angular/core'

// This service is not part of ErrorHandlerService because that one's
// constructed twice; once as ErrorHandler and once as service if injected
// explicitly. To prevent that, use this service here which will then be a
// singleton service (i.e. constructed only once).

export interface ErrorMessage {
  title: string
  message: string
}

@Injectable({
  providedIn: 'root',
})
export class ErrorMessageService {
  errorMessage = signal<ErrorMessage | undefined>(undefined)
}
