import { TestBed } from '@angular/core/testing'

import { HttpErrorResponse } from '@angular/common/http'
import { AuthService } from '../auth/auth.service'
import { ErrorHandlerService } from './error-handler.service'

describe('ErrorHandlerService', () => {
  let service: ErrorHandlerService
  let authServiceSpy: jasmine.SpyObj<AuthService>

  beforeEach(() => {
    authServiceSpy = jasmine.createSpyObj('AuthService', ['logIn'])

    TestBed.configureTestingModule({
      providers: [{ provide: AuthService, useValue: authServiceSpy }],
    })
    service = TestBed.inject(ErrorHandlerService)
  })

  it('should catch and handle HttpErrorResponse errors', () => {
    expect(() => service.handleError(new HttpErrorResponse({}))).not.toThrow()
  })

  it('should start login on HttpErrorResponse status 401', () => {
    expect(() => service.handleError(new HttpErrorResponse({ status: 401 }))).not.toThrow()
    expect(authServiceSpy.logIn).toHaveBeenCalled()
  })

  it('should pass through other errors', () => {
    const error = new Error()
    expect(() => service.handleError(error)).toThrow(error)
  })
})
