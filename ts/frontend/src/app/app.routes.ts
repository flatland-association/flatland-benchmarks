import { Routes } from '@angular/router'
import { ImpressumView, NotFoundView, PrivacyView } from '@flatland-association/flatland-ui'
import { AuthGuard } from './guards/auth.guard'
import { BenchmarkGroupView } from './views/benchmark-group/benchmark-group.view'
import { BenchmarksDetailView } from './views/benchmarks-detail/benchmarks-detail.view'
import { HomeView } from './views/home/home.view'
import { MySubmissionsView } from './views/my-submissions/my-submissions.view'
import { NewSubmissionView } from './views/new-submission/new-submission.view'
import { ParticipateView } from './views/participate/participate.view'
import { SubmissionView } from './views/submission/submission.view'
import { VcCampaignView } from './views/vc-campaign/vc-campaign.view'
import { VcEvaluationObjectiveView } from './views/vc-evaluation-objective/vc-evaluation-objective.view'
import { VcKpiView } from './views/vc-kpi/vc-kpi.view'
import { VcMySubmissionsView } from './views/vc-my-submissions/vc-my-submissions.view'
import { VcNewSubmissionView } from './views/vc-new-submission/vc-new-submission.view'
import { VcResultsView } from './views/vc-results/vc-results.view'
import { VcSubmissionView } from './views/vc-submission/vc-submission.view'

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
  {
    path: 'hub',
    redirectTo: () => {
      location.href = 'https://www.flatland.cloud'
      return 'home'
    },
  },
  { path: 'benchmarks', pathMatch: 'full', redirectTo: 'home' },
  { path: 'benchmarks/:group_id', component: BenchmarkGroupView, canActivate: [AuthGuard] },
  // TODO: generalize/clean up
  // see: https://github.com/flatland-association/flatland-benchmarks/issues/323
  { path: 'fab-benchmarks/:id', component: BenchmarksDetailView },
  {
    path: 'fab-benchmarks/:id/participate',
    component: ParticipateView,
    canActivate: [AuthGuard],
  },
  {
    path: 'fab-benchmarks/:id/participate/new-submission',
    component: NewSubmissionView,
    canActivate: [AuthGuard],
  },
  {
    path: 'fab-benchmarks/:id/participate/submissions',
    pathMatch: 'full',
    redirectTo: 'fab-benchmarks/:id/participate',
  },
  {
    path: 'fab-benchmarks/:id/participate/submissions/:submission',
    component: SubmissionView,
    canActivate: [AuthGuard],
  },
  { path: 'vc-campaign/:group_id', component: VcCampaignView, canActivate: [AuthGuard] },
  { path: 'vc-evaluation-objective/:benchmark_id', component: VcEvaluationObjectiveView, canActivate: [AuthGuard] },
  {
    path: 'vc-evaluation-objective/:benchmark_id/my-submissions',
    component: VcMySubmissionsView,
    canActivate: [AuthGuard],
  },
  { path: 'vc-evaluation-objective/:benchmark_id/:test_id', component: VcKpiView, canActivate: [AuthGuard] },
  {
    path: 'vc-evaluation-objective/:benchmark_id/:test_id/new-submission',
    component: VcNewSubmissionView,
    canActivate: [AuthGuard],
  },
  {
    path: 'submissions/:submission_id',
    component: VcSubmissionView,
    canActivate: [AuthGuard],
  },
  {
    path: 'submissions/:submission_id/results/:test_id/:scenario_id',
    component: VcResultsView,
    canActivate: [AuthGuard],
  },
  {
    path: 'my-submissions',
    component: MySubmissionsView,
    canActivate: [AuthGuard],
  },
  { path: 'impressum', component: ImpressumView },
  { path: 'privacy', component: PrivacyView },
  { path: '**', component: NotFoundView },
]
