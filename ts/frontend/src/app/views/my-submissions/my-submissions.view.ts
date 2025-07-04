import { Component, inject, OnInit } from '@angular/core'
import { RouterModule } from '@angular/router'
import { BenchmarkDefinitionRow, SubmissionRow, TestDefinitionRow } from '@common/interfaces'
import { ContentComponent, SectionComponent } from '@flatland-association/flatland-ui'
import { BreadcrumbsComponent } from '../../components/breadcrumbs/breadcrumbs.component'
import { SiteHeadingComponent } from '../../components/site-heading/site-heading.component'
import { TableColumn, TableComponent, TableRow } from '../../components/table/table.component'
import { ApiService } from '../../features/api/api.service'
import { AuthService } from '../../features/auth/auth.service'
import { Customization, CustomizationService } from '../../features/customization/customization.service'
import { PublicResourcePipe } from '../../pipes/public-resource/public-resource.pipe'

@Component({
  selector: 'view-my-submissions',
  imports: [
    RouterModule,
    ContentComponent,
    SectionComponent,
    BreadcrumbsComponent,
    PublicResourcePipe,
    SiteHeadingComponent,
    TableComponent,
  ],
  templateUrl: './my-submissions.view.html',
  styleUrl: './my-submissions.view.scss',
})
export class MySubmissionsView implements OnInit {
  apiService = inject(ApiService)
  authService = inject(AuthService)
  customizationService = inject(CustomizationService)

  submissions?: SubmissionRow[]
  benchmarks?: Map<string, BenchmarkDefinitionRow>
  tests?: Map<string, TestDefinitionRow>
  customization?: Customization

  columns: TableColumn[] = [{ title: 'Submission' }, { title: 'Objective' }, { title: 'KPI' }]
  rows: TableRow[] = []

  async ngOnInit() {
    this.customization = await this.customizationService.getCustomization()
    // load all my submissions
    this.submissions = (
      await this.apiService.get('/submissions', { query: { submitted_by: this.authService.userUuid } })
    ).body
    // load linked resources
    // TODO: offload this to service with caching
    const benchmarkIds = Array.from(new Set(this.submissions?.map((submission) => submission.benchmark_id)))
    if (benchmarkIds) {
      const benchmarks = (
        await this.apiService.get('/definitions/benchmarks/:benchmark_ids', {
          params: { benchmark_ids: benchmarkIds.join(',') },
        })
      ).body
      this.benchmarks = new Map(benchmarks?.map((benchmark) => [benchmark.id, benchmark]))
    }
    const testIds = Array.from(new Set(this.submissions?.flatMap((submission) => submission.test_ids)))
    if (testIds) {
      const tests = (
        await this.apiService.get('/definitions/tests/:test_ids', { params: { test_ids: testIds.join(',') } })
      ).body
      this.tests = new Map(tests?.map((test) => [test.id, test]))
    }
    // build table
    this.rows =
      this.submissions?.map((submission) => {
        return {
          routerLink: ['/', 'vc-evaluation-objective', submission.test_ids[0], 'my-submissions'],
          cells: [
            { text: submission.name },
            { text: this.benchmarks?.get(submission.benchmark_id)?.name ?? 'NA' },
            { text: this.tests?.get(submission.test_ids[0])?.name ?? 'NA' },
          ],
        }
      }) ?? []
  }
}
