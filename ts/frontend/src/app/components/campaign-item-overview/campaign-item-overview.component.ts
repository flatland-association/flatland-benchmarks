import { Component, inject, Input, OnChanges, OnInit, SimpleChanges } from '@angular/core'
import { BenchmarkDefinitionRow, SuiteDefinitionRow } from '@common/interfaces'
import { Customization, CustomizationService } from '../../features/customization/customization.service'
import { ResourceService } from '../../features/resource/resource.service'
import { TableColumn, TableComponent, TableRow } from '../table/table.component'

@Component({
  selector: 'app-campaign-item-overview',
  imports: [TableComponent],
  templateUrl: './campaign-item-overview.component.html',
  styleUrl: './campaign-item-overview.component.scss',
})
export class CampaignItemOverviewComponent implements OnInit, OnChanges {
  @Input() suite?: SuiteDefinitionRow
  @Input() benchmark?: BenchmarkDefinitionRow

  private resourceService = inject(ResourceService)
  private customizationService = inject(CustomizationService)

  customization?: Customization

  columns: TableColumn[] = [{ title: 'KPI' }, { title: 'Score', align: 'right' }]
  rows: TableRow[] = []

  ngOnInit(): void {
    this.customizationService.getCustomization().then((customization) => {
      this.customization = customization
    })
  }

  ngOnChanges(changes: SimpleChanges): void {
    if (changes['suite'] || changes['benchmark']) {
      this.buildBoard()
    }
  }

  async buildBoard() {
    if (this.suite && this.benchmark) {
      const suite = this.suite
      const benchmark = this.benchmark
      const campaignItemOverview = (
        await this.resourceService.load('/results/campaign-items/:benchmark_ids', {
          params: { benchmark_ids: this.benchmark.id },
        })
      )?.at(0)
      // pre-fetch linked resources
      await Promise.all([
        this.resourceService
          .loadGrouped('/definitions/tests/:test_ids', {
            params: { test_ids: this.benchmark.test_ids ?? [] },
          })
          .then((tests) =>
            this.resourceService.loadGrouped('/definitions/fields/:field_ids', {
              params: { field_ids: tests?.flatMap((test) => test.field_ids) ?? [] },
            }),
          ),
      ])
      this.rows = await Promise.all(
        campaignItemOverview?.items.map(async (item) => {
          const test = (
            await this.resourceService.load('/definitions/tests/:test_ids', {
              params: { test_ids: item.test_id },
            })
          )?.at(0)
          const fields = await this.resourceService.loadOrdered('/definitions/fields/:field_ids', {
            params: { field_ids: test?.field_ids ?? [] },
          })
          return {
            routerLink: ['/', 'benchmarks', suite.id, benchmark.id, 'tests', item.test_id],
            cells: [{ text: test?.name ?? 'NA' }, { scorings: item.scorings, fieldDefinitions: fields }],
          }
        }) ?? [],
      )
    } else {
      this.rows = []
    }
  }
}
