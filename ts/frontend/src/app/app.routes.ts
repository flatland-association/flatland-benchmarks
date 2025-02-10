import { Routes } from '@angular/router'
import { ImpressumView, NotFoundView, PrivacyView } from '@flatland-association/flatland-ui'
import { AuthGuard } from './guards/auth.guard'
import { BenchmarksDetailView } from './views/benchmarks-detail/benchmarks-detail.view'
import { BenchmarkView } from './views/benchmarks/benchmarks.view'
import { HomeView } from './views/home/home.view'
import { NewSubmissionView } from './views/new-submission/new-submission.view'
import { ParticipateView } from './views/participate/participate.view'
import { SubmissionView } from './views/submission/submission.view'

export const routes: Routes = [
  { path: '', pathMatch: 'full', redirectTo: 'home' },
  { path: 'home', component: HomeView },
  { path: 'benchmarks', component: BenchmarkView },
  {
    path: 'association',
    redirectTo: () => {
      location.href = 'https://flatland-association.org'
      return 'home'
    },
  },
  { path: 'benchmarks/:id', component: BenchmarksDetailView },
  {
    path: 'benchmarks/:id/participate',
    component: ParticipateView,
    canActivate: [AuthGuard],
  },
  {
    path: 'benchmarks/:id/participate/new-submission',
    component: NewSubmissionView,
    canActivate: [AuthGuard],
  },
  {
    path: 'benchmarks/:id/participate/submissions/:submission',
    component: SubmissionView,
    canActivate: [AuthGuard],
  },
  { path: 'impressum', component: ImpressumView },
  { path: 'privacy', component: PrivacyView },
  { path: '**', component: NotFoundView },
]
