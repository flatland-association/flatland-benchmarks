import { Routes } from '@angular/router'
import { ImpressumView, NotFoundView, PrivacyView } from '@flatland-association/flatland-ui'
import { Breadcrumb, BreadcrumbData } from './components/breadcrumbs/breadcrumbs.component'
import { AuthGuard } from './guards/auth.guard'
import { BenchmarkGroupView } from './views/benchmark-group/benchmark-group.view'
import { BenchmarkView } from './views/benchmark/benchmark.view'
import { HomeView } from './views/home/home.view'
import { MySubmissionsView } from './views/my-submissions/my-submissions.view'
import { NewSubmissionView } from './views/new-submission/new-submission.view'
import { SubmissionView } from './views/submission/submission.view'
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
  // TODO: rename to suites?
  // see: https://github.com/flatland-association/flatland-benchmarks/issues/402
  {
    path: 'benchmarks',
    data: { breadcrumbs: [Breadcrumb.HIDDEN] } satisfies BreadcrumbData,
    children: [
      { path: '', pathMatch: 'full', redirectTo: '/home' },
      {
        path: ':group_id',
        component: BenchmarkGroupView,
        canActivate: [AuthGuard],
        data: { breadcrumbs: [Breadcrumb.benchmark_group] } satisfies BreadcrumbData,
      },
      {
        path: ':group_id/:benchmark_id',
        component: BenchmarkView,
        canActivate: [AuthGuard],
        data: { breadcrumbs: [Breadcrumb.benchmark_group, Breadcrumb.benchmark] } satisfies BreadcrumbData,
      },
      {
        path: ':group_id/:benchmark_id/tests',
        pathMatch: 'full',
        redirectTo: ':group_id/:benchmark_id',
      },
      {
        path: ':group_id/:benchmark_id/tests/:test_id',
        component: VcKpiView,
        canActivate: [AuthGuard],
        data: {
          breadcrumbs: [Breadcrumb.benchmark_group, Breadcrumb.benchmark, Breadcrumb.HIDDEN, Breadcrumb.test],
        } satisfies BreadcrumbData,
      },
      {
        path: ':group_id/:benchmark_id/new-submission',
        component: NewSubmissionView,
        canActivate: [AuthGuard],
        data: {
          breadcrumbs: [Breadcrumb.benchmark_group, Breadcrumb.benchmark, 'New Submission'],
        } satisfies BreadcrumbData,
      },
    ],
  },
  // TODO: generalize/clean up
  // see: https://github.com/flatland-association/flatland-benchmarks/issues/323
  {
    path: 'fab-benchmarks/:id/participate/submissions/:submission',
    component: SubmissionView,
    canActivate: [AuthGuard],
  },
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
    data: { breadcrumbs: ['My Submissions'] } satisfies BreadcrumbData,
  },
  { path: 'impressum', component: ImpressumView },
  { path: 'privacy', component: PrivacyView },
  { path: '**', component: NotFoundView },
]
