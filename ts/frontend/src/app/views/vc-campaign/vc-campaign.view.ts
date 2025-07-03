import { Component, inject, OnInit } from '@angular/core'
import { FormsModule } from '@angular/forms'
import { ActivatedRoute, RouterModule } from '@angular/router'
import {
  BenchmarkDefinitionRow,
  BenchmarkGroupDefinitionRow,
  CampaignOverview,
  SubmissionRow,
  TestDefinitionRow,
} from '@common/interfaces'
import { ContentComponent, SectionComponent } from '@flatland-association/flatland-ui'
import { BreadcrumbsComponent } from '../../components/breadcrumbs/breadcrumbs.component'
import { SiteHeadingComponent } from '../../components/site-heading/site-heading.component'
import { TableColumn, TableComponent, TableRow } from '../../components/table/table.component'
import { ApiService } from '../../features/api/api.service'
import { Customization, CustomizationService } from '../../features/customization/customization.service'
import { PublicResourcePipe } from '../../pipes/public-resource/public-resource.pipe'

@Component({
  selector: 'view-vc-campaign',
  imports: [
    FormsModule,
    RouterModule,
    ContentComponent,
    SectionComponent,
    BreadcrumbsComponent,
    PublicResourcePipe,
    SiteHeadingComponent,
    TableComponent,
  ],
  templateUrl: './vc-campaign.view.html',
  styleUrl: './vc-campaign.view.scss',
})
export class VcCampaignView implements OnInit {
  apiService = inject(ApiService)
  customizationService = inject(CustomizationService)

  groupId: string
  group?: BenchmarkGroupDefinitionRow
  benchmarks?: Map<string, BenchmarkDefinitionRow>
  tests?: Map<string, TestDefinitionRow>
  submissions?: Map<string, SubmissionRow>
  campaignOverview?: CampaignOverview
  customization?: Customization

  columns: TableColumn[] = [
    { title: 'Evaluation objective' },
    { title: 'KPIs', align: 'right' },
    { title: 'Score', align: 'right' },
  ]
  rows: TableRow[] = []

  constructor() {
    const route = inject(ActivatedRoute)

    this.groupId = route.snapshot.params['group_id']
  }

  async ngOnInit() {
    this.customization = await this.customizationService.getCustomization()
    this.group = (
      await this.apiService.get('/definitions/benchmark-groups/:group_id', { params: { group_id: this.groupId } })
    ).body?.at(0)
    this.campaignOverview = (
      await this.apiService.get('/results/campaigns/:group_ids', { params: { group_ids: this.groupId } })
    ).body?.at(0)
    // load linked resources
    // TODO: unify, see https://github.com/flatland-association/flatland-benchmarks/issues/66
    const benchmarkIds = this.group?.benchmark_definition_ids?.join(',')
    if (benchmarkIds) {
      this.benchmarks = new Map(
        (
          await this.apiService.get('/definitions/benchmarks/:id', {
            params: { id: benchmarkIds },
          })
        ).body?.map((benchmark) => [benchmark.id, benchmark]),
      )
    }
    // build table rows from board
    this.rows =
      this.campaignOverview?.items.map((item) => {
        const benchmark = this.benchmarks?.get(item.benchmark_id)
        return {
          routerLink: ['/', 'vc-evaluation-objective', item.benchmark_id],
          cells: [
            { text: benchmark?.name ?? 'NA' },
            { text: benchmark?.test_definition_ids.length ?? 'NA' },
            { scorings: item.scorings },
          ],
        }
      }) ?? []
  }
}
