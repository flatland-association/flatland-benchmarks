import { Component, inject, OnInit } from '@angular/core'
import { ActivatedRoute, RouterModule } from '@angular/router'
import { BenchmarkDefinitionRow, SubmissionRow, TestDefinitionRow } from '@common/interfaces'
import { ElementType } from '@common/utility-types'
import { ContentComponent, SectionComponent } from '@flatland-association/flatland-ui'
import { BreadcrumbsComponent } from '../../components/breadcrumbs/breadcrumbs.component'
import { TableColumn, TableComponent, TableRow } from '../../components/table/table.component'
import { ApiService } from '../../features/api/api.service'

@Component({
  selector: 'view-vc-kpi',
  imports: [RouterModule, ContentComponent, SectionComponent, BreadcrumbsComponent, TableComponent],
  templateUrl: './vc-kpi.view.html',
  styleUrl: './vc-kpi.view.scss',
})
export class VcKpiView implements OnInit {
  apiService = inject(ApiService)

  benchmarkId: string
  testId: string

  benchmark?: BenchmarkDefinitionRow
  test?: TestDefinitionRow
  submissions?: Map<string, SubmissionRow>

  columns: TableColumn[] = [{ title: 'Rank' }, { title: 'Submission' }, { title: 'Score', align: 'right' }]
  rows: TableRow[] = []

  constructor() {
    const route = inject(ActivatedRoute)

    this.benchmarkId = route.snapshot.params['benchmark_id']
    this.testId = route.snapshot.params['test_id']
  }

  async ngOnInit() {
    const board = (
      await this.apiService.get('/results/benchmarks/:benchmark_id/tests/:test_id', {
        params: { benchmark_id: this.benchmarkId, test_id: this.testId },
      })
    ).body?.at(0)
    // load linked resources
    // TODO: offload this to service with caching
    this.benchmark = (await this.apiService.get('/benchmarks/:id', { params: { id: this.benchmarkId } })).body?.at(0)
    this.test = (await this.apiService.get('/tests/:id', { params: { id: this.testId } })).body?.at(0)
    const subIds = board?.items.map((item) => item.submission_id).join(',')
    if (subIds) {
      this.submissions = new Map(
        (
          await this.apiService.get('/submissions/:uuid', {
            params: { uuid: subIds },
          })
        ).body?.map((submission) => [submission.id, submission]),
      )
    }
    // build table rows from board
    this.rows =
      board?.items.map((item) => {
        const testScoring = item.test_scorings[0].scorings
        return {
          // routerLink: item.test_id,
          cells: [
            { text: testScoring?.['primary']?.rank ?? '-' },
            { text: this.submissions!.get(item.submission_id)?.name ?? 'NA' },
            { scorings: testScoring },
          ],
        } satisfies ElementType<typeof this.rows>
      }) ?? []
  }
}
