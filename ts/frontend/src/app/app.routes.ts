import { Routes } from '@angular/router'
import { ImpressumView, NotFoundView, PrivacyView } from '@flatland-association/flatland-ui'
import { AuthGuard } from './guards/auth.guard'
import { BenchmarksDetailView } from './views/benchmarks-detail/benchmarks-detail.view'
import { BenchmarkView } from './views/benchmarks/benchmarks.view'
import { HomeView } from './views/home/home.view'

export const routes: Routes = [
  { path: '', pathMatch: 'full', redirectTo: 'home' },
  { path: 'home', component: HomeView },
  { path: 'benchmarks', component: BenchmarkView, canActivate: [AuthGuard] },
  {
    path: 'association',
    redirectTo: () => {
      location.href = 'https://flatland-association.org'
      return 'home'
    },
  },
  { path: 'benchmarks/:id', component: BenchmarksDetailView, canActivate: [AuthGuard] },
  { path: 'impressum', component: ImpressumView },
  { path: 'privacy', component: PrivacyView },
  { path: '**', component: NotFoundView },
]
