import { Component, inject, OnInit } from '@angular/core'
import { FormsModule } from '@angular/forms'
import { ActivatedRoute, RouterModule } from '@angular/router'
import {
  BenchmarkDefinitionRow,
  BenchmarkGroupDefinitionRow,
  CampaignItem,
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
  campaignBoard?: CampaignItem
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
    this.group = (await this.apiService.get('/benchmark-groups/:id', { params: { id: this.groupId } })).body?.at(0)
    // TODO: board
    // load linked resources
    // TODO: unify, see https://github.com/flatland-association/flatland-benchmarks/issues/66
    const benchmarkIds = this.group?.benchmark_definition_ids?.join(',')
    if (benchmarkIds) {
      this.benchmarks = new Map(
        (
          await this.apiService.get('/benchmarks/:id', {
            params: { id: benchmarkIds },
          })
        ).body?.map((benchmark) => [benchmark.id, benchmark]),
      )
    }
    // build table rows from objectives (TODO: from board)
    this.rows =
      this.group?.benchmark_definition_ids.map((benchmarkId) => {
        const benchmark = this.benchmarks?.get(benchmarkId)
        return {
          routerLink: ['/', 'vc-evaluation-objective', benchmarkId],
          cells: [
            { text: benchmark?.name ?? 'NA' },
            { text: benchmark?.test_definition_ids.length ?? 'NA' },
            { text: 'NA' },
          ],
        }
      }) ?? []
  }
}
