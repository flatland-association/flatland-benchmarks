import { Routes } from '@angular/router'
import { ImpressumView, NotFoundView, PrivacyView } from '@flatland-association/flatland-ui'
import { Breadcrumb, BreadcrumbData } from './components/breadcrumbs/breadcrumbs.component'
import { AuthGuard } from './guards/auth.guard'
import { BenchmarkView } from './views/benchmark/benchmark.view'
import { HomeView } from './views/home/home.view'
import { MySubmissionsView } from './views/my-submissions/my-submissions.view'
import { SubmissionScenarioResultsView } from './views/submission-scenario-results/submission-scenario-results.view'
import { SubmissionView } from './views/submission/submission.view'
import { SuiteView } from './views/suite/suite.view'
import { TestView } from './views/test/test.view'

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
  {
    path: 'suites',
    data: { breadcrumbs: [Breadcrumb.HIDDEN] } satisfies BreadcrumbData,
    children: [
      { path: '', pathMatch: 'full', redirectTo: '/home' },
      {
        path: ':suite_id',
        component: SuiteView,
        data: { breadcrumbs: [Breadcrumb.suite] } satisfies BreadcrumbData,
      },
      {
        path: ':suite_id/:benchmark_id',
        component: BenchmarkView,
        data: { breadcrumbs: [Breadcrumb.suite, Breadcrumb.benchmark] } satisfies BreadcrumbData,
      },
      {
        path: ':suite_id/:benchmark_id/tests',
        pathMatch: 'full',
        redirectTo: ':suite_id/:benchmark_id',
      },
      {
        path: ':suite_id/:benchmark_id/tests/:test_id',
        component: TestView,
        data: {
          breadcrumbs: [Breadcrumb.suite, Breadcrumb.benchmark, Breadcrumb.HIDDEN, Breadcrumb.test],
        } satisfies BreadcrumbData,
      },
      {
        path: ':suite_id/:benchmark_id/submissions',
        pathMatch: 'full',
        redirectTo: ':suite_id/:benchmark_id',
      },
      {
        path: ':suite_id/:benchmark_id/submissions/:submission_id',
        component: SubmissionView,
        data: {
          breadcrumbs: [Breadcrumb.suite, Breadcrumb.benchmark, Breadcrumb.HIDDEN, Breadcrumb.submission],
        } satisfies BreadcrumbData,
      },
      {
        path: ':suite_id/:benchmark_id/submissions/:submission_id/:test_id',
        pathMatch: 'full',
        redirectTo: ':suite_id/:benchmark_id/submissions/:submission_id',
      },
      {
        path: ':suite_id/:benchmark_id/submissions/:submission_id/:test_id/:scenario_id',
        component: SubmissionScenarioResultsView,
        data: {
          breadcrumbs: [
            Breadcrumb.suite,
            Breadcrumb.benchmark,
            Breadcrumb.HIDDEN,
            Breadcrumb.submission,
            Breadcrumb.test,
            Breadcrumb.scenario,
          ],
        } satisfies BreadcrumbData,
      },
    ],
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
