import { Component, inject, Input, OnChanges, OnInit, SimpleChanges } from '@angular/core'
import { SuiteDefinitionRow } from '@common/interfaces'
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
  @Input() suite?: SuiteDefinitionRow

  private resourceService = inject(ResourceService)
  private customizationService = inject(CustomizationService)

  customization?: Customization

  columns: TableColumn[] = [
    { title: 'Evaluation objective', sortable: 'text', filterable: true },
    { title: 'KPIs', align: 'right', sortable: 'number' },
    { title: 'Score', align: 'right', sortable: 'score' },
  ]
  rows: TableRow[] = []

  ngOnInit(): void {
    this.customizationService.getCustomization().then((customization) => {
      this.customization = customization
    })
  }

  ngOnChanges(changes: SimpleChanges): void {
    if (changes['suite']) {
      this.buildBoard()
    }
  }

  async buildBoard() {
    if (this.suite) {
      const campaignOverview = (
        await this.resourceService.load('/results/campaigns/:suite_ids', {
          params: { suite_ids: this.suite.id },
        })
      )?.at(0)
      // pre-fetch all required benchmarks
      this.resourceService.loadGrouped('/definitions/benchmarks/:benchmark_ids', {
        params: { benchmark_ids: this.suite.benchmark_ids ?? [] },
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
            routerLink: ['/', 'suites', this.suite!.id, item.benchmark_id],
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
