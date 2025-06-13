import { Component, inject, OnInit } from '@angular/core'
import { ActivatedRoute, RouterModule } from '@angular/router'
import { BenchmarkDefinitionRow, SubmissionRow, TestDefinitionRow } from '@common/interfaces'
import { ElementType } from '@common/utility-types'
import { ContentComponent, SectionComponent } from '@flatland-association/flatland-ui'
import { BreadcrumbsComponent } from '../../components/breadcrumbs/breadcrumbs.component'
import { TableColumn, TableComponent, TableRow } from '../../components/table/table.component'
import { ApiService } from '../../features/api/api.service'

// const leArray = [
//   { title: '' },
//   { title: '', type: 'scoring-plain' },
//   { title: '', type: 'text' },
// ] as const satisfies TableColumn[] //{0: 'text', 1: 'number', 2: 'text'}

// type RowItemType<C extends readonly TableColumn[]> = {
//   -readonly [i in keyof C]: C[i]['type'] extends 'text'
//     ? string
//     : C[i]['type'] extends 'scoring-plain'
//       ? Scoring
//       : unknown
// }

// interface leRows<C extends readonly TableColumn[]> {
//   items: RowItemType<C>
// }

// const a: Prettify<leRows<typeof leArray>> = {}

// const columns = [
//   { title: 'Rank', type: 'text' },
//   { title: 'Submission', type: 'text' },
//   { title: 'Score', align: 'right', type: 'scoring-plain' },
// ] as const satisfies TableColumn[]

// let rows: TableRow<typeof columns>[] = []

// type ColumnTypes = TableRowItems<typeof columns>

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
      await this.apiService.get('/results/campaign-item/:benchmark_id/tests/:test_id', {
        params: { benchmark_id: this.benchmarkId, test_id: this.testId },
      })
    ).body?.at(0)
    console.log(board)
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
