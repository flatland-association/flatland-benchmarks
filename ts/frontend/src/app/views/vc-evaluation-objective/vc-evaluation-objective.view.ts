import { Component, inject, OnInit } from '@angular/core'
import { FormsModule } from '@angular/forms'
import { ActivatedRoute, RouterModule } from '@angular/router'
import { BenchmarkDefinitionRow, CampaignItem, SubmissionRow, TestDefinitionRow } from '@common/interfaces'
import { ContentComponent, SectionComponent } from '@flatland-association/flatland-ui'
import { BreadcrumbsComponent } from '../../components/breadcrumbs/breadcrumbs.component'
import { TableColumn, TableComponent, TableRow } from '../../components/table/table.component'
import { ApiService } from '../../features/api/api.service'

@Component({
  selector: 'view-vc-evaluation-objective',
  imports: [FormsModule, RouterModule, ContentComponent, SectionComponent, BreadcrumbsComponent, TableComponent],
  templateUrl: './vc-evaluation-objective.view.html',
  styleUrl: './vc-evaluation-objective.view.scss',
})
export class VcEvaluationObjectiveView implements OnInit {
  apiService = inject(ApiService)

  benchmarkId: string
  benchmark?: BenchmarkDefinitionRow
  tests?: Map<string, TestDefinitionRow>
  submissions?: Map<string, SubmissionRow>
  campaignItemBoard?: CampaignItem

  columns: TableColumn[] = [{ title: 'KPI' }, { title: 'Score', align: 'right' }]
  rows: TableRow[] = []

  constructor() {
    const route = inject(ActivatedRoute)

    this.benchmarkId = route.snapshot.params['benchmark_id']
  }

  async ngOnInit() {
    this.benchmark = (await this.apiService.get('/benchmarks/:id', { params: { id: this.benchmarkId } })).body?.at(0)
    this.campaignItemBoard = (
      await this.apiService.get('/results/campaign-item/:benchmark_id', {
        params: { benchmark_id: this.benchmarkId },
      })
    ).body?.at(0)
    // load linked resources
    // TODO: offload this to service with caching
    const testIds = this.campaignItemBoard?.items.map((item) => item.test_id).join(',')
    if (testIds) {
      this.tests = new Map(
        (
          await this.apiService.get('/tests/:id', {
            params: { id: testIds },
          })
        ).body?.map((test) => [test.id, test]),
      )
    }
    const subIds = this.campaignItemBoard?.items.map((item) => item.submission_id).join(',')
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
      this.campaignItemBoard?.items.map((item) => {
        return {
          routerLink: item.test_id,
          cells: [{ text: this.tests?.get(item.test_id)?.name ?? 'NA' }, { scorings: item.scorings }],
        }
      }) ?? []
  }
}
