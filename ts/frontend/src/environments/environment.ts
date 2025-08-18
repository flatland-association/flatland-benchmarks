import { AuthConfig } from 'angular-oauth2-oidc'

const authConfig: AuthConfig = {
  issuer: 'https://keycloak.flatland.cloud/realms/flatland',
  // The ClientId you received from the IAM Team
  clientId: 'fab',
  // For production with Angular i18n the language code needs to be included in the redirectUri.
  // In your environment.prod.ts (or similar, but not your environment.ts) replace it with the following line:
  // redirectUri: location.origin + location.pathname.substring(0, location.pathname.indexOf('/', 1) + 1)
  // Note that these URIs must also be added to allowed redirect URIs in Azure (e.g. https://your-domain/en/, https://your-domain/de/, ...)
  redirectUri: location.origin,
  silentRefreshRedirectUri: window.location.origin + '/silent-refresh.html',
  responseType: 'code',
  scope: 'openid profile email offline_access',
}

export const environment = {
  // API base URL
  apiBase: `${location.protocol}//${location.hostname}:8000`,
  // auth configuration or null if none is used
  authConfig,
}
