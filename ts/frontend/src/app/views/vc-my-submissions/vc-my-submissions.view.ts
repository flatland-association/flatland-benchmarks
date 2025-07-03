import { Component, inject, OnInit } from '@angular/core'
import { FormsModule } from '@angular/forms'
import { ActivatedRoute } from '@angular/router'
import { BenchmarkDefinitionRow, SubmissionRow, TestDefinitionRow } from '@common/interfaces'
import { ContentComponent } from '@flatland-association/flatland-ui'
import { BreadcrumbsComponent } from '../../components/breadcrumbs/breadcrumbs.component'
import { SiteHeadingComponent } from '../../components/site-heading/site-heading.component'
import { TableColumn, TableComponent, TableRow } from '../../components/table/table.component'
import { ApiService } from '../../features/api/api.service'
import { AuthService } from '../../features/auth/auth.service'
import { Customization, CustomizationService } from '../../features/customization/customization.service'
import { PublicResourcePipe } from '../../pipes/public-resource/public-resource.pipe'

@Component({
  selector: 'view-vc-my-submissions',
  imports: [
    FormsModule,
    ContentComponent,
    BreadcrumbsComponent,
    PublicResourcePipe,
    SiteHeadingComponent,
    TableComponent,
  ],
  templateUrl: './vc-my-submissions.view.html',
  styleUrl: './vc-my-submissions.view.scss',
})
export class VcMySubmissionsView implements OnInit {
  apiService = inject(ApiService)
  authService = inject(AuthService)
  customizationService = inject(CustomizationService)

  benchmarkId: string

  benchmark?: BenchmarkDefinitionRow
  submissions?: SubmissionRow[]
  tests?: Map<string, TestDefinitionRow>
  customization?: Customization

  columns: TableColumn[] = [{ title: 'Name' }, { title: 'KPI' }, { title: 'Started' }]
  rows: TableRow[] = []

  constructor() {
    const route = inject(ActivatedRoute)

    this.benchmarkId = route.snapshot.params['benchmark_id']
  }

  async ngOnInit() {
    this.customization = await this.customizationService.getCustomization()
    const myUuid = this.authService.userUuid
    this.submissions = (
      await this.apiService.get('/submissions', {
        query: { benchmark: this.benchmarkId, submitted_by: myUuid },
      })
    ).body
    // load linked resources
    // TODO: offload this to service with caching
    this.benchmark = (
      await this.apiService.get('/definitions/benchmarks/:benchmark_ids', {
        params: { benchmark_ids: this.benchmarkId },
      })
    ).body?.at(0)
    // gather unique test ids, load, transform to map (uuid: test)
    const testIds = Array.from(new Set(this.submissions?.map((submission) => submission.test_ids[0])))
    const tests = (
      await this.apiService.get('/definitions/tests/:test_ids', { params: { test_ids: testIds.join(',') } })
    ).body
    this.tests = new Map(tests?.map((test) => [test.id, test]))
    // build table rows from board
    this.rows =
      this.submissions?.map((submission) => {
        return {
          // TODO: submission detail view
          // routerLink: item.test_id,
          cells: [
            { text: submission.name },
            { text: this.tests?.get(submission.test_ids[0])?.name ?? 'NA' },
            { text: submission.submitted_at ?? '' },
          ],
        }
      }) ?? []
  }
}
