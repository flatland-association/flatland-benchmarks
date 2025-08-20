import { Component, inject, OnInit } from '@angular/core'
import { ActivatedRoute, RouterModule } from '@angular/router'
import { BenchmarkDefinitionRow, FieldDefinitionRow, SubmissionRow, TestDefinitionRow } from '@common/interfaces'
import { ElementType } from '@common/utility-types'
import { ContentComponent, SectionComponent } from '@flatland-association/flatland-ui'
import { BreadcrumbsComponent } from '../../components/breadcrumbs/breadcrumbs.component'
import { SiteHeadingComponent } from '../../components/site-heading/site-heading.component'
import { TableColumn, TableComponent, TableRow } from '../../components/table/table.component'
import { ApiService } from '../../features/api/api.service'
import { Customization, CustomizationService } from '../../features/customization/customization.service'
import { PublicResourcePipe } from '../../pipes/public-resource/public-resource.pipe'

@Component({
  selector: 'view-vc-kpi',
  imports: [
    RouterModule,
    ContentComponent,
    SectionComponent,
    BreadcrumbsComponent,
    PublicResourcePipe,
    SiteHeadingComponent,
    TableComponent,
  ],
  templateUrl: './vc-kpi.view.html',
  styleUrl: './vc-kpi.view.scss',
})
export class VcKpiView implements OnInit {
  apiService = inject(ApiService)
  customizationService = inject(CustomizationService)

  benchmarkId: string
  testId: string

  benchmark?: BenchmarkDefinitionRow
  test?: TestDefinitionRow
  fields?: FieldDefinitionRow[]
  submissions?: Map<string, SubmissionRow>
  customization?: Customization

  columns: TableColumn[] = [{ title: 'Rank' }, { title: 'Submission' }, { title: 'Score', align: 'right' }]
  rows: TableRow[] = []

  constructor() {
    const route = inject(ActivatedRoute)

    this.benchmarkId = route.snapshot.params['benchmark_id']
    this.testId = route.snapshot.params['test_id']
  }

  async ngOnInit() {
    this.customization = await this.customizationService.getCustomization()
    const board = (
      await this.apiService.get('/results/benchmarks/:benchmark_id/tests/:test_ids', {
        params: { benchmark_id: this.benchmarkId, test_ids: this.testId },
      })
    ).body?.at(0)
    // load linked resources
    // TODO: offload this to service with caching
    this.benchmark = (
      await this.apiService.get('/definitions/benchmarks/:benchmark_ids', {
        params: { benchmark_ids: this.benchmarkId },
      })
    ).body?.at(0)
    this.test = (
      await this.apiService.get('/definitions/tests/:test_ids', { params: { test_ids: this.testId } })
    ).body?.at(0)
    const subIds = board?.items.map((item) => item.submission_id).join(',')
    if (subIds) {
      this.submissions = new Map(
        (
          await this.apiService.get('/submissions/:submission_ids', {
            params: { submission_ids: subIds },
          })
        ).body?.map((submission) => [submission.id, submission]),
      )
    }
    // only one test, means only one relevant source of field_ids
    const fieldIds = this.test?.field_ids
    if (fieldIds) {
      this.fields = (
        await this.apiService.get('/definitions/fields/:field_ids', {
          params: { field_ids: fieldIds.join(',') },
        })
      ).body
    }
    // build table rows from board
    this.rows =
      board?.items.map((item) => {
        const testScoring = item.test_scorings[0].scorings
        return {
          routerLink: ['/', 'submissions', item.submission_id],
          cells: [
            { text: testScoring?.[this.fields?.at(0)?.key ?? 'primary']?.rank ?? '-' },
            { text: this.submissions!.get(item.submission_id)?.name ?? 'NA' },
            { scorings: testScoring, fieldDefinitions: this.fields },
          ],
        } satisfies ElementType<typeof this.rows>
      }) ?? []
  }
}
