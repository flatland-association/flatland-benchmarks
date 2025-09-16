import { Component, inject, Input, OnChanges, OnInit, SimpleChanges } from '@angular/core'
import { BenchmarkGroupDefinitionRow } from '@common/interfaces'
import { Customization, CustomizationService } from '../../features/customization/customization.service'
import { ResourceService } from '../../features/resource/resource.service'
import { TableColumn, TableComponent, TableRow } from '../table/table.component'

@Component({
  selector: 'app-campaign-overview',
  imports: [TableComponent],
  templateUrl: './campaign-overview.component.html',
  styleUrl: './campaign-overview.component.scss',
})
export class CampaignOverviewComponent implements OnInit, OnChanges {
  @Input() group?: BenchmarkGroupDefinitionRow

  private resourceService = inject(ResourceService)
  private customizationService = inject(CustomizationService)

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
      const campaignOverview = (
        await this.resourceService.load('/results/campaigns/:group_ids', {
          params: { group_ids: this.group.id },
        })
      )?.at(0)
      // pre-fetch all required benchmarks
      this.resourceService.loadGrouped('/definitions/benchmarks/:benchmark_ids', {
        params: { benchmark_ids: this.group.benchmark_ids ?? [] },
      })
      this.rows = await Promise.all(
        campaignOverview?.items.map(async (item) => {
          const benchmark = (
            await this.resourceService.load('/definitions/benchmarks/:benchmark_ids', {
              params: { benchmark_ids: item.benchmark_id },
            })
          )?.at(0)
          const fields = await this.resourceService.loadOrdered('/definitions/fields/:field_ids', {
            params: { field_ids: benchmark?.campaign_field_ids ?? [] },
          })
          return {
            routerLink: ['/', 'benchmarks', this.group!.id, item.benchmark_id],
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
