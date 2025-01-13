import { Routes } from '@angular/router'
import { ImpressumView, NotFoundView, PrivacyView } from '@flatland-association/flatland-ui'
import { HomeView } from './views/home/home.view'

export const routes: Routes = [
  { path: '', pathMatch: 'full', redirectTo: 'home' },
  { path: 'home', component: HomeView },
  {
    path: 'association',
    redirectTo: () => {
      location.href = 'https://flatland-association.org'
      return 'home'
    },
  },
  { path: 'impressum', component: ImpressumView },
  { path: 'privacy', component: PrivacyView },
  { path: '**', component: NotFoundView },
]
