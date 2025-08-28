import { Component, inject, Input, OnChanges, OnInit, SimpleChanges } from '@angular/core'
import { BenchmarkGroupDefinitionRow } from '@common/interfaces'
import { ContentComponent } from '@flatland-association/flatland-ui'
import { ApiService } from '../../features/api/api.service'
import { Customization, CustomizationService } from '../../features/customization/customization.service'
import { ResourceService } from '../../features/resource/resource.service'
import { TableColumn, TableComponent, TableRow } from '../table/table.component'

@Component({
  selector: 'app-campaign-overview',
  imports: [ContentComponent, TableComponent],
  templateUrl: './campaign-overview.component.html',
  styleUrl: './campaign-overview.component.scss',
})
export class CampaignOverviewComponent implements OnInit, OnChanges {
  @Input() group?: BenchmarkGroupDefinitionRow

  resourceService = inject(ResourceService)
  apiService = inject(ApiService)
  customizationService = inject(CustomizationService)

  customization?: Customization

  columns: TableColumn[] = [
    { title: 'Evaluation objective' },
    { title: 'KPIs', align: 'right' },
    { title: 'Score', align: 'right' },
  ]
  rows: TableRow[] = []

  ngOnInit(): void {
    this.customizationService.getCustomization().then((customization) => {
      this.customization = customization
    })
  }

  ngOnChanges(changes: SimpleChanges): void {
    if (changes['group']) {
      this.buildBoard()
    }
  }

  async buildBoard() {
    if (this.group) {
      // TODO: load via resource service as well
      // see: https://github.com/flatland-association/flatland-benchmarks/issues/395
      const campaignOverview = (
        await this.apiService.get('/results/campaigns/:group_ids', { params: { group_ids: this.group.id } })
      ).body?.at(0)
      this.rows = await Promise.all(
        campaignOverview?.items.map(async (item) => {
          const benchmark = await this.resourceService.load('/definitions/benchmarks/', item.benchmark_id)
          const fields = await this.resourceService.loadMultiOrdered('/definitions/fields/', benchmark.field_ids)
          return {
            // TODO: route to generalized page
            // see: https://github.com/flatland-association/flatland-benchmarks/issues/323
            routerLink: ['/', 'vc-evaluation-objective', item.benchmark_id],
            cells: [
              { text: benchmark?.name ?? 'NA' },
              { text: benchmark?.test_ids.length ?? 'NA' },
              { scorings: item.scorings, fieldDefinitions: fields },
            ],
          }
        }) ?? [],
      )
    } else {
      this.rows = []
    }
  }
}
