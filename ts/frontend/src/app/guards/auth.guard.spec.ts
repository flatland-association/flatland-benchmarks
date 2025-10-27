import { TestBed } from '@angular/core/testing'

import { AuthService } from '../features/auth/auth.service'
import { AuthGuard } from './auth.guard'

describe('AuthGuard', () => {
  let authServiceStub: { isLoggedIn: () => unknown; logIn: (url: string) => unknown }
  let guard: AuthGuard

  beforeEach(() => {
    authServiceStub = {
      isLoggedIn: () => true,
      logIn: (_url: string) => {
        /* */
      },
    }
    TestBed.configureTestingModule({
      providers: [{ provide: AuthService, useValue: authServiceStub }],
    })
    guard = TestBed.inject(AuthGuard)
  })

  it('should be created', () => {
    expect(guard).toBeTruthy()
  })

  it('should return true if logged in', async () => {
    //@ts-expect-error ActivatedRouteSnapshot
    expect(await guard.canActivate({}, { url: '/test' })).toBe(true)
  })

  it('should start login flow if not logged in', async () => {
    spyOn(authServiceStub, 'isLoggedIn').and.returnValue(false)
    const logInSpy = spyOn(authServiceStub, 'logIn').and.returnValue(undefined)
    //@ts-expect-error ActivatedRouteSnapshot
    await guard.canActivate({}, { url: '/test' })
    expect(logInSpy).toHaveBeenCalledTimes(1)
    expect(logInSpy).toHaveBeenCalledWith('/test')
  })
})
